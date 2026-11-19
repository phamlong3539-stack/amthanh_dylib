#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
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

@interface PHLProtectedAudioManager : NSObject <UITableViewDataSource, UITableViewDelegate> {
    AVPlayer *phlAudioPlayer;
    AVPlayerItem *phlPlayerItem;

    UIButton *phlFloatingBtn;
    UIView *phlMenuContainer;
    UIView *phlDragHeader;
    UITableView *phlTableView;

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
    btn.layer.cornerRadius = 9;
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
        CGFloat menuW = MIN(312.0f, screenW - 96.0f);
        if (menuW < 260.0f) menuW = MIN(300.0f, screenW - 24.0f);
        CGFloat menuH = 432.0f;

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
            // 2. Khung menu chính (chỉ kéo qua thanh tiêu đề trên cùng để tránh chạm nhầm)
            phlMenuContainer = [[UIView alloc] initWithFrame:CGRectMake(72, 62, menuW, menuH)];
            phlMenuContainer.backgroundColor = [UIColor colorWithRed:0.045 green:0.022 blue:0.125 alpha:0.98];
            phlMenuContainer.layer.cornerRadius = 16;
            phlMenuContainer.layer.borderWidth = 1.5;
            phlMenuContainer.layer.borderColor = [UIColor colorWithRed:0.82 green:0.42 blue:1.0 alpha:0.95].CGColor;
            phlMenuContainer.clipsToBounds = YES;
            phlMenuContainer.hidden = YES;
            phlMenuContainer.alpha = 0.0;

            // Thanh tiêu đề dùng làm tay nắm kéo di chuyển toàn menu
            phlDragHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuW, 54)];
            phlDragHeader.backgroundColor = [UIColor colorWithRed:0.11 green:0.05 blue:0.23 alpha:0.95];
            [phlMenuContainer addSubview:phlDragHeader];

            UIPanGestureRecognizer *headerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMenuHeaderPan:)];
            [phlDragHeader addGestureRecognizer:headerPan];

            UILabel *dragGripLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, menuW - 56, 12)];
            dragGripLabel.text = @"⋮⋮ KÉO THANH NÀY ĐỂ DI CHUYỂN";
            dragGripLabel.textColor = [UIColor colorWithRed:0.72 green:0.55 blue:0.98 alpha:0.85];
            dragGripLabel.font = [UIFont systemFontOfSize:8 weight:UIFontWeightBold];
            [phlDragHeader addSubview:dragGripLabel];

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 18, menuW - 56, 18)];
            titleLabel.text = @"👑 PHL PHAM LONG • AUDIO";
            titleLabel.textColor = [UIColor colorWithRed:0.95 green:0.78 blue:1.0 alpha:1.0];
            titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightHeavy];
            [phlDragHeader addSubview:titleLabel];

            phlNowPlayingLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 35, menuW - 24, 16)];
            phlNowPlayingLabel.text = @"♪ Chưa chọn bài hát";
            phlNowPlayingLabel.textColor = [UIColor colorWithRed:0.35 green:0.95 blue:1.0 alpha:1.0];
            phlNowPlayingLabel.font = [UIFont systemFontOfSize:10.5 weight:UIFontWeightSemibold];
            [phlDragHeader addSubview:phlNowPlayingLabel];

            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            closeBtn.frame = CGRectMake(menuW - 38, 10, 28, 28);
            [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
            [closeBtn setTitleColor:[UIColor colorWithRed:1.0 green:0.55 blue:0.72 alpha:1.0] forState:UIControlStateNormal];
            closeBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
            closeBtn.backgroundColor = [UIColor colorWithRed:0.22 green:0.06 blue:0.18 alpha:0.85];
            closeBtn.layer.cornerRadius = 14;
            [closeBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:closeBtn];

            // Cụm điều khiển chính: Prev | Play/Pause | Next | Lặp
            CGFloat padX = 12.0f;
            CGFloat innerW = menuW - padX * 2.0f;
            CGFloat gap = 6.0f;
            CGFloat btnW = (innerW - gap * 3.0f) / 4.0f;
            CGFloat ctrlY = 62.0f;

            UIColor *ctrlBg = [UIColor colorWithRed:0.15 green:0.08 blue:0.29 alpha:0.95];
            UIColor *ctrlBorder = [UIColor colorWithRed:0.68 green:0.36 blue:1.0 alpha:0.7];

            UIButton *prevBtn = [self makeControlButtonWithTitle:@"⏮"
                                                      fontSize:14
                                                       bgColor:ctrlBg
                                                   borderColor:ctrlBorder
                                                        action:@selector(playPreviousSong)];
            prevBtn.frame = CGRectMake(padX, ctrlY, btnW, 32);
            [phlMenuContainer addSubview:prevBtn];

            phlPlayPauseBtn = [self makeControlButtonWithTitle:@"▶"
                                                    fontSize:15
                                                     bgColor:[UIColor colorWithRed:0.48 green:0.18 blue:0.86 alpha:0.96]
                                                 borderColor:[UIColor colorWithRed:0.9 green:0.62 blue:1.0 alpha:0.95]
                                                      action:@selector(togglePlayPause)];
            phlPlayPauseBtn.frame = CGRectMake(padX + (btnW + gap), ctrlY, btnW, 32);
            [phlMenuContainer addSubview:phlPlayPauseBtn];

            UIButton *nextBtn = [self makeControlButtonWithTitle:@"⏭"
                                                      fontSize:14
                                                       bgColor:ctrlBg
                                                   borderColor:ctrlBorder
                                                        action:@selector(playNextSong)];
            nextBtn.frame = CGRectMake(padX + (btnW + gap) * 2.0f, ctrlY, btnW, 32);
            [phlMenuContainer addSubview:nextBtn];

            phlRepeatBtn = [self makeControlButtonWithTitle:@"🔁"
                                                 fontSize:14
                                                  bgColor:ctrlBg
                                              borderColor:ctrlBorder
                                                   action:@selector(toggleRepeatMode)];
            phlRepeatBtn.frame = CGRectMake(padX + (btnW + gap) * 3.0f, ctrlY, btnW, 32);
            [self syncRepeatButton];
            [phlMenuContainer addSubview:phlRepeatBtn];

            // Thanh chỉnh / giảm âm lượng
            CGFloat volY = 102.0f;
            UIButton *muteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            muteBtn.frame = CGRectMake(padX, volY, 32, 26);
            [muteBtn setTitle:@"🔉" forState:UIControlStateNormal];
            muteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [muteBtn addTarget:self action:@selector(decreaseVolumeStep) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:muteBtn];

            phlVolumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(padX + 36, volY, innerW - 72, 26)];
            phlVolumeSlider.minimumValue = 0.0f;
            phlVolumeSlider.maximumValue = 1.0f;
            phlVolumeSlider.value = phlCurrentVolume;
            phlVolumeSlider.minimumTrackTintColor = [UIColor colorWithRed:0.35 green:0.92 blue:1.0 alpha:1.0];
            phlVolumeSlider.maximumTrackTintColor = [UIColor colorWithWhite:0.24 alpha:1.0];
            phlVolumeSlider.thumbTintColor = [UIColor whiteColor];
            [phlVolumeSlider addTarget:self action:@selector(volumeSliderChanged:) forControlEvents:UIControlEventValueChanged];
            [phlMenuContainer addSubview:phlVolumeSlider];

            UIButton *volUpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            volUpBtn.frame = CGRectMake(menuW - padX - 32, volY, 32, 26);
            [volUpBtn setTitle:@"🔊" forState:UIControlStateNormal];
            volUpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [volUpBtn addTarget:self action:@selector(increaseVolumeStep) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:volUpBtn];

            // Thanh chuyển ứng dụng nhanh
            CGFloat appY = 134.0f;
            NSArray *appLabels = @[@"TikTok", @"YouTube", @"Telegram"];
            NSArray *appSchemes = @[@"snssdk1233://", @"youtube://", @"tg://"];
            CGFloat appGap = 5.0f;
            CGFloat appBtnW = (innerW - appGap * 2.0f) / 3.0f;

            for (NSInteger j = 0; j < (NSInteger)appLabels.count; j++) {
                UIButton *appBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                appBtn.frame = CGRectMake(padX + j * (appBtnW + appGap), appY, appBtnW, 26);
                [appBtn setTitle:[NSString stringWithFormat:@"↗ %@", appLabels[j]] forState:UIControlStateNormal];
                appBtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightSemibold];
                [appBtn setTitleColor:[UIColor colorWithRed:0.88 green:0.96 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                appBtn.backgroundColor = [UIColor colorWithRed:0.08 green:0.13 blue:0.26 alpha:0.94];
                appBtn.layer.cornerRadius = 7;
                appBtn.layer.borderWidth = 1.0;
                appBtn.layer.borderColor = [UIColor colorWithRed:0.35 green:0.65 blue:1.0 alpha:0.35].CGColor;
                objc_setAssociatedObject(appBtn, "phlSchemeKey", appSchemes[j], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [appBtn addTarget:self action:@selector(openExternalApp:) forControlEvents:UIControlEventTouchUpInside];
                [phlMenuContainer addSubview:appBtn];
            }

            // Danh sách bài hát (cuộn độc lập, chân bản quyền cố định bên dưới)
            CGFloat footerHeight = 68.0f;
            CGFloat tableY = 166.0f;
            CGFloat tableH = menuH - tableY - footerHeight - 6.0f;

            phlTableView = [[UITableView alloc] initWithFrame:CGRectMake(8, tableY, menuW - 16, tableH) style:UITableViewStylePlain];
            phlTableView.backgroundColor = [UIColor clearColor];
            phlTableView.separatorColor = [UIColor colorWithWhite:0.22 alpha:1.0];
            phlTableView.delegate = self;
            phlTableView.dataSource = self;
            [phlMenuContainer addSubview:phlTableView];

            // --- CHÂN CỐ ĐỊNH DƯỚI CÙNG (INFO BẢN QUYỀN https://phamlong09.store) ---
            CGFloat infoBtnY = menuH - footerHeight;
            phlAdminInfoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            phlAdminInfoBtn.frame = CGRectMake(padX, infoBtnY, innerW, 28);
            [phlAdminInfoBtn setTitle:@"🛡 INFO & BẢN QUYỀN • phamlong09.store" forState:UIControlStateNormal];
            [phlAdminInfoBtn setTitleColor:[UIColor colorWithRed:0.45 green:0.96 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            phlAdminInfoBtn.titleLabel.font = [UIFont systemFontOfSize:10.5 weight:UIFontWeightBold];
            phlAdminInfoBtn.backgroundColor = [UIColor colorWithRed:0.14 green:0.06 blue:0.28 alpha:0.96];
            phlAdminInfoBtn.layer.cornerRadius = 8;
            phlAdminInfoBtn.layer.borderWidth = 1.0;
            phlAdminInfoBtn.layer.borderColor = [UIColor colorWithRed:0.78 green:0.42 blue:1.0 alpha:0.85].CGColor;
            [phlAdminInfoBtn addTarget:self action:@selector(openAdminInfoGroup) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:phlAdminInfoBtn];

            phlCopyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, infoBtnY + 30, menuW - 16, 34)];
            phlCopyrightLabel.text = @"BẢN QUYỀN THUỘC ADMIN TELEGRAM: @PHL0990\nZALO: 0522608620";
            phlCopyrightLabel.textColor = [UIColor colorWithRed:0.9 green:0.82 blue:1.0 alpha:0.95];
            phlCopyrightLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightBold];
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
    [self clampViewToSafeBounds:phlMenuContainer topMargin:22.0f bottomMargin:16.0f];
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
    phlCurrentVolume = slider.value;
    [[NSUserDefaults standardUserDefaults] setFloat:phlCurrentVolume forKey:kPHLPrefVolume];
    if (phlAudioPlayer) {
        phlAudioPlayer.volume = phlCurrentVolume;
    }
}

- (void)decreaseVolumeStep {
    phlCurrentVolume = MAX(0.0f, phlCurrentVolume - 0.15f);
    phlVolumeSlider.value = phlCurrentVolume;
    [self volumeSliderChanged:phlVolumeSlider];
}

- (void)increaseVolumeStep {
    phlCurrentVolume = MIN(1.0f, phlCurrentVolume + 0.15f);
    phlVolumeSlider.value = phlCurrentVolume;
    [self volumeSliderChanged:phlVolumeSlider];
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

- (void)openExternalApp:(UIButton *)sender {
    NSString *scheme = objc_getAssociatedObject(sender, "phlSchemeKey");
    if (!scheme || scheme.length == 0) return;
    NSURL *appURL = [NSURL URLWithString:scheme];
    if (!appURL) return;
    [[UIApplication sharedApplication] openURL:appURL options:@{} completionHandler:nil];
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
        cell.textLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:9];
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
