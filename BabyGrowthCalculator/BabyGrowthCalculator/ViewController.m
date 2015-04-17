//
//  ViewController.m
//  BabyGrowthCalculator
//
//  Created by 宣佚 on 15/4/17.
//  Copyright (c) 2015年 宣佚. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *countBut;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stageSelectBut;

@property (strong ,nonatomic) NSString *pickerString;

@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    self.resultLabel.text = @"";
    self.stageSelectBut.selectedSegmentIndex = 0;
}

-(void)datePickerValueChanged
{
    self.pickerString = [self dateStringFromDate:self.datePicker.date];
    self.dateField.text = self.pickerString;
}

-(NSString *)dateStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [dateFormatter stringFromDate:date];
    return str;
}

-(NSString *)AccordingPreDayMathPanyDay_Fommart:(int64_t)date
{
    NSString *reString = [self ComDateToString_Week:date];
    return reString;
}

-(NSString *)AccordingPreDayMathPanyDay:(int64_t)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *panDate = [NSDate dateWithTimeIntervalSince1970:date];
    NSTimeInterval interval = 280 * 24 * 60 * 60;
    NSString *preString = [dateFormatter stringFromDate:[panDate initWithTimeInterval:interval sinceDate:panDate]];
    return preString;
}

-(NSString *)AccordingPanyDayMathPanyDay:(int64_t)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *panDate = [NSDate dateWithTimeIntervalSince1970:date];
    NSTimeInterval interval = 280 * 24 * 60 * 60;
    NSTimeInterval ts = -interval;
    NSString *preString = [dateFormatter stringFromDate:[panDate initWithTimeInterval:ts sinceDate:panDate]];
    return preString;
}

-(NSString *)AccordingPanyDayMathPanyDay_Formmat:(int64_t)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *panDate = [NSDate dateWithTimeIntervalSince1970:date];
    NSTimeInterval interval = 280 * 24 * 60 * 60;
    NSTimeInterval ts = -interval;
    NSString *preString = [dateFormatter stringFromDate:[panDate initWithTimeInterval:ts sinceDate:panDate]];
    NSDate *destDate= [dateFormatter dateFromString:preString];
    int64_t prets = [destDate timeIntervalSince1970];
    NSString *reString = [self ComDateToString_Week:prets];
    return reString;
}

-(NSString *)AccordingBirthDayMathGrowthDay:(int64_t)date
{
    NSString *reString = [self ComDateToString_Day:date isBirth:YES];
    return reString;
}

-(NSString *)ComDateToString_Week:(int64_t)date
{
    NSString *reString = @"";
    NSDate *toDate = [NSDate dateWithTimeIntervalSince1970:date];
    NSDate *startDate = [[NSDate alloc] init];
    NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
    NSUInteger unitFlags = NSWeekOfMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *cps = [ chineseClendar components:unitFlags fromDate:toDate  toDate:startDate  options:0];
    NSMutableString *str = [[NSMutableString alloc] init];
    if ([cps weekOfMonth] == 0 && [cps day] == 0) {
        reString = @"0天";
    }
    else {
        if ([cps weekOfMonth] != 0) {
            [str appendString:[NSString stringWithFormat:@"%ld",(long)[cps weekOfMonth]]];
            [str appendString:@"周"];
        }
        if ([cps day] != 0) {
            [str appendString:[NSString stringWithFormat:@"%ld",(long)[cps day]]];
            [str appendString:@"天"];
        }
    }
    reString = str;
    return reString;
}

-(NSString *)ComDateToString_Day:(int64_t)date isBirth:(BOOL)isBirth
{
    NSString *reString = @"";
    NSDateComponents *cps = [self ComponentsDateGaps:date];
    NSMutableString *str = [[NSMutableString alloc] init];
    if ([cps year] == 0 && [cps month] == 0 && [cps day] == 0) {
        reString = @"0天";
        return reString;
    } else {
        if ([cps year] != 0) {
            [str appendString:[NSString stringWithFormat:@"%ld",(long)[cps year]]];
            if (isBirth == YES) {
                [str appendString:@"岁"];
            }
            else {
                [str appendString:@"年"];
            }
        }
        if ([cps month] != 0) {
            [str appendString:[NSString stringWithFormat:@"%ld",(long)[cps month]]];
            [str appendString:@"月"];
        }
        if ([cps day] != 0) {
            [str appendString:[NSString stringWithFormat:@"%ld",(long)[cps day]]];
            [str appendString:@"天"];
        }
        reString = str;
        return reString;
    }
    
}

-(NSDateComponents *)ComponentsDateGaps:(int64_t)toDateString
{
    NSDate *toDate = [NSDate dateWithTimeIntervalSince1970:toDateString];
    NSDate *startDate = [[NSDate alloc] init];
    NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    NSDateComponents *cps = [ chineseClendar components:unitFlags fromDate:toDate  toDate:startDate  options:0];
    return cps;
}

- (IBAction)CountButPress:(id)sender {
    NSString *preString = @"";
    NSString *birthString = @"";
    NSString *panyString = @"";
    NSString *dayString = @"";
    switch (self.stageSelectBut.selectedSegmentIndex) {
        case 0:
            preString = self.pickerString;
            panyString = [self AccordingPreDayMathPanyDay:[self.datePicker.date timeIntervalSince1970]];
            dayString = [self AccordingPreDayMathPanyDay_Fommart:[self.datePicker.date timeIntervalSince1970]];
            break;
        case 1:
            panyString = self.pickerString;
            preString = [self AccordingPanyDayMathPanyDay:[self.datePicker.date timeIntervalSince1970]];
            dayString = [self AccordingPanyDayMathPanyDay_Formmat:[self.datePicker.date timeIntervalSince1970]];
            break;
        case 2:
            birthString = self.pickerString;;
            dayString = [self AccordingBirthDayMathGrowthDay:[self.datePicker.date timeIntervalSince1970]];
            break;
        default:
            break;
    }
    if ([birthString isEqualToString:@""]) {
        self.resultLabel.text = [NSString stringWithFormat:@"末次经期是：%@ ，预产期是:%@ ,已经怀孕:%@",preString,panyString,dayString];
    } else {
        self.resultLabel.text = [NSString stringWithFormat:@"宝宝生日是:%@ ,宝宝出生了:%@",birthString,dayString];
    }
}

@end
