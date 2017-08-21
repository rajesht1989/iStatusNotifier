//
//  iStatusNotifier.h
//  iStatusNotifier
//
//  Created by Rajesh on 3/25/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface iStatusNotifier : UIWindow

+ (void)configure:(NSDictionary *)dict; //@{@"bgColor":[UIColor redColor],@"fgColor":[UIColor whiteColor],@"font":[UIFont systemFontOfSize:25]}
+ (void)showMessage:(NSString *)message; // 1 secod default
+ (void)showNeverStopMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message duration:(NSInteger)interval;
+ (BOOL)isVisible;
+ (void)interrupt;

@end
