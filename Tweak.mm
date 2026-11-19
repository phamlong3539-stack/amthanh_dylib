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

static NSString *const kPHLPrefBackgroundAudio = @"PHL_AllowBackgroundAudio";
static NSString *const kPHLPrefRepeatOne = @"PHL_RepeatOneSong";
static NSString *const kPHLPrefVolume = @"PHL_PlayerVolume";
static NSString *const kPHLDefaultYouTubeURL = @"https://www.youtube.com";

@interface PHLProtectedAudioManager : NSObject <UITableViewDataSource, UITableViewDelegate> {
    AVPlayer *phlAudioPlayer;
    AVPlayerItem *phlPlayerItem;
    id phlTimeObserver;

    UIButton *phlFloatingBtn;
    UIView *phlMenuContainer;
    UITableView *phlTableView;

    // Khu vực điều khiển trình phát chuyên nghiệp
    UILabel *phlNowPlayingLabel;
    UIButton *phlPlayPauseBtn;
    UIButton *phlRepeatBtn;
    UIButton *phlYouTubeBottomBtn;
    UISlider *phlSeekSlider;
    UILabel *phlCurrentTimeLabel;
    UILabel *phlDurationLabel;
    UISlider *phlVolumeSlider;
    UISwitch *phlBgSwitch;
    BOOL phlIsSeeking;

    NSMutableArray *phlPlaylist;
    NSString *phlStatusMessage;
    NSInteger phlCurrentIndex;
    BOOL phlIsMenuOpen;
    BOOL phlAllowBackgroundPlay;
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
        phlIsSeeking = NO;

        if ([defaults objectForKey:kPHLPrefBackgroundAudio] != nil) {
            phlAllowBackgroundPlay = [defaults boolForKey:kPHLPrefBackgroundAudio];
        } else {
            phlAllowBackgroundPlay = YES;
        }

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
        [self registerLifecycleObservers];
    }
    return self;
}

- (void)registerLifecycleObservers {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(handleDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [nc addObserver:self selector:@selector(handleWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [nc addObserver:self selector:@selector(handleItemDidFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)handleDidEnterBackground:(NSNotification *)note {
    if (phlAllowBackgroundPlay) {
        [self configureAudioSession];
        if (phlAudioPlayer && phlCurrentIndex >= 0) {
            [phlAudioPlayer play];
        }
    } else {
        if (phlAudioPlayer) {
            [phlAudioPlayer pause];
            [self syncPlayPauseButton];
        }
    }
}

- (void)handleWillEnterForeground:(NSNotification *)note {
    [self configureAudioSession];
    [self syncPlayPauseButton];
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
    if (phlAllowBackgroundPlay) {
        [session setCategory:AVAudioSessionCategoryPlayback
                 withOptions:AVAudioSessionCategoryOptionMixWithOthers
                       error:&sessionError];
    } else {
        [session setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    }
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

- (NSString *)formatTimeSeconds:(double)seconds {
    if (isnan(seconds) || isinf(seconds) || seconds < 0) return @"00:00";
    int totalSec = (int)seconds;
    int mins = totalSec / 60;
    int secs = totalSec % 60;
    return [NSString stringWithFormat:@"%02d:%02d", mins, secs];
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
            // 2. Menu trình phát nhạc chuyên nghiệp (kéo tự do toàn khung)
            phlMenuContainer = [[UIView alloc] initWithFrame:CGRectMake(76, 76, 300, 440)];
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
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, 236, 22)];
            titleLabel.text = @"👑 PHL PHAM LONG - PRO AUDIO";
            titleLabel.textColor = [UIColor colorWithRed:0.92 green:0.7 blue:1.0 alpha:1.0];
            titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [phlMenuContainer addSubview:titleLabel];

            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            closeBtn.frame = CGRectMake(256, 6, 34, 24);
            [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
            [closeBtn setTitleColor:[UIColor colorWithRed:1.0 green:0.55 blue:0.7 alpha:1.0] forState:UIControlStateNormal];
            closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [closeBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:closeBtn];

            // Tên bài đang phát
            phlNowPlayingLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 30, 276, 18)];
            phlNowPlayingLabel.text = @"♪ Chưa chọn bài hát";
            phlNowPlayingLabel.textColor = [UIColor cyanColor];
            phlNowPlayingLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
            [phlMenuContainer addSubview:phlNowPlayingLabel];

            // Thanh tua nhạc (Seek Slider) + mốc thời gian
            phlCurrentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 50, 42, 16)];
            phlCurrentTimeLabel.text = @"00:00";
            phlCurrentTimeLabel.textColor = [UIColor lightGrayColor];
            phlCurrentTimeLabel.font = [UIFont monospacedDigitSystemFontOfSize:10 weight:UIFontWeightRegular];
            [phlMenuContainer addSubview:phlCurrentTimeLabel];

            phlSeekSlider = [[UISlider alloc] initWithFrame:CGRectMake(56, 48, 188, 20)];
            phlSeekSlider.minimumValue = 0.0f;
            phlSeekSlider.maximumValue = 1.0f;
            phlSeekSlider.value = 0.0f;
            phlSeekSlider.minimumTrackTintColor = [UIColor colorWithRed:0.75 green:0.35 blue:1.0 alpha:1.0];
            phlSeekSlider.maximumTrackTintColor = [UIColor colorWithWhite:0.25 alpha:1.0];
            [phlSeekSlider addTarget:self action:@selector(seekSliderTouchDown:) forControlEvents:UIControlEventTouchDown];
            [phlSeekSlider addTarget:self action:@selector(seekSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            [phlSeekSlider addTarget:self action:@selector(seekSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
            [phlMenuContainer addSubview:phlSeekSlider];

            phlDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(246, 50, 42, 16)];
            phlDurationLabel.text = @"00:00";
            phlDurationLabel.textColor = [UIColor lightGrayColor];
            phlDurationLabel.font = [UIFont monospacedDigitSystemFontOfSize:10 weight:UIFontWeightRegular];
            phlDurationLabel.textAlignment = NSTextAlignmentRight;
            [phlMenuContainer addSubview:phlDurationLabel];

            // Hàng nút điều khiển: -10s | Prev | Play/Pause | Next | +10s | Lặp
            CGFloat ctrlY = 72;
            NSArray *titles = @[@"-10s", @"⏮", @"▶", @"⏭", @"+10s", @"🔁"];
            NSArray *selectors = @[
                NSStringFromSelector(@selector(rewind10s)),
                NSStringFromSelector(@selector(playPreviousSong)),
                NSStringFromSelector(@selector(togglePlayPause)),
                NSStringFromSelector(@selector(playNextSong)),
                NSStringFromSelector(@selector(forward10s)),
                NSStringFromSelector(@selector(toggleRepeatMode))
            ];
            CGFloat btnW = 43.0f;
            CGFloat gap = 3.5f;
            CGFloat startX = 12.0f;

            for (NSInteger i = 0; i < (NSInteger)titles.count; i++) {
                UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
                b.frame = CGRectMake(startX + i * (btnW + gap), ctrlY, btnW, 28);
                [b setTitle:titles[i] forState:UIControlStateNormal];
                b.titleLabel.font = [UIFont boldSystemFontOfSize:(i == 0 || i == 4) ? 10 : 13];
                b.backgroundColor = [UIColor colorWithRed:0.14 green:0.07 blue:0.26 alpha:0.9];
                b.layer.cornerRadius = 7;
                b.layer.borderWidth = 1.0;
                b.layer.borderColor = [UIColor colorWithRed:0.6 green:0.3 blue:0.95 alpha:0.6].CGColor;
                [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [b addTarget:self action:NSSelectorFromString(selectors[i]) forControlEvents:UIControlEventTouchUpInside];

                if (i == 2) phlPlayPauseBtn = b;
                if (i == 5) {
                    phlRepeatBtn = b;
                    [self syncRepeatButton];
                }
                [phlMenuContainer addSubview:b];
            }

            // Thanh chỉnh / giảm âm lượng
            UIButton *muteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            muteBtn.frame = CGRectMake(12, 106, 36, 24);
            [muteBtn setTitle:@"🔉" forState:UIControlStateNormal];
            muteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [muteBtn addTarget:self action:@selector(decreaseVolumeStep) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:muteBtn];

            phlVolumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(52, 108, 196, 20)];
            phlVolumeSlider.minimumValue = 0.0f;
            phlVolumeSlider.maximumValue = 1.0f;
            phlVolumeSlider.value = phlCurrentVolume;
            phlVolumeSlider.minimumTrackTintColor = [UIColor cyanColor];
            phlVolumeSlider.maximumTrackTintColor = [UIColor colorWithWhite:0.25 alpha:1.0];
            [phlVolumeSlider addTarget:self action:@selector(volumeSliderChanged:) forControlEvents:UIControlEventValueChanged];
            [phlMenuContainer addSubview:phlVolumeSlider];

            UIButton *volUpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            volUpBtn.frame = CGRectMake(252, 106, 36, 24);
            [volUpBtn setTitle:@"🔊" forState:UIControlStateNormal];
            volUpBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [volUpBtn addTarget:self action:@selector(increaseVolumeStep) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:volUpBtn];

            // Công tắc cho phép nghe nhạc khi thoát / ẩn ứng dụng
            UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 134, 215, 26)];
            bgLabel.text = @"Nghe nhạc khi thoát / ẩn app";
            bgLabel.textColor = [UIColor colorWithRed:0.9 green:0.85 blue:1.0 alpha:1.0];
            bgLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
            [phlMenuContainer addSubview:bgLabel];

            phlBgSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(235, 132, 51, 31)];
            phlBgSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
            phlBgSwitch.on = phlAllowBackgroundPlay;
            phlBgSwitch.onTintColor = [UIColor colorWithRed:0.75 green:0.35 blue:1.0 alpha:1.0];
            [phlBgSwitch addTarget:self action:@selector(bgSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            [phlMenuContainer addSubview:phlBgSwitch];

            // Thanh chuyển ứng dụng nhanh
            NSArray *appLabels = @[@"TikTok", @"YouTube", @"Telegram"];
            NSArray *appSchemes = @[@"snssdk1233://", @"youtube://", @"tg://"];
            CGFloat appBtnW = 88.0f;
            CGFloat appGap = 6.0f;
            for (NSInteger j = 0; j < (NSInteger)appLabels.count; j++) {
                UIButton *appBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                appBtn.frame = CGRectMake(12 + j * (appBtnW + appGap), 164, appBtnW, 24);
                [appBtn setTitle:[NSString stringWithFormat:@"⇄ %@", appLabels[j]] forState:UIControlStateNormal];
                appBtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightSemibold];
                [appBtn setTitleColor:[UIColor colorWithRed:0.85 green:0.95 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                appBtn.backgroundColor = [UIColor colorWithRed:0.08 green:0.12 blue:0.24 alpha:0.9];
                appBtn.layer.cornerRadius = 6;
                objc_setAssociatedObject(appBtn, "phlSchemeKey", appSchemes[j], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [appBtn addTarget:self action:@selector(openExternalApp:) forControlEvents:UIControlEventTouchUpInside];
                [phlMenuContainer addSubview:appBtn];
            }

            // Danh sách bài hát
            phlTableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 194, 284, 200) style:UITableViewStylePlain];
            phlTableView.backgroundColor = [UIColor clearColor];
            phlTableView.separatorColor = [UIColor colorWithWhite:0.22 alpha:1.0];
            phlTableView.delegate = self;
            phlTableView.dataSource = self;
            [phlMenuContainer addSubview:phlTableView];

            // Nút chuyển hướng YouTube cố định ở dưới cùng menu
            phlYouTubeBottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            phlYouTubeBottomBtn.frame = CGRectMake(12, 400, 276, 30);
            [phlYouTubeBottomBtn setTitle:@"▶ Chuyển sang YouTube nghe nhạc" forState:UIControlStateNormal];
            [phlYouTubeBottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            phlYouTubeBottomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:11];
            phlYouTubeBottomBtn.backgroundColor = [UIColor colorWithRed:0.72 green:0.12 blue:0.22 alpha:0.95];
            phlYouTubeBottomBtn.layer.cornerRadius = 8;
            phlYouTubeBottomBtn.layer.borderWidth = 1.0;
            phlYouTubeBottomBtn.layer.borderColor = [UIColor colorWithRed:1.0 green:0.45 blue:0.55 alpha:0.85].CGColor;
            [phlYouTubeBottomBtn addTarget:self action:@selector(openYouTubeRedirect) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:phlYouTubeBottomBtn];

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

- (void)setupTimeObserver {
    if (!phlAudioPlayer) return;
    if (phlTimeObserver) {
        [phlAudioPlayer removeTimeObserver:phlTimeObserver];
        phlTimeObserver = nil;
    }

    __weak typeof(self) weakSelf = self;
    CMTime interval = CMTimeMakeWithSeconds(0.5, NSEC_PER_SEC);
    phlTimeObserver = [phlAudioPlayer addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || strongSelf->phlIsSeeking) return;

        double currentSec = CMTimeGetSeconds(time);
        CMTime durTime = strongSelf->phlAudioPlayer.currentItem.duration;
        double totalSec = CMTimeGetSeconds(durTime);

        strongSelf->phlCurrentTimeLabel.text = [strongSelf formatTimeSeconds:currentSec];
        if (!isnan(totalSec) && !isinf(totalSec) && totalSec > 0) {
            strongSelf->phlDurationLabel.text = [strongSelf formatTimeSeconds:totalSec];
            strongSelf->phlSeekSlider.value = (float)MAX(0.0, MIN(1.0, currentSec / totalSec));
        } else {
            strongSelf->phlDurationLabel.text = @"00:00";
            strongSelf->phlSeekSlider.value = 0.0f;
        }
    }];
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
    phlSeekSlider.value = 0.0f;
    phlCurrentTimeLabel.text = @"00:00";
    phlDurationLabel.text = @"00:00";

    phlPlayerItem = [AVPlayerItem playerItemWithURL:url];
    if (!phlAudioPlayer) {
        phlAudioPlayer = [AVPlayer playerWithPlayerItem:phlPlayerItem];
    } else {
        [phlAudioPlayer replaceCurrentItemWithPlayerItem:phlPlayerItem];
    }
    phlAudioPlayer.volume = phlCurrentVolume;
    [self setupTimeObserver];
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

- (void)rewind10s {
    [self seekByOffsetSeconds:-10.0];
}

- (void)forward10s {
    [self seekByOffsetSeconds:10.0];
}

- (void)seekByOffsetSeconds:(double)delta {
    if (!phlAudioPlayer || !phlAudioPlayer.currentItem) return;
    double cur = CMTimeGetSeconds(phlAudioPlayer.currentTime);
    double dur = CMTimeGetSeconds(phlAudioPlayer.currentItem.duration);
    if (isnan(cur) || isinf(cur)) cur = 0;

    double target = MAX(0.0, cur + delta);
    if (!isnan(dur) && !isinf(dur) && dur > 0) {
        target = MIN(dur, target);
    }

    CMTime targetTime = CMTimeMakeWithSeconds(target, NSEC_PER_SEC);
    [phlAudioPlayer seekToTime:targetTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    phlCurrentTimeLabel.text = [self formatTimeSeconds:target];
}

- (void)seekSliderTouchDown:(UISlider *)slider {
    phlIsSeeking = YES;
}

- (void)seekSliderValueChanged:(UISlider *)slider {
    if (!phlAudioPlayer || !phlAudioPlayer.currentItem) return;
    double dur = CMTimeGetSeconds(phlAudioPlayer.currentItem.duration);
    if (!isnan(dur) && !isinf(dur) && dur > 0) {
        phlCurrentTimeLabel.text = [self formatTimeSeconds:(slider.value * dur)];
    }
}

- (void)seekSliderTouchEnded:(UISlider *)slider {
    if (!phlAudioPlayer || !phlAudioPlayer.currentItem) {
        phlIsSeeking = NO;
        return;
    }
    double dur = CMTimeGetSeconds(phlAudioPlayer.currentItem.duration);
    if (!isnan(dur) && !isinf(dur) && dur > 0) {
        double target = slider.value * dur;
        CMTime targetTime = CMTimeMakeWithSeconds(target, NSEC_PER_SEC);
        [phlAudioPlayer seekToTime:targetTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                phlIsSeeking = NO;
            });
        }];
    } else {
        phlIsSeeking = NO;
    }
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
        : [UIColor colorWithRed:0.14 green:0.07 blue:0.26 alpha:0.9];
}

- (void)bgSwitchChanged:(UISwitch *)sender {
    phlAllowBackgroundPlay = sender.on;
    [[NSUserDefaults standardUserDefaults] setBool:phlAllowBackgroundPlay forKey:kPHLPrefBackgroundAudio];
    [self configureAudioSession];
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

    if (phlAllowBackgroundPlay && phlAudioPlayer && phlCurrentIndex >= 0) {
        [self configureAudioSession];
    } else if (phlAudioPlayer) {
        [phlAudioPlayer pause];
        [self syncPlayPauseButton];
    }

    [[UIApplication sharedApplication] openURL:ytURL options:@{} completionHandler:nil];
}

- (void)openExternalApp:(UIButton *)sender {
    NSString *scheme = objc_getAssociatedObject(sender, "phlSchemeKey");
    if (!scheme || scheme.length == 0) return;
    NSURL *appURL = [NSURL URLWithString:scheme];
    if (!appURL) return;

    if (phlAllowBackgroundPlay && phlAudioPlayer && phlCurrentIndex >= 0) {
        [self configureAudioSession];
        [phlAudioPlayer play];
    }

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
