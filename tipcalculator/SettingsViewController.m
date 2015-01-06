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

    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultType"]);
    NSLog(@"%lu", (unsigned long)[self.venues indexOfObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultType"]]);

    [self.venuePicker selectRow:[self.venues indexOfObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultType"]] inComponent:0 animated:NO];

    [self.emotionPicker selectRow:[self.emotions indexOfObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"defaultEmotion"]] inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == self.venuePicker.tag) {
        return [self.venues[row] capitalizedString];
    } else {
        return [self.emotions[row] capitalizedString];
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
