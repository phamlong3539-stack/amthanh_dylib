// ==============================================================================
// ==============================================================================
// 👑 PHL ENTERPRISE SECURE AUDIO RUNTIME (ARM64 ZERO-LATENCY MASTER ENGINE v2.4 PRO OBFUSCATED)
// CÔNG NGHỆ: DIRECT GIT WIRE PROTOCOL • ZERO RATE LIMIT • ANTI-SILENCE WATCHDOG
// BẢO MẬT: ENTERPRISE SYMBOL OBFUSCATION • ROLLING CIPHER STRING HIDING • OPAQUE PREDICATES
// TÍNH NĂNG: BÀI HOT PHÁT ĐẦU TIÊN • CHU KỲ BỎ QUA BÀI ĐÃ PHÁT • TUẦN HOÀN 100% KHÔNG IM LẶNG
// FIX v2.2: MUTUAL AUDIO EXCLUSION YOUTUBE ↔ GITHUB (KHÔNG CÒN NGHE 2 ÂM THANH CÙNG LÚC)
// FIX v2.3: BRANDING CACHE 100% ĐỒNG BỘ CONFIG (KHÔNG CÒN DÍNH HARDCODE CŨ)
// FIX v2.4: SMART QUEUE (BÀI HOT ĐẦU, BỎ QUA ĐÃ PHÁT, RESET VÒNG) & ANTI-SILENCE ENGINE
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

#pragma mark - 🛡️ TẦNG 0: BẢNG LÀM RỐI KÝ HIỆU & METADATA (ENTERPRISE SYMBOL OBFUSCATION)

// --- TÊN LỚP (CLASSES) ---
#define PHLProtectedAudioManager                _0x7b4a_AudioManager
#define PHLWeakScriptMessageProxy               _0x6c3d_ScriptProxy
#define PHLTransportButton                      _0x5d2e_VectorButton
#define TransportButtonKind                     _0x_TbKind

// --- BIẾN NỘI BỘ (IVARS) ---
#define _playedSongURLs                         _0x_u1
#define _playbackWatchdogTimer                  _0x_u2
#define _pausedByYouTube                        _0x_u3
#define _isTransitioningTrack                   _0x_u4
#define _isSyncingConfig                        _0x_u5
#define _lastKnownCommitSHA                     _0x_u6
#define _lastConfigETag                         _0x_u7
#define _pendingHeaderTitle                     _0x_u8
#define _pendingTickerText                      _0x_u9
#define _pendingFooterText                      _0x_ua
#define _pendingAdminBtnText                    _0x_ub
#define _featuredVipSong                        _0x_uc
#define _hasAutoPlayedVip                       _0x_ud
#define _hasShownLaunchAnnouncement             _0x_ue
#define _cachedAnnouncement                     _0x_uf
#define _isYouTubeEnabled                       _0x_v1
#define _youtubeHomeURL                         _0x_v2
#define _youtubeLockedMsg                       _0x_v3
#define _adminTargetURL                         _0x_v4
#define _maxAllowedGain                         _0x_v5
#define _autoSyncTimer                          _0x_v6
#define _statusMsg                              _0x_v7
#define _playlist                               _0x_v8
#define _menuOpen                               _0x_v9
#define _webOpen                                _0x_va
#define _webLoaded                              _0x_vb
#define _repOne                                 _0x_vc
#define _gain                                   _0x_vd
#define _idx                                    _0x_ve
#define _floatBtn                               _0x_vf
#define _menuBox                                _0x_w1
#define _gradient                               _0x_w2
#define _dragHdr                                _0x_w3
#define _headerTitleLbl                         _0x_w4
#define _tickerLbl                              _0x_w5
#define _titleLbl                               _0x_w6
#define _closeBtn                               _0x_w7
#define _table                                  _0x_w8
#define _player                                 _0x_w9
#define _playerItem                             _0x_wa
#define _btnPrev                                _0x_wb
#define _btnPlay                                _0x_wc
#define _btnNext                                _0x_wd
#define _btnRep                                 _0x_we
#define _btnMute                                _0x_wf
#define _btnVolUp                               _0x_x1
#define _volSlider                              _0x_x2
#define _gainLbl                                _0x_x3
#define _btnWebToggle                           _0x_x4
#define _webBox                                 _0x_x5
#define _btnBack                                _0x_x6
#define _btnFwd                                 _0x_x7
#define _btnHome                                _0x_x8
#define _btnCloseW                              _0x_x9
#define _searchBar                              _0x_xa
#define _btnSearch                              _0x_xb
#define _web                                    _0x_xc
#define _adminBtn                               _0x_xd
#define _cprLbl                                 _0x_xe
#define _cachedAdminConfig                      _0x_xf1
#define _pendingNeonColor                       _0x_xf2
#define _pendingGradientColors                  _0x_xf3
#define _enablePulseGlow                        _0x_xf4

// --- PHƯƠNG THỨC NỘI BỘ (METHODS & SELECTORS) ---
#define advanceToNextTrackAuto                  _0x_a8f1_nxt
#define startPlaybackWatchdog                   _0x_b9e2_swd
#define checkPlaybackWatchdog                   _0x_ca03_cwd
#define updateTitleLabelForCurrentSong          _0x_db14_utl
#define playSongAtIndex                         _0x_ec25_psi
#define fetchRemoteAdminConfig                  _0x_fd36_fac
#define applyRemoteAdminConfig                  _0x_0e47_aac
#define fetchRemotePlaylist                     _0x_1f58_fpl
#define parseAndApplyPlaylistData               _0x_2069_pad
#define injectFeaturedSongIntoPlaylist          _0x_317a_inj
#define cleanYouTubePageInWebView               _0x_428b_cln
#define pauseWebMediaIfPlaying                  _0x_539c_pwb
#define pauseStreamPlayerIfPlaying              _0x_64ad_psp
#define cleanTitleForSong                       _0x_75be_cts
#define applyIndependentGain                    _0x_86cf_aig
#define applyGainToItem                         _0x_97d0_agi
#define loadRemoteLogo                          _0x_a8e1_lrl
#define applyLogoImageToButton                  _0x_b9f2_alb
#define showAnnouncementPopup                   _0x_ca03_sap
#define toggleEmbeddedBrowser                   _0x_db14_teb
#define closeEmbeddedBrowser                    _0x_ec25_ceb
#define syncBrowserVisibilityAnimated           _0x_fd36_sbv
#define loadYouTubeURLString                    _0x_0e47_lyu
#define triggerYouTubeSearch                    _0x_1f58_tys
#define openAdminInfoGroup                      _0x_2069_oai
#define toggleRepeatMode                        _0x_317a_trm
#define syncRepeatButton                        _0x_428b_srb
#define syncPlayPauseButton                     _0x_539c_spb
#define togglePlayPause                         _0x_64ad_tpp
#define playNextSong                            _0x_75be_pns
#define playPreviousSong                        _0x_86cf_pps
#define initializeFramework                     _0x_97d0_ini
#define resolveActiveWindow                     _0x_a8e1_raw
#define makeUtilityButtonWithTitle              _0x_b9f2_mub
#define layoutMenuSubviewsWithWidth             _0x_ca03_lms
#define applyMenuFrameForExpanded               _0x_db14_amf
#define configureAudioSession                   _0x_ec25_cas
#define handleItemDidFinish                     _0x_fd36_hdf
#define handleItemFailedToPlay                  _0x_0e47_hfp
#define handleAudioSessionInterruption          _0x_1f58_hsi
#define toggleMenu                              _0x_2069_tmn
#define handleFloatingPan                       _0x_317a_hfp
#define handleMenuHeaderPan                     _0x_428b_hmp
#define clampViewToSafeBounds                   _0x_539c_csb
#define volumeSliderChanged                     _0x_64ad_vsc
#define decreaseVolumeStep                      _0x_75be_dvs
#define increaseVolumeStep                      _0x_86cf_ivs
#define triggerPulseMark                        _0x_97d0_tpm
#define refreshTransportVisual                  _0x_a8e1_rtv
#define setupKind                               _0x_b9f2_spk
#define buttonWithKind                          _0x_ca03_bwk
#define fallbackFetchApiConfig                  _0x_db14_ffa
#define fallbackFetchDirectRawConfig            _0x_ec25_ffd
#define webGoBack                               _0x_fd36_wgb
#define webGoForward                            _0x_0e47_wgf
#define webGoHome                               _0x_1f58_wgh
#define ensureFloatingButtonPulseAnimation      _0x_fa01_efp
#define handleAppDidBecomeActive                _0x_fa02_hba
#define handleAppWillEnterForeground            _0x_fa03_wef
#define handleAppDidEnterBackground             _0x_fa04_deb

// --- OPAQUE GUARDS (CHỐNG DỰNG ĐỒ THỊ ĐIỀU KHIỂN CFG TRONG IDA / GHIDRA) ---
#define PHL_OPAQUE_GUARD() \
    do { \
        volatile unsigned long _phl_opq_a = 0x5A7CUL; \
        volatile unsigned long _phl_opq_b = 0x1E3BUL; \
        if (((_phl_opq_a * _phl_opq_b) & 1UL) != 0UL) { \
            __builtin_trap(); \
        } \
    } while (0)

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

#define PHL_DEC(name) PHL_DecryptString(kEnc_##name, kLen_##name)

// https://raw.githubusercontent.com/phamlong3539-stack/phl-music-data/main/logo.png
static const uint8_t kEnc_GITHUB_RAW_LOGO[] = { 0x32, 0x2F, 0x28, 0x2D, 0x2D, 0x65, 0x4F, 0x4E, 0x10, 0x02, 0x13, 0x4B, 0x01, 0x0E, 0x1C, 0x01, 0x1F, 0x09, 0x19, 0x1E, 0x0B, 0x1D, 0x13, 0x1E, 0x1C, 0x07, 0x11, 0x1B, 0x02, 0x59, 0x1B, 0x16, 0x17, 0x54, 0x0C, 0x15, 0x1F, 0x12, 0xEC, 0xEE, 0xEC, 0xE4, 0xB7, 0xB0, 0xB5, 0xBE, 0xA5, 0xFA, 0xFE, 0xEA, 0xEF, 0xE6, 0xA1, 0xFF, 0xF8, 0xFD, 0xBF, 0xFE, 0xE1, 0xE6, 0xFF, 0xF4, 0xB5, 0xFD, 0xFB, 0xEF, 0xFD, 0xB2, 0xF3, 0xFE, 0xC9, 0xCF, 0x8D, 0xCF, 0xCB, 0xC2, 0xC9, 0x89, 0xD8, 0xC7, 0xCD };
static const size_t kLen_GITHUB_RAW_LOGO = 81;

// https://raw.githubusercontent.com/phamlong3539-stack/phl-music-data/main/playlist.json
static const uint8_t kEnc_GITHUB_RAW_PLAYLIST[] = { 0x32, 0x2F, 0x28, 0x2D, 0x2D, 0x65, 0x4F, 0x4E, 0x10, 0x02, 0x13, 0x4B, 0x01, 0x0E, 0x1C, 0x01, 0x1F, 0x09, 0x19, 0x1E, 0x0B, 0x1D, 0x13, 0x1E, 0x1C, 0x07, 0x11, 0x1B, 0x02, 0x59, 0x1B, 0x16, 0x17, 0x54, 0x0C, 0x15, 0x1F, 0x12, 0xEC, 0xEE, 0xEC, 0xE4, 0xB7, 0xB0, 0xB5, 0xBE, 0xA5, 0xFA, 0xFE, 0xEA, 0xEF, 0xE6, 0xA1, 0xFF, 0xF8, 0xFD, 0xBF, 0xFE, 0xE1, 0xE6, 0xFF, 0xF4, 0xB5, 0xFD, 0xFB, 0xEF, 0xFD, 0xB2, 0xF3, 0xFE, 0xC9, 0xCF, 0x8D, 0xD3, 0xC8, 0xC4, 0xDF, 0xCB, 0xC1, 0xDA, 0xDE, 0x85, 0xC6, 0xDE, 0xC1, 0xC1 };
static const size_t kLen_GITHUB_RAW_PLAYLIST = 86;

// https://github.com/phamlong3539-stack/phl-music-data.git/info/refs?service=git-upload-pack
static const uint8_t kEnc_GIT_INFO_REFS[] = { 0x32, 0x2F, 0x28, 0x2D, 0x2D, 0x65, 0x4F, 0x4E, 0x05, 0x0A, 0x10, 0x0D, 0x13, 0x05, 0x46, 0x0A, 0x05, 0x06, 0x43, 0x1D, 0x06, 0x0E, 0x1D, 0x1D, 0x1D, 0x1D, 0x13, 0x46, 0x43, 0x44, 0x41, 0x54, 0x09, 0x0F, 0x1D, 0x1E, 0x15, 0x50, 0xF0, 0xE9, 0xEE, 0xAE, 0xE9, 0xF0, 0xF5, 0xEE, 0xEB, 0xA4, 0xEE, 0xEA, 0xF8, 0xEC, 0xA0, 0xE8, 0xF9, 0xE5, 0xBD, 0xFA, 0xFA, 0xF3, 0xF9, 0xB8, 0xEA, 0xFC, 0xFC, 0xE8, 0xA3, 0xEE, 0xFB, 0xED, 0xD6, 0xC8, 0xC1, 0xC6, 0x99, 0xC2, 0xCF, 0xD3, 0x85, 0xDC, 0xDA, 0xC7, 0xC3, 0xCC, 0xCA, 0x82, 0xC0, 0xD0, 0xD1, 0xD8 };
static const size_t kLen_GIT_INFO_REFS = 90;

// https://raw.githubusercontent.com/phamlong3539-stack/phl-music-data/
static const uint8_t kEnc_GITHUB_RAW_BASE[] = { 0x32, 0x2F, 0x28, 0x2D, 0x2D, 0x65, 0x4F, 0x4E, 0x10, 0x02, 0x13, 0x4B, 0x01, 0x0E, 0x1C, 0x01, 0x1F, 0x09, 0x19, 0x1E, 0x0B, 0x1D, 0x13, 0x1E, 0x1C, 0x07, 0x11, 0x1B, 0x02, 0x59, 0x1B, 0x16, 0x17, 0x54, 0x0C, 0x15, 0x1F, 0x12, 0xEC, 0xEE, 0xEC, 0xE4, 0xB7, 0xB0, 0xB5, 0xBE, 0xA5, 0xFA, 0xFE, 0xEA, 0xEF, 0xE6, 0xA1, 0xFF, 0xF8, 0xFD, 0xBF, 0xFE, 0xE1, 0xE6, 0xFF, 0xF4, 0xB5, 0xFD, 0xFB, 0xEF, 0xFD, 0xB2 };
static const size_t kLen_GITHUB_RAW_BASE = 68;

// https://raw.githubusercontent.com/phamlong3539-stack/phl-music-data/main/config.json
static const uint8_t kEnc_GITHUB_RAW_CFG[] = { 0x32, 0x2F, 0x28, 0x2D, 0x2D, 0x65, 0x4F, 0x4E, 0x10, 0x02, 0x13, 0x4B, 0x01, 0x0E, 0x1C, 0x01, 0x1F, 0x09, 0x19, 0x1E, 0x0B, 0x1D, 0x13, 0x1E, 0x1C, 0x07, 0x11, 0x1B, 0x02, 0x59, 0x1B, 0x16, 0x17, 0x54, 0x0C, 0x15, 0x1F, 0x12, 0xEC, 0xEE, 0xEC, 0xE4, 0xB7, 0xB0, 0xB5, 0xBE, 0xA5, 0xFA, 0xFE, 0xEA, 0xEF, 0xE6, 0xA1, 0xFF, 0xF8, 0xFD, 0xBF, 0xFE, 0xE1, 0xE6, 0xFF, 0xF4, 0xB5, 0xFD, 0xFB, 0xEF, 0xFD, 0xB2, 0xF3, 0xFE, 0xC9, 0xCF, 0x8D, 0xC0, 0xCB, 0xCB, 0xC0, 0xCE, 0xCF, 0x87, 0xC0, 0xD8, 0xC3, 0xC3 };
static const size_t kLen_GITHUB_RAW_CFG = 84;

// https://api.github.com/repos/phamlong3539-stack/phl-music-data/contents/config.json
static const uint8_t kEnc_GITHUB_API_CFG[] = { 0x32, 0x2F, 0x28, 0x2D, 0x2D, 0x65, 0x4F, 0x4E, 0x03, 0x13, 0x0D, 0x4B, 0x01, 0x0E, 0x1C, 0x01, 0x1F, 0x09, 0x42, 0x0E, 0x01, 0x02, 0x5F, 0x03, 0x17, 0x03, 0x1B, 0x06, 0x59, 0x07, 0x10, 0x18, 0x17, 0x17, 0x13, 0x13, 0x19, 0x4C, 0xB5, 0xB2, 0xBB, 0xAE, 0xF7, 0xF1, 0xE7, 0xE4, 0xE3, 0xA6, 0xFA, 0xE3, 0xE0, 0xA0, 0xE3, 0xFA, 0xE3, 0xF8, 0xF1, 0xBE, 0xF0, 0xF4, 0xE2, 0xF6, 0xB7, 0xFA, 0xF5, 0xF5, 0xE8, 0xF8, 0xF0, 0xEB, 0xD3, 0x8E, 0xC1, 0xCC, 0xCA, 0xC3, 0xCF, 0xC0, 0x86, 0xC3, 0xD9, 0xC4, 0xC2 };
static const size_t kLen_GITHUB_API_CFG = 83;

// https://t.me/PHL0990
static const uint8_t __attribute__((unused)) kEnc_DEFAULT_ADMIN_URL[] = { 0x32, 0x2F, 0x28, 0x2D, 0x2D, 0x65, 0x4F, 0x4E, 0x16, 0x4D, 0x09, 0x00, 0x49, 0x37, 0x20, 0x25, 0x5A, 0x52, 0x55, 0x5D };
static const size_t __attribute__((unused)) kLen_DEFAULT_ADMIN_URL = 20;

// --- ENCRYPTED PROTOCOL & DICTIONARY KEYS ---
static const uint8_t kEnc_SYSTEM_CONTROL[] = { 0x29, 0x22, 0x2F, 0x29, 0x3B, 0x32, 0x3F, 0x02, 0x0D, 0x0D, 0x10, 0x17, 0x09, 0x0B };
static const size_t kLen_SYSTEM_CONTROL = 14;
static const uint8_t kEnc_KILL_SWITCH[] = { 0x31, 0x32, 0x30, 0x31, 0x01, 0x2C, 0x17, 0x08, 0x16, 0x00, 0x0C };
static const size_t kLen_KILL_SWITCH = 11;
static const uint8_t kEnc_YOUTUBE_MODULE[] = { 0x23, 0x34, 0x29, 0x29, 0x2B, 0x3D, 0x05, 0x3E, 0x0F, 0x0C, 0x00, 0x10, 0x0A, 0x02 };
static const size_t kLen_YOUTUBE_MODULE = 14;
static const uint8_t kEnc_VIP_FEATURED_SONG[] = { 0x2C, 0x32, 0x2C, 0x02, 0x38, 0x3A, 0x01, 0x15, 0x17, 0x11, 0x01, 0x01, 0x39, 0x14, 0x07, 0x07, 0x0D };
static const size_t kLen_VIP_FEATURED_SONG = 17;
static const uint8_t kEnc_BRANDING[] = { 0x38, 0x29, 0x3D, 0x33, 0x3A, 0x36, 0x0E, 0x06 };
static const size_t kLen_BRANDING = 8;
static const uint8_t kEnc_HEADER_TITLE[] = { 0x32, 0x3E, 0x3D, 0x39, 0x3B, 0x2D, 0x3F, 0x15, 0x0B, 0x17, 0x08, 0x00 };
static const size_t kLen_HEADER_TITLE = 12;
static const uint8_t kEnc_TICKER_ANNOUNCEMENT[] = { 0x2E, 0x32, 0x3F, 0x36, 0x3B, 0x2D, 0x3F, 0x00, 0x0C, 0x0D, 0x0B, 0x10, 0x08, 0x04, 0x0D, 0x04, 0x0F, 0x05, 0x18 };
static const size_t kLen_TICKER_ANNOUNCEMENT = 19;
static const uint8_t kEnc_FOOTER_COPYRIGHT[] = { 0x3C, 0x34, 0x33, 0x29, 0x3B, 0x2D, 0x3F, 0x02, 0x0D, 0x13, 0x1D, 0x17, 0x0F, 0x00, 0x00, 0x1D };
static const size_t kLen_FOOTER_COPYRIGHT = 16;
static const uint8_t kEnc_ADMIN_BUTTON_TEXT[] = { 0x3B, 0x3F, 0x31, 0x34, 0x30, 0x00, 0x02, 0x14, 0x16, 0x17, 0x0B, 0x0B, 0x39, 0x13, 0x0D, 0x11, 0x1E };
static const size_t kLen_ADMIN_BUTTON_TEXT = 17;
static const uint8_t kEnc_ADMIN_BUTTON_URL[] = { 0x3B, 0x3F, 0x31, 0x34, 0x30, 0x00, 0x02, 0x14, 0x16, 0x17, 0x0B, 0x0B, 0x39, 0x12, 0x1A, 0x05 };
static const size_t kLen_ADMIN_BUTTON_URL = 16;
static const uint8_t kEnc_AUDIO_ENGINE[] = { 0x3B, 0x2E, 0x38, 0x34, 0x31, 0x00, 0x05, 0x0F, 0x05, 0x0A, 0x0A, 0x00 };
static const size_t kLen_AUDIO_ENGINE = 12;
static const uint8_t kEnc_MAX_GAIN[] = { 0x37, 0x3A, 0x24, 0x02, 0x39, 0x3E, 0x09, 0x0F };
static const size_t kLen_MAX_GAIN = 8;
static const uint8_t kEnc_ANNOUNCEMENT[] = { 0x3B, 0x35, 0x32, 0x32, 0x2B, 0x31, 0x03, 0x04, 0x0F, 0x06, 0x0A, 0x11 };
static const size_t kLen_ANNOUNCEMENT = 12;
static const uint8_t kEnc_SONGS[] = { 0x29, 0x34, 0x32, 0x3A, 0x2D };
static const size_t kLen_SONGS = 5;
static const uint8_t kEnc_PLAYLIST[] = { 0x2A, 0x37, 0x3D, 0x24, 0x32, 0x36, 0x13, 0x15 };
static const size_t kLen_PLAYLIST = 8;
static const uint8_t kEnc_TITLE[] = { 0x2E, 0x32, 0x28, 0x31, 0x3B };
static const size_t kLen_TITLE = 5;
static const uint8_t kEnc_URL[] = { 0x2F, 0x29, 0x30 };
static const size_t kLen_URL = 3;
static const uint8_t kEnc_IS_HOT[] = { 0x33, 0x28, 0x03, 0x35, 0x31, 0x2B };
static const size_t kLen_IS_HOT = 6;
static const uint8_t kEnc_ENABLED[] = { 0x3F, 0x35, 0x3D, 0x3F, 0x32, 0x3A, 0x04 };
static const size_t kLen_ENABLED = 7;
static const uint8_t kEnc_HOME_URL[] = { 0x32, 0x34, 0x31, 0x38, 0x01, 0x2A, 0x12, 0x0D };
static const size_t kLen_HOME_URL = 8;
static const uint8_t kEnc_LOCKED_REASON[] = { 0x36, 0x34, 0x3F, 0x36, 0x3B, 0x3B, 0x3F, 0x13, 0x07, 0x02, 0x17, 0x0A, 0x08 };
static const size_t kLen_LOCKED_REASON = 13;
static const uint8_t kEnc_PHLWEBMEDIAPLAYING[] = { 0x2A, 0x33, 0x30, 0x0A, 0x3B, 0x3D, 0x2D, 0x04, 0x06, 0x0A, 0x05, 0x35, 0x0A, 0x06, 0x11, 0x00, 0x04, 0x0C };
static const size_t kLen_PHLWEBMEDIAPLAYING = 18;
static const uint8_t kEnc_PHLWEBMEDIAPAUSED[] = { 0x2A, 0x33, 0x30, 0x0A, 0x3B, 0x3D, 0x2D, 0x04, 0x06, 0x0A, 0x05, 0x35, 0x07, 0x12, 0x1B, 0x0C, 0x0E };
static const size_t kLen_PHLWEBMEDIAPAUSED = 17;
static const uint8_t kEnc_PHL_CACHEDCONFIGJSON[] = { 0x0A, 0x13, 0x10, 0x02, 0x1D, 0x3E, 0x03, 0x09, 0x07, 0x07, 0x27, 0x0A, 0x08, 0x01, 0x01, 0x0E, 0x20, 0x38, 0x23, 0x23 };
static const size_t kLen_PHL_CACHEDCONFIGJSON = 20;
static const uint8_t kEnc_PHL_CACHEDPLAYLIST[] = { 0x0A, 0x13, 0x10, 0x02, 0x1D, 0x3E, 0x03, 0x09, 0x07, 0x07, 0x34, 0x09, 0x07, 0x1E, 0x04, 0x00, 0x19, 0x1F };
static const size_t kLen_PHL_CACHEDPLAYLIST = 18;
static const uint8_t kEnc_PHL_LASTCOMMITSHA[] = { 0x0A, 0x13, 0x10, 0x02, 0x12, 0x3E, 0x13, 0x15, 0x21, 0x0C, 0x09, 0x08, 0x0F, 0x13, 0x3B, 0x21, 0x2B };
static const size_t kLen_PHL_LASTCOMMITSHA = 17;
static const uint8_t kEnc_PHL_LASTCONFIGETAG[] = { 0x0A, 0x13, 0x10, 0x02, 0x12, 0x3E, 0x13, 0x15, 0x21, 0x0C, 0x0A, 0x03, 0x0F, 0x00, 0x2D, 0x3D, 0x0B, 0x0C };
static const size_t kLen_PHL_LASTCONFIGETAG = 18;
static const uint8_t kEnc_PHL_REPEATONESONG[] = { 0x0A, 0x13, 0x10, 0x02, 0x0C, 0x3A, 0x10, 0x04, 0x03, 0x17, 0x2B, 0x0B, 0x03, 0x34, 0x07, 0x07, 0x0D };
static const size_t kLen_PHL_REPEATONESONG = 17;
static const uint8_t kEnc_PHL_INDEPENDENTAUDIOGAIN[] = { 0x0A, 0x13, 0x10, 0x02, 0x17, 0x31, 0x04, 0x04, 0x12, 0x06, 0x0A, 0x01, 0x03, 0x09, 0x1C, 0x28, 0x1F, 0x0F, 0x05, 0x02, 0x29, 0x0E, 0x19, 0x1F };
static const size_t kLen_PHL_INDEPENDENTAUDIOGAIN = 24;

// --- THEME & UI ENCRYPTED KEYS ---
static const uint8_t kEnc_THEME_CUSTOMIZER[] = { 0x2E, 0x33, 0x39, 0x30, 0x3B, 0x00, 0x03, 0x14, 0x11, 0x17, 0x0B, 0x08, 0x0F, 0x1D, 0x0D, 0x1B };
static const size_t kLen_THEME_CUSTOMIZER = 16;
static const uint8_t kEnc_NEON_BORDER_COLOR[] = { 0x34, 0x3E, 0x33, 0x33, 0x01, 0x3D, 0x0F, 0x13, 0x06, 0x06, 0x16, 0x3A, 0x05, 0x08, 0x04, 0x06, 0x18 };
static const size_t kLen_NEON_BORDER_COLOR = 17;
static const uint8_t kEnc_GRADIENT_START_COLOR[] = { 0x3D, 0x29, 0x3D, 0x39, 0x37, 0x3A, 0x0E, 0x15, 0x3D, 0x10, 0x10, 0x04, 0x14, 0x13, 0x37, 0x0A, 0x05, 0x07, 0x03, 0x1F };
static const size_t kLen_GRADIENT_START_COLOR = 20;
static const uint8_t kEnc_GRADIENT_MID_COLOR[] = { 0x3D, 0x29, 0x3D, 0x39, 0x37, 0x3A, 0x0E, 0x15, 0x3D, 0x0E, 0x0D, 0x01, 0x39, 0x04, 0x07, 0x05, 0x05, 0x19 };
static const size_t kLen_GRADIENT_MID_COLOR = 18;
static const uint8_t kEnc_GRADIENT_END_COLOR[] = { 0x3D, 0x29, 0x3D, 0x39, 0x37, 0x3A, 0x0E, 0x15, 0x3D, 0x06, 0x0A, 0x01, 0x39, 0x04, 0x07, 0x05, 0x05, 0x19 };
static const size_t kLen_GRADIENT_END_COLOR = 18;
static const uint8_t kEnc_FLOATING_ICON[] = { 0x3C, 0x37, 0x33, 0x3C, 0x2A, 0x36, 0x0E, 0x06, 0x3D, 0x0A, 0x07, 0x0A, 0x08 };
static const size_t kLen_FLOATING_ICON = 13;
static const uint8_t kEnc_FLOATING_PULSE_GLOW[] = { 0x3C, 0x37, 0x33, 0x3C, 0x2A, 0x36, 0x0E, 0x06, 0x3D, 0x13, 0x11, 0x09, 0x15, 0x02, 0x37, 0x0E, 0x06, 0x04, 0x1B };
static const size_t kLen_FLOATING_PULSE_GLOW = 19;
static const uint8_t kEnc_PHL_PULSE_ANIM[] = { 0x2A, 0x33, 0x30, 0x02, 0x2E, 0x2A, 0x0C, 0x12, 0x07, 0x3C, 0x05, 0x0B, 0x0F, 0x0A };
static const size_t kLen_PHL_PULSE_ANIM = 14;

// --- ANTI-ANALYSIS TARGETS ---
static const uint8_t kEnc_SEC_FRIDAGADGET[] = { 0x1C, 0x29, 0x35, 0x39, 0x3F, 0x18, 0x01, 0x05, 0x05, 0x06, 0x10 };
static const size_t kLen_SEC_FRIDAGADGET = 11;
static const uint8_t kEnc_SEC_FRIDA_AGENT[] = { 0x3C, 0x29, 0x35, 0x39, 0x3F, 0x72, 0x01, 0x06, 0x07, 0x0D, 0x10 };
static const size_t kLen_SEC_FRIDA_AGENT = 11;
static const uint8_t kEnc_SEC_CYNJECT[] = { 0x39, 0x22, 0x32, 0x37, 0x3B, 0x3C, 0x14 };
static const size_t kLen_SEC_CYNJECT = 7;
static const uint8_t kEnc_SEC_LIBCYCRIPT[] = { 0x36, 0x32, 0x3E, 0x3E, 0x27, 0x3C, 0x12, 0x08, 0x12, 0x17 };
static const size_t kLen_SEC_LIBCYCRIPT = 10;
static const uint8_t kEnc_SEC_SUBSTRATELOADER[] = { 0x09, 0x2E, 0x3E, 0x2E, 0x2A, 0x2D, 0x01, 0x15, 0x07, 0x2F, 0x0B, 0x04, 0x02, 0x02, 0x1A };
static const size_t kLen_SEC_SUBSTRATELOADER = 15;

#pragma mark - 🛡️ TẦNG 2: BẢO MẬT CHỐNG DEBUG & HOOK (ANTI-LLDB, ANTI-FRIDA, ANTI-ATTACH)

PHL_HIDDEN static inline void PHL_EnforceSecuritySanity(void) {
    PHL_OPAQUE_GUARD();
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
    NSString *fg = PHL_DecryptString(kEnc_SEC_FRIDAGADGET, kLen_SEC_FRIDAGADGET);
    NSString *fa = PHL_DecryptString(kEnc_SEC_FRIDA_AGENT, kLen_SEC_FRIDA_AGENT);
    NSString *cj = PHL_DecryptString(kEnc_SEC_CYNJECT, kLen_SEC_CYNJECT);
    NSString *cy = PHL_DecryptString(kEnc_SEC_LIBCYCRIPT, kLen_SEC_LIBCYCRIPT);
    for (uint32_t i = 0; i < count; i++) {
        const char *img = _dyld_get_image_name(i);
        if (img) {
            if (strstr(img, fg.UTF8String) || strstr(img, fa.UTF8String) || strstr(img, cj.UTF8String) || strstr(img, cy.UTF8String)) {
                exit(0);
            }
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
    NSDictionary *_cachedAnnouncement;
    BOOL _hasAutoPlayedVip;
    BOOL _hasShownLaunchAnnouncement;
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

    // CÔNG NGHỆ CHỐNG TRỄ & CHỐNG LẶP LỖI DAO ĐỘNG
    NSString *_lastKnownCommitSHA;
    NSString *_lastConfigETag;
    BOOL _isSyncingConfig;
    BOOL _isTransitioningTrack;

    // FIX v2.2: MUTUAL AUDIO EXCLUSION YOUTUBE ↔ GITHUB
    // _pausedByYouTube = YES khi GitHub bị dừng do YouTube bắt đầu phát
    // → dùng để tự động resume GitHub khi đóng YouTube
    BOOL _pausedByYouTube;

    // FIX v2.3: BRANDING CACHE — LƯU GIÁ TRỊ CONFIG KHI UI CHƯA SẴN SÀNG
    // applyRemoteAdminConfig có thể được gọi từ init() trước khi label tồn tại
    // → lưu vào biến cache, áp dụng lại ngay khi initializeFramework hoàn tất
    NSString *_pendingHeaderTitle;
    NSString *_pendingTickerText;
    NSString *_pendingFooterText;
    NSString *_pendingAdminBtnText;

    // FIX v2.4: SMART UNPLAYED CYCLE & ANTI-SILENCE WATCHDOG
    NSMutableSet<NSString *> *_playedSongURLs;
    NSTimer *_playbackWatchdogTimer;

    // FIX v2.5: THEME & ANIMATION PERSISTENCE ACROSS RE-ENTRY
    NSDictionary *_cachedAdminConfig;
    UIColor *_pendingNeonColor;
    NSArray *_pendingGradientColors;
    BOOL _enablePulseGlow;
}
+ (instancetype)sharedInstance;
- (void)initializeFramework;
- (void)ensureFloatingButtonPulseAnimation;
- (void)handleAppDidBecomeActive:(NSNotification *)note;
- (void)handleAppWillEnterForeground:(NSNotification *)note;
- (void)handleAppDidEnterBackground:(NSNotification *)note;
@end

@implementation PHLProtectedAudioManager

#pragma mark - XỬ LÝ LÀM SẠCH TÊN BÀI HÁT & NHẬN DIỆN BÀI HOT PRO

- (NSString *)cleanTitleForSong:(NSString *)rawTitle isHot:(BOOL *)outIsHot {
    if (!rawTitle || rawTitle.length == 0) {
        if (outIsHot) *outIsHot = NO;
        return @"Bài hát chưa đặt tên";
    }

    NSString *clean = rawTitle;
    BOOL isHot = NO;

    if ([clean rangeOfString:@"HOT" options:NSCaseInsensitiveSearch].location != NSNotFound ||
        [clean rangeOfString:@"TREND" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        isHot = YES;
    }

    // Tự động gỡ bỏ các ký hiệu rườm rà như ⭐ [HOT TREND], [HOT TREND], ⭐ [HOT], [HOT], v.v.
    NSArray *redundantPrefixes = @[
        @"⭐ [HOT TREND]", @"[HOT TREND]",
        @"⭐ [HOT]", @"[HOT]",
        @"⭐", @"🔥"
    ];
    for (NSString *prefix in redundantPrefixes) {
        clean = [clean stringByReplacingOccurrencesOfString:prefix withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, clean.length)];
    }

    clean = [clean stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (clean.length == 0) clean = rawTitle;

    if (outIsHot) *outIsHot = isHot;
    return clean;
}

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
            "    if(!musicFilterTriggered && (window.location.pathname === '/' || window.location.pathname === '')){\n"
            "      var chips = document.querySelectorAll('ytm-chip-cloud-chip-renderer, ytm-feed-filter-chip-bar-renderer button, [role=\"tab\"], .chip-container button');\n"
            "      for(var i=0; i<chips.length; i++){\n"
            "        var t = (chips[i].textContent || '').trim().toLowerCase();\n"
            "        if(t === 'âm nhạc' || t === 'music'){\n"
            "          chips[i].click();\n"
            "          musicFilterTriggered = true;\n"
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
            "  if(!window.__phlObserverActive){\n"
            "    window.__phlObserverActive = true;\n"
            "    var obs = new MutationObserver(function(){\n"
            "      if(!window.__phlThrottle){ window.__phlThrottle = setTimeout(function(){ executePurge(); window.__phlThrottle = null; }, 500); }\n"
            "    });\n"
            "    if(document.body){ obs.observe(document.body, {childList: true, subtree: true}); }\n"
            "  }\n"
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
            // --- FIX v2.2: Thêm 'timeupdate' để bắt được autoplay của YouTube ---
            // 'play' bắt khi user nhấn play / autoplay bắt đầu
            "          e.addEventListener('play', function(){\n"
            "            self.applyToElement(e);\n"
            "            e.__phlTimeupdateNotified = false;\n"
            "            if(window.webkit && window.webkit.messageHandlers &&\n"
            "               window.webkit.messageHandlers.phlWebMediaPlaying){\n"
            "              window.webkit.messageHandlers.phlWebMediaPlaying.postMessage('playing');\n"
            "            }\n"
            "          }, true);\n"
            // 'timeupdate' bắt được trường hợp autoplay tiếp tục mà không fire 'play' event
            "          e.addEventListener('timeupdate', function(){\n"
            "            if(!e.paused && !e.__phlTimeupdateNotified && e.currentTime > 0.3){\n"
            "              e.__phlTimeupdateNotified = true;\n"
            "              if(window.webkit && window.webkit.messageHandlers &&\n"
            "                 window.webkit.messageHandlers.phlWebMediaPlaying){\n"
            "                window.webkit.messageHandlers.phlWebMediaPlaying.postMessage('playing');\n"
            "              }\n"
            "            }\n"
            "          }, true);\n"
            // 'pause' reset flag để lần play tiếp theo sẽ fire lại notification
            "          e.addEventListener('pause', function(){\n"
            "            e.__phlTimeupdateNotified = false;\n"
            "            var allPaused = true;\n"
            "            document.querySelectorAll('video,audio').forEach(function(el){\n"
            "              if(!el.paused) allPaused = false;\n"
            "            });\n"
            "            if(allPaused && window.webkit && window.webkit.messageHandlers &&\n"
            "               window.webkit.messageHandlers.phlWebMediaPaused){\n"
            "              window.webkit.messageHandlers.phlWebMediaPaused.postMessage('paused');\n"
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
        _playedSongURLs = [[NSMutableSet alloc] init];
        _hasAutoPlayedVip = NO;
        _hasShownLaunchAnnouncement = NO;
        _cachedAnnouncement = nil;
        _statusMsg = @"Đang nạp dữ liệu Master VIP...";
        _idx = -1;
        _menuOpen = NO;
        _webOpen = NO;
        _webLoaded = NO;
        _isSyncingConfig = NO;
        _isTransitioningTrack = NO;
        _pausedByYouTube = NO;

        // MẶC ĐỊNH AN TOÀN: NẠP TRẠNG THÁI YOUTUBE TỪ BỘ NHỚ LƯU TRỮ TRƯỚC ĐÓ
        _isYouTubeEnabled = [ud objectForKey:@"PHL_Cached_YT_Enabled"] ? [ud boolForKey:@"PHL_Cached_YT_Enabled"] : YES;
        _youtubeHomeURL = @"https://m.youtube.com";
        _youtubeLockedMsg = @"Tính năng YouTube đang bảo trì hạ tầng.";
        _adminTargetURL = @"https://phamlong09.store";
        _maxAllowedGain = 3.0f;

        // MẶC ĐỊNH PHÁT TUẦN HOÀN TOÀN BỘ DANH SÁCH (1 -> 10 -> 1)
        _repOne = [ud objectForKey:PHL_DEC(PHL_REPEATONESONG)] ? [ud boolForKey:PHL_DEC(PHL_REPEATONESONG)] : NO;
        _gain = [ud objectForKey:PHL_DEC(PHL_INDEPENDENTAUDIOGAIN)] ? [ud floatForKey:PHL_DEC(PHL_INDEPENDENTAUDIOGAIN)] : 1.0f;
        _lastKnownCommitSHA = [ud stringForKey:PHL_DEC(PHL_LASTCOMMITSHA)];
        _lastConfigETag = [ud stringForKey:PHL_DEC(PHL_LASTCONFIGETAG)];

        // FIX v2.5: Mặc định theme Màu Hồng #FF85C0 và hiệu ứng thở nút nổi
        _enablePulseGlow = YES;
        _pendingNeonColor = [UIColor colorWithRed:1.0 green:0.52 blue:0.75 alpha:1.0];
        _pendingGradientColors = @[
            (id)[UIColor colorWithRed:0.18 green:0.03 blue:0.13 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.30 green:0.06 blue:0.21 alpha:1.0].CGColor,
            (id)[UIColor colorWithRed:0.07 green:0.01 blue:0.05 alpha:1.0].CGColor
        ];

        // 1. NẠP PLAYLIST ĐÃ LƯU TỪ TRƯỚC (HIỆN DANH SÁCH BÀI HÁT TỨC THÌ)
        NSArray *cachedPlay = [ud arrayForKey:PHL_DEC(PHL_CACHEDPLAYLIST)];
        if (cachedPlay && [cachedPlay isKindOfClass:[NSArray class]] && cachedPlay.count > 0) {
            [_playlist addObjectsFromArray:cachedPlay];
            _statusMsg = nil;
        }

        // 2. NẠP CONFIG ĐÃ LƯU TỪ TRƯỚC (CẢ NSUSERDEFAULTS VÀ TẬP TIN DỰ PHÒNG CỤC BỘ)
        NSDictionary *cachedCfg = [ud dictionaryForKey:PHL_DEC(PHL_CACHEDCONFIGJSON)];
        if (!cachedCfg) {
            NSString *backupPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"phl_admin_config_backup.json"];
            NSData *bData = [NSData dataWithContentsOfFile:backupPath];
            if (bData) {
                cachedCfg = [NSJSONSerialization JSONObjectWithData:bData options:0 error:nil];
            }
        }
        if (cachedCfg && [cachedCfg isKindOfClass:[NSDictionary class]]) {
            _cachedAdminConfig = cachedCfg;
            [self applyRemoteAdminConfig:cachedCfg];
        }

        [self configureAudioSession];

        // LẮNG NGHE NGẮT PHIÊN ÂM THANH (CUỘC GỌI ĐẾN / BÁO THỨC) ĐỂ TỰ ĐỘNG TIẾP TỤC PHÁT
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAudioSessionInterruption:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:nil];

        // LẮNG NGHE KHI APP MỞ LẠI / TỪ NỀN QUAY LẠI -> TIẾP TỤC CHUYỂN ĐỘNG NÚT & ĐỒNG BỘ CONFIG
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAppDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAppWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAppDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - XỬ LÝ CHUYỂN BÀI THÔNG MINH (BÀI HOT ĐẦU TIÊN • BỎ QUA ĐÃ PHÁT • CHỐNG IM LẶNG)

- (void)advanceToNextTrackAuto {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_isTransitioningTrack) return;
        self->_isTransitioningTrack = YES;

        if (self->_playlist.count == 0) {
            self->_isTransitioningTrack = NO;
            return;
        }

        // Chế độ lặp 1 bài nếu user bật Repeat One
        if (self->_repOne && self->_idx >= 0 && self->_idx < (NSInteger)self->_playlist.count) {
            [self playSongAtIndex:self->_idx];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self->_isTransitioningTrack = NO;
            });
            return;
        }

        // 1. Đánh dấu bài hiện tại vừa phát xong vào danh sách đã phát trong chu kỳ này
        if (self->_idx >= 0 && self->_idx < (NSInteger)self->_playlist.count) {
            NSDictionary *cur = self->_playlist[self->_idx];
            NSString *u = cur[@"url"];
            if (u && u.length > 0) {
                [self->_playedSongURLs addObject:u];
            }
        }

        NSInteger totalCount = (NSInteger)self->_playlist.count;

        // 2. Kiểm tra xem toàn bộ các bài hát trong danh sách đã được phát chưa
        BOOL allPlayed = YES;
        for (NSDictionary *song in self->_playlist) {
            NSString *u = song[@"url"];
            if (u && u.length > 0 && ![self->_playedSongURLs containsObject:u]) {
                allPlayed = NO;
                break;
            }
        }

        // 3. Nếu toàn bộ bài hát đã phát xong -> Reset chu kỳ và bắt đầu vòng lặp mới từ trên xuống
        if (allPlayed) {
            [self->_playedSongURLs removeAllObjects];
            // Không lặp lại ngay bài vừa mới kết thúc nếu danh sách có nhiều hơn 1 bài
            if (self->_idx >= 0 && self->_idx < (NSInteger)self->_playlist.count && totalCount > 1) {
                NSDictionary *cur = self->_playlist[self->_idx];
                NSString *u = cur[@"url"];
                if (u && u.length > 0) [self->_playedSongURLs addObject:u];
            }
        }

        // 4. Tìm bài tiếp theo từ trên xuống dưới (từ _idx + 1 trở đi) chưa phát lần nào trong chu kỳ này
        NSInteger chosenIndex = NSNotFound;
        for (NSInteger step = 1; step <= totalCount; step++) {
            NSInteger candidate = (self->_idx + step) % totalCount;
            NSDictionary *candSong = self->_playlist[candidate];
            NSString *candUrl = candSong[@"url"];
            if (candUrl && candUrl.length > 0 && ![self->_playedSongURLs containsObject:candUrl]) {
                chosenIndex = candidate;
                break;
            }
        }

        // 5. Dự phòng an toàn: nếu không tìm thấy thì chuyển bài theo modulo
        if (chosenIndex == NSNotFound) {
            [self->_playedSongURLs removeAllObjects];
            chosenIndex = (self->_idx + 1) % totalCount;
        }

        // 6. Phát bài tiếp theo
        [self playSongAtIndex:chosenIndex];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self->_isTransitioningTrack = NO;
        });
    });
}

- (void)handleItemDidFinish:(NSNotification *)note {
    [self advanceToNextTrackAuto];
}

- (void)handleItemFailedToPlay:(NSNotification *)note {
    // Tự động bỏ qua bài lỗi và phát bài tiếp theo ngay lập tức
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_idx >= 0 && self->_idx < (NSInteger)self->_playlist.count) {
            NSDictionary *cur = self->_playlist[self->_idx];
            NSString *u = cur[PHL_DEC(URL)];
            if (u && u.length > 0) [self->_playedSongURLs addObject:u];
        }
        [self advanceToNextTrackAuto];
    });
}

#pragma mark - 🛡️ WATCHDOG CHỐNG IM LẶNG (CHỐNG LỖI MẤT KẾT NỐI / RƠI RỤNG NOTIFICATION)

- (void)startPlaybackWatchdog {
    if (_playbackWatchdogTimer) {
        [_playbackWatchdogTimer invalidate];
        _playbackWatchdogTimer = nil;
    }
    _playbackWatchdogTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                              target:self
                                                            selector:@selector(checkPlaybackWatchdog)
                                                            userInfo:nil
                                                             repeats:YES];
}

- (void)checkPlaybackWatchdog {
    if (!_player || !_playerItem) return;
    if (_pausedByYouTube) return; // YouTube đang phát -> không can thiệp

    // 1. Nếu item bị lỗi mạng (404/SSL/hết hạn) -> Chuyển ngay bài tiếp theo
    if (_playerItem.status == AVPlayerItemStatusFailed) {
        [self handleItemFailedToPlay:nil];
        return;
    }

    // 2. Kiểm tra nếu thời gian chạy đã chạm hoặc vượt quá thời lượng bài hát
    CMTime cur = _player.currentTime;
    CMTime dur = _playerItem.duration;
    if (CMTIME_IS_VALID(cur) && CMTIME_IS_VALID(dur) && dur.value > 0) {
        Float64 cSec = CMTimeGetSeconds(cur);
        Float64 dSec = CMTimeGetSeconds(dur);
        if (dSec > 1.5 && cSec >= (dSec - 0.45)) {
            // Đã hết bài nhưng hệ điều hành không bắn notification -> Watchdog chủ động chuyển bài!
            [self advanceToNextTrackAuto];
            return;
        }
    }

    // 3. Đồng bộ nút UI Play/Pause
    [self syncPlayPauseButton];
}

- (void)handleAudioSessionInterruption:(NSNotification *)note {
    NSNumber *type = note.userInfo[AVAudioSessionInterruptionTypeKey];
    if (!type) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([type unsignedIntegerValue] == AVAudioSessionInterruptionTypeBegan) {
            if (self->_player && self->_player.rate > 0.01f) {
                [self->_player pause];
                [self syncPlayPauseButton];
            }
        } else if ([type unsignedIntegerValue] == AVAudioSessionInterruptionTypeEnded) {
            NSNumber *opt = note.userInfo[AVAudioSessionInterruptionOptionKey];
            if (opt && ([opt unsignedIntegerValue] & AVAudioSessionInterruptionOptionShouldResume)) {
                if (self->_player && self->_playerItem) {
                    [self configureAudioSession];
                    [self->_player play];
                    [self syncPlayPauseButton];
                }
            }
        }
    });
}

- (void)configureAudioSession {
    NSError *err = nil;
    AVAudioSession *s = [AVAudioSession sharedInstance];
    [s setCategory:AVAudioSessionCategoryPlayback withOptions:(AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionAllowAirPlay) error:&err];
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
    [[NSUserDefaults standardUserDefaults] setFloat:_gain forKey:PHL_DEC(PHL_INDEPENDENTAUDIOGAIN)];

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
                                                   timeoutInterval:6.0];
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
    if (_pendingNeonColor) {
        _floatBtn.layer.borderColor = _pendingNeonColor.CGColor;
    }
    [self ensureFloatingButtonPulseAnimation];
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
    CGFloat fH = 48.0f;

    if (exp) {
        // === YouTube mode: ẩn transport + volume controls để YouTube chiếm toàn bộ không gian ===
        _btnPrev.hidden = YES;    _btnPrev.frame = CGRectZero;
        _btnPlay.hidden = YES;    _btnPlay.frame = CGRectZero;
        _btnNext.hidden = YES;    _btnNext.frame = CGRectZero;
        _btnRep.hidden = YES;     _btnRep.frame = CGRectZero;
        _btnMute.hidden = YES;    _btnMute.frame = CGRectZero;
        _volSlider.hidden = YES;  _volSlider.frame = CGRectZero;
        _btnVolUp.hidden = YES;   _btnVolUp.frame = CGRectZero;
        _gainLbl.hidden = YES;    _gainLbl.frame = CGRectZero;

        // Nút toggle YouTube được đẩy lên sát header
        _btnWebToggle.frame = CGRectMake(padX, cy, inW, 23.0f);
        cy += 27.0f;
    } else {
        // === Music mode: hiện lại transport + volume controls ===
        _btnPrev.hidden = NO; _btnPlay.hidden = NO; _btnNext.hidden = NO; _btnRep.hidden = NO;
        _btnMute.hidden = NO; _volSlider.hidden = NO; _btnVolUp.hidden = NO; _gainLbl.hidden = NO;

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
    }

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

    _menuBox.transform = CGAffineTransformIdentity;

    CGFloat sW = w.bounds.size.width;
    CGFloat sH = w.bounds.size.height;

    CGFloat cW = MIN(312.0f, sW - 30.0f);
    if (cW < 260.0f) cW = MAX(240.0f, sW - 16.0f);

    CGFloat eW = MIN(580.0f, MAX(cW, sW - 60.0f));

    CGFloat maxH = MAX(240.0f, sH - 24.0f);
    CGFloat cH = MIN(320.0f, maxH);
    // FIX v2.3: YouTube expanded → tối đa chiều cao màn hình (trừ 24pt safe area)
    // để webview to ra dễ nhìn hơn (trước chỉ 330pt, nay dùng gần hết màn hình)
    CGFloat eH = maxH;

    CGFloat tW = exp ? eW : cW;
    CGFloat tH = exp ? eH : cH;

    CGFloat curX = _menuBox.frame.origin.x;
    CGFloat maxX = MAX(8.0f, sW - tW - 8.0f);
    CGFloat tX = exp ? MIN(maxX, MAX(16.0f, (sW - tW) * 0.5f)) : MAX(8.0f, MIN(maxX, curX));
    CGFloat tY = exp ? 12.0f : MAX(12.0f, MIN(sH - tH - 12.0f, _menuBox.frame.origin.y));

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
        if (!kw) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self initializeFramework];
            });
            return;
        }

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
            UIColor *initNeon = self->_pendingNeonColor ?: [UIColor colorWithRed:1.0 green:0.52 blue:0.75 alpha:1.0];
            self->_floatBtn.layer.borderColor = initNeon.CGColor;
            self->_floatBtn.backgroundColor = [UIColor colorWithRed:0.12 green:0.02 blue:0.08 alpha:0.96];
            [self->_floatBtn setTitle:@"👑" forState:UIControlStateNormal];
            self->_floatBtn.titleLabel.font = [UIFont systemFontOfSize:22];
            [self->_floatBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];

            UIPanGestureRecognizer *p = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleFloatingPan:)];
            [self->_floatBtn addGestureRecognizer:p];
            [kw addSubview:self->_floatBtn];
            [self loadRemoteLogo];
            [self ensureFloatingButtonPulseAnimation];
        } else if (self->_floatBtn.superview != kw) {
            [kw addSubview:self->_floatBtn];
            [self ensureFloatingButtonPulseAnimation];
        }

        if (!self->_menuBox) {
            self->_menuBox = [[UIView alloc] initWithFrame:CGRectMake(70, 16, mW, mH)];
            self->_menuBox.backgroundColor = [UIColor colorWithRed:0.10 green:0.02 blue:0.07 alpha:0.98];
            self->_menuBox.layer.cornerRadius = 16;
            self->_menuBox.layer.borderWidth = 1.6;
            UIColor *initNeon = self->_pendingNeonColor ?: [UIColor colorWithRed:1.0 green:0.52 blue:0.75 alpha:1.0];
            self->_menuBox.layer.borderColor = initNeon.CGColor;
            self->_menuBox.clipsToBounds = YES;
            self->_menuBox.hidden = YES;
            self->_menuBox.alpha = 0.0;

            self->_gradient = [CAGradientLayer layer];
            self->_gradient.frame = CGRectMake(0, 0, mW, mH);
            self->_gradient.colors = self->_pendingGradientColors ?: @[
                (id)[UIColor colorWithRed:0.18 green:0.03 blue:0.13 alpha:1.0].CGColor,
                (id)[UIColor colorWithRed:0.30 green:0.06 blue:0.21 alpha:1.0].CGColor,
                (id)[UIColor colorWithRed:0.07 green:0.01 blue:0.05 alpha:1.0].CGColor
            ];
            self->_gradient.startPoint = CGPointMake(0.0f, 0.0f);
            self->_gradient.endPoint = CGPointMake(1.0f, 1.0f);
            [self->_menuBox.layer insertSublayer:self->_gradient atIndex:0];

            self->_dragHdr = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mW, 48)];
            self->_dragHdr.backgroundColor = [UIColor colorWithRed:0.25 green:0.05 blue:0.18 alpha:0.88];
            [self->_menuBox addSubview:self->_dragHdr];

            UIPanGestureRecognizer *hp = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMenuHeaderPan:)];
            [self->_dragHdr addGestureRecognizer:hp];

            self->_headerTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, mW - 48, 15)];
            // FIX v2.3: Dùng pending value từ config nếu đã có, không hardcode tên sai
            self->_headerTitleLbl.text = (self->_pendingHeaderTitle.length > 0)
                ? self->_pendingHeaderTitle
                : @"👑 PHẠM LONG • AUDIO PRO";
            self->_headerTitleLbl.textColor = [UIColor colorWithRed:1.0 green:0.82 blue:1.0 alpha:1.0];
            self->_headerTitleLbl.font = [UIFont systemFontOfSize:11.5 weight:UIFontWeightHeavy];
            [self->_dragHdr addSubview:self->_headerTitleLbl];

            self->_tickerLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 19, mW - 48, 12)];
            // FIX v2.3: Dùng pending value từ config nếu đã có
            self->_tickerLbl.text = (self->_pendingTickerText.length > 0)
                ? self->_pendingTickerText
                : @"⚡ AUDIO PRO CHUYÊN NGHIỆP ⚡";
            self->_tickerLbl.textColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.4 alpha:1.0];
            self->_tickerLbl.font = [UIFont systemFontOfSize:8.5 weight:UIFontWeightBold];
            [self->_dragHdr addSubview:self->_tickerLbl];

            self->_titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, mW - 44, 13)];
            self->_titleLbl.textColor = [UIColor colorWithRed:0.38 green:1.0 blue:0.82 alpha:1.0];
            self->_titleLbl.font = [UIFont systemFontOfSize:9.5 weight:UIFontWeightSemibold];
            [self->_dragHdr addSubview:self->_titleLbl];
            if (self->_idx >= 0 && self->_idx < (NSInteger)self->_playlist.count) {
                [self updateTitleLabelForCurrentSong];
            } else {
                self->_titleLbl.text = @"♪ Đang sẵn sàng nạp nhạc VIP...";
            }

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

            NSString *ytInitTitle = self->_isYouTubeEnabled ? @"🎬 YOUTUBE PRO (BẤM MỞ)" : @"🚫 YOUTUBE (TẠM KHÓA)";
            UIColor *ytInitColor = self->_isYouTubeEnabled ? [UIColor colorWithRed:0.65 green:0.98 blue:1.0 alpha:1.0] : [UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0];
            UIColor *ytInitBorder = self->_isYouTubeEnabled ? [UIColor colorWithRed:0.38 green:0.95 blue:1.0 alpha:0.9] : [UIColor redColor];

            self->_btnWebToggle = [self makeUtilityButtonWithTitle:ytInitTitle
                                                              fontSize:9.0
                                                               bgColor:[UIColor colorWithRed:0.12 green:0.24 blue:0.48 alpha:0.95]
                                                           borderColor:ytInitBorder
                                                                action:@selector(toggleEmbeddedBrowser)];
            [self->_btnWebToggle setTitleColor:ytInitColor forState:UIControlStateNormal];
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
            [ucc addScriptMessageHandler:proxy name:PHL_DEC(PHLWEBMEDIAPLAYING)];
            // FIX v2.2: Thêm handler phlWebMediaPaused để biết YouTube đã dừng hết
            [ucc addScriptMessageHandler:proxy name:PHL_DEC(PHLWEBMEDIAPAUSED)];

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
            // FIX v2.3: Dùng pending value từ config nếu đã có, không hardcode nội dung cũ
            self->_cprLbl.text = (self->_pendingFooterText.length > 0)
                ? self->_pendingFooterText
                : @"BẢN QUYỀN ĐỘC QUYỀN PHẠM LONG\nZALO: 0522608620 • TELEGRAM: @PHL0990";
            self->_cprLbl.textColor = [UIColor colorWithRed:1.0 green:0.86 blue:0.55 alpha:0.98];
            self->_cprLbl.font = [UIFont systemFontOfSize:8 weight:UIFontWeightBold];
            self->_cprLbl.textAlignment = NSTextAlignmentCenter;
            self->_cprLbl.numberOfLines = 2;
            [self->_menuBox addSubview:self->_cprLbl];

            // FIX v2.5: ÁP DỤNG TRỌN VẸN CONFIG & THEME NGAY KHI UI VỪA SẴN SÀNG
            // (Khắc phục triệt để lỗi mất màu hồng và đơ icon khi thoát ra vào lại game)
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *configToApply = self->_cachedAdminConfig ?: [[NSUserDefaults standardUserDefaults] dictionaryForKey:PHL_DEC(PHL_CACHEDCONFIGJSON)];
                if (configToApply && [configToApply isKindOfClass:[NSDictionary class]]) {
                    [self applyRemoteAdminConfig:configToApply];
                } else {
                    if (self->_pendingHeaderTitle.length > 0) {
                        self->_headerTitleLbl.text = self->_pendingHeaderTitle;
                    }
                    if (self->_pendingTickerText.length > 0) {
                        self->_tickerLbl.text = self->_pendingTickerText;
                    }
                    if (self->_pendingFooterText.length > 0) {
                        self->_cprLbl.text = self->_pendingFooterText;
                    }
                    if (self->_pendingAdminBtnText.length > 0) {
                        [self->_adminBtn setTitle:self->_pendingAdminBtnText forState:UIControlStateNormal];
                    }
                    [self ensureFloatingButtonPulseAnimation];
                }
            });

            [self layoutMenuSubviewsWithWidth:mW height:mH expanded:NO];
            [self applyIndependentGain:self->_gain];
            [kw addSubview:self->_menuBox];
        } else if (self->_menuBox.superview != kw) {
            [kw addSubview:self->_menuBox];
        }

        [self fetchRemotePlaylist];
        [self fetchRemoteAdminConfig];
        [self syncPlayPauseButton];
        [self startPlaybackWatchdog];

        // ĐỒNG BỘ THÔNG MINH: CHỐNG CHẠM HẠN MỨC GITHUB VÀ TIẾT KIỆM PIN TỐI ĐA
        if (!self->_autoSyncTimer) {
            self->_autoSyncTimer = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(fetchRemoteAdminConfig) userInfo:nil repeats:YES];
        }
    });
}

#pragma mark - BỘ ĐỒNG BỘ ZERO-LATENCY (CÔNG NGHỆ DIRECT GIT PROTOCOL • KHÔNG HẠN MỨC RATE LIMIT)

- (void)fetchRemoteAdminConfig {
    if (_isSyncingConfig) return;
    _isSyncingConfig = YES;

    // TẦNG 1: DÙNG GIT WIRE PROTOCOL LẤY COMMIT SHA TRỰC TIẾP
    NSString *refsUrlStr = PHL_DecryptString(kEnc_GIT_INFO_REFS, kLen_GIT_INFO_REFS);
    NSURL *refsUrl = [NSURL URLWithString:refsUrlStr];
    if (!refsUrl) {
        _isSyncingConfig = NO;
        [self fallbackFetchApiConfig];
        return;
    }

    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:refsUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:4.0];
    [req setValue:@"PHL-Engine/1.0" forHTTPHeaderField:@"User-Agent"];
    [req setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];

    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        NSHTTPURLResponse *hr = (NSHTTPURLResponse *)r;
        if (!e && d && hr.statusCode == 200) {
            NSString *rawText = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
            if (rawText && rawText.length > 0) {
                NSRange headRange = [rawText rangeOfString:@" HEAD"];
                if (headRange.location != NSNotFound && headRange.location >= 40) {
                    NSString *sha = [rawText substringWithRange:NSMakeRange(headRange.location - 40, 40)];
                    NSCharacterSet *hexChars = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefABCDEF"];
                    if (sha.length == 40 && [sha rangeOfCharacterFromSet:[hexChars invertedSet]].location == NSNotFound) {
                        // NẾU COMMIT SHA KHÔNG ĐỔI -> DỮ LIỆU ĐANG MỚI NHẤT, KHÔNG CẦN TẢI LẠI
                        if (self->_lastKnownCommitSHA && [sha isEqualToString:self->_lastKnownCommitSHA]) {
                            self->_isSyncingConfig = NO;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self ensureFloatingButtonPulseAnimation];
                                if (self->_cachedAdminConfig) {
                                    [self applyRemoteAdminConfig:self->_cachedAdminConfig];
                                }
                            });
                            return;
                        }

                        // COMMIT MỚI CỦA ADMIN: TẢI TRỰC TIẾP THEO SHA (BỎ QUA 100% CACHE 5 PHÚT FASTLY CDN)
                        NSString *rawBase = PHL_DecryptString(kEnc_GITHUB_RAW_BASE, kLen_GITHUB_RAW_BASE);
                        NSString *shaCfgUrl = [NSString stringWithFormat:@"%@%@/config.json", rawBase, sha];
                        [self downloadConfigFromURL:[NSURL URLWithString:shaCfgUrl] commitSHA:sha];
                        return;
                    }
                }
            }
        }

        // TẦNG DỰ PHÒNG NẾU GIT PROTOCOL GẶP SỰ CỐ MẠNG
        [self fallbackFetchApiConfig];
    }] resume];
}

- (void)downloadConfigFromURL:(NSURL *)url commitSHA:(NSString *)sha {
    if (!url) {
        _isSyncingConfig = NO;
        return;
    }
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [req setValue:@"PHL-Engine/1.0" forHTTPHeaderField:@"User-Agent"];
    [req setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];

    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        self->_isSyncingConfig = NO;
        NSHTTPURLResponse *hr = (NSHTTPURLResponse *)r;
        if (!e && d && hr.statusCode == 200) {
            NSError *jsonErr = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:d options:0 error:&jsonErr];
            if (!jsonErr && [dict isKindOfClass:[NSDictionary class]] && (dict[PHL_DEC(SYSTEM_CONTROL)] || dict[PHL_DEC(YOUTUBE_MODULE)])) {
                if (sha && sha.length == 40) {
                    self->_lastKnownCommitSHA = sha;
                    [[NSUserDefaults standardUserDefaults] setObject:sha forKey:PHL_DEC(PHL_LASTCOMMITSHA)];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self applyRemoteAdminConfig:dict];
                });
                return;
            }
        }
        [self fallbackFetchApiConfig];
    }] resume];
}

- (void)fallbackFetchApiConfig {
    NSString *apiUrlStr = PHL_DecryptString(kEnc_GITHUB_API_CFG, kLen_GITHUB_API_CFG);
    NSURL *apiUrl = [NSURL URLWithString:apiUrlStr];
    if (!apiUrl) {
        _isSyncingConfig = NO;
        [self fallbackFetchDirectRawConfig];
        return;
    }

    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:apiUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [req setValue:@"PHL-Engine/1.0" forHTTPHeaderField:@"User-Agent"];
    [req setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    if (_lastConfigETag && _lastConfigETag.length > 0) {
        [req setValue:_lastConfigETag forHTTPHeaderField:@"If-None-Match"];
    }

    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        NSHTTPURLResponse *hr = (NSHTTPURLResponse *)r;
        if (hr && hr.statusCode == 304) {
            self->_isSyncingConfig = NO;
            return;
        }

        if (!e && d && hr && hr.statusCode == 200) {
            self->_isSyncingConfig = NO;
            NSString *etag = hr.allHeaderFields[@"ETag"];
            if (etag) {
                self->_lastConfigETag = etag;
                [[NSUserDefaults standardUserDefaults] setObject:etag forKey:PHL_DEC(PHL_LASTCONFIGETAG)];
            }

            NSDictionary *apiJson = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            NSString *base64Str = apiJson[@"content"];
            if (base64Str && [base64Str isKindOfClass:[NSString class]]) {
                NSString *clean = [base64Str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                clean = [clean stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                NSData *decoded = [[NSData alloc] initWithBase64EncodedString:clean options:0];
                if (decoded) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:decoded options:0 error:nil];
                    if ([dict isKindOfClass:[NSDictionary class]] && (dict[PHL_DEC(SYSTEM_CONTROL)] || dict[PHL_DEC(YOUTUBE_MODULE)])) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self applyRemoteAdminConfig:dict];
                        });
                        return;
                    }
                }
            }
        }

        [self fallbackFetchDirectRawConfig];
    }] resume];
}

- (void)fallbackFetchDirectRawConfig {
    NSString *rawUrlStr = PHL_DecryptString(kEnc_GITHUB_RAW_CFG, kLen_GITHUB_RAW_CFG);
    NSURL *rawUrl = [NSURL URLWithString:rawUrlStr];
    if (!rawUrl) {
        _isSyncingConfig = NO;
        return;
    }
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:rawUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [req setValue:@"PHL-Engine/1.0" forHTTPHeaderField:@"User-Agent"];
    [req setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];

    [[[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        self->_isSyncingConfig = NO;
        NSHTTPURLResponse *hr = (NSHTTPURLResponse *)r;
        if (!e && d && hr && hr.statusCode == 200) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:d options:0 error:nil];
            if ([dict isKindOfClass:[NSDictionary class]] && (dict[PHL_DEC(SYSTEM_CONTROL)] || dict[PHL_DEC(YOUTUBE_MODULE)])) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self applyRemoteAdminConfig:dict];
                });
            }
        }
    }] resume];
}

- (void)applyRemoteAdminConfig:(NSDictionary *)dict {
    PHL_OPAQUE_GUARD();
    // CHẶN HOÀN TOÀN CÁC GÓI TIN LỖI 403 HOẶC ĐỊNH DẠNG KHÔNG CHUẨN
    if (![dict isKindOfClass:[NSDictionary class]]) return;
    if (!dict[PHL_DEC(SYSTEM_CONTROL)] && !dict[PHL_DEC(YOUTUBE_MODULE)]) return;

    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self applyRemoteAdminConfig:dict];
        });
        return;
    }

    // LƯU CẤU HÌNH HỢP LỆ VÀO BỘ NHỚ CỤC BỘ ĐỂ CHỐNG LỖI MỞ LẠI KHI KHỞI ĐỘNG
    _cachedAdminConfig = dict;
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:PHL_DEC(PHL_CACHEDCONFIGJSON)];
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSString *backupPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"phl_admin_config_backup.json"];
    NSData *backupData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    if (backupData) {
        [backupData writeToFile:backupPath atomically:YES];
    }

    // 1. MASTER KILL-SWITCH
    if ([dict[PHL_DEC(SYSTEM_CONTROL)][PHL_DEC(KILL_SWITCH)] boolValue]) {
        [self pauseStreamPlayerIfPlaying];
        [self pauseWebMediaIfPlaying];
        _menuOpen = NO;
        _webOpen = NO;
        if (_floatBtn) _floatBtn.hidden = YES;
        if (_menuBox) _menuBox.hidden = YES;
        return;
    } else if (_floatBtn) {
        _floatBtn.hidden = NO;
    }

    // 2. TÙY BIẾN NÚT NỔI & HIỆU ỨNG THỞ PHÁT SÁNG
    NSString *fIcon = dict[PHL_DEC(SYSTEM_CONTROL)][PHL_DEC(FLOATING_ICON)];
    if (fIcon && fIcon.length > 0 && _floatBtn) {
        if (!_floatBtn.currentImage) {
            [_floatBtn setTitle:fIcon forState:UIControlStateNormal];
        }
    }
    if (dict[PHL_DEC(SYSTEM_CONTROL)][PHL_DEC(FLOATING_PULSE_GLOW)] != nil) {
        _enablePulseGlow = [dict[PHL_DEC(SYSTEM_CONTROL)][PHL_DEC(FLOATING_PULSE_GLOW)] boolValue];
    }
    [self ensureFloatingButtonPulseAnimation];

    // 3. ĐỔI MÀU NEON THEME & GRADIENT
    NSDictionary *th = dict[PHL_DEC(THEME_CUSTOMIZER)];
    if (th) {
        UIColor *neon = ColorFromHex(th[PHL_DEC(NEON_BORDER_COLOR)], [UIColor colorWithRed:1.0 green:0.52 blue:0.75 alpha:1.0]);
        _pendingNeonColor = neon;
        if (_menuBox) _menuBox.layer.borderColor = neon.CGColor;
        if (_floatBtn) _floatBtn.layer.borderColor = neon.CGColor;
        if (_searchBar) _searchBar.layer.borderColor = [neon colorWithAlphaComponent:0.75].CGColor;
        if (_adminBtn) _adminBtn.layer.borderColor = neon.CGColor;
        if (_table) _table.separatorColor = [neon colorWithAlphaComponent:0.25];

        UIColor *cStart = ColorFromHex(th[PHL_DEC(GRADIENT_START_COLOR)], [UIColor colorWithRed:0.18 green:0.03 blue:0.13 alpha:1.0]);
        UIColor *cMid = ColorFromHex(th[PHL_DEC(GRADIENT_MID_COLOR)], [UIColor colorWithRed:0.30 green:0.06 blue:0.21 alpha:1.0]);
        UIColor *cEnd = ColorFromHex(th[PHL_DEC(GRADIENT_END_COLOR)], [UIColor colorWithRed:0.07 green:0.01 blue:0.05 alpha:1.0]);
        _pendingGradientColors = @[(id)cStart.CGColor, (id)cMid.CGColor, (id)cEnd.CGColor];
        if (_gradient) _gradient.colors = _pendingGradientColors;
    }

    // 4. TIÊU ĐỀ, MARQUEE TICKER & NÚT ADMIN
    NSDictionary *brand = dict[PHL_DEC(BRANDING)];
    if (brand) {
        // FIX v2.3: Luôn lưu vào biến pending trước
        // Nếu UI đã tồn tại thì apply ngay, nếu chưa thì initializeFramework sẽ apply sau
        if (brand[PHL_DEC(HEADER_TITLE)]) {
            _pendingHeaderTitle = brand[PHL_DEC(HEADER_TITLE)];
            if (_headerTitleLbl) _headerTitleLbl.text = _pendingHeaderTitle;
        }
        if (brand[PHL_DEC(TICKER_ANNOUNCEMENT)]) {
            _pendingTickerText = brand[PHL_DEC(TICKER_ANNOUNCEMENT)];
            if (_tickerLbl) _tickerLbl.text = _pendingTickerText;
        }
        if (brand[PHL_DEC(ADMIN_BUTTON_TEXT)]) {
            _pendingAdminBtnText = brand[PHL_DEC(ADMIN_BUTTON_TEXT)];
            if (_adminBtn) [_adminBtn setTitle:_pendingAdminBtnText forState:UIControlStateNormal];
        }
        if (brand[PHL_DEC(ADMIN_BUTTON_URL)]) _adminTargetURL = brand[PHL_DEC(ADMIN_BUTTON_URL)];
        if (brand[PHL_DEC(FOOTER_COPYRIGHT)]) {
            _pendingFooterText = brand[PHL_DEC(FOOTER_COPYRIGHT)];
            if (_cprLbl) _cprLbl.text = _pendingFooterText;
        }
    }

    // 5. CÔNG SUẤT ÂM LƯỢNG (TỐI ĐA 300%)
    NSDictionary *audioCfg = dict[PHL_DEC(AUDIO_ENGINE)];
    if (audioCfg && audioCfg[PHL_DEC(MAX_GAIN)]) {
        _maxAllowedGain = [audioCfg[PHL_DEC(MAX_GAIN)] floatValue];
        _volSlider.maximumValue = _maxAllowedGain;
    }

    // 6. GHIM BÀI HÁT HOT TREND VIP
    NSDictionary *feat = dict[PHL_DEC(VIP_FEATURED_SONG)];
    if (feat && [feat[PHL_DEC(ENABLED)] boolValue]) {
        _featuredVipSong = feat;
        [self injectFeaturedSongIntoPlaylist];
    }

    // 7. QUẢN LÝ KHÓA / MỞ YOUTUBE TỨC THÌ (XỬ LÝ TRIỆT ĐỂ LỖI MỞ LẠI NGOÀI Ý MUỐN)
    NSDictionary *ytCfg = dict[PHL_DEC(YOUTUBE_MODULE)];
    if (ytCfg) {
        if (ytCfg[PHL_DEC(ENABLED)] != nil) {
            _isYouTubeEnabled = [ytCfg[PHL_DEC(ENABLED)] boolValue];
            [[NSUserDefaults standardUserDefaults] setBool:_isYouTubeEnabled forKey:@"PHL_Cached_YT_Enabled"];
        }
        if (ytCfg[PHL_DEC(HOME_URL)]) _youtubeHomeURL = ytCfg[PHL_DEC(HOME_URL)];
        if (ytCfg[PHL_DEC(LOCKED_REASON)]) _youtubeLockedMsg = ytCfg[PHL_DEC(LOCKED_REASON)];

        if (!_isYouTubeEnabled) {
            [_btnWebToggle setTitle:@"🚫 YOUTUBE (TẠM KHÓA)" forState:UIControlStateNormal];
            [_btnWebToggle setTitleColor:[UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0] forState:UIControlStateNormal];
            _btnWebToggle.layer.borderColor = [UIColor redColor].CGColor;

            // NẾU ADMIN ĐÃ KHÓA -> DỪNG NGAY MEDIA VÀ THU HẸP GIAO DIỆN VỀ MENU NHẠC
            [self pauseWebMediaIfPlaying];
            if (_webOpen) {
                _webOpen = NO;
                _webBox.hidden = YES;
                _table.hidden = NO;
                [self applyMenuFrameForExpanded:NO animated:YES];
            } else {
                _webBox.hidden = YES;
                _table.hidden = NO;
            }
        } else {
            [_btnWebToggle setTitleColor:[UIColor colorWithRed:0.65 green:0.98 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            _btnWebToggle.layer.borderColor = [UIColor colorWithRed:0.38 green:0.95 blue:1.0 alpha:0.9].CGColor;
            NSString *t = _webOpen ? @"☰ ĐANG MỞ YOUTUBE • VỀ KHO NHẠC (THU GỌN)" : @"🌐 MỞ YOUTUBE VIP (ZERO ADS)";
            [_btnWebToggle setTitle:t forState:UIControlStateNormal];
        }
    }

    // 8. POPUP THÔNG BÁO TỪ ADMIN — CHỈ HIỆN 1 LẦN KHI MỞ ỨNG DỤNG
    NSDictionary *ann = dict[PHL_DEC(ANNOUNCEMENT)];
    if (ann && [ann[@"show"] boolValue]) {
        _cachedAnnouncement = ann;
        if (!_hasShownLaunchAnnouncement) {
            _hasShownLaunchAnnouncement = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAnnouncementPopup];
            });
        }
    } else {
        _cachedAnnouncement = nil;
    }
}

- (void)showAnnouncementPopup {
    if (!_cachedAnnouncement) return;
    if (![_cachedAnnouncement[@"show"] boolValue]) return;

    NSString *title = _cachedAnnouncement[@"title"] ?: @"👑 THÔNG BÁO TỪ ADMIN";
    NSString *msg = _cachedAnnouncement[@"message"] ?: @"";
    NSString *btnTitle = _cachedAnnouncement[@"button_title"] ?: @"Đã hiểu";
    NSString *link = _cachedAnnouncement[@"action_url"];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleCancel handler:nil]];
    if ([link isKindOfClass:[NSString class]] && link.length > 0) {
        [alert addAction:[UIAlertAction actionWithTitle:@"Xem ngay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link] options:@{} completionHandler:nil];
        }]];
    }

    UIWindow *w = [self resolveActiveWindow];
    if (!w) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showAnnouncementPopup];
        });
        return;
    }

    UIViewController *vc = w.rootViewController;
    while (vc.presentedViewController) {
        if ([vc.presentedViewController isKindOfClass:[UIAlertController class]]) {
            return;
        }
        vc = vc.presentedViewController;
    }
    if (vc) {
        [vc presentViewController:alert animated:YES completion:nil];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showAnnouncementPopup];
        });
    }
}

- (void)injectFeaturedSongIntoPlaylist {
    if (!_featuredVipSong || !_playlist) return;
    NSString *vTitle = _featuredVipSong[PHL_DEC(TITLE)];
    NSString *vUrl = _featuredVipSong[PHL_DEC(URL)];
    if (!vUrl || vUrl.length == 0) return;

    BOOL isHotDetected = NO;
    NSString *clean = [self cleanTitleForSong:vTitle isHot:&isHotDetected];

    // TÌM XEM BÀI HÁT ĐÃ TỒN TẠI TRONG DANH SÁCH CHƯA ĐỂ TRÁNH TRÙNG LẶP
    NSInteger existingIdx = NSNotFound;
    for (NSInteger i = 0; i < (NSInteger)_playlist.count; i++) {
        NSDictionary *it = _playlist[i];
        if ([it[PHL_DEC(URL)] isEqualToString:vUrl]) {
            existingIdx = i;
            break;
        }
    }

    NSMutableDictionary *featuredItem = [NSMutableDictionary dictionary];
    featuredItem[PHL_DEC(TITLE)] = clean;
    featuredItem[@"raw_title"] = vTitle ?: clean;
    featuredItem[PHL_DEC(URL)] = vUrl;
    featuredItem[PHL_DEC(IS_HOT)] = @(YES);

    if (existingIdx == 0) {
        _playlist[0] = featuredItem;
    } else {
        if (existingIdx != NSNotFound) {
            [_playlist removeObjectAtIndex:existingIdx];
            if (_idx == existingIdx) _idx = 0;
            else if (_idx > existingIdx) _idx--;
        }
        [_playlist insertObject:featuredItem atIndex:0];
    }

    [_table reloadData];

    // TỰ ĐỘNG PHÁT NHẠC VIP KHI VÀO ỨNG DỤNG NẾU ENABLED = TRUE
    if ([_featuredVipSong[PHL_DEC(ENABLED)] boolValue]) {
        if (!_hasAutoPlayedVip && _playlist.count > 0 && (!self->_player || self->_player.rate < 0.01f || self->_idx < 0)) {
            _hasAutoPlayedVip = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self playSongAtIndex:0];
            });
        }
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [self cleanYouTubePageInWebView];
}

- (void)userContentController:(WKUserContentController *)ucc didReceiveScriptMessage:(WKScriptMessage *)msg {
    if ([msg.name isEqualToString:PHL_DEC(PHLWEBMEDIAPLAYING)]) {
        // FIX v2.2: YouTube bắt đầu phát → dừng GitHub AVPlayer, đánh dấu _pausedByYouTube
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->_player && self->_player.rate > 0.01f) {
                // GitHub đang phát → phải dừng lại, lưu dấu để auto-resume khi tắt YT
                [self->_player pause];
                self->_pausedByYouTube = YES;
                [self syncPlayPauseButton];
            }
            // Nếu GitHub đã dừng sẵn rồi thì không set _pausedByYouTube
            // (tránh auto-resume khi user chủ động dừng GitHub trước)
        });
    } else if ([msg.name isEqualToString:PHL_DEC(PHLWEBMEDIAPAUSED)]) {
        // FIX v2.2: Tất cả media YouTube đã dừng → tự động resume GitHub nếu YT là nguyên nhân dừng
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->_pausedByYouTube && self->_player && self->_playerItem) {
                self->_pausedByYouTube = NO;
                [self configureAudioSession];
                [self->_player play];
                [self syncPlayPauseButton];
            }
        });
    }
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
    if (!_webOpen && _webBox.hidden) return;
    _webOpen = NO;
    [self pauseWebMediaIfPlaying];
    [_searchBar resignFirstResponder];
    [self syncBrowserVisibilityAnimated:YES];

    // FIX v2.2: Khi đóng YouTube → tự động resume GitHub nhạc nếu YouTube là lý do dừng
    if (_pausedByYouTube && _player && _playerItem) {
        _pausedByYouTube = NO;
        // Delay nhỏ để animation đóng YouTube hoàn tất trước khi phát lại
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self->_player && self->_playerItem && self->_player.rate < 0.01f) {
                [self configureAudioSession];
                [self->_player play];
                [self syncPlayPauseButton];
            }
        });
    }
}

- (void)syncBrowserVisibilityAnimated:(BOOL)animated {
    [self applyMenuFrameForExpanded:_webOpen animated:animated];
    _webBox.hidden = !_webOpen;
    _table.hidden = _webOpen;

    if (!_isYouTubeEnabled) {
        [_btnWebToggle setTitle:@"🚫 YOUTUBE (TẠM KHÓA)" forState:UIControlStateNormal];
        [_btnWebToggle setTitleColor:[UIColor colorWithRed:1.0 green:0.4 blue:0.4 alpha:1.0] forState:UIControlStateNormal];
        _btnWebToggle.layer.borderColor = [UIColor redColor].CGColor;
    } else {
        NSString *t = _webOpen ? @"☰ ĐANG MỞ YOUTUBE • VỀ KHO NHẠC (THU GỌN)" : @"🌐 MỞ YOUTUBE VIP (ZERO ADS)";
        [_btnWebToggle setTitle:t forState:UIControlStateNormal];
        [_btnWebToggle setTitleColor:[UIColor colorWithRed:0.65 green:0.98 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        _btnWebToggle.layer.borderColor = [UIColor colorWithRed:0.38 green:0.95 blue:1.0 alpha:0.9].CGColor;
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
        // NẾU YOUTUBE ĐANG BỊ KHÓA -> CHẮC CHẮN KHÔNG MỞ TRÌNH DUYỆT
        if (!_isYouTubeEnabled) {
            _webOpen = NO;
        }

        _menuBox.hidden = NO;
        _table.hidden = _webOpen;
        _webBox.hidden = !_webOpen;
        [self applyMenuFrameForExpanded:_webOpen animated:NO];
        _menuBox.transform = CGAffineTransformMakeScale(0.85, 0.85);
        [UIView animateWithDuration:0.22 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self->_menuBox.alpha = 1.0;
            self->_menuBox.transform = CGAffineTransformIdentity;
        } completion:nil];

        // ĐỒNG BỘ CONFIG & PLAYLIST TỨC THÌ KHI MỞ MENU
        [self fetchRemoteAdminConfig];
        [self fetchRemotePlaylist];
    } else {
        [_searchBar resignFirstResponder];
        // ĐÓNG MENU -> TỰ ĐỘNG THU GỌN WEB ĐỂ LẦN SAU MỞ LẠI SẼ HIỆN MENU NHẠC GỌN GÀNG
        _webOpen = NO;
        _webBox.hidden = YES;
        _table.hidden = NO;
        [self applyMenuFrameForExpanded:NO animated:NO];

        [UIView animateWithDuration:0.18 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self->_menuBox.alpha = 0.0;
            self->_menuBox.transform = CGAffineTransformMakeScale(0.85, 0.85);
        } completion:^(BOOL fin){
            self->_menuBox.hidden = YES;
            self->_menuBox.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)clampViewToSafeBounds:(UIView *)v topMargin:(CGFloat)tm bottomMargin:(CGFloat)bm {
    UIWindow *w = [self resolveActiveWindow];
    if (!w) return;
    CGSize sz = w.bounds.size;
    CGFloat vW = v.bounds.size.width;
    CGFloat vH = v.bounds.size.height;

    CGRect f = v.frame;
    CGFloat minX = 6.0f;
    CGFloat maxX = MAX(minX, sz.width - vW - 6.0f);
    if (f.origin.x < minX) f.origin.x = minX;
    else if (f.origin.x > maxX) f.origin.x = maxX;

    CGFloat minY = tm;
    CGFloat maxY = MAX(minY, sz.height - vH - bm);
    if (f.origin.y < minY) f.origin.y = minY;
    else if (f.origin.y > maxY) f.origin.y = maxY;

    v.frame = f;
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
    [self clampViewToSafeBounds:_menuBox topMargin:12.0f bottomMargin:12.0f];
    [p setTranslation:CGPointZero inView:_menuBox.superview];
}

#pragma mark - ĐẢM BẢO CHUYỂN ĐỘNG NÚT NỔI & KHÔI PHỤC KHI RA VÀO GAME

- (void)ensureFloatingButtonPulseAnimation {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self ensureFloatingButtonPulseAnimation];
        });
        return;
    }
    if (!_floatBtn) return;
    if (_enablePulseGlow) {
        CAAnimation *existing = [_floatBtn.layer animationForKey:PHL_DEC(PHL_PULSE_ANIM)];
        if (!existing) {
            CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            pulse.duration = 1.1;
            pulse.repeatCount = HUGE_VALF;
            pulse.autoreverses = YES;
            pulse.fromValue = @(1.0);
            pulse.toValue = @(1.14);
            pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pulse.removedOnCompletion = NO;
            pulse.fillMode = kCAFillModeForwards;
            [_floatBtn.layer addAnimation:pulse forKey:PHL_DEC(PHL_PULSE_ANIM)];
        }
    } else {
        [_floatBtn.layer removeAnimationForKey:PHL_DEC(PHL_PULSE_ANIM)];
    }
}

- (void)handleAppDidBecomeActive:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self ensureFloatingButtonPulseAnimation];
        NSDictionary *cfg = self->_cachedAdminConfig ?: [[NSUserDefaults standardUserDefaults] dictionaryForKey:PHL_DEC(PHL_CACHEDCONFIGJSON)];
        if (cfg) {
            [self applyRemoteAdminConfig:cfg];
        }
        [self fetchRemoteAdminConfig];
        // Kích hoạt nhịp tim đồng bộ ngầm định kỳ 30s khi đang chơi game
        if (!self->_autoSyncTimer) {
            self->_autoSyncTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(fetchRemoteAdminConfig) userInfo:nil repeats:YES];
        }
    });
}

- (void)handleAppWillEnterForeground:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self ensureFloatingButtonPulseAnimation];
        NSDictionary *cfg = self->_cachedAdminConfig ?: [[NSUserDefaults standardUserDefaults] dictionaryForKey:PHL_DEC(PHL_CACHEDCONFIGJSON)];
        if (cfg) {
            [self applyRemoteAdminConfig:cfg];
        }
    });
}

- (void)handleAppDidEnterBackground:(NSNotification *)note {
    // Tạm dừng timer khi ở chế độ nền để CHỐNG NÓNG MÁY & TIẾT KIỆM PIN 100%
    if (_autoSyncTimer) {
        [_autoSyncTimer invalidate];
        _autoSyncTimer = nil;
    }
}

- (void)fetchRemotePlaylist {
    NSURL *u = nil;
    if (_lastKnownCommitSHA && _lastKnownCommitSHA.length == 40) {
        NSString *rawBase = PHL_DecryptString(kEnc_GITHUB_RAW_BASE, kLen_GITHUB_RAW_BASE);
        u = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/playlist.json", rawBase, _lastKnownCommitSHA]];
    }
    if (!u) {
        u = [NSURL URLWithString:PHL_DecryptString(kEnc_GITHUB_RAW_PLAYLIST, kLen_GITHUB_RAW_PLAYLIST)];
    }
    if (!u) return;

    NSURLSessionConfiguration *c = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *s = [NSURLSession sessionWithConfiguration:c];

    NSURLSessionDataTask *t = [s dataTaskWithURL:u completionHandler:^(NSData *d, NSURLResponse *r, NSError *e) {
        NSHTTPURLResponse *hr = (NSHTTPURLResponse *)r;
        if (e || !d || hr.statusCode != 200) {
            // NẾU URL THEO SHA THẤT BẠI -> DỰ PHÒNG THEO RAW MAIN
            if (self->_lastKnownCommitSHA) {
                NSURL *fallbackU = [NSURL URLWithString:PHL_DecryptString(kEnc_GITHUB_RAW_PLAYLIST, kLen_GITHUB_RAW_PLAYLIST)];
                [[[NSURLSession sharedSession] dataTaskWithURL:fallbackU completionHandler:^(NSData *fd, NSURLResponse *fr, NSError *fe) {
                    if (!fe && fd && ((NSHTTPURLResponse *)fr).statusCode == 200) {
                        [self parseAndApplyPlaylistData:fd];
                    }
                }] resume];
            }
            return;
        }
        [self parseAndApplyPlaylistData:d];
    }];
    [t resume];
}

- (void)parseAndApplyPlaylistData:(NSData *)data {
    NSError *je = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&je];
    if (je || ![dict isKindOfClass:[NSDictionary class]]) return;

    NSArray *songs = dict[PHL_DEC(SONGS)] ?: dict[PHL_DEC(PLAYLIST)];
    if (![songs isKindOfClass:[NSArray class]] || songs.count == 0) return;

    // LƯU CACHE PLAYLIST VÀO BỘ NHỚ CỤC BỘ
    [[NSUserDefaults standardUserDefaults] setObject:songs forKey:PHL_DEC(PHL_CACHEDPLAYLIST)];

    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *curPlayingUrl = (self->_idx >= 0 && self->_idx < (NSInteger)self->_playlist.count)
            ? self->_playlist[self->_idx][PHL_DEC(URL)]
            : nil;

        [self->_playlist removeAllObjects];
        [self->_playlist addObjectsFromArray:songs];
        [self injectFeaturedSongIntoPlaylist];
        self->_statusMsg = nil;

        // Đồng bộ lại vị trí _idx theo URL bài hát đang phát nếu có
        if (curPlayingUrl) {
            for (NSInteger i = 0; i < (NSInteger)self->_playlist.count; i++) {
                if ([self->_playlist[i][PHL_DEC(URL)] isEqualToString:curPlayingUrl]) {
                    self->_idx = i;
                    break;
                }
            }
        }

        [self updateTitleLabelForCurrentSong];
        [self->_table reloadData];
    });
}

- (void)updateTitleLabelForCurrentSong {
    if (_idx < 0 || _idx >= (NSInteger)_playlist.count || !_titleLbl) return;
    NSDictionary *song = _playlist[_idx];
    NSString *rawTitle = song[PHL_DEC(TITLE)] ?: @"Đang phát";
    BOOL isHot = [song[PHL_DEC(IS_HOT)] boolValue];
    BOOL detectedHot = NO;
    NSString *clean = [self cleanTitleForSong:rawTitle isHot:&detectedHot];
    if (detectedHot) isHot = YES;

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"♪ %@ ", clean]
                                                                            attributes:@{
        NSForegroundColorAttributeName: [UIColor colorWithRed:0.38 green:1.0 blue:0.82 alpha:1.0],
        NSFontAttributeName: [UIFont systemFontOfSize:9.5 weight:UIFontWeightSemibold]
    }];

    if (isHot) {
        NSAttributedString *hotBadgeAttr = [[NSAttributedString alloc] initWithString:@" HOT "
                                                                           attributes:@{
            NSForegroundColorAttributeName: [UIColor colorWithRed:1.0 green:0.84 blue:0.18 alpha:1.0],
            NSFontAttributeName: [UIFont systemFontOfSize:7.5 weight:UIFontWeightHeavy],
            NSBackgroundColorAttributeName: [UIColor colorWithRed:1.0 green:0.84 blue:0.18 alpha:0.20]
        }];
        [attr appendAttributedString:hotBadgeAttr];
    }
    _titleLbl.attributedText = attr;
}

- (void)playSongAtIndex:(NSInteger)index {
    PHL_OPAQUE_GUARD();
    if (index < 0 || index >= (NSInteger)_playlist.count) return;
    _idx = index;

    NSDictionary *song = _playlist[index];
    NSString *uStr = song[PHL_DEC(URL)];
    if (!uStr || uStr.length == 0) return;

    NSURL *u = [NSURL URLWithString:uStr];
    if (!u) return;

    [self pauseWebMediaIfPlaying];
    [self configureAudioSession];
    // FIX v2.2: Người dùng chủ động bật nhạc GitHub → xóa flag pausedByYouTube
    _pausedByYouTube = NO;

    // FIX v2.4: Đánh dấu URL bài này đã được phát vào chu kỳ hiện tại
    if (uStr.length > 0) {
        [_playedSongURLs addObject:uStr];
    }

    // DỌN DẸP OBSERVER CŨ ĐỂ KHÔNG BỊ TRÙNG LẶP SKIPPING BÀI HÁT
    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:_playerItem];
    }

    _playerItem = [AVPlayerItem playerItemWithURL:u];

    // CHỈ ĐĂNG KÝ OBSERVER CHUYỂN BÀI DUY NHẤT CHO _playerItem HIỆN TẠI
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleItemDidFinish:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:_playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleItemFailedToPlay:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification
                                               object:_playerItem];

    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:_playerItem];
    } else {
        [_player replaceCurrentItemWithPlayerItem:_playerItem];
    }
    _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;

    [self applyIndependentGain:_gain];

    if (@available(iOS 10.0, *)) {
        [_player playImmediatelyAtRate:1.0f];
    } else {
        [_player play];
    }

    // CẬP NHẬT TIÊU ĐỀ NOW PLAYING VỚI BADGE VÀNG GOLD SANG TRỌNG
    [self updateTitleLabelForCurrentSong];

    [self syncPlayPauseButton];
    [_table reloadData];

    // TỰ ĐỘNG CUỘN ĐẾN BÀI HÁT ĐANG PHÁT TRONG DANH SÁCH
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->_table && self->_playlist.count > index) {
            [self->_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                atScrollPosition:UITableViewScrollPositionMiddle
                                        animated:YES];
        }
    });

    // KÍCH HOẠT WATCHDOG CHỐNG IM LẶNG
    [self startPlaybackWatchdog];
}

- (void)togglePlayPause {
    [_btnPlay triggerPulseMark];
    if (!_player || !_playerItem) {
        if (_playlist.count > 0) [self playSongAtIndex:MAX(0, _idx)];
        return;
    }
    if (_player.rate > 0.01f) {
        // User chủ động DỪNG GitHub → xóa flag để không auto-resume
        _pausedByYouTube = NO;
        [_player pause];
    } else {
        // User chủ động PHÁT GitHub → dừng YouTube, xóa flag
        _pausedByYouTube = NO;
        [self pauseWebMediaIfPlaying];
        [self configureAudioSession];
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
    [_btnNext triggerPulseMark];
    // CHUYỂN BÀI THÔNG MINH (BỎ QUA BÀI ĐÃ PHÁT, RESET KHI HẾT VÒNG)
    [self advanceToNextTrackAuto];
}

- (void)playPreviousSong {
    if (!_playlist.count) return;
    // LÙI BÀI (TỪ 1 QUAY VỀ BÀI CUỐI 10)
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
    [[NSUserDefaults standardUserDefaults] setBool:_repOne forKey:PHL_DEC(PHL_REPEATONESONG)];
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

    // BADGE "HOT" VÀNG NHỎ CHUYÊN NGHIỆP TRÊN TỪNG DÒNG BÀI HÁT
    UILabel *hotBadge = (UILabel *)[c.contentView viewWithTag:777];
    if (!hotBadge) {
        hotBadge = [[UILabel alloc] init];
        hotBadge.tag = 777;
        hotBadge.font = [UIFont systemFontOfSize:7.5 weight:UIFontWeightHeavy];
        hotBadge.textColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.18 alpha:1.0]; // Màu vàng kim loại #FFD700
        hotBadge.textAlignment = NSTextAlignmentCenter;
        hotBadge.backgroundColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.18 alpha:0.18]; // Nền vàng mờ tinh tế
        hotBadge.layer.borderColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.18 alpha:0.85].CGColor; // Viền vàng thanh mảnh
        hotBadge.layer.borderWidth = 0.8f;
        hotBadge.layer.cornerRadius = 3.5f;
        hotBadge.clipsToBounds = YES;
        hotBadge.text = @"HOT";
        [c.contentView addSubview:hotBadge];
    }

    if (_playlist.count == 0) {
        hotBadge.hidden = YES;
        c.textLabel.textColor = [UIColor colorWithRed:1.0 green:0.65 blue:0.75 alpha:1.0];
        c.textLabel.text = _statusMsg ?: @"Không có bài hát";
        c.detailTextLabel.textColor = [UIColor lightGrayColor];
        c.detailTextLabel.text = @"Chạm để thử tải lại";
        return c;
    }

    NSDictionary *song = _playlist[ip.row];
    NSString *rawTitle = song[PHL_DEC(TITLE)] ?: @"Bài hát chưa đặt tên";
    BOOL isHot = [song[PHL_DEC(IS_HOT)] boolValue];
    BOOL detectedHot = NO;
    NSString *cleanTitle = [self cleanTitleForSong:rawTitle isHot:&detectedHot];
    if (detectedHot) isHot = YES;

    BOOL isCur = (ip.row == _idx);

    c.textLabel.textColor = isCur ? [UIColor colorWithRed:1.0 green:0.65 blue:1.0 alpha:1.0] : [UIColor whiteColor];
    c.textLabel.text = cleanTitle;
    c.detailTextLabel.textColor = isCur ? [UIColor colorWithRed:0.35 green:1.0 blue:0.75 alpha:1.0] : [UIColor colorWithRed:0.45 green:0.92 blue:1.0 alpha:1.0];
    c.detailTextLabel.text = isCur ? @"🔊 Đang phát trực tiếp" : @"▶ Chạm để phát nhạc";

    if (isHot) {
        hotBadge.hidden = NO;
        CGSize sz = [cleanTitle sizeWithAttributes:@{NSFontAttributeName: c.textLabel.font}];
        CGFloat badgeW = 28.0f;
        CGFloat badgeH = 13.0f;
        CGFloat badgeX = 16.0f + sz.width + 6.0f;
        CGFloat maxBadgeX = tv.bounds.size.width - badgeW - 8.0f;
        if (badgeX > maxBadgeX) badgeX = maxBadgeX;
        hotBadge.frame = CGRectMake(badgeX, 6.0f, badgeW, badgeH);
    } else {
        hotBadge.hidden = YES;
    }

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

#pragma mark - Constructor Khởi Chạy (Khởi động tức thì 0 giây trễ)

__attribute__((constructor)) static void LibraryEntryPoint(void) {
    PHL_OPAQUE_GUARD();
    PHL_EnforceSecuritySanity();
    PHL_StartSecurityWatchdog();
    dispatch_async(dispatch_get_main_queue(), ^{
        [[PHLProtectedAudioManager sharedInstance] initializeFramework];
    });
}
