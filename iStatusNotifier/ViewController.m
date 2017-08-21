//
//  ViewController.m
//  iStatusNotifier
//
//  Created by Rajesh on 3/25/15.
//

#import "ViewController.h"
#import "iStatusNotifier.h"
#import "RGSColorSlider.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet RGSColorSlider *bgSlider;
@property (weak, nonatomic) IBOutlet RGSColorSlider *fgSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_bgSlider setValue:0];
    [_textview setBackgroundColor:_bgSlider.color];
    [_fgSlider setValue:.5];
    [_textview setTextColor:_fgSlider.color];
    [iStatusNotifier configure:@{@"bgColor":_textview.backgroundColor,@"fgColor":_textview.textColor,@"font":[UIFont systemFontOfSize:15]}];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
}

- (IBAction)bgColorChanged:(RGSColorSlider *)sender {
    [_textview setBackgroundColor:sender.color];
    [iStatusNotifier configure:@{@"bgColor":_textview.backgroundColor}];
}

- (IBAction)fgColorChanged:(RGSColorSlider *)sender {
    [_textview setTextColor:sender.color];
    [iStatusNotifier configure:@{@"fgColor":_textview.textColor}];
}

- (IBAction)previewTapped:(id)sender {
    [self.view endEditing:YES];
    [iStatusNotifier showMessage:_textview.text duration:_timeSlider.value];
}

@end
