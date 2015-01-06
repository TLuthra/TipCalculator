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

@property (weak, nonatomic) IBOutlet UIButton *deliveryButton;
@property (weak, nonatomic) IBOutlet UIButton *restaurantButton;
@property (weak, nonatomic) IBOutlet UIButton *barButton;

@property (weak, nonatomic) IBOutlet UIButton *happyButton;
@property (weak, nonatomic) IBOutlet UIButton *sadButton;

@property (weak, nonatomic) NSString *selectedType;
@property (weak, nonatomic) NSString *selectedEmotion;

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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];

    

    NSDictionary *tipAmounts = [[NSUserDefaults standardUserDefaults] objectForKey:@"tipAmounts"];

    if (tipAmounts == nil) {
        tipAmounts = @{@"delivery":@{@"happy":@(0.15), @"sad":@(0.07)},
                       @"restaurant":@{@"happy":@(0.25), @"sad":@(0.13)},
                       @"bar":@{@"happy":@(0.20), @"sad":@(0.10)}};
        [[NSUserDefaults standardUserDefaults] setObject:tipAmounts forKey:@"tipAmounts"];

        [[NSUserDefaults standardUserDefaults] setObject:@"restaurant" forKey:@"defaultType"];
        [[NSUserDefaults standardUserDefaults] setObject:@"happy" forKey:@"defaultEmotion"];
    }

    self.selectedType = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultType"];
    self.selectedEmotion = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultEmotion"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAmountChanged:(UITextField *)sender {
    NSString *billAmount = sender.text;

    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:billAmount];
    if ([number isEqualToNumber:[NSDecimalNumber notANumber]] && [billAmount length] > 1) {
        billAmount = [billAmount substringFromIndex:1];
        number = [NSDecimalNumber decimalNumberWithString:billAmount];
    }
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
//    [formatter setLocale:[NSLocale currentLocale]];
    sender.text = [NSString stringWithFormat:@"$%@", billAmount];
    [self updateValues];
}

- (IBAction)onTap:(id)sender {
    NSLog(@"this is the onTap %@", sender);

    [self.view endEditing:YES];
    [self updateValues];
}
- (IBAction)onChooseType:(UIButton *)sender {
    NSLog(@"this is the on press %@ %ld", sender, (long)sender.tag);

    [self.deliveryButton setAlpha:0.3];
    [self.restaurantButton setAlpha:0.3];
    [self.barButton setAlpha:0.3];

    [sender setAlpha:1.0];

    if (sender.tag == 100) {
        self.selectedType = @"delivery";
    } else if (sender.tag == 101) {
        self.selectedType = @"restaurant";
    } else if (sender.tag == 102) {
        self.selectedType = @"bar";
    }
}
- (IBAction)onChooseEmotion:(UIButton *)sender {
    NSLog(@"this is the on choose emotion %@ %ld", sender, (long)sender.tag);

    [self.happyButton setAlpha:0.3];
    [self.sadButton setAlpha:0.3];

    [sender setAlpha:1.0];
    if (sender.tag == 200) {
        self.selectedEmotion = @"happy";
    } else if (sender.tag == 201) {
        self.selectedEmotion = @"sad";
    }
}

- (void)updateValues {
    if ([self.billTextField.text length] < 1) {
        return;
    }

    float billAmount = [[self.billTextField.text substringFromIndex:1] floatValue];
    NSLog(@"Bill Amount: %f", billAmount);
//    float tipAmount = billAmount * [tipValues[self.tipControl.selectedSegmentIndex] floatValue];

    NSDictionary *tipAmounts = [[NSUserDefaults standardUserDefaults] objectForKey:@"tipAmounts"];


    float tipAmount = billAmount * [[[tipAmounts objectForKey:self.selectedType] objectForKey:self.selectedEmotion] floatValue];

//    float tipAmount = [@(0.1) floatValue];
    float totalAmount = billAmount + tipAmount;

    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];

    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];

}

- (void)onSettingsButton {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

@end
