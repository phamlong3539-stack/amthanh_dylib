#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
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

@interface PHLProtectedAudioManager : NSObject <UITableViewDataSource, UITableViewDelegate> {
    AVPlayer *phlAudioPlayer;
    AVPlayerItem *phlPlayerItem;
    UIButton *phlFloatingBtn;
    UIView *phlMenuContainer;
    UITableView *phlTableView;
    NSMutableArray *phlPlaylist;
    NSString *phlStatusMessage;
    NSString *phlPlayingTitle;
    BOOL phlIsMenuOpen;
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
        phlPlaylist = [[NSMutableArray alloc] init];
        phlStatusMessage = @"Đang tải danh sách nhạc...";
        phlPlayingTitle = nil;
        phlIsMenuOpen = NO;
        [self configureAudioSession];
    }
    return self;
}

- (void)configureAudioSession {
    NSError *sessionError = nil;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
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
            phlFloatingBtn.frame = CGRectMake(25, 130, 50, 50);
            phlFloatingBtn.layer.cornerRadius = 25;
            phlFloatingBtn.clipsToBounds = YES;
            phlFloatingBtn.layer.borderWidth = 2.0;
            phlFloatingBtn.layer.borderColor = [UIColor colorWithRed:0.75 green:0.35 blue:1.0 alpha:1.0].CGColor;
            phlFloatingBtn.backgroundColor = [UIColor colorWithRed:0.04 green:0.02 blue:0.1 alpha:0.92];
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
            // 2. Menu chính (cho phép kéo di chuyển toàn bộ khung)
            phlMenuContainer = [[UIView alloc] initWithFrame:CGRectMake(85, 130, 275, 330)];
            phlMenuContainer.backgroundColor = [UIColor colorWithRed:0.04 green:0.02 blue:0.12 alpha:0.96];
            phlMenuContainer.layer.cornerRadius = 14;
            phlMenuContainer.layer.borderWidth = 1.5;
            phlMenuContainer.layer.borderColor = [UIColor colorWithRed:0.8 green:0.4 blue:1.0 alpha:1.0].CGColor;
            phlMenuContainer.hidden = YES;
            phlMenuContainer.alpha = 0.0;

            UIPanGestureRecognizer *menuPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
            menuPan.cancelsTouchesInView = NO;
            [phlMenuContainer addGestureRecognizer:menuPan];

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 255, 28)];
            titleLabel.text = @"👑 PHL PHAM LONG - AUDIO MENU";
            titleLabel.textColor = [UIColor colorWithRed:0.9 green:0.65 blue:1.0 alpha:1.0];
            titleLabel.font = [UIFont boldSystemFontOfSize:12];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [phlMenuContainer addSubview:titleLabel];

            phlTableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 42, 259, 276) style:UITableViewStylePlain];
            phlTableView.backgroundColor = [UIColor clearColor];
            phlTableView.separatorColor = [UIColor colorWithWhite:0.22 alpha:1.0];
            phlTableView.delegate = self;
            phlTableView.dataSource = self;
            [phlMenuContainer addSubview:phlTableView];

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

- (void)playMusicWithTitle:(NSString *)title urlString:(NSString *)urlString {
    if (!urlString || urlString.length == 0) return;
    [self configureAudioSession];

    NSString *encodedStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:encodedStr ?: urlString];
    if (!url) return;

    dispatch_async(dispatch_get_main_queue(), ^{
        phlPlayingTitle = title;
        [phlTableView reloadData];

        phlPlayerItem = [AVPlayerItem playerItemWithURL:url];
        if (!phlAudioPlayer) {
            phlAudioPlayer = [AVPlayer playerWithPlayerItem:phlPlayerItem];
        } else {
            [phlAudioPlayer replaceCurrentItemWithPlayerItem:phlPlayerItem];
        }
        phlAudioPlayer.volume = 1.0;
        [phlAudioPlayer play];
    });
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
    BOOL isCurrent = (phlPlayingTitle && [phlPlayingTitle isEqualToString:title]);

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

    NSDictionary *song = phlPlaylist[indexPath.row];
    [self playMusicWithTitle:song[@"title"] urlString:song[@"url"]];
}

@end

__attribute__((constructor)) static void phlSecureInit() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[PHLProtectedAudioManager sharedInstance] initializeFramework];
    });
}
