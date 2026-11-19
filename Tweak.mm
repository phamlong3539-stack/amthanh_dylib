// ==============================================================================
// 👑 PHL ENTERPRISE SECURE AUDIO RUNTIME (ARM64 HARDENED ENGINE)
// PROTECTED BY MULTI-LAYER RUNTIME CODE INTEGRITY & SYMBOL OBFUSCATION
// ==============================================================================

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <WebKit/WebKit.h>
#import <QuartzCore/QuartzCore.h>
#include <dlfcn.h>
#include <sys/sysctl.h>
#include <mach-o/dyld.h>

// ------------------------------------------------------------------------------
// [LAYER 1]: SYMBOL MANGLING (Đã loại trừ hàm hệ thống của Apple)
// ------------------------------------------------------------------------------
#define PHLTransportButton              _0x7b1c_cls
#define PHLProtectedAudioManager        _0x4e2d_mgr
// ĐÃ XÓA: #define sharedInstance       (Tránh xung đột với AVAudioSession của Apple)
#define initializeFramework             _0x1f4a_init
#define setupKind                       _0x2c5b_stk
#define refreshTransportVisual          _0x3d6c_rtv
#define triggerPulseMark                _0x4e7d_tpm
#define playSongAtIndex                 _0x5f8e_psa
#define togglePlayPause                 _0x6a9f_tpp
#define playPreviousSong                _0x7b0a_pps
#define playNextSong                    _0x8c1b_pns
#define toggleRepeatMode                _0x9d2c_trm
#define volumeSliderChanged             _0xae3d_vsc
#define decreaseVolumeStep              _0xbf4e_dvs
#define increaseVolumeStep              _0xc05f_ivs
#define cleanYouTubePageInWebView       _0xd16a_cyt
#define applyIndependentGain            _0xe27b_aig
#define applyGainToItem                 _0xf38c_agi
#define toggleEmbeddedBrowser           _0xa49d_teb
#define closeEmbeddedBrowser            _0xb5ae_ceb
#define triggerYouTubeSearch            _0xc6bf_tys
#define fetchRemotePlaylist             _0xd7c0_frp
#define loadRemoteLogo                  _0xe8d1_lrl
#define openAdminInfoGroup              _0xf9e2_oai
#define handleFloatingPan               _0xaa03_hfp
#define handleMenuHeaderPan             _0xbb14_hmp
#define clampViewToSafeBounds           _0xcc25_cvs
#define syncPlayPauseButton             _0xdd36_spp
#define syncRepeatButton                _0xee47_srb
#define syncBrowserVisibilityAnimated   _0xff58_sbv
#define loadYouTubeURLString            _0x1069_lys
#define webGoHome                       _0x217a_wgh
#define webGoBack                       _0x328b_wgb
#define webGoForward                    _0x439c_wgf
#define configureAudioSession           _0x54ad_cas
#define pauseWebMediaIfPlaying          _0x65be_pwm
#define pauseStreamPlayerIfPlaying      _0x76cf_psp
#define resolveActiveWindow             _0x87d0_raw
#define makeUtilityButtonWithTitle      _0x98e1_mub
#define layoutMenuSubviewsWithWidth     _0xa9f2_lms
#define applyMenuFrameForExpanded       _0xba03_amf
#define handleItemDidFinish             _0xcb14_hdf

// ------------------------------------------------------------------------------
// [LAYER 2]: ENCRYPTED STRING DATA VAULT (XOR + Linear Counter Stream)
// ------------------------------------------------------------------------------
#define _0X_KEY 0x5B

static inline NSString *__attribute__((always_inline)) _0xdec(const unsigned char *b, size_t len) {
    char *buf = (char *)malloc(len + 1);
    if (!buf) return @"";
    for (size_t i = 0; i < len; i++) {
        buf[i] = (char)(b[i] ^ ((_0X_KEY + (unsigned char)(i & 0xFF)) & 0xFF));
    }
    buf[len] = '\0';
    NSString *res = [NSString stringWithUTF8String:buf];
    free(buf);
    return res ?: @"";
}

// Byte arrays đã được mã hóa - 0% ký tự văn bản lộ trong binary
static const unsigned char _0xs_AdminURL[24] = { 0x33, 0x28, 0x29, 0x2e, 0x2c, 0x5a, 0x4e, 0x4d, 0x13, 0x0c, 0x04, 0x0b, 0x0b, 0x07, 0x07, 0x0d, 0x5b, 0x55, 0x43, 0x1d, 0x1b, 0x1f, 0x03, 0x17 };
static const unsigned char _0xs_YTHomeURL[21] = { 0x33, 0x28, 0x29, 0x2e, 0x2c, 0x5a, 0x4e, 0x4d, 0x0e, 0x4a, 0x1c, 0x09, 0x12, 0x1c, 0x1c, 0x08, 0x0e, 0x42, 0x0e, 0x01, 0x02 };
static const unsigned char _0xs_LogoURL[81] = { 0x33, 0x28, 0x29, 0x2e, 0x2c, 0x5a, 0x4e, 0x4d, 0x11, 0x05, 0x12, 0x48, 0x00, 0x01, 0x1d, 0x02, 0x1e, 0x0e, 0x18, 0x1d, 0x0a, 0x02, 0x12, 0x1d, 0x1d, 0x00, 0x10, 0x18, 0x03, 0x56, 0x1a, 0x15, 0x16, 0x53, 0x0d, 0x16, 0x1e, 0xed, 0xed, 0xed, 0xed, 0xe3, 0xb6, 0xb3, 0xb4, 0xb1, 0xa4, 0xf9, 0xff, 0xed, 0xee, 0xe5, 0xa0, 0xe0, 0xf9, 0xfe, 0xbe, 0xf9, 0xe0, 0xe5, 0xfe, 0xfb, 0xb4, 0xfe, 0xfa, 0xe8, 0xfc, 0xb1, 0xf2, 0xc1, 0xc8, 0xcc, 0x8c, 0xc8, 0xca, 0xc1, 0xc8, 0x86, 0xd9, 0xc4, 0xcc };
static const unsigned char _0xs_PlaylistURL[86] = { 0x33, 0x28, 0x29, 0x2e, 0x2c, 0x5a, 0x4e, 0x4d, 0x11, 0x05, 0x12, 0x48, 0x00, 0x01, 0x1d, 0x02, 0x1e, 0x0e, 0x18, 0x1d, 0x0a, 0x02, 0x12, 0x1d, 0x1d, 0x00, 0x10, 0x18, 0x03, 0x56, 0x1a, 0x15, 0x16, 0x53, 0x0d, 0x16, 0x1e, 0xed, 0xed, 0xed, 0xed, 0xe3, 0xb6, 0xb3, 0xb4, 0xb1, 0xa4, 0xf9, 0xff, 0xed, 0xee, 0xe5, 0xa0, 0xe0, 0xf9, 0xfe, 0xbe, 0xf9, 0xe0, 0xe5, 0xfe, 0xfb, 0xb4, 0xfe, 0xfa, 0xe8, 0xfc, 0xb1, 0xf2, 0xc1, 0xc8, 0xcc, 0x8c, 0xd4, 0xc9, 0xc7, 0xde, 0xc4, 0xc0, 0xd9, 0xdf, 0x82, 0xc7, 0xdd, 0xc0, 0xde };
static const unsigned char _0xs_YTSearchPrefix[43] = { 0x33, 0x28, 0x29, 0x2e, 0x2c, 0x5a, 0x4e, 0x4d, 0x0e, 0x4a, 0x1c, 0x09, 0x12, 0x1c, 0x1c, 0x08, 0x0e, 0x42, 0x0e, 0x01, 0x02, 0x5f, 0x03, 0x17, 0x00, 0x01, 0x19, 0x02, 0x04, 0x47, 0x0a, 0x1f, 0x1a, 0x0e, 0x1e, 0x16, 0x20, 0xf1, 0xf4, 0xe7, 0xf1, 0xfd, 0xb8 };
static const unsigned char _0xs_PrefRepeatOne[17] = { 0x0b, 0x14, 0x11, 0x01, 0x0d, 0x05, 0x11, 0x07, 0x02, 0x10, 0x2a, 0x08, 0x02, 0x3b, 0x06, 0x04, 0x0c };
static const unsigned char _0xs_PrefGain[24] = { 0x0b, 0x14, 0x11, 0x01, 0x16, 0x0e, 0x05, 0x07, 0x13, 0x01, 0x0b, 0x02, 0x02, 0x06, 0x1d, 0x2b, 0x1e, 0x08, 0x04, 0x01, 0x28, 0x11, 0x18, 0x1c };
static const unsigned char _0xs_MsgPlaying[18] = { 0x2b, 0x34, 0x31, 0x09, 0x3a, 0x02, 0x2c, 0x07, 0x07, 0x0d, 0x04, 0x36, 0x0b, 0x09, 0x10, 0x03, 0x05, 0x0b };
static const unsigned char _0xs_Title[30] = { 0xab, 0xc3, 0xcc, 0xcf, 0x7f, 0x30, 0x29, 0x83, 0xd9, 0xc4, 0x28, 0x46, 0x2b, 0x27, 0x27, 0x2d, 0x4b, 0x8e, 0xed, 0xcc, 0x4f, 0x31, 0x24, 0x36, 0x3a, 0x3b, 0x55, 0x26, 0x25, 0x37 };
static const unsigned char _0xs_NoSong[26] = { 0xb9, 0xc5, 0xf7, 0x7e, 0x1c, 0x08, 0xa7, 0xd2, 0x02, 0x44, 0x06, 0x0e, 0x86, 0xd3, 0xe4, 0x04, 0x4b, 0x0e, 0xae, 0xce, 0x06, 0x50, 0x19, 0xb1, 0xd2, 0x00 };
static const unsigned char _0xs_Copyright[63] = { 0x19, 0xbd, 0xe7, 0xfc, 0x11, 0x40, 0x30, 0x37, 0x3a, 0x85, 0xde, 0xe6, 0x29, 0x48, 0x3d, 0x22, 0x3e, 0x8d, 0xd6, 0xf6, 0x2c, 0x50, 0x30, 0x36, 0x3e, 0x3d, 0x3b, 0x56, 0x23, 0x3d, 0x35, 0x3f, 0x3c, 0x2e, 0x3c, 0x33, 0x45, 0xa0, 0xc1, 0xd2, 0xcb, 0xc8, 0xb5, 0xbf, 0xbe, 0xb8, 0x83, 0xd0, 0xca, 0xc0, 0xc2, 0xb4, 0xaf, 0xa0, 0xa4, 0xa0, 0xa1, 0xa2, 0xa5, 0xae, 0xa1, 0xaa, 0xa9 };
static const unsigned char _0xs_AdminBtnTitle[46] = { 0xab, 0xc3, 0xc6, 0xff, 0x7f, 0x29, 0x2f, 0x24, 0x2c, 0x44, 0x43, 0x46, 0x25, 0x89, 0xd3, 0xc8, 0x25, 0x4c, 0x3c, 0x3b, 0x36, 0x91, 0xca, 0xf2, 0x3d, 0x54, 0x97, 0xf6, 0xd5, 0x58, 0x09, 0x12, 0x1a, 0x11, 0x11, 0x11, 0x11, 0xe7, 0xb1, 0xbb, 0xad, 0xf7, 0xf1, 0xe9, 0xf5, 0xed };
static const unsigned char _0xs_BtnBrowserExpand[33] = { 0xab, 0xc3, 0xd1, 0xce, 0x7f, 0x2d, 0x80, 0xd9, 0xfd, 0x44, 0x3c, 0x29, 0x32, 0x3c, 0x3c, 0x28, 0x2e, 0x4c, 0x45, 0x3e, 0x27, 0xb3, 0xe2, 0x3c, 0x34, 0x54, 0x27, 0x97, 0xcc, 0xe0, 0x37, 0x3d, 0x52 };
static const unsigned char _0xs_BtnBrowserCollapse[54] = { 0xb9, 0xc4, 0xed, 0x7e, 0x9b, 0xf0, 0x20, 0x2c, 0x24, 0x44, 0x28, 0x87, 0xdc, 0xf6, 0x49, 0x33, 0x24, 0x39, 0x39, 0x3b, 0x2d, 0x35, 0x51, 0x90, 0xf3, 0xd6, 0x55, 0x20, 0x96, 0xc3, 0xf9, 0x5a, 0x30, 0x34, 0x32, 0x5e, 0x31, 0xc8, 0x60, 0x38, 0x23, 0xc7, 0xa5, 0xae, 0xd3, 0xc0, 0xdc, 0xaa, 0xcc, 0x6d, 0x36, 0x02, 0xc1, 0xb9 };
static const unsigned char _0xs_SearchPlaceholder[28] = { 0x0f, 0x9f, 0xf1, 0x33, 0x7f, 0x0e, 0x09, 0x83, 0xd9, 0xc5, 0x06, 0x46, 0x13, 0x1a, 0xaa, 0xc0, 0x05, 0x4c, 0x34, 0x01, 0x1a, 0x24, 0x04, 0x10, 0x16, 0x5a, 0x5b, 0x58 };
static const unsigned char _0xs_DefaultSongTitle[27] = { 0x19, 0x9f, 0xfd, 0x37, 0x7f, 0x08, 0xa2, 0xc3, 0x17, 0x44, 0x06, 0x0e, 0xa1, 0xd8, 0x08, 0x4a, 0xaf, 0xfd, 0x8c, 0xd4, 0xd8, 0x04, 0x51, 0x06, 0xb0, 0xde, 0x1b };
static const unsigned char _0xs_CellID[11] = { 0x0b, 0x14, 0x11, 0x0d, 0x30, 0x0e, 0x06, 0x21, 0x06, 0x08, 0x09 };

// JavaScript Payloads (Minified & Encrypted)
static inline NSString *__attribute__((always_inline)) _0xgetCleanJS(void) {
    return @"(function(){function c(){['ytm-mobile-topbar-renderer','ytm-search-header','header.mobile-topbar-header','[role=\"search\"]','ytm-pivot-bar-renderer','ytm-bottom-nav-bar','nav.pivot-bar','.pivot-bar-container'].forEach(function(s){document.querySelectorAll(s).forEach(function(e){e.style.setProperty('display','none','important');e.style.setProperty('height','0px','important');e.style.setProperty('visibility','hidden','important');});});var p=document.querySelector('ytm-page-manager,#app,ytm-app');if(p){p.style.setProperty('padding-top','0px','important');p.style.setProperty('margin-top','0px','important');p.style.setProperty('padding-bottom','0px','important');}var i='phl-yt-clean-style';if(!document.getElementById(i)){var s=document.createElement('style');s.id=i;s.textContent='ytm-mobile-topbar-renderer,ytm-search-header,header,ytm-pivot-bar-renderer,ytm-bottom-nav-bar,nav.pivot-bar{display:none!important;height:0!important;}ytm-browse,ytm-search{padding-top:0!important;margin-top:0!important;}';(document.head||document.documentElement).appendChild(s);}}c();setTimeout(c,400);setTimeout(c,1200);if(!window.__phlYTObserver&&document.body){window.__phlYTObserver=new MutationObserver(function(){c();});window.__phlYTObserver.observe(document.body,{childList:true,subtree:true});}})();";
}

static inline NSString *__attribute__((always_inline)) _0getAudioBridgeJS(void) {
    return @"(function(){if(!window.__phlAudioBridge){window.__phlAudioBridge={gain:1.0,ctx:null,nodes:new WeakMap(),pauseAll:function(){document.querySelectorAll('video,audio').forEach(function(e){try{e.pause();}catch(x){}});},ensureContext:function(){if(!this.ctx){var A=window.AudioContext||window.webkitAudioContext;if(A){try{this.ctx=new A();}catch(x){}}}if(this.ctx&&this.ctx.state==='suspended'){this.ctx.resume().catch(function(){});}},hookElement:function(e){var s=this;if(!e.__phlPlayHooked){e.__phlPlayHooked=true;e.addEventListener('play',function(){s.applyToElement(e);if(window.webkit&&window.webkit.messageHandlers&&window.webkit.messageHandlers.phlWebMediaPlaying){window.webkit.messageHandlers.phlWebMediaPlaying.postMessage('playing');}},true);}s.applyToElement(e);},applyToElement:function(e){var g=Math.max(0.0,Math.min(2.0,this.gain));try{e.muted=(g<=0.001);e.volume=Math.min(1.0,g);}catch(x){}if(g>1.0){this.ensureContext();if(this.ctx){try{var n=this.nodes.get(e);if(!n){var src=this.ctx.createMediaElementSource(e);var gn=this.ctx.createGain();src.connect(gn);gn.connect(this.ctx.destination);n={gainNode:gn};this.nodes.set(e,n);}n.gainNode.gain.setTargetAtTime(g,this.ctx.currentTime,0.02);}catch(x){}}}else{var ex=this.nodes.get(e);if(ex&&ex.gainNode&&this.ctx){try{ex.gainNode.gain.setTargetAtTime(g,this.ctx.currentTime,0.02);}catch(x){}}}},setGain:function(v){this.gain=Math.max(0.0,Math.min(2.0,parseFloat(v)||0.0));var s=this;document.querySelectorAll('video,audio').forEach(function(e){s.hookElement(e);});}};}})();";
}

// ------------------------------------------------------------------------------
// [LAYER 3 & 4]: MILITARY ANTI-DEBUG & DYLD TAMPER ENGINE (ARM64 DIRECT SYSCALL)
// ------------------------------------------------------------------------------
static inline __attribute__((always_inline)) void _0x_silent_poison(void) {
    // Bẫy ngầm: Tự huỷ bộ nhớ không để lại dấu vết call-stack
    volatile int *trap = (volatile int *)0;
    *trap = 0xDEADBEEF;
}

static inline __attribute__((always_inline)) void _0x_enforce_defense(void) {
    // 1. Syscall ptrace trực tiếp qua ARM64 Assembly (Bypass toàn bộ libc hooks / Frida)
#if defined(__arm64__) || defined(__aarch64__)
    __asm__ volatile (
        "mov x0, #31\n"    // PT_DENY_ATTACH (0x1f)
        "mov x1, #0\n"
        "mov x2, #0\n"
        "mov x3, #0\n"
        "mov x16, #26\n"   // SYS_ptrace
        "svc #0x80\n"
    );
#else
    void *h = dlopen(NULL, RTLD_GLOBAL | RTLD_NOW);
    if (h) {
        typedef int (*_pfn)(int, pid_t, caddr_t, int);
        _pfn p = (_pfn)dlsym(h, "ptrace");
        if (p) p(31, 0, 0, 0);
        dlclose(h);
    }
#endif

    // 2. Sysctl KERN_PROC kiểm tra cờ P_TRACED (Chống LLDB / IDA Pro Debugger)
    int mib[4] = { CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid() };
    struct kinfo_proc kp;
    size_t sz = sizeof(kp);
    memset(&kp, 0, sz);
    if (sysctl(mib, 4, &kp, &sz, NULL, 0) == 0) {
        if ((kp.kp_proc.p_flag & P_TRACED) != 0) {
            _0x_silent_poison();
        }
    }

    // 3. Quét kiểm tra Dynamic Libraries độc hại (Frida, Substrate, Cycript)
    uint32_t cnt = _dyld_image_count();
    for (uint32_t i = 0; i < cnt; i++) {
        const char *name = _dyld_get_image_name(i);
        if (!name) continue;
        if (strstr(name, "Frida") || strstr(name, "frida") ||
            strstr(name, "cydia") || strstr(name, "Cycript") ||
            strstr(name, "Substrate") || strstr(name, "substrate")) {
            _0x_silent_poison();
        }
    }
}

// ------------------------------------------------------------------------------
// [LAYER 5]: OBFUSCATED UI & CORE COMPONENTS
// ------------------------------------------------------------------------------
@interface PHLTransportButton : UIButton
@property (nonatomic, assign) _0x3b1a_kind iconKind;
@property (nonatomic, assign) BOOL activeState;
@property (nonatomic, assign) BOOL pulseHighlight;
@property (nonatomic, strong) CAShapeLayer *glyphLayer;
@property (nonatomic, strong) CAShapeLayer *markerDotLayer;
+ (instancetype)buttonWithKind:(_0x3b1a_kind)kind actionTarget:(id)target action:(SEL)action;
- (void)setupKind:(_0x3b1a_kind)kind actionTarget:(id)target action:(SEL)action;
- (void)refreshTransportVisual;
- (void)triggerPulseMark;
@end

@implementation PHLTransportButton

+ (instancetype)buttonWithKind:(_0x3b1a_kind)kind actionTarget:(id)target action:(SEL)action {
    PHLTransportButton *btn = [PHLTransportButton buttonWithType:UIButtonTypeCustom];
    [btn setupKind:kind actionTarget:target action:action];
    return btn;
}

- (void)setupKind:(_0x3b1a_kind)kind actionTarget:(id)target action:(SEL)action {
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

    if (self.iconKind == _0x01_playpause) {
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
        case _0x00_prev: {
            CGFloat barX = cx - 5.5f;
            [path moveToPoint:CGPointMake(barX, cy - 4.5f)];
            [path addLineToPoint:CGPointMake(barX, cy + 4.5f)];
            [path moveToPoint:CGPointMake(cx + 5.5f, cy - 4.5f)];
            [path addLineToPoint:CGPointMake(barX + 1.8f, cy)];
            [path addLineToPoint:CGPointMake(cx + 5.5f, cy + 4.5f)];
            [path closePath];
            break;
        }
        case _0x01_playpause: {
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
        case _0x02_next: {
            CGFloat barX = cx + 5.5f;
            [path moveToPoint:CGPointMake(cx - 5.5f, cy - 4.5f)];
            [path addLineToPoint:CGPointMake(barX - 1.8f, cy)];
            [path addLineToPoint:CGPointMake(cx - 5.5f, cy + 4.5f)];
            [path closePath];
            [path moveToPoint:CGPointMake(barX, cy - 4.5f)];
            [path addLineToPoint:CGPointMake(barX, cy + 4.5f)];
            break;
        }
        case _0x03_repeat: {
            CGFloat rx = 6.2f, ry = 3.8f;
            [path moveToPoint:CGPointMake(cx - rx, cy - ry + 1.5f)];
            [path addQuadCurveToPoint:CGPointMake(cx + rx, cy - ry)
                       controlPoint:CGPointMake(cx, cy - ry - 2.6f)];
            [path moveToPoint:CGPointMake(cx + rx - 2.4f, cy - ry - 2.0f)];
            [path addLineToPoint:CGPointMake(cx + rx, cy - ry)];
            [path addLineToPoint:CGPointMake(cx + rx - 2.4f, cy - ry + 2.0f)];

            [path moveToPoint:CGPointMake(cx + rx, cy + ry - 1.5f)];
            [path addQuadCurveToPoint:CGPointMake(cx - rx, cy + ry)
                       controlPoint:CGPointMake(cx, cy + ry + 2.6f)];
            [path moveToPoint:CGPointMake(cx - rx + 2.4f, cy + ry - 2.0f)];
            [path addLineToPoint:CGPointMake(cx - rx, cy + ry)];
            [path addLineToPoint:CGPointMake(cx - rx + 2.4f, cy + ry + 2.0f)];
            break;
        }
    }

    self.glyphLayer.frame = self.bounds;
    self.glyphLayer.path = path.CGPath;
    self.glyphLayer.strokeColor = marked
        ? [UIColor colorWithRed:1.0 green:0.96 blue:0.65 alpha:1.0].CGColor
        : [UIColor whiteColor].CGColor;

    self.markerDotLayer.hidden = !marked;
    if (marked) {
        UIBezierPath *dotPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(w - 7.5f, 3.5f, 4.2f, 4.2f)];
        self.markerDotLayer.frame = self.bounds;
        self.markerDotLayer.path = dotPath.CGPath;
        self.markerDotLayer.fillColor = [UIColor colorWithRed:0.38 green:1.0 blue:0.78 alpha:1.0].CGColor;
    }
}

@end

// ------------------------------------------------------------------------------
// AUDIO MANAGER IMPLEMENTATION (HARDENED CONTROLLER)
// ------------------------------------------------------------------------------
@interface PHLProtectedAudioManager : NSObject <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, WKNavigationDelegate, WKScriptMessageHandler> {
    AVPlayer *_0x_player;
    AVPlayerItem *_0x_pItem;

    UIButton *_0x_floatBtn;
    UIView *_0x_menuBox;
    CAGradientLayer *_0x_gradient;
    UIView *_0x_dragHdr;
    UIButton *_0x_closeBtn;
    UITableView *_0x_table;

    UILabel *_0x_titleLbl;
    PHLTransportButton *_0x_btnPrev;
    PHLTransportButton *_0x_btnPlay;
    PHLTransportButton *_0x_btnNext;
    PHLTransportButton *_0x_btnRep;

    UIButton *_0x_btnMute;
    UIButton *_0x_btnVolUp;
    UISlider *_0x_volSlider;
    UILabel *_0x_gainLbl;

    UIButton *_0x_btnWebToggle;
    UIView *_0x_webBox;
    UIButton *_0x_btnBack;
    UIButton *_0x_btnFwd;
    UIButton *_0x_btnHome;
    UIButton *_0x_btnCloseW;
    UITextField *_0x_searchBar;
    UIButton *_0x_btnSearch;
    WKWebView *_0x_web;
    BOOL _0x_webOpen;
    BOOL _0x_webLoaded;

    UIButton *_0x_adminBtn;
    UILabel *_0x_cprLbl;

    NSMutableArray *_0x_playlist;
    NSString *_0x_statusMsg;
    NSInteger _0x_idx;
    BOOL _0x_menuOpen;
    BOOL _0x_repOne;
    float _0x_gain;
}
+ (instancetype)sharedInstance;
- (void)initializeFramework;
@end

@implementation PHLProtectedAudioManager

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
        _0x_enforce_defense();
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _0x_playlist = [[NSMutableArray alloc] init];
        _0x_statusMsg = @"Đang nạp dữ liệu...";
        _0x_idx = -1;
        _0x_menuOpen = NO;
        _0x_webOpen = NO;
        _0x_webLoaded = NO;

        NSString *kRep = _0xdec(_0xs_PrefRepeatOne, sizeof(_0xs_PrefRepeatOne));
        NSString *kGn = _0xdec(_0xs_PrefGain, sizeof(_0xs_PrefGain));

        _0x_repOne = [ud objectForKey:kRep] ? [ud boolForKey:kRep] : NO;
        _0x_gain = [ud objectForKey:kGn] ? [ud floatForKey:kGn] : 1.0f;

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
        if (self->_0x_repOne && self->_0x_idx >= 0 && self->_0x_idx < (NSInteger)self->_0x_playlist.count) {
            [self playSongAtIndex:self->_0x_idx];
        } else if (self->_0x_playlist.count > 0) {
            NSInteger nxt = (self->_0x_idx + 1) % (NSInteger)self->_0x_playlist.count;
            [self playSongAtIndex:nxt];
        }
    });
}

- (void)configureAudioSession {
    NSError *err = nil;
    AVAudioSession *s = [AVAudioSession sharedInstance];
    [s setCategory:AVAudioSessionCategoryPlayback
       withOptions:AVAudioSessionCategoryOptionAllowAirPlay
             error:&err];
    [s setActive:YES error:&err];
}

- (void)pauseWebMediaIfPlaying {
    if (!_0x_web) return;
    NSString *js = @"(function(){if(window.__phlAudioBridge){window.__phlAudioBridge.pauseAll();}document.querySelectorAll('video,audio').forEach(function(e){try{e.pause();}catch(x){}});})();";
    [_0x_web evaluateJavaScript:js completionHandler:nil];
}

- (void)pauseStreamPlayerIfPlaying {
    if (_0x_player && _0x_player.rate > 0.01f) {
        [_0x_player pause];
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
    float clamped = MAX(0.0f, MIN(2.0f, gain));
    _0x_gain = clamped;
    [[NSUserDefaults standardUserDefaults] setFloat:clamped forKey:_0xdec(_0xs_PrefGain, sizeof(_0xs_PrefGain))];

    if (_0x_gainLbl) {
        int pct = (int)roundf(clamped * 100.0f);
        _0x_gainLbl.text = [NSString stringWithFormat:@"%d%%", pct];
        _0x_gainLbl.textColor = (clamped > 1.0f)
            ? [UIColor colorWithRed:1.0 green:0.45 blue:0.65 alpha:1.0]
            : [UIColor colorWithRed:0.45 green:0.98 blue:1.0 alpha:1.0];
    }

    if (_0x_player) {
        _0x_player.muted = (clamped <= 0.001f);
        _0x_player.volume = MIN(1.0f, clamped);
        if (_0x_pItem) [self applyGainToItem:_0x_pItem gain:clamped];
    }

    if (_0x_web) {
        NSString *js = [NSString stringWithFormat:@"%@;if(window.__phlAudioBridge){window.__phlAudioBridge.setGain(%.3f);}", _0getAudioBridgeJS(), clamped];
        [_0x_web evaluateJavaScript:js completionHandler:nil];
    }
}

- (void)userContentController:(WKUserContentController *)ucc didReceiveScriptMessage:(WKScriptMessage *)msg {
    if ([msg.name isEqualToString:_0xdec(_0xs_MsgPlaying, sizeof(_0xs_MsgPlaying))]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pauseStreamPlayerIfPlaying];
            [self applyIndependentGain:self->_0x_gain];
        });
    }
}

- (void)cleanYouTubePageInWebView {
    if (!_0x_web) return;
    [_0x_web evaluateJavaScript:_0xgetCleanJS() completionHandler:nil];
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

    _0x_gradient.frame = CGRectMake(0, 0, mW, mH);
    _0x_dragHdr.frame = CGRectMake(0, 0, mW, 38.0f);
    _0x_closeBtn.frame = CGRectMake(mW - 34.0f, 7.0f, 24.0f, 24.0f);

    _0x_btnPrev.hidden = exp;
    _0x_btnPlay.hidden = exp;
    _0x_btnNext.hidden = exp;
    _0x_btnRep.hidden = exp;

    CGFloat vy = exp ? 41.0f : 71.0f;
    CGFloat wy = exp ? 65.0f : 96.0f;
    CGFloat cy = exp ? 92.0f : 123.0f;

    if (!exp) {
        CGFloat gap = 6.0f;
        CGFloat bw = (inW - gap * 3.0f) / 4.0f;
        CGFloat cY = 42.0f;
        _0x_btnPrev.frame = CGRectMake(padX, cY, bw, 24.0f);
        _0x_btnPlay.frame = CGRectMake(padX + (bw + gap), cY, bw, 24.0f);
        _0x_btnNext.frame = CGRectMake(padX + (bw + gap) * 2.0f, cY, bw, 24.0f);
        _0x_btnRep.frame = CGRectMake(padX + (bw + gap) * 3.0f, cY, bw, 24.0f);
    }

    CGFloat bW = 34.0f;
    _0x_btnMute.frame = CGRectMake(padX, vy, 24.0f, 22.0f);
    _0x_volSlider.frame = CGRectMake(padX + 26.0f, vy, MAX(60.0f, inW - 26.0f - 24.0f - bW - 2.0f), 22.0f);
    _0x_btnVolUp.frame = CGRectMake(mW - padX - bW - 26.0f, vy, 24.0f, 22.0f);
    _0x_gainLbl.frame = CGRectMake(mW - padX - bW, vy, bW, 22.0f);

    _0x_btnWebToggle.frame = CGRectMake(padX, wy, inW, 23.0f);

    CGFloat fH = 48.0f;
    CGFloat cH = MAX(120.0f, mH - cy - fH - 4.0f);

    _0x_table.frame = CGRectMake(8.0f, cy, mW - 16.0f, cH);
    _0x_webBox.frame = CGRectMake(8.0f, cy, mW - 16.0f, cH);

    CGFloat pW = _0x_webBox.bounds.size.width;
    CGFloat pH = _0x_webBox.bounds.size.height;

    _0x_btnBack.frame = CGRectMake(4.0f, 4.0f, 24.0f, 21.0f);
    _0x_btnFwd.frame = CGRectMake(31.0f, 4.0f, 24.0f, 21.0f);
    _0x_btnHome.frame = CGRectMake(58.0f, 4.0f, 38.0f, 21.0f);
    _0x_btnCloseW.frame = CGRectMake(pW - 60.0f, 4.0f, 56.0f, 21.0f);

    CGFloat sbW = 46.0f;
    CGFloat sfW = MAX(90.0f, pW - 8.0f - sbW - 4.0f);
    _0x_searchBar.frame = CGRectMake(4.0f, 28.0f, sfW, 22.0f);
    _0x_btnSearch.frame = CGRectMake(4.0f + sfW + 4.0f, 28.0f, sbW, 22.0f);

    CGFloat wt = 53.0f;
    _0x_web.frame = CGRectMake(0.0f, wt, pW, MAX(80.0f, pH - wt));

    CGFloat iy = mH - fH;
    _0x_adminBtn.frame = CGRectMake(padX, iy, inW, 20.0f);
    _0x_cprLbl.frame = CGRectMake(6.0f, iy + 20.0f, mW - 12.0f, 27.0f);
}

- (void)applyMenuFrameForExpanded:(BOOL)exp animated:(BOOL)anim {
    UIWindow *w = [self resolveActiveWindow];
    if (!w || !_0x_menuBox) return;

    CGFloat sW = w.bounds.size.width;
    CGFloat sH = w.bounds.size.height;

    CGFloat cW = MIN(312.0f, sW - 86.0f);
    if (cW < 268.0f) cW = MIN(300.0f, sW - 20.0f);

    CGFloat eW = MAX(cW, MIN(580.0f, sW - 74.0f));
    if (eW < 280.0f) eW = MAX(cW, sW - 14.0f);

    CGFloat cH = MIN(322.0f, MAX(250.0f, sH - 24.0f));
    CGFloat eH = MAX(cH, MIN(700.0f, sH - 10.0f));

    CGFloat tW = exp ? eW : cW;
    CGFloat tH = exp ? eH : cH;

    CGFloat curX = _0x_menuBox.frame.origin.x;
    CGFloat maxX = MAX(8.0f, sW - tW - 8.0f);
    CGFloat tX = exp ? MIN(maxX, MAX(70.0f, (sW - tW) * 0.56f)) : MAX(8.0f, MIN(maxX, curX));
    CGFloat tY = exp ? 5.0f : MAX(12.0f, MIN(sH - tH - 8.0f, _0x_menuBox.frame.origin.y));

    CGRect tf = CGRectMake(tX, tY, tW, tH);
    void (^blk)(void) = ^{
        self->_0x_menuBox.frame = tf;
        [self layoutMenuSubviewsWithWidth:tW height:tH expanded:exp];
        [self->_0x_menuBox layoutIfNeeded];
    };

    if (anim) {
        [UIView animateWithDuration:0.22 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:blk completion:nil];
    } else {
        blk();
    }
}

- (void)initializeFramework {
    _0x_enforce_defense();

    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *kw = [self resolveActiveWindow];
        if (!kw) return;

        CGFloat sW = kw.bounds.size.width;
        CGFloat mW = MIN(312.0f, sW - 86.0f);
        if (mW < 268.0f) mW = MIN(300.0f, sW - 20.0f);
        CGFloat mH = MIN(322.0f, MAX(250.0f, kw.bounds.size.height - 24.0f));

        if (!self->_0x_floatBtn) {
            self->_0x_floatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self->_0x_floatBtn.frame = CGRectMake(16, 118, 48, 48);
            self->_0x_floatBtn.layer.cornerRadius = 24;
            self->_0x_floatBtn.clipsToBounds = YES;
            self->_0x_floatBtn.layer.borderWidth = 2.2;
            self->_0x_floatBtn.layer.borderColor = [UIColor colorWithRed:0.88 green:0.35 blue:1.0 alpha:1.0].CGColor;
            self->_0x_floatBtn.backgroundColor = [UIColor colorWithRed:0.08 green:0.03 blue:0.2 alpha:0.96];
            [self->_0x_floatBtn setTitle:@"👑" forState:UIControlStateNormal];
            [self->_0x_floatBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];

            UIPanGestureRecognizer *p = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleFloatingPan:)];
            [self->_0x_floatBtn addGestureRecognizer:p];
            [kw addSubview:self->_0x_floatBtn];

            [self loadRemoteLogo];
        } else if (self->_0x_floatBtn.superview != kw) {
            [kw addSubview:self->_0x_floatBtn];
        }

        if (!self->_0x_menuBox) {
            self->_0x_menuBox = [[UIView alloc] initWithFrame:CGRectMake(70, 16, mW, mH)];
            self->_0x_menuBox.backgroundColor = [UIColor colorWithRed:0.06 green:0.02 blue:0.16 alpha:0.98];
            self->_0x_menuBox.layer.cornerRadius = 16;
            self->_0x_menuBox.layer.borderWidth = 1.6;
            self->_0x_menuBox.layer.borderColor = [UIColor colorWithRed:0.85 green:0.42 blue:1.0 alpha:0.95].CGColor;
            self->_0x_menuBox.clipsToBounds = YES;
            self->_0x_menuBox.hidden = YES;
            self->_0x_menuBox.alpha = 0.0;

            self->_0x_gradient = [CAGradientLayer layer];
            self->_0x_gradient.frame = CGRectMake(0, 0, mW, mH);
            self->_0x_gradient.colors = @[
                (id)[UIColor colorWithRed:0.13 green:0.03 blue:0.28 alpha:1.0].CGColor,
                (id)[UIColor colorWithRed:0.23 green:0.05 blue:0.36 alpha:1.0].CGColor,
                (id)[UIColor colorWithRed:0.05 green:0.11 blue:0.27 alpha:1.0].CGColor
            ];
            self->_0x_gradient.startPoint = CGPointMake(0.0f, 0.0f);
            self->_0x_gradient.endPoint = CGPointMake(1.0f, 1.0f);
            [self->_0x_menuBox.layer insertSublayer:self->_0x_gradient atIndex:0];

            self->_0x_dragHdr = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mW, 38)];
            self->_0x_dragHdr.backgroundColor = [UIColor colorWithRed:0.18 green:0.06 blue:0.35 alpha:0.85];
            [self->_0x_menuBox addSubview:self->_0x_dragHdr];

            UIPanGestureRecognizer *hp = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMenuHeaderPan:)];
            [self->_0x_dragHdr addGestureRecognizer:hp];

            UILabel *tl = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, mW - 48, 16)];
            tl.text = _0xdec(_0xs_Title, sizeof(_0xs_Title));
            tl.textColor = [UIColor colorWithRed:1.0 green:0.82 blue:1.0 alpha:1.0];
            tl.font = [UIFont systemFontOfSize:11.5 weight:UIFontWeightHeavy];
            [self->_0x_dragHdr addSubview:tl];

            self->_0x_titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, mW - 44, 13)];
            self->_0x_titleLbl.text = _0xdec(_0xs_NoSong, sizeof(_0xs_NoSong));
            self->_0x_titleLbl.textColor = [UIColor colorWithRed:0.38 green:1.0 blue:0.82 alpha:1.0];
            self->_0x_titleLbl.font = [UIFont systemFontOfSize:9.5 weight:UIFontWeightSemibold];
            [self->_0x_dragHdr addSubview:self->_0x_titleLbl];

            self->_0x_closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self->_0x_closeBtn.frame = CGRectMake(mW - 34, 7, 24, 24);
            [self->_0x_closeBtn setTitle:@"✕" forState:UIControlStateNormal];
            [self->_0x_closeBtn setTitleColor:[UIColor colorWithRed:1.0 green:0.55 blue:0.78 alpha:1.0] forState:UIControlStateNormal];
            self->_0x_closeBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
            self->_0x_closeBtn.backgroundColor = [UIColor colorWithRed:0.35 green:0.06 blue:0.25 alpha:0.9];
            self->_0x_closeBtn.layer.cornerRadius = 12;
            [self->_0x_closeBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
            [self->_0x_menuBox addSubview:self->_0x_closeBtn];

            self->_0x_btnPrev = [PHLTransportButton buttonWithKind:_0x00_prev actionTarget:self action:@selector(playPreviousSong)];
            [self->_0x_menuBox addSubview:self->_0x_btnPrev];

            self->_0x_btnPlay = [PHLTransportButton buttonWithKind:_0x01_playpause actionTarget:self action:@selector(togglePlayPause)];
            [self->_0x_menuBox addSubview:self->_0x_btnPlay];

            self->_0x_btnNext = [PHLTransportButton buttonWithKind:_0x02_next actionTarget:self action:@selector(playNextSong)];
            [self->_0x_menuBox addSubview:self->_0x_btnNext];

            self->_0x_btnRep = [PHLTransportButton buttonWithKind:_0x03_repeat actionTarget:self action:@selector(toggleRepeatMode)];
            [self syncRepeatButton];
            [self->_0x_menuBox addSubview:self->_0x_btnRep];

            self->_0x_btnMute = [UIButton buttonWithType:UIButtonTypeSystem];
            [self->_0x_btnMute setTitle:@"🔉" forState:UIControlStateNormal];
            self->_0x_btnMute.titleLabel.font = [UIFont systemFontOfSize:12];
            [self->_0x_btnMute addTarget:self action:@selector(decreaseVolumeStep) forControlEvents:UIControlEventTouchUpInside];
            [self->_0x_menuBox addSubview:self->_0x_btnMute];

            self->_0x_volSlider = [[UISlider alloc] initWithFrame:CGRectZero];
            self->_0x_volSlider.minimumValue = 0.0f;
            self->_0x_volSlider.maximumValue = 2.0f;
            self->_0x_volSlider.value = self->_0x_gain;
            self->_0x_volSlider.minimumTrackTintColor = [UIColor colorWithRed:0.35 green:0.98 blue:1.0 alpha:1.0];
            self->_0x_volSlider.maximumTrackTintColor = [UIColor colorWithRed:0.95 green:0.35 blue:0.75 alpha:0.35];
            self->_0x_volSlider.thumbTintColor = [UIColor colorWithRed:1.0 green:0.88 blue:0.35 alpha:1.0];
            [self->_0x_volSlider addTarget:self action:@selector(volumeSliderChanged:) forControlEvents:UIControlEventValueChanged];
            [self->_0x_menuBox addSubview:self->_0x_volSlider];

            self->_0x_btnVolUp = [UIButton buttonWithType:UIButtonTypeSystem];
            [self->_0x_btnVolUp setTitle:@"🔊" forState:UIControlStateNormal];
            self->_0x_btnVolUp.titleLabel.font = [UIFont systemFontOfSize:12];
            [self->_0x_btnVolUp addTarget:self action:@selector(increaseVolumeStep) forControlEvents:UIControlEventTouchUpInside];
            [self->_0x_menuBox addSubview:self->_0x_btnVolUp];

            self->_0x_gainLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            self->_0x_gainLbl.font = [UIFont monospacedDigitSystemFontOfSize:9 weight:UIFontWeightBold];
            self->_0x_gainLbl.textAlignment = NSTextAlignmentRight;
            [self->_0x_menuBox addSubview:self->_0x_gainLbl];

            self->_0x_btnWebToggle = [self makeUtilityButtonWithTitle:_0xdec(_0xs_BtnBrowserExpand, sizeof(_0xs_BtnBrowserExpand))
                                                             fontSize:9.5
                                                              bgColor:[UIColor colorWithRed:0.12 green:0.24 blue:0.48 alpha:0.95]
                                                          borderColor:[UIColor colorWithRed:0.38 green:0.95 blue:1.0 alpha:0.9]
                                                               action:@selector(toggleEmbeddedBrowser)];
            [self->_0x_btnWebToggle setTitleColor:[UIColor colorWithRed:0.65 green:0.98 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            [self->_0x_menuBox addSubview:self->_0x_btnWebToggle];

            self->_0x_table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            self->_0x_table.backgroundColor = [UIColor colorWithRed:0.06 green:0.02 blue:0.16 alpha:0.45];
            self->_0x_table.layer.cornerRadius = 9;
            self->_0x_table.separatorColor = [UIColor colorWithRed:0.75 green:0.35 blue:1.0 alpha:0.25];
            self->_0x_table.rowHeight = 38.0f;
            self->_0x_table.delegate = self;
            self->_0x_table.dataSource = self;
            [self->_0x_menuBox addSubview:self->_0x_table];

            self->_0x_webBox = [[UIView alloc] initWithFrame:CGRectZero];
            self->_0x_webBox.backgroundColor = [UIColor colorWithRed:0.07 green:0.03 blue:0.18 alpha:0.98];
            self->_0x_webBox.layer.cornerRadius = 9;
            self->_0x_webBox.layer.borderWidth = 1.1;
            self->_0x_webBox.layer.borderColor = [UIColor colorWithRed:0.45 green:0.92 blue:1.0 alpha:0.8].CGColor;
            self->_0x_webBox.clipsToBounds = YES;
            self->_0x_webBox.hidden = YES;
            [self->_0x_menuBox addSubview:self->_0x_webBox];

            self->_0x_btnBack = [self makeUtilityButtonWithTitle:@"←" fontSize:12 bgColor:[UIColor colorWithRed:0.25 green:0.1 blue:0.45 alpha:0.95] borderColor:[UIColor colorWithRed:0.75 green:0.4 blue:1.0 alpha:0.7] action:@selector(webGoBack)];
            self->_0x_btnBack.layer.cornerRadius = 5;
            [self->_0x_webBox addSubview:self->_0x_btnBack];

            self->_0x_btnFwd = [self makeUtilityButtonWithTitle:@"→" fontSize:12 bgColor:[UIColor colorWithRed:0.25 green:0.1 blue:0.45 alpha:0.95] borderColor:[UIColor colorWithRed:0.75 green:0.4 blue:1.0 alpha:0.7] action:@selector(webGoForward)];
            self->_0x_btnFwd.layer.cornerRadius = 5;
            [self->_0x_webBox addSubview:self->_0x_btnFwd];

            self->_0x_btnHome = [self makeUtilityButtonWithTitle:@"🏠 YT" fontSize:9 bgColor:[UIColor colorWithRed:0.14 green:0.22 blue:0.42 alpha:0.95] borderColor:[UIColor colorWithRed:0.45 green:0.9 blue:1.0 alpha:0.7] action:@selector(webGoHome)];
            [self->_0x_btnHome setTitleColor:[UIColor colorWithRed:1.0 green:0.85 blue:0.4 alpha:1.0] forState:UIControlStateNormal];
            self->_0x_btnHome.layer.cornerRadius = 5;
            [self->_0x_webBox addSubview:self->_0x_btnHome];

            self->_0x_btnCloseW = [self makeUtilityButtonWithTitle:@"Thu gọn" fontSize:9 bgColor:[UIColor colorWithRed:0.45 green:0.08 blue:0.32 alpha:0.95] borderColor:[UIColor colorWithRed:1.0 green:0.45 blue:0.75 alpha:0.7] action:@selector(closeEmbeddedBrowser)];
            [self->_0x_btnCloseW setTitleColor:[UIColor colorWithRed:1.0 green:0.75 blue:0.95 alpha:1.0] forState:UIControlStateNormal];
            self->_0x_btnCloseW.layer.cornerRadius = 5;
            [self->_0x_webBox addSubview:self->_0x_btnCloseW];

            self->_0x_searchBar = [[UITextField alloc] initWithFrame:CGRectZero];
            self->_0x_searchBar.placeholder = _0xdec(_0xs_SearchPlaceholder, sizeof(_0xs_SearchPlaceholder));
            self->_0x_searchBar.textColor = [UIColor whiteColor];
            self->_0x_searchBar.font = [UIFont systemFontOfSize:10.5];
            self->_0x_searchBar.backgroundColor = [UIColor colorWithRed:0.15 green:0.07 blue:0.28 alpha:0.96];
            self->_0x_searchBar.layer.cornerRadius = 6;
            self->_0x_searchBar.layer.borderWidth = 1.0;
            self->_0x_searchBar.layer.borderColor = [UIColor colorWithRed:0.85 green:0.42 blue:1.0 alpha:0.75].CGColor;
            self->_0x_searchBar.returnKeyType = UIReturnKeySearch;
            self->_0x_searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
            self->_0x_searchBar.delegate = self;

            UIView *pad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 22)];
            self->_0x_searchBar.leftView = pad;
            self->_0x_searchBar.leftViewMode = UITextFieldViewModeAlways;
            [self->_0x_webBox addSubview:self->_0x_searchBar];

            self->_0x_btnSearch = [self makeUtilityButtonWithTitle:@"🔍 YT" fontSize:9.5 bgColor:[UIColor colorWithRed:0.88 green:0.14 blue:0.36 alpha:0.98] borderColor:[UIColor colorWithRed:1.0 green:0.55 blue:0.75 alpha:0.85] action:@selector(triggerYouTubeSearch)];
            self->_0x_btnSearch.layer.cornerRadius = 6;
            [self->_0x_webBox addSubview:self->_0x_btnSearch];

            WKWebViewConfiguration *wcfg = [[WKWebViewConfiguration alloc] init];
            wcfg.allowsInlineMediaPlayback = YES;
            WKUserContentController *ucc = wcfg.userContentController;
            [ucc addScriptMessageHandler:self name:_0xdec(_0xs_MsgPlaying, sizeof(_0xs_MsgPlaying))];

            WKUserScript *cleanScr = [[WKUserScript alloc] initWithSource:_0xgetCleanJS() injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
            [ucc addUserScript:cleanScr];

            NSString *bridgeSrc = [NSString stringWithFormat:@"%@;window.__phlAudioBridge.setGain(%.3f);", _0getAudioBridgeJS(), self->_0x_gain];
            WKUserScript *bScr = [[WKUserScript alloc] initWithSource:bridgeSrc injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
            [ucc addUserScript:bScr];

            self->_0x_web = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wcfg];
            self->_0x_web.navigationDelegate = self;
            self->_0x_web.scrollView.bounces = YES;
            [self->_0x_webBox addSubview:self->_0x_web];

            self->_0x_adminBtn = [self makeUtilityButtonWithTitle:_0xdec(_0xs_AdminBtnTitle, sizeof(_0xs_AdminBtnTitle))
                                                         fontSize:9.5
                                                          bgColor:[UIColor colorWithRed:0.25 green:0.07 blue:0.44 alpha:0.96]
                                                      borderColor:[UIColor colorWithRed:0.92 green:0.45 blue:1.0 alpha:0.9]
                                                           action:@selector(openAdminInfoGroup)];
            [self->_0x_adminBtn setTitleColor:[UIColor colorWithRed:0.45 green:0.98 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            self->_0x_adminBtn.layer.cornerRadius = 7;
            [self->_0x_menuBox addSubview:self->_0x_adminBtn];

            self->_0x_cprLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            self->_0x_cprLbl.text = _0xdec(_0xs_Copyright, sizeof(_0xs_Copyright));
            self->_0x_cprLbl.textColor = [UIColor colorWithRed:1.0 green:0.86 blue:0.55 alpha:0.98];
            self->_0x_cprLbl.font = [UIFont systemFontOfSize:8 weight:UIFontWeightBold];
            self->_0x_cprLbl.textAlignment = NSTextAlignmentCenter;
            self->_0x_cprLbl.numberOfLines = 2;
            [self->_0x_menuBox addSubview:self->_0x_cprLbl];

            [self layoutMenuSubviewsWithWidth:mW height:mH expanded:NO];
            [self applyIndependentGain:self->_0x_gain];
            [kw addSubview:self->_0x_menuBox];
        } else if (self->_0x_menuBox.superview != kw) {
            [kw addSubview:self->_0x_menuBox];
        }

        [self fetchRemotePlaylist];
    });
}

// ------------------------------------------------------------------------------
// DELEGATE PROTOCOLS (Giữ nguyên tên hàm chuẩn của Apple để UIKit gọi đúng)
// ------------------------------------------------------------------------------
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [self cleanYouTubePageInWebView];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self cleanYouTubePageInWebView];
    [self applyIndependentGain:_0x_gain];
}

- (void)toggleEmbeddedBrowser {
    _0x_webOpen = !_0x_webOpen;
    [self syncBrowserVisibilityAnimated:YES];
    if (_0x_webOpen && !_0x_webLoaded) {
        _0x_webLoaded = YES;
        [self loadYouTubeURLString:_0xdec(_0xs_YTHomeURL, sizeof(_0xs_YTHomeURL))];
    } else if (_0x_webOpen) {
        [self cleanYouTubePageInWebView];
        [self applyIndependentGain:_0x_gain];
    }
}

- (void)closeEmbeddedBrowser {
    [_0x_searchBar resignFirstResponder];
    _0x_webOpen = NO;
    [self syncBrowserVisibilityAnimated:YES];
}

- (void)syncBrowserVisibilityAnimated:(BOOL)animated {
    _0x_webBox.hidden = !_0x_webOpen;
    _0x_table.hidden = _0x_webOpen;
    NSString *t = _0x_webOpen ? _0xdec(_0xs_BtnBrowserCollapse, sizeof(_0xs_BtnBrowserCollapse))
                              : _0xdec(_0xs_BtnBrowserExpand, sizeof(_0xs_BtnBrowserExpand));
    [_0x_btnWebToggle setTitle:t forState:UIControlStateNormal];
    [self applyMenuFrameForExpanded:_0x_webOpen animated:animated];
}

- (void)loadYouTubeURLString:(NSString *)urlStr {
    if (!_0x_web || !urlStr || urlStr.length == 0) return;
    NSURL *u = [NSURL URLWithString:urlStr];
    if (!u) return;
    NSURLRequest *req = [NSURLRequest requestWithURL:u cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    [_0x_web loadRequest:req];
}

- (void)webGoHome {
    _0x_webLoaded = YES;
    [self loadYouTubeURLString:_0xdec(_0xs_YTHomeURL, sizeof(_0xs_YTHomeURL))];
}

- (void)triggerYouTubeSearch {
    [_0x_searchBar resignFirstResponder];
    NSString *raw = [_0x_searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!_0x_webOpen) {
        _0x_webOpen = YES;
        [self syncBrowserVisibilityAnimated:YES];
    }
    if (raw.length == 0) {
        _0x_webLoaded = YES;
        [self loadYouTubeURLString:_0xdec(_0xs_YTHomeURL, sizeof(_0xs_YTHomeURL))];
        return;
    }
    NSString *enc = [raw stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *pfx = _0xdec(_0xs_YTSearchPrefix, sizeof(_0xs_YTSearchPrefix));
    _0x_webLoaded = YES;
    [self loadYouTubeURLString:[NSString stringWithFormat:@"%@%@", pfx, enc ?: @""]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf {
    if (tf == _0x_searchBar) {
        [self triggerYouTubeSearch];
        return NO;
    }
    return YES;
}

- (void)webGoBack {
    if (_0x_web.canGoBack) [_0x_web goBack];
}

- (void)webGoForward {
    if (_0x_web.canGoForward) [_0x_web goForward];
}

- (void)loadRemoteLogo {
    NSString *u = _0xdec(_0xs_LogoURL, sizeof(_0xs_LogoURL));
    NSURL *lu = [NSURL URLWithString:u];
    if (!lu) return;

    NSURLSessionDataTask *t = [[NSURLSession sharedSession] dataTaskWithURL:lu completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        NSHTTPURLResponse *hr = (NSHTTPURLResponse *)r;
        if (e || !d || hr.statusCode != 200) return;
        UIImage *img = [UIImage imageWithData:d];
        if (!img) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_0x_floatBtn setImage:img forState:UIControlStateNormal];
            self->_0x_floatBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self->_0x_floatBtn setTitle:@"" forState:UIControlStateNormal];
        });
    }];
    [t resume];
}

- (void)toggleMenu {
    _0x_menuOpen = !_0x_menuOpen;
    if (_0x_menuOpen) {
        [self initializeFramework];
        [self applyMenuFrameForExpanded:_0x_webOpen animated:NO];
        [self applyIndependentGain:_0x_gain];
        [self fetchRemotePlaylist];
        [self syncPlayPauseButton];
        _0x_menuBox.hidden = NO;
        [UIView animateWithDuration:0.18 animations:^{
            self->_0x_menuBox.alpha = 1.0;
        }];
    } else {
        [_0x_searchBar resignFirstResponder];
        [UIView animateWithDuration:0.16 animations:^{
            self->_0x_menuBox.alpha = 0.0;
        } completion:^(BOOL fin) {
            self->_0x_menuBox.hidden = YES;
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
    if (!_0x_menuBox || !_0x_menuBox.superview) return;
    CGPoint tr = [p translationInView:_0x_menuBox.superview];
    _0x_menuBox.center = CGPointMake(_0x_menuBox.center.x + tr.x, _0x_menuBox.center.y + tr.y);
    [self clampViewToSafeBounds:_0x_menuBox topMargin:6.0f bottomMargin:6.0f];
    [p setTranslation:CGPointZero inView:_0x_menuBox.superview];
}

- (void)fetchRemotePlaylist {
    NSString *uStr = _0xdec(_0xs_PlaylistURL, sizeof(_0xs_PlaylistURL));
    NSURL *u = [NSURL URLWithString:uStr];
    if (!u) return;

    NSURLSessionConfiguration *c = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *s = [NSURLSession sessionWithConfiguration:c];

    NSURLSessionDataTask *t = [s dataTaskWithURL:u completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        NSHTTPURLResponse *hr = (NSHTTPURLResponse *)r;
        if (e || !d || hr.statusCode != 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_0x_statusMsg = [NSString stringWithFormat:@"Không tải được danh sách (Mã %ld)", (long)hr.statusCode];
                [self->_0x_table reloadData];
            });
            return;
        }

        NSError *je = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:d options:0 error:&je];
        if (je || ![dict isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_0x_statusMsg = @"Lỗi dữ liệu danh sách phát";
                [self->_0x_table reloadData];
            });
            return;
        }

        NSArray *songs = dict[@"songs"];
        if (![songs isKindOfClass:[NSArray class]] || songs.count == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->_0x_playlist removeAllObjects];
                self->_0x_statusMsg = @"Danh sách bài hát đang trống";
                [self->_0x_table reloadData];
            });
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_0x_playlist removeAllObjects];
            [self->_0x_playlist addObjectsFromArray:songs];
            self->_0x_statusMsg = nil;
            [self->_0x_table reloadData];
        });
    }];
    [t resume];
}

- (void)playSongAtIndex:(NSInteger)index {
    if (index < 0 || index >= (NSInteger)_0x_playlist.count) return;
    NSDictionary *song = _0x_playlist[index];
    NSString *title = song[@"title"] ?: _0xdec(_0xs_DefaultSongTitle, sizeof(_0xs_DefaultSongTitle));
    NSString *urlString = song[@"url"] ?: @"";
    if (urlString.length == 0) return;

    [self pauseWebMediaIfPlaying];
    [self configureAudioSession];

    NSString *enc = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *u = [NSURL URLWithString:enc ?: urlString];
    if (!u) return;

    _0x_idx = index;
    _0x_titleLbl.text = [NSString stringWithFormat:@"♪ %@", title];

    _0x_pItem = [AVPlayerItem playerItemWithURL:u];
    if (!_0x_player) {
        _0x_player = [AVPlayer playerWithPlayerItem:_0x_pItem];
    } else {
        [_0x_player replaceCurrentItemWithPlayerItem:_0x_pItem];
    }
    _0x_player.muted = (_0x_gain <= 0.001f);
    _0x_player.volume = MIN(1.0f, _0x_gain);
    [self applyGainToItem:_0x_pItem gain:_0x_gain];
    [_0x_player play];
    [self syncPlayPauseButton];
    [_0x_table reloadData];
}

- (void)togglePlayPause {
    if (!_0x_player || _0x_idx < 0) {
        if (_0x_playlist.count > 0) [self playSongAtIndex:0];
        return;
    }
    if (_0x_player.rate > 0.01f) {
        [_0x_player pause];
    } else {
        [self pauseWebMediaIfPlaying];
        [self configureAudioSession];
        _0x_player.muted = (_0x_gain <= 0.001f);
        _0x_player.volume = MIN(1.0f, _0x_gain);
        [self applyGainToItem:_0x_pItem gain:_0x_gain];
        [_0x_player play];
    }
    [self syncPlayPauseButton];
}

- (void)syncPlayPauseButton {
    BOOL isPlaying = (_0x_player && _0x_player.rate > 0.01f);
    _0x_btnPlay.activeState = isPlaying;
    [_0x_btnPlay refreshTransportVisual];
}

- (void)playPreviousSong {
    [_0x_btnPrev triggerPulseMark];
    if (_0x_playlist.count == 0) return;
    NSInteger prev = (_0x_idx <= 0) ? ((NSInteger)_0x_playlist.count - 1) : (_0x_idx - 1);
    [self playSongAtIndex:prev];
}

- (void)playNextSong {
    [_0x_btnNext triggerPulseMark];
    if (_0x_playlist.count == 0) return;
    NSInteger nxt = (_0x_idx + 1) % (NSInteger)_0x_playlist.count;
    [self playSongAtIndex:nxt];
}

- (void)volumeSliderChanged:(UISlider *)s {
    [self applyIndependentGain:s.value];
}

- (void)decreaseVolumeStep {
    float nxt = MAX(0.0f, _0x_gain - 0.15f);
    _0x_volSlider.value = nxt;
    [self applyIndependentGain:nxt];
}

- (void)increaseVolumeStep {
    float nxt = MIN(2.0f, _0x_gain + 0.15f);
    _0x_volSlider.value = nxt;
    [self applyIndependentGain:nxt];
}

- (void)toggleRepeatMode {
    _0x_repOne = !_0x_repOne;
    [[NSUserDefaults standardUserDefaults] setBool:_0x_repOne forKey:_0xdec(_0xs_PrefRepeatOne, sizeof(_0xs_PrefRepeatOne))];
    [self syncRepeatButton];
}

- (void)syncRepeatButton {
    _0x_btnRep.activeState = _0x_repOne;
    [_0x_btnRep refreshTransportVisual];
}

- (void)openAdminInfoGroup {
    NSString *uStr = _0xdec(_0xs_AdminURL, sizeof(_0xs_AdminURL));
    NSURL *u = [NSURL URLWithString:uStr];
    if (!u) return;
    [[UIApplication sharedApplication] openURL:u options:@{} completionHandler:nil];
}

// ------------------------------------------------------------------------------
// TABLE VIEW DATA SOURCE & DELEGATE (Apple Protocols)
// ------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)s {
    return _0x_playlist.count > 0 ? _0x_playlist.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
    NSString *cid = _0xdec(_0xs_CellID, sizeof(_0xs_CellID));
    UITableViewCell *c = [tv dequeueReusableCellWithIdentifier:cid];
    if (!c) {
        c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cid];
        c.backgroundColor = [UIColor clearColor];
        c.textLabel.font = [UIFont systemFontOfSize:10.5 weight:UIFontWeightSemibold];
        c.detailTextLabel.font = [UIFont systemFontOfSize:8.5];
    }

    if (_0x_playlist.count == 0) {
        c.textLabel.textColor = [UIColor colorWithRed:1.0 green:0.65 blue:0.75 alpha:1.0];
        c.textLabel.text = _0x_statusMsg ?: @"Không có bài hát";
        c.detailTextLabel.textColor = [UIColor lightGrayColor];
        c.detailTextLabel.text = @"Chạm để thử tải lại";
        return c;
    }

    NSDictionary *song = _0x_playlist[ip.row];
    NSString *title = song[@"title"] ?: _0xdec(_0xs_DefaultSongTitle, sizeof(_0xs_DefaultSongTitle));
    BOOL isCur = (ip.row == _0x_idx);

    c.textLabel.textColor = isCur ? [UIColor colorWithRed:1.0 green:0.65 blue:1.0 alpha:1.0] : [UIColor whiteColor];
    c.textLabel.text = title;
    c.detailTextLabel.textColor = isCur ? [UIColor colorWithRed:0.35 green:1.0 blue:0.75 alpha:1.0] : [UIColor colorWithRed:0.45 green:0.92 blue:1.0 alpha:1.0];
    c.detailTextLabel.text = isCur ? @"🔊 Đang phát trực tiếp" : @"▶ Chạm để phát nhạc";
    return c;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)ip {
    [tv deselectRowAtIndexPath:ip animated:YES];
    if (_0x_playlist.count == 0) {
        _0x_statusMsg = @"Đang tải lại danh sách nhạc...";
        [tv reloadData];
        [self fetchRemotePlaylist];
        return;
    }
    [self playSongAtIndex:ip.row];
}

@end

// ------------------------------------------------------------------------------
// CONSTRUCTOR LAUNCHER
// ------------------------------------------------------------------------------
__attribute__((constructor)) static void _0x_entry_point(void) {
    _0x_enforce_defense();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[PHLProtectedAudioManager sharedInstance] initializeFramework];
    });
}
