//
//  SettingsViewController.m
//  tipcalculator
//
//  Created by Tanooj Luthra on 1/5/15.
//  Copyright (c) 2015 Tanooj Luthra. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UIPickerView *venuePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *emotionPicker;
@property (strong, nonatomic) NSArray* venues;
@property (strong, nonatomic) NSArray* emotions;
@property (weak, nonatomic) IBOutlet UISwitch *roundSwitch;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.venuePicker.dataSource = self;
    self.venuePicker.delegate = self;
    self.venuePicker.tag = 100;
    self.venues = @[@"delivery", @"restaurant", @"bar"];

    self.emotionPicker.dataSource = self;
    self.emotionPicker.delegate = self;
    self.emotionPicker.tag = 101;
    self.emotions = @[@"happy", @"sad"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.venuePicker selectRow:[self.venues indexOfObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultType"]] inComponent:0 animated:NO];

    [self.emotionPicker selectRow:[self.emotions indexOfObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultEmotion"]] inComponent:0 animated:NO];
    NSLog(@"roundTotal on? %d",  [[NSUserDefaults standardUserDefaults] boolForKey:@"roundTotal"]);
    [self.roundSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"roundTotal"] animated:NO];

}

- (IBAction)roundSwitchToggle:(id)sender {
    NSLog(@"bool for round: %d", ((UISwitch *)sender).on);
    NSLog(@"bool for round: %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"roundTotal"]);
    [[NSUserDefaults standardUserDefaults] setBool:((UISwitch *)sender).on forKey:@"roundTotal"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.minimumFontSize = 8.;
        tView.adjustsFontSizeToFitWidth = YES;
    }

    if (pickerView.tag == self.venuePicker.tag) {
        tView.text = [self.venues[row] capitalizedString];
    } else {
        tView.text = [self.emotions[row] capitalizedString];
    }

    return tView;
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == self.venuePicker.tag) {
        return 3;
    } else {
        return 2;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == self.venuePicker.tag) {
        [[NSUserDefaults standardUserDefaults] setObject:self.venues[row] forKey:@"defaultType"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.emotions[row] forKey:@"defaultEmotion"];
    }
}


@end
