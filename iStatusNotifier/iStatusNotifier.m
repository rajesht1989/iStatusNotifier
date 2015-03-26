//
//  iStatusNotifier.m
//  iStatusNotifier
//
//  Created by Rajesh on 3/25/15.
//

#import "iStatusNotifier.h"
@interface iStatusNotifier()
@property(nonatomic,strong) UIWindow *statusWindow;
@end

@implementation iStatusNotifier
+ (void)showStatusBarAlert:(NSString *)stMessage
{
    [[[iStatusNotifier sharedInstance] lblMessage] setText:stMessage];
    [[[iStatusNotifier sharedInstance] lblMessage] setAlpha:0.];
    [UIView animateWithDuration:0.5f delay:0. options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
                         [[[iStatusNotifier sharedInstance] lblMessage] setAlpha:1.];
                     } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.5f delay:[[iStatusNotifier sharedInstance] iDuration] options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
                                 [[[iStatusNotifier sharedInstance] lblMessage] setAlpha:0.];
                             }completion:nil];
                     }];
}

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
    }
    return objNotifier;
}

@end
