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
static NSString *const kPHLDefaultYouTubeURL = @"https://www.youtube.com";
static NSString *const kPHLAdminInfoURL = @"https://phamlong09.store";

@interface PHLProtectedAudioManager : NSObject <UITableViewDataSource, UITableViewDelegate> {
    AVPlayer *phlAudioPlayer;
    AVPlayerItem *phlPlayerItem;

    UIButton *phlFloatingBtn;
    UIView *phlMenuContainer;
    UITableView *phlTableView;

    // Khu vực điều khiển trình phát
    UILabel *phlNowPlayingLabel;
    UIButton *phlPlayPauseBtn;
    UIButton *phlRepeatBtn;
    UIButton *phlYouTubeBottomBtn;
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

- (void)initializeFramework {
    preventDebugging();

    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [self resolveActiveWindow];
        if (!keyWindow) return;

        if (!phlFloatingBtn) {
            // 1. Nút nổi (Floating Button) giao diện tròn bo tím Neon
            phlFloatingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            phlFloatingBtn.frame = CGRectMake(20, 120, 48, 48);
            phlFloatingBtn.layer.cornerRadius = 24;
            phlFloatingBtn.clipsToBounds = YES;
            phlFloatingBtn.layer.borderWidth = 2.0;
            phlFloatingBtn.layer.borderColor = [UIColor colorWithRed:0.75 green:0.35 blue:1.0 alpha:1.0].CGColor;
            phlFloatingBtn.backgroundColor = [UIColor colorWithRed:0.04 green:0.02 blue:0.1 alpha:0.94];
            [phlFloatingBtn setTitle:@"👑" forState:UIControlStateNormal];
            [phlFloatingBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];

            UIPanGestureRecognizer *btnPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            [phlFloatingBtn addGestureRecognizer:btnPan];
            [keyWindow addSubview:phlFloatingBtn];

            [self loadRemoteLogo];
        } else if (phlFloatingBtn.superview != keyWindow) {
            [keyWindow addSubview:phlFloatingBtn];
        }

        if (!phlMenuContainer) {
            // 2. Menu chính (kéo tự do toàn khung, chân bản quyền cố định dưới cùng)
            phlMenuContainer = [[UIView alloc] initWithFrame:CGRectMake(76, 70, 304, 448)];
            phlMenuContainer.backgroundColor = [UIColor colorWithRed:0.04 green:0.02 blue:0.12 alpha:0.97];
            phlMenuContainer.layer.cornerRadius = 14;
            phlMenuContainer.layer.borderWidth = 1.5;
            phlMenuContainer.layer.borderColor = [UIColor colorWithRed:0.8 green:0.4 blue:1.0 alpha:1.0].CGColor;
            phlMenuContainer.hidden = YES;
            phlMenuContainer.alpha = 0.0;

            UIPanGestureRecognizer *menuPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            menuPan.cancelsTouchesInView = NO;
            [phlMenuContainer addGestureRecognizer:menuPan];

            // Tiêu đề + nút đóng nhanh
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, 240, 22)];
            titleLabel.text = @"👑 PHL PHAM LONG - PRO AUDIO";
            titleLabel.textColor = [UIColor colorWithRed:0.92 green:0.7 blue:1.0 alpha:1.0];
            titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [phlMenuContainer addSubview:titleLabel];

            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            closeBtn.frame = CGRectMake(260, 6, 34, 24);
            [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
            [closeBtn setTitleColor:[UIColor colorWithRed:1.0 green:0.55 blue:0.7 alpha:1.0] forState:UIControlStateNormal];
            closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [closeBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:closeBtn];

            // Tên bài đang phát
            phlNowPlayingLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 30, 280, 18)];
            phlNowPlayingLabel.text = @"♪ Chưa chọn bài hát";
            phlNowPlayingLabel.textColor = [UIColor cyanColor];
            phlNowPlayingLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
            [phlMenuContainer addSubview:phlNowPlayingLabel];

            // Hàng điều khiển phát nhạc: Prev | Play/Pause | Next | Lặp
            NSArray *titles = @[@"⏮", @"▶", @"⏭", @"🔁"];
            NSArray *selectors = @[
                NSStringFromSelector(@selector(playPreviousSong)),
                NSStringFromSelector(@selector(togglePlayPause)),
                NSStringFromSelector(@selector(playNextSong)),
                NSStringFromSelector(@selector(toggleRepeatMode))
            ];
            CGFloat btnW = 66.0f;
            CGFloat gap = 5.3f;
            CGFloat startX = 12.0f;

            for (NSInteger i = 0; i < (NSInteger)titles.count; i++) {
                UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
                b.frame = CGRectMake(startX + i * (btnW + gap), 53, btnW, 28);
                [b setTitle:titles[i] forState:UIControlStateNormal];
                b.titleLabel.font = [UIFont boldSystemFontOfSize:13];
                b.backgroundColor = [UIColor colorWithRed:0.14 green:0.07 blue:0.26 alpha:0.92];
                b.layer.cornerRadius = 7;
                b.layer.borderWidth = 1.0;
                b.layer.borderColor = [UIColor colorWithRed:0.6 green:0.3 blue:0.95 alpha:0.65].CGColor;
                [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [b addTarget:self action:NSSelectorFromString(selectors[i]) forControlEvents:UIControlEventTouchUpInside];

                if (i == 1) phlPlayPauseBtn = b;
                if (i == 3) {
                    phlRepeatBtn = b;
                    [self syncRepeatButton];
                }
                [phlMenuContainer addSubview:b];
            }

            // Thanh chỉnh / giảm âm lượng
            UIButton *muteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            muteBtn.frame = CGRectMake(12, 87, 36, 24);
            [muteBtn setTitle:@"🔉" forState:UIControlStateNormal];
            muteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [muteBtn addTarget:self action:@selector(decreaseVolumeStep) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:muteBtn];

            phlVolumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(52, 89, 200, 20)];
            phlVolumeSlider.minimumValue = 0.0f;
            phlVolumeSlider.maximumValue = 1.0f;
            phlVolumeSlider.value = phlCurrentVolume;
            phlVolumeSlider.minimumTrackTintColor = [UIColor cyanColor];
            phlVolumeSlider.maximumTrackTintColor = [UIColor colorWithWhite:0.25 alpha:1.0];
            [phlVolumeSlider addTarget:self action:@selector(volumeSliderChanged:) forControlEvents:UIControlEventValueChanged];
            [phlMenuContainer addSubview:phlVolumeSlider];

            UIButton *volUpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            volUpBtn.frame = CGRectMake(256, 87, 36, 24);
            [volUpBtn setTitle:@"🔊" forState:UIControlStateNormal];
            volUpBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [volUpBtn addTarget:self action:@selector(increaseVolumeStep) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:volUpBtn];

            // Thanh chuyển ứng dụng nhanh
            NSArray *appLabels = @[@"TikTok", @"YouTube", @"Telegram"];
            NSArray *appSchemes = @[@"snssdk1233://", @"youtube://", @"tg://"];
            CGFloat appBtnW = 89.3f;
            CGFloat appGap = 6.0f;
            for (NSInteger j = 0; j < (NSInteger)appLabels.count; j++) {
                UIButton *appBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                appBtn.frame = CGRectMake(12 + j * (appBtnW + appGap), 117, appBtnW, 24);
                [appBtn setTitle:[NSString stringWithFormat:@"⇄ %@", appLabels[j]] forState:UIControlStateNormal];
                appBtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightSemibold];
                [appBtn setTitleColor:[UIColor colorWithRed:0.85 green:0.95 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                appBtn.backgroundColor = [UIColor colorWithRed:0.08 green:0.12 blue:0.24 alpha:0.92];
                appBtn.layer.cornerRadius = 6;
                objc_setAssociatedObject(appBtn, "phlSchemeKey", appSchemes[j], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [appBtn addTarget:self action:@selector(openExternalApp:) forControlEvents:UIControlEventTouchUpInside];
                [phlMenuContainer addSubview:appBtn];
            }

            // Danh sách bài hát (cuộn độc lập, không đẩy chân menu)
            phlTableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 147, 288, 204) style:UITableViewStylePlain];
            phlTableView.backgroundColor = [UIColor clearColor];
            phlTableView.separatorColor = [UIColor colorWithWhite:0.22 alpha:1.0];
            phlTableView.delegate = self;
            phlTableView.dataSource = self;
            [phlMenuContainer addSubview:phlTableView];

            // --- PHẦN CHÂN CỐ ĐỊNH DƯỚI CÙNG (KHÔNG ĐỔI VỊ TRÍ KHI THÊM BÀI) ---
            phlYouTubeBottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            phlYouTubeBottomBtn.frame = CGRectMake(12, 356, 280, 28);
            [phlYouTubeBottomBtn setTitle:@"▶ Chuyển sang YouTube nghe nhạc" forState:UIControlStateNormal];
            [phlYouTubeBottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            phlYouTubeBottomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
            phlYouTubeBottomBtn.backgroundColor = [UIColor colorWithRed:0.72 green:0.12 blue:0.22 alpha:0.95];
            phlYouTubeBottomBtn.layer.cornerRadius = 7;
            phlYouTubeBottomBtn.layer.borderWidth = 1.0;
            phlYouTubeBottomBtn.layer.borderColor = [UIColor colorWithRed:1.0 green:0.45 blue:0.55 alpha:0.85].CGColor;
            [phlYouTubeBottomBtn addTarget:self action:@selector(openYouTubeRedirect) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:phlYouTubeBottomBtn];

            phlAdminInfoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            phlAdminInfoBtn.frame = CGRectMake(12, 388, 280, 22);
            [phlAdminInfoBtn setTitle:@"🌐 ADMIN PHẠM LONG • phamlong09.store" forState:UIControlStateNormal];
            [phlAdminInfoBtn setTitleColor:[UIColor colorWithRed:0.45 green:0.95 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            phlAdminInfoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:10];
            phlAdminInfoBtn.backgroundColor = [UIColor colorWithRed:0.11 green:0.05 blue:0.22 alpha:0.92];
            phlAdminInfoBtn.layer.cornerRadius = 6;
            phlAdminInfoBtn.layer.borderWidth = 1.0;
            phlAdminInfoBtn.layer.borderColor = [UIColor colorWithRed:0.65 green:0.35 blue:1.0 alpha:0.6].CGColor;
            [phlAdminInfoBtn addTarget:self action:@selector(openAdminInfoGroup) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:phlAdminInfoBtn];

            phlCopyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 412, 288, 32)];
            phlCopyrightLabel.text = @"BẢN QUYỀN THUỘC ADMIN TELEGRAM: @PHL0990\nZALO: 0522608620";
            phlCopyrightLabel.textColor = [UIColor colorWithRed:0.88 green:0.78 blue:1.0 alpha:0.95];
            phlCopyrightLabel.font = [UIFont boldSystemFontOfSize:9];
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
        [UIView animateWithDuration:0.2 animations:^{
            phlMenuContainer.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            phlMenuContainer.alpha = 0.0;
        } completion:^(BOOL finished) {
            phlMenuContainer.hidden = YES;
        }];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    UIView *targetView = pan.view;
    if (!targetView || !targetView.superview) return;

    CGPoint translation = [pan translationInView:targetView.superview];
    CGPoint newCenter = CGPointMake(targetView.center.x + translation.x, targetView.center.y + translation.y);

    CGFloat halfW = targetView.bounds.size.width / 2.0;
    CGFloat halfH = targetView.bounds.size.height / 2.0;
    CGSize superSize = targetView.superview.bounds.size;

    newCenter.x = MAX(halfW, MIN(superSize.width - halfW, newCenter.x));
    newCenter.y = MAX(halfH, MIN(superSize.height - halfH, newCenter.y));

    targetView.center = newCenter;
    [pan setTranslation:CGPointZero inView:targetView.superview];
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
        ? [UIColor colorWithRed:0.45 green:0.15 blue:0.75 alpha:0.95]
        : [UIColor colorWithRed:0.14 green:0.07 blue:0.26 alpha:0.92];
}

- (NSURL *)resolveYouTubeTargetURL {
    NSString *targetStr = kPHLDefaultYouTubeURL;

    if (phlCurrentIndex >= 0 && phlCurrentIndex < (NSInteger)phlPlaylist.count) {
        NSDictionary *song = phlPlaylist[phlCurrentIndex];
        NSString *ytField = song[@"youtube"] ?: (song[@"youtube_url"] ?: song[@"yt"]);
        if ([ytField isKindOfClass:[NSString class]] && ytField.length > 0) {
            targetStr = ytField;
        } else {
            NSString *title = song[@"title"];
            if ([title isKindOfClass:[NSString class]] && title.length > 0) {
                NSCharacterSet *allowed = [NSCharacterSet URLQueryAllowedCharacterSet];
                NSString *encodedQuery = [title stringByAddingPercentEncodingWithAllowedCharacters:allowed];
                targetStr = [NSString stringWithFormat:@"https://m.youtube.com/results?search_query=%@", encodedQuery];
            }
        }
    }

    NSString *encodedTarget = [targetStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:encodedTarget ?: targetStr];
}

- (void)openYouTubeRedirect {
    NSURL *ytURL = [self resolveYouTubeTargetURL];
    if (!ytURL) return;
    [[UIApplication sharedApplication] openURL:ytURL options:@{} completionHandler:nil];
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

    cell.textLabel.textColor = isCurrent ? [UIColor colorWithRed:0.85 green:0.55 blue:1.0 alpha:1.0] : [UIColor whiteColor];
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
