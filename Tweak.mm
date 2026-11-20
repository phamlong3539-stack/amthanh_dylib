// ==============================================================================
// 👑 PHL ENTERPRISE SECURE AUDIO RUNTIME (ARM64 MASTER ENGINE - 50 YR EDITION)
// ARCHITECTURE: NUCLEAR AD-BLOCK • ZERO-SEARCH WEBUI • HI-RES GAIN & BASS BOOST
// COMPATIBILITY: THEOS • GITHUB ACTIONS CI • ESIGN READY
// ==============================================================================

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
#import <QuartzCore/QuartzCore.h>
#include <dlfcn.h>
#include <sys/sysctl.h>
#include <mach-o/dyld.h>

typedef NS_ENUM(NSInteger, TransportButtonKind) {
    TransportButtonKindPrevious = 0,
    TransportButtonKindPlayPause = 1,
    TransportButtonKindNext = 2,
    TransportButtonKindRepeat = 3
};

#pragma mark - Bộ Chuyển Đổi Màu HEX Siêu Tốc

static inline UIColor *ColorFromHex(NSString *hexString, UIColor *fallback) {
    if (!hexString || hexString.length == 0) return fallback;
    NSString *clean = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if (clean.length != 6) return fallback;
    unsigned int rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:clean];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                           green:((rgbValue & 0x00FF00) >> 8) / 255.0
                            blue:(rgbValue & 0x0000FF) / 255.0
                           alpha:1.0];
}

#pragma mark - Weak Script Message Proxy

@interface PHLWeakScriptMessageProxy : NSObject <WKScriptMessageHandler>
@property (nonatomic, weak) id<WKScriptMessageHandler> delegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)delegate;
@end

@implementation PHLWeakScriptMessageProxy
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)delegate {
    self = [super init];
    if (self) { _delegate = delegate; }
    return self;
}
- (void)userContentController:(WKUserContentController *)ucc didReceiveScriptMessage:(WKScriptMessage *)msg {
    [self.delegate userContentController:ucc didReceiveScriptMessage:msg];
}
@end

#pragma mark - Nút Điều Khiển Vector UI

@interface PHLTransportButton : UIButton
@property (nonatomic, assign) TransportButtonKind iconKind;
@property (nonatomic, assign) BOOL activeState;
@property (nonatomic, assign) BOOL pulseHighlight;
@property (nonatomic, strong) CAShapeLayer *glyphLayer;
@property (nonatomic, strong) CAShapeLayer *markerDotLayer;
+ (instancetype)buttonWithKind:(TransportButtonKind)kind actionTarget:(id)target action:(SEL)action;
- (void)setupKind:(TransportButtonKind)kind actionTarget:(id)target action:(SEL)action;
- (void)refreshTransportVisual;
- (void)triggerPulseMark;
@end

@implementation PHLTransportButton

+ (instancetype)buttonWithKind:(TransportButtonKind)kind actionTarget:(id)target action:(SEL)action {
    PHLTransportButton *btn = [PHLTransportButton buttonWithType:UIButtonTypeCustom];
    [btn setupKind:kind actionTarget:target action:action];
    return btn;
}

- (void)setupKind:(TransportButtonKind)kind actionTarget:(id)target action:(SEL)action {
    _iconKind = kind;
    _activeState = NO;
    _pulseHighlight = NO;

    self.layer.cornerRadius = 8.0f;
    self.layer.borderWidth = 1.15f;
    self.clipsToBounds = YES;
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    if (!_glyphLayer) {
        _glyphLayer = [CAShapeLayer layer];
        _glyphLayer.fillColor = [UIColor clearColor].CGColor;
        _glyphLayer.strokeColor = [UIColor whiteColor].CGColor;
        _glyphLayer.lineWidth = 1.6f;
        _glyphLayer.lineCap = kCALineCapRound;
        _glyphLayer.lineJoin = kCALineJoinRound;
        [self.layer addSublayer:_glyphLayer];
    }

    if (!_markerDotLayer) {
        _markerDotLayer = [CAShapeLayer layer];
        _markerDotLayer.hidden = YES;
        [self.layer addSublayer:_markerDotLayer];
    }

    [self refreshTransportVisual];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self refreshTransportVisual];
}

- (void)triggerPulseMark {
    self.pulseHighlight = YES;
    [self refreshTransportVisual];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.28 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pulseHighlight = NO;
        [self refreshTransportVisual];
    });
}

- (void)refreshTransportVisual {
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    if (w <= 1.0f || h <= 1.0f) return;

    BOOL marked = self.activeState || self.pulseHighlight;
    CGFloat cx = w * 0.5f;
    CGFloat cy = h * 0.5f;

    if (self.iconKind == TransportButtonKindPlayPause) {
        self.backgroundColor = self.activeState
            ? [UIColor colorWithRed:0.86 green:0.18 blue:0.82 alpha:0.98]
            : [UIColor colorWithRed:0.62 green:0.14 blue:0.68 alpha:0.94];
        self.layer.borderColor = marked
            ? [UIColor colorWithRed:0.42 green:0.98 blue:1.0 alpha:1.0].CGColor
            : [UIColor colorWithRed:0.92 green:0.48 blue:1.0 alpha:0.92].CGColor;
    } else {
        self.backgroundColor = marked
            ? [UIColor colorWithRed:0.34 green:0.12 blue:0.58 alpha:0.96]
            : [UIColor colorWithRed:0.18 green:0.06 blue:0.36 alpha:0.90];
        self.layer.borderColor = marked
            ? [UIColor colorWithRed:0.42 green:0.98 blue:1.0 alpha:1.0].CGColor
            : [UIColor colorWithRed:0.78 green:0.38 blue:1.0 alpha:0.82].CGColor;
    }

    UIBezierPath *path = [UIBezierPath bezierPath];
    switch (self.iconKind) {
        case TransportButtonKindPrevious: {
            CGFloat barX = cx - 5.5f;
            [path moveToPoint:CGPointMake(barX, cy - 4.5f)];
            [path addLineToPoint:CGPointMake(barX, cy + 4.5f)];
            [path moveToPoint:CGPointMake(cx + 5.5f, cy - 4.5f)];
            [path addLineToPoint:CGPointMake(barX + 1.8f, cy)];
            [path addLineToPoint:CGPointMake(cx + 5.5f, cy + 4.5f)];
            [path closePath];
            break;
        }
        case TransportButtonKindPlayPause: {
            if (self.activeState) {
                [path moveToPoint:CGPointMake(cx - 3.2f, cy - 4.8f)];
                [path addLineToPoint:CGPointMake(cx - 3.2f, cy + 4.8f)];
                [path moveToPoint:CGPointMake(cx + 3.2f, cy - 4.8f)];
                [path addLineToPoint:CGPointMake(cx + 3.2f, cy + 4.8f)];
            } else {
                [path moveToPoint:CGPointMake(cx - 3.6f, cy - 5.2f)];
                [path addLineToPoint:CGPointMake(cx + 4.8f, cy)];
                [path addLineToPoint:CGPointMake(cx - 3.6f, cy + 5.2f)];
                [path closePath];
            }
            break;
        }
        case TransportButtonKindNext: {
            CGFloat barX = cx + 5.5f;
            [path moveToPoint:CGPointMake(cx - 5.5f, cy - 4.5f)];
            [path addLineToPoint:CGPointMake(barX - 1.8f, cy)];
            [path addLineToPoint:CGPointMake(cx - 5.5f, cy + 4.5f)];
            [path closePath];
            [path moveToPoint:CGPointMake(barX, cy - 4.5f)];
            [path addLineToPoint:CGPointMake(barX, cy + 4.5f)];
            break;
        }
        case TransportButtonKindRepeat: {
            CGFloat rx = 6.2f, ry = 3.8f;
            [path moveToPoint:CGPointMake(cx - rx, cy - ry + 1.5f)];
            [path addQuadCurveToPoint:CGPointMake(cx + rx, cy - ry) controlPoint:CGPointMake(cx, cy - ry - 2.6f)];
            [path moveToPoint:CGPointMake(cx + rx - 2.4f, cy - ry - 2.0f)];
            [path addLineToPoint:CGPointMake(cx + rx, cy - ry)];
            [path addLineToPoint:CGPointMake(cx + rx - 2.4f, cy - ry + 2.0f)];

            [path moveToPoint:CGPointMake(cx + rx, cy + ry - 1.5f)];
            [path addQuadCurveToPoint:CGPointMake(cx - rx, cy + ry) controlPoint:CGPointMake(cx, cy + ry + 2.6f)];
            [path moveToPoint:CGPointMake(cx - rx + 2.4f, cy + ry - 2.0f)];
            [path addLineToPoint:CGPointMake(cx - rx, cy + ry)];
            [path addLineToPoint:CGPointMake(cx - rx + 2.4f, cy + ry + 2.0f)];
            break;
        }
    }

    self.glyphLayer.frame = self.bounds;
    self.glyphLayer.path = path.CGPath;
    self.glyphLayer.strokeColor = marked ? [UIColor colorWithRed:1.0 green:0.96 blue:0.65 alpha:1.0].CGColor : [UIColor whiteColor].CGColor;

    self.markerDotLayer.hidden = !marked;
    if (marked) {
        UIBezierPath *dotPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(w - 7.5f, 3.5f, 4.2f, 4.2f)];
        self.markerDotLayer.frame = self.bounds;
        self.markerDotLayer.path = dotPath.CGPath;
        self.markerDotLayer.fillColor = [UIColor colorWithRed:0.38 green:1.0 blue:0.78 alpha:1.0].CGColor;
    }
}

@end

#pragma mark - Bộ Não Trung Tâm

@interface PHLProtectedAudioManager : NSObject <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, WKNavigationDelegate, WKScriptMessageHandler> {
    AVPlayer *_player;
    AVPlayerItem *_playerItem;

    UIButton *_floatBtn;
    UIView *_menuBox;
    CAGradientLayer *_gradient;
    UIView *_dragHdr;
    UIButton *_closeBtn;
    UITableView *_table;

    UILabel *_headerTitleLbl;
    UILabel *_tickerLbl;
    UILabel *_titleLbl;
    PHLTransportButton *_btnPrev;
    PHLTransportButton *_btnPlay;
    PHLTransportButton *_btnNext;
    PHLTransportButton *_btnRep;

    UIButton *_btnMute;
    UIButton *_btnVolUp;
    UISlider *_volSlider;
    UILabel *_gainLbl;

    UIButton *_btnWebToggle;
    UIView *_webBox;
    UIButton *_btnBack;
    UIButton *_btnFwd;
    UIButton *_btnHome;
    UIButton *_btnCloseW;
    UITextField *_searchBar;
    UIButton *_btnSearch;
    WKWebView *_web;
    BOOL _webOpen;
    BOOL _webLoaded;

    UIButton *_adminBtn;
    UILabel *_cprLbl;

    NSMutableArray *_playlist;
    NSDictionary *_featuredVipSong;
    NSString *_statusMsg;
    NSInteger _idx;
    BOOL _menuOpen;
    BOOL _repOne;
    float _gain;

    BOOL _isYouTubeEnabled;
    NSString *_youtubeHomeURL;
    NSString *_youtubeLockedMsg;
    NSString *_adminTargetURL;
    float _maxAllowedGain;
}
+ (instancetype)sharedInstance;
- (void)initializeFramework;
@end

@implementation PHLProtectedAudioManager

static inline NSString *GetNuclearCleanAndAdBlockJS(void) {
    return @"(function(){\n"
            "  var css = 'ytm-mobile-topbar-renderer, ytm-search-header, [role=\"search\"], \\\n"
            "             button[aria-label*=\"Search\"], button[aria-label*=\"Tìm kiếm\"], \\\n"
            "             .mobile-topbar-header-search-icon, .search-icon, ytm-searchbox, \\\n"
            "             ytm-pivot-bar-renderer, ytm-bottom-nav-bar, nav.pivot-bar, \\\n"
            "             .ad-container, .companion-ad-container, ytm-promoted-sparkles-web-renderer, \\\n"
            "             ytm-promoted-sparkles-text-search-web-renderer, .ytp-ad-overlay-container, \\\n"
            "             .ytp-ad-skip-button-slot, ytd-banner-promo-renderer, ytm-paid-content-overlay-renderer, \\\n"
            "             .video-ads, ytm-promoted-video-renderer { \\\n"
            "               display: none !important; \\\n"
            "               height: 0px !important; \\\n"
            "               visibility: hidden !important; \\\n"
            "               pointer-events: none !important; \\\n"
            "             } \\\n"
            "             ytm-page-manager, #app, ytm-app { \\\n"
            "               padding-top: 0px !important; \\\n"
            "               margin-top: 0px !important; \\\n"
            "               padding-bottom: 0px !important; \\\n"
            "             }';\n"
            "  var styleId = 'phl-nuclear-clean-style';\n"
            "  if(!document.getElementById(styleId)){\n"
            "    var st = document.createElement('style');\n"
            "    st.id = styleId;\n"
            "    st.textContent = css;\n"
            "    (document.head || document.documentElement).appendChild(st);\n"
            "  }\n"
            "  function executePurge(){\n"
            "    document.querySelectorAll('ytm-mobile-topbar-renderer, ytm-search-header, [role=\"search\"], .ad-container, ytm-pivot-bar-renderer').forEach(function(el){\n"
            "      el.remove();\n"
            "    });\n"
            "    var skip = document.querySelector('.ytp-ad-skip-button, .ytp-ad-skip-button-modern, .videoAdUiSkipButton, .ytp-ad-skip-button-slot button');\n"
            "    if(skip) { skip.click(); }\n"
            "    var ad = document.querySelector('.ad-showing, .ad-interrupting');\n"
            "    var vid = document.querySelector('video');\n"
            "    if(ad && vid && !isNaN(vid.duration)){\n"
            "      vid.muted = true;\n"
            "      vid.playbackRate = 16.0;\n"
            "      vid.currentTime = vid.duration;\n"
            "    }\n"
            "  }\n"
            "  executePurge();\n"
            "  setInterval(executePurge, 250);\n"
            "})();";
}

static inline NSString *GetAudioBridgeJS(void) {
    return @"(function(){if(!window.__phlAudioBridge){window.__phlAudioBridge={gain:1.0,ctx:null,nodes:new WeakMap(),pauseAll:function(){document.querySelectorAll('video,audio').forEach(function(e){try{e.pause();}catch(x){}});},ensureContext:function(){if(!this.ctx){var A=window.AudioContext||window.webkitAudioContext;if(A){try{this.ctx=new A();}catch(x){}}}if(this.ctx&&this.ctx.state==='suspended'){this.ctx.resume().catch(function(){});}},hookElement:function(e){var s=this;if(!e.__phlPlayHooked){e.__phlPlayHooked=true;e.addEventListener('play',function(){s.applyToElement(e);if(window.webkit&&window.webkit.messageHandlers&&window.webkit.messageHandlers.phlWebMediaPlaying){window.webkit.messageHandlers.phlWebMediaPlaying.postMessage('playing');}},true);}s.applyToElement(e);},applyToElement:function(e){var g=Math.max(0.0,Math.min(3.0,this.gain));try{e.muted=(g<=0.001);e.volume=Math.min(1.0,g);}catch(x){}if(g>1.0){this.ensureContext();if(this.ctx){try{var n=this.nodes.get(e);if(!n){var src=this.ctx.createMediaElementSource(e);var gn=this.ctx.createGain();var bass=this.ctx.createBiquadFilter();bass.type='lowshelf';bass.frequency.value=250;bass.gain.value=4.0;src.connect(bass);bass.connect(gn);gn.connect(this.ctx.destination);n={gainNode:gn};this.nodes.set(e,n);}n.gainNode.gain.setTargetAtTime(g,this.ctx.currentTime,0.02);}catch(x){}}}else{var ex=this.nodes.get(e);if(ex&&ex.gainNode&&this.ctx){try{ex.gainNode.gain.setTargetAtTime(g,this.ctx.currentTime,0.02);}catch(x){}}}},setGain:function(v){this.gain=Math.max(0.0,Math.min(3.0,parseFloat(v)||0.0));var s=this;document.querySelectorAll('video,audio').forEach(function(e){s.hookElement(e);});}};}})();";
}

+ (instancetype)sharedInstance {
    static PHLProtectedAudioManager *inst = nil;
    static dispatch_once_t tk;
    dispatch_once(&tk, ^{
        inst = [[PHLProtectedAudioManager alloc] init];
    });
    return inst;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _playlist = [[NSMutableArray alloc] init];
        _statusMsg = @"Đang nạp dữ liệu Master VIP...";
        _idx = -1;
        _menuOpen = NO;
        _webOpen = NO;
        _webLoaded = NO;

        _isYouTubeEnabled = YES;
        _youtubeHomeURL = @"https://m.youtube.com";
        _youtubeLockedMsg = @"Tính năng YouTube đang bảo trì!";
        _adminTargetURL = @"https://phamlong09.store";
        _maxAllowedGain = 3.0f;

        _repOne = [ud objectForKey:@"PHL_RepeatOneSong"] ? [ud boolForKey:@"PHL_RepeatOneSong"] : NO;
        _gain = [ud objectForKey:@"PHL_IndependentAudioGain"] ? [ud floatForKey:@"PHL_IndependentAudioGain"] : 1.0f;

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
        if (self->_repOne && self->_idx >= 0 && self->_idx < (NSInteger)self->_playlist.count) {
            [self playSongAtIndex:self->_idx];
        } else if (self->_playlist.count > 0) {
            NSInteger nxt = (self->_idx + 1) % (NSInteger)self->_playlist.count;
            [self playSongAtIndex:nxt];
        }
    });
}

- (void)configureAudioSession {
    NSError *err = nil;
    AVAudioSession *s = [AVAudioSession sharedInstance];
    [s setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowAirPlay error:&err];
    [s setActive:YES error:&err];
}

- (void)pauseWebMediaIfPlaying {
    if (!_web) return;
    NSString *js = @"(function(){if(window.__phlAudioBridge){window.__phlAudioBridge.pauseAll();}document.querySelectorAll('video,audio').forEach(function(e){try{e.pause();}catch(x){}});})();";
    [_web evaluateJavaScript:js completionHandler:nil];
}

- (void)pauseStreamPlayerIfPlaying {
    if (_player && _player.rate > 0.01f) {
        [_player pause];
        [self syncPlayPauseButton];
    }
}

- (void)applyGainToItem:(AVPlayerItem *)item gain:(float)gain {
    if (!item || !item.asset) return;
    if (gain <= 1.001f) {
        item.audioMix = nil;
        return;
    }
    NSArray<AVAssetTrack *> *tracks = [item.asset tracksWithMediaType:AVMediaTypeAudio];
    if (!tracks || tracks.count == 0) return;

    AVMutableAudioMix *mix = [AVMutableAudioMix audioMix];
    NSMutableArray *arr = [NSMutableArray array];
    for (AVAssetTrack *t in tracks) {
        AVMutableAudioMixInputParameters *p = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:t];
        [p setVolume:gain atTime:kCMTimeZero];
        [arr addObject:p];
    }
    mix.inputParameters = arr;
    item.audioMix = mix;
}

- (void)applyIndependentGain:(float)gain {
    float clamped = MAX(0.0f, MIN(_maxAllowedGain, gain));
    _gain = clamped;
    [[NSUserDefaults standardUserDefaults] setFloat:clamped forKey:@"PHL_IndependentAudioGain"];

    if (_gainLbl) {
        int pct = (int)roundf(clamped * 100.0f);
        _gainLbl.text = [NSString stringWithFormat:@"%d%%", pct];
        _gainLbl.textColor = (clamped > 1.0f)
            ? [UIColor colorWithRed:1.0 green:0.45 blue:0.65 alpha:1.0]
            : [UIColor colorWithRed:0.45 green:0.98 blue:1.0 alpha:1.0];
    }

    if (_player) {
        _player.muted = (clamped <= 0.001f);
        _player.volume = MIN(1.0f, clamped);
        if (_playerItem) [self applyGainToItem:_playerItem gain:clamped];
    }

    if (_web) {
        NSString *js = [NSString stringWithFormat:@"%@;if(window.__phlAudioBridge){window.__phlAudioBridge.setGain(%.3f);}", GetAudioBridgeJS(), clamped];
        [_web evaluateJavaScript:js completionHandler:nil];
    }
}

- (void)userContentController:(WKUserContentController *)ucc didReceiveScriptMessage:(WKScriptMessage *)msg {
    if ([msg.name isEqualToString:@"phlWebMediaPlaying"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pauseStreamPlayerIfPlaying];
            [self applyIndependentGain:self->_gain];
        });
    }
}

- (void)cleanYouTubePageInWebView {
    if (!_web) return;
    [_web evaluateJavaScript:GetNuclearCleanAndAdBlockJS() completionHandler:nil];
}

- (UIWindow *)resolveActiveWindow {
    for (UIWindowScene *s in [UIApplication sharedApplication].connectedScenes) {
        if (s.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *w in s.windows) {
                if (w.isKeyWindow) return w;
            }
            if (s.windows.firstObject) return s.windows.firstObject;
        }
    }
    return [UIApplication sharedApplication].windows.firstObject;
}

- (UIButton *)makeUtilityButtonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize bgColor:(UIColor *)bg borderColor:(UIColor *)bc action:(SEL)act {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightBold];
    btn.backgroundColor = bg;
    btn.layer.cornerRadius = 8;
    btn.layer.borderWidth = 1.1;
    btn.layer.borderColor = bc.CGColor;
    [btn addTarget:self action:act forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)layoutMenuSubviewsWithWidth:(CGFloat)mW height:(CGFloat)mH expanded:(BOOL)exp {
    CGFloat padX = 10.0f;
    CGFloat inW = mW - padX * 2.0f;

    _gradient.frame = CGRectMake(0, 0, mW, mH);
    _dragHdr.frame = CGRectMake(0, 0, mW, 48.0f);
    _closeBtn.frame = CGRectMake(mW - 34.0f, 7.0f, 24.0f, 24.0f);

    _btnPrev.hidden = exp;
    _btnPlay.hidden = exp;
    _btnNext.hidden = exp;
    _btnRep.hidden = exp;

    CGFloat vy = exp ? 51.0f : 81.0f;
    CGFloat wy = exp ? 75.0f : 106.0f;
    CGFloat cy = exp ? 102.0f : 133.0f;

    if (!exp) {
        CGFloat gap = 6.0f;
        CGFloat bw = (inW - gap * 3.0f) / 4.0f;
        CGFloat cY = 52.0f;
        _btnPrev.frame = CGRectMake(padX, cY, bw, 24.0f);
        _btnPlay.frame = CGRectMake(padX + (bw + gap), cY, bw, 24.0f);
        _btnNext.frame = CGRectMake(padX + (bw + gap) * 2.0f, cY, bw, 24.0f);
        _btnRep.frame = CGRectMake(padX + (bw + gap) * 3.0f, cY, bw, 24.0f);
    }

    CGFloat bW = 34.0f;
    _btnMute.frame = CGRectMake(padX, vy, 24.0f, 22.0f);
    _volSlider.frame = CGRectMake(padX + 26.0f, vy, MAX(60.0f, inW - 26.0f - 24.0f - bW - 2.0f), 22.0f);
    _btnVolUp.frame = CGRectMake(mW - padX - bW - 26.0f, vy, 24.0f, 22.0f);
    _gainLbl.frame = CGRectMake(mW - padX - bW, vy, bW, 22.0f);

    _btnWebToggle.frame = CGRectMake(padX, wy, inW, 23.0f);

    CGFloat fH = 48.0f;
    CGFloat cH = MAX(120.0f, mH - cy - fH - 4.0f);

    _table.frame = CGRectMake(8.0f, cy, mW - 16.0f, cH);
    _webBox.frame = CGRectMake(8.0f, cy, mW - 16.0f, cH);

    CGFloat pW = _webBox.bounds.size.width;
    CGFloat pH = _webBox.bounds.size.height;

    _btnBack.frame = CGRectMake(4.0f, 4.0f, 24.0f, 21.0f);
    _btnFwd.frame = CGRectMake(31.0f, 4.0f, 24.0f, 21.0f);
    _btnHome.frame = CGRectMake(58.0f, 4.0f, 38.0f, 21.0f);
    _btnCloseW.frame = CGRectMake(pW - 60.0f, 4.0f, 56.0f, 21.0f);

    CGFloat sbW = 46.0f;
    CGFloat sfW = MAX(90.0f, pW - 8.0f - sbW - 4.0f);
    _searchBar.frame = CGRectMake(4.0f, 28.0f, sfW, 22.0f);
    _btnSearch.frame = CGRectMake(4.0f + sfW + 4.0f, 28.0f, sbW, 22.0f);

    CGFloat wt = 53.0f;
    _web.frame = CGRectMake(0.0f, wt, pW, MAX(80.0f, pH - wt));

    CGFloat iy = mH - fH;
    _adminBtn.frame = CGRectMake(padX, iy, inW, 20.0f);
    _cprLbl.frame = CGRectMake(6.0f, iy + 20.0f, mW - 12.0f, 27.0f);
}

- (void)applyMenuFrameForExpanded:(BOOL)exp animated:(BOOL)anim {
    UIWindow *w = [self resolveActiveWindow];
    if (!w || !_menuBox) return;

    CGFloat sW = w.bounds.size.width;
    CGFloat sH = w.bounds.size.height;

    CGFloat cW = MIN(312.0f, sW - 86.0f);
    if (cW < 268.0f) cW = MIN(300.0f, sW - 20.0f);

    CGFloat eW = MAX(cW, MIN(580.0f, sW - 74.0f));
    if (eW < 280.0f) eW = MAX(cW, sW - 14.0f);

    CGFloat cH = MIN(332.0f, MAX(250.0f, sH - 24.0f));
    CGFloat eH = MAX(cH, MIN(700.0f, sH - 10.0f));

    CGFloat tW = exp ? eW : cW;
    CGFloat tH = exp ? eH : cH;

    CGFloat curX = _menuBox.frame.origin.x;
    CGFloat maxX = MAX(8.0f, sW - tW - 8.0f);
    CGFloat tX = exp ? MIN(maxX, MAX(70.0f, (sW - tW) * 0.56f)) : MAX(8.0f, MIN(maxX, curX));
    CGFloat tY = exp ? 5.0f : MAX(12.0f, MIN(sH - tH - 8.0f, _menuBox.frame.origin.y));

    CGRect tf = CGRectMake(tX, tY, tW, tH);
    void (^blk)(void) = ^{
        self->_menuBox.frame = tf;
        [self layoutMenuSubviewsWithWidth:tW height:tH expanded:exp];
        [self->_menuBox layoutIfNeeded];
    };

    if (anim) {
        [UIView animateWithDuration:0.22 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:blk completion:nil];
    } else {
        blk();
    }
}

- (void)initializeFramework {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *kw = [self resolveActiveWindow];
        if (!kw) return;

        CGFloat sW = kw.bounds.size.width;
        CGFloat mW = MIN(312.0f, sW - 86.0f);
        if (mW < 268.0f) mW = MIN(300.0f, sW - 20.0f);
        CGFloat mH = MIN(332.0f, MAX(250.0f, kw.bounds.size.height - 24.0f));

        if (!self->_floatBtn) {
            self->_floatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self->_floatBtn.frame = CGRectMake(16, 118, 48, 48);
            self->_floatBtn.layer.cornerRadius = 24;
            self->_floatBtn.clipsToBounds = YES;
            self->_floatBtn.layer.borderWidth = 2.2;
            self->_floatBtn.layer.borderColor = [UIColor colorWithRed:0.88 green:0.35 blue:1.0 alpha:1.0].CGColor;
            self->_floatBtn.backgroundColor = [UIColor colorWithRed:0.08 green:0.03 blue:0.2 alpha:0.96];
            [self->_floatBtn setTitle:@"👑" forState:UIControlStateNormal];
            self->_floatBtn.titleLabel.font = [UIFont systemFontOfSize:22];
            [self->_floatBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];

            UIPanGestureRecognizer *p = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleFloatingPan:)];
            [self->_floatBtn addGestureRecognizer:p];
            [kw addSubview:self->_floatBtn];

            [self loadRemoteLogo];
        } else if (self->_floatBtn.superview != kw) {
            [kw addSubview:self->_floatBtn];
        }

        if (!self->_menuBox) {
            self->_menuBox = [[UIView alloc] initWithFrame:CGRectMake(70, 16, mW, mH)];
            self->_menuBox.backgroundColor = [UIColor colorWithRed:0.06 green:0.02 blue:0.16 alpha:0.98];
            self->_menuBox.layer.cornerRadius = 16;
            self->_menuBox.layer.borderWidth = 1.6;
            self->_menuBox.layer.borderColor = [UIColor colorWithRed:0.85 green:0.42 blue:1.0 alpha:0.95].CGColor;
            self->_menuBox.clipsToBounds = YES;
            self->_menuBox.hidden = YES;
            self->_menuBox.alpha = 0.0;

            self->_gradient = [CAGradientLayer layer];
            self->_gradient.frame = CGRectMake(0, 0, mW, mH);
            self->_gradient.colors = @[
                (id)[UIColor colorWithRed:0.13 green:0.03 blue:0.28 alpha:1.0].CGColor,
                (id)[UIColor colorWithRed:0.23 green:0.05 blue:0.36 alpha:1.0].CGColor,
                (id)[UIColor colorWithRed:0.05 green:0.11 blue:0.27 alpha:1.0].CGColor
            ];
            self->_gradient.startPoint = CGPointMake(0.0f, 0.0f);
            self->_gradient.endPoint = CGPointMake(1.0f, 1.0f);
            [self->_menuBox.layer insertSublayer:self->_gradient atIndex:0];

            self->_dragHdr = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mW, 48)];
            self->_dragHdr.backgroundColor = [UIColor colorWithRed:0.18 green:0.06 blue:0.35 alpha:0.85];
            [self->_menuBox addSubview:self->_dragHdr];

            UIPanGestureRecognizer *hp = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMenuHeaderPan:)];
            [self->_dragHdr addGestureRecognizer:hp];

            self->_headerTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, mW - 48, 15)];
            self->_headerTitleLbl.text = @"👑 PHẠM LONG • SUPREME MASTER AUDIO";
            self->_headerTitleLbl.textColor = [UIColor colorWithRed:1.0 green:0.82 blue:1.0 alpha:1.0];
            self->_headerTitleLbl.font = [UIFont systemFontOfSize:11.5 weight:UIFontWeightHeavy];
            [self->_dragHdr addSubview:self->_headerTitleLbl];

            self->_tickerLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 19, mW - 48, 12)];
            self->_tickerLbl.text = @"⚡ NUCLEAR AD-BLOCK • CHẤT LƯỢNG MASTER HI-RES ⚡";
            self->_tickerLbl.textColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.4 alpha:1.0];
            self->_tickerLbl.font = [UIFont systemFontOfSize:8.5 weight:UIFontWeightBold];
            [self->_dragHdr addSubview:self->_tickerLbl];

            self->_titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, mW - 44, 13)];
            self->_titleLbl.text = @"♪ Đang sẵn sàng nạp nhạc VIP...";
            self->_titleLbl.textColor = [UIColor colorWithRed:0.38 green:1.0 blue:0.82 alpha:1.0];
            self->_titleLbl.font = [UIFont systemFontOfSize:9.5 weight:UIFontWeightSemibold];
            [self->_dragHdr addSubview:self->_titleLbl];

            self->_closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self->_closeBtn.frame = CGRectMake(mW - 34, 7, 24, 24);
            [self->_closeBtn setTitle:@"✕" forState:UIControlStateNormal];
            [self->_closeBtn setTitleColor:[UIColor colorWithRed:1.0 green:0.55 blue:0.78 alpha:1.0] forState:UIControlStateNormal];
            self->_closeBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
            self->_closeBtn.backgroundColor = [UIColor colorWithRed:0.35 green:0.06 blue:0.25 alpha:0.9];
            self->_closeBtn.layer.cornerRadius = 12;
            [self->_closeBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
            [self->_menuBox addSubview:self->_closeBtn];

            self->_btnPrev = [PHLTransportButton buttonWithKind:TransportButtonKindPrevious actionTarget:self action:@selector(playPreviousSong)];
            [self->_menuBox addSubview:self->_btnPrev];

            self->_btnPlay = [PHLTransportButton buttonWithKind:TransportButtonKindPlayPause actionTarget:self action:@selector(togglePlayPause)];
            [self->_menuBox addSubview:self->_btnPlay];

            self->_btnNext = [PHLTransportButton buttonWithKind:TransportButtonKindNext actionTarget:self action:@selector(playNextSong)];
            [self->_menuBox addSubview:self->_btnNext];

            self->_btnRep = [PHLTransportButton buttonWithKind:TransportButtonKindRepeat actionTarget:self action:@selector(toggleRepeatMode)];
            [self syncRepeatButton];
            [self->_menuBox addSubview:self->_btnRep];

            self->_btnMute = [UIButton buttonWithType:UIButtonTypeSystem];
            [self->_btnMute setTitle:@"🔉" forState:UIControlStateNormal];
            self->_btnMute.titleLabel.font = [UIFont systemFontOfSize:12];
            [self->_btnMute addTarget:self action:@selector(decreaseVolumeStep) forControlEvents:UIControlEventTouchUpInside];
            [self->_menuBox addSubview:self->_btnMute];

            self->_volSlider = [[UISlider alloc] initWithFrame:CGRectZero];
            self->_volSlider.minimumValue = 0.0f;
            self->_volSlider.maximumValue = self->_maxAllowedGain;
            self->_volSlider.value = self->_gain;
            self->_volSlider.minimumTrackTintColor = [UIColor colorWithRed:0.35 green:0.98 blue:1.0 alpha:1.0];
            self->_volSlider.maximumTrackTintColor = [UIColor colorWithRed:0.95 green:0.35 blue:0.75 alpha:0.35];
            self->_volSlider.thumbTintColor = [UIColor colorWithRed:1.0 green:0.88 blue:0.35 alpha:1.0];
            [self->_volSlider addTarget:self action:@selector(volumeSliderChanged:) forControlEvents:UIControlEventValueChanged];
            [self->_menuBox addSubview:self->_volSlider];

            self->_btnVolUp = [UIButton buttonWithType:UIButtonTypeSystem];
            [self->_btnVolUp setTitle:@"🔊" forState:UIControlStateNormal];
            self->_btnVolUp.titleLabel.font = [UIFont systemFontOfSize:12];
            [self->_btnVolUp addTarget:self action:@selector(increaseVolumeStep) forControlEvents:UIControlEventTouchUpInside];
            [self->_menuBox addSubview:self->_btnVolUp];

            self->_gainLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            self->_gainLbl.font = [UIFont monospacedDigitSystemFontOfSize:9 weight:UIFontWeightBold];
            self->_gainLbl.textAlignment = NSTextAlignmentRight;
            [self->_menuBox addSubview:self->_gainLbl];

            self->_btnWebToggle = [self makeUtilityButtonWithTitle:@"🌐 MỞ YOUTUBE VIP (ZERO ADS)"
                                                             fontSize:9.0
                                                              bgColor:[UIColor colorWithRed:0.12 green:0.24 blue:0.48 alpha:0.95]
                                                          borderColor:[UIColor colorWithRed:0.38 green:0.95 blue:1.0 alpha:0.9]
                                                               action:@selector(toggleEmbeddedBrowser)];
            [self->_btnWebToggle setTitleColor:[UIColor colorWithRed:0.65 green:0.98 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            [self->_menuBox addSubview:self->_btnWebToggle];

            self->_table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            self->_table.backgroundColor = [UIColor colorWithRed:0.06 green:0.02 blue:0.16 alpha:0.45];
            self->_table.layer.cornerRadius = 9;
            self->_table.separatorColor = [UIColor colorWithRed:0.75 green:0.35 blue:1.0 alpha:0.25];
            self->_table.rowHeight = 38.0f;
            self->_table.delegate = self;
            self->_table.dataSource = self;
            [self->_menuBox addSubview:self->_table];

            self->_webBox = [[UIView alloc] initWithFrame:CGRectZero];
            self->_webBox.backgroundColor = [UIColor colorWithRed:0.07 green:0.03 blue:0.18 alpha:0.98];
            self->_webBox.layer.cornerRadius = 9;
            self->_webBox.layer.borderWidth = 1.1;
            self->_webBox.layer.borderColor = [UIColor colorWithRed:0.45 green:0.92 blue:1.0 alpha:0.8].CGColor;
            self->_webBox.clipsToBounds = YES;
            self->_webBox.hidden = YES;
            [self->_menuBox addSubview:self->_webBox];

            self->_btnBack = [self makeUtilityButtonWithTitle:@"←" fontSize:12 bgColor:[UIColor colorWithRed:0.25 green:0.1 blue:0.45 alpha:0.95] borderColor:[UIColor colorWithRed:0.75 green:0.4 blue:1.0 alpha:0.7] action:@selector(webGoBack)];
            self->_btnBack.layer.cornerRadius = 5;
            [self->_webBox addSubview:self->_btnBack];

            self->_btnFwd = [self makeUtilityButtonWithTitle:@"→" fontSize:12 bgColor:[UIColor colorWithRed:0.25 green:0.1 blue:0.45 alpha:0.95] borderColor:[UIColor colorWithRed:0.75 green:0.4 blue:1.0 alpha:0.7] action:@selector(webGoForward)];
            self->_btnFwd.layer.cornerRadius = 5;
            [self->_webBox addSubview:self->_btnFwd];

            self->_btnHome = [self makeUtilityButtonWithTitle:@"🏠 YT" fontSize:9 bgColor:[UIColor colorWithRed:0.14 green:0.22 blue:0.42 alpha:0.95] borderColor:[UIColor colorWithRed:0.45 green:0.9 blue:1.0 alpha:0.7] action:@selector(webGoHome)];
            [self->_btnHome setTitleColor:[UIColor colorWithRed:1.0 green:0.85 blue:0.4 alpha:1.0] forState:UIControlStateNormal];
            self->_btnHome.layer.cornerRadius = 5;
            [self->_webBox addSubview:self->_btnHome];

            self->_btnCloseW = [self makeUtilityButtonWithTitle:@"Thu gọn" fontSize:9 bgColor:[UIColor colorWithRed:0.45 green:0.08 blue:0.32 alpha:0.95] borderColor:[UIColor colorWithRed:1.0 green:0.45 blue:0.75 alpha:0.7] action:@selector(closeEmbeddedBrowser)];
            [self->_btnCloseW setTitleColor:[UIColor colorWithRed:1.0 green:0.75 blue:0.95 alpha:1.0] forState:UIControlStateNormal];
            self->_btnCloseW.layer.cornerRadius = 5;
            [self->_webBox addSubview:self->_btnCloseW];

            self->_searchBar = [[UITextField alloc] initWithFrame:CGRectZero];
            self->_searchBar.placeholder = @"🔍 Nhập tên bài hát / ca sĩ để tìm...";
            self->_searchBar.textColor = [UIColor whiteColor];
            self->_searchBar.font = [UIFont systemFontOfSize:10.5 weight:UIFontWeightMedium];
            self->_searchBar.backgroundColor = [UIColor colorWithRed:0.15 green:0.07 blue:0.28 alpha:0.96];
            self->_searchBar.layer.cornerRadius = 6;
            self->_searchBar.layer.borderWidth = 1.0;
            self->_searchBar.layer.borderColor = [UIColor colorWithRed:0.85 green:0.42 blue:1.0 alpha:0.75].CGColor;
            self->_searchBar.returnKeyType = UIReturnKeySearch;
            self->_searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
            self->_searchBar.delegate = self;

            UIView *pad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 22)];
            self->_searchBar.leftView = pad;
            self->_searchBar.leftViewMode = UITextFieldViewModeAlways;
            [self->_webBox addSubview:self->_searchBar];

            self->_btnSearch = [self makeUtilityButtonWithTitle:@"Tìm" fontSize:9.5 bgColor:[UIColor colorWithRed:0.88 green:0.14 blue:0.36 alpha:0.98] borderColor:[UIColor colorWithRed:1.0 green:0.55 blue:0.75 alpha:0.85] action:@selector(triggerYouTubeSearch)];
            self->_btnSearch.layer.cornerRadius = 6;
            [self->_webBox addSubview:self->_btnSearch];

            WKWebViewConfiguration *wcfg = [[WKWebViewConfiguration alloc] init];
            wcfg.allowsInlineMediaPlayback = YES;
            WKUserContentController *ucc = wcfg.userContentController;

            PHLWeakScriptMessageProxy *proxy = [[PHLWeakScriptMessageProxy alloc] initWithDelegate:self];
            [ucc addScriptMessageHandler:proxy name:@"phlWebMediaPlaying"];

            WKUserScript *cleanScr = [[WKUserScript alloc] initWithSource:GetNuclearCleanAndAdBlockJS() injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
            [ucc addUserScript:cleanScr];

            NSString *bridgeSrc = [NSString stringWithFormat:@"%@;window.__phlAudioBridge.setGain(%.3f);", GetAudioBridgeJS(), self->_gain];
            WKUserScript *bScr = [[WKUserScript alloc] initWithSource:bridgeSrc injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
            [ucc addUserScript:bScr];

            self->_web = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wcfg];
            self->_web.navigationDelegate = self;
            self->_web.scrollView.bounces = YES;
            [self->_webBox addSubview:self->_web];

            self->_adminBtn = [self makeUtilityButtonWithTitle:@"💬 LIÊN HỆ TELEGRAM ADMIN"
                                                         fontSize:9.5
                                                          bgColor:[UIColor colorWithRed:0.25 green:0.07 blue:0.44 alpha:0.96]
                                                      borderColor:[UIColor colorWithRed:0.92 green:0.45 blue:1.0 alpha:0.9]
                                                           action:@selector(openAdminInfoGroup)];
            [self->_adminBtn setTitleColor:[UIColor colorWithRed:0.45 green:0.98 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            self->_adminBtn.layer.cornerRadius = 7;
            [self->_menuBox addSubview:self->_adminBtn];

            self->_cprLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            self->_cprLbl.text = @"BẢN QUYỀN THUỘC ADMIN TELEGRAM: @PHL0990\nZALO: 0522608620";
            self->_cprLbl.textColor = [UIColor colorWithRed:1.0 green:0.86 blue:0.55 alpha:0.98];
            self->_cprLbl.font = [UIFont systemFontOfSize:8 weight:UIFontWeightBold];
            self->_cprLbl.textAlignment = NSTextAlignmentCenter;
            self->_cprLbl.numberOfLines = 2;
            [self->_menuBox addSubview:self->_cprLbl];

            [self layoutMenuSubviewsWithWidth:mW height:mH expanded:NO];
            [self applyIndependentGain:self->_gain];
            [kw addSubview:self->_menuBox];
        } else if (self->_menuBox.superview != kw) {
            [kw addSubview:self->_menuBox];
        }

        [self fetchRemotePlaylist];
        [self fetchRemoteAdminConfig];
    });
}

#pragma mark - Nạp Cấu Hình Tối Cao

- (void)fetchRemoteAdminConfig {
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
    NSString *uStr = [NSString stringWithFormat:@"https://raw.githubusercontent.com/phamlong3539-stack/phl-music-data/main/config.json?t=%.0f", ts];
    NSURL *u = [NSURL URLWithString:uStr];
    if (!u) return;

    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:u cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:8.0];
    [req setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];

    NSURLSessionDataTask *t = [[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        NSHTTPURLResponse *hr = (NSHTTPURLResponse *)r;
        if (e || !d || hr.statusCode != 200) return;

        NSError *je = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:d options:0 error:&je];
        if (je || ![dict isKindOfClass:[NSDictionary class]]) return;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self applyRemoteAdminConfig:dict];
        });
    }];
    [t resume];
}

- (void)applyRemoteAdminConfig:(NSDictionary *)dict {
    // 1. KILL-SWITCH
    if ([dict[@"system_control"][@"kill_switch"] boolValue]) {
        [self pauseStreamPlayerIfPlaying];
        [self pauseWebMediaIfPlaying];
        _floatBtn.hidden = YES;
        _menuBox.hidden = YES;
        return;
    } else if (_floatBtn) {
        _floatBtn.hidden = NO;
    }

    // 2. ICON & HIỆU ỨNG THỞ NÚT NỔI
    NSString *fIcon = dict[@"system_control"][@"floating_icon"];
    if (fIcon && fIcon.length > 0 && _floatBtn) {
        [_floatBtn setTitle:fIcon forState:UIControlStateNormal];
    }
    BOOL enablePulse = [dict[@"system_control"][@"floating_pulse_glow"] boolValue];
    if (enablePulse) {
        if (![_floatBtn.layer animationForKey:@"phl_pulse_anim"]) {
            CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            pulse.duration = 1.1;
            pulse.repeatCount = HUGE_VALF;
            pulse.autoreverses = YES;
            pulse.fromValue = @(1.0);
            pulse.toValue = @(1.14);
            pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [_floatBtn.layer addAnimation:pulse forKey:@"phl_pulse_anim"];
        }
    } else {
        [_floatBtn.layer removeAnimationForKey:@"phl_pulse_anim"];
    }

    // 3. ĐỔI MÀU NEON THEME
    NSDictionary *th = dict[@"theme_customizer"];
    if (th) {
        UIColor *neon = ColorFromHex(th[@"neon_border_color"], [UIColor colorWithRed:0.85 green:0.42 blue:1.0 alpha:0.95]);
        _menuBox.layer.borderColor = neon.CGColor;
        _floatBtn.layer.borderColor = neon.CGColor;

        UIColor *cStart = ColorFromHex(th[@"gradient_start_color"], [UIColor colorWithRed:0.13 green:0.03 blue:0.28 alpha:1.0]);
        UIColor *cMid = ColorFromHex(th[@"gradient_mid_color"], [UIColor colorWithRed:0.23 green:0.05 blue:0.36 alpha:1.0]);
        UIColor *cEnd = ColorFromHex(th[@"gradient_end_color"], [UIColor colorWithRed:0.05 green:0.11 blue:0.27 alpha:1.0]);
        _gradient.colors = @[(id)cStart.CGColor, (id)cMid.CGColor, (id)cEnd.CGColor];
    }

    // 4. TIÊU ĐỀ & NÚT ADMIN
    NSDictionary *brand = dict[@"branding"];
    if (brand) {
        if (brand[@"header_title"]) _headerTitleLbl.text = brand[@"header_title"];
        if (brand[@"ticker_announcement"]) _tickerLbl.text = brand[@"ticker_announcement"];
        if (brand[@"admin_button_text"]) [_adminBtn setTitle:brand[@"admin_button_text"] forState:UIControlStateNormal];
        if (brand[@"admin_button_url"]) _adminTargetURL = brand[@"admin_button_url"];
        if (brand[@"footer_copyright"]) _cprLbl.text = brand[@"footer_copyright"];
    }

    // 5. CÔNG SUẤT ÂM LƯỢNG
    NSDictionary *audioCfg = dict[@"audio_engine"];
    if (audioCfg && audioCfg[@"max_gain"]) {
        _maxAllowedGain = [audioCfg[@"max_gain"] floatValue];
        _volSlider.maximumValue = _maxAllowedGain;
    }

    // 6. GHIM BÀI HÁT HOT TREND
    NSDictionary *feat = dict[@"vip_featured_song"];
    if (feat && [feat[@"enabled"] boolValue]) {
        _featuredVipSong = feat;
        [self injectFeaturedSongIntoPlaylist];
    }

    // 7. QUẢN LÝ YOUTUBE
    NSDictionary *ytCfg = dict[@"youtube_module"];
    if (ytCfg) {
        if (ytCfg[@"enabled"] != nil) _isYouTubeEnabled = [ytCfg[@"enabled"] boolValue];
        if (ytCfg[@"home_url"]) _youtubeHomeURL = ytCfg[@"home_url"];
        if (ytCfg[@"locked_reason"]) _youtubeLockedMsg = ytCfg[@"locked_reason"];

        if (!_isYouTubeEnabled) {
            [_btnWebToggle setTitle:@"🚫 YOUTUBE (TẠM KHÓA)" forState:UIControlStateNormal];
            [_btnWebToggle setTitleColor:[UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0] forState:UIControlStateNormal];
            _btnWebToggle.layer.borderColor = [UIColor redColor].CGColor;
            if (_webOpen) [self closeEmbeddedBrowser];
        } else {
            [_btnWebToggle setTitleColor:[UIColor colorWithRed:0.65 green:0.98 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            _btnWebToggle.layer.borderColor = [UIColor colorWithRed:0.38 green:0.95 blue:1.0 alpha:0.9].CGColor;
            NSString *t = _webOpen ? @"☰ ĐANG MỞ YOUTUBE • VỀ KHO NHẠC (THU GỌN)" : @"🌐 MỞ YOUTUBE VIP (ZERO ADS)";
            [_btnWebToggle setTitle:t forState:UIControlStateNormal];
        }
    }

    // 8. BẮN POPUP THÔNG BÁO TỪ XA
    NSDictionary *ann = dict[@"announcement"];
    if (ann && [ann[@"show"] boolValue]) {
        NSString *popId = ann[@"id"] ?: @"default";
        NSString *lastId = [[NSUserDefaults standardUserDefaults] stringForKey:@"PHL_LastSeenBroadcastID"];
        if (![lastId isEqualToString:popId]) {
            [[NSUserDefaults standardUserDefaults] setObject:popId forKey:@"PHL_LastSeenBroadcastID"];

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:ann[@"title"] ?: @"THÔNG BÁO"
                                                                           message:ann[@"message"] ?: @""
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:ann[@"button_title"] ?: @"Đóng" style:UIAlertActionStyleCancel handler:nil]];
            NSString *link = ann[@"action_url"];
            if (link && link.length > 0) {
                [alert addAction:[UIAlertAction actionWithTitle:@"Xem ngay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link] options:@{} completionHandler:nil];
                }]];
            }
            UIWindow *w = [self resolveActiveWindow];
            [w.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)injectFeaturedSongIntoPlaylist {
    if (!_featuredVipSong || !_playlist) return;
    NSString *vTitle = _featuredVipSong[@"title"];
    NSString *vUrl = _featuredVipSong[@"url"];
    if (!vTitle || !vUrl) return;

    if (_playlist.count > 0 && [_playlist.firstObject[@"url"] isEqualToString:vUrl]) {
        return;
    }
    NSDictionary *item = @{@"title": vTitle, @"url": vUrl};
    [_playlist insertObject:item atIndex:0];
    [_table reloadData];
}

#pragma mark - Delegate & Tương Tác Web

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [self cleanYouTubePageInWebView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self cleanYouTubePageInWebView];
    [self applyIndependentGain:_gain];
}

- (void)toggleEmbeddedBrowser {
    if (!_isYouTubeEnabled) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"🛡 THÔNG BÁO QUẢN TRỊ"
                                                                       message:_youtubeLockedMsg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Đã hiểu" style:UIAlertActionStyleCancel handler:nil]];
        UIWindow *w = [self resolveActiveWindow];
        [w.rootViewController presentViewController:alert animated:YES completion:nil];
        return;
    }

    _webOpen = !_webOpen;
    [self syncBrowserVisibilityAnimated:YES];
    if (_webOpen && !_webLoaded) {
        _webLoaded = YES;
        [self loadYouTubeURLString:_youtubeHomeURL];
    } else if (_webOpen) {
        [self cleanYouTubePageInWebView];
        [self applyIndependentGain:_gain];
    }
}

- (void)closeEmbeddedBrowser {
    [_searchBar resignFirstResponder];
    _webOpen = NO;
    [self syncBrowserVisibilityAnimated:YES];
}

- (void)syncBrowserVisibilityAnimated:(BOOL)animated {
    _webBox.hidden = !_webOpen;
    _table.hidden = _webOpen;
    NSString *t = _webOpen ? @"☰ ĐANG MỞ YOUTUBE • VỀ KHO NHẠC (THU GỌN)" : @"🌐 MỞ YOUTUBE VIP (ZERO ADS)";
    [_btnWebToggle setTitle:t forState:UIControlStateNormal];
    [self applyMenuFrameForExpanded:_webOpen animated:animated];
}

- (void)loadYouTubeURLString:(NSString *)urlStr {
    if (!_web || !urlStr || urlStr.length == 0) return;
    NSURL *u = [NSURL URLWithString:urlStr];
    if (!u) return;
    NSURLRequest *req = [NSURLRequest requestWithURL:u cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [_web loadRequest:req];
}

- (void)webGoHome {
    _webLoaded = YES;
    [self loadYouTubeURLString:_youtubeHomeURL];
}

- (void)triggerYouTubeSearch {
    [_searchBar resignFirstResponder];
    NSString *raw = [_searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!_webOpen) {
        _webOpen = YES;
        [self syncBrowserVisibilityAnimated:YES];
    }
    if (raw.length == 0) {
        _webLoaded = YES;
        [self loadYouTubeURLString:_youtubeHomeURL];
        return;
    }
    NSString *enc = [raw stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    _webLoaded = YES;
    [self loadYouTubeURLString:[NSString stringWithFormat:@"https://m.youtube.com/results?search_query=%@", enc ?: @""]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf {
    if (tf == _searchBar) {
        [self triggerYouTubeSearch];
        return NO;
    }
    return YES;
}

- (void)webGoBack {
    if (_web.canGoBack) [_web goBack];
}

- (void)webGoForward {
    if (_web.canGoForward) [_web goForward];
}

- (void)loadRemoteLogo {
    NSURL *lu = [NSURL URLWithString:@"https://raw.githubusercontent.com/phamlong3539-stack/phl-music-data/main/logo.png"];
    if (!lu) return;

    NSURLSessionDataTask *t = [[NSURLSession sharedSession] dataTaskWithURL:lu completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        NSHTTPURLResponse *hr = (NSHTTPURLResponse *)r;
        if (e || !d || hr.statusCode != 200) return;
        UIImage *img = [UIImage imageWithData:d];
        if (!img) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_floatBtn setImage:img forState:UIControlStateNormal];
            self->_floatBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self->_floatBtn setTitle:@"" forState:UIControlStateNormal];
        });
    }];
    [t resume];
}

- (void)toggleMenu {
    _menuOpen = !_menuOpen;
    if (_menuOpen) {
        [self initializeFramework];
        [self applyMenuFrameForExpanded:_webOpen animated:NO];
        [self applyIndependentGain:_gain];
        [self fetchRemotePlaylist];
        [self fetchRemoteAdminConfig];
        [self syncPlayPauseButton];
        _menuBox.hidden = NO;
        [UIView animateWithDuration:0.18 animations:^{
            self->_menuBox.alpha = 1.0;
        }];
    } else {
        [_searchBar resignFirstResponder];
        [UIView animateWithDuration:0.16 animations:^{
            self->_menuBox.alpha = 0.0;
        } completion:^(BOOL fin) {
            self->_menuBox.hidden = YES;
        }];
    }
}

- (void)clampViewToSafeBounds:(UIView *)v topMargin:(CGFloat)tm bottomMargin:(CGFloat)bm {
    if (!v || !v.superview) return;
    CGSize sz = v.superview.bounds.size;
    CGFloat hw = v.bounds.size.width / 2.0f;
    CGFloat hh = v.bounds.size.height / 2.0f;

    CGFloat minX = hw + 6.0f;
    CGFloat maxX = sz.width - hw - 6.0f;
    CGFloat minY = hh + tm;
    CGFloat maxY = sz.height - hh - bm;

    CGPoint c = v.center;
    if (minX <= maxX) c.x = MAX(minX, MIN(maxX, c.x));
    if (minY <= maxY) c.y = MAX(minY, MIN(maxY, c.y));
    v.center = c;
}

- (void)handleFloatingPan:(UIPanGestureRecognizer *)p {
    UIView *v = p.view;
    if (!v || !v.superview) return;
    CGPoint tr = [p translationInView:v.superview];
    v.center = CGPointMake(v.center.x + tr.x, v.center.y + tr.y);
    [self clampViewToSafeBounds:v topMargin:14.0f bottomMargin:14.0f];
    [p setTranslation:CGPointZero inView:v.superview];
}

- (void)handleMenuHeaderPan:(UIPanGestureRecognizer *)p {
    if (!_menuBox || !_menuBox.superview) return;
    CGPoint tr = [p translationInView:_menuBox.superview];
    _menuBox.center = CGPointMake(_menuBox.center.x + tr.x, _menuBox.center.y + tr.y);
    [self clampViewToSafeBounds:_menuBox topMargin:6.0f bottomMargin:6.0f];
    [p setTranslation:CGPointZero inView:_menuBox.superview];
}

- (void)fetchRemotePlaylist {
    NSURL *u = [NSURL URLWithString:@"https://raw.githubusercontent.com/phamlong3539-stack/phl-music-data/main/playlist.json"];
    if (!u) return;

    NSURLSessionConfiguration *c = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *s = [NSURLSession sessionWithConfiguration:c];

    NSURLSessionDataTask *t = [s dataTaskWithURL:u completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        NSHTTPURLResponse *hr = (NSHTTPURLResponse *)r;
        if (e || !d || hr.statusCode != 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_statusMsg = [NSString stringWithFormat:@"Không tải được danh sách (Mã %ld)", (long)hr.statusCode];
                [self->_table reloadData];
            });
            return;
        }

        NSError *je = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:d options:0 error:&je];
        if (je || ![dict isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_statusMsg = @"Lỗi dữ liệu danh sách phát";
                [self->_table reloadData];
            });
            return;
        }

        NSArray *songs = dict[@"songs"];
        if (![songs isKindOfClass:[NSArray class]] || songs.count == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_playlist removeAllObjects];
                self->_statusMsg = @"Danh sách bài hát đang trống";
                [self->_table reloadData];
            });
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_playlist removeAllObjects];
            [self->_playlist addObjectsFromArray:songs];
            [self injectFeaturedSongIntoPlaylist];
            self->_statusMsg = nil;
            [self->_table reloadData];
        });
    }];
    [t resume];
}

- (void)playSongAtIndex:(NSInteger)index {
    if (index < 0 || index >= (NSInteger)_playlist.count) return;
    NSDictionary *song = _playlist[index];
    NSString *title = song[@"title"] ?: @"Bài hát chưa đặt tên";
    NSString *urlString = song[@"url"] ?: @"";
    if (urlString.length == 0) return;

    [self pauseWebMediaIfPlaying];
    [self configureAudioSession];

    NSString *enc = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *u = [NSURL URLWithString:enc ?: urlString];
    if (!u) return;

    _idx = index;
    _titleLbl.text = [NSString stringWithFormat:@"♪ %@", title];

    _playerItem = [AVPlayerItem playerItemWithURL:u];
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:_playerItem];
    } else {
        [_player replaceCurrentItemWithPlayerItem:_playerItem];
    }
    _player.muted = (_gain <= 0.001f);
    _player.volume = MIN(1.0f, _gain);
    [self applyGainToItem:_playerItem gain:_gain];
    [_player play];
    [self syncPlayPauseButton];
    [_table reloadData];
}

- (void)togglePlayPause {
    if (!_player || _idx < 0) {
        if (_playlist.count > 0) [self playSongAtIndex:0];
        return;
    }
    if (_player.rate > 0.01f) {
        [_player pause];
    } else {
        [self pauseWebMediaIfPlaying];
        [self configureAudioSession];
        _player.muted = (_gain <= 0.001f);
        _player.volume = MIN(1.0f, _gain);
        [self applyGainToItem:_playerItem gain:_gain];
        [_player play];
    }
    [self syncPlayPauseButton];
}

- (void)syncPlayPauseButton {
    BOOL isPlaying = (_player && _player.rate > 0.01f);
    _btnPlay.activeState = isPlaying;
    [_btnPlay refreshTransportVisual];
}

- (void)playPreviousSong {
    [_btnPrev triggerPulseMark];
    if (_playlist.count == 0) return;
    NSInteger prev = (_idx <= 0) ? ((NSInteger)_playlist.count - 1) : (_idx - 1);
    [self playSongAtIndex:prev];
}

- (void)playNextSong {
    [_btnNext triggerPulseMark];
    if (_playlist.count == 0) return;
    NSInteger nxt = (_idx + 1) % (NSInteger)_playlist.count;
    [self playSongAtIndex:nxt];
}

- (void)volumeSliderChanged:(UISlider *)s {
    [self applyIndependentGain:s.value];
}

- (void)decreaseVolumeStep {
    float nxt = MAX(0.0f, _gain - 0.15f);
    _volSlider.value = nxt;
    [self applyIndependentGain:nxt];
}

- (void)increaseVolumeStep {
    float nxt = MIN(_maxAllowedGain, _gain + 0.15f);
    _volSlider.value = nxt;
    [self applyIndependentGain:nxt];
}

- (void)toggleRepeatMode {
    _repOne = !_repOne;
    [[NSUserDefaults standardUserDefaults] setBool:_repOne forKey:@"PHL_RepeatOneSong"];
    [self syncRepeatButton];
}

- (void)syncRepeatButton {
    _btnRep.activeState = _repOne;
    [_btnRep refreshTransportVisual];
}

- (void)openAdminInfoGroup {
    if (!_adminTargetURL || _adminTargetURL.length == 0) return;
    NSURL *u = [NSURL URLWithString:_adminTargetURL];
    if (!u) return;
    [[UIApplication sharedApplication] openURL:u options:@{} completionHandler:nil];
}

#pragma mark - Table View Data Source & Delegate

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s {
    return _playlist.count > 0 ? _playlist.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    static NSString *cid = @"PHLSongCell";
    UITableViewCell *c = [tv dequeueReusableCellWithIdentifier:cid];
    if (!c) {
        c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cid];
        c.backgroundColor = [UIColor clearColor];
        c.textLabel.font = [UIFont systemFontOfSize:10.5 weight:UIFontWeightSemibold];
        c.detailTextLabel.font = [UIFont systemFontOfSize:8.5];
    }

    if (_playlist.count == 0) {
        c.textLabel.textColor = [UIColor colorWithRed:1.0 green:0.65 blue:0.75 alpha:1.0];
        c.textLabel.text = _statusMsg ?: @"Không có bài hát";
        c.detailTextLabel.textColor = [UIColor lightGrayColor];
        c.detailTextLabel.text = @"Chạm để thử tải lại";
        return c;
    }

    NSDictionary *song = _playlist[ip.row];
    NSString *title = song[@"title"] ?: @"Bài hát chưa đặt tên";
    BOOL isCur = (ip.row == _idx);

    c.textLabel.textColor = isCur ? [UIColor colorWithRed:1.0 green:0.65 blue:1.0 alpha:1.0] : [UIColor whiteColor];
    c.textLabel.text = title;
    c.detailTextLabel.textColor = isCur ? [UIColor colorWithRed:0.35 green:1.0 blue:0.75 alpha:1.0] : [UIColor colorWithRed:0.45 green:0.92 blue:1.0 alpha:1.0];
    c.detailTextLabel.text = isCur ? @"🔊 Đang phát trực tiếp" : @"▶ Chạm để phát nhạc";
    return c;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    [tv deselectRowAtIndexPath:ip animated:YES];
    if (_playlist.count == 0) {
        _statusMsg = @"Đang tải lại danh sách nhạc...";
        [tv reloadData];
        [self fetchRemotePlaylist];
        return;
    }
    [self playSongAtIndex:ip.row];
}

@end

#pragma mark - Constructor Khởi Chạy

__attribute__((constructor)) static void LibraryEntryPoint(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[PHLProtectedAudioManager sharedInstance] initializeFramework];
    });
}
