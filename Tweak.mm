// ==============================================================================
// ==============================================================================
// 👑 PHL ENTERPRISE SECURE AUDIO RUNTIME (ARM64 ZERO-LATENCY MASTER ENGINE)
// CÔNG NGHỆ: DIRECT GITHUB CORE API • REAL-TIME ZERO DELAY • NUCLEAR AD-BLOCK
// ==============================================================================

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
#import <QuartzCore/QuartzCore.h>
#include <dlfcn.h>
#include <sys/sysctl.h>
#include <mach-o/dyld.h>
#include <unistd.h>

#define PHL_HIDDEN __attribute__((visibility("hidden")))

#pragma mark - 🛡️ TẦNG 1: MÃ HÓA CHUỖI TỰ ĐỘNG (XOR ROLLING CIPHER)

static inline NSString *PHL_DecryptString(const uint8_t *enc, size_t len) {
    if (!enc || len == 0) return @"";
    NSMutableData *d = [NSMutableData dataWithLength:len];
    uint8_t *bytes = (uint8_t *)d.mutableBytes;
    uint8_t baseKey = 0x5A;
    for (size_t i = 0; i < len; i++) {
        bytes[i] = (uint8_t)(enc[i] ^ ((baseKey + (uint8_t)i) & 0xFF));
    }
    return [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding] ?: @"";
}

// https://raw.githubusercontent.com/phamlong3539-stack/phl-music-data/main/logo.png
static const uint8_t kEnc_GITHUB_RAW_LOGO[] = { 0x32, 0x2F, 0x28, 0x2D, 0x2D, 0x65, 0x4F, 0x4E, 0x10, 0x02, 0x13, 0x4B, 0x01, 0x0E, 0x1C, 0x01, 0x1F, 0x09, 0x19, 0x1E, 0x0B, 0x1D, 0x13, 0x1E, 0x1C, 0x07, 0x11, 0x1B, 0x02, 0x59, 0x1B, 0x16, 0x17, 0x54, 0x0C, 0x15, 0x1F, 0x12, 0xEC, 0xEE, 0xEC, 0xE4, 0xB7, 0xB0, 0xB5, 0xBE, 0xA5, 0xFA, 0xFE, 0xEA, 0xEF, 0xE6, 0xA1, 0xFF, 0xF8, 0xFD, 0xBF, 0xFE, 0xE1, 0xE6, 0xFF, 0xF4, 0xB5, 0xFD, 0xFB, 0xEF, 0xFD, 0xB2, 0xF3, 0xFE, 0xC9, 0xCF, 0x8D, 0xCF, 0xCB, 0xC2, 0xC9, 0x89, 0xD8, 0xC7, 0xCD };
static const size_t kLen_GITHUB_RAW_LOGO = 81;

// https://raw.githubusercontent.com/phamlong3539-stack/phl-music-data/main/playlist.json
static const uint8_t kEnc_GITHUB_RAW_PLAYLIST[] = { 0x32, 0x2F, 0x28, 0x2D, 0x2D, 0x65, 0x4F, 0x4E, 0x10, 0x02, 0x13, 0x4B, 0x01, 0x0E, 0x1C, 0x01, 0x1F, 0x09, 0x19, 0x1E, 0x0B, 0x1D, 0x13, 0x1E, 0x1C, 0x07, 0x11, 0x1B, 0x02, 0x59, 0x1B, 0x16, 0x17, 0x54, 0x0C, 0x15, 0x1F, 0x12, 0xEC, 0xEE, 0xEC, 0xE4, 0xB7, 0xB0, 0xB5, 0xBE, 0xA5, 0xFA, 0xFE, 0xEA, 0xEF, 0xE6, 0xA1, 0xFF, 0xF8, 0xFD, 0xBF, 0xFE, 0xE1, 0xE6, 0xFF, 0xF4, 0xB5, 0xFD, 0xFB, 0xEF, 0xFD, 0xB2, 0xF3, 0xFE, 0xC9, 0xCF, 0x8D, 0xD3, 0xC8, 0xC4, 0xDF, 0xCB, 0xC1, 0xDA, 0xDE, 0x85, 0xC6, 0xDE, 0xC1, 0xC1 };
static const size_t kLen_GITHUB_RAW_PLAYLIST = 86;

// https://api.github.com/repos/phamlong3539-stack/phl-music-data/contents/config.json
static const uint8_t kEnc_GITHUB_API_CFG[] = { 0x32, 0x2F, 0x28, 0x2D, 0x2D, 0x65, 0x4F, 0x4E, 0x03, 0x13, 0x0D, 0x4B, 0x01, 0x0E, 0x1C, 0x01, 0x1F, 0x09, 0x42, 0x0E, 0x01, 0x02, 0x5F, 0x03, 0x17, 0x03, 0x1B, 0x06, 0x59, 0x07, 0x10, 0x18, 0x17, 0x17, 0x13, 0x13, 0x19, 0x4C, 0xB5, 0xB2, 0xBB, 0xAE, 0xF7, 0xF1, 0xE7, 0xE4, 0xE3, 0xA6, 0xFA, 0xE3, 0xE0, 0xA0, 0xE3, 0xFA, 0xE3, 0xF8, 0xF1, 0xBE, 0xF0, 0xF4, 0xE2, 0xF6, 0xB7, 0xFA, 0xF5, 0xF5, 0xE8, 0xF8, 0xF0, 0xEB, 0xD3, 0x8E, 0xC1, 0xCC, 0xCA, 0xC3, 0xCF, 0xC0, 0x86, 0xC3, 0xD9, 0xC4, 0xC2 };
static const size_t kLen_GITHUB_API_CFG = 83;

// https://t.me/PHL0990
static const uint8_t __attribute__((unused)) kEnc_DEFAULT_ADMIN_URL[] = { 0x32, 0x2F, 0x28, 0x2D, 0x2D, 0x65, 0x4F, 0x4E, 0x16, 0x4D, 0x09, 0x00, 0x49, 0x37, 0x20, 0x25, 0x5A, 0x52, 0x55, 0x5D };
static const size_t __attribute__((unused)) kLen_DEFAULT_ADMIN_URL = 20;

#pragma mark - 🛡️ TẦNG 2: BẢO MẬT CHỐNG DEBUG & HOOK (ANTI-LLDB, ANTI-FRIDA, ANTI-ATTACH)

PHL_HIDDEN static inline void PHL_EnforceSecuritySanity(void) {
    typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
    ptrace_ptr_t ptrace_func = (ptrace_ptr_t)dlsym(RTLD_DEFAULT, "ptrace");
    if (ptrace_func) {
        ptrace_func(31, 0, 0, 0);
    }
    int name[4];
    struct kinfo_proc info;
    size_t info_size = sizeof(info);
    info.kp_proc.p_flag = 0;
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid();
    if (sysctl(name, 4, &info, &info_size, NULL, 0) == 0) {
        if ((info.kp_proc.p_flag & P_TRACED) != 0) {
            exit(0);
        }
    }
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; i++) {
        const char *img = _dyld_get_image_name(i);
        if (img && (strstr(img, "FridaGadget") || strstr(img, "frida-agent") || strstr(img, "cynject"))) {
            exit(0);
        }
    }
}

static dispatch_source_t s_phlSentinel = NULL;
PHL_HIDDEN static void PHL_StartSecurityWatchdog(void) {
    if (s_phlSentinel) return;
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    s_phlSentinel = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, q);
    if (s_phlSentinel) {
        dispatch_source_set_timer(s_phlSentinel,
                                  dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)),
                                  (uint64_t)(15 * NSEC_PER_SEC),
                                  (uint64_t)(2 * NSEC_PER_SEC));
        dispatch_source_set_event_handler(s_phlSentinel, ^{
            PHL_EnforceSecuritySanity();
        });
        dispatch_resume(s_phlSentinel);
    }
}

typedef NS_ENUM(NSInteger, TransportButtonKind) {
    TransportButtonKindPrevious = 0,
    TransportButtonKindPlayPause = 1,
    TransportButtonKindNext = 2,
    TransportButtonKindRepeat = 3
};

#pragma mark - Bộ Chuyển Đổi Màu HEX

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

    if (self.iconKind == TransportButtonKindRepeat) {
        self.markerDotLayer.hidden = !self.activeState;
        if (self.activeState) {
            self.markerDotLayer.frame = CGRectMake(cx - 1.5f, h - 4.5f, 3.0f, 3.0f);
            self.markerDotLayer.backgroundColor = [UIColor colorWithRed:0.42 green:0.98 blue:1.0 alpha:1.0].CGColor;
            self.markerDotLayer.cornerRadius = 1.5f;
        }
    }
}

@end

#pragma mark - PHLProtectedAudioManager Interface

@interface PHLProtectedAudioManager : NSObject <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, WKNavigationDelegate, WKScriptMessageHandler> {
    UIButton *_floatBtn;
    UIView *_menuBox;
    CAGradientLayer *_gradient;
    UIView *_dragHdr;

    UILabel *_headerTitleLbl;
    UILabel *_tickerLbl;
    UILabel *_titleLbl;
    UIButton *_closeBtn;
    UITableView *_table;

    AVPlayer *_player;
    AVPlayerItem *_playerItem;

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
    NSTimer *_autoSyncTimer;
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
            "  var musicFilterTriggered = false;\n"
            "  function executePurge(){\n"
            // TỰ ĐỘNG CHUYỂN SANG MỤC ÂM NHẠC TRÊN TRANG CHỦ (BÊN CẠNH TẤT CẢ)
            "    if(!musicFilterTriggered && (window.location.pathname === '/' || window.location.pathname === '')){\n"
            "      var chips = document.querySelectorAll('ytm-chip-cloud-chip-renderer, ytm-feed-filter-chip-bar-renderer button, [role=\"tab\"], .chip-container button');\n"
            "      for(var i=0; i<chips.length; i++){\n"
            "        var t = (chips[i].textContent || '').trim().toLowerCase();\n"
            "        if(t === 'âm nhạc' || t === 'music'){\n"
            "          chips[i].click();\n"
            "          musicFilterTriggered = true;\n"
            // Khi đã bấm chuyển Âm nhạc, ẩn toàn bộ thanh Tất cả/Âm nhạc/Trò chơi đi để màn hình sạch bóng
            "          setTimeout(function(){\n"
            "            var cBar = document.querySelector('ytm-feed-filter-chip-bar-renderer, ytm-chip-cloud-renderer, #chips');\n"
            "            if(cBar){ cBar.style.display = 'none'; cBar.style.height = '0px'; }\n"
            "          }, 450);\n"
            "          break;\n"
            "        }\n"
            "      }\n"
            "    }\n"
            "    document.querySelectorAll('ytm-mobile-topbar-renderer, ytm-search-header, [role=\"search\"], .ad-container, ytm-pivot-bar-renderer').forEach(function(el){\n"
            "      try{ el.remove(); }catch(x){}\n"
            "    });\n"
            "    var skip = document.querySelector('.ytp-ad-skip-button, .ytp-ad-skip-button-modern, .videoAdUiSkipButton, .ytp-ad-skip-button-slot button');\n"
            "    if(skip) { try{ skip.click(); }catch(x){} }\n"
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
    return @"(function(){\n"
            "  if(!window.__phlAudioBridge){\n"
            "    window.__phlAudioBridge = {\n"
            "      gain: 1.0,\n"
            "      ctx: null,\n"
            "      nodes: new WeakMap(),\n"
            "      pauseAll: function(){\n"
            "        document.querySelectorAll('video,audio').forEach(function(e){ try{e.pause();}catch(x){} });\n"
            "      },\n"
            "      ensureContext: function(){\n"
            "        if(!this.ctx){\n"
            "          var AC = window.AudioContext || window.webkitAudioContext;\n"
            "          if(AC){ try{ this.ctx = new AC(); }catch(x){} }\n"
            "        }\n"
            "        if(this.ctx && this.ctx.state === 'suspended'){\n"
            "          this.ctx.resume().catch(function(){});\n"
            "        }\n"
            "      },\n"
            "      hookElement: function(e){\n"
            "        var self = this;\n"
            "        if(!e.__phlPlayHooked){\n"
            "          e.__phlPlayHooked = true;\n"
            "          e.addEventListener('play', function(){\n"
            "            self.applyToElement(e);\n"
            "            if(window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.phlWebMediaPlaying){\n"
            "              window.webkit.messageHandlers.phlWebMediaPlaying.postMessage('playing');\n"
            "            }\n"
            "          }, true);\n"
            "        }\n"
            "        self.applyToElement(e);\n"
            "      },\n"
            "      applyToElement: function(e){\n"
            "        var g = Math.max(0.0, Math.min(3.0, this.gain));\n"
            "        try { e.muted = (g <= 0.001); e.volume = Math.min(1.0, g); } catch(x){}\n"
            "        if(g > 1.0){\n"
            "          this.ensureContext();\n"
            "          if(this.ctx){\n"
            "            try {\n"
            "              var nodeInfo = this.nodes.get(e);\n"
            "              if(!nodeInfo){\n"
            "                var src = this.ctx.createMediaElementSource(e);\n"
            "                var gn = this.ctx.createGain();\n"
            "                var bass = this.ctx.createBiquadFilter();\n"
            "                bass.type = 'lowshelf';\n"
            "                bass.frequency.value = 250;\n"
            "                bass.gain.value = 4.0;\n"
            "                src.connect(bass);\n"
            "                bass.connect(gn);\n"
            "                gn.connect(this.ctx.destination);\n"
            "                nodeInfo = {gainNode: gn};\n"
            "                this.nodes.set(e, nodeInfo);\n"
            "              }\n"
            "              nodeInfo.gainNode.gain.setTargetAtTime(g, this.ctx.currentTime, 0.02);\n"
            "            } catch(x){}\n"
            "          }\n"
            "        } else {\n"
            "          var existing = this.nodes.get(e);\n"
            "          if(existing && existing.gainNode && this.ctx){\n"
            "            try { existing.gainNode.gain.setTargetAtTime(g, this.ctx.currentTime, 0.02); } catch(x){}\n"
            "          }\n"
            "        }\n"
            "      },\n"
            "      setGain: function(v){\n"
            "        this.gain = Math.max(0.0, Math.min(3.0, parseFloat(v) || 0.0));\n"
            "        var self = this;\n"
            "        document.querySelectorAll('video,audio').forEach(function(e){ self.hookElement(e); });\n"
            "      }\n"
            "    };\n"
            "  }\n"
            "})();";
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

        // LẮNG NGHE KHI APP MỞ LẠI -> NẠP LỆNH TỨC THÌ
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(fetchRemoteAdminConfig)
                                                     name:UIApplicationDidBecomeActiveNotification
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

- (void)applyIndependentGain:(float)val {
    _gain = MAX(0.0f, MIN(_maxAllowedGain, val));
    [[NSUserDefaults standardUserDefaults] setFloat:_gain forKey:@"PHL_IndependentAudioGain"];

    if (_gainLbl) {
        _gainLbl.text = [NSString stringWithFormat:@"%.0f%%", _gain * 100.0f];
    }

    if (_player) {
        _player.volume = MIN(1.0f, _gain);
        if (_player.currentItem) {
            [self applyGainToItem:_player.currentItem gain:_gain];
        }
    }

    if (_web) {
        NSString *js = [NSString stringWithFormat:@"if(window.__phlAudioBridge){window.__phlAudioBridge.setGain(%.3f);}", _gain];
        [_web evaluateJavaScript:js completionHandler:nil];
    }
}

- (void)cleanYouTubePageInWebView {
    if (!_web) return;
    [_web evaluateJavaScript:GetNuclearCleanAndAdBlockJS() completionHandler:nil];
}

- (UIWindow *)resolveActiveWindow {
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *s = (UIWindowScene *)scene;
                if (s.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *w in s.windows) { if (w.isKeyWindow) return w; }
                    if (s.windows.firstObject) return s.windows.firstObject;
                }
            }
        }
    }
    for (UIWindow *w in [UIApplication sharedApplication].windows) {
        if (w.isKeyWindow) return w;
    }
    return [UIApplication sharedApplication].windows.firstObject ?: [UIApplication sharedApplication].keyWindow;
}

- (void)loadRemoteLogo {
    NSString *cachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"phl_official_logo.png"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        UIImage *cached = [UIImage imageWithContentsOfFile:cachePath];
        if (cached && self->_floatBtn) {
            [self applyLogoImageToButton:cached];
            return;
        }
    }
    NSString *rawLogo = PHL_DecryptString(kEnc_GITHUB_RAW_LOGO, kLen_GITHUB_RAW_LOGO);
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:rawLogo]
                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                   timeoutInterval:8.0];
    [req setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (!e && d && d.length > 0) {
            UIImage *img = [UIImage imageWithData:d];
            if (img) {
                [d writeToFile:cachePath atomically:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self applyLogoImageToButton:img];
                });
            }
        }
    }] resume];
}

- (void)applyLogoImageToButton:(UIImage *)img {
    if (!_floatBtn || !img) return;
    [_floatBtn setTitle:@"" forState:UIControlStateNormal];
    [_floatBtn setImage:img forState:UIControlStateNormal];
    _floatBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _floatBtn.imageEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    _floatBtn.layer.cornerRadius = 24.0f;
    _floatBtn.clipsToBounds = YES;
}

- (UIButton *)makeUtilityButtonWithTitle:(NSString *)title fontSize:(CGFloat)sz bgColor:(UIColor *)bg borderColor:(UIColor *)bc action:(SEL)act {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:sz weight:UIFontWeightBold];
    btn.backgroundColor = bg;
    btn.layer.borderColor = bc.CGColor;
    btn.layer.borderWidth = 1.0;
    btn.clipsToBounds = YES;
    if (act) [btn addTarget:self action:act forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)layoutMenuSubviewsWithWidth:(CGFloat)mW height:(CGFloat)mH expanded:(BOOL)exp {
    _gradient.frame = CGRectMake(0, 0, mW, mH);
    _dragHdr.frame = CGRectMake(0, 0, mW, 48);

    _headerTitleLbl.frame = CGRectMake(10, 4, mW - 48, 15);
    _tickerLbl.frame = CGRectMake(10, 19, mW - 48, 12);
    _titleLbl.frame = CGRectMake(10, 32, mW - 44, 13);
    _closeBtn.frame = CGRectMake(mW - 34, 7, 24, 24);

    CGFloat padX = 8.0f;
    CGFloat inW = mW - (padX * 2.0f);
    CGFloat cy = 52.0f;

    CGFloat gap = 6.0f;
    CGFloat bW = floorf((inW - (gap * 3.0f)) / 4.0f);
    _btnPrev.frame = CGRectMake(padX, cy, bW, 26.0f);
    _btnPlay.frame = CGRectMake(padX + (bW + gap), cy, bW, 26.0f);
    _btnNext.frame = CGRectMake(padX + (bW + gap) * 2.0f, cy, bW, 26.0f);
    _btnRep.frame = CGRectMake(padX + (bW + gap) * 3.0f, cy, bW, 26.0f);
    cy += 30.0f;

    CGFloat vy = cy;
    CGFloat wy = cy + 26.0f;
    cy = wy + 27.0f;

    bW = 34.0f;
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

            PHLWeakScriptMessageProxy *proxy = [[PHLWeakScriptMessageProxy alloc] initWithDelegate:(id<WKScriptMessageHandler>)self];
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

        // TỰ ĐỘNG ĐỒNG BỘ CONFIG MỖI 10 GIÂY (CHỐNG TRỄ HOÀN TOÀN)
        if (!self->_autoSyncTimer) {
            self->_autoSyncTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(fetchRemoteAdminConfig) userInfo:nil repeats:YES];
        }
    });
}

#pragma mark - BỘ ĐỒNG BỘ ZERO-LATENCY (ĐỘ TRỄ 0 GIÂY QUA GITHUB API)

- (void)fetchRemoteAdminConfig {
    NSURL *apiUrl = [NSURL URLWithString:PHL_DecryptString(kEnc_GITHUB_API_CFG, kLen_GITHUB_API_CFG)];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:apiUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0];
    [req setValue:@"PHL-Engine/1.0" forHTTPHeaderField:@"User-Agent"];
    [req setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
        if (!error && data && httpResp.statusCode == 200) {
            NSDictionary *apiJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *base64Str = apiJson[@"content"];
            if (base64Str && base64Str.length > 0) {
                NSString *cleanBase64 = [base64Str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                cleanBase64 = [cleanBase64 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:cleanBase64 options:0];
                if (decodedData) {
                    NSDictionary *config = [NSJSONSerialization JSONObjectWithData:decodedData options:0 error:nil];
                    if (config && [config isKindOfClass:[NSDictionary class]]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self applyRemoteAdminConfig:config];
                        });
                        return; // NẠP THÀNH CÔNG VỚI ĐỘ TRỄ 0 GIÂY
                    }
                }
            }
        }

        // DỰ PHÒNG NẾU GITHUB API HẾT HẠN MỨC (FALLBACK)
        [self fallbackFetchRawConfig];
    }];
    [task resume];
}

- (void)fallbackFetchRawConfig {
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
    NSString *baseApi = PHL_DecryptString(kEnc_GITHUB_API_CFG, kLen_GITHUB_API_CFG); NSString *uStr = [NSString stringWithFormat:@"%@?v=%.0f", baseApi, ts];
    NSURL *u = [NSURL URLWithString:uStr];
    if (!u) return;
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:u cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0];
    [req setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        if (!e && d) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if (dict && [dict isKindOfClass:[NSDictionary class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self applyRemoteAdminConfig:dict];
                });
            }
        }
    }] resume];
}

- (void)applyRemoteAdminConfig:(NSDictionary *)dict {
    // 1. MASTER KILL-SWITCH
    if ([dict[@"system_control"][@"kill_switch"] boolValue]) {
        [self pauseStreamPlayerIfPlaying];
        [self pauseWebMediaIfPlaying];
        _floatBtn.hidden = YES;
        _menuBox.hidden = YES;
        return;
    } else if (_floatBtn) {
        _floatBtn.hidden = NO;
    }

    // 2. TÙY BIẾN NÚT NỔI & HIỆU ỨNG THỞ PHÁT SÁNG
    NSString *fIcon = dict[@"system_control"][@"floating_icon"];
    if (fIcon && fIcon.length > 0 && _floatBtn) {
        // Giữ nguyên logo tùy biến
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

    // 4. TIÊU ĐỀ, MARQUEE TICKER & NÚT ADMIN
    NSDictionary *brand = dict[@"branding"];
    if (brand) {
        if (brand[@"header_title"]) _headerTitleLbl.text = brand[@"header_title"];
        if (brand[@"ticker_announcement"]) _tickerLbl.text = brand[@"ticker_announcement"];
        if (brand[@"admin_button_text"]) [_adminBtn setTitle:brand[@"admin_button_text"] forState:UIControlStateNormal];
        if (brand[@"admin_button_url"]) _adminTargetURL = brand[@"admin_button_url"];
        if (brand[@"footer_copyright"]) _cprLbl.text = brand[@"footer_copyright"];
    }

    // 5. CÔNG SUẤT ÂM LƯỢNG (TỐI ĐA 300%)
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

    // 7. QUẢN LÝ KHÓA / MỞ YOUTUBE TỨC THÌ
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

    // 8. POPUP THÔNG BÁO TỪ ADMIN — CHỈ HIỆN 1 LẦN DUY NHẤT MỖI ID THÔNG BÁO MỚI
    NSDictionary *ann = dict[@"announcement"];
    if (ann && [ann[@"show"] boolValue]) {
        // Lấy ID thông báo (admin tự đặt, ví dụ: "tb_012_active")
        NSString *annId = ann[@"id"];
        if ([annId isKindOfClass:[NSString class]] && annId.length > 0) {
            NSString *seenKey = [@"PHL_SeenAnnouncement_" stringByAppendingString:annId];
            BOOL alreadySeen = [[NSUserDefaults standardUserDefaults] boolForKey:seenKey];
            if (!alreadySeen) {
                // Đánh dấu đã xem ngay lập tức, trước khi show để tránh race condition
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:seenKey];
                [[NSUserDefaults standardUserDefaults] synchronize];

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:ann[@"title"] ?: @"👑 THÔNG BÁO TỪ ADMIN"
                                                                               message:ann[@"message"] ?: @""
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:ann[@"button_title"] ?: @"Đã hiểu" style:UIAlertActionStyleCancel handler:nil]];
                NSString *link = ann[@"action_url"];
                if ([link isKindOfClass:[NSString class]] && link.length > 0) {
                    [alert addAction:[UIAlertAction actionWithTitle:@"Xem ngay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link] options:@{} completionHandler:nil];
                    }]];
                }
                UIWindow *w = [self resolveActiveWindow];
                UIViewController *vc = w.rootViewController;
                while (vc.presentedViewController) vc = vc.presentedViewController;
                if (vc && !vc.presentedViewController) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [vc presentViewController:alert animated:YES completion:nil];
                    });
                }
            }
            // Nếu alreadySeen == YES -> bỏ qua hoàn toàn, không làm phiền user
        }
        // Nếu không có "id" trong config -> bỏ qua hoàn toàn để an toàn
    }
}

- (void)injectFeaturedSongIntoPlaylist {
    if (!_featuredVipSong || !_playlist) return;
    NSString *vTitle = _featuredVipSong[@"title"];
    NSString *vUrl = _featuredVipSong[@"url"];
    if (!vUrl || vUrl.length == 0) return;

    if (_playlist.count > 0 && [_playlist.firstObject[@"url"] isEqualToString:vUrl]) return;
    NSDictionary *item = @{@"title": vTitle ?: @"⭐ [HOT TREND] VIP Song", @"url": vUrl};
    [_playlist insertObject:item atIndex:0];
    [_table reloadData];
}

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
    if (!_webOpen) return;
    _webOpen = NO;
    [self syncBrowserVisibilityAnimated:YES];
}

- (void)syncBrowserVisibilityAnimated:(BOOL)animated {
    [self applyMenuFrameForExpanded:_webOpen animated:animated];
    _webBox.hidden = !_webOpen;
    _table.hidden = _webOpen;
    
    if (!_isYouTubeEnabled) {
        [_btnWebToggle setTitle:@"🚫 YOUTUBE (TẠM KHÓA)" forState:UIControlStateNormal];
        [_btnWebToggle setTitleColor:[UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0] forState:UIControlStateNormal];
    } else {
        NSString *t = _webOpen ? @"☰ ĐANG MỞ YOUTUBE • VỀ KHO NHẠC (THU GỌN)" : @"🌐 MỞ YOUTUBE VIP (ZERO ADS)";
        [_btnWebToggle setTitle:t forState:UIControlStateNormal];
        [_btnWebToggle setTitleColor:[UIColor colorWithRed:0.65 green:0.98 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    }
}

- (void)loadYouTubeURLString:(NSString *)urlStr {
    if (!_web || !urlStr || urlStr.length == 0) return;
    NSURL *u = [NSURL URLWithString:urlStr];
    if (!u) return;
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:u cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    [req setValue:@"PHL-Engine/1.0" forHTTPHeaderField:@"User-Agent"];
    [_web loadRequest:req];
}

- (void)webGoBack { if (_web && _web.canGoBack) [_web goBack]; }
- (void)webGoForward { if (_web && _web.canGoForward) [_web goForward]; }
- (void)webGoHome {
    _webLoaded = YES;
    [self loadYouTubeURLString:_youtubeHomeURL];
}

- (void)triggerYouTubeSearch {
    [_searchBar resignFirstResponder];
    NSString *raw = _searchBar.text;
    if (!raw || raw.length == 0) {
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

- (void)toggleMenu {
    _menuOpen = !_menuOpen;
    if (_menuOpen) {
        _menuBox.hidden = NO;
        [self applyMenuFrameForExpanded:_webOpen animated:NO];
        _menuBox.transform = CGAffineTransformMakeScale(0.85, 0.85);
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self->_menuBox.alpha = 1.0;
            self->_menuBox.transform = CGAffineTransformIdentity;
        } completion:nil];

        // TỰ ĐỘNG CẬP NHẬT CONFIG & PLAYLIST MỖI KHI MỞ MENU
        [self fetchRemoteAdminConfig];
        [self fetchRemotePlaylist];
    } else {
        [UIView animateWithDuration:0.20 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self->_menuBox.alpha = 0.0;
            self->_menuBox.transform = CGAffineTransformMakeScale(0.85, 0.85);
        } completion:^(BOOL fin){
            self->_menuBox.hidden = YES;
        }];
    }
}

- (void)clampViewToSafeBounds:(UIView *)v topMargin:(CGFloat)tm bottomMargin:(CGFloat)bm {
    UIWindow *w = [self resolveActiveWindow];
    if (!w) return;
    CGSize sz = w.bounds.size;
    CGFloat hw = v.bounds.size.width * 0.5f;
    CGFloat hh = v.bounds.size.height * 0.5f;

    CGFloat minX = hw + 4.0f;
    CGFloat maxX = sz.width - hw - 4.0f;
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
    NSURL *u = [NSURL URLWithString:PHL_DecryptString(kEnc_GITHUB_RAW_PLAYLIST, kLen_GITHUB_RAW_PLAYLIST)];
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

        NSArray *songs = nil;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            songs = dict[@"songs"] ?: dict[@"playlist"];
        } else if ([dict isKindOfClass:[NSArray class]]) {
            songs = (NSArray *)dict;
        }
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
    _idx = index;

    NSDictionary *song = _playlist[index];
    NSString *uStr = song[@"url"];
    if (!uStr || uStr.length == 0) return;

    NSURL *u = [NSURL URLWithString:uStr];
    if (!u) return;

    [self pauseWebMediaIfPlaying];
    [self configureAudioSession];

    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    }

    _playerItem = [AVPlayerItem playerItemWithURL:u];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleItemDidFinish:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:_playerItem];

    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:_playerItem];
    } else {
        [_player replaceCurrentItemWithPlayerItem:_playerItem];
    }

    [self applyIndependentGain:_gain];
    [_player play];

    NSString *t = song[@"title"] ?: @"Đang phát";
    _titleLbl.text = [NSString stringWithFormat:@"♪ %@", t];
    [self syncPlayPauseButton];
    [_table reloadData];
}

- (void)togglePlayPause {
    [_btnPlay triggerPulseMark];
    if (!_player || !_playerItem) {
        if (_playlist.count > 0) [self playSongAtIndex:MAX(0, _idx)];
        return;
    }
    if (_player.rate > 0.01f) {
        [_player pause];
    } else {
        [self pauseWebMediaIfPlaying];
        [_player play];
    }
    [self syncPlayPauseButton];
}

- (void)syncPlayPauseButton {
    BOOL isPlaying = (_player && _player.rate > 0.01f);
    _btnPlay.activeState = isPlaying;
    [_btnPlay refreshTransportVisual];
}

- (void)playNextSong {
    if (!_playlist.count) return;
    NSInteger nxt = (_idx + 1) % (NSInteger)_playlist.count;
    [self playSongAtIndex:nxt];
    [_btnNext triggerPulseMark];
}

- (void)playPreviousSong {
    if (!_playlist.count) return;
    NSInteger prv = (_idx <= 0) ? (NSInteger)_playlist.count - 1 : _idx - 1;
    [_btnPrev triggerPulseMark];
    [self playSongAtIndex:prv];
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
    PHL_EnforceSecuritySanity();
    PHL_StartSecurityWatchdog();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[PHLProtectedAudioManager sharedInstance] initializeFramework];
    });
}
