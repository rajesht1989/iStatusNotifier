//
//  iStatusNotifier.m
//  iStatusNotifier
//
//  Created by Rajesh on 3/25/15.
//

#import "iStatusNotifier.h"

@interface iStatusViewController : UIViewController

@property (nonatomic, strong) UIWindow *owner;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *screenshotView;

@end

@implementation iStatusViewController

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_messageLabel];
        [_messageLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [_messageLabel setNumberOfLines:0];
        [_messageLabel setTextAlignment:NSTextAlignmentCenter];
        [_messageLabel setBackgroundColor:[UIColor whiteColor]];
        [self.view setClipsToBounds:YES];
    }
    return _messageLabel;
}

- (void)show:(BOOL)show {
    __block CGRect messageLabelRect;
    __block CGRect statusBarRect;
    if (show) {
        [_owner setHidden:NO];
        _screenshotView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
        [self.view addSubview:_screenshotView];
        [_screenshotView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        messageLabelRect = [[self messageLabel] frame];
        messageLabelRect.origin.y = -self.view.bounds.size.height;
        [_messageLabel setFrame:messageLabelRect];
        
        statusBarRect = [_screenshotView frame];
        [UIView animateWithDuration:.2 animations:^{
            messageLabelRect.origin.y = 0;
            [_messageLabel setFrame:messageLabelRect];
            
            statusBarRect.origin.y = _messageLabel.bounds.size.height;
            [_screenshotView setFrame:statusBarRect];
        }];
    } else {
        messageLabelRect = [[self messageLabel] frame];
        statusBarRect = [_screenshotView frame];

        [UIView animateWithDuration:.2 animations:^{
            messageLabelRect.origin.y = -self.view.bounds.size.height;
            [_messageLabel setFrame:messageLabelRect];
            
            statusBarRect.origin.y = 0;
            [_screenshotView setFrame:statusBarRect];
        } completion:^(BOOL finished) {
            [_screenshotView removeFromSuperview];
            [_owner setHidden:YES];
        }];
    }
}

@end


@interface iStatusNotifier()
@property (nonatomic, strong) iStatusViewController *statusController;
@property (nonatomic, strong) NSDictionary *configurations;

@end

@implementation iStatusNotifier

+ (instancetype)notifier {
    static iStatusNotifier *notifier;
    if (notifier == nil) {
        notifier = [[self alloc] init];
    }
    return notifier;
}

+ (void)configure:(NSDictionary *)dict {
    [[self notifier] setConfigurations:dict];
}

+ (void)showMessage:(NSString *)message {
    [self showMessage:message duration:1];
}

+ (void)showNeverStopMessage:(NSString *)message {
    iStatusViewController *statusController = [[self notifier] statusController];
    if (message.length == 0) [statusController show:NO];
    else {
        [[statusController messageLabel] setText:message];
        if (self.isVisible == NO) {
            [statusController show:YES];
            [[self notifier] configure];
        }
    }
}

+ (void)showMessage:(NSString *)message duration:(NSInteger)interval {
    [self showNeverStopMessage:message];
    [self performSelector:@selector(interrupt) withObject:nil afterDelay:interval];
}

+ (BOOL)isVisible {
    return [[self notifier] isHidden] == NO;
}

+ (void)interrupt {
    [[[self notifier] statusController] show:NO];
}

- (instancetype)init {
    if (self = [super initWithFrame:self.currentFrame]) {
        [self setHidden:YES];
        [self setWindowLevel:UIWindowLevelStatusBar];
        [self setBackgroundColor:[UIColor clearColor]];
        iStatusViewController *statusController = [[iStatusViewController alloc] init];
        [statusController setOwner:self];
        [self setStatusController:statusController];
        [self setRootViewController:statusController];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self setFrame:self.currentFrame];
            [self.statusController.screenshotView setHidden:YES];
        }];
    }
    return self;
}

- (CGRect)currentFrame {
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect mainScreenBounds = UIScreen.mainScreen.bounds;
    BOOL isIphone = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
    
    UIViewController *topViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    if ([topViewController isKindOfClass:[UITabBarController class]]) {
        topViewController = [(UITabBarController *)topViewController selectedViewController];
    }
    switch ([[UIApplication sharedApplication] statusBarOrientation]) {
        case UIInterfaceOrientationPortraitUpsideDown :
            return statusBarFrame;
            break;
        case UIInterfaceOrientationLandscapeLeft :
            if (isIphone && topViewController.prefersStatusBarHidden) {
                if ([topViewController isKindOfClass:[UINavigationController class]]) {
                    statusBarFrame = mainScreenBounds;
                    statusBarFrame.size.height = [[(UINavigationController *)topViewController navigationBar] bounds].size.height;
                } else {
                    statusBarFrame = mainScreenBounds;
                    statusBarFrame.size.height = 20;
                }
            }
            return statusBarFrame;
            break;
        case UIInterfaceOrientationLandscapeRight :
            if (isIphone && topViewController.prefersStatusBarHidden) {
                if ([topViewController isKindOfClass:[UINavigationController class]]) {
                    statusBarFrame = mainScreenBounds;
                    statusBarFrame.size.height = [[(UINavigationController *)topViewController navigationBar] bounds].size.height;
                } else {
                    statusBarFrame = mainScreenBounds;
                    statusBarFrame.size.height = 20;
                }
            }
            return statusBarFrame;
            break;
        default:
            return statusBarFrame;
            break;
    }
    return statusBarFrame;
}

- (void)setConfigurations:(NSDictionary *)configurations {
    _configurations = configurations;
    if (_statusController.isViewLoaded) {
        [self configure];
    }
}

- (void)configure {
    if ([_configurations objectForKey:@"bgColor"]) {
        [_statusController.messageLabel setBackgroundColor:[_configurations objectForKey:@"bgColor"]];
    }
    if ([_configurations objectForKey:@"fgColor"]) {
        [_statusController.messageLabel setTextColor:[_configurations objectForKey:@"fgColor"]];
    }
    if ([_configurations objectForKey:@"font"]) {
        [_statusController.messageLabel setFont:[_configurations objectForKey:@"font"]];
    }
}

@end


