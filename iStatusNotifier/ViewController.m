//
//  ViewController.m
//  iStatusNotifier
//
//  Created by Rajesh on 3/25/15.
//

#import "ViewController.h"
#import "iStatusNotifier.h"

@interface ViewController ()
{
    __weak IBOutlet UITextField *redRef;
    __weak IBOutlet UITextField *greenRef;
    __weak IBOutlet UITextField *blueRef;
    __weak IBOutlet UITextField *tfmessage;
    
}

@end

@implementation ViewController

- (IBAction)durationChanged:(UISlider *)sender
{
    [[iStatusNotifier sharedInstance] setIDuration:sender.value];
}
- (IBAction)showMessageTapped:(id)sender
{
    [[[iStatusNotifier sharedInstance] lblMessage] setBackgroundColor:[UIColor colorWithRed:[[redRef text] integerValue] green:[[greenRef text] integerValue] blue:[[blueRef text] integerValue] alpha:1.]];
    [iStatusNotifier showStatusBarAlert:tfmessage.text];
}

@end
