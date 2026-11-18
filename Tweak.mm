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
        phlIsMenuOpen = NO;
    }
    return self;
}

- (void)initializeFramework {
    preventDebugging();

    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
            }
        }
        if (!keyWindow) {
            keyWindow = [UIApplication sharedApplication].windows.firstObject;
        }
        if (!keyWindow) return;

        // 1. Nút nổi (Floating Button) giao diện Tím Neon độc quyền PHL
        phlFloatingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        phlFloatingBtn.frame = CGRectMake(25, 130, 50, 50);
        phlFloatingBtn.layer.cornerRadius = 25;
        phlFloatingBtn.clipsToBounds = YES;
        phlFloatingBtn.layer.borderWidth = 2.0;
        phlFloatingBtn.layer.borderColor = [UIColor colorWithRed:0.75 green:0.35 blue:1.0 alpha:1.0].CGColor;
        [phlFloatingBtn setTitle:@"👑" forState:UIControlStateNormal];
        phlFloatingBtn.backgroundColor = [UIColor colorWithRed:0.04 green:0.02 blue:0.1 alpha:0.92];
        [phlFloatingBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];

        UIPanGestureRecognizer *btnPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [phlFloatingBtn addGestureRecognizer:btnPan];
        [keyWindow addSubview:phlFloatingBtn];

        // 2. Menu chính (cho phép kéo di chuyển toàn bộ khung)
        phlMenuContainer = [[UIView alloc] initWithFrame:CGRectMake(85, 130, 275, 330)];
        phlMenuContainer.backgroundColor = [UIColor colorWithRed:0.04 green:0.02 blue:0.12 alpha:0.96];
        phlMenuContainer.layer.cornerRadius = 14;
        phlMenuContainer.layer.borderWidth = 1.5;
        phlMenuContainer.layer.borderColor = [UIColor colorWithRed:0.8 green:0.4 blue:1.0 alpha:1.0].CGColor;
        phlMenuContainer.hidden = YES;
        phlMenuContainer.alpha = 0.0;

        UIPanGestureRecognizer *menuPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMenuPan:)];
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

        [self fetchGitHubPlaylist];
    });
}

- (void)toggleMenu {
    phlIsMenuOpen = !phlIsMenuOpen;
    if (phlIsMenuOpen) {
        phlMenuContainer.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{ phlMenuContainer.alpha = 1.0; }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{ phlMenuContainer.alpha = 0.0; } completion:^(BOOL finished) {
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

- (void)handleMenuPan:(UIPanGestureRecognizer *)pan {
    UIView *menuView = pan.view;
    if (!menuView || !menuView.superview) return;
    CGPoint translation = [pan translationInView:menuView.superview];
    CGPoint newCenter = CGPointMake(menuView.center.x + translation.x, menuView.center.y + translation.y);

    CGFloat halfW = menuView.bounds.size.width / 2.0;
    CGFloat halfH = menuView.bounds.size.height / 2.0;
    CGSize superSize = menuView.superview.bounds.size;
    newCenter.x = MAX(halfW, MIN(superSize.width - halfW, newCenter.x));
    newCenter.y = MAX(halfH, MIN(superSize.height - halfH, newCenter.y));

    menuView.center = newCenter;
    [pan setTranslation:CGPointZero inView:menuView.superview];
}

- (void)fetchGitHubPlaylist {
    NSString *jsonURLStr = @"https://raw.githubusercontent.com/phamlong3539-stack/phl-music-data/main/playlist.json";
    NSURL *url = [NSURL URLWithString:jsonURLStr];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error || !data) return;
        NSError *jsonError;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (!jsonError && jsonDict) {
            NSArray *songs = [jsonDict objectForKey:@"songs"];
            if (songs) {
                [phlPlaylist removeAllObjects];
                [phlPlaylist addObjectsFromArray:songs];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [phlTableView reloadData];
                });
            }
        }
    }];
    [task resume];
}

- (void)playMusicWithURL:(NSString *)urlString {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:urlString];
        phlPlayerItem = [AVPlayerItem playerItemWithURL:url];
        if (!phlAudioPlayer) {
            phlAudioPlayer = [AVPlayer playerWithPlayerItem:phlPlayerItem];
        } else {
            [phlAudioPlayer replaceCurrentItemWithPlayerItem:phlPlayerItem];
        }
        [phlAudioPlayer play];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return phlPlaylist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"PHLSongCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
        cell.detailTextLabel.textColor = [UIColor cyanColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:9];
    }
    NSDictionary *song = phlPlaylist[indexPath.row];
    cell.textLabel.text = song[@"title"];
    cell.detailTextLabel.text = @"▶ Streaming trực tiếp từ GitHub";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *song = phlPlaylist[indexPath.row];
    [self playMusicWithURL:song[@"url"]];
}

@end

__attribute__((constructor)) static void phlSecureInit() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[PHLProtectedAudioManager sharedInstance] initializeFramework];
    });
}
