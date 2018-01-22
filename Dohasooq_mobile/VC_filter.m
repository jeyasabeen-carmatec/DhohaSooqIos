//
//  VC_filter.m
//  Dohasooq_mobile
//
//  Created by Test User on 13/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_filter.h"
#import "XMLDictionary/XMLDictionary.h"

@interface VC_filter ()
{
    NSString *lower,*upper;
}

@end

@implementation VC_filter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self picker_set_UP];
    
    self.navigationController.navigationBar.hidden = NO;

    self.LBL_slider.minValue = 1;
    self.LBL_slider.maxValue = 3000;
    self.LBL_slider.selectedMinimum = 1;
    self.LBL_slider.selectedMaximum = 3000;
    
    _LBL_slider.hideLabels = YES;
    _LBL_slider.lineHeight = 7.0f;
    _LBL_slider.handleImage = [UIImage imageNamed:@"UISliderHandleDefault.png"];
    
    _TXT_start_date.text = @"Select start date";
    _TXT_end_date.text = @"Select end date";
    
    lower = [NSString stringWithFormat:@"%d",(int)self.LBL_slider.selectedMinimum];
    upper = [NSString stringWithFormat:@"%d",(int)self.LBL_slider.selectedMaximum];
    self.BTN_all.backgroundColor = self.BTN_submit.backgroundColor;
    
    
    // Set color for highlighted section of the slider track
    // Set height of slider track

    @try {
        
        self.LBL_max.text = [NSString stringWithFormat:@"Max %@ %d",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"], (int)self.LBL_slider.selectedMaximum];
        self.LBL_min.text = [NSString stringWithFormat:@"Min %@ %d", [[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],(int)self.LBL_slider.selectedMinimum];
        NSLog(@"%@ /n %@",lower,upper);
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    


    [_BTN_submit addTarget:self action:@selector(submit_ACTION) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
- (IBAction)labelSliderChanged:(TTRangeSlider*)sender
{
    lower = [NSString stringWithFormat:@"%d",(int)self.LBL_slider.selectedMinimum];
    upper = [NSString stringWithFormat:@"%d",(int)self.LBL_slider.selectedMaximum];
    self.LBL_max.text = [NSString stringWithFormat:@"Max %@ %d",[[NSUserDefaults standardUserDefaults]valueForKey:@"currency"],(int)self.LBL_slider.selectedMaximum];
    self.LBL_min.text = [NSString stringWithFormat:@"Min %@ %d",[[NSUserDefaults standardUserDefaults]valueForKey:@"currency"], (int)self.LBL_slider.selectedMinimum];

  
}
//-(void)slider_changed
//{
//    _LBL_max.text = [NSString stringWithFormat:@"Max QAR:%.f",_MAX_slider.value];
//
//   
//
//}
//-(void)slider_changed_min
//{
//    _LBL_min.text = [NSString stringWithFormat:@"Min QAR:%.f",_MIN_slider.value];
//    
//}

-(void)picker_set_UP
{
    _start_picker = [[UIDatePicker alloc] init];
    _end_picker = [[UIDatePicker alloc] init];
    _start_picker.datePickerMode = UIDatePickerModeDate;
    _end_picker.datePickerMode = UIDatePickerModeDate;

  
    
    
    UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fromdateTextField:)];
    [_start_picker addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.delegate = self;
    
    
    UITapGestureRecognizer* gestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(todateTextField:)];
    [_end_picker addGestureRecognizer:gestureRecognizer1];
    gestureRecognizer1.delegate = self;
    [_start_picker addTarget:self action:@selector(fromdateTextField:) forControlEvents:UIControlEventValueChanged];
    [_end_picker addTarget:self action:@selector(todateTextField:) forControlEvents:UIControlEventValueChanged];
    
    
    UIToolbar* conutry_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    conutry_close.barStyle = UIBarStyleBlackTranslucent;
    [conutry_close sizeToFit];
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(conutry_close.frame.size.width - 100, 0, 100, conutry_close.frame.size.height);
    [close setTitle:@"Done" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(countrybuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [conutry_close addSubview:close];
    _TXT_start_date.inputAccessoryView=conutry_close;
    _TXT_end_date.inputAccessoryView=conutry_close;
    self.TXT_start_date.inputView = _start_picker;
    self.TXT_end_date.inputView=_end_picker;
    _TXT_end_date.delegate = self;
    _TXT_start_date.delegate = self;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    
    
    NSDate *min_date = [[NSDate alloc] init];
    NSString  *min = [NSString stringWithFormat:@"%@",[formatter stringFromDate:min_date]];
    min_date = [formatter dateFromString:min];
    [_start_picker setMinimumDate:min_date];
    [_end_picker setMinimumDate:min_date];

    _TXT_start_date.tintColor=[UIColor clearColor];
    _TXT_end_date.tintColor=[UIColor clearColor];
    
    _TXT_start_date.layer.borderWidth = 0.5f;
    _TXT_end_date.layer.borderWidth = 0.5f;
    _TXT_start_date.layer.borderColor = _LBL_max.textColor.CGColor;
    
    _TXT_end_date.layer.borderColor = _LBL_max.textColor.CGColor;


}
-(void)countrybuttonClick
{
    [self.TXT_start_date resignFirstResponder];
    [self.TXT_end_date resignFirstResponder];
}
#pragma mark - UIPickerViewDataSource


-(void) fromdateTextField:(id)sender
{
    //    [_fromdate_picker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = _start_picker.date;
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    _TXT_start_date.text = [NSString stringWithFormat:@"%@",dateString];
}
-(void) todateTextField:(id)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = _end_picker.date;
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    _TXT_end_date.text = [NSString stringWithFormat:@"%@",dateString];
}



// #3
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    if (pickerView == _start_picker) {
//        return 1;
//    }if(pickerView==_end_picker)
//    {
//        return 1;
//    }
//    
//    return 0;
//}
//
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    if (pickerView == _start_picker) {
//        return [start_Dates count];
//    }
//    if (pickerView == _end_picker) {
//        return [end_Dtaes count];
//    }
//    
//    
//    return 0;
//}
//#pragma mark - UIPickerViewDelegate
//
//
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if (pickerView == _start_picker) {
//        return  start_Dates[row];
//    }
//    if (pickerView == _end_picker) {
//        return end_Dtaes[row];
//    }
//    
//    return nil;
//}
//
//// #6
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    if (pickerView == _start_picker) {
//       // self.TXT_start_date.text = self.countrypicker[row];
//        NSLog(@"the text is:%@",_TXT_start_date.text);
//        
//       
//       
//    }
//    if (pickerView == _end_picker) {
//        
//     //   self.TXT_state.text=self.statepicker[row];
//        //self.TXT_email.enabled=YES;
//    }
//}
//- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
//{
//    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
//        CGFloat rowHeight = [_start_picker rowSizeForComponent:0].height;
//        CGRect selectedRowFrame = CGRectInset(_start_picker.bounds, 0.0, (CGRectGetHeight(_start_picker.frame) - rowHeight) / 2.0 );
//        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_start_picker]));
//        if (userTappedOnSelectedRow) {
//            NSInteger selectedRow = [_start_picker selectedRowInComponent:0];
//            [self pickerView:_start_picker didSelectRow:selectedRow inComponent:0];
//        }
//    }
//}
//- (IBAction)tappedToSelectRowstate:(UITapGestureRecognizer *)tapRecognizer
//{
//    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
//        CGFloat rowHeight = [_end_picker rowSizeForComponent:0].height;
//        CGRect selectedRowFrame = CGRectInset(_end_picker.bounds, 0.0, (CGRectGetHeight(_end_picker.frame) - rowHeight) / 2.0 );
//        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_end_picker]));
//        if (userTappedOnSelectedRow) {
//            NSInteger selectedRow = [_end_picker selectedRowInComponent:0];
//            [self pickerView:_end_picker didSelectRow:selectedRow inComponent:0];
//        }
//    }
//}
#pragma mark - UIGestureRecognizerDelegate


- (IBAction)back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)all_action:(id)sender {
    _TXT_start_date.text = @"Select start date";
    _TXT_end_date.text = @"Select end date";
    _BTN_all.backgroundColor = self.BTN_submit.backgroundColor;
    _BTN_today.backgroundColor = [UIColor colorWithRed:0.31 green:0.29 blue:0.21 alpha:1.0];
    _BTN_tomorrow.backgroundColor = [UIColor colorWithRed:0.31 green:0.29 blue:0.21 alpha:1.0];
    _BTN_weekend.backgroundColor =  [UIColor colorWithRed:0.31 green:0.29 blue:0.21 alpha:1.0];
    
}
- (IBAction)today_action:(id)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *min_date = [[NSDate date] init];
    NSString  *date = [NSString stringWithFormat:@"%@",[formatter stringFromDate:min_date]];
    _TXT_start_date.text = date;
    _TXT_end_date.text = date;
    _BTN_today.backgroundColor = self.BTN_submit.backgroundColor;
    _BTN_all.backgroundColor = [UIColor colorWithRed:0.31 green:0.29 blue:0.21 alpha:1.0];
    _BTN_tomorrow.backgroundColor = [UIColor colorWithRed:0.31 green:0.29 blue:0.21 alpha:1.0];
    _BTN_weekend.backgroundColor =  [UIColor colorWithRed:0.31 green:0.29 blue:0.21 alpha:1.0];
    

    
}
- (IBAction)tomorrow_action:(id)sender {
    NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    NSString  *date = [NSString stringWithFormat:@"%@",[formatter stringFromDate:tomorrow]];
    _TXT_start_date.text = date;
    _BTN_tomorrow.backgroundColor = self.BTN_submit.backgroundColor;
    _BTN_all.backgroundColor = [UIColor colorWithRed:0.31 green:0.29 blue:0.21 alpha:1.0];
    _BTN_today.backgroundColor = [UIColor colorWithRed:0.31 green:0.29 blue:0.21 alpha:1.0];
    _BTN_weekend.backgroundColor =  [UIColor colorWithRed:0.31 green:0.29 blue:0.21 alpha:1.0];
    
    
}
- (IBAction)weekend_action:(id)sender
{
    #define FRIDAY 6
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    
    NSDate *nextFriday = [NSDate date];
    NSInteger iWeekday = [[gregorian components:NSWeekdayCalendarUnit fromDate:nextFriday] weekday];
    
    while (iWeekday != FRIDAY) {
        nextFriday = [gregorian dateByAddingComponents:dayComponent toDate:nextFriday options:0];
        iWeekday = [[gregorian components:NSWeekdayCalendarUnit fromDate:nextFriday] weekday];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    NSString  *friday = [NSString stringWithFormat:@"%@",[formatter stringFromDate:nextFriday]];
    NSLog(@"%@",friday);
    
    NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:nextFriday];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"MM-dd-yyyy"];
    NSString  *next_sat = [NSString stringWithFormat:@"%@",[formatter1 stringFromDate:tomorrow]];
    _TXT_start_date.text = friday;
    _TXT_end_date.text = next_sat;
    
    _BTN_weekend.backgroundColor = self.BTN_submit.backgroundColor;
    _BTN_all.backgroundColor = [UIColor colorWithRed:0.31 green:0.29 blue:0.21 alpha:1.0];
    _BTN_today.backgroundColor = [UIColor colorWithRed:0.31 green:0.29 blue:0.21 alpha:1.0];
    _BTN_tomorrow.backgroundColor =  [UIColor colorWithRed:0.31 green:0.29 blue:0.21 alpha:1.0];
    
}
-(void)submit_ACTION
{
    if(_BTN_all.backgroundColor == _BTN_submit.backgroundColor)
    {
          [self.navigationController popViewControllerAnimated:NO];
    }
    else
    {
    
    if([_TXT_start_date.text isEqualToString:@"Select start date"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select the Start date"delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
   else  if([_TXT_start_date.text isEqualToString:@"Select end date"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select the End date"delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
else{
        
    @try
    {
            NSString *start_date = _TXT_start_date.text;
            start_date = [start_date stringByReplacingOccurrencesOfString:@"-" withString:@"%20"];
            NSString *end_date = _TXT_end_date.text;
            end_date = [end_date stringByReplacingOccurrencesOfString:@"-" withString:@"%20"];
            
            
    NSString *str = [NSString stringWithFormat:@"https://api.q-tickets.com/V2.0/geteventsbyfilters?minPrice=%@&maxPrice=%@&startDate=%@&endDate=%@&country=Qatar",lower,upper,start_date,end_date];
    
    NSURL *URL = [[NSURL alloc] initWithString:str];
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    //NSLog(@"string: %@", xmlString);
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
   
    NSLog(@"The Order Data is:%@",xmlDoc);
       
        
        if([[[xmlDoc valueForKey:@"EventDetails"]valueForKey:@"eventdetail"]count] > 0)
        {
            @try
            {
             [[NSUserDefaults standardUserDefaults] setObject:[[xmlDoc valueForKey:@"EventDetails"]valueForKey:@"eventdetail"] forKey:@"Events_arr"];
               [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController popViewControllerAnimated:NO];

            }
            @catch(NSException *exception)
            {
                [[NSUserDefaults standardUserDefaults] setObject:[[xmlDoc valueForKey:@"EventDetails"]valueForKey:@"eventdetail"] forKey:@"Events_arr"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
        }
            else
            {
                [self.navigationController popViewControllerAnimated:NO];

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Events Found"delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];

            }
            

        
        
        
     
     }
     @catch(NSException *exception)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"connection error"delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         [alert show];
     }
   
    }
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
