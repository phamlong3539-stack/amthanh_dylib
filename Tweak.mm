#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
#import <MediaPlayer/MediaPlayer.h>
#include <dlfcn.h>
#include <sys/sysctl.h>

// Chống Debugging / Anti-Crack cơ bản
typedef int (*ptrace_ptr)(int _request, pid_t _pid, caddr_t _addr, int _data);
static void preventDebugging() {
    void *handle = dlopen(NULL, RTLD_GLOBAL | RTLD_NOW);
    if (handle) {
        ptrace_ptr ptrace_p = (ptrace_ptr)dlsym(handle, "ptrace");
        if (ptrace_p) {
            ptrace_p(31 /* PT_DENY_ATTACH */, 0, 0, 0);
        }
        dlclose(handle);
    }
}

static NSString *const kPHLPrefRepeatOne = @"PHL_RepeatOneSong";
static NSString *const kPHLPrefVolume = @"PHL_PlayerVolume";
static NSString *const kPHLAdminInfoURL = @"https://phamlong09.store";
static NSString *const kPHLYouTubeHomeURL = @"https://m.youtube.com";

@interface PHLProtectedAudioManager : NSObject <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, WKNavigationDelegate> {
    AVPlayer *phlAudioPlayer;
    AVPlayerItem *phlPlayerItem;
    MPVolumeView *phlSystemVolumeView;
    UISlider *phlSystemVolumeSlider;

    UIButton *phlFloatingBtn;
    UIView *phlMenuContainer;
    UIView *phlDragHeader;
    UITableView *phlTableView;

    // Trình duyệt web nhúng & tìm kiếm YouTube trong menu
    UIButton *phlOpenBrowserBtn;
    UIView *phlWebPanel;
    UITextField *phlYouTubeSearchField;
    WKWebView *phlWebView;
    BOOL phlIsWebOpen;
    BOOL phlHasLoadedInitialWeb;

    // Khu vực điều khiển trình phát
    UILabel *phlNowPlayingLabel;
    UIButton *phlPlayPauseBtn;
    UIButton *phlRepeatBtn;
    UIButton *phlAdminInfoBtn;
    UILabel *phlCopyrightLabel;
    UISlider *phlVolumeSlider;

    NSMutableArray *phlPlaylist;
    NSString *phlStatusMessage;
    NSInteger phlCurrentIndex;
    BOOL phlIsMenuOpen;
    BOOL phlRepeatOne;
    float phlCurrentVolume;
}
+ (instancetype)sharedInstance;
- (void)initializeFramework;
@end

@implementation PHLProtectedAudioManager

+ (instancetype)sharedInstance {
    static PHLProtectedAudioManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PHLProtectedAudioManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        phlPlaylist = [[NSMutableArray alloc] init];
        phlStatusMessage = @"Đang tải danh sách nhạc...";
        phlCurrentIndex = -1;
        phlIsMenuOpen = NO;
        phlIsWebOpen = NO;
        phlHasLoadedInitialWeb = NO;

        if ([defaults objectForKey:kPHLPrefRepeatOne] != nil) {
            phlRepeatOne = [defaults boolForKey:kPHLPrefRepeatOne];
        } else {
            phlRepeatOne = NO;
        }

        if ([defaults objectForKey:kPHLPrefVolume] != nil) {
            phlCurrentVolume = [defaults floatForKey:kPHLPrefVolume];
        } else {
            phlCurrentVolume = 0.85f;
        }

        [self configureAudioSession];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleItemDidFinish:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];
    }
    return self;
}

- (void)handleItemDidFinish:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (phlRepeatOne && phlCurrentIndex >= 0 && phlCurrentIndex < (NSInteger)phlPlaylist.count) {
            [self playSongAtIndex:phlCurrentIndex];
        } else if (phlPlaylist.count > 0) {
            NSInteger nextIdx = (phlCurrentIndex + 1) % (NSInteger)phlPlaylist.count;
            [self playSongAtIndex:nextIdx];
        }
    });
}

- (void)configureAudioSession {
    NSError *sessionError = nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback
             withOptions:AVAudioSessionCategoryOptionMixWithOthers
                   error:&sessionError];
    [session setActive:YES error:&sessionError];
}

- (void)bindSystemVolumeSlider {
    if (phlSystemVolumeSlider) return;
    phlSystemVolumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-1000, -1000, 10, 10)];
    phlSystemVolumeView.hidden = YES;
    for (UIView *sub in phlSystemVolumeView.subviews) {
        if ([sub isKindOfClass:[UISlider class]]) {
            phlSystemVolumeSlider = (UISlider *)sub;
            break;
        }
    }
}

- (void)applyUnifiedVolume:(float)vol {
    float clamped = MAX(0.0f, MIN(1.0f, vol));
    phlCurrentVolume = clamped;
    [[NSUserDefaults standardUserDefaults] setFloat:clamped forKey:kPHLPrefVolume];

    // 1. Âm lượng nhạc GitHub (AVPlayer)
    if (phlAudioPlayer) {
        phlAudioPlayer.volume = clamped;
    }

    // 2. Âm lượng trình duyệt web (WKWebView <video>/<audio>)
    if (phlWebView) {
        NSString *js = [NSString stringWithFormat:
                        @"(function(){var v=%.3f;var m=(v<=0.001);document.querySelectorAll('video,audio').forEach(function(el){try{el.muted=m;el.volume=v;}catch(e){}});})();",
                        clamped];
        [phlWebView evaluateJavaScript:js completionHandler:nil];
    }

    // 3. Đồng bộ thanh âm lượng hệ thống nếu tìm thấy
    [self bindSystemVolumeSlider];
    if (phlSystemVolumeSlider) {
        phlSystemVolumeSlider.value = clamped;
        [phlSystemVolumeSlider sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (UIWindow *)resolveActiveWindow {
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *window in scene.windows) {
                if (window.isKeyWindow) {
                    return window;
                }
            }
            if (scene.windows.firstObject) {
                return scene.windows.firstObject;
            }
        }
    }
    return [UIApplication sharedApplication].windows.firstObject;
}

- (UIButton *)makeControlButtonWithTitle:(NSString *)title
                               fontSize:(CGFloat)fontSize
                                bgColor:(UIColor *)bgColor
                            borderColor:(UIColor *)borderColor
                                 action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightBold];
    btn.backgroundColor = bgColor;
    btn.layer.cornerRadius = 8;
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = borderColor.CGColor;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)initializeFramework {
    preventDebugging();

    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [self resolveActiveWindow];
        if (!keyWindow) return;

        CGFloat screenW = keyWindow.bounds.size.width;
        CGFloat menuW = MIN(312.0f, screenW - 92.0f);
        if (menuW < 268.0f) menuW = MIN(300.0f, screenW - 20.0f);
        // Thu gọn chiều cao để chân bản quyền hiển thị trọn vẹn và cân đối
        CGFloat menuH = 356.0f;

        if (!phlFloatingBtn) {
            // 1. Nút nổi tròn bo tím Neon
            phlFloatingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            phlFloatingBtn.frame = CGRectMake(16, 118, 48, 48);
            phlFloatingBtn.layer.cornerRadius = 24;
            phlFloatingBtn.clipsToBounds = YES;
            phlFloatingBtn.layer.borderWidth = 2.0;
            phlFloatingBtn.layer.borderColor = [UIColor colorWithRed:0.78 green:0.38 blue:1.0 alpha:1.0].CGColor;
            phlFloatingBtn.backgroundColor = [UIColor colorWithRed:0.05 green:0.02 blue:0.13 alpha:0.96];
            [phlFloatingBtn setTitle:@"👑" forState:UIControlStateNormal];
            [phlFloatingBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];

            UIPanGestureRecognizer *btnPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleFloatingPan:)];
            [phlFloatingBtn addGestureRecognizer:btnPan];
            [keyWindow addSubview:phlFloatingBtn];

            [self loadRemoteLogo];
        } else if (phlFloatingBtn.superview != keyWindow) {
            [keyWindow addSubview:phlFloatingBtn];
        }

        if (!phlMenuContainer) {
            // 2. Khung menu chính gọn gàng (chỉ kéo qua thanh tiêu đề trên cùng)
            phlMenuContainer = [[UIView alloc] initWithFrame:CGRectMake(70, 28, menuW, menuH)];
            phlMenuContainer.backgroundColor = [UIColor colorWithRed:0.045 green:0.022 blue:0.125 alpha:0.98];
            phlMenuContainer.layer.cornerRadius = 15;
            phlMenuContainer.layer.borderWidth = 1.5;
            phlMenuContainer.layer.borderColor = [UIColor colorWithRed:0.82 green:0.42 blue:1.0 alpha:0.95].CGColor;
            phlMenuContainer.clipsToBounds = YES;
            phlMenuContainer.hidden = YES;
            phlMenuContainer.alpha = 0.0;

            // Thanh tiêu đề dùng làm tay nắm kéo di chuyển toàn menu
            phlDragHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuW, 46)];
            phlDragHeader.backgroundColor = [UIColor colorWithRed:0.11 green:0.05 blue:0.23 alpha:0.95];
            [phlMenuContainer addSubview:phlDragHeader];

            UIPanGestureRecognizer *headerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMenuHeaderPan:)];
            [phlDragHeader addGestureRecognizer:headerPan];

            UILabel *dragGripLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, menuW - 48, 10)];
            dragGripLabel.text = @"⋮⋮ KÉO THANH NÀY ĐỂ DI CHUYỂN";
            dragGripLabel.textColor = [UIColor colorWithRed:0.72 green:0.55 blue:0.98 alpha:0.85];
            dragGripLabel.font = [UIFont systemFontOfSize:7.5 weight:UIFontWeightBold];
            [phlDragHeader addSubview:dragGripLabel];

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, menuW - 48, 16)];
            titleLabel.text = @"👑 PHL PHAM LONG • AUDIO";
            titleLabel.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:1.0 alpha:1.0];
            titleLabel.font = [UIFont systemFontOfSize:11.5 weight:UIFontWeightHeavy];
            [phlDragHeader addSubview:titleLabel];

            phlNowPlayingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, menuW - 20, 14)];
            phlNowPlayingLabel.text = @"♪ Chưa chọn bài hát";
            phlNowPlayingLabel.textColor = [UIColor colorWithRed:0.35 green:0.95 blue:1.0 alpha:1.0];
            phlNowPlayingLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightSemibold];
            [phlDragHeader addSubview:phlNowPlayingLabel];

            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            closeBtn.frame = CGRectMake(menuW - 34, 9, 24, 24);
            [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
            [closeBtn setTitleColor:[UIColor colorWithRed:1.0 green:0.55 blue:0.72 alpha:1.0] forState:UIControlStateNormal];
            closeBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
            closeBtn.backgroundColor = [UIColor colorWithRed:0.22 green:0.06 blue:0.18 alpha:0.85];
            closeBtn.layer.cornerRadius = 12;
            [closeBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:closeBtn];

            // Cụm điều khiển chính: Prev | Play/Pause | Next | Lặp
            CGFloat padX = 10.0f;
            CGFloat innerW = menuW - padX * 2.0f;
            CGFloat gap = 5.0f;
            CGFloat btnW = (innerW - gap * 3.0f) / 4.0f;
            CGFloat ctrlY = 51.0f;

            UIColor *ctrlBg = [UIColor colorWithRed:0.15 green:0.08 blue:0.29 alpha:0.95];
            UIColor *ctrlBorder = [UIColor colorWithRed:0.68 green:0.36 blue:1.0 alpha:0.7];

            UIButton *prevBtn = [self makeControlButtonWithTitle:@"⏮"
                                                      fontSize:13
                                                       bgColor:ctrlBg
                                                   borderColor:ctrlBorder
                                                        action:@selector(playPreviousSong)];
            prevBtn.frame = CGRectMake(padX, ctrlY, btnW, 26);
            [phlMenuContainer addSubview:prevBtn];

            phlPlayPauseBtn = [self makeControlButtonWithTitle:@"▶"
                                                    fontSize:14
                                                     bgColor:[UIColor colorWithRed:0.48 green:0.18 blue:0.86 alpha:0.96]
                                                 borderColor:[UIColor colorWithRed:0.9 green:0.62 blue:1.0 alpha:0.95]
                                                      action:@selector(togglePlayPause)];
            phlPlayPauseBtn.frame = CGRectMake(padX + (btnW + gap), ctrlY, btnW, 26);
            [phlMenuContainer addSubview:phlPlayPauseBtn];

            UIButton *nextBtn = [self makeControlButtonWithTitle:@"⏭"
                                                      fontSize:13
                                                       bgColor:ctrlBg
                                                   borderColor:ctrlBorder
                                                        action:@selector(playNextSong)];
            nextBtn.frame = CGRectMake(padX + (btnW + gap) * 2.0f, ctrlY, btnW, 26);
            [phlMenuContainer addSubview:nextBtn];

            phlRepeatBtn = [self makeControlButtonWithTitle:@"🔁"
                                                 fontSize:13
                                                  bgColor:ctrlBg
                                              borderColor:ctrlBorder
                                                   action:@selector(toggleRepeatMode)];
            phlRepeatBtn.frame = CGRectMake(padX + (btnW + gap) * 3.0f, ctrlY, btnW, 26);
            [self syncRepeatButton];
            [phlMenuContainer addSubview:phlRepeatBtn];

            // Thanh âm lượng chung cho cả nhạc GitHub và trình duyệt web
            CGFloat volY = 81.0f;
            UIButton *muteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            muteBtn.frame = CGRectMake(padX, volY, 28, 22);
            [muteBtn setTitle:@"🔉" forState:UIControlStateNormal];
            muteBtn.titleLabel.font = [UIFont systemFontOfSize:12.5];
            [muteBtn addTarget:self action:@selector(decreaseVolumeStep) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:muteBtn];

            phlVolumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(padX + 30, volY, innerW - 60, 22)];
            phlVolumeSlider.minimumValue = 0.0f;
            phlVolumeSlider.maximumValue = 1.0f;
            phlVolumeSlider.value = phlCurrentVolume;
            phlVolumeSlider.minimumTrackTintColor = [UIColor colorWithRed:0.35 green:0.92 blue:1.0 alpha:1.0];
            phlVolumeSlider.maximumTrackTintColor = [UIColor colorWithWhite:0.24 alpha:1.0];
            phlVolumeSlider.thumbTintColor = [UIColor whiteColor];
            [phlVolumeSlider addTarget:self action:@selector(volumeSliderChanged:) forControlEvents:UIControlEventValueChanged];
            [phlMenuContainer addSubview:phlVolumeSlider];

            UIButton *volUpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            volUpBtn.frame = CGRectMake(menuW - padX - 28, volY, 28, 22);
            [volUpBtn setTitle:@"🔊" forState:UIControlStateNormal];
            volUpBtn.titleLabel.font = [UIFont systemFontOfSize:12.5];
            [volUpBtn addTarget:self action:@selector(increaseVolumeStep) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:volUpBtn];

            // Nút mở trình duyệt web & tìm YouTube ngay trên menu
            CGFloat webToggleY = 107.0f;
            phlOpenBrowserBtn = [self makeControlButtonWithTitle:@"🌐 MỞ TRÌNH DUYỆT & TÌM YOUTUBE TRONG MENU"
                                                        fontSize:9.5
                                                         bgColor:[UIColor colorWithRed:0.12 green:0.18 blue:0.36 alpha:0.96]
                                                     borderColor:[UIColor colorWithRed:0.35 green:0.85 blue:1.0 alpha:0.75]
                                                          action:@selector(toggleEmbeddedBrowser)];
            phlOpenBrowserBtn.frame = CGRectMake(padX, webToggleY, innerW, 24);
            [phlOpenBrowserBtn setTitleColor:[UIColor colorWithRed:0.65 green:0.96 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            [phlMenuContainer addSubview:phlOpenBrowserBtn];

            // Vùng nội dung chính gọn gàng, chừa đủ chỗ cho chân bản quyền ở đáy
            CGFloat footerHeight = 58.0f;
            CGFloat contentY = 135.0f;
            CGFloat contentH = menuH - contentY - footerHeight - 4.0f;

            phlTableView = [[UITableView alloc] initWithFrame:CGRectMake(8, contentY, menuW - 16, contentH) style:UITableViewStylePlain];
            phlTableView.backgroundColor = [UIColor clearColor];
            phlTableView.separatorColor = [UIColor colorWithWhite:0.22 alpha:1.0];
            phlTableView.rowHeight = 40.0f;
            phlTableView.delegate = self;
            phlTableView.dataSource = self;
            [phlMenuContainer addSubview:phlTableView];

            // Khung trình duyệt web nhúng ngay trên menu
            phlWebPanel = [[UIView alloc] initWithFrame:CGRectMake(8, contentY, menuW - 16, contentH)];
            phlWebPanel.backgroundColor = [UIColor colorWithRed:0.06 green:0.03 blue:0.15 alpha:0.98];
            phlWebPanel.layer.cornerRadius = 9;
            phlWebPanel.layer.borderWidth = 1.0;
            phlWebPanel.layer.borderColor = [UIColor colorWithRed:0.45 green:0.8 blue:1.0 alpha:0.55].CGColor;
            phlWebPanel.clipsToBounds = YES;
            phlWebPanel.hidden = YES;
            [phlMenuContainer addSubview:phlWebPanel];

            CGFloat panelW = phlWebPanel.bounds.size.width;
            CGFloat panelH = phlWebPanel.bounds.size.height;

            UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            backBtn.frame = CGRectMake(5, 5, 24, 22);
            [backBtn setTitle:@"←" forState:UIControlStateNormal];
            [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            backBtn.backgroundColor = [UIColor colorWithRed:0.18 green:0.1 blue:0.32 alpha:0.9];
            backBtn.layer.cornerRadius = 5;
            [backBtn addTarget:self action:@selector(webGoBack) forControlEvents:UIControlEventTouchUpInside];
            [phlWebPanel addSubview:backBtn];

            UIButton *fwdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            fwdBtn.frame = CGRectMake(32, 5, 24, 22);
            [fwdBtn setTitle:@"→" forState:UIControlStateNormal];
            [fwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            fwdBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            fwdBtn.backgroundColor = [UIColor colorWithRed:0.18 green:0.1 blue:0.32 alpha:0.9];
            fwdBtn.layer.cornerRadius = 5;
            [fwdBtn addTarget:self action:@selector(webGoForward) forControlEvents:UIControlEventTouchUpInside];
            [phlWebPanel addSubview:fwdBtn];

            UIButton *closeWebBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            closeWebBtn.frame = CGRectMake(panelW - 56, 5, 51, 22);
            [closeWebBtn setTitle:@"Danh sách" forState:UIControlStateNormal];
            [closeWebBtn setTitleColor:[UIColor colorWithRed:0.95 green:0.75 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            closeWebBtn.titleLabel.font = [UIFont boldSystemFontOfSize:9];
            closeWebBtn.backgroundColor = [UIColor colorWithRed:0.28 green:0.09 blue:0.22 alpha:0.92];
            closeWebBtn.layer.cornerRadius = 5;
            [closeWebBtn addTarget:self action:@selector(closeEmbeddedBrowser) forControlEvents:UIControlEventTouchUpInside];
            [phlWebPanel addSubview:closeWebBtn];

            CGFloat searchBtnW = 42.0f;
            CGFloat searchFieldW = panelW - 10.0f - searchBtnW - 4.0f;

            phlYouTubeSearchField = [[UITextField alloc] initWithFrame:CGRectMake(5, 30, searchFieldW, 24)];
            phlYouTubeSearchField.placeholder = @"Tìm nhạc trên YouTube...";
            phlYouTubeSearchField.textColor = [UIColor whiteColor];
            phlYouTubeSearchField.font = [UIFont systemFontOfSize:10.5];
            phlYouTubeSearchField.backgroundColor = [UIColor colorWithRed:0.12 green:0.07 blue:0.22 alpha:0.95];
            phlYouTubeSearchField.layer.cornerRadius = 6;
            phlYouTubeSearchField.layer.borderWidth = 1.0;
            phlYouTubeSearchField.layer.borderColor = [UIColor colorWithRed:0.65 green:0.35 blue:1.0 alpha:0.6].CGColor;
            phlYouTubeSearchField.returnKeyType = UIReturnKeySearch;
            phlYouTubeSearchField.clearButtonMode = UITextFieldViewModeWhileEditing;
            phlYouTubeSearchField.delegate = self;

            UIView *leftPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 24)];
            phlYouTubeSearchField.leftView = leftPad;
            phlYouTubeSearchField.leftViewMode = UITextFieldViewModeAlways;
            [phlWebPanel addSubview:phlYouTubeSearchField];

            UIButton *ytSearchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            ytSearchBtn.frame = CGRectMake(5 + searchFieldW + 4.0f, 30, searchBtnW, 24);
            [ytSearchBtn setTitle:@"🔍 YT" forState:UIControlStateNormal];
            [ytSearchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            ytSearchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:9.5];
            ytSearchBtn.backgroundColor = [UIColor colorWithRed:0.74 green:0.12 blue:0.22 alpha:0.95];
            ytSearchBtn.layer.cornerRadius = 6;
            [ytSearchBtn addTarget:self action:@selector(triggerYouTubeSearch) forControlEvents:UIControlEventTouchUpInside];
            [phlWebPanel addSubview:ytSearchBtn];

            WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
            webConfig.allowsInlineMediaPlayback = YES;
            phlWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 57, panelW, MAX(60.0f, panelH - 57)) configuration:webConfig];
            phlWebView.navigationDelegate = self;
            phlWebView.scrollView.bounces = YES;
            [phlWebPanel addSubview:phlWebView];

            // --- CHÂN CỐ ĐỊNH DƯỚI CÙNG (HIỂN THỊ TRỌN VẸN TRONG KHUNG GỌN) ---
            CGFloat infoBtnY = menuH - footerHeight;
            phlAdminInfoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            phlAdminInfoBtn.frame = CGRectMake(padX, infoBtnY, innerW, 22);
            [phlAdminInfoBtn setTitle:@"🛡 INFO & BẢN QUYỀN • phamlong09.store" forState:UIControlStateNormal];
            [phlAdminInfoBtn setTitleColor:[UIColor colorWithRed:0.45 green:0.96 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            phlAdminInfoBtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightBold];
            phlAdminInfoBtn.backgroundColor = [UIColor colorWithRed:0.14 green:0.06 blue:0.28 alpha:0.96];
            phlAdminInfoBtn.layer.cornerRadius = 7;
            phlAdminInfoBtn.layer.borderWidth = 1.0;
            phlAdminInfoBtn.layer.borderColor = [UIColor colorWithRed:0.78 green:0.42 blue:1.0 alpha:0.85].CGColor;
            [phlAdminInfoBtn addTarget:self action:@selector(openAdminInfoGroup) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:phlAdminInfoBtn];

            phlCopyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, infoBtnY + 23, menuW - 12, 33)];
            phlCopyrightLabel.text = @"BẢN QUYỀN THUỘC ADMIN TELEGRAM: @PHL0990\nZALO: 0522608620";
            phlCopyrightLabel.textColor = [UIColor colorWithRed:0.9 green:0.82 blue:1.0 alpha:0.95];
            phlCopyrightLabel.font = [UIFont systemFontOfSize:8.5 weight:UIFontWeightBold];
            phlCopyrightLabel.textAlignment = NSTextAlignmentCenter;
            phlCopyrightLabel.numberOfLines = 2;
            [phlMenuContainer addSubview:phlCopyrightLabel];

            [keyWindow addSubview:phlMenuContainer];
        } else if (phlMenuContainer.superview != keyWindow) {
            [keyWindow addSubview:phlMenuContainer];
        }

        [self fetchGitHubPlaylist];
    });
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self applyUnifiedVolume:phlCurrentVolume];
}

- (void)toggleEmbeddedBrowser {
    phlIsWebOpen = !phlIsWebOpen;
    [self syncBrowserVisibility];
    if (phlIsWebOpen && !phlHasLoadedInitialWeb) {
        phlHasLoadedInitialWeb = YES;
        [self loadYouTubeURLString:kPHLYouTubeHomeURL];
    }
}

- (void)closeEmbeddedBrowser {
    [phlYouTubeSearchField resignFirstResponder];
    phlIsWebOpen = NO;
    [self syncBrowserVisibility];
}

- (void)syncBrowserVisibility {
    phlWebPanel.hidden = !phlIsWebOpen;
    phlTableView.hidden = phlIsWebOpen;
    [phlOpenBrowserBtn setTitle:(phlIsWebOpen
        ? @"☰ ĐANG MỞ TRÌNH DUYỆT • VỀ DANH SÁCH NHẠC"
        : @"🌐 MỞ TRÌNH DUYỆT & TÌM YOUTUBE TRONG MENU")
                        forState:UIControlStateNormal];
}

- (void)loadYouTubeURLString:(NSString *)urlStr {
    if (!phlWebView || !urlStr || urlStr.length == 0) return;
    NSURL *url = [NSURL URLWithString:urlStr];
    if (!url) return;
    NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [phlWebView loadRequest:req];
}

- (void)triggerYouTubeSearch {
    [phlYouTubeSearchField resignFirstResponder];
    NSString *rawQuery = [phlYouTubeSearchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!phlIsWebOpen) {
        phlIsWebOpen = YES;
        [self syncBrowserVisibility];
    }

    if (rawQuery.length == 0) {
        phlHasLoadedInitialWeb = YES;
        [self loadYouTubeURLString:kPHLYouTubeHomeURL];
        return;
    }

    NSCharacterSet *allowed = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodedQuery = [rawQuery stringByAddingPercentEncodingWithAllowedCharacters:allowed];
    NSString *searchURL = [NSString stringWithFormat:@"https://m.youtube.com/results?search_query=%@", encodedQuery ?: @""];
    phlHasLoadedInitialWeb = YES;
    [self loadYouTubeURLString:searchURL];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == phlYouTubeSearchField) {
        [self triggerYouTubeSearch];
        return NO;
    }
    return YES;
}

- (void)webGoBack {
    if (phlWebView.canGoBack) {
        [phlWebView goBack];
    }
}

- (void)webGoForward {
    if (phlWebView.canGoForward) {
        [phlWebView goForward];
    }
}

- (void)loadRemoteLogo {
    NSURL *logoURL = [NSURL URLWithString:@"https://raw.githubusercontent.com/phamlong3539-stack/phl-music-data/main/logo.png"];
    if (!logoURL) return;

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:logoURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
        if (error || !data || httpResp.statusCode != 200) return;
        UIImage *img = [UIImage imageWithData:data];
        if (!img) return;

        dispatch_async(dispatch_get_main_queue(), ^{
            [phlFloatingBtn setImage:img forState:UIControlStateNormal];
            phlFloatingBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [phlFloatingBtn setTitle:@"" forState:UIControlStateNormal];
        });
    }];
    [task resume];
}

- (void)toggleMenu {
    phlIsMenuOpen = !phlIsMenuOpen;
    if (phlIsMenuOpen) {
        [self initializeFramework];
        [self fetchGitHubPlaylist];
        [self syncPlayPauseButton];
        phlMenuContainer.hidden = NO;
        [UIView animateWithDuration:0.18 animations:^{
            phlMenuContainer.alpha = 1.0;
        }];
    } else {
        [phlYouTubeSearchField resignFirstResponder];
        [UIView animateWithDuration:0.16 animations:^{
            phlMenuContainer.alpha = 0.0;
        } completion:^(BOOL finished) {
            phlMenuContainer.hidden = YES;
        }];
    }
}

- (void)clampViewToSafeBounds:(UIView *)targetView topMargin:(CGFloat)topMargin bottomMargin:(CGFloat)bottomMargin {
    if (!targetView || !targetView.superview) return;
    CGSize superSize = targetView.superview.bounds.size;
    CGFloat halfW = targetView.bounds.size.width / 2.0f;
    CGFloat halfH = targetView.bounds.size.height / 2.0f;

    CGFloat minX = halfW + 6.0f;
    CGFloat maxX = superSize.width - halfW - 6.0f;
    CGFloat minY = halfH + topMargin;
    CGFloat maxY = superSize.height - halfH - bottomMargin;

    CGPoint c = targetView.center;
    if (minX <= maxX) c.x = MAX(minX, MIN(maxX, c.x));
    if (minY <= maxY) c.y = MAX(minY, MIN(maxY, c.y));
    targetView.center = c;
}

- (void)handleFloatingPan:(UIPanGestureRecognizer *)pan {
    UIView *targetView = pan.view;
    if (!targetView || !targetView.superview) return;

    CGPoint translation = [pan translationInView:targetView.superview];
    targetView.center = CGPointMake(targetView.center.x + translation.x, targetView.center.y + translation.y);
    [self clampViewToSafeBounds:targetView topMargin:18.0f bottomMargin:18.0f];
    [pan setTranslation:CGPointZero inView:targetView.superview];
}

- (void)handleMenuHeaderPan:(UIPanGestureRecognizer *)pan {
    if (!phlMenuContainer || !phlMenuContainer.superview) return;

    CGPoint translation = [pan translationInView:phlMenuContainer.superview];
    phlMenuContainer.center = CGPointMake(phlMenuContainer.center.x + translation.x, phlMenuContainer.center.y + translation.y);
    [self clampViewToSafeBounds:phlMenuContainer topMargin:18.0f bottomMargin:14.0f];
    [pan setTranslation:CGPointZero inView:phlMenuContainer.superview];
}

- (void)fetchGitHubPlaylist {
    NSString *jsonURLStr = @"https://raw.githubusercontent.com/phamlong3539-stack/phl-music-data/main/playlist.json";
    NSURL *url = [NSURL URLWithString:jsonURLStr];
    if (!url) return;

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
        if (error || !data || httpResp.statusCode != 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                phlStatusMessage = [NSString stringWithFormat:@"Không tải được playlist (HTTP %ld)", (long)httpResp.statusCode];
                [phlTableView reloadData];
            });
            return;
        }

        NSError *jsonError = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError || ![jsonDict isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                phlStatusMessage = @"Lỗi cú pháp JSON trong playlist.json";
                [phlTableView reloadData];
            });
            return;
        }

        NSArray *songs = jsonDict[@"songs"];
        if (![songs isKindOfClass:[NSArray class]] || songs.count == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [phlPlaylist removeAllObjects];
                phlStatusMessage = @"Danh sách bài hát đang trống";
                [phlTableView reloadData];
            });
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [phlPlaylist removeAllObjects];
            [phlPlaylist addObjectsFromArray:songs];
            phlStatusMessage = nil;
            [phlTableView reloadData];
        });
    }];
    [task resume];
}

- (void)playSongAtIndex:(NSInteger)index {
    if (index < 0 || index >= (NSInteger)phlPlaylist.count) return;
    NSDictionary *song = phlPlaylist[index];
    NSString *title = song[@"title"] ?: @"Bài hát chưa đặt tên";
    NSString *urlString = song[@"url"] ?: @"";
    if (urlString.length == 0) return;

    [self configureAudioSession];

    NSString *encodedStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:encodedStr ?: urlString];
    if (!url) return;

    phlCurrentIndex = index;
    phlNowPlayingLabel.text = [NSString stringWithFormat:@"♪ %@", title];

    phlPlayerItem = [AVPlayerItem playerItemWithURL:url];
    if (!phlAudioPlayer) {
        phlAudioPlayer = [AVPlayer playerWithPlayerItem:phlPlayerItem];
    } else {
        [phlAudioPlayer replaceCurrentItemWithPlayerItem:phlPlayerItem];
    }
    phlAudioPlayer.volume = phlCurrentVolume;
    [phlAudioPlayer play];
    [self syncPlayPauseButton];
    [phlTableView reloadData];
}

- (void)togglePlayPause {
    if (!phlAudioPlayer || phlCurrentIndex < 0) {
        if (phlPlaylist.count > 0) {
            [self playSongAtIndex:0];
        }
        return;
    }

    if (phlAudioPlayer.rate > 0.01f) {
        [phlAudioPlayer pause];
    } else {
        [self configureAudioSession];
        phlAudioPlayer.volume = phlCurrentVolume;
        [phlAudioPlayer play];
    }
    [self syncPlayPauseButton];
}

- (void)syncPlayPauseButton {
    BOOL isPlaying = (phlAudioPlayer && phlAudioPlayer.rate > 0.01f);
    [phlPlayPauseBtn setTitle:(isPlaying ? @"⏸" : @"▶") forState:UIControlStateNormal];
}

- (void)playPreviousSong {
    if (phlPlaylist.count == 0) return;
    NSInteger prevIdx = (phlCurrentIndex <= 0) ? ((NSInteger)phlPlaylist.count - 1) : (phlCurrentIndex - 1);
    [self playSongAtIndex:prevIdx];
}

- (void)playNextSong {
    if (phlPlaylist.count == 0) return;
    NSInteger nextIdx = (phlCurrentIndex + 1) % (NSInteger)phlPlaylist.count;
    [self playSongAtIndex:nextIdx];
}

- (void)volumeSliderChanged:(UISlider *)slider {
    [self applyUnifiedVolume:slider.value];
}

- (void)decreaseVolumeStep {
    float nextVol = MAX(0.0f, phlCurrentVolume - 0.15f);
    phlVolumeSlider.value = nextVol;
    [self applyUnifiedVolume:nextVol];
}

- (void)increaseVolumeStep {
    float nextVol = MIN(1.0f, phlCurrentVolume + 0.15f);
    phlVolumeSlider.value = nextVol;
    [self applyUnifiedVolume:nextVol];
}

- (void)toggleRepeatMode {
    phlRepeatOne = !phlRepeatOne;
    [[NSUserDefaults standardUserDefaults] setBool:phlRepeatOne forKey:kPHLPrefRepeatOne];
    [self syncRepeatButton];
}

- (void)syncRepeatButton {
    [phlRepeatBtn setTitle:(phlRepeatOne ? @"🔂" : @"🔁") forState:UIControlStateNormal];
    phlRepeatBtn.backgroundColor = phlRepeatOne
        ? [UIColor colorWithRed:0.48 green:0.16 blue:0.82 alpha:0.96]
        : [UIColor colorWithRed:0.15 green:0.08 blue:0.29 alpha:0.95];
}

- (void)openAdminInfoGroup {
    NSURL *infoURL = [NSURL URLWithString:kPHLAdminInfoURL];
    if (!infoURL) return;
    [[UIApplication sharedApplication] openURL:infoURL options:@{} completionHandler:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return phlPlaylist.count > 0 ? phlPlaylist.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"PHLSongCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:10.5 weight:UIFontWeightMedium];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:8.5];
    }

    if (phlPlaylist.count == 0) {
        cell.textLabel.textColor = [UIColor colorWithRed:1.0 green:0.65 blue:0.65 alpha:1.0];
        cell.textLabel.text = phlStatusMessage ?: @"Không có bài hát";
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.text = @"Chạm để thử tải lại từ GitHub";
        return cell;
    }

    NSDictionary *song = phlPlaylist[indexPath.row];
    NSString *title = song[@"title"] ?: @"Bài hát chưa đặt tên";
    BOOL isCurrent = (indexPath.row == phlCurrentIndex);

    cell.textLabel.textColor = isCurrent ? [UIColor colorWithRed:0.88 green:0.58 blue:1.0 alpha:1.0] : [UIColor whiteColor];
    cell.textLabel.text = title;
    cell.detailTextLabel.textColor = isCurrent ? [UIColor greenColor] : [UIColor cyanColor];
    cell.detailTextLabel.text = isCurrent ? @"🔊 Đang phát trực tiếp" : @"▶ Chạm để phát từ GitHub";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (phlPlaylist.count == 0) {
        phlStatusMessage = @"Đang tải lại danh sách nhạc...";
        [tableView reloadData];
        [self fetchGitHubPlaylist];
        return;
    }

    [self playSongAtIndex:indexPath.row];
}

@end

__attribute__((constructor)) static void phlSecureInit() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[PHLProtectedAudioManager sharedInstance] initializeFramework];
    });
}
