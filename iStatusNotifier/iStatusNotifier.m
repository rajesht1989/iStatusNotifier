//
//  iStatusNotifier.m
//  iStatusNotifier
//
//  Created by Rajesh on 3/25/15.
//

#import "iStatusNotifier.h"
@interface iStatusNotifier()
@property(nonatomic,strong) UIWindow *statusWindow;
@property(nonatomic,assign) BOOL isVisible;
@property (nonatomic, strong) void (^completion)(void);
@end

@implementation iStatusNotifier

+ (instancetype)sharedInstance
{
    static iStatusNotifier *objNotifier;
    if (!objNotifier)
    {
        objNotifier = [[self alloc] init];
        
        objNotifier.statusWindow = [[UIWindow alloc] initWithFrame:[[UIApplication sharedApplication] statusBarFrame]];
        objNotifier.statusWindow.windowLevel = UIWindowLevelStatusBar;
        [objNotifier.statusWindow makeKeyAndVisible];
        objNotifier.lblMessage = [[UILabel alloc] initWithFrame:objNotifier.statusWindow.frame];
        [objNotifier.lblMessage setBackgroundColor:[UIColor whiteColor]];
        [objNotifier.lblMessage setTextAlignment:NSTextAlignmentCenter];
        [objNotifier.statusWindow addSubview:objNotifier.lblMessage];
        [[[iStatusNotifier sharedInstance] lblMessage] setAlpha:0.];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return objNotifier;
}

+ (void)showStatusBarAlert:(NSString *)stMessage {
    iStatusNotifier *notifier = [iStatusNotifier sharedInstance];
    [[notifier lblMessage] setText:stMessage];
    [[notifier lblMessage] setAlpha:0.];
    [UIView animateWithDuration:0.5f delay:0. options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        [notifier setIsVisible:YES];
        [[[iStatusNotifier sharedInstance] lblMessage] setAlpha:1.];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:[notifier iDuration] options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            [[notifier lblMessage] setAlpha:0.];
        }completion:^(BOOL finished) {
            if (notifier.completion)
                notifier.completion();
            [notifier setIsVisible:NO];
        }];
    }];
}

+ (void)showStatusBarAlert:(NSString *)stMessage completion:(void (^)(void))completion {
    [[iStatusNotifier sharedInstance] setCompletion:completion];
    [self showStatusBarAlert:stMessage];
}

+ (void)dismiss {
    iStatusNotifier *notifier = [iStatusNotifier sharedInstance];
    if (notifier.isVisible) {
        [[notifier lblMessage] setAlpha:0.];
    }
}
+ (void)didRotate:(NSNotification *)notification {
    [[[iStatusNotifier sharedInstance] lblMessage] setAlpha:0.];
}

@end
