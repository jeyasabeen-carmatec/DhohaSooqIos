//
//  VC_event_user.m
//  Dohasooq_mobile
//
//  Created by Test User on 28/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_event_user.h"
#import "Helper_activity.h"
#import "XMLDictionary/XMLDictionary.h"


@interface VC_event_user ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIWebViewDelegate>
{
    float scroll_height;
    NSMutableArray *phone_code_arr;
    UIView *VW_overlay;
  //  UIActivityIndicatorView *activityIndicatorView;
    NSArray *country_arr;
    //NSTimer *timer;
}

@end

@implementation VC_event_user

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _TXT_name.delegate = self;
    _TXT_code.delegate = self;
    _TXT_mail.delegate = self;
    _TXT_phone.delegate = self;
    _TXT_voucher.delegate = self;
    
    
    @try
    {
        
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        if (dict.count != 0) {
            
            _TXT_mail.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_email"];
            _TXT_name.text = [dict valueForKey:@"firstname"];
            
            if([[dict  valueForKey:@"phone"] isEqualToString:@"<null>"]||[[dict  valueForKey:@"phone"] isEqualToString:@""]||[[dict  valueForKey:@"phone"] isEqualToString:@"null"]||![dict  valueForKey:@"phone"])
            {
                
                    _TXT_phone.text = @"";
                    _TXT_code.text = @"+974";
                }
                else
                {
                    NSArray  *arr = [[dict valueForKey:@"phone"] componentsSeparatedByString:@"-"];
                    _TXT_phone.text = [arr objectAtIndex:1];
                    _TXT_code.text = [arr objectAtIndex:0];
                }
            
        }
    }@catch(NSException *exception)
    {
        
    }
    
    
    self.navigationController.navigationBar.hidden = NO;

    phone_code_arr = [[NSMutableArray alloc]init];
    CGRect frameset = _VW_contents.frame;
    frameset.size.height = _BTN_pay.frame.origin.y + _BTN_pay.frame.size.height;
    frameset.size.width = _scroll_contents.frame.size.width;
    _VW_contents.frame = frameset;
    
    
    self.web_terms.delegate = self;
    
    
    [self.scroll_contents addSubview:_VW_contents];
    
    @try
    {
        NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"Amount_dict"];
        _LBL_amount.text = [NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:1],[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
        _LBL_service_charges.text = [NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:2],[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
         _LBL_total_charge.text = [NSString stringWithFormat:@"%d %@",[[arr objectAtIndex:1] intValue]+[[arr objectAtIndex:2] intValue],[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];

    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    [self phone_code_view];
    _TXT_name.layer.borderWidth = 0.5f;
    _TXT_name.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _TXT_mail.layer.borderWidth = 0.5f;
    _TXT_mail.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _TXT_phone.layer.borderWidth = 0.5f;
    _TXT_phone.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _TXT_code.layer.borderWidth = 0.5f;
    _TXT_code.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _TXT_voucher.layer.borderWidth = 0.5f;
    _TXT_voucher.layer.borderColor = [UIColor lightGrayColor].CGColor;
    

    
    _BTN_apply.layer.cornerRadius = 2.0f;
    _BTN_apply.layer.masksToBounds = YES;
    
    _VW_terms.layer.cornerRadius = 2.0f;
    _VW_terms.layer.masksToBounds = YES;
    
    _BTN_ok_terms.layer.cornerRadius = 2.0f;
    _BTN_ok_terms.layer.masksToBounds = YES;
    
    

    _LBL_stat.tag = 0;
    scroll_height  = _VW_contents.frame.origin.y + _VW_contents.frame.size.height;
    [_BTN_pay addTarget:self action:@selector(Pay_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_check addTarget:self action:@selector(BTN_chek_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_terms addTarget:self action:@selector(terms_conditions) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_ok_terms addTarget:self action:@selector(terms_ok) forControlEvents:UIControlEventTouchUpInside];


    NSString *str_accept = @"I accept";
    NSString *str_terms = @"Terms and Conditions";
    NSString *str_conditions = [NSString stringWithFormat:@"%@ %@",str_accept,str_terms];
    if ([_BTN_terms.titleLabel respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_BTN_terms.titleLabel.textColor,
                                  NSFontAttributeName:_BTN_terms.titleLabel.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str_conditions attributes:attribs];
        NSRange enames = [str_conditions rangeOfString:str_accept];
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Italic" size:17.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                range:enames];

        
        
        NSRange ename = [str_conditions rangeOfString:str_terms];
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:17.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.23 green:0.35 blue:0.60 alpha:1.0]}
                                    range:ename];
        
        [_BTN_terms setAttributedTitle:attributedText forState:UIControlStateNormal];
    }
    else
    {      [_BTN_terms setTitle:str_conditions forState:UIControlStateNormal];
    }
    
    
    

}
-(void)viewWillAppear:(BOOL)animated
{
    
    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    //    VW_overlay.layer.cornerRadius = 10.0;
    
//    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
//    activityIndicatorView.center = VW_overlay.center;
//    [VW_overlay addSubview:activityIndicatorView];
    [self.view addSubview:VW_overlay];
    
     VW_overlay.hidden = YES;
    
    
    
    
}
/*UIFont *font = [UIFont fontWithName:@"OpenSans" size:12];
NSString *htmlString = [NSString stringWithFormat:@"<span style=\"font-family: %@; font-size:             %i\">%@</span>",font.fontName, (int) font.pointSize, yourHTMLString];*/
-(void)terms_conditions
{
   
    _VW_terms.hidden = NO;
    VW_overlay.hidden = NO;
    CGRect frameset = _VW_terms.frame;
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if(result.height <= 480)
    {
        frameset.size.height = 300;
        frameset.size.width = 300;

    }
    else if(result.height <= 568)
    {
        frameset.size.height = 350;
        frameset.size.width = 350;

    }
    else
    {
        frameset.size.height = 400;
        frameset.size.width = 400;

    }
    

     _VW_terms.frame= frameset;
    _VW_terms.center =  self.view.center;
    [VW_overlay addSubview:_VW_terms];
    
//  timer = [NSTimer scheduledTimerWithTimeInterval:1
//                                             target:self
//                                           selector:@selector(set_DATA_web_VIEW)
//                                           userInfo:nil
//                                            repeats:NO];
//
    [self set_DATA_web_VIEW];
  
    
    
}

-(void)terms_ok
{
    
    _VW_terms.hidden =YES;
    VW_overlay.hidden = YES;
    
    
}
-(void)set_DATA_web_VIEW
{
    NSString *html = @"<html><head><meta charset=\"utf-8\"></head><body><div class=\"english_data\" dir=\"ltr\"><ol><li>Once the tickets are confirmed it is deemed as sold and as per the cinema regulations, once a ticket has been paid for, it cannot be refunded replaced or cancelled or changed/transferred.</li><li>Ticket prices are applicable for children from 2 years and above.</li><li>Reserved seats cannot be transferred or changed.</li><li>Q-Tickets guarantee the absolute privacy and confidentiality of its users' personal information.</li><li>Q-Tickets only role is to facilitate the online reservation process. We are neither responsible nor accountable for the theater's services.</li><li>By agreeing to the terms and conditions, you are verifying that all the personal information is valid and accurate, and that you bear all legal responsibility for it.</li><li>Q-Tickets is not responsible for the movies ratings.Theatre owner has right to access permission.</li></ol></div><div class=\"arabic_data\" dir=\"rtl\" lang=\"ar\"><ol><li>حالما يتم تأكيد التذاكر تعتبر قد بيعت وحيث ينص قانون السينيما، حينما يتم دفع ثمن التذاكر فأنه غير ممكن استبدالها أرجاعها أو حتى ألغائها.</li><li>الأسعار قابلة للتطبيق للأطفال من سن 2 فما فوق.</li><li>المقاعد المحجوزة لا يمكن تغيريها أو نقلها.</li><li>Q-ticketts تضمن السريه والخصوصية التامه للمعلومات الشخصية لمستخدميها.</li><li>Q-tickets دورها الاساسي والوحيد من خلال الحجز عبر الأنترنت، ونحن غير مسؤولين عن خدمات القاعة.</li><li>عبر الموافقة على الشروط والأحكام فأنك تعطي الحق بأستخدام المعلومات الشخصيه بشكل قانوني.<li><li>Q-tickets غير مسؤولة عن تقييم الفيلم، مالك القاعه هو فقط من لديه الصلاحيه لذلك.</li>          </ol></div></body>";
    
    
    UIFont *font = [UIFont fontWithName:@"poppins" size:15];
    NSString *string = [NSString stringWithFormat:@"<span style=\"font-family: %@; font-size:             %i\">%@</span>",font.fontName, (int) font.pointSize, html];
    
    //    VW_overlay.hidden = NO;
    //    [activityIndicatorView startAnimating];
    
    [_web_terms loadHTMLString:string baseURL:nil];
 //   [timer invalidate];
    

}

-(void)phone_code_view
{
  
    
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    phone_code_arr = (NSMutableArray *)[parsedObject valueForKey:@"countries"];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                 ascending:YES];
    [phone_code_arr sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSLog(@"%@",phone_code_arr);
    
    _phone_picker_view = [[UIPickerView alloc] init];
    _phone_picker_view.delegate = self;
    _phone_picker_view.dataSource = self;
    
    
    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(tappedToSelectRow:)];
    tapToSelect.delegate = self;
    [_phone_picker_view addGestureRecognizer:tapToSelect];

    
    NSLog(@"%@",phone_code_arr);
    
    UIToolbar* phone_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    phone_close.barStyle = UIBarStyleBlackTranslucent;
    [phone_close sizeToFit];
    
    UIButton *done=[[UIButton alloc]init];
    done.frame=CGRectMake(phone_close.frame.size.width - 100, 0, 100, phone_close.frame.size.height);
    [done setTitle:@"Done" forState:UIControlStateNormal];
    [done addTarget:self action:@selector(countrybuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [phone_close addSubview:done];
    
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(phone_close.frame.origin.x -20, 0, 100, phone_close.frame.size.height);
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(countrybuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [phone_close addSubview:close];
    
    _TXT_code.inputAccessoryView=phone_close;
   _TXT_code.inputView = _phone_picker_view;


    
}
-(void)countrybuttonClick
{
    [self.TXT_code resignFirstResponder];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_contents layoutIfNeeded];
    _scroll_contents.contentSize = CGSizeMake(_scroll_contents.frame.size.width,scroll_height);
    
}
#pragma text field delgates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField)
    {
        scroll_height = scroll_height + 100;
        [self viewDidLayoutSubviews];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField)
    {
        scroll_height = scroll_height - 100;
        [self viewDidLayoutSubviews];
    }
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger inte = _TXT_phone.text.length;
    if([_TXT_code.text isEqualToString:@"+974"])
    {
        
            if(inte == 8)
            {
                if ([string isEqualToString:@""])
                {
                    return YES;
                }
                else
                {
                    return NO;
                }
            }
        
        
    }
    else
    {
        if(inte >= 15)
        {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
    NSCharacterSet *notAllowedChar = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    NSString *resultStrin = [[_TXT_phone.text componentsSeparatedByCharactersInSet:notAllowedChar] componentsJoinedByString:@""];
    
    _TXT_phone.text = resultStrin;
    

    return YES;
}

#pragma Button Actions
- (IBAction)back_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)Pay_action
{
    NSString *msg;
    NSString *text_to_compare_email = _TXT_mail.text;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];

    if(_TXT_name.text.length < 1)
    {
        [_TXT_name becomeFirstResponder];
        msg = @"Please enter your name";
    }
    else if([emailTest evaluateWithObject:text_to_compare_email] == NO)
    {
        [_TXT_mail becomeFirstResponder];
        msg = @"Please enter valid email address";
        
        
    }
    else if ([_TXT_phone.text isEqualToString:@""])
    {
        [_TXT_phone becomeFirstResponder];
        msg = @"Please enter Phone Number";
        
        
        
    }
    if([_TXT_code.text isEqualToString:@"+974"])
    {
        if(_TXT_phone.text.length < 8)
        {
            [_TXT_phone becomeFirstResponder];
            msg = @"Phone Number cannot be less than 8 digits";
        }
        else if(_TXT_phone.text.length > 8)
        {
            [self.TXT_phone becomeFirstResponder];
            
            msg = @"Phone Number cannot be more than 8 digits";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"لا يجب ألا يقلّ رقم الجوال عن 8 أرقام ";
            }
        }

    }
    
    else
    {
        if (_TXT_phone.text.length < 5)
        {
            [_TXT_phone becomeFirstResponder];
            msg = @"Phone Number cannot be less than 5 digits";
        }
        
        
        
        
        else if(_TXT_phone.text.length>15)
        {
            [_TXT_phone becomeFirstResponder];
            msg = @"Phone Number should not be more than 15 characters";
            
            
        }
    }
         if([_TXT_phone.text isEqualToString:@" "])
        {
            [_TXT_phone becomeFirstResponder];
            msg = @"Blank space are not allowed";
            
            
        }
        else  if(_LBL_stat.tag == 0)
        {
            msg = @"Please accept the accept terms and conditions";
        }
        
        
    
    
    if(msg)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
    }
    else
        
    {
        
        [Helper_activity animating_images:self];
        [self performSelector:@selector(get_oreder_ID) withObject:nil afterDelay:0.01];
        
    }
    



}
#pragma mark Generating Order ID

-(void)get_oreder_ID
{
    @try
    {
        NSMutableArray *arr;NSString  *event_price_id; NSString *event_master_id;
        arr = [[NSMutableArray alloc]init];
        NSArray *temp_arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"cost_arr"];
        NSDictionary *event_dict =[[NSUserDefaults standardUserDefaults] valueForKey:@"event_dtl"];
        
        for(int j = 0;j< temp_arr.count;j++)
        {
            if([[[temp_arr objectAtIndex:j] valueForKey:@"quantity"] intValue] > 0)
            {
                NSString  *event_ticket_id = [NSString stringWithFormat:@"%@-%@",[[temp_arr objectAtIndex:j] valueForKey:@"ticket_ID"],[[temp_arr objectAtIndex:j] valueForKey:@"quantity"]];
                [arr addObject:event_ticket_id];
                event_master_id = [NSString stringWithFormat:@"%@",[[temp_arr objectAtIndex:j]valueForKey:@"ticket_master_ID"]];
            }
        }
        
        
        
        event_price_id = [arr componentsJoinedByString:@","];
        
        NSString *event_id = [NSString stringWithFormat:@"%@",[event_dict valueForKey:@"_eventid"]];
        
        NSString *str_count = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Amount_dict"] objectAtIndex:0]];
        NSString *str_price = [NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"Amount_dict"] objectAtIndex:1]];
        NSString *start_date = [[NSUserDefaults standardUserDefaults] valueForKey:@"event_book_date"];
        if([start_date isEqualToString:@"(null)"] ||[start_date isEqualToString:@"<null>"])
        {
            start_date = [event_dict valueForKey:@"_startDate"];
            
        }
        else{
            start_date = start_date;
        }
        NSString *start_time = [event_dict valueForKey:@"_StartTime"];
        NSLog(@"The appended string is:%@",event_price_id);
        NSString *str_prefix = _TXT_code.text;
        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@",1234567890"] invertedSet];
        NSString *resultString = [[str_prefix componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
        
        NSLog (@"Result: %@", resultString);

        str_prefix = resultString;

        NSString* Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
        NSLog(@"output is : %@", Identifier);
        NSString *str_url = [NSString stringWithFormat:@"https://api.q-tickets.com/V2.0/eventbookings?eventid=%@&ticket_id=%@&amount=%@&tkt_count=%@&NoOftktPerid=%@&camount=0&email=%@&name=%@&phone=%@&prefix=%@&bdate=%@&btime=%@&balamount=0&couponcodes=null&Source=11&AppVersion=1.0",event_id,event_master_id,str_price,str_count,event_price_id,_TXT_mail.text,_TXT_name.text,_TXT_phone.text,str_prefix,start_date,start_time];
        str_url = [str_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

        
        NSURL *URL = [[NSURL alloc] initWithString:str_url];  
        
        NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
        NSLog(@"The booking_data is:%@",xmlDoc);
        NSString *str_stat =[NSString stringWithFormat:@"%@",[[xmlDoc valueForKey:@"result"] valueForKey:@"_status"]];
        if(![xmlDoc valueForKey:@"result"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Some Thing Went Wrong" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
             [Helper_activity stop_activity_animation:self];
            // [self get_transaction_id];
        }

        else  if([str_stat isEqualToString:@"False"])
        {
             [Helper_activity stop_activity_animation:self];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[[xmlDoc valueForKey:@"result"] valueForKey:@"_errormsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        else
        {

        
        
        //_Transaction_Id
        
        // Saving User Data And Transaction ID
        //full_name, email, mobile, bookingId, movie_event,user_id
        
        NSDictionary *save_booking_dic = @{@"full_name":_TXT_name.text,@"email":_TXT_mail.text,@"mobile":_TXT_phone.text };
        
        [[NSUserDefaults standardUserDefaults]setObject:save_booking_dic forKey:@"savebooking"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:[xmlDoc valueForKey:@"result"]  forKey:@"order_details"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:[[xmlDoc valueForKey:@"result"] valueForKey:@"_orderid"] forKey:@"order_ID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [Helper_activity stop_activity_animation:self];
            [self performSegueWithIdentifier:@"user_detail_pay" sender:self];

        }
        // Move to next
    }
    @catch(NSException *exception)
    {
        
    }
    
    
}
-(void)BTN_chek_action
{
    if(_LBL_stat.tag == 1)
    {
        _LBL_stat.image = [UIImage imageNamed:@"uncheked_order"];
        [_LBL_stat setTag:0];
    }
    else if(_LBL_stat.tag == 0)
    {
        _LBL_stat.image = [UIImage imageNamed:@"checkbox_select.png"];
        [_LBL_stat setTag:1];
    }
    
}

- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [_phone_picker_view rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(_phone_picker_view.bounds, 0.0, (CGRectGetHeight(_phone_picker_view.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_phone_picker_view]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [_phone_picker_view selectedRowInComponent:0];
            [self pickerView:_phone_picker_view didSelectRow:selectedRow inComponent:0];
        }
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}
#pragma mark - UIPickerViewDataSource

// #3
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
   
        return 1;
   
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   
        return [phone_code_arr count];
   
}
#pragma mark - UIPickerViewDelegate


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   return [NSString stringWithFormat:@"%@   %@",[phone_code_arr[row] valueForKey:@"name"],[phone_code_arr[row] valueForKey:@"code"]];
    
}

// #6
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   
    @try {
        self.TXT_code.text = [phone_code_arr[row] valueForKey:@"code"];
        NSLog(@"the text is:%@",_TXT_code.text);
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
        
    
   }


#pragma mark picker_close_action
-(void)picker_close_action{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark WebViewDelegate Methods


-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //[self removeLoadingView];
    
    //[activityIndicatorView startAnimating];
   // VW_overlay.hidden = YES;
    NSLog(@"finish");
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    //[self removeLoadingView];
    NSLog(@"Error for WEBVIEW: %@", [error description]);
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
