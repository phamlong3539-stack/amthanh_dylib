// ==============================================================================
// 👑 PHL ENTERPRISE SECURE AUDIO RUNTIME (ARM64 ZERO-LATENCY MASTER ENGINE)
// 🛡️ BẢN ĐẶC BIỆT: CHỐNG CRACK ĐA TẦNG (MILITARY-GRADE ANTI-REVERSE & OBFUSCATION)
// 🎵 YOUTUBE MUSIC PURGE ENGINE: TỰ ĐỘNG CHUYỂN KHO NHẠC & XÓA SẠCH THANH CHỦ ĐỀ
// ==============================================================================

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#include <dlfcn.h>
#include <sys/sysctl.h>
#include <mach-o/dyld.h>
#include <unistd.h>

#define PHL_HIDDEN __attribute__((visibility("hidden")))

typedef NS_ENUM(NSInteger, TransportButtonKind) {
    TransportButtonKindPrevious  = 0,
    TransportButtonKindPlayPause = 1,
    TransportButtonKindNext      = 2,
    TransportButtonKindRepeat    = 3
};

#pragma mark - 🛡️ TẦNG 1: MÃ HÓA CHUỖI TỰ ĐỘNG (XOR ROLLING CIPHER - CHỐNG DUMP STRINGS)

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

// https://m.youtube.com/feed/music
static const uint8_t kEnc_YT_MUSIC[] = { 0x32, 0x2F, 0x28, 0x2D, 0x2D, 0x65, 0x4F, 0x4E, 0x0F, 0x4D, 0x1D, 0x0A, 0x13, 0x13, 0x1D, 0x0B, 0x0F, 0x45, 0x0F, 0x02, 0x03, 0x40, 0x16, 0x14, 0x17, 0x17, 0x5B, 0x18, 0x03, 0x04, 0x11, 0x1A };
static const size_t kLen_YT_MUSIC = 32;

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
static const uint8_t kEnc_DEFAULT_ADMIN_URL[] = { 0x32, 0x2F, 0x28, 0x2D, 0x2D, 0x65, 0x4F, 0x4E, 0x16, 0x4D, 0x09, 0x00, 0x49, 0x37, 0x20, 0x25, 0x5A, 0x52, 0x55, 0x5D };
static const size_t kLen_DEFAULT_ADMIN_URL = 20;

#pragma mark - 🛡️ TẦNG 2: BẢO MẬT CHỐNG DEBUG & HOOK (ANTI-LLDB, ANTI-FRIDA, ANTI-ATTACH)

PHL_HIDDEN static inline void PHL_EnforceSecuritySanity(void) {
    // 1. Chống Debugger Attach bằng Syscall ptrace động (PT_DENY_ATTACH = 31)
    typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
    ptrace_ptr_t ptrace_func = (ptrace_ptr_t)dlsym(RTLD_DEFAULT, "ptrace");
    if (ptrace_func) {
        ptrace_func(31, 0, 0, 0);
    }

    // 2. Kiểm tra tiến trình có đang bị theo dõi (P_TRACED flag qua sysctl)
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
            // Đang bị LLDB / Cycript theo dõi -> Thoát ngầm
            exit(0);
        }
    }

    // 3. Quét phát hiện Frida-Gadget / Cynject trong bộ nhớ
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

#pragma mark - Weak Proxy Helpers

@interface PHLWeakTimerTarget : NSObject
@property (nonatomic, weak) id target;
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
    CGRect b = self.bounds;
    if (CGRectIsEmpty(b)) return;

    UIColor *bgBase  = [UIColor colorWithRed:0.18 green:0.04 blue:0.26 alpha:0.92];
    UIColor *borderC = [UIColor colorWithRed:0.75 green:0.30 blue:0.95 alpha:0.75];
    UIColor *tintC   = [UIColor colorWithRed:0.95 green:0.92 blue:1.0 alpha:0.95];

    if (self.iconKind == TransportButtonKindRepeat && self.activeState) {
        bgBase  = [UIColor colorWithRed:0.45 green:0.10 blue:0.60 alpha:0.98];
        borderC = [UIColor colorWithRed:0.35 green:0.98 blue:1.0 alpha:0.95];
        tintC   = [UIColor colorWithRed:0.35 green:0.98 blue:1.0 alpha:1.0];
    }
    if (self.pulseHighlight) {
        bgBase  = [UIColor colorWithRed:0.85 green:0.15 blue:0.45 alpha:0.98];
        borderC = [UIColor whiteColor];
        tintC   = [UIColor whiteColor];
    }

    self.backgroundColor     = bgBase;
    self.layer.borderColor   = borderC.CGColor;
    self.glyphLayer.frame    = b;
    self.glyphLayer.strokeColor = tintC.CGColor;

    CGFloat cx = CGRectGetMidX(b);
    CGFloat cy = CGRectGetMidY(b);
    UIBezierPath *p = [UIBezierPath bezierPath];

    switch (self.iconKind) {
        case TransportButtonKindPlayPause: {
            if (self.activeState) {
                // Đang phát -> Hiện biểu tượng PAUSE (||)
                self.glyphLayer.fillColor = tintC.CGColor;
                CGFloat bw = 2.8, bh = 11.0, sp = 2.4;
                UIBezierPath *b1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(cx - sp - bw, cy - bh/2.0, bw, bh) cornerRadius:1.0];
                UIBezierPath *b2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(cx + sp, cy - bh/2.0, bw, bh) cornerRadius:1.0];
                [p appendPath:b1]; [p appendPath:b2];
            } else {
                // Đang dừng -> Hiện biểu tượng PLAY (▶)
                self.glyphLayer.fillColor = tintC.CGColor;
                CGFloat pw = 10.0, ph = 12.0;
                [p moveToPoint:CGPointMake(cx - pw * 0.45, cy - ph / 2.0)];
                [p addLineToPoint:CGPointMake(cx + pw * 0.55, cy)];
                [p addLineToPoint:CGPointMake(cx - pw * 0.45, cy + ph / 2.0)];
                [p closePath];
            }
            break;
        }
        case TransportButtonKindPrevious: {
            self.glyphLayer.fillColor = tintC.CGColor;
            CGFloat bw = 1.8, bh = 10.0, tw = 6.0, th = 9.0;
            UIBezierPath *bar = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(cx - 5.5, cy - bh/2.0, bw, bh) cornerRadius:0.8];
            [p appendPath:bar];
            UIBezierPath *tri = [UIBezierPath bezierPath];
            [tri moveToPoint:CGPointMake(cx - 3.5, cy)];
            [tri addLineToPoint:CGPointMake(cx + tw - 3.5, cy - th/2.0)];
            [tri addLineToPoint:CGPointMake(cx + tw - 3.5, cy + th/2.0)];
            [tri closePath];
            [p appendPath:tri];
            break;
        }
        case TransportButtonKindNext: {
            self.glyphLayer.fillColor = tintC.CGColor;
            CGFloat bw = 1.8, bh = 10.0, tw = 6.0, th = 9.0;
            UIBezierPath *bar = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(cx + 5.5 - bw, cy - bh/2.0, bw, bh) cornerRadius:0.8];
            [p appendPath:bar];
            UIBezierPath *tri = [UIBezierPath bezierPath];
            [tri moveToPoint:CGPointMake(cx + 3.5, cy)];
            [tri addLineToPoint:CGPointMake(cx - tw + 3.5, cy - th/2.0)];
            [tri addLineToPoint:CGPointMake(cx - tw + 3.5, cy + th/2.0)];
            [tri closePath];
            [p appendPath:tri];
            break;
        }
        case TransportButtonKindRepeat: {
            self.glyphLayer.fillColor = [UIColor clearColor].CGColor;
            CGFloat r = 5.2;
            [p addArcWithCenter:CGPointMake(cx, cy) radius:r startAngle:-M_PI_2 endAngle:M_PI * 1.0 clockwise:YES];
            [p moveToPoint:CGPointMake(cx, cy - r - 2.2)];
            [p addLineToPoint:CGPointMake(cx + 2.2, cy - r)];
            [p addLineToPoint:CGPointMake(cx, cy - r + 2.2)];
            break;
        }
    }
    self.glyphLayer.path = p.CGPath;

    if (self.iconKind == TransportButtonKindRepeat && self.activeState) {
        self.markerDotLayer.hidden = NO;
        self.markerDotLayer.frame = CGRectMake(cx - 1.5, b.size.height - 4.5, 3.0, 3.0);
        self.markerDotLayer.backgroundColor = [UIColor colorWithRed:0.35 green:0.98 blue:1.0 alpha:1.0].CGColor;
        self.markerDotLayer.cornerRadius = 1.5;
    } else {
        self.markerDotLayer.hidden = YES;
    }
}

@end

#pragma mark - PHLProtectedAudioManager Interface

@interface PHLProtectedAudioManager : NSObject <WKNavigationDelegate, WKScriptMessageHandler, UITextFieldDelegate> {
    UIButton        *_floatBtn;
    UIView          *_menuBox;
    CAGradientLayer *_gradient;
    UIView          *_dragHdr;

    UILabel         *_headerTitleLbl;
    UILabel         *_tickerLbl;
    UILabel         *_titleLbl;
    UIButton        *_closeBtn;

    PHLTransportButton *_btnPrev;
    PHLTransportButton *_btnPlay;
    PHLTransportButton *_btnNext;
    PHLTransportButton *_btnRep;

    UIButton        *_btnMute;
    UISlider        *_volSlider;
    UIButton        *_btnBoost;
    UILabel         *_volLbl;

    UIButton        *_btnWebToggle;
    UIView          *_webBox;
    UIButton        *_btnBack;
    UIButton        *_btnFwd;
    UIButton        *_btnHome;
    UITextField     *_searchBar;
    UIButton        *_btnSearch;
    WKWebView       *_web;

    UIButton        *_adminBtn;
    UILabel         *_cprLbl;

    NSArray         *_playlist;
    NSInteger        _curIndex;
    BOOL             _isRep;
    CGFloat          _gain;
    CGFloat          _maxAllowedGain;
    BOOL             _webOpen;
    BOOL             _webLoaded;

    AVAudioPlayer   *_streamPlayer;
    AVPlayer        *_avStreamPlayer;
    BOOL             _isAvPlayer;
    BOOL             _isHandlingMediaInterruption;
    BOOL             _isYouTubeEnabled;
    NSString        *_youtubeHomeURL;
    NSString        *_youtubeLockedMsg;
    NSString        *_adminTargetURL;
    NSDictionary    *_featuredVipSong;

    NSDictionary    *_cachedAnnouncement;
    BOOL             _isShowingAnnouncement;
    BOOL             _hasShownPopupOnLaunch;

    CGPoint          _panStartBtn;
    CGPoint          _panStartMenu;

    NSTimer         *_autoSyncTimer;
    NSTimer         *_streamPlaybackWatchdog;
}
+ (instancetype)sharedInstance;
- (void)initializeFramework;
@end

@implementation PHLProtectedAudioManager

// ─────────────── 🎵 JAVASCRIPT TIÊU DIỆT THANH CHỦ ĐỀ VÀ TỰ CHUYỂN ÂM NHẠC ─

static inline NSString *GetNuclearCleanAndAdBlockJS(void) {
    return @"(function(){\n"
            // CSS triệt hạ toàn bộ thanh chủ đề 'Tất cả', 'Âm nhạc', 'Trò chơi' và quảng cáo
            "  var css = 'ytm-feed-filter-chip-bar-renderer, ytm-chip-cloud-renderer, ytm-chip-cloud-chip-renderer, \\\n"
            "             yt-feed-filter-chip-bar-renderer, yt-chip-cloud-renderer, yt-chip-cloud-chip-renderer, \\\n"
            "             iron-selector#chips, #chips, div#chips, .chip-bar, .chip-cloud, .feed-filter-chip-bar, \\\n"
            "             [role=\"tablist\"], [aria-label*=\"Filter\" i], [aria-label*=\"Bộ lọc\" i], [role=\"tab\"], \\\n"
            "             ytm-mobile-topbar-renderer, ytm-search-header, [role=\"search\"], \\\n"
            "             .ad-container, .companion-ad-container, ytm-promoted-sparkles-web-renderer, \\\n"
            "             .ytp-ad-overlay-container, .ytp-ad-skip-button-slot, ytd-banner-promo-renderer, \\\n"
            "             ytm-paid-content-overlay-renderer, .video-ads, ytm-promoted-video-renderer, \\\n"
            "             ytm-pivot-bar-renderer, ytm-bottom-nav-bar, nav.pivot-bar { \\\n"
            "               display: none !important; \\\n"
            "               height: 0px !important; \\\n"
            "               max-height: 0px !important; \\\n"
            "               min-height: 0px !important; \\\n"
            "               visibility: hidden !important; \\\n"
            "               pointer-events: none !important; \\\n"
            "               opacity: 0 !important; \\\n"
            "               position: absolute !important; \\\n"
            "               left: -9999px !important; \\\n"
            "               top: -9999px !important; \\\n"
            "             } \\\n"
            "             ytm-page-manager, #app, ytm-app { \\\n"
            "               padding-top: 0px !important; \\\n"
            "               margin-top: 0px !important; \\\n"
            "               padding-bottom: 0px !important; \\\n"
            "             }';\n"
            "  var sid = 'phl-master-cleaner';\n"
            "  var existingStyle = document.getElementById(sid);\n"
            "  if(!existingStyle){\n"
            "    var st = document.createElement('style'); st.id = sid; st.textContent = css;\n"
            "    (document.head || document.documentElement).appendChild(st);\n"
            "  } else { existingStyle.textContent = css; }\n"
            // Tự động chuyển hướng sang trang Âm Nhạc nếu đang ở trang chủ thông thường
            "  if(window.location.hostname.indexOf('youtube.com') !== -1){\n"
            "    if(window.location.pathname === '/' || window.location.pathname === ''){\n"
            "      window.location.replace('https://m.youtube.com/feed/music');\n"
            "    }\n"
            "  }\n"
            "  function executePurge(){\n"
            // Xóa sạch phần tử DOM thanh danh mục
            "    var sel = 'ytm-feed-filter-chip-bar-renderer, ytm-chip-cloud-renderer, ytm-chip-cloud-chip-renderer, yt-feed-filter-chip-bar-renderer, yt-chip-cloud-renderer, yt-chip-cloud-chip-renderer, iron-selector#chips, #chips, div#chips, .chip-bar, .chip-cloud, [role=\"tablist\"], ytm-mobile-topbar-renderer, ytm-search-header, .ad-container, ytm-pivot-bar-renderer';\n"
            "    document.querySelectorAll(sel).forEach(function(e){ try{ e.remove(); }catch(x){} });\n"
            // Tự động bấm nút Bỏ qua quảng cáo
            "    var sk = document.querySelector('.ytp-ad-skip-button, .ytp-ad-skip-button-modern, .videoAdUiSkipButton, .ytp-ad-skip-button-slot button');\n"
            "    if(sk){ try{ sk.click(); }catch(x){} }\n"
            // Bẻ gãy video quảng cáo: Tua tốc độ 16x và tắt tiếng
            "    var ad = document.querySelector('.ad-showing, .ad-interrupting');\n"
            "    var v = document.querySelector('video');\n"
            "    if(ad && v && !isNaN(v.duration)){\n"
            "      v.muted = true; v.playbackRate = 16.0; v.currentTime = v.duration;\n"
            "    }\n"
            "  }\n"
            "  executePurge();\n"
            "  setInterval(executePurge, 200);\n"
            "  if(window.MutationObserver){\n"
            "    var obs = new MutationObserver(function(){ executePurge(); });\n"
            "    obs.observe(document.documentElement, { childList: true, subtree: true });\n"
            "  }\n"
            "})();";
}

static inline NSString *GetAudioBridgeJS(void) {
    return @"(function(){\n"
            "if(!window.__phlAudioBridge){\n"
            "window.__phlAudioBridge={\n"
            "gain:1.0,ctx:null,nodes:new WeakMap(),\n"
            "pauseAll:function(){document.querySelectorAll('video,audio').forEach(function(e){try{e.pause();}catch(x){}});},\n"
            "ensureContext:function(){\n"
            "if(!this.ctx){var AC=window.AudioContext||window.webkitAudioContext;if(AC){try{this.ctx=new AC();}catch(x){}}}\n"
            "if(this.ctx&&this.ctx.state==='suspended'){this.ctx.resume().catch(function(){});}},\n"
            "hookElement:function(e){\n"
            "var self=this;\n"
            "if(!e.__phlPlayHooked){e.__phlPlayHooked=true;e.addEventListener('play',function(){\n"
            "self.applyToElement(e);\n"
            "if(window.webkit&&window.webkit.messageHandlers&&window.webkit.messageHandlers.phlWebMediaPlaying){\n"
            "window.webkit.messageHandlers.phlWebMediaPlaying.postMessage('playing');}},true);}\n"
            "self.applyToElement(e);},\n"
            "applyToElement:function(e){\n"
            "var g=Math.max(0.0,Math.min(3.0,this.gain));try{e.muted=(g<=0.001);e.volume=Math.min(1.0,g);}catch(x){}\n"
            "if(g>1.0){this.ensureContext();if(this.ctx){try{\n"
            "var ni=this.nodes.get(e);\n"
            "if(!ni){\n"
            "var src=this.ctx.createMediaElementSource(e);var gn=this.ctx.createGain();\n"
            "var bs=this.ctx.createBiquadFilter();bs.type='lowshelf';bs.frequency.value=250;bs.gain.value=4.0;\n"
            "src.connect(bs);bs.connect(gn);gn.connect(this.ctx.destination);\n"
            "ni={gainNode:gn};this.nodes.set(e,ni);}\n"
            "if(ni&&ni.gainNode){ni.gainNode.gain.setValueAtTime(g,this.ctx.currentTime);}\n"
            "}catch(x){}}}\n"
            "else{try{var ex=this.nodes.get(e);if(ex&&ex.gainNode){ex.gainNode.gain.setValueAtTime(1.0,this.ctx?this.ctx.currentTime:0);}}catch(x){}},\n"
            "setGain:function(g){\n"
            "this.gain=Math.max(0.0,Math.min(3.0,g));var self=this;\n"
            "document.querySelectorAll('video,audio').forEach(function(el){self.hookElement(el);});}\n"
            "};\n"
            "document.querySelectorAll('video,audio').forEach(function(el){window.__phlAudioBridge.hookElement(el);});\n"
            "}\n"
            "})();";
}

#pragma mark - Singleton Implementation

+ (instancetype)sharedInstance {
    static PHLProtectedAudioManager *sInst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInst = [[PHLProtectedAudioManager alloc] init];
    });
    return sInst;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _playlist           = @[];
        _curIndex           = 0;
        _isRep              = NO;
        _gain               = 1.0f;
        _maxAllowedGain     = 3.0f;
        _webOpen            = NO;
        _webLoaded          = NO;
        _isYouTubeEnabled   = YES;
        _isAvPlayer         = NO;
        _isHandlingMediaInterruption = NO;
        _isShowingAnnouncement = NO;
        _hasShownPopupOnLaunch = NO;

        // Mặc định tự chuyển thẳng vào kho Âm Nhạc YouTube Music
        _youtubeHomeURL     = PHL_DecryptString(kEnc_YT_MUSIC, kLen_YT_MUSIC);
        _youtubeLockedMsg   = @"Tính năng YouTube đang bảo trì!";
        _adminTargetURL     = PHL_DecryptString(kEnc_DEFAULT_ADMIN_URL, kLen_DEFAULT_ADMIN_URL);

        [self setupAudioSessionCategory];
        [self registerInterruptionObserver];
    }
    return self;
}

// ─────────────── Audio Session Configuration ───────────────────────────────

- (void)setupAudioSessionCategory {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [session setCategory:AVAudioSessionCategoryPlayback
             withOptions:(AVAudioSessionCategoryOptionMixWithOthers |
                          AVAudioSessionCategoryOptionAllowBluetooth |
                          AVAudioSessionCategoryOptionAllowAirPlay)
                   error:&error];
    [session setActive:YES error:&error];
}

- (void)registerInterruptionObserver {
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(handleAudioSessionInterruption:)
               name:AVAudioSessionInterruptionNotification
             object:nil];
}

- (void)handleAudioSessionInterruption:(NSNotification *)note {
    NSDictionary *info = note.userInfo;
    AVAudioSessionInterruptionType type =
        (AVAudioSessionInterruptionType)[info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];

    if (type == AVAudioSessionInterruptionTypeBegan) {
        _isHandlingMediaInterruption = YES;
        [self syncPlayPauseButtonVisualState:NO];
    } else if (type == AVAudioSessionInterruptionTypeEnded) {
        _isHandlingMediaInterruption = NO;
        AVAudioSessionInterruptionOptions opts =
            [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (opts & AVAudioSessionInterruptionOptionShouldResume) {
            [self setupAudioSessionCategory];
            if (_isAvPlayer && _avStreamPlayer) {
                [_avStreamPlayer play];
                [self syncPlayPauseButtonVisualState:YES];
            } else if (_streamPlayer) {
                [_streamPlayer play];
                [self syncPlayPauseButtonVisualState:YES];
            }
        }
    }
}

// ─────────────── Âm Lượng Độc Lập Siêu Tăng Âm 300% (Independent Gain) ────────

- (void)applyIndependentGain:(CGFloat)v {
    _gain = MAX(0.0f, MIN(_maxAllowedGain, v));

    if (_streamPlayer) {
        _streamPlayer.volume = MIN(1.0f, _gain);
    }
    if (_avStreamPlayer) {
        _avStreamPlayer.volume = MIN(1.0f, _gain);
    }

    _volLbl.text = [NSString stringWithFormat:@"%.0f%%", _gain * 100.0f];

    if (_web) {
        NSString *js = [NSString stringWithFormat:
            @"%@;if(window.__phlAudioBridge){window.__phlAudioBridge.setGain(%.3f);}",
            GetAudioBridgeJS(), v];
        [_web evaluateJavaScript:js completionHandler:nil];
    }
}

- (void)pauseStreamPlayerIfPlaying {
    if (_streamPlayer && _streamPlayer.isPlaying) [_streamPlayer pause];
    if (_avStreamPlayer && _avStreamPlayer.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        [_avStreamPlayer pause];
    }
    [self syncPlayPauseButtonVisualState:NO];
}

- (void)pauseWebMediaIfPlaying {
    if (!_web) return;
    [_web evaluateJavaScript:
        @"(function(){if(window.__phlAudioBridge){window.__phlAudioBridge.pauseAll();}"
        @"document.querySelectorAll('video,audio').forEach(function(e){try{e.pause();}catch(x){}});})();"
        completionHandler:nil];
}

// ─────────────── TẢI LOGO TRỰC TIẾP TỪ GITHUB (ZERO DELAY CACHE) ──────────

- (void)loadRemoteLogo {
    NSString *cachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"phl_official_logo.png"];

    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        UIImage *cached = [UIImage imageWithContentsOfFile:cachePath];
        if (cached) {
            [self applyLogoImageToButton:cached];
            return;
        }
    }

    NSString *rawLogoURL = PHL_DecryptString(kEnc_GITHUB_RAW_LOGO, kLen_GITHUB_RAW_LOGO);
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:rawLogoURL]
                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                   timeoutInterval:10.0];
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
    _floatBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _floatBtn.layer.cornerRadius = 24.0f;
    _floatBtn.clipsToBounds = YES;
}

// ─────────────── Window & ViewController Helpers ───────────────────────────

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

    if ([link isKindOfClass:[NSString class]] && link.length > 0) {
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

// ─────────────── Button Factory ─────────────────────────────────────────────

- (UIButton *)makeUtilBtn:(NSString *)title size:(CGFloat)sz
                       bg:(UIColor *)bg border:(UIColor *)bc action:(SEL)act {
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

// ─────────────── Floating Button & Subview Layout ──────────────────────────

- (void)layoutMenuSubviewsWithWidth:(CGFloat)w height:(CGFloat)h expanded:(BOOL)exp {
    _gradient.frame = CGRectMake(0, 0, w, h);
    _dragHdr.frame  = CGRectMake(0, 0, w, 44);

    _headerTitleLbl.frame = CGRectMake(10, 4, w - 46, 15);
    _tickerLbl.frame      = CGRectMake(10, 19, w - 46, 12);
    _titleLbl.frame       = CGRectMake(10, 31, w - 46, 12);
    _closeBtn.frame       = CGRectMake(w - 32, 10, 24, 24);

    CGFloat y = 48.0;

    // Bộ 4 nút điều khiển
    CGFloat bGap = 6.0;
    CGFloat bW = floor((w - 20.0 - (3.0 * bGap)) / 4.0);
    _btnPrev.frame = CGRectMake(10.0, y, bW, 26.0);
    _btnPlay.frame = CGRectMake(10.0 + (bW + bGap), y, bW, 26.0);
    _btnNext.frame = CGRectMake(10.0 + (bW + bGap) * 2.0, y, bW, 26.0);
    _btnRep.frame  = CGRectMake(10.0 + (bW + bGap) * 3.0, y, bW, 26.0);

    y += 30.0;

    // Thanh Volume Slider
    _btnMute.frame   = CGRectMake(10, y, 20, 20);
    _volSlider.frame = CGRectMake(32, y, w - 92, 20);
    _btnBoost.frame  = CGRectMake(w - 58, y, 20, 20);
    _volLbl.frame    = CGRectMake(w - 36, y, 26, 20);

    y += 24.0;

    // Nút mở/đóng YouTube
    _btnWebToggle.frame = CGRectMake(10, y, w - 20, 22);
    y += 26.0;

    if (exp) {
        _webBox.hidden = NO;
        CGFloat navH = 22.0;
        _btnBack.frame   = CGRectMake(0, 0, 24, navH);
        _btnFwd.frame    = CGRectMake(26, 0, 24, navH);
        _btnHome.frame   = CGRectMake(52, 0, 32, navH);
        _btnSearch.frame = CGRectMake(w - 56, 0, 36, navH);
        CGFloat sW = MAX(40.0f, (w - 20.0f) - 90.0f - 40.0f);
        _searchBar.frame = CGRectMake(86, 0, sW, navH);

        CGFloat boxH = h - y - 36.0;
        _webBox.frame = CGRectMake(10, y, w - 20, boxH);
        _web.frame    = CGRectMake(0, navH + 2.0, w - 20, boxH - navH - 2.0);
        y += boxH + 4.0;
    } else {
        _webBox.hidden = YES;
    }

    // Nút Admin Telegram
    _adminBtn.frame = CGRectMake(10, y, w - 20, 20);
    y += 22.0;

    // Copyright
    _cprLbl.frame = CGRectMake(10, y, w - 20, 18);
}

// ─────────────── KHỞI TẠO FRAMEWORK & GIAO DIỆN ───────────────────────────

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

            [self->_floatBtn setTitle:@"👑" forState:UIControlStateNormal];
            self->_floatBtn.titleLabel.font = [UIFont systemFontOfSize:22];

            [self->_floatBtn addTarget:self action:@selector(toggleMenu)
              forControlEvents:UIControlEventTouchUpInside];
            UIPanGestureRecognizer *pg =
                [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(handleFloatingPan:)];
            [self->_floatBtn addGestureRecognizer:pg];
            [kw addSubview:self->_floatBtn];

            [self loadRemoteLogo];

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
            self->_volSlider.minimumValue = 0.0f;
            self->_volSlider.maximumValue = self->_maxAllowedGain;
            self->_volSlider.value        = self->_gain;
            self->_volSlider.minimumTrackTintColor =
                [UIColor colorWithRed:0.95 green:0.25 blue:0.75 alpha:1.0];
            self->_volSlider.maximumTrackTintColor =
                [UIColor colorWithRed:0.2 green:0.1 blue:0.35 alpha:1.0];
            self->_volSlider.thumbTintColor =
                [UIColor colorWithRed:1.0 green:0.85 blue:0.3 alpha:1.0];
            [self->_volSlider addTarget:self action:@selector(handleVolumeChanged:)
                forControlEvents:UIControlEventValueChanged];
            [self->_menuBox addSubview:self->_volSlider];

            self->_btnBoost = [UIButton buttonWithType:UIButtonTypeSystem];
            [self->_btnBoost setTitle:@"🔊" forState:UIControlStateNormal];
            self->_btnBoost.titleLabel.font = [UIFont systemFontOfSize:12];
            [self->_btnBoost addTarget:self action:@selector(increaseVolumeStep)
                forControlEvents:UIControlEventTouchUpInside];
            [self->_menuBox addSubview:self->_btnBoost];

            self->_volLbl = [self makeLbl:@"100%" size:9.0 weight:UIFontWeightBold
                color:[UIColor colorWithRed:1.0 green:0.9 blue:0.5 alpha:1.0]];
            self->_volLbl.textAlignment = NSTextAlignmentRight;
            [self->_menuBox addSubview:self->_volLbl];

            self->_btnWebToggle = [self makeUtilBtn:@"≡ MỞ YOUTUBE AD-BLOCK" size:9.5
                bg:[UIColor colorWithRed:0.12 green:0.04 blue:0.24 alpha:0.95]
                border:[UIColor colorWithRed:0.8 green:0.3 blue:0.95 alpha:0.85]
                action:@selector(toggleEmbeddedBrowser)];
            self->_btnWebToggle.layer.cornerRadius = 6;
            [self->_menuBox addSubview:self->_btnWebToggle];

            self->_webBox = [[UIView alloc] init];
            self->_webBox.backgroundColor = [UIColor blackColor];
            self->_webBox.layer.cornerRadius = 8;
            self->_webBox.clipsToBounds      = YES;
            self->_webBox.hidden             = YES;
            [self->_menuBox addSubview:self->_webBox];

            self->_btnBack = [self makeUtilBtn:@"◀" size:10.5
                bg:[UIColor colorWithRed:0.22 green:0.05 blue:0.32 alpha:0.95]
                border:[UIColor colorWithRed:0.7 green:0.3 blue:0.85 alpha:0.8]
                action:@selector(webGoBack)];
            self->_btnBack.layer.cornerRadius = 5;
            [self->_webBox addSubview:self->_btnBack];

            self->_btnFwd = [self makeUtilBtn:@"▶" size:10.5
                bg:[UIColor colorWithRed:0.22 green:0.05 blue:0.32 alpha:0.95]
                border:[UIColor colorWithRed:0.7 green:0.3 blue:0.85 alpha:0.8]
                action:@selector(webGoForward)];
            self->_btnFwd.layer.cornerRadius = 5;
            [self->_webBox addSubview:self->_btnFwd];

            self->_btnHome = [self makeUtilBtn:@"🏠 YT" size:9.5
                bg:[UIColor colorWithRed:0.22 green:0.05 blue:0.32 alpha:0.95]
                border:[UIColor colorWithRed:0.7 green:0.3 blue:0.85 alpha:0.8]
                action:@selector(webGoHome)];
            self->_btnHome.layer.cornerRadius = 5;
            [self->_webBox addSubview:self->_btnHome];

            self->_searchBar = [[UITextField alloc] init];
            self->_searchBar.backgroundColor =
                [UIColor colorWithRed:0.15 green:0.03 blue:0.22 alpha:0.95];
            self->_searchBar.textColor = [UIColor whiteColor];
            self->_searchBar.font = [UIFont systemFontOfSize:9.5];
            self->_searchBar.layer.cornerRadius = 5;
            self->_searchBar.layer.borderWidth  = 0.8;
            self->_searchBar.layer.borderColor  =
                [UIColor colorWithRed:0.65 green:0.25 blue:0.85 alpha:0.7].CGColor;
            self->_searchBar.attributedPlaceholder =
                [[NSAttributedString alloc] initWithString:@"Nhập tên bài hát / ca sĩ..."
                    attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
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
            // Tiêm CSS ngay khi Document Bắt đầu (Pre-render) để thanh chủ đề không bị nháy
            [ucc addUserScript:[[WKUserScript alloc]
                initWithSource:GetNuclearCleanAndAdBlockJS()
                injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                forMainFrameOnly:NO]];
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
            self->_web.layer.cornerRadius = 6;
            self->_web.clipsToBounds      = YES;
            [self->_webBox addSubview:self->_web];

            self->_adminBtn = [self makeUtilBtn:@"💬 LIÊN HỆ TELEGRAM ADMIN" size:9.5
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
    l.textAlignment = NSTextAlignmentLeft;
    return l;
}

// ─────────────── Zero-Latency GitHub Admin Config ──────────────────────────

- (void)fetchRemoteAdminConfig {
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
    NSString *baseApi = PHL_DecryptString(kEnc_GITHUB_API_CFG, kLen_GITHUB_API_CFG);
    NSString *uStr = [NSString stringWithFormat:@"%@?v=%.0f", baseApi, ts];

    NSMutableURLRequest *req =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uStr]
                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                            timeoutInterval:8.0];
    [req setValue:@"PHL-Engine/2.5" forHTTPHeaderField:@"User-Agent"];
    [req setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];

    [[[NSURLSession sharedSession] dataTaskWithRequest:req
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *hr = (NSHTTPURLResponse *)response;
            if (!error && data && hr.statusCode == 200) {
                NSDictionary *api = [NSJSONSerialization JSONObjectWithData:data
                    options:0 error:nil];
                NSString *b64 = api[@"content"];
                if ([b64 isKindOfClass:[NSString class]] && b64.length > 0) {
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
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
    NSString *baseApi = PHL_DecryptString(kEnc_GITHUB_API_CFG, kLen_GITHUB_API_CFG);
    NSString *uStr = [NSString stringWithFormat:@"%@?v=%.0f", baseApi, ts];
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

// ─────────────── THỰC THI LỆNH ADMIN TỨC THÌ (ZERO DELAY) ──────────────────

- (void)applyRemoteAdminConfig:(NSDictionary *)dict {
    // 1. LỆNH KILL-SWITCH
    if ([dict[@"system_control"][@"kill_switch"] boolValue]) {
        [self pauseStreamPlayerIfPlaying];
        [self pauseWebMediaIfPlaying];
        _floatBtn.hidden = YES;
        _menuBox.hidden  = YES;
        return;
    } else if (_floatBtn) {
        _floatBtn.hidden = NO;
    }

    // 2. LỆNH HIỆU ỨNG THỞ NÚT NỔI
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

    // 3. LỆNH ĐỔI MÀU GIAO DIỆN NEON THEME
    NSDictionary *th = dict[@"theme_customizer"];
    if (th && [th isKindOfClass:[NSDictionary class]]) {
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

    // 4. LỆNH THƯƠNG HIỆU & LIÊN HỆ ADMIN
    NSDictionary *brand = dict[@"branding"];
    if (brand && [brand isKindOfClass:[NSDictionary class]]) {
        if ([brand[@"header_title"] isKindOfClass:[NSString class]])     _headerTitleLbl.text = brand[@"header_title"];
        if ([brand[@"ticker_announcement"] isKindOfClass:[NSString class]]) _tickerLbl.text   = brand[@"ticker_announcement"];
        if ([brand[@"admin_button_text"] isKindOfClass:[NSString class]])
            [_adminBtn setTitle:brand[@"admin_button_text"] forState:UIControlStateNormal];
        if ([brand[@"admin_button_url"] isKindOfClass:[NSString class]]) _adminTargetURL = brand[@"admin_button_url"];
        if ([brand[@"footer_copyright"] isKindOfClass:[NSString class]]) _cprLbl.text    = brand[@"footer_copyright"];
    }

    // 5. LỆNH CÔNG SUẤT ÂM LƯỢNG (MAX GAIN BOOSTER)
    NSDictionary *audioCfg = dict[@"audio_engine"];
    if (audioCfg && [audioCfg isKindOfClass:[NSDictionary class]] && audioCfg[@"max_gain"]) {
        _maxAllowedGain = MAX(1.0f, [audioCfg[@"max_gain"] floatValue]);
        _volSlider.maximumValue = _maxAllowedGain;
    }

    // 6. LỆNH GHIM BÀI HÁT VIP HOT TREND
    NSDictionary *feat = dict[@"vip_featured_song"];
    if (feat && [feat isKindOfClass:[NSDictionary class]] && [feat[@"enabled"] boolValue]) {
        _featuredVipSong = feat;
        [self injectFeaturedSongIntoPlaylist];
    }

    // 7. LỆNH KHÓA/MỞ YOUTUBE TỨC THÌ
    NSDictionary *ytCfg = dict[@"youtube_module"];
    if (ytCfg && [ytCfg isKindOfClass:[NSDictionary class]]) {
        if (ytCfg[@"enabled"] != nil) {
            _isYouTubeEnabled = [ytCfg[@"enabled"] boolValue];
        }
        NSString *hUrl = ytCfg[@"home_url"];
        if ([hUrl isKindOfClass:[NSString class]] && hUrl.length > 0) {
            // Tự động chuẩn hóa về kho Âm Nhạc nếu là trang chủ chung
            if ([hUrl isEqualToString:@"https://m.youtube.com"] ||
                [hUrl isEqualToString:@"https://m.youtube.com/"] ||
                [hUrl isEqualToString:@"https://youtube.com"] ||
                [hUrl isEqualToString:@"https://www.youtube.com"]) {
                hUrl = @"https://m.youtube.com/feed/music";
            }
            _youtubeHomeURL = hUrl;
        }
        NSString *lReason = ytCfg[@"locked_reason"];
        if ([lReason isKindOfClass:[NSString class]] && lReason.length > 0) {
            _youtubeLockedMsg = lReason;
        }
        [self syncBrowserButtonTitle];
        if (!_isYouTubeEnabled && _webOpen) [self closeEmbeddedBrowser];
    }

    // 8. LỆNH BẮN POPUP THÔNG BÁO TỨC THÌ
    NSDictionary *ann = dict[@"announcement"];
    if (ann && [ann isKindOfClass:[NSDictionary class]] && [ann[@"show"] boolValue]) {
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
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
    NSString *base = PHL_DecryptString(kEnc_GITHUB_RAW_PLAYLIST, kLen_GITHUB_RAW_PLAYLIST);
    NSString *uStr = [NSString stringWithFormat:@"%@?v=%.0f", base, ts];
    NSMutableURLRequest *req =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:uStr]
                                cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                            timeoutInterval:8.0];
    [req setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];

    [[[NSURLSession sharedSession] dataTaskWithRequest:req
        completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
            if (!e && d) {
                NSArray *arr = [NSJSONSerialization JSONObjectWithData:d
                    options:0 error:nil];
                if ([arr isKindOfClass:[NSArray class]] && arr.count > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self->_playlist = arr;
                        [self injectFeaturedSongIntoPlaylist];
                        if (self->_curIndex >= (NSInteger)self->_playlist.count) {
                            self->_curIndex = 0;
                        }
                        [self updateSongTitleDisplay];
                    });
                }
            }
        }] resume];
}

- (void)injectFeaturedSongIntoPlaylist {
    if (!_featuredVipSong) return;
    NSString *vUrl = _featuredVipSong[@"url"];
    if (![vUrl isKindOfClass:[NSString class]] || vUrl.length == 0) return;
    if (_playlist.count > 0 && [_playlist.firstObject[@"url"] isEqualToString:vUrl]) return;

    NSMutableArray *m = [_playlist mutableCopy] ?: [NSMutableArray array];
    [m insertObject:_featuredVipSong atIndex:0];
    _playlist = [m copy];
}

- (void)updateSongTitleDisplay {
    if (_playlist.count == 0) {
        _titleLbl.text = @"♪ Danh sách bài hát đang trống";
        return;
    }
    NSDictionary *song = _playlist[_curIndex];
    NSString *name     = song[@"title"] ?: song[@"name"] ?: @"Không tên";
    _titleLbl.text     = [NSString stringWithFormat:@"♪ [%ld/%lu] %@",
                          (long)(_curIndex + 1), (unsigned long)_playlist.count, name];
}

// ─────────────── Stream Audio Player ───────────────────────────────────────

- (void)playCurrentSong {
    if (_playlist.count == 0) return;
    NSDictionary *song = _playlist[_curIndex];
    NSString *urlStr   = song[@"url"];
    NSString *name     = song[@"title"] ?: song[@"name"] ?: @"Không tên";
    if (![urlStr isKindOfClass:[NSString class]] || urlStr.length == 0) return;

    [self pauseWebMediaIfPlaying];

    _titleLbl.text = [NSString stringWithFormat:@"⏳ Đang nạp: %@", name];
    [self syncPlayPauseButtonVisualState:YES];

    NSURL *u = [NSURL URLWithString:urlStr];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *err = nil;
        NSData *d = [NSData dataWithContentsOfURL:u options:NSDataReadingMappedIfSafe error:&err];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!err && d && d.length > 32) {
                NSError *pErr = nil;
                self->_streamPlayer = [[AVAudioPlayer alloc] initWithData:d error:&pErr];
                if (!pErr && self->_streamPlayer) {
                    self->_isAvPlayer = NO;
                    self->_streamPlayer.numberOfLoops = 0;
                    self->_streamPlayer.volume = MIN(1.0f, self->_gain);
                    [self->_streamPlayer prepareToPlay];
                    [self->_streamPlayer play];
                    [self updateSongTitleDisplay];
                    [self syncPlayPauseButtonVisualState:YES];
                    [self armPlaybackWatchdog];
                    return;
                }
            }
            [self playViaAVPlayerFallback:u name:name];
        });
    });
}

- (void)playViaAVPlayerFallback:(NSURL *)url name:(NSString *)name {
    _isAvPlayer     = YES;
    _avStreamPlayer = [AVPlayer playerWithURL:url];
    _avStreamPlayer.volume = MIN(1.0f, _gain);
    [_avStreamPlayer play];
    [self updateSongTitleDisplay];
    [self syncPlayPauseButtonVisualState:YES];
    [self armPlaybackWatchdog];
}

- (void)armPlaybackWatchdog {
    [_streamPlaybackWatchdog invalidate];
    PHLWeakTimerTarget *t =
        [PHLWeakTimerTarget proxyWithTarget:self
                                   selector:@selector(checkStreamPlaybackStatus)];
    _streamPlaybackWatchdog =
        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:t
                                       selector:@selector(fire:)
                                       userInfo:nil
                                        repeats:YES];
}

- (void)checkStreamPlaybackStatus {
    if (!_isRep) {
        if (!_isAvPlayer && _streamPlayer) {
            if (!_streamPlayer.isPlaying && _streamPlayer.currentTime >= _streamPlayer.duration - 0.5) {
                [self playNextSong];
            }
        }
    } else {
        if (!_isAvPlayer && _streamPlayer && !_streamPlayer.isPlaying) {
            _streamPlayer.currentTime = 0;
            [_streamPlayer play];
        }
    }
}

// ─────────────── Control Actions ───────────────────────────────────────────

- (void)playPreviousSong {
    [_btnPrev triggerPulseMark];
    if (_playlist.count == 0) return;
    _curIndex = (_curIndex - 1 + _playlist.count) % _playlist.count;
    [self playCurrentSong];
}

- (void)playNextSong {
    [_btnNext triggerPulseMark];
    if (_playlist.count == 0) return;
    _curIndex = (_curIndex + 1) % _playlist.count;
    [self playCurrentSong];
}

- (void)togglePlayPause {
    [_btnPlay triggerPulseMark];

    BOOL isStreamPlaying = NO;
    if (_isAvPlayer && _avStreamPlayer) {
        isStreamPlaying = (_avStreamPlayer.timeControlStatus == AVPlayerTimeControlStatusPlaying);
    } else if (_streamPlayer) {
        isStreamPlaying = _streamPlayer.isPlaying;
    }

    if (isStreamPlaying) {
        [self pauseStreamPlayerIfPlaying];
    } else {
        if (!_streamPlayer && !_avStreamPlayer) {
            [self playCurrentSong];
        } else if (_isAvPlayer && _avStreamPlayer) {
            [self pauseWebMediaIfPlaying];
            [_avStreamPlayer play];
            [self syncPlayPauseButtonVisualState:YES];
        } else if (_streamPlayer) {
            [self pauseWebMediaIfPlaying];
            [_streamPlayer play];
            [self syncPlayPauseButtonVisualState:YES];
        }
    }
}

- (void)syncPlayPauseButtonVisualState:(BOOL)isPlaying {
    _btnPlay.activeState = isPlaying;
    [_btnPlay refreshTransportVisual];
}

- (void)toggleRepeatMode {
    _isRep = !_isRep;
    [self syncRepeatButton];
}

- (void)syncRepeatButton {
    _btnRep.activeState = _isRep;
    [_btnRep refreshTransportVisual];
}

// ─────────────── Volume Slider Controls ────────────────────────────────────

- (void)decreaseVolumeStep {
    CGFloat nv = MAX(0.0f, _gain - 0.1f);
    _volSlider.value = nv;
    [self applyIndependentGain:nv];
}

- (void)increaseVolumeStep {
    CGFloat nv = MIN(_maxAllowedGain, _gain + 0.1f);
    _volSlider.value = nv;
    [self applyIndependentGain:nv];
}

- (void)handleVolumeChanged:(UISlider *)s {
    [self applyIndependentGain:s.value];
}

// ─────────────── Menu Animations ───────────────────────────────────────────

- (void)toggleMenu {
    if (_menuBox.hidden) {
        _menuBox.hidden = NO;
        _menuBox.transform = CGAffineTransformMakeScale(0.85, 0.85);
        [UIView animateWithDuration:0.25 delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            self->_menuBox.alpha = 1.0;
            self->_menuBox.transform = CGAffineTransformIdentity;
        } completion:nil];

        // BẮN POPUP NGAY LẬP TỨC KHI CHẠM MỞ MENU
        [self triggerAnnouncementPopupExplicitly];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self fetchRemoteAdminConfig];
        });
    } else {
        [UIView animateWithDuration:0.2 delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            self->_menuBox.alpha = 0.0;
            self->_menuBox.transform = CGAffineTransformMakeScale(0.85, 0.85);
        } completion:^(BOOL finished){
            self->_menuBox.hidden = YES;
        }];
    }
}

// ─────────────── Web Browser / YouTube Controls ────────────────────────────

- (void)syncBrowserButtonTitle {
    if (!_isYouTubeEnabled) {
        [_btnWebToggle setTitle:[NSString stringWithFormat:@"🔒 %@", _youtubeLockedMsg]
                       forState:UIControlStateNormal];
        _btnWebToggle.backgroundColor =
            [UIColor colorWithRed:0.25 green:0.04 blue:0.08 alpha:0.95];
    } else if (_webOpen) {
        [_btnWebToggle setTitle:@"≡ ĐANG MỞ YOUTUBE • THU GỌN"
                       forState:UIControlStateNormal];
        _btnWebToggle.backgroundColor =
            [UIColor colorWithRed:0.05 green:0.22 blue:0.42 alpha:0.95];
    } else {
        [_btnWebToggle setTitle:@"≡ MỞ YOUTUBE AD-BLOCK"
                       forState:UIControlStateNormal];
        _btnWebToggle.backgroundColor =
            [UIColor colorWithRed:0.12 green:0.04 blue:0.24 alpha:0.95];
    }
}

- (void)toggleEmbeddedBrowser {
    if (!_isYouTubeEnabled) {
        UIAlertController *al =
            [UIAlertController alertControllerWithTitle:@"👑 THÔNG BÁO"
                                                message:_youtubeLockedMsg
                                         preferredStyle:UIAlertControllerStyleAlert];
        [al addAction:[UIAlertAction actionWithTitle:@"Đã hiểu"
                                               style:UIAlertActionStyleDefault
                                             handler:nil]];
        UIViewController *top = [self resolveTopViewController];
        if (top) [top presentViewController:al animated:YES completion:nil];
        return;
    }

    if (_webOpen) {
        [self closeEmbeddedBrowser];
    } else {
        [self openEmbeddedBrowser];
    }
}

- (void)openEmbeddedBrowser {
    _webOpen = YES;
    [self syncBrowserButtonTitle];

    UIWindow *w = [self resolveActiveWindow];
    CGFloat sW  = w.bounds.size.width;
    CGFloat sH  = w.bounds.size.height;
    CGFloat expW = MIN(sW - 20.0f, 320.0f);
    CGFloat expH = MIN(sH - 24.0f, 340.0f);

    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self->_menuBox.frame;
        f.size.width  = expW;
        f.size.height = expH;
        self->_menuBox.frame = f;
        [self layoutMenuSubviewsWithWidth:expW height:expH expanded:YES];
    }];

    if (!_webLoaded) {
        _webLoaded = YES;
        [self loadYouTubeURL:_youtubeHomeURL];
    } else if (_webOpen) {
        [self applyIndependentGain:_gain];
    }
}

- (void)closeEmbeddedBrowser {
    _webOpen = NO;
    [self syncBrowserButtonTitle];

    UIWindow *w = [self resolveActiveWindow];
    CGFloat sW  = w.bounds.size.width;
    CGFloat sH  = w.bounds.size.height;
    CGFloat cW = MAX(268.0f, MIN(312.0f, sW - 86.0f));
    CGFloat cH = MIN(332.0f, MAX(250.0f, sH - 24.0f));

    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self->_menuBox.frame;
        f.size.width  = cW;
        f.size.height = cH;
        self->_menuBox.frame = f;
        [self layoutMenuSubviewsWithWidth:cW height:cH expanded:NO];
    }];
}

- (void)loadYouTubeURL:(NSString *)urlStr {
    if (!_web || ![urlStr isKindOfClass:[NSString class]] || urlStr.length == 0) return;
    NSURL *u = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:u];
    [req setValue:@"PHL-Engine/2.5" forHTTPHeaderField:@"User-Agent"];
    [_web loadRequest:req];
}

- (void)webGoBack    { if (_web.canGoBack)    [_web goBack]; }
- (void)webGoForward { if (_web.canGoForward) [_web goForward]; }
- (void)webGoHome    { [self loadYouTubeURL:_youtubeHomeURL ?: @"https://m.youtube.com/feed/music"]; }

- (void)triggerYouTubeSearch {
    [_searchBar resignFirstResponder];
    NSString *raw =
        [_searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (raw.length == 0) {
        [self loadYouTubeURL:_youtubeHomeURL];
        return;
    }
    NSString *enc =
        [raw stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *uStr = [NSString stringWithFormat:@"https://m.youtube.com/results?search_query=%@", enc];
    [self loadYouTubeURL:uStr];
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf {
    [self triggerYouTubeSearch];
    return YES;
}

- (void)openAdminInfoGroup {
    if (!_adminTargetURL || _adminTargetURL.length == 0) return;
    NSURL *u = [NSURL URLWithString:_adminTargetURL];
    if (u) {
        [[UIApplication sharedApplication] openURL:u options:@{} completionHandler:nil];
    }
}

// ─────────────── Drag Pan Gesture Handlers ─────────────────────────────────

- (void)handleFloatingPan:(UIPanGestureRecognizer *)p {
    UIWindow *w = [self resolveActiveWindow];
    if (!w) return;
    CGPoint loc = [p locationInView:w];
    if (p.state == UIGestureRecognizerStateBegan) {
        _panStartBtn = loc;
    } else if (p.state == UIGestureRecognizerStateChanged) {
        CGFloat x = MAX(4.0f, MIN(w.bounds.size.width - 52.0f, loc.x - 24.0f));
        CGFloat y = MAX(20.0f, MIN(w.bounds.size.height - 52.0f, loc.y - 24.0f));
        _floatBtn.frame = CGRectMake(x, y, 48, 48);
    }
}

- (void)handleMenuHeaderPan:(UIPanGestureRecognizer *)p {
    UIWindow *w = [self resolveActiveWindow];
    if (!w) return;
    CGPoint loc = [p locationInView:w];
    if (p.state == UIGestureRecognizerStateBegan) {
        _panStartMenu = CGPointMake(loc.x - _menuBox.frame.origin.x,
                                    loc.y - _menuBox.frame.origin.y);
    } else if (p.state == UIGestureRecognizerStateChanged) {
        CGFloat x = MAX(4.0f, MIN(w.bounds.size.width - _menuBox.frame.size.width - 4.0f,
                                 loc.x - _panStartMenu.x));
        CGFloat y = MAX(16.0f, MIN(w.bounds.size.height - _menuBox.frame.size.height - 10.0f,
                                 loc.y - _panStartMenu.y));
        CGRect f = _menuBox.frame;
        f.origin = CGPointMake(x, y);
        _menuBox.frame = f;
    }
}

// ─────────────── WKNavigationDelegate ──────────────────────────────────────

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
    NSURL *u = nav.request.URL;
    NSString *host = u.host.lowercaseString;
    NSString *path = u.path.lowercaseString;
    if (host && [host containsString:@"youtube.com"]) {
        // Tự động chặn và nắn luồng sang /feed/music nếu chạm vào trang chủ gốc
        if (!path || [path isEqualToString:@""] || [path isEqualToString:@"/"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.youtube.com/feed/music"]]];
            });
            dh(WKNavigationActionPolicyCancel);
            return;
        }
    }
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

// ─────────────── Điểm Khởi Chạy Thuần Objective-C++ ───────────────────────

__attribute__((constructor)) static void InitializeAMThanhDylib(void) {
    // Kích hoạt tường lửa bảo mật tầng nhân trước khi khởi động UI
    PHL_EnforceSecuritySanity();
    PHL_StartSecurityWatchdog();

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        [[PHLProtectedAudioManager sharedInstance] initializeFramework];
    });
}
