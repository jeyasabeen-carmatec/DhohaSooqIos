//
//  VC_movie_user_detail.m
//  Dohasooq_mobile
//
//  Created by Test User on 13/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_movie_user_detail.h"
#import "XMLDictionary/XMLDictionary.h"
#import "VC_Movie_booking.h"
#import "HttpClient.h"

@interface VC_movie_user_detail ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIWebViewDelegate>

{
    float scroll_height;
    NSMutableArray *phone_code_arr;
    UIView *VW_overlay;
   // UIActivityIndicatorView *activityIndicatorView;
    NSDictionary *temp_dict;
    NSArray *country_arr;
}


@end

@implementation VC_movie_user_detail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    phone_code_arr = [[NSMutableArray alloc]init];
    CGRect frameset = _VW_contents.frame;
    frameset.size.height = _BTN_pay.frame.origin.y + _BTN_pay.frame.size.height;
    frameset.size.width = _scroll_contents.frame.size.width;
    _VW_contents.frame = frameset;
    [self.scroll_contents addSubview:_VW_contents];
    @try
    {
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    if (dict.count != 0) {
        
        _TXT_mail.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_email"];
        _TXT_name.text = [dict valueForKey:@"firstname"];
        
    }
    }@catch(NSException *exception)
    {
        
    }
    
    @try
    {
        temp_dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"Amount_dict"];
        _LBL_amount.text = [NSString stringWithFormat:@"%@ %@",[[temp_dict valueForKey:@"result"] valueForKey:@"_ticketprice"],[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
        _LBL_service_charges.text = [NSString stringWithFormat:@"%@ %@",[[temp_dict valueForKey:@"result"] valueForKey:@"_servicecharges"],[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
        _LBL_total_charge.text = [NSString stringWithFormat:@"%d %@",[[[temp_dict valueForKey:@"result"] valueForKey:@"_ticketprice"] intValue]+[[[temp_dict valueForKey:@"result"] valueForKey:@"_servicecharges"] intValue],[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
        
        int result = [[[temp_dict valueForKey:@"result"] valueForKey:@"_servicecharges"] intValue] +[[[temp_dict valueForKey:@"result"] valueForKey:@"_ticketprice"] intValue];
        NSString *charge = [NSString stringWithFormat:@"%d",result];
        
        [[NSUserDefaults standardUserDefaults] setValue:charge forKey:@"charges"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
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
    
    self.navigationController.navigationBar.hidden = NO;

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
    NSArray *sorted_arr = [phone_code_arr sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSLog(@"%@",sorted_arr);
    
    
    
    
    
    //phone_code_arr = [NSMutableArray arrayWithArray:[codes allValues]];
//   country_arr = [codes allKeys];
//    [[NSUserDefaults standardUserDefaults] setObject:country_arr forKey:@"country_array"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _phone_picker_view = [[UIPickerView alloc] init];
    _phone_picker_view.delegate = self;
    _phone_picker_view.dataSource = self;
    
    
    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(tappedToSelectRow:)];
    tapToSelect.delegate = self;
    [_phone_picker_view addGestureRecognizer:tapToSelect];
    
    
    
    
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
#pragma Button Actions
- (IBAction)back_action:(id)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
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
    
    else if (_TXT_phone.text.length < 5)
    {
        [_TXT_phone becomeFirstResponder];
        msg = @"Phone Number cannot be less than 5 digits";
        
        
        
    }
    else if(_TXT_phone.text.length>15)
    {
        [_TXT_phone becomeFirstResponder];
        msg = @"Phone Number should not be more than 15 characters";
        
        
    }
    else if([_TXT_phone.text isEqualToString:@" "])
    {
        [_TXT_phone becomeFirstResponder];
        msg = @"Blank space are not allowed";
        
        
    }
    else  if(_LBL_stat.tag == 0)
    {
        msg = @"Please accept the accept terms and conditions";
    }
    
    
    else
        
    {

        [HttpClient animating_images:self];
    [self performSelector:@selector(get_transaction_id) withObject:nil afterDelay:0.01];
        
    }
    
    
    if(msg)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
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
        _LBL_stat.image = [UIImage imageNamed:@"checked_order"];
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
    //return [NSString stringWithFormat:@"%@  %@",country_arr [row],phone_code_arr[row]];
    
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
#pragma mark Get Transaction ID For Generate Booking ID/Order ID


-(void)get_transaction_id
{
    @try
    {
        NSString *str_prefix =_TXT_code.text;
        str_prefix = [str_prefix stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString *str_url = [NSString stringWithFormat:@"https://api.q-tickets.com/V2.0/send_lock_request?Transaction_Id=%@&name=%@&email=%@&mobile=%@&prefix=%@&VoucherCodes=null",[[temp_dict valueForKey:@"result"] valueForKey:@"_Transaction_Id"],_TXT_name.text,_TXT_mail.text,_TXT_phone.text,str_prefix];
    
    NSURL *URL = [[NSURL alloc] initWithString:str_url];
    
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    NSLog(@"The booking_data is:%@",xmlDoc);
    [HttpClient stop_activity_animation];
    if(![xmlDoc valueForKey:@"result"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Some Thing Went Wrong" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        [self get_transaction_id];
    }
    else
    {
        
        //_Transaction_Id
        
        // Saving User Data And Transaction ID
        //full_name, email, mobile, bookingId, movie_event,user_id
        
        NSDictionary *save_booking_dic = @{@"full_name":_TXT_name.text,@"email":_TXT_mail.text,@"mobile":_TXT_phone.text };
        
        [[NSUserDefaults standardUserDefaults]setObject:save_booking_dic forKey:@"savebooking"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        // Optional
        
        [[NSUserDefaults standardUserDefaults] setValue:[[xmlDoc valueForKey:@"result"] valueForKey:@"_Transaction_Id"] forKey:@"TID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [HttpClient stop_activity_animation];
        
        [self performSegueWithIdentifier:@"movie_user_detail_pay" sender:self];
    }
    
    }
    @catch(NSException *Exception)
    {
       [HttpClient stop_activity_animation];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
