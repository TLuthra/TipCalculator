//
//  TipViewController.m
//  tipcalculator
//
//  Created by Tanooj Luthra on 12/15/14.
//  Copyright (c) 2014 Tanooj Luthra. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *equationLabel;

@property (weak, nonatomic) IBOutlet UIButton *deliveryButton;
@property (weak, nonatomic) IBOutlet UIButton *restaurantButton;
@property (weak, nonatomic) IBOutlet UIButton *barButton;

@property (weak, nonatomic) IBOutlet UIButton *happyButton;
@property (weak, nonatomic) IBOutlet UIButton *sadButton;

@property (weak, nonatomic) NSString *selectedType;
@property (weak, nonatomic) NSString *selectedEmotion;
@property (assign, nonatomic) BOOL *selectedButton;

- (IBAction)onTap:(id)sender;
- (void)updateValues;
@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tip Calculator";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *image = [[UIImage imageNamed:@"Settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];

    self.navigationItem.rightBarButtonItem = settingsButton;
    UIColor *viewTint = [self view].tintColor;
    [self.navigationController.navigationBar setTintColor:viewTint];

    NSDictionary *tipAmounts = [[NSUserDefaults standardUserDefaults] objectForKey:@"tipAmounts"];

    if (tipAmounts == nil) {
        tipAmounts = @{@"delivery":@{@"happy":@(0.15), @"sad":@(0.07)},
                       @"restaurant":@{@"happy":@(0.25), @"sad":@(0.13)},
                       @"bar":@{@"happy":@(0.20), @"sad":@(0.10)}};
        [[NSUserDefaults standardUserDefaults] setObject:tipAmounts forKey:@"tipAmounts"];

        [[NSUserDefaults standardUserDefaults] setObject:@"delivery" forKey:@"defaultType"];
        [[NSUserDefaults standardUserDefaults] setObject:@"happy" forKey:@"defaultEmotion"];

        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"roundTotal"];
    }

    self.selectedButton = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.selectedType = self.selectedButton ? self.selectedType : [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultType"];
    self.selectedEmotion = self.selectedButton ? self.selectedEmotion :  [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultEmotion"];

    [self updateValues];
    [self selectButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onAmountChanged:(UITextField *)sender {
    NSString *billAmount = sender.text;

    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:billAmount];
    if ([number isEqualToNumber:[NSDecimalNumber notANumber]] && [billAmount length] > 1) {
        billAmount = [billAmount substringFromIndex:1];
        number = [NSDecimalNumber decimalNumberWithString:billAmount];
    }

    sender.text = [NSString stringWithFormat:@"$%@", billAmount];
    [self updateValues];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateValues];
}
- (IBAction)onChooseType:(UIButton *)sender {
    if (sender.tag == 100) {
        self.selectedType = @"delivery";
    } else if (sender.tag == 101) {
        self.selectedType = @"restaurant";
    } else if (sender.tag == 102) {
        self.selectedType = @"bar";
    }

    self.selectedButton = YES;
    [self selectButtons];
}
- (IBAction)onChooseEmotion:(UIButton *)sender {
    if (sender.tag == 200) {
        self.selectedEmotion = @"happy";
    } else if (sender.tag == 201) {
        self.selectedEmotion = @"sad";
    }

    self.selectedButton = YES;
    [self selectButtons];
}

- (void)selectButtons {
    [self.deliveryButton setAlpha:0.3];
    [self.restaurantButton setAlpha:0.3];
    [self.barButton setAlpha:0.3];

    [self.happyButton setAlpha:0.3];
    [self.sadButton setAlpha:0.3];

    UIButton* selectedButton;

    if ([self.selectedType isEqualToString:@"delivery"]) {
        selectedButton = (UIButton *)[self.view viewWithTag:100];
    } else if ([self.selectedType isEqualToString:@"restaurant"]) {
        selectedButton = (UIButton *)[self.view viewWithTag:101];
    } else if ([self.selectedType isEqualToString:@"bar"]) {
        selectedButton = (UIButton *)[self.view viewWithTag:102];
    }

    [selectedButton setAlpha:1.0];

    if ([self.selectedEmotion isEqualToString:@"happy"]) {
        selectedButton = (UIButton *)[self.view viewWithTag:200];
    } else if ([self.selectedEmotion isEqualToString:@"sad"]) {
        selectedButton = (UIButton *)[self.view viewWithTag:201];
    }

    [selectedButton setAlpha:1.0];
}

- (void)updateValues {
    if ([self.billTextField.text length] < 1) {
        return;
    }

    float billAmount = [[self.billTextField.text substringFromIndex:1] floatValue];

    NSDictionary *tipAmounts = [[NSUserDefaults standardUserDefaults] objectForKey:@"tipAmounts"];

    float tipPercentage = [[[tipAmounts objectForKey:self.selectedType] objectForKey:self.selectedEmotion] floatValue];

    float tipAmount = billAmount * tipPercentage;

    float totalAmount = billAmount + tipAmount;

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"roundTotal"]) {
        totalAmount = lroundf(totalAmount);
        tipAmount = totalAmount - billAmount;
        tipPercentage = tipAmount / billAmount;
    }

    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];

    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];

    self.equationLabel.text = [NSString stringWithFormat:@"$%0.2f + %ld%%", billAmount, lroundf(tipPercentage * 10000) / 100];

}

- (void)onSettingsButton {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

@end
