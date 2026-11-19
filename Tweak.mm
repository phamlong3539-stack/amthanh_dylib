#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
#import <QuartzCore/QuartzCore.h>
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
static NSString *const kPHLPrefGain = @"PHL_IndependentAudioGain";
static NSString *const kPHLAdminInfoURL = @"https://phamlong09.store";
static NSString *const kPHLYouTubeHomeURL = @"https://m.youtube.com";

static NSString *const kPHLCleanYouTubeJS =
@"(function(){"
"  function cleanYT(){"
"    var selectors = ["
"      'ytm-mobile-topbar-renderer',"
"      'ytm-search-header',"
"      'header.mobile-topbar-header',"
"      '[role=\"search\"]',"
"      'ytm-pivot-bar-renderer',"
"      'ytm-bottom-nav-bar',"
"      'nav.pivot-bar',"
"      '.pivot-bar-container'"
"    ];"
"    selectors.forEach(function(sel){"
"      document.querySelectorAll(sel).forEach(function(el){"
"        el.style.setProperty('display', 'none', 'important');"
"        el.style.setProperty('height', '0px', 'important');"
"        el.style.setProperty('visibility', 'hidden', 'important');"
"      });"
"    });"
"    var pageMgr = document.querySelector('ytm-page-manager, #app, ytm-app');"
"    if (pageMgr) {"
"      pageMgr.style.setProperty('padding-top', '0px', 'important');"
"      pageMgr.style.setProperty('margin-top', '0px', 'important');"
"      pageMgr.style.setProperty('padding-bottom', '0px', 'important');"
"    }"
"    var styleId = 'phl-yt-clean-style';"
"    if (!document.getElementById(styleId)) {"
"      var st = document.createElement('style');"
"      st.id = styleId;"
"      st.textContent = "
"        'ytm-mobile-topbar-renderer, ytm-search-header, header, ytm-pivot-bar-renderer, ytm-bottom-nav-bar, nav.pivot-bar { display: none !important; height: 0 !important; }' "
"        'ytm-browse, ytm-search { padding-top: 0 !important; margin-top: 0 !important; }';"
"      (document.head || document.documentElement).appendChild(st);"
"    }"
"  }"
"  cleanYT();"
"  setTimeout(cleanYT, 400);"
"  setTimeout(cleanYT, 1200);"
"  if (!window.__phlYTObserver && document.body) {"
"    window.__phlYTObserver = new MutationObserver(function(){ cleanYT(); });"
"    window.__phlYTObserver.observe(document.body, { childList: true, subtree: true });"
"  }"
"})();";

static NSString *const kPHLWebAudioBridgeJS =
@"(function(){"
"  if (!window.__phlAudioBridge) {"
"    window.__phlAudioBridge = {"
"      gain: 1.0,"
"      ctx: null,"
"      nodes: new WeakMap(),"
"      pauseAll: function(){"
"        document.querySelectorAll('video,audio').forEach(function(el){ try { el.pause(); } catch(e){} });"
"      },"
"      ensureContext: function(){"
"        if (!this.ctx) {"
"          var AC = window.AudioContext || window.webkitAudioContext;"
"          if (AC) { try { this.ctx = new AC(); } catch(e){} }"
"        }"
"        if (this.ctx && this.ctx.state === 'suspended') {"
"          this.ctx.resume().catch(function(){});"
"        }"
"      },"
"      hookElement: function(el){"
"        var self = this;"
"        if (!el.__phlPlayHooked) {"
"          el.__phlPlayHooked = true;"
"          el.addEventListener('play', function(){"
"            self.applyToElement(el);"
"            if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.phlWebMediaPlaying) {"
"              window.webkit.messageHandlers.phlWebMediaPlaying.postMessage('playing');"
"            }"
"          }, true);"
"        }"
"        self.applyToElement(el);"
"      },"
"      applyToElement: function(el){"
"        var g = Math.max(0.0, Math.min(2.0, this.gain));"
"        try {"
"          el.muted = (g <= 0.001);"
"          el.volume = Math.min(1.0, g);"
"        } catch(e){}"
"        if (g > 1.0) {"
"          this.ensureContext();"
"          if (this.ctx) {"
"            try {"
"              var entry = this.nodes.get(el);"
"              if (!entry) {"
"                var src = this.ctx.createMediaElementSource(el);"
"                var gainNode = this.ctx.createGain();"
"                src.connect(gainNode);"
"                gainNode.connect(this.ctx.destination);"
"                entry = { gainNode: gainNode };"
"                this.nodes.set(el, entry);"
"              }"
"              entry.gainNode.gain.setTargetAtTime(g, this.ctx.currentTime, 0.02);"
"            } catch(e){}"
"          }"
"        } else {"
"          var existing = this.nodes.get(el);"
"          if (existing && existing.gainNode && this.ctx) {"
"            try { existing.gainNode.gain.setTargetAtTime(g, this.ctx.currentTime, 0.02); } catch(e){}"
"          }"
"        }"
"      },"
"      setGain: function(val){"
"        this.gain = Math.max(0.0, Math.min(2.0, parseFloat(val) || 0.0));"
"        var self = this;"
"        document.querySelectorAll('video,audio').forEach(function(el){ self.hookElement(el); });"
"      }"
"    };"
"  }"
"})();";

@interface PHLProtectedAudioManager : NSObject <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, WKNavigationDelegate, WKScriptMessageHandler> {
    AVPlayer *phlAudioPlayer;
    AVPlayerItem *phlPlayerItem;

    UIButton *phlFloatingBtn;
    UIView *phlMenuContainer;
    CAGradientLayer *phlMenuGradient;
    UIView *phlDragHeader;
    UIButton *phlCloseBtn;
    UITableView *phlTableView;

    // Khu vực điều khiển chính
    UILabel *phlNowPlayingLabel;
    UIButton *phlPrevBtn;
    UIButton *phlPlayPauseBtn;
    UIButton *phlNextBtn;
    UIButton *phlRepeatBtn;
    UIButton *phlMuteBtn;
    UIButton *phlVolUpBtn;
    UISlider *phlVolumeSlider;
    UILabel *phlGainValueLabel;

    // Trình duyệt web nhúng & tìm kiếm YouTube trong menu
    UIButton *phlOpenBrowserBtn;
    UIView *phlWebPanel;
    UIButton *phlBackBtn;
    UIButton *phlFwdBtn;
    UIButton *phlHomeYtBtn;
    UIButton *phlCloseWebBtn;
    UITextField *phlYouTubeSearchField;
    UIButton *phlYtSearchBtn;
    WKWebView *phlWebView;
    BOOL phlIsWebOpen;
    BOOL phlHasLoadedInitialWeb;

    // Chân bản quyền cố định dưới cùng
    UIButton *phlAdminInfoBtn;
    UILabel *phlCopyrightLabel;

    NSMutableArray *phlPlaylist;
    NSString *phlStatusMessage;
    NSInteger phlCurrentIndex;
    BOOL phlIsMenuOpen;
    BOOL phlRepeatOne;
    float phlCurrentGain; // 0.0 -> 2.0 (1.0 = chuẩn 100%, > 1.0 = tăng vượt mức âm lượng máy)
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

        if ([defaults objectForKey:kPHLPrefGain] != nil) {
            phlCurrentGain = [defaults floatForKey:kPHLPrefGain];
        } else {
            phlCurrentGain = 1.0f;
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
    // Dùng Playback độc lập, không ép đè trộn lẫn lung tung
    [session setCategory:AVAudioSessionCategoryPlayback
             withOptions:AVAudioSessionCategoryOptionAllowAirPlay
                   error:&sessionError];
    [session setActive:YES error:&sessionError];
}

- (void)pauseWebMediaIfPlaying {
    if (!phlWebView) return;
    NSString *js = @"(function(){ if (window.__phlAudioBridge) { window.__phlAudioBridge.pauseAll(); } document.querySelectorAll('video,audio').forEach(function(el){ try { el.pause(); } catch(e){} }); })();";
    [phlWebView evaluateJavaScript:js completionHandler:nil];
}

- (void)pauseGitHubPlayerIfPlaying {
    if (phlAudioPlayer && phlAudioPlayer.rate > 0.01f) {
        [phlAudioPlayer pause];
        [self syncPlayPauseButton];
    }
}

- (void)applyGainToItem:(AVPlayerItem *)item gain:(float)gain {
    if (!item || !item.asset) return;
    AVAsset *asset = item.asset;
    [asset loadTracksWithMediaType:AVMediaTypeAudio completionHandler:^(NSArray<AVAssetTrack *> * _Nullable audioTracks, NSError * _Nullable error) {
        if (error || audioTracks.count == 0) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
            NSMutableArray<AVMutableAudioMixInputParameters *> *params = [NSMutableArray array];
            for (AVAssetTrack *track in audioTracks) {
                AVMutableAudioMixInputParameters *p = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
                [p setVolume:gain atTime:kCMTimeZero];
                [params addObject:p];
            }
            audioMix.inputParameters = params;
            item.audioMix = audioMix;
        });
    }];
}

- (void)applyIndependentGain:(float)gain {
    float clamped = MAX(0.0f, MIN(2.0f, gain));
    phlCurrentGain = clamped;
    [[NSUserDefaults standardUserDefaults] setFloat:clamped forKey:kPHLPrefGain];

    if (phlGainValueLabel) {
        int pct = (int)roundf(clamped * 100.0f);
        phlGainValueLabel.text = [NSString stringWithFormat:@"%d%%", pct];
        phlGainValueLabel.textColor = (clamped > 1.0f)
            ? [UIColor colorWithRed:1.0 green:0.45 blue:0.65 alpha:1.0]
            : [UIColor colorWithRed:0.45 green:0.98 blue:1.0 alpha:1.0];
    }

    // 1. Nhạc GitHub (AVPlayer): chỉnh volume chuẩn tới 1.0 và boost tới 2.0 qua audioMix
    if (phlAudioPlayer) {
        phlAudioPlayer.muted = (clamped <= 0.001f);
        phlAudioPlayer.volume = MIN(1.0f, clamped);
        if (phlPlayerItem) {
            [self applyGainToItem:phlPlayerItem gain:clamped];
        }
    }

    // 2. Trình duyệt web (WKWebView): chỉnh độc lập tới 2.0x qua GainNode mà không chạm vào nút âm lượng máy
    if (phlWebView) {
        NSString *js = [NSString stringWithFormat:
                        @"%@; if (window.__phlAudioBridge) { window.__phlAudioBridge.setGain(%.3f); }",
                        kPHLWebAudioBridgeJS, clamped];
        [phlWebView evaluateJavaScript:js completionHandler:nil];
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"phlWebMediaPlaying"]) {
        // Khi người dùng bấm phát nhạc/video trên YouTube trong menu thì tự dừng nhạc GitHub để không xung đột
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pauseGitHubPlayerIfPlaying];
            [self applyIndependentGain:phlCurrentGain];
        });
    }
}

- (void)cleanYouTubePageInWebView {
    if (!phlWebView) return;
    [phlWebView evaluateJavaScript:kPHLCleanYouTubeJS completionHandler:nil];
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
    btn.layer.borderWidth = 1.1;
    btn.layer.borderColor = borderColor.CGColor;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)layoutMenuSubviewsWithWidth:(CGFloat)menuW height:(CGFloat)menuH expanded:(BOOL)expanded {
    CGFloat padX = 10.0f;
    CGFloat innerW = menuW - padX * 2.0f;

    phlMenuGradient.frame = CGRectMake(0, 0, menuW, menuH);
    phlDragHeader.frame = CGRectMake(0, 0, menuW, 42.0f);
    phlCloseBtn.frame = CGRectMake(menuW - 34.0f, 8.0f, 24.0f, 24.0f);

    phlPrevBtn.hidden = expanded;
    phlPlayPauseBtn.hidden = expanded;
    phlNextBtn.hidden = expanded;
    phlRepeatBtn.hidden = expanded;

    CGFloat volY = 0.0f;
    CGFloat webToggleY = 0.0f;
    CGFloat contentY = 0.0f;

    if (expanded) {
        volY = 44.0f;
        webToggleY = 68.0f;
        contentY = 95.0f;
    } else {
        CGFloat gap = 6.0f;
        CGFloat btnW = (innerW - gap * 3.0f) / 4.0f;
        CGFloat ctrlY = 46.0f;
        phlPrevBtn.frame = CGRectMake(padX, ctrlY, btnW, 24.0f);
        phlPlayPauseBtn.frame = CGRectMake(padX + (btnW + gap), ctrlY, btnW, 24.0f);
        phlNextBtn.frame = CGRectMake(padX + (btnW + gap) * 2.0f, ctrlY, btnW, 24.0f);
        phlRepeatBtn.frame = CGRectMake(padX + (btnW + gap) * 3.0f, ctrlY, btnW, 24.0f);

        volY = 74.0f;
        webToggleY = 99.0f;
        contentY = 126.0f;
    }

    CGFloat gainBadgeW = 34.0f;
    phlMuteBtn.frame = CGRectMake(padX, volY, 24.0f, 22.0f);
    phlVolumeSlider.frame = CGRectMake(padX + 26.0f, volY, MAX(60.0f, innerW - 26.0f - 24.0f - gainBadgeW - 2.0f), 22.0f);
    phlVolUpBtn.frame = CGRectMake(menuW - padX - gainBadgeW - 26.0f, volY, 24.0f, 22.0f);
    phlGainValueLabel.frame = CGRectMake(menuW - padX - gainBadgeW, volY, gainBadgeW, 22.0f);

    phlOpenBrowserBtn.frame = CGRectMake(padX, webToggleY, innerW, 23.0f);

    CGFloat footerHeight = 48.0f;
    CGFloat contentH = MAX(120.0f, menuH - contentY - footerHeight - 4.0f);

    phlTableView.frame = CGRectMake(8.0f, contentY, menuW - 16.0f, contentH);
    phlWebPanel.frame = CGRectMake(8.0f, contentY, menuW - 16.0f, contentH);

    CGFloat panelW = phlWebPanel.bounds.size.width;
    CGFloat panelH = phlWebPanel.bounds.size.height;

    phlBackBtn.frame = CGRectMake(4.0f, 4.0f, 24.0f, 21.0f);
    phlFwdBtn.frame = CGRectMake(31.0f, 4.0f, 24.0f, 21.0f);
    phlHomeYtBtn.frame = CGRectMake(58.0f, 4.0f, 38.0f, 21.0f);
    phlCloseWebBtn.frame = CGRectMake(panelW - 60.0f, 4.0f, 56.0f, 21.0f);

    CGFloat searchBtnW = 46.0f;
    CGFloat searchFieldW = MAX(90.0f, panelW - 8.0f - searchBtnW - 4.0f);
    phlYouTubeSearchField.frame = CGRectMake(4.0f, 28.0f, searchFieldW, 22.0f);
    phlYtSearchBtn.frame = CGRectMake(4.0f + searchFieldW + 4.0f, 28.0f, searchBtnW, 22.0f);

    CGFloat webTop = 53.0f;
    phlWebView.frame = CGRectMake(0.0f, webTop, panelW, MAX(80.0f, panelH - webTop));

    CGFloat infoBtnY = menuH - footerHeight;
    phlAdminInfoBtn.frame = CGRectMake(padX, infoBtnY, innerW, 20.0f);
    phlCopyrightLabel.frame = CGRectMake(6.0f, infoBtnY + 20.0f, menuW - 12.0f, 27.0f);
}

- (void)applyMenuFrameForExpanded:(BOOL)expanded animated:(BOOL)animated {
    UIWindow *keyWindow = [self resolveActiveWindow];
    if (!keyWindow || !phlMenuContainer) return;

    CGFloat screenW = keyWindow.bounds.size.width;
    CGFloat screenH = keyWindow.bounds.size.height;

    CGFloat compactW = MIN(312.0f, screenW - 86.0f);
    if (compactW < 268.0f) compactW = MIN(300.0f, screenW - 20.0f);

    CGFloat expandedW = MAX(compactW, MIN(580.0f, screenW - 74.0f));
    if (expandedW < 280.0f) expandedW = MAX(compactW, screenW - 14.0f);

    CGFloat compactH = MIN(322.0f, MAX(250.0f, screenH - 24.0f));
    CGFloat expandedH = MAX(compactH, MIN(700.0f, screenH - 10.0f));

    CGFloat targetW = expanded ? expandedW : compactW;
    CGFloat targetH = expanded ? expandedH : compactH;

    CGFloat curX = phlMenuContainer.frame.origin.x;
    CGFloat maxX = MAX(8.0f, screenW - targetW - 8.0f);
    CGFloat targetX = expanded ? MIN(maxX, MAX(70.0f, (screenW - targetW) * 0.56f))
                               : MAX(8.0f, MIN(maxX, curX));

    CGFloat targetY = expanded ? 5.0f
                               : MAX(12.0f, MIN(screenH - targetH - 8.0f, phlMenuContainer.frame.origin.y));

    CGRect targetFrame = CGRectMake(targetX, targetY, targetW, targetH);

    void (^applyBlock)(void) = ^{
        phlMenuContainer.frame = targetFrame;
        [self layoutMenuSubviewsWithWidth:targetW height:targetH expanded:expanded];
        [phlMenuContainer layoutIfNeeded];
    };

    if (animated) {
        [UIView animateWithDuration:0.22
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:applyBlock
                         completion:nil];
    } else {
        applyBlock();
    }
}

- (void)initializeFramework {
    preventDebugging();

    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [self resolveActiveWindow];
        if (!keyWindow) return;

        CGFloat screenW = keyWindow.bounds.size.width;
        CGFloat menuW = MIN(312.0f, screenW - 86.0f);
        if (menuW < 268.0f) menuW = MIN(300.0f, screenW - 20.0f);
        CGFloat menuH = MIN(322.0f, MAX(250.0f, keyWindow.bounds.size.height - 24.0f));

        if (!phlFloatingBtn) {
            phlFloatingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            phlFloatingBtn.frame = CGRectMake(16, 118, 48, 48);
            phlFloatingBtn.layer.cornerRadius = 24;
            phlFloatingBtn.clipsToBounds = YES;
            phlFloatingBtn.layer.borderWidth = 2.2;
            phlFloatingBtn.layer.borderColor = [UIColor colorWithRed:0.88 green:0.35 blue:1.0 alpha:1.0].CGColor;
            phlFloatingBtn.backgroundColor = [UIColor colorWithRed:0.08 green:0.03 blue:0.2 alpha:0.96];
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
            phlMenuContainer = [[UIView alloc] initWithFrame:CGRectMake(70, 16, menuW, menuH)];
            phlMenuContainer.backgroundColor = [UIColor colorWithRed:0.06 green:0.02 blue:0.16 alpha:0.98];
            phlMenuContainer.layer.cornerRadius = 16;
            phlMenuContainer.layer.borderWidth = 1.6;
            phlMenuContainer.layer.borderColor = [UIColor colorWithRed:0.85 green:0.42 blue:1.0 alpha:0.95].CGColor;
            phlMenuContainer.clipsToBounds = YES;
            phlMenuContainer.hidden = YES;
            phlMenuContainer.alpha = 0.0;

            phlMenuGradient = [CAGradientLayer layer];
            phlMenuGradient.frame = CGRectMake(0, 0, menuW, menuH);
            phlMenuGradient.colors = @[
                (id)[UIColor colorWithRed:0.13 green:0.03 blue:0.28 alpha:1.0].CGColor,
                (id)[UIColor colorWithRed:0.23 green:0.05 blue:0.36 alpha:1.0].CGColor,
                (id)[UIColor colorWithRed:0.05 green:0.11 blue:0.27 alpha:1.0].CGColor
            ];
            phlMenuGradient.startPoint = CGPointMake(0.0f, 0.0f);
            phlMenuGradient.endPoint = CGPointMake(1.0f, 1.0f);
            [phlMenuContainer.layer insertSublayer:phlMenuGradient atIndex:0];

            // Thanh tiêu đề kéo di chuyển
            phlDragHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuW, 42)];
            phlDragHeader.backgroundColor = [UIColor colorWithRed:0.18 green:0.06 blue:0.35 alpha:0.85];
            [phlMenuContainer addSubview:phlDragHeader];

            UIPanGestureRecognizer *headerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMenuHeaderPan:)];
            [phlDragHeader addGestureRecognizer:headerPan];

            UILabel *dragGripLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, menuW - 48, 9)];
            dragGripLabel.text = @"⋮⋮ KÉO THANH NÀY ĐỂ DI CHUYỂN";
            dragGripLabel.textColor = [UIColor colorWithRed:0.45 green:0.96 blue:1.0 alpha:0.9];
            dragGripLabel.font = [UIFont systemFontOfSize:7.5 weight:UIFontWeightBold];
            [phlDragHeader addSubview:dragGripLabel];

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, menuW - 48, 15)];
            titleLabel.text = @"👑 PHL PHAM LONG • AUDIO PRO";
            titleLabel.textColor = [UIColor colorWithRed:1.0 green:0.82 blue:1.0 alpha:1.0];
            titleLabel.font = [UIFont systemFontOfSize:11.5 weight:UIFontWeightHeavy];
            [phlDragHeader addSubview:titleLabel];

            phlNowPlayingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 27, menuW - 44, 13)];
            phlNowPlayingLabel.text = @"♪ Chưa chọn bài hát";
            phlNowPlayingLabel.textColor = [UIColor colorWithRed:0.38 green:1.0 blue:0.82 alpha:1.0];
            phlNowPlayingLabel.font = [UIFont systemFontOfSize:9.5 weight:UIFontWeightSemibold];
            [phlDragHeader addSubview:phlNowPlayingLabel];

            phlCloseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            phlCloseBtn.frame = CGRectMake(menuW - 34, 8, 24, 24);
            [phlCloseBtn setTitle:@"✕" forState:UIControlStateNormal];
            [phlCloseBtn setTitleColor:[UIColor colorWithRed:1.0 green:0.55 blue:0.78 alpha:1.0] forState:UIControlStateNormal];
            phlCloseBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
            phlCloseBtn.backgroundColor = [UIColor colorWithRed:0.35 green:0.06 blue:0.25 alpha:0.9];
            phlCloseBtn.layer.cornerRadius = 12;
            [phlCloseBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:phlCloseBtn];

            // Cụm điều khiển nhạc GitHub (tự ẩn khi mở YouTube)
            UIColor *ctrlBg = [UIColor colorWithRed:0.22 green:0.08 blue:0.42 alpha:0.92];
            UIColor *ctrlBorder = [UIColor colorWithRed:0.85 green:0.42 blue:1.0 alpha:0.85];

            phlPrevBtn = [self makeControlButtonWithTitle:@"⏮"
                                                 fontSize:13
                                                  bgColor:ctrlBg
                                              borderColor:ctrlBorder
                                                   action:@selector(playPreviousSong)];
            [phlMenuContainer addSubview:phlPrevBtn];

            phlPlayPauseBtn = [self makeControlButtonWithTitle:@"▶"
                                                    fontSize:14
                                                     bgColor:[UIColor colorWithRed:0.78 green:0.16 blue:0.76 alpha:0.96]
                                                 borderColor:[UIColor colorWithRed:0.42 green:0.96 blue:1.0 alpha:0.95]
                                                      action:@selector(togglePlayPause)];
            [phlMenuContainer addSubview:phlPlayPauseBtn];

            phlNextBtn = [self makeControlButtonWithTitle:@"⏭"
                                                 fontSize:13
                                                  bgColor:ctrlBg
                                              borderColor:ctrlBorder
                                                   action:@selector(playNextSong)];
            [phlMenuContainer addSubview:phlNextBtn];

            phlRepeatBtn = [self makeControlButtonWithTitle:@"🔁"
                                                   fontSize:13
                                                    bgColor:ctrlBg
                                                borderColor:ctrlBorder
                                                     action:@selector(toggleRepeatMode)];
            [self syncRepeatButton];
            [phlMenuContainer addSubview:phlRepeatBtn];

            // Thanh Gain âm thanh độc lập (0% -> 200%, không đụng âm lượng máy)
            phlMuteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [phlMuteBtn setTitle:@"🔉" forState:UIControlStateNormal];
            phlMuteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [phlMuteBtn addTarget:self action:@selector(decreaseVolumeStep) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:phlMuteBtn];

            phlVolumeSlider = [[UISlider alloc] initWithFrame:CGRectZero];
            phlVolumeSlider.minimumValue = 0.0f;
            phlVolumeSlider.maximumValue = 2.0f;
            phlVolumeSlider.value = phlCurrentGain;
            phlVolumeSlider.minimumTrackTintColor = [UIColor colorWithRed:0.35 green:0.98 blue:1.0 alpha:1.0];
            phlVolumeSlider.maximumTrackTintColor = [UIColor colorWithRed:0.95 green:0.35 blue:0.75 alpha:0.35];
            phlVolumeSlider.thumbTintColor = [UIColor colorWithRed:1.0 green:0.88 blue:0.35 alpha:1.0];
            [phlVolumeSlider addTarget:self action:@selector(volumeSliderChanged:) forControlEvents:UIControlEventValueChanged];
            [phlMenuContainer addSubview:phlVolumeSlider];

            phlVolUpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [phlVolUpBtn setTitle:@"🔊" forState:UIControlStateNormal];
            phlVolUpBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [phlVolUpBtn addTarget:self action:@selector(increaseVolumeStep) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:phlVolUpBtn];

            phlGainValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            phlGainValueLabel.font = [UIFont monospacedDigitSystemFontOfSize:9 weight:UIFontWeightBold];
            phlGainValueLabel.textAlignment = NSTextAlignmentRight;
            [phlMenuContainer addSubview:phlGainValueLabel];

            // Nút chuyển chế độ trình duyệt YouTube / Danh sách GitHub
            phlOpenBrowserBtn = [self makeControlButtonWithTitle:@"🌐 MỞ YOUTUBE (PHÓNG RỘNG)"
                                                        fontSize:9.5
                                                         bgColor:[UIColor colorWithRed:0.12 green:0.24 blue:0.48 alpha:0.95]
                                                     borderColor:[UIColor colorWithRed:0.38 green:0.95 blue:1.0 alpha:0.9]
                                                          action:@selector(toggleEmbeddedBrowser)];
            [phlOpenBrowserBtn setTitleColor:[UIColor colorWithRed:0.65 green:0.98 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            [phlMenuContainer addSubview:phlOpenBrowserBtn];

            // Danh sách nhạc GitHub
            phlTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            phlTableView.backgroundColor = [UIColor colorWithRed:0.06 green:0.02 blue:0.16 alpha:0.45];
            phlTableView.layer.cornerRadius = 9;
            phlTableView.separatorColor = [UIColor colorWithRed:0.75 green:0.35 blue:1.0 alpha:0.25];
            phlTableView.rowHeight = 38.0f;
            phlTableView.delegate = self;
            phlTableView.dataSource = self;
            [phlMenuContainer addSubview:phlTableView];

            // Khung trình duyệt web nhúng trên menu
            phlWebPanel = [[UIView alloc] initWithFrame:CGRectZero];
            phlWebPanel.backgroundColor = [UIColor colorWithRed:0.07 green:0.03 blue:0.18 alpha:0.98];
            phlWebPanel.layer.cornerRadius = 9;
            phlWebPanel.layer.borderWidth = 1.1;
            phlWebPanel.layer.borderColor = [UIColor colorWithRed:0.45 green:0.92 blue:1.0 alpha:0.8].CGColor;
            phlWebPanel.clipsToBounds = YES;
            phlWebPanel.hidden = YES;
            [phlMenuContainer addSubview:phlWebPanel];

            phlBackBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [phlBackBtn setTitle:@"←" forState:UIControlStateNormal];
            [phlBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            phlBackBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            phlBackBtn.backgroundColor = [UIColor colorWithRed:0.25 green:0.1 blue:0.45 alpha:0.95];
            phlBackBtn.layer.cornerRadius = 5;
            [phlBackBtn addTarget:self action:@selector(webGoBack) forControlEvents:UIControlEventTouchUpInside];
            [phlWebPanel addSubview:phlBackBtn];

            phlFwdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [phlFwdBtn setTitle:@"→" forState:UIControlStateNormal];
            [phlFwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            phlFwdBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            phlFwdBtn.backgroundColor = [UIColor colorWithRed:0.25 green:0.1 blue:0.45 alpha:0.95];
            phlFwdBtn.layer.cornerRadius = 5;
            [phlFwdBtn addTarget:self action:@selector(webGoForward) forControlEvents:UIControlEventTouchUpInside];
            [phlWebPanel addSubview:phlFwdBtn];

            phlHomeYtBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [phlHomeYtBtn setTitle:@"🏠 YT" forState:UIControlStateNormal];
            [phlHomeYtBtn setTitleColor:[UIColor colorWithRed:1.0 green:0.85 blue:0.4 alpha:1.0] forState:UIControlStateNormal];
            phlHomeYtBtn.titleLabel.font = [UIFont boldSystemFontOfSize:9];
            phlHomeYtBtn.backgroundColor = [UIColor colorWithRed:0.14 green:0.22 blue:0.42 alpha:0.95];
            phlHomeYtBtn.layer.cornerRadius = 5;
            [phlHomeYtBtn addTarget:self action:@selector(webGoHome) forControlEvents:UIControlEventTouchUpInside];
            [phlWebPanel addSubview:phlHomeYtBtn];

            phlCloseWebBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [phlCloseWebBtn setTitle:@"Thu gọn" forState:UIControlStateNormal];
            [phlCloseWebBtn setTitleColor:[UIColor colorWithRed:1.0 green:0.75 blue:0.95 alpha:1.0] forState:UIControlStateNormal];
            phlCloseWebBtn.titleLabel.font = [UIFont boldSystemFontOfSize:9];
            phlCloseWebBtn.backgroundColor = [UIColor colorWithRed:0.45 green:0.08 blue:0.32 alpha:0.95];
            phlCloseWebBtn.layer.cornerRadius = 5;
            [phlCloseWebBtn addTarget:self action:@selector(closeEmbeddedBrowser) forControlEvents:UIControlEventTouchUpInside];
            [phlWebPanel addSubview:phlCloseWebBtn];

            phlYouTubeSearchField = [[UITextField alloc] initWithFrame:CGRectZero];
            phlYouTubeSearchField.placeholder = @"Tìm nhạc trên YouTube...";
            phlYouTubeSearchField.textColor = [UIColor whiteColor];
            phlYouTubeSearchField.font = [UIFont systemFontOfSize:10.5];
            phlYouTubeSearchField.backgroundColor = [UIColor colorWithRed:0.15 green:0.07 blue:0.28 alpha:0.96];
            phlYouTubeSearchField.layer.cornerRadius = 6;
            phlYouTubeSearchField.layer.borderWidth = 1.0;
            phlYouTubeSearchField.layer.borderColor = [UIColor colorWithRed:0.85 green:0.42 blue:1.0 alpha:0.75].CGColor;
            phlYouTubeSearchField.returnKeyType = UIReturnKeySearch;
            phlYouTubeSearchField.clearButtonMode = UITextFieldViewModeWhileEditing;
            phlYouTubeSearchField.delegate = self;

            UIView *leftPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 22)];
            phlYouTubeSearchField.leftView = leftPad;
            phlYouTubeSearchField.leftViewMode = UITextFieldViewModeAlways;
            [phlWebPanel addSubview:phlYouTubeSearchField];

            phlYtSearchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [phlYtSearchBtn setTitle:@"🔍 YT" forState:UIControlStateNormal];
            [phlYtSearchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            phlYtSearchBtn.titleLabel.font = [UIFont boldSystemFontOfSize:9.5];
            phlYtSearchBtn.backgroundColor = [UIColor colorWithRed:0.88 green:0.14 blue:0.36 alpha:0.98];
            phlYtSearchBtn.layer.cornerRadius = 6;
            [phlYtSearchBtn addTarget:self action:@selector(triggerYouTubeSearch) forControlEvents:UIControlEventTouchUpInside];
            [phlWebPanel addSubview:phlYtSearchBtn];

            WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
            webConfig.allowsInlineMediaPlayback = YES;
            WKUserContentController *ucc = webConfig.userContentController;
            [ucc addScriptMessageHandler:self name:@"phlWebMediaPlaying"];

            WKUserScript *cleanScript = [[WKUserScript alloc] initWithSource:kPHLCleanYouTubeJS
                                                             injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                          forMainFrameOnly:NO];
            [ucc addUserScript:cleanScript];

            NSString *initBridge = [NSString stringWithFormat:@"%@; window.__phlAudioBridge.setGain(%.3f);",
                                    kPHLWebAudioBridgeJS, phlCurrentGain];
            WKUserScript *bridgeScript = [[WKUserScript alloc] initWithSource:initBridge
                                                              injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                           forMainFrameOnly:NO];
            [ucc addUserScript:bridgeScript];

            phlWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webConfig];
            phlWebView.navigationDelegate = self;
            phlWebView.scrollView.bounces = YES;
            [phlWebPanel addSubview:phlWebView];

            // Chân bản quyền cố định dưới cùng
            phlAdminInfoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [phlAdminInfoBtn setTitle:@"🛡 INFO & BẢN QUYỀN • phamlong09.store" forState:UIControlStateNormal];
            [phlAdminInfoBtn setTitleColor:[UIColor colorWithRed:0.45 green:0.98 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            phlAdminInfoBtn.titleLabel.font = [UIFont systemFontOfSize:9.5 weight:UIFontWeightBold];
            phlAdminInfoBtn.backgroundColor = [UIColor colorWithRed:0.25 green:0.07 blue:0.44 alpha:0.96];
            phlAdminInfoBtn.layer.cornerRadius = 7;
            phlAdminInfoBtn.layer.borderWidth = 1.0;
            phlAdminInfoBtn.layer.borderColor = [UIColor colorWithRed:0.92 green:0.45 blue:1.0 alpha:0.9].CGColor;
            [phlAdminInfoBtn addTarget:self action:@selector(openAdminInfoGroup) forControlEvents:UIControlEventTouchUpInside];
            [phlMenuContainer addSubview:phlAdminInfoBtn];

            phlCopyrightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            phlCopyrightLabel.text = @"BẢN QUYỀN THUỘC ADMIN TELEGRAM: @PHL0990\nZALO: 0522608620";
            phlCopyrightLabel.textColor = [UIColor colorWithRed:1.0 green:0.86 blue:0.55 alpha:0.98];
            phlCopyrightLabel.font = [UIFont systemFontOfSize:8 weight:UIFontWeightBold];
            phlCopyrightLabel.textAlignment = NSTextAlignmentCenter;
            phlCopyrightLabel.numberOfLines = 2;
            [phlMenuContainer addSubview:phlCopyrightLabel];

            [self layoutMenuSubviewsWithWidth:menuW height:menuH expanded:NO];
            [self applyIndependentGain:phlCurrentGain];
            [keyWindow addSubview:phlMenuContainer];
        } else if (phlMenuContainer.superview != keyWindow) {
            [keyWindow addSubview:phlMenuContainer];
        }

        [self fetchGitHubPlaylist];
    });
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [self cleanYouTubePageInWebView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self cleanYouTubePageInWebView];
    [self applyIndependentGain:phlCurrentGain];
}

- (void)toggleEmbeddedBrowser {
    phlIsWebOpen = !phlIsWebOpen;
    [self syncBrowserVisibilityAnimated:YES];
    if (phlIsWebOpen && !phlHasLoadedInitialWeb) {
        phlHasLoadedInitialWeb = YES;
        [self loadYouTubeURLString:kPHLYouTubeHomeURL];
    } else if (phlIsWebOpen) {
        [self cleanYouTubePageInWebView];
        [self applyIndependentGain:phlCurrentGain];
    }
}

- (void)closeEmbeddedBrowser {
    [phlYouTubeSearchField resignFirstResponder];
    phlIsWebOpen = NO;
    [self syncBrowserVisibilityAnimated:YES];
}

- (void)syncBrowserVisibilityAnimated:(BOOL)animated {
    phlWebPanel.hidden = !phlIsWebOpen;
    phlTableView.hidden = phlIsWebOpen;
    [phlOpenBrowserBtn setTitle:(phlIsWebOpen
        ? @"☰ ĐANG MỞ YOUTUBE • VỀ GITHUB (THU GỌN)"
        : @"🌐 MỞ YOUTUBE (PHÓNG RỘNG)")
                        forState:UIControlStateNormal];
    [self applyMenuFrameForExpanded:phlIsWebOpen animated:animated];
}

- (void)loadYouTubeURLString:(NSString *)urlStr {
    if (!phlWebView || !urlStr || urlStr.length == 0) return;
    NSURL *url = [NSURL URLWithString:urlStr];
    if (!url) return;
    NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [phlWebView loadRequest:req];
}

- (void)webGoHome {
    phlHasLoadedInitialWeb = YES;
    [self loadYouTubeURLString:kPHLYouTubeHomeURL];
}

- (void)triggerYouTubeSearch {
    [phlYouTubeSearchField resignFirstResponder];
    NSString *rawQuery = [phlYouTubeSearchField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!phlIsWebOpen) {
        phlIsWebOpen = YES;
        [self syncBrowserVisibilityAnimated:YES];
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
        [self applyMenuFrameForExpanded:phlIsWebOpen animated:NO];
        [self applyIndependentGain:phlCurrentGain];
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
    [self clampViewToSafeBounds:targetView topMargin:14.0f bottomMargin:14.0f];
    [pan setTranslation:CGPointZero inView:targetView.superview];
}

- (void)handleMenuHeaderPan:(UIPanGestureRecognizer *)pan {
    if (!phlMenuContainer || !phlMenuContainer.superview) return;

    CGPoint translation = [pan translationInView:phlMenuContainer.superview];
    phlMenuContainer.center = CGPointMake(phlMenuContainer.center.x + translation.x, phlMenuContainer.center.y + translation.y);
    [self clampViewToSafeBounds:phlMenuContainer topMargin:6.0f bottomMargin:6.0f];
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

    // Dừng nhạc trên YouTube/Web trước để tránh 2 nguồn phát chồng nhau
    [self pauseWebMediaIfPlaying];
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
    phlAudioPlayer.muted = (phlCurrentGain <= 0.001f);
    phlAudioPlayer.volume = MIN(1.0f, phlCurrentGain);
    [self applyGainToItem:phlPlayerItem gain:phlCurrentGain];
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
        [self pauseWebMediaIfPlaying];
        [self configureAudioSession];
        phlAudioPlayer.muted = (phlCurrentGain <= 0.001f);
        phlAudioPlayer.volume = MIN(1.0f, phlCurrentGain);
        [self applyGainToItem:phlPlayerItem gain:phlCurrentGain];
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
    [self applyIndependentGain:slider.value];
}

- (void)decreaseVolumeStep {
    float nextGain = MAX(0.0f, phlCurrentGain - 0.15f);
    phlVolumeSlider.value = nextGain;
    [self applyIndependentGain:nextGain];
}

- (void)increaseVolumeStep {
    float nextGain = MIN(2.0f, phlCurrentGain + 0.15f);
    phlVolumeSlider.value = nextGain;
    [self applyIndependentGain:nextGain];
}

- (void)toggleRepeatMode {
    phlRepeatOne = !phlRepeatOne;
    [[NSUserDefaults standardUserDefaults] setBool:phlRepeatOne forKey:kPHLPrefRepeatOne];
    [self syncRepeatButton];
}

- (void)syncRepeatButton {
    [phlRepeatBtn setTitle:(phlRepeatOne ? @"🔂" : @"🔁") forState:UIControlStateNormal];
    phlRepeatBtn.backgroundColor = phlRepeatOne
        ? [UIColor colorWithRed:0.88 green:0.18 blue:0.68 alpha:0.96]
        : [UIColor colorWithRed:0.22 green:0.08 blue:0.42 alpha:0.92];
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
        cell.textLabel.font = [UIFont systemFontOfSize:10.5 weight:UIFontWeightSemibold];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:8.5];
    }

    if (phlPlaylist.count == 0) {
        cell.textLabel.textColor = [UIColor colorWithRed:1.0 green:0.65 blue:0.75 alpha:1.0];
        cell.textLabel.text = phlStatusMessage ?: @"Không có bài hát";
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.text = @"Chạm để thử tải lại từ GitHub";
        return cell;
    }

    NSDictionary *song = phlPlaylist[indexPath.row];
    NSString *title = song[@"title"] ?: @"Bài hát chưa đặt tên";
    BOOL isCurrent = (indexPath.row == phlCurrentIndex);

    cell.textLabel.textColor = isCurrent ? [UIColor colorWithRed:1.0 green:0.65 blue:1.0 alpha:1.0] : [UIColor whiteColor];
    cell.textLabel.text = title;
    cell.detailTextLabel.textColor = isCurrent ? [UIColor colorWithRed:0.35 green:1.0 blue:0.75 alpha:1.0] : [UIColor colorWithRed:0.45 green:0.92 blue:1.0 alpha:1.0];
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
