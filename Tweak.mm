// ==============================================================================
// 👑 PHL ENTERPRISE SECURE AUDIO RUNTIME (ARM64 ZERO-LATENCY MASTER ENGINE)
// CÔNG NGHỆ: DIRECT GITHUB CORE API • REAL-TIME ZERO DELAY • NUCLEAR AD-BLOCK
//
// 🔧 FIXED by Senior Dev (50yr exp) - v2.2.0 (POPUP LUÔN HIỆN KHI MỞ APP/MENU)
// ==============================================================================

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
#import <QuartzCore/QuartzCore.h>
#include <dlfcn.h>
#include <sys/sysctl.h>
#include <mach-o/dyld.h>

typedef NS_ENUM(NSInteger, TransportButtonKind) {
    TransportButtonKindPrevious  = 0,
    TransportButtonKindPlayPause = 1,
    TransportButtonKindNext      = 2,
    TransportButtonKindRepeat    = 3
};

#pragma mark - Utilities

static inline UIColor *ColorFromHex(NSString *hexString, UIColor *fallback) {
    if (!hexString || hexString.length == 0) return fallback;
    NSString *clean = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if (clean.length != 6) return fallback;
    unsigned int rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:clean];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                           green:((rgbValue & 0x00FF00) >> 8)  / 255.0
                            blue: (rgbValue & 0x0000FF)         / 255.0
                           alpha:1.0];
}

#pragma mark - NSTimer Weak Proxy

@interface PHLWeakTimerTarget : NSObject
@property (nonatomic, weak)   id  target;
@property (nonatomic, assign) SEL selector;
+ (instancetype)proxyWithTarget:(id)target selector:(SEL)selector;
@end

@implementation PHLWeakTimerTarget
+ (instancetype)proxyWithTarget:(id)target selector:(SEL)selector {
    PHLWeakTimerTarget *p = [PHLWeakTimerTarget new];
    p.target   = target;
    p.selector = selector;
    return p;
}
- (void)fire:(NSTimer *)t {
    if (self.target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:nil];
#pragma clang diagnostic pop
    } else {
        [t invalidate];
    }
}
@end

#pragma mark - WKWebView Script Message Weak Proxy

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

#pragma mark - Transport Button

@interface PHLTransportButton : UIButton
@property (nonatomic, assign) TransportButtonKind iconKind;
@property (nonatomic, assign) BOOL activeState;
@property (nonatomic, assign) BOOL pulseHighlight;
@property (nonatomic, strong) CAShapeLayer *glyphLayer;
@property (nonatomic, strong) CAShapeLayer *markerDotLayer;
+ (instancetype)buttonWithKind:(TransportButtonKind)kind actionTarget:(id)target action:(SEL)action;
- (void)refreshTransportVisual;
- (void)triggerPulseMark;
@end

@implementation PHLTransportButton

+ (instancetype)buttonWithKind:(TransportButtonKind)kind actionTarget:(id)target action:(SEL)action {
    PHLTransportButton *btn = [PHLTransportButton buttonWithType:UIButtonTypeCustom];
    btn.iconKind   = kind;
    btn.activeState = NO;
    btn.pulseHighlight = NO;
    btn.layer.cornerRadius = 8.0f;
    btn.layer.borderWidth  = 1.15f;
    btn.clipsToBounds = YES;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    btn.glyphLayer = [CAShapeLayer layer];
    btn.glyphLayer.fillColor   = [UIColor clearColor].CGColor;
    btn.glyphLayer.strokeColor = [UIColor whiteColor].CGColor;
    btn.glyphLayer.lineWidth   = 1.6f;
    btn.glyphLayer.lineCap     = kCALineCapRound;
    btn.glyphLayer.lineJoin    = kCALineJoinRound;
    [btn.layer addSublayer:btn.glyphLayer];

    btn.markerDotLayer = [CAShapeLayer layer];
    btn.markerDotLayer.hidden = YES;
    [btn.layer addSublayer:btn.markerDotLayer];

    [btn refreshTransportVisual];
    return btn;
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
    CGFloat cx = w * 0.5f, cy = h * 0.5f;

    if (self.iconKind == TransportButtonKindPlayPause) {
        self.backgroundColor = self.activeState
            ? [UIColor colorWithRed:0.86 green:0.18 blue:0.82 alpha:0.98]
            : [UIColor colorWithRed:0.62 green:0.14 blue:0.68 alpha:0.94];
    } else {
        self.backgroundColor = marked
            ? [UIColor colorWithRed:0.34 green:0.12 blue:0.58 alpha:0.96]
            : [UIColor colorWithRed:0.18 green:0.06 blue:0.36 alpha:0.90];
    }
    self.layer.borderColor = marked
        ? [UIColor colorWithRed:0.42 green:0.98 blue:1.0 alpha:1.0].CGColor
        : [UIColor colorWithRed:0.78 green:0.38 blue:1.0 alpha:0.82].CGColor;

    UIBezierPath *path = [UIBezierPath bezierPath];
    switch (self.iconKind) {
        case TransportButtonKindPrevious: {
            CGFloat bx = cx - 5.5f;
            [path moveToPoint:CGPointMake(bx, cy - 4.5f)];
            [path addLineToPoint:CGPointMake(bx, cy + 4.5f)];
            [path moveToPoint:CGPointMake(cx + 5.5f, cy - 4.5f)];
            [path addLineToPoint:CGPointMake(bx + 1.8f, cy)];
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
            CGFloat bx = cx + 5.5f;
            [path moveToPoint:CGPointMake(cx - 5.5f, cy - 4.5f)];
            [path addLineToPoint:CGPointMake(bx - 1.8f, cy)];
            [path addLineToPoint:CGPointMake(cx - 5.5f, cy + 4.5f)];
            [path closePath];
            [path moveToPoint:CGPointMake(bx, cy - 4.5f)];
            [path addLineToPoint:CGPointMake(bx, cy + 4.5f)];
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
            [path moveToPoint:CGPointMake(cx - rx + 2.4f, cy - ry - 2.0f)];
            [path addLineToPoint:CGPointMake(cx - rx, cy + ry)];
            [path addLineToPoint:CGPointMake(cx - rx + 2.4f, cy + ry + 2.0f)];
            break;
        }
    }

    self.glyphLayer.frame       = self.bounds;
    self.glyphLayer.path        = path.CGPath;
    self.glyphLayer.strokeColor = marked
        ? [UIColor colorWithRed:1.0 green:0.96 blue:0.65 alpha:1.0].CGColor
        : [UIColor whiteColor].CGColor;

    self.markerDotLayer.hidden = !marked;
    if (marked) {
        UIBezierPath *dot = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(w - 7.5f, 3.5f, 4.2f, 4.2f)];
        self.markerDotLayer.frame     = self.bounds;
        self.markerDotLayer.path      = dot.CGPath;
        self.markerDotLayer.fillColor = [UIColor colorWithRed:0.38 green:1.0 blue:0.78 alpha:1.0].CGColor;
    }
}
@end

#pragma mark - Core Manager

@interface PHLProtectedAudioManager : NSObject
    <UITableViewDataSource, UITableViewDelegate,
     UITextFieldDelegate,
     WKNavigationDelegate, WKScriptMessageHandler> {

    AVPlayer        *_player;
    AVPlayerItem    *_playerItem;

    UIButton        *_floatBtn;
    UIView          *_menuBox;
    CAGradientLayer *_gradient;
    UIView          *_dragHdr;
    UIButton        *_closeBtn;
    UITableView     *_table;
    UILabel         *_headerTitleLbl;
    UILabel         *_tickerLbl;
    UILabel         *_titleLbl;

    PHLTransportButton *_btnPrev, *_btnPlay, *_btnNext, *_btnRep;

    UIButton        *_btnMute, *_btnVolUp;
    UISlider        *_volSlider;
    UILabel         *_gainLbl;

    UIButton        *_btnWebToggle;
    UIView          *_webBox;
    UIButton        *_btnBack, *_btnFwd, *_btnHome, *_btnCloseW;
    UITextField     *_searchBar;
    UIButton        *_btnSearch;
    WKWebView       *_web;
    BOOL             _webOpen;
    BOOL             _webLoaded;

    UIButton        *_adminBtn;
    UILabel         *_cprLbl;

    NSMutableArray  *_playlist;
    NSDictionary    *_featuredVipSong;
    NSString        *_statusMsg;
    NSInteger        _idx;
    BOOL             _menuOpen;
    BOOL             _repOne;
    float            _gain;

    BOOL             _isYouTubeEnabled;
    NSString        *_youtubeHomeURL;
    NSString        *_youtubeLockedMsg;
    NSString        *_adminTargetURL;
    float            _maxAllowedGain;
    NSTimer         *_autoSyncTimer;

    // QUẢN LÝ POPUP
    NSDictionary    *_cachedAnnouncement;
    BOOL             _isShowingAnnouncement;
    BOOL             _hasShownPopupOnLaunch;

    NSDate          *_lastConfigFetchDate;
    BOOL             _menuCurrentlyExpanded;
    BOOL             _menuFrameInitialized;
}
+ (instancetype)sharedInstance;
- (void)initializeFramework;
@end

@implementation PHLProtectedAudioManager

// ─────────────── JavaScript ────────────────────────────────────────────────

static inline NSString *GetNuclearCleanAndAdBlockJS(void) {
    return @"(function(){"
            "var css='ytm-mobile-topbar-renderer,ytm-search-header,[role=\"search\"],"
            ".ad-container,.companion-ad-container,ytm-promoted-sparkles-web-renderer,"
            ".ytp-ad-overlay-container,.ytp-ad-skip-button-slot,ytd-banner-promo-renderer,"
            "ytm-paid-content-overlay-renderer,.video-ads,ytm-promoted-video-renderer,"
            "ytm-pivot-bar-renderer,ytm-bottom-nav-bar,nav.pivot-bar"
            "{display:none!important;height:0px!important;visibility:hidden!important;pointer-events:none!important}"
            "ytm-page-manager,#app,ytm-app{padding-top:0px!important;margin-top:0px!important;padding-bottom:0px!important}';"
            "var sid='phl-nuke';if(!document.getElementById(sid)){"
            "var st=document.createElement('style');st.id=sid;st.textContent=css;"
            "(document.head||document.documentElement).appendChild(st);}"
            "function purge(){"
            "document.querySelectorAll('ytm-mobile-topbar-renderer,ytm-search-header,[role=\"search\"],.ad-container,ytm-pivot-bar-renderer').forEach(function(e){e.remove();});"
            "var sk=document.querySelector('.ytp-ad-skip-button,.ytp-ad-skip-button-modern,.videoAdUiSkipButton,.ytp-ad-skip-button-slot button');"
            "if(sk){sk.click();}"
            "var ad=document.querySelector('.ad-showing,.ad-interrupting');"
            "var v=document.querySelector('video');"
            "if(ad&&v&&!isNaN(v.duration)){v.muted=true;v.playbackRate=16.0;v.currentTime=v.duration;}}"
            "purge();setInterval(purge,250);"
            "})();";
}

static inline NSString *GetAudioBridgeJS(void) {
    return @"(function(){"
            "if(!window.__phlAudioBridge){"
            "window.__phlAudioBridge={"
            "gain:1.0,ctx:null,nodes:new WeakMap(),"
            "pauseAll:function(){document.querySelectorAll('video,audio').forEach(function(e){try{e.pause();}catch(x){}});},"
            "ensureContext:function(){"
            "if(!this.ctx){var AC=window.AudioContext||window.webkitAudioContext;if(AC){try{this.ctx=new AC();}catch(x){}}}"
            "if(this.ctx&&this.ctx.state==='suspended'){this.ctx.resume().catch(function(){});}},"
            "hookElement:function(e){"
            "var self=this;"
            "if(!e.__phlPlayHooked){e.__phlPlayHooked=true;e.addEventListener('play',function(){self.applyToElement(e);"
            "if(window.webkit&&window.webkit.messageHandlers&&window.webkit.messageHandlers.phlWebMediaPlaying){"
            "window.webkit.messageHandlers.phlWebMediaPlaying.postMessage('playing');}},true);}"
            "self.applyToElement(e);},"
            "applyToElement:function(e){"
            "var g=Math.max(0.0,Math.min(3.0,this.gain));try{e.muted=(g<=0.001);e.volume=Math.min(1.0,g);}catch(x){}"
            "if(g>1.0){this.ensureContext();if(this.ctx){try{"
            "var ni=this.nodes.get(e);"
            "if(!ni){var src=this.ctx.createMediaElementSource(e);var gn=this.ctx.createGain();"
            "var bs=this.ctx.createBiquadFilter();bs.type='lowshelf';bs.frequency.value=250;bs.gain.value=4.0;"
            "src.connect(bs);bs.connect(gn);gn.connect(this.ctx.destination);"
            "ni={gainNode:gn};this.nodes.set(e,ni);}"
            "ni.gainNode.gain.setTargetAtTime(g,this.ctx.currentTime,0.02);}catch(x){}}"
            "}else{var xi=this.nodes.get(e);if(xi&&xi.gainNode&&this.ctx){"
            "try{xi.gainNode.gain.setTargetAtTime(g,this.ctx.currentTime,0.02);}catch(x){}}}},"
            "setGain:function(v){"
            "this.gain=Math.max(0.0,Math.min(3.0,parseFloat(v)||0.0));"
            "var self=this;document.querySelectorAll('video,audio').forEach(function(e){self.hookElement(e);});}"
            "};}}();";
}

// ─────────────── Singleton ─────────────────────────────────────────────────

+ (instancetype)sharedInstance {
    static PHLProtectedAudioManager *inst = nil;
    static dispatch_once_t tk;
    dispatch_once(&tk, ^{ inst = [[PHLProtectedAudioManager alloc] init]; });
    return inst;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    _playlist           = [[NSMutableArray alloc] init];
    _statusMsg          = @"Đang nạp dữ liệu Master VIP...";
    _idx                = -1;
    _menuOpen           = NO;
    _webOpen            = NO;
    _webLoaded          = NO;
    _menuCurrentlyExpanded = NO;
    _menuFrameInitialized  = NO;
    _isShowingAnnouncement = NO;
    _hasShownPopupOnLaunch = NO;
    _cachedAnnouncement    = nil;
    _lastConfigFetchDate   = nil;

    _isYouTubeEnabled   = YES;
    _youtubeHomeURL     = @"https://m.youtube.com";
    _youtubeLockedMsg   = @"Tính năng YouTube đang bảo trì!";
    _adminTargetURL     = @"https://phamlong09.store";
    _maxAllowedGain     = 3.0f;

    NSUserDefaults *ud  = [NSUserDefaults standardUserDefaults];
    _repOne = [ud objectForKey:@"PHL_RepeatOneSong"]
        ? [ud boolForKey:@"PHL_RepeatOneSong"] : NO;
    _gain = [ud objectForKey:@"PHL_IndependentAudioGain"]
        ? [ud floatForKey:@"PHL_IndependentAudioGain"] : 1.0f;

    [self configureAudioSession];

    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(handleItemDidFinish:)
               name:AVPlayerItemDidPlayToEndTimeNotification
             object:nil];

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_autoSyncTimer invalidate];
    _autoSyncTimer = nil;
}

// ─────────────── Audio Session ─────────────────────────────────────────────

- (void)configureAudioSession {
    NSError *err = nil;
    AVAudioSession *s = [AVAudioSession sharedInstance];
    [s setCategory:AVAudioSessionCategoryPlayback
       withOptions:AVAudioSessionCategoryOptionAllowAirPlay
             error:&err];
    [s setActive:YES error:&err];
}

- (void)handleItemDidFinish:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_repOne && self->_idx >= 0 && self->_idx < (NSInteger)self->_playlist.count) {
            [self playSongAtIndex:self->_idx];
        } else if (self->_playlist.count > 0) {
            [self playSongAtIndex:(self->_idx + 1) % (NSInteger)self->_playlist.count];
        }
    });
}

// ─────────────── Gain & Volume ─────────────────────────────────────────────

- (void)applyGainToItem:(AVPlayerItem *)item gain:(float)gain {
    if (!item || !item.asset) return;
    if (gain <= 1.001f) { item.audioMix = nil; return; }
    NSArray<AVAssetTrack *> *tracks = [item.asset tracksWithMediaType:AVMediaTypeAudio];
    if (!tracks.count) return;
    AVMutableAudioMix *mix = [AVMutableAudioMix audioMix];
    NSMutableArray *arr = [NSMutableArray array];
    for (AVAssetTrack *t in tracks) {
        AVMutableAudioMixInputParameters *p =
            [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:t];
        [p setVolume:gain atTime:kCMTimeZero];
        [arr addObject:p];
    }
    mix.inputParameters = arr;
    item.audioMix = mix;
}

- (void)applyIndependentGain:(float)gain {
    float v = MAX(0.0f, MIN(_maxAllowedGain, gain));
    _gain = v;
    [[NSUserDefaults standardUserDefaults] setFloat:v forKey:@"PHL_IndependentAudioGain"];

    if (_gainLbl) {
        int pct = (int)roundf(v * 100.0f);
        _gainLbl.text = [NSString stringWithFormat:@"%d%%", pct];
        _gainLbl.textColor = (v > 1.0f)
            ? [UIColor colorWithRed:1.0 green:0.45 blue:0.65 alpha:1.0]
            : [UIColor colorWithRed:0.45 green:0.98 blue:1.0 alpha:1.0];
    }
    if (_player) {
        _player.muted  = (v <= 0.001f);
        _player.volume = MIN(1.0f, v);
        if (_playerItem) [self applyGainToItem:_playerItem gain:v];
    }
    if (_web) {
        NSString *js = [NSString stringWithFormat:
            @"%@;if(window.__phlAudioBridge){window.__phlAudioBridge.setGain(%.3f);}",
            GetAudioBridgeJS(), v];
        [_web evaluateJavaScript:js completionHandler:nil];
    }
}

- (void)pauseStreamPlayerIfPlaying {
    if (_player && _player.rate > 0.01f) {
        [_player pause];
        [self syncPlayPauseButton];
    }
}

- (void)pauseWebMediaIfPlaying {
    if (!_web) return;
    [_web evaluateJavaScript:
        @"(function(){if(window.__phlAudioBridge){window.__phlAudioBridge.pauseAll();}"
        @"document.querySelectorAll('video,audio').forEach(function(e){try{e.pause();}catch(x){}});})();"
                completionHandler:nil];
}

// ─────────────── Logo Render ───────────────────────────────────────────────

- (UIImage *)renderLogoImageWithSize:(CGFloat)sz {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz, sz), NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) { UIGraphicsEndImageContext(); return nil; }

    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] = { 0.52f,0.10f,0.88f,1.0f, 0.18f,0.04f,0.42f,1.0f };
    CGGradientRef grad = CGGradientCreateWithColorComponents(cs, colors, NULL, 2);
    CGContextAddEllipseInRect(ctx, CGRectMake(1, 1, sz-2, sz-2));
    CGContextClip(ctx);
    CGContextDrawRadialGradient(ctx, grad,
        CGPointMake(sz*0.42f, sz*0.38f), 0,
        CGPointMake(sz*0.5f,  sz*0.5f),  sz*0.5f, 0);
    CGGradientRelease(grad);
    CGColorSpaceRelease(cs);

    CGContextSetStrokeColorWithColor(ctx,
        [UIColor colorWithRed:0.0 green:0.95 blue:1.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(ctx, 2.0f);
    CGContextAddEllipseInRect(ctx, CGRectMake(1.5, 1.5, sz-3, sz-3));
    CGContextStrokePath(ctx);

    NSString *note = @"♪";
    NSDictionary *attrs = @{
        NSFontAttributeName: [UIFont systemFontOfSize:sz*0.5f weight:UIFontWeightBold],
        NSForegroundColorAttributeName: [UIColor colorWithRed:1.0 green:0.9 blue:0.3 alpha:1.0]
    };
    CGSize ns = [note sizeWithAttributes:attrs];
    [note drawAtPoint:CGPointMake((sz-ns.width)*0.5f, (sz-ns.height)*0.5f+1.f)
       withAttributes:attrs];

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

// ─────────────── Window & ViewController Helpers ───────────────────────────

- (UIWindow *)resolveActiveWindow {
    for (UIWindowScene *s in [UIApplication sharedApplication].connectedScenes) {
        if (s.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *w in s.windows) { if (w.isKeyWindow) return w; }
            if (s.windows.firstObject) return s.windows.firstObject;
        }
    }
    return [UIApplication sharedApplication].windows.firstObject;
}

- (UIViewController *)resolveTopViewController {
    UIWindow *w    = [self resolveActiveWindow];
    UIViewController *vc = w.rootViewController;
    while (vc.presentedViewController) vc = vc.presentedViewController;
    return vc;
}

// ─────────────── [POPUP THÔNG BÁO] ─────────────────────────────────────────

- (void)triggerAnnouncementPopupExplicitly {
    if (!_cachedAnnouncement) return;
    if (![_cachedAnnouncement[@"show"] boolValue]) return;
    if (_isShowingAnnouncement) return;

    UIViewController *top = [self resolveTopViewController];
    if (!top || top.presentedViewController) return;

    _isShowingAnnouncement = YES;
    _hasShownPopupOnLaunch = YES;

    NSString *title = _cachedAnnouncement[@"title"] ?: @"👑 THÔNG BÁO";
    NSString *msg   = _cachedAnnouncement[@"message"] ?: @"";
    NSString *okTxt = _cachedAnnouncement[@"button_title"] ?: @"Đóng";
    NSString *link  = _cachedAnnouncement[@"action_url"];

    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:title
                                            message:msg
                                     preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:okTxt
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *a) {
        self->_isShowingAnnouncement = NO;
    }]];

    if (link.length > 0) {
        [alert addAction:[UIAlertAction actionWithTitle:@"Xem ngay"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *a) {
            self->_isShowingAnnouncement = NO;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]
                                               options:@{}
                                     completionHandler:nil];
        }]];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [top presentViewController:alert animated:YES completion:nil];
    });
}

// ─────────────── Button Factory ────────────────────────────────────────────

- (UIButton *)makeUtilBtn:(NSString *)title size:(CGFloat)sz
                       bg:(UIColor *)bg border:(UIColor *)bc action:(SEL)act {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font  = [UIFont systemFontOfSize:sz weight:UIFontWeightBold];
    btn.backgroundColor  = bg;
    btn.layer.cornerRadius = 8;
    btn.layer.borderWidth  = 1.1;
    btn.layer.borderColor  = bc.CGColor;
    [btn addTarget:self action:act forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

// ─────────────── Layout ────────────────────────────────────────────────────

- (void)layoutMenuSubviewsWithWidth:(CGFloat)mW height:(CGFloat)mH expanded:(BOOL)exp {
    CGFloat padX = 10.0f, inW = mW - padX * 2.0f;

    _gradient.frame  = CGRectMake(0, 0, mW, mH);
    _dragHdr.frame   = CGRectMake(0, 0, mW, 48.0f);
    _closeBtn.frame  = CGRectMake(mW - 34.0f, 7.0f, 24.0f, 24.0f);

    _headerTitleLbl.frame = CGRectMake(10, 4,  mW - 48, 15);
    _tickerLbl.frame      = CGRectMake(10, 19, mW - 48, 12);
    _titleLbl.frame       = CGRectMake(10, 32, mW - 44, 13);

    _btnPrev.hidden = exp; _btnPlay.hidden = exp;
    _btnNext.hidden = exp; _btnRep.hidden  = exp;

    if (!exp) {
        CGFloat gap = 6.0f, bw = (inW - gap * 3.0f) / 4.0f, cY = 52.0f;
        _btnPrev.frame = CGRectMake(padX,                        cY, bw, 24.0f);
        _btnPlay.frame = CGRectMake(padX + (bw+gap),             cY, bw, 24.0f);
        _btnNext.frame = CGRectMake(padX + (bw+gap)*2.0f,        cY, bw, 24.0f);
        _btnRep.frame  = CGRectMake(padX + (bw+gap)*3.0f,        cY, bw, 24.0f);
    }

    CGFloat vy = exp ? 51.0f : 81.0f;
    CGFloat wy = exp ? 75.0f : 106.0f;
    CGFloat cy = exp ? 102.0f : 133.0f;
    CGFloat bW = 34.0f;

    _btnMute.frame    = CGRectMake(padX, vy, 24.0f, 22.0f);
    _volSlider.frame  = CGRectMake(padX+26.0f, vy, MAX(60.0f, inW-26.0f-24.0f-bW-2.0f), 22.0f);
    _btnVolUp.frame   = CGRectMake(mW-padX-bW-26.0f, vy, 24.0f, 22.0f);
    _gainLbl.frame    = CGRectMake(mW-padX-bW, vy, bW, 22.0f);
    _btnWebToggle.frame = CGRectMake(padX, wy, inW, 23.0f);

    CGFloat fH = 48.0f, cH = MAX(120.0f, mH - cy - fH - 4.0f);
    _table.frame  = CGRectMake(8.0f, cy, mW-16.0f, cH);
    _webBox.frame = CGRectMake(8.0f, cy, mW-16.0f, cH);

    CGFloat pW = _webBox.bounds.size.width, pH = _webBox.bounds.size.height;
    _btnBack.frame   = CGRectMake(4.0f,     4.0f, 24.0f, 21.0f);
    _btnFwd.frame    = CGRectMake(31.0f,    4.0f, 24.0f, 21.0f);
    _btnHome.frame   = CGRectMake(58.0f,    4.0f, 38.0f, 21.0f);
    _btnCloseW.frame = CGRectMake(pW-60.0f, 4.0f, 56.0f, 21.0f);

    CGFloat sbW = 46.0f, sfW = MAX(90.0f, pW-8.0f-sbW-4.0f);
    _searchBar.frame  = CGRectMake(4.0f,         28.0f, sfW,  22.0f);
    _btnSearch.frame  = CGRectMake(4.0f+sfW+4.0f,28.0f, sbW, 22.0f);
    _web.frame = CGRectMake(0.0f, 53.0f, pW, MAX(80.0f, pH-53.0f));

    CGFloat iy = mH - fH;
    _adminBtn.frame = CGRectMake(padX,  iy,      inW,     20.0f);
    _cprLbl.frame   = CGRectMake(6.0f,  iy+20.f, mW-12.f, 27.0f);
}

- (void)applyMenuFrameForExpanded:(BOOL)exp animated:(BOOL)anim {
    if (_menuFrameInitialized && _menuCurrentlyExpanded == exp) return;
    _menuCurrentlyExpanded = exp;
    _menuFrameInitialized  = YES;

    UIWindow *w = [self resolveActiveWindow];
    if (!w || !_menuBox) return;

    CGFloat sW = w.bounds.size.width, sH = w.bounds.size.height;
    CGFloat cW = MAX(268.0f, MIN(312.0f, sW - 86.0f));
    CGFloat eW = MAX(cW,     MIN(580.0f, sW - 74.0f));
    CGFloat cH = MIN(332.0f, MAX(250.0f, sH - 24.0f));
    CGFloat eH = MAX(cH,     MIN(700.0f, sH - 10.0f));
    CGFloat tW = exp ? eW : cW, tH = exp ? eH : cH;

    CGFloat curX = _menuBox.frame.origin.x;
    CGFloat maxX = MAX(8.0f, sW - tW - 8.0f);
    CGFloat tX   = exp
        ? MIN(maxX, MAX(70.0f, (sW - tW) * 0.56f))
        : MAX(8.0f, MIN(maxX, curX));
    CGFloat tY   = exp
        ? 5.0f
        : MAX(12.0f, MIN(sH - tH - 8.0f, _menuBox.frame.origin.y));

    CGRect tf = CGRectMake(tX, tY, tW, tH);
    void (^blk)(void) = ^{
        self->_menuBox.frame = tf;
        [self layoutMenuSubviewsWithWidth:tW height:tH expanded:exp];
        [self->_menuBox layoutIfNeeded];
    };

    if (anim) {
        [UIView animateWithDuration:0.22 delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:blk completion:nil];
    } else {
        blk();
    }
}

// ─────────────── Build UI ──────────────────────────────────────────────────

- (void)initializeFramework {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *kw = [self resolveActiveWindow];
        if (!kw) return;

        CGFloat sW = kw.bounds.size.width;
        CGFloat mW = MAX(268.0f, MIN(312.0f, sW - 86.0f));
        CGFloat mH = MIN(332.0f, MAX(250.0f, kw.bounds.size.height - 24.0f));

        if (!self->_floatBtn) {
            self->_floatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self->_floatBtn.frame = CGRectMake(16, 118, 48, 48);
            self->_floatBtn.layer.cornerRadius = 24;
            self->_floatBtn.clipsToBounds      = YES;
            self->_floatBtn.layer.borderWidth  = 2.2;
            self->_floatBtn.layer.borderColor  =
                [UIColor colorWithRed:0.88 green:0.35 blue:1.0 alpha:1.0].CGColor;
            self->_floatBtn.backgroundColor =
                [UIColor colorWithRed:0.08 green:0.03 blue:0.2 alpha:0.96];

            UIImage *logo = [self renderLogoImageWithSize:36.0f];
            if (logo) {
                [self->_floatBtn setImage:logo forState:UIControlStateNormal];
                self->_floatBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
                self->_floatBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            } else {
                [self->_floatBtn setTitle:@"♪" forState:UIControlStateNormal];
                self->_floatBtn.titleLabel.font = [UIFont systemFontOfSize:22];
            }

            [self->_floatBtn addTarget:self action:@selector(toggleMenu)
              forControlEvents:UIControlEventTouchUpInside];
            UIPanGestureRecognizer *pg =
                [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(handleFloatingPan:)];
            [self->_floatBtn addGestureRecognizer:pg];
            [kw addSubview:self->_floatBtn];
        } else if (self->_floatBtn.superview != kw) {
            [kw addSubview:self->_floatBtn];
        }

        if (!self->_menuBox) {
            self->_menuBox = [[UIView alloc] initWithFrame:CGRectMake(70, 16, mW, mH)];
            self->_menuBox.backgroundColor =
                [UIColor colorWithRed:0.06 green:0.02 blue:0.16 alpha:0.98];
            self->_menuBox.layer.cornerRadius = 16;
            self->_menuBox.layer.borderWidth  = 1.6;
            self->_menuBox.layer.borderColor  =
                [UIColor colorWithRed:0.85 green:0.42 blue:1.0 alpha:0.95].CGColor;
            self->_menuBox.clipsToBounds = YES;
            self->_menuBox.hidden = YES;
            self->_menuBox.alpha  = 0.0;

            self->_gradient = [CAGradientLayer layer];
            self->_gradient.colors = @[
                (id)[UIColor colorWithRed:0.13 green:0.03 blue:0.28 alpha:1.0].CGColor,
                (id)[UIColor colorWithRed:0.23 green:0.05 blue:0.36 alpha:1.0].CGColor,
                (id)[UIColor colorWithRed:0.05 green:0.11 blue:0.27 alpha:1.0].CGColor
            ];
            self->_gradient.startPoint = CGPointMake(0, 0);
            self->_gradient.endPoint   = CGPointMake(1, 1);
            [self->_menuBox.layer insertSublayer:self->_gradient atIndex:0];

            self->_dragHdr = [[UIView alloc] init];
            self->_dragHdr.backgroundColor =
                [UIColor colorWithRed:0.18 green:0.06 blue:0.35 alpha:0.85];
            [self->_menuBox addSubview:self->_dragHdr];
            UIPanGestureRecognizer *hp =
                [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(handleMenuHeaderPan:)];
            [self->_dragHdr addGestureRecognizer:hp];

            self->_headerTitleLbl = [self makeLbl:@"👑 PHẠM LONG • SUPREME MASTER AUDIO"
                size:11.5 weight:UIFontWeightHeavy
                color:[UIColor colorWithRed:1.0 green:0.82 blue:1.0 alpha:1.0]];
            [self->_dragHdr addSubview:self->_headerTitleLbl];

            self->_tickerLbl = [self makeLbl:@"⚡ NUCLEAR AD-BLOCK • CHẤT LƯỢNG MASTER HI-RES ⚡"
                size:8.5 weight:UIFontWeightBold
                color:[UIColor colorWithRed:1.0 green:0.85 blue:0.4 alpha:1.0]];
            [self->_dragHdr addSubview:self->_tickerLbl];

            self->_titleLbl = [self makeLbl:@"♪ Đang sẵn sàng nạp nhạc VIP..."
                size:9.5 weight:UIFontWeightSemibold
                color:[UIColor colorWithRed:0.38 green:1.0 blue:0.82 alpha:1.0]];
            [self->_dragHdr addSubview:self->_titleLbl];

            self->_closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [self->_closeBtn setTitle:@"✕" forState:UIControlStateNormal];
            [self->_closeBtn setTitleColor:
                [UIColor colorWithRed:1.0 green:0.55 blue:0.78 alpha:1.0]
                forState:UIControlStateNormal];
            self->_closeBtn.titleLabel.font =
                [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
            self->_closeBtn.backgroundColor =
                [UIColor colorWithRed:0.35 green:0.06 blue:0.25 alpha:0.9];
            self->_closeBtn.layer.cornerRadius = 12;
            [self->_closeBtn addTarget:self action:@selector(toggleMenu)
                forControlEvents:UIControlEventTouchUpInside];
            [self->_menuBox addSubview:self->_closeBtn];

            self->_btnPrev = [PHLTransportButton buttonWithKind:TransportButtonKindPrevious
                actionTarget:self action:@selector(playPreviousSong)];
            self->_btnPlay = [PHLTransportButton buttonWithKind:TransportButtonKindPlayPause
                actionTarget:self action:@selector(togglePlayPause)];
            self->_btnNext = [PHLTransportButton buttonWithKind:TransportButtonKindNext
                actionTarget:self action:@selector(playNextSong)];
            self->_btnRep  = [PHLTransportButton buttonWithKind:TransportButtonKindRepeat
                actionTarget:self action:@selector(toggleRepeatMode)];
            [self syncRepeatButton];
            for (UIView *b in @[self->_btnPrev, self->_btnPlay, self->_btnNext, self->_btnRep])
                [self->_menuBox addSubview:b];

            self->_btnMute = [UIButton buttonWithType:UIButtonTypeSystem];
            [self->_btnMute setTitle:@"🔉" forState:UIControlStateNormal];
            self->_btnMute.titleLabel.font = [UIFont systemFontOfSize:12];
            [self->_btnMute addTarget:self action:@selector(decreaseVolumeStep)
                forControlEvents:UIControlEventTouchUpInside];
            [self->_menuBox addSubview:self->_btnMute];

            self->_volSlider = [[UISlider alloc] init];
            self->_volSlider.minimumValue        = 0.0f;
            self->_volSlider.maximumValue        = self->_maxAllowedGain;
            self->_volSlider.value               = self->_gain;
            self->_volSlider.minimumTrackTintColor =
                [UIColor colorWithRed:0.35 green:0.98 blue:1.0 alpha:1.0];
            self->_volSlider.maximumTrackTintColor =
                [UIColor colorWithRed:0.95 green:0.35 blue:0.75 alpha:0.35];
            self->_volSlider.thumbTintColor =
                [UIColor colorWithRed:1.0 green:0.88 blue:0.35 alpha:1.0];
            [self->_volSlider addTarget:self action:@selector(volumeSliderChanged:)
                forControlEvents:UIControlEventValueChanged];
            [self->_menuBox addSubview:self->_volSlider];

            self->_btnVolUp = [UIButton buttonWithType:UIButtonTypeSystem];
            [self->_btnVolUp setTitle:@"🔊" forState:UIControlStateNormal];
            self->_btnVolUp.titleLabel.font = [UIFont systemFontOfSize:12];
            [self->_btnVolUp addTarget:self action:@selector(increaseVolumeStep)
                forControlEvents:UIControlEventTouchUpInside];
            [self->_menuBox addSubview:self->_btnVolUp];

            self->_gainLbl = [[UILabel alloc] init];
            self->_gainLbl.font = [UIFont monospacedDigitSystemFontOfSize:9
                                   weight:UIFontWeightBold];
            self->_gainLbl.textAlignment = NSTextAlignmentRight;
            [self->_menuBox addSubview:self->_gainLbl];

            self->_btnWebToggle = [self makeUtilBtn:@"🌐 MỞ YOUTUBE VIP (ZERO ADS)"
                size:9.0
                bg:[UIColor colorWithRed:0.12 green:0.24 blue:0.48 alpha:0.95]
                border:[UIColor colorWithRed:0.38 green:0.95 blue:1.0 alpha:0.9]
                action:@selector(toggleEmbeddedBrowser)];
            [self->_btnWebToggle setTitleColor:
                [UIColor colorWithRed:0.65 green:0.98 blue:1.0 alpha:1.0]
                forState:UIControlStateNormal];
            [self->_menuBox addSubview:self->_btnWebToggle];

            self->_table = [[UITableView alloc] initWithFrame:CGRectZero
                style:UITableViewStylePlain];
            self->_table.backgroundColor =
                [UIColor colorWithRed:0.06 green:0.02 blue:0.16 alpha:0.45];
            self->_table.layer.cornerRadius = 9;
            self->_table.separatorColor =
                [UIColor colorWithRed:0.75 green:0.35 blue:1.0 alpha:0.25];
            self->_table.rowHeight  = 38.0f;
            self->_table.delegate   = self;
            self->_table.dataSource = self;
            [self->_menuBox addSubview:self->_table];

            self->_webBox = [[UIView alloc] init];
            self->_webBox.backgroundColor =
                [UIColor colorWithRed:0.07 green:0.03 blue:0.18 alpha:0.98];
            self->_webBox.layer.cornerRadius = 9;
            self->_webBox.layer.borderWidth  = 1.1;
            self->_webBox.layer.borderColor  =
                [UIColor colorWithRed:0.45 green:0.92 blue:1.0 alpha:0.8].CGColor;
            self->_webBox.clipsToBounds = YES;
            self->_webBox.hidden = YES;
            [self->_menuBox addSubview:self->_webBox];

            self->_btnBack = [self makeUtilBtn:@"←" size:12
                bg:[UIColor colorWithRed:0.25 green:0.1 blue:0.45 alpha:0.95]
                border:[UIColor colorWithRed:0.75 green:0.4 blue:1.0 alpha:0.7]
                action:@selector(webGoBack)];
            self->_btnBack.layer.cornerRadius = 5;
            [self->_webBox addSubview:self->_btnBack];

            self->_btnFwd = [self makeUtilBtn:@"→" size:12
                bg:[UIColor colorWithRed:0.25 green:0.1 blue:0.45 alpha:0.95]
                border:[UIColor colorWithRed:0.75 green:0.4 blue:1.0 alpha:0.7]
                action:@selector(webGoForward)];
            self->_btnFwd.layer.cornerRadius = 5;
            [self->_webBox addSubview:self->_btnFwd];

            self->_btnHome = [self makeUtilBtn:@"🏠 YT" size:9
                bg:[UIColor colorWithRed:0.14 green:0.22 blue:0.42 alpha:0.95]
                border:[UIColor colorWithRed:0.45 green:0.9 blue:1.0 alpha:0.7]
                action:@selector(webGoHome)];
            [self->_btnHome setTitleColor:
                [UIColor colorWithRed:1.0 green:0.85 blue:0.4 alpha:1.0]
                forState:UIControlStateNormal];
            self->_btnHome.layer.cornerRadius = 5;
            [self->_webBox addSubview:self->_btnHome];

            self->_btnCloseW = [self makeUtilBtn:@"Thu gọn" size:9
                bg:[UIColor colorWithRed:0.45 green:0.08 blue:0.32 alpha:0.95]
                border:[UIColor colorWithRed:1.0 green:0.45 blue:0.75 alpha:0.7]
                action:@selector(closeEmbeddedBrowser)];
            [self->_btnCloseW setTitleColor:
                [UIColor colorWithRed:1.0 green:0.75 blue:0.95 alpha:1.0]
                forState:UIControlStateNormal];
            self->_btnCloseW.layer.cornerRadius = 5;
            [self->_webBox addSubview:self->_btnCloseW];

            self->_searchBar = [[UITextField alloc] init];
            self->_searchBar.placeholder = @"🔍 Nhập tên bài hát / ca sĩ...";
            self->_searchBar.textColor   = [UIColor whiteColor];
            self->_searchBar.font        = [UIFont systemFontOfSize:10.5
                                            weight:UIFontWeightMedium];
            self->_searchBar.backgroundColor =
                [UIColor colorWithRed:0.15 green:0.07 blue:0.28 alpha:0.96];
            self->_searchBar.layer.cornerRadius = 6;
            self->_searchBar.layer.borderWidth  = 1.0;
            self->_searchBar.layer.borderColor  =
                [UIColor colorWithRed:0.85 green:0.42 blue:1.0 alpha:0.75].CGColor;
            self->_searchBar.returnKeyType   = UIReturnKeySearch;
            self->_searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
            self->_searchBar.delegate        = self;
            UIView *pad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 22)];
            self->_searchBar.leftView     = pad;
            self->_searchBar.leftViewMode = UITextFieldViewModeAlways;
            [self->_webBox addSubview:self->_searchBar];

            self->_btnSearch = [self makeUtilBtn:@"Tìm" size:9.5
                bg:[UIColor colorWithRed:0.88 green:0.14 blue:0.36 alpha:0.98]
                border:[UIColor colorWithRed:1.0 green:0.55 blue:0.75 alpha:0.85]
                action:@selector(triggerYouTubeSearch)];
            self->_btnSearch.layer.cornerRadius = 6;
            [self->_webBox addSubview:self->_btnSearch];

            WKWebViewConfiguration *wcfg = [[WKWebViewConfiguration alloc] init];
            wcfg.allowsInlineMediaPlayback = YES;
            WKUserContentController *ucc   = wcfg.userContentController;
            PHLWeakScriptMessageProxy *mp  =
                [[PHLWeakScriptMessageProxy alloc] initWithDelegate:self];
            [ucc addScriptMessageHandler:mp name:@"phlWebMediaPlaying"];
            [ucc addUserScript:[[WKUserScript alloc]
                initWithSource:GetNuclearCleanAndAdBlockJS()
                injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                forMainFrameOnly:NO]];
            NSString *bSrc = [NSString stringWithFormat:
                @"%@;window.__phlAudioBridge.setGain(%.3f);",
                GetAudioBridgeJS(), self->_gain];
            [ucc addUserScript:[[WKUserScript alloc]
                initWithSource:bSrc
                injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                forMainFrameOnly:NO]];

            self->_web = [[WKWebView alloc] initWithFrame:CGRectZero
                configuration:wcfg];
            self->_web.navigationDelegate = self;
            self->_web.scrollView.bounces = YES;
            [self->_webBox addSubview:self->_web];

            self->_adminBtn = [self makeUtilBtn:@"💬 LIÊN HỆ TELEGRAM ADMIN"
                size:9.5
                bg:[UIColor colorWithRed:0.25 green:0.07 blue:0.44 alpha:0.96]
                border:[UIColor colorWithRed:0.92 green:0.45 blue:1.0 alpha:0.9]
                action:@selector(openAdminInfoGroup)];
            [self->_adminBtn setTitleColor:
                [UIColor colorWithRed:0.45 green:0.98 blue:1.0 alpha:1.0]
                forState:UIControlStateNormal];
            self->_adminBtn.layer.cornerRadius = 7;
            [self->_menuBox addSubview:self->_adminBtn];

            self->_cprLbl = [[UILabel alloc] init];
            self->_cprLbl.text = @"BẢN QUYỀN THUỘC ADMIN TELEGRAM: @PHL0990\nZALO: 0522608620";
            self->_cprLbl.textColor =
                [UIColor colorWithRed:1.0 green:0.86 blue:0.55 alpha:0.98];
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

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self fetchRemotePlaylist];
            [self fetchRemoteAdminConfig];
        });

        if (!self->_autoSyncTimer) {
            PHLWeakTimerTarget *tp =
                [PHLWeakTimerTarget proxyWithTarget:self
                                           selector:@selector(fetchRemoteAdminConfig)];
            self->_autoSyncTimer =
                [NSTimer scheduledTimerWithTimeInterval:300.0
                                                 target:tp
                                               selector:@selector(fire:)
                                               userInfo:nil
                                                repeats:YES];
        }
    });
}

// ─────────────── Label Factory ─────────────────────────────────────────────

- (UILabel *)makeLbl:(NSString *)text size:(CGFloat)sz
              weight:(UIFontWeight)w color:(UIColor *)c {
    UILabel *l  = [[UILabel alloc] init];
    l.text       = text;
    l.font       = [UIFont systemFontOfSize:sz weight:w];
    l.textColor  = c;
    return l;
}

// ─────────────── Remote Data ───────────────────────────────────────────────

- (void)fetchRemoteAdminConfig {
    if (_lastConfigFetchDate &&
        [[NSDate date] timeIntervalSinceDate:_lastConfigFetchDate] < 60.0) return;
    _lastConfigFetchDate = [NSDate date];

    NSURL *apiUrl = [NSURL URLWithString:
        @"https://api.github.com/repos/phamlong3539-stack/phl-music-data/contents/config.json"];
    NSMutableURLRequest *req =
        [NSMutableURLRequest requestWithURL:apiUrl
                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                            timeoutInterval:8.0];
    [req setValue:@"PHL-Engine/2.2" forHTTPHeaderField:@"User-Agent"];
    [req setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];

    [[[NSURLSession sharedSession] dataTaskWithRequest:req
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *hr = (NSHTTPURLResponse *)response;
            if (!error && data && hr.statusCode == 200) {
                NSDictionary *api = [NSJSONSerialization JSONObjectWithData:data
                    options:0 error:nil];
                NSString *b64 = api[@"content"];
                if (b64.length > 0) {
                    b64 = [b64 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    b64 = [b64 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    NSData *dec = [[NSData alloc] initWithBase64EncodedString:b64 options:0];
                    if (dec) {
                        NSDictionary *cfg = [NSJSONSerialization JSONObjectWithData:dec
                            options:0 error:nil];
                        if ([cfg isKindOfClass:[NSDictionary class]]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self applyRemoteAdminConfig:cfg];
                            });
                            return;
                        }
                    }
                }
            }
            [self fallbackFetchRawConfig];
        }] resume];
}

- (void)fallbackFetchRawConfig {
    NSString *uStr = [NSString stringWithFormat:
        @"https://raw.githubusercontent.com/phamlong3539-stack/phl-music-data/main/config.json?v=%.0f",
        [[NSDate date] timeIntervalSince1970]];
    NSMutableURLRequest *req =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uStr]
                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                            timeoutInterval:8.0];
    [req setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:req
        completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
            if (!e && d) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:d
                    options:0 error:nil];
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self applyRemoteAdminConfig:dict];
                    });
                }
            }
        }] resume];
}

- (void)applyRemoteAdminConfig:(NSDictionary *)dict {
    // 1. Kill switch
    if ([dict[@"system_control"][@"kill_switch"] boolValue]) {
        [self pauseStreamPlayerIfPlaying];
        [self pauseWebMediaIfPlaying];
        _floatBtn.hidden = YES;
        _menuBox.hidden  = YES;
        return;
    } else if (_floatBtn) {
        _floatBtn.hidden = NO;
    }

    // 2. Floating icon & pulse
    NSString *fIcon = dict[@"system_control"][@"floating_icon"];
    if (fIcon.length > 0 && _floatBtn) {
        if (!_floatBtn.currentImage) {
            [_floatBtn setTitle:fIcon forState:UIControlStateNormal];
        }
    }
    BOOL enablePulse = [dict[@"system_control"][@"floating_pulse_glow"] boolValue];
    if (enablePulse) {
        if (![_floatBtn.layer animationForKey:@"phl_pulse"]) {
            CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            a.duration = 1.1; a.repeatCount = HUGE_VALF; a.autoreverses = YES;
            a.fromValue = @(1.0); a.toValue = @(1.14);
            a.timingFunction =
                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [_floatBtn.layer addAnimation:a forKey:@"phl_pulse"];
        }
    } else {
        [_floatBtn.layer removeAnimationForKey:@"phl_pulse"];
    }

    // 3. Theme
    NSDictionary *th = dict[@"theme_customizer"];
    if (th) {
        UIColor *neon = ColorFromHex(th[@"neon_border_color"],
            [UIColor colorWithRed:0.85 green:0.42 blue:1.0 alpha:0.95]);
        _menuBox.layer.borderColor  = neon.CGColor;
        _floatBtn.layer.borderColor = neon.CGColor;
        UIColor *cS = ColorFromHex(th[@"gradient_start_color"],
            [UIColor colorWithRed:0.13 green:0.03 blue:0.28 alpha:1.0]);
        UIColor *cM = ColorFromHex(th[@"gradient_mid_color"],
            [UIColor colorWithRed:0.23 green:0.05 blue:0.36 alpha:1.0]);
        UIColor *cE = ColorFromHex(th[@"gradient_end_color"],
            [UIColor colorWithRed:0.05 green:0.11 blue:0.27 alpha:1.0]);
        _gradient.colors = @[(id)cS.CGColor, (id)cM.CGColor, (id)cE.CGColor];
    }

    // 4. Branding
    NSDictionary *brand = dict[@"branding"];
    if (brand) {
        if (brand[@"header_title"])     _headerTitleLbl.text = brand[@"header_title"];
        if (brand[@"ticker_announcement"]) _tickerLbl.text   = brand[@"ticker_announcement"];
        if (brand[@"admin_button_text"])
            [_adminBtn setTitle:brand[@"admin_button_text"] forState:UIControlStateNormal];
        if (brand[@"admin_button_url"]) _adminTargetURL = brand[@"admin_button_url"];
        if (brand[@"footer_copyright"]) _cprLbl.text    = brand[@"footer_copyright"];
    }

    // 5. Audio max gain
    NSDictionary *audioCfg = dict[@"audio_engine"];
    if (audioCfg[@"max_gain"]) {
        _maxAllowedGain = MAX(1.0f, [audioCfg[@"max_gain"] floatValue]);
        _volSlider.maximumValue = _maxAllowedGain;
    }

    // 6. Featured song
    NSDictionary *feat = dict[@"vip_featured_song"];
    if (feat && [feat[@"enabled"] boolValue]) {
        _featuredVipSong = feat;
        [self injectFeaturedSongIntoPlaylist];
    }

    // 7. YouTube
    NSDictionary *ytCfg = dict[@"youtube_module"];
    if (ytCfg) {
        if (ytCfg[@"enabled"] != nil)   _isYouTubeEnabled = [ytCfg[@"enabled"] boolValue];
        if (ytCfg[@"home_url"].length)   _youtubeHomeURL   = ytCfg[@"home_url"];
        if (ytCfg[@"locked_reason"].length) _youtubeLockedMsg = ytCfg[@"locked_reason"];
        [self syncBrowserButtonTitle];
        if (!_isYouTubeEnabled && _webOpen) [self closeEmbeddedBrowser];
    }

    // 8. BẮN POPUP NGAY LẬP TỨC KHI VÀO APP
    NSDictionary *ann = dict[@"announcement"];
    if (ann && [ann[@"show"] boolValue]) {
        _cachedAnnouncement = ann;

        if (!_hasShownPopupOnLaunch && !_isShowingAnnouncement) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self triggerAnnouncementPopupExplicitly];
            });
        }
    }
}

// ─────────────── Playlist ──────────────────────────────────────────────────

- (void)fetchRemotePlaylist {
    NSURL *apiUrl = [NSURL URLWithString:
        @"https://api.github.com/repos/phamlong3539-stack/phl-music-data/contents/playlist.json"];
    NSMutableURLRequest *req =
        [NSMutableURLRequest requestWithURL:apiUrl
                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                            timeoutInterval:8.0];
    [req setValue:@"PHL-Engine/2.2" forHTTPHeaderField:@"User-Agent"];
    [req setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];

    [[[NSURLSession sharedSession] dataTaskWithRequest:req
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *hr = (NSHTTPURLResponse *)response;
            if (!error && data && hr.statusCode == 200) {
                NSDictionary *api = [NSJSONSerialization JSONObjectWithData:data
                    options:0 error:nil];
                NSString *b64 = api[@"content"];
                if (b64.length > 0) {
                    b64 = [b64 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    b64 = [b64 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    NSData *dec = [[NSData alloc] initWithBase64EncodedString:b64 options:0];
                    if (dec) {
                        NSDictionary *root = [NSJSONSerialization JSONObjectWithData:dec
                            options:0 error:nil];
                        NSArray *songs = [root isKindOfClass:[NSDictionary class]]
                            ? root[@"songs"] : nil;
                        if ([songs isKindOfClass:[NSArray class]] && songs.count > 0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self->_playlist removeAllObjects];
                                [self->_playlist addObjectsFromArray:songs];
                                [self injectFeaturedSongIntoPlaylist];
                                [self->_table reloadData];
                                if (self->_idx < 0 && self->_playlist.count > 0)
                                    [self playSongAtIndex:0];
                            });
                            return;
                        }
                    }
                }
            }
            [self fallbackFetchRawPlaylist];
        }] resume];
}

- (void)fallbackFetchRawPlaylist {
    NSString *uStr = [NSString stringWithFormat:
        @"https://raw.githubusercontent.com/phamlong3539-stack/phl-music-data/main/playlist.json?v=%.0f",
        [[NSDate date] timeIntervalSince1970]];
    NSMutableURLRequest *req =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uStr]
                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                            timeoutInterval:8.0];
    [req setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:req
        completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
            if (!e && d) {
                NSDictionary *root = [NSJSONSerialization JSONObjectWithData:d
                    options:0 error:nil];
                NSArray *songs = [root isKindOfClass:[NSDictionary class]]
                    ? root[@"songs"] : nil;
                if ([songs isKindOfClass:[NSArray class]] && songs.count > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self->_playlist removeAllObjects];
                        [self->_playlist addObjectsFromArray:songs];
                        [self injectFeaturedSongIntoPlaylist];
                        [self->_table reloadData];
                        if (self->_idx < 0 && self->_playlist.count > 0)
                            [self playSongAtIndex:0];
                    });
                }
            }
        }] resume];
}

- (void)injectFeaturedSongIntoPlaylist {
    if (!_featuredVipSong) return;
    NSString *vUrl = _featuredVipSong[@"url"];
    if (!vUrl.length) return;
    if (_playlist.count > 0 &&
        [_playlist.firstObject[@"url"] isEqualToString:vUrl]) return;
    NSString *vTitle = _featuredVipSong[@"title"] ?: @"Featured VIP";
    [_playlist insertObject:@{@"title": vTitle, @"url": vUrl} atIndex:0];
    [_table reloadData];
}

// ─────────────── Playback ──────────────────────────────────────────────────

- (void)playSongAtIndex:(NSInteger)idx {
    if (idx < 0 || idx >= (NSInteger)_playlist.count) return;
    _idx = idx;
    NSDictionary *song = _playlist[idx];
    NSString *urlStr   = song[@"url"];
    NSString *name     = song[@"title"] ?: song[@"name"] ?: @"Không tên";
    if (!urlStr.length) return;

    NSURL *url = [NSURL URLWithString:urlStr];
    if (!url) {
        NSString *enc = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:
            [NSCharacterSet URLQueryAllowedCharacterSet]];
        url = [NSURL URLWithString:enc];
    }
    if (!url) return;

    if (_playerItem) {
        [[NSNotificationCenter defaultCenter]
            removeObserver:self
                      name:AVPlayerItemDidPlayToEndTimeNotification
                    object:_playerItem];
    }

    _playerItem = [AVPlayerItem playerItemWithURL:url];
    [self applyGainToItem:_playerItem gain:_gain];

    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:_playerItem];
    } else {
        [_player replaceCurrentItemWithPlayerItem:_playerItem];
    }
    _player.muted  = (_gain <= 0.001f);
    _player.volume = MIN(1.0f, _gain);
    [_player play];

    if (_titleLbl) _titleLbl.text = [NSString stringWithFormat:@"♪ %@", name];
    [self syncPlayPauseButton];
    [_table reloadData];
}

- (void)togglePlayPause {
    if (!_player || !_playerItem) {
        if (_playlist.count > 0) [self playSongAtIndex:MAX(0, _idx)];
        return;
    }
    if (_player.rate > 0.01f) { [_player pause]; }
    else {
        [self pauseWebMediaIfPlaying];
        [self configureAudioSession];
        _player.muted  = (_gain <= 0.001f);
        _player.volume = MIN(1.0f, _gain);
        [_player play];
    }
    [self syncPlayPauseButton];
}

- (void)playNextSong {
    if (!_playlist.count) return;
    [self playSongAtIndex:(_idx + 1) % (NSInteger)_playlist.count];
    [_btnNext triggerPulseMark];
}

- (void)playPreviousSong {
    if (!_playlist.count) return;
    NSInteger p = (_idx <= 0)
        ? (NSInteger)_playlist.count - 1 : _idx - 1;
    [self playSongAtIndex:p];
    [_btnPrev triggerPulseMark];
}

- (void)toggleRepeatMode {
    _repOne = !_repOne;
    [[NSUserDefaults standardUserDefaults] setBool:_repOne forKey:@"PHL_RepeatOneSong"];
    [self syncRepeatButton];
    [_btnRep triggerPulseMark];
}

- (void)syncRepeatButton {
    if (!_btnRep) return;
    _btnRep.activeState = _repOne;
    [_btnRep refreshTransportVisual];
}

- (void)syncPlayPauseButton {
    if (!_btnPlay) return;
    _btnPlay.activeState = (_player && _player.rate > 0.01f);
    [_btnPlay refreshTransportVisual];
}

- (void)volumeSliderChanged:(UISlider *)s { [self applyIndependentGain:s.value]; }

- (void)increaseVolumeStep {
    float nv = MIN(_maxAllowedGain, _gain + 0.15f);
    if (_volSlider) _volSlider.value = nv;
    [self applyIndependentGain:nv];
}

- (void)decreaseVolumeStep {
    float nv = MAX(0.0f, _gain - 0.15f);
    if (_volSlider) _volSlider.value = nv;
    [self applyIndependentGain:nv];
}

// ─────────────── Menu Toggle ───────────────────────────────────────────────

- (void)toggleMenu {
    _menuOpen = !_menuOpen;
    if (_menuOpen) {
        _menuBox.hidden = NO;
        _menuBox.alpha  = 0.0;
        _menuFrameInitialized = NO;
        [self applyMenuFrameForExpanded:_webOpen animated:NO];
        [self applyIndependentGain:_gain];
        [self syncPlayPauseButton];
        [UIView animateWithDuration:0.18 animations:^{
            self->_menuBox.alpha = 1.0;
        }];

        // BẮN POPUP NGAY LẬP TỨC KHI CHẠM MỞ MENU
        [self triggerAnnouncementPopupExplicitly];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self fetchRemoteAdminConfig];
        });
    } else {
        [_searchBar resignFirstResponder];
        [UIView animateWithDuration:0.16 animations:^{
            self->_menuBox.alpha = 0.0;
        } completion:^(BOOL f) {
            self->_menuBox.hidden = YES;
        }];
    }
}

// ─────────────── Browser ───────────────────────────────────────────────────

- (void)toggleEmbeddedBrowser {
    if (!_isYouTubeEnabled) {
        UIViewController *top = [self resolveTopViewController];
        if (!top || top.presentedViewController) return;
        UIAlertController *a =
            [UIAlertController alertControllerWithTitle:@"🛡 THÔNG BÁO"
                                                message:_youtubeLockedMsg
                                         preferredStyle:UIAlertControllerStyleAlert];
        [a addAction:[UIAlertAction actionWithTitle:@"Đã hiểu"
            style:UIAlertActionStyleCancel handler:nil]];
        [top presentViewController:a animated:YES completion:nil];
        return;
    }
    _webOpen = !_webOpen;
    [self syncBrowserVisibilityAnimated:YES];
    if (_webOpen && !_webLoaded) {
        _webLoaded = YES;
        [self loadYouTubeURL:_youtubeHomeURL];
    } else if (_webOpen) {
        [self cleanYouTubePageInWebView];
    }
}

- (void)closeEmbeddedBrowser {
    [_searchBar resignFirstResponder];
    _webOpen = NO;
    [self syncBrowserVisibilityAnimated:YES];
}

- (void)syncBrowserVisibilityAnimated:(BOOL)anim {
    _webBox.hidden = !_webOpen;
    _table.hidden  = _webOpen;
    [self syncBrowserButtonTitle];
    _menuFrameInitialized = NO;
    [self applyMenuFrameForExpanded:_webOpen animated:anim];
}

- (void)syncBrowserButtonTitle {
    if (!_btnWebToggle) return;
    if (!_isYouTubeEnabled) {
        [_btnWebToggle setTitle:@"🚫 YOUTUBE (TẠM KHÓA)"
            forState:UIControlStateNormal];
        [_btnWebToggle setTitleColor:
            [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0]
            forState:UIControlStateNormal];
        _btnWebToggle.layer.borderColor = [UIColor redColor].CGColor;
    } else {
        NSString *t = _webOpen
            ? @"☰ ĐANG MỞ YOUTUBE • THU GỌN"
            : @"🌐 MỞ YOUTUBE VIP (ZERO ADS)";
        [_btnWebToggle setTitle:t forState:UIControlStateNormal];
        [_btnWebToggle setTitleColor:
            [UIColor colorWithRed:0.65 green:0.98 blue:1.0 alpha:1.0]
            forState:UIControlStateNormal];
        _btnWebToggle.layer.borderColor =
            [UIColor colorWithRed:0.38 green:0.95 blue:1.0 alpha:0.9].CGColor;
    }
}

- (void)loadYouTubeURL:(NSString *)urlStr {
    if (!_web || !urlStr.length) return;
    NSURL *u = [NSURL URLWithString:urlStr];
    if (!u) return;
    [_web loadRequest:[NSURLRequest requestWithURL:u
        cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0]];
}

- (void)webGoBack    { if (_web.canGoBack)    [_web goBack]; }
- (void)webGoForward { if (_web.canGoForward) [_web goForward]; }
- (void)webGoHome    { [self loadYouTubeURL:_youtubeHomeURL]; }

- (void)triggerYouTubeSearch {
    [_searchBar resignFirstResponder];
    NSString *raw = [_searchBar.text
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!_webOpen) {
        _webOpen  = YES;
        _webLoaded = YES;
        [self syncBrowserVisibilityAnimated:YES];
    }
    if (!raw.length) {
        [self loadYouTubeURL:_youtubeHomeURL];
        return;
    }
    NSString *enc = [raw stringByAddingPercentEncodingWithAllowedCharacters:
        [NSCharacterSet URLQueryAllowedCharacterSet]];
    [self loadYouTubeURL:
        [NSString stringWithFormat:@"https://m.youtube.com/results?search_query=%@", enc ?: @""]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf {
    if (tf == _searchBar) { [self triggerYouTubeSearch]; return NO; }
    return YES;
}

- (void)openAdminInfoGroup {
    if (!_adminTargetURL.length) return;
    NSURL *u = [NSURL URLWithString:_adminTargetURL];
    if (u) [[UIApplication sharedApplication] openURL:u options:@{} completionHandler:nil];
}

// ─────────────── Pan Gestures ──────────────────────────────────────────────

- (void)clampView:(UIView *)v topMargin:(CGFloat)tm bottomMargin:(CGFloat)bm {
    if (!v || !v.superview) return;
    CGSize sz = v.superview.bounds.size;
    CGFloat hw = v.bounds.size.width  / 2.0f;
    CGFloat hh = v.bounds.size.height / 2.0f;
    CGPoint c  = v.center;
    c.x = MAX(hw + 6.0f,  MIN(sz.width  - hw - 6.0f,  c.x));
    c.y = MAX(hh + tm,    MIN(sz.height - hh - bm,     c.y));
    v.center = c;
}

- (void)handleFloatingPan:(UIPanGestureRecognizer *)g {
    UIView *v = g.view;
    if (!v || !v.superview) return;
    CGPoint tr = [g translationInView:v.superview];
    v.center = CGPointMake(v.center.x + tr.x, v.center.y + tr.y);
    [self clampView:v topMargin:14.0f bottomMargin:14.0f];
    [g setTranslation:CGPointZero inView:v.superview];
}

- (void)handleMenuHeaderPan:(UIPanGestureRecognizer *)g {
    if (!_menuBox || !_menuBox.superview) return;
    CGPoint tr = [g translationInView:_menuBox.superview];
    _menuBox.center = CGPointMake(_menuBox.center.x + tr.x, _menuBox.center.y + tr.y);
    [self clampView:_menuBox topMargin:6.0f bottomMargin:6.0f];
    [g setTranslation:CGPointZero inView:_menuBox.superview];
}

// ─────────────── UITableView ───────────────────────────────────────────────

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s {
    return MAX(1, (NSInteger)_playlist.count);
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    static NSString *cid = @"PHLSongCell";
    UITableViewCell *c   = [tv dequeueReusableCellWithIdentifier:cid];
    if (!c) {
        c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:cid];
        c.backgroundColor = [UIColor clearColor];
        c.selectionStyle  = UITableViewCellSelectionStyleNone;
        c.textLabel.font  = [UIFont systemFontOfSize:11.5 weight:UIFontWeightSemibold];
        c.detailTextLabel.font = [UIFont systemFontOfSize:9.5];
    }

    if (_playlist.count == 0) {
        c.textLabel.textColor    = [UIColor colorWithRed:1.0 green:0.65 blue:0.75 alpha:1.0];
        c.textLabel.text         = _statusMsg ?: @"Không có bài hát";
        c.detailTextLabel.textColor = [UIColor lightGrayColor];
        c.detailTextLabel.text   = @"Chạm để thử tải lại";
        c.contentView.backgroundColor = [UIColor clearColor];
        return c;
    }

    NSDictionary *song = _playlist[ip.row];
    NSString *name     = song[@"title"] ?: song[@"name"] ?: @"Không tên";
    BOOL isCur = (ip.row == _idx);

    c.textLabel.textColor =
        isCur ? [UIColor colorWithRed:1.0 green:0.65 blue:1.0 alpha:1.0]
              : [UIColor colorWithRed:0.98 green:0.90 blue:1.0 alpha:1.0];
    c.textLabel.text = isCur ? [NSString stringWithFormat:@"▶ %@", name] : name;
    c.detailTextLabel.textColor =
        isCur ? [UIColor colorWithRed:0.35 green:1.0 blue:0.75 alpha:1.0]
              : [UIColor colorWithRed:0.68 green:0.98 blue:1.0 alpha:0.90];
    c.detailTextLabel.text =
        isCur ? @"🔊 Đang phát" : (song[@"artist"] ?: @"▶ Chạm để phát");
    c.contentView.backgroundColor = isCur
        ? [UIColor colorWithRed:0.28 green:0.08 blue:0.52 alpha:0.75]
        : [UIColor clearColor];

    static const NSInteger kVIPTag = 9901;
    UILabel *vipLbl = (UILabel *)[c.contentView viewWithTag:kVIPTag];
    BOOL isVIP = isCur && _featuredVipSong &&
        [_featuredVipSong[@"url"] isEqualToString:song[@"url"]];
    if (isVIP) {
        if (!vipLbl) {
            vipLbl = [[UILabel alloc] initWithFrame:CGRectMake(c.bounds.size.width-42, 2, 38, 16)];
            vipLbl.tag  = kVIPTag;
            vipLbl.text = @"👑VIP";
            vipLbl.font = [UIFont systemFontOfSize:8 weight:UIFontWeightHeavy];
            vipLbl.textColor   = [UIColor colorWithRed:1.0 green:0.82 blue:0.1 alpha:1.0];
            vipLbl.textAlignment = NSTextAlignmentRight;
            [c.contentView addSubview:vipLbl];
        }
        vipLbl.hidden = NO;
    } else {
        if (vipLbl) vipLbl.hidden = YES;
    }

    return c;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    [tv deselectRowAtIndexPath:ip animated:YES];
    if (_playlist.count == 0) {
        [self fetchRemotePlaylist]; return;
    }
    [self pauseWebMediaIfPlaying];
    [self playSongAtIndex:ip.row];
}

// ─────────────── WKNavigationDelegate ─────────────────────────────────────

- (void)webView:(WKWebView *)wv didCommitNavigation:(WKNavigation *)nav {
    [self cleanYouTubePageInWebView];
}

- (void)webView:(WKWebView *)wv didFinishNavigation:(WKNavigation *)nav {
    [self cleanYouTubePageInWebView];
    [self applyIndependentGain:_gain];
}

- (void)webView:(WKWebView *)webView
    decidePolicyForNavigationAction:(WKNavigationAction *)nav
                    decisionHandler:(void (^)(WKNavigationActionPolicy))dh {
    dh(WKNavigationActionPolicyAllow);
}

- (void)userContentController:(WKUserContentController *)ucc
       didReceiveScriptMessage:(WKScriptMessage *)msg {
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

@end

// ─────────────── Theos Hook ────────────────────────────────────────────────

%hook SpringBoard
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        [[PHLProtectedAudioManager sharedInstance] initializeFramework];
    });
}
%end
