//
//  VC_My_profile.m
//  Dohasooq_mobile
//
//  Created by Test User on 28/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_My_profile.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import  <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface VC_My_profile ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    float scroll_ht;
    NSMutableArray *countrypicker,*statepicker;
    NSDictionary *grouppicker;
    NSDictionary *user_dictionary;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
}

@end

@implementation VC_My_profile

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self set_UP_VIEW];
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    //    VW_overlay.layer.cornerRadius = 10.0;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    VW_overlay.hidden = YES;
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    
    [self performSelector:@selector(View_user_data) withObject:nil afterDelay:0.01];

    
}

-(void)set_UP_VIEW
{
    _BTN_save.hidden = YES;
    _BTN_save_billing.hidden = YES;
    
    CGRect frameset = _VW_profile.frame;
    //frameset.size.height = _BTN_male.frame.origin.y + _BTN_male.frame.size.height;
    frameset.size.width = _scroll_contents.frame.size.width;
    _VW_profile.frame = frameset;
    [self.scroll_contents addSubview:_VW_profile];
    
    frameset = _VW_layer.frame;
    frameset.size.height = _BTN_male.frame.origin.y + _BTN_male.frame.size.height + 12;
    _VW_layer.frame = frameset;
    
    frameset = _VW_login.frame;
    frameset.origin.y =_VW_layer.frame.origin.y+ _VW_layer.frame.size.height;
    frameset.size.width = _scroll_contents.frame.size.width;
    _VW_login.frame = frameset;
    [self.scroll_contents addSubview:_VW_login];
    
    frameset = _VW_billing.frame;
    frameset.origin.y =_VW_login.frame.origin.y+ _VW_login.frame.size.height;
    frameset.size.width = _scroll_contents.frame.size.width;
    _VW_billing.frame = frameset;
    [self.scroll_contents addSubview:_VW_billing];
    
    frameset = _VW_layer_billing.frame;
    frameset.size.height = _TXT_zipcode.frame.origin.y + _TXT_zipcode.frame.size.height + 12;
    _VW_layer_billing.frame = frameset;

    
    scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height;
    _BTN_bank_customer.tag = 0;
    _BTN_bank_employee.tag = 1;
    _BTN_male.tag = 1;
    _BTN_feamle.tag = 1;

    [_BTN_edit addTarget:self action:@selector(Button_edit_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_edit_billing addTarget:self action:@selector(Button_edit_billing_action) forControlEvents:UIControlEventTouchUpInside];

    [_BTN_bank_customer addTarget:self action:@selector(BTN_bank_customer_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_bank_employee addTarget:self action:@selector(BTN_bank_employee_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_male addTarget:self action:@selector(BTN_male_action) forControlEvents:UIControlEventTouchUpInside];
     [_BTN_feamle addTarget:self action:@selector(BTN_female_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_camera addTarget:self action:@selector(take_Picture) forControlEvents:UIControlEventTouchUpInside];
    _BTN_camera.layer.cornerRadius = _BTN_camera.frame.size.width/2;
    _BTN_camera.layer.masksToBounds = YES;
    
    _VW_layer.layer.borderWidth = 0.4f;
    _VW_layer.layer.borderColor =[UIColor lightGrayColor].CGColor;
    _VW_layer_login.layer.borderWidth = 0.4f;
    _VW_layer_login.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
    _VW_layer_billing.layer.borderWidth = 0.4f;
    _VW_layer_billing.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
    _VW_profile_pic.layer.cornerRadius = self.VW_profile_pic.frame.size.width/2;
    _VW_profile_pic.layer.masksToBounds = YES;
    
    _IMG_Profile_pic.layer.cornerRadius = self.IMG_Profile_pic.frame.size.width/2;
    _IMG_Profile_pic.layer.masksToBounds = YES;
    
    [_BTN_save addTarget:self action:@selector(Save_button_clicked) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_save_billing addTarget:self action:@selector(Save_button_Billing_clicked) forControlEvents:UIControlEventTouchUpInside];

    [self picker_SET_UP];
    [self TEXT_hidden];
    [self TEXT_billing_hidden];
    [self  View_user_data];


}
-(void)picker_SET_UP    //Picker_set
{
    _contry_pickerView = [[UIPickerView alloc] init];
    _contry_pickerView.delegate = self;
    _contry_pickerView.dataSource = self;
    _state_pickerView = [[UIPickerView alloc] init];
    _state_pickerView.delegate = self;
    _state_pickerView.dataSource = self;
    _group_pickerVIEW = [[UIPickerView alloc] init];
    _group_pickerVIEW.delegate = self;
    _group_pickerVIEW.dataSource = self;
    _date_picker = [[UIDatePicker alloc] init];
    _date_picker.datePickerMode = UIDatePickerModeDate;

    
    
    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(tappedToSelectRow:)];
    tapToSelect.delegate = self;
    [_contry_pickerView addGestureRecognizer:tapToSelect];
    UITapGestureRecognizer *satetap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(tappedToSelectRowstate:)];
    satetap.delegate = self;
    [_state_pickerView addGestureRecognizer:satetap];
    
    
    
    
    UIToolbar* conutry_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    conutry_close.barStyle = UIBarStyleBlackTranslucent;
    [conutry_close sizeToFit];
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(conutry_close.frame.size.width - 100, 0, 100, conutry_close.frame.size.height);
    [close setTitle:@"Done" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(countrybuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [conutry_close addSubview:close];
    _TXT_country.inputAccessoryView=conutry_close;
    _TXT_state.inputAccessoryView=conutry_close;
    _TXT_group.inputAccessoryView=conutry_close;
    _TXT_Dob.inputAccessoryView =conutry_close;

    self.TXT_country.inputView = _contry_pickerView;
    self.TXT_state.inputView=_state_pickerView;
    _TXT_group.inputView = _group_pickerVIEW;
     _TXT_Dob.inputView = _date_picker;

    _TXT_country.tintColor=[UIColor clearColor];
    _TXT_state.tintColor=[UIColor clearColor];
    _TXT_group.tintColor=[UIColor clearColor];
    _TXT_Dob.tintColor=[UIColor clearColor];

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    
    NSDate *min_date = [[NSDate alloc] init];
    NSString  *min = [NSString stringWithFormat:@"%@",[formatter stringFromDate:min_date]];
    min_date = [formatter dateFromString:min];
    [_date_picker setMaximumDate:min_date];
    [_date_picker addTarget:self action:@selector(fromdateTextField) forControlEvents:UIControlEventValueChanged];

    
    NSMutableArray *temp_arr = [[NSMutableArray alloc]init];
    countrypicker = [[NSMutableArray alloc]init];
     temp_arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"country_arr"];
    for(int i =0 ;i < temp_arr.count;i++)
    {
        [countrypicker addObject:[[temp_arr objectAtIndex:i]valueForKey:@"name"]];
    }
    [self customer_GROUP_API];
    
    
    // = [[NSUserDefaults standardUserDefaults] valueForKey:@"country_arr"];
}
-(void)countrybuttonClick
{
    [_TXT_state resignFirstResponder];
    [_TXT_country resignFirstResponder];
    [_TXT_group resignFirstResponder];
    [_TXT_Dob resignFirstResponder];


    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_contents layoutIfNeeded];
    _scroll_contents.contentSize = CGSizeMake(_scroll_contents.frame.size.width,scroll_ht);
}
#pragma Button Actions
-(void)Button_edit_action
{
  if([_BTN_edit.titleLabel.text isEqualToString:@""])
  {
      [_BTN_edit setTitle:@"" forState:UIControlStateNormal];
      _BTN_save.hidden = YES;
      CGRect frameset = _VW_profile.frame;
     // frameset.size.height = _BTN_male.frame.origin.y + _BTN_male.frame.size.height;
      _VW_profile.frame = frameset;
      
      frameset = _VW_layer.frame;
      frameset.size.height = _BTN_male.frame.origin.y + _BTN_male.frame.size.height + 12;
      _VW_layer.frame = frameset;

      
      frameset = _VW_login.frame;
      frameset.origin.y =_VW_layer.frame.origin.y+ _VW_layer.frame.size.height;
      frameset.size.width = _scroll_contents.frame.size.width;
      _VW_login.frame = frameset;
      
      frameset = _VW_billing.frame;
      frameset.origin.y =_VW_login.frame.origin.y+ _VW_login.frame.size.height;
      frameset.size.width = _scroll_contents.frame.size.width;
      _VW_billing.frame = frameset;
      
      scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height;


    //  [self viewDidLayoutSubviews];
      
  }
  else
  {
      [_BTN_edit setTitle:@"" forState:UIControlStateNormal];
      _BTN_save.hidden = NO;
      
      CGRect frameset = _VW_profile.frame;
      //frameset.size.height = _BTN_save.frame.origin.y + _BTN_save.frame.size.height;
      _VW_profile.frame = frameset;
      
      frameset = _VW_layer.frame;
      frameset.size.height = _BTN_save.frame.origin.y + _BTN_save.frame.size.height + 12;
      _VW_layer.frame = frameset;
      
      frameset = _VW_login.frame;
      frameset.origin.y =_VW_layer.frame.origin.y+ _VW_layer.frame.size.height;
      frameset.size.width = _scroll_contents.frame.size.width;
      _VW_login.frame = frameset;
      
      frameset = _VW_billing.frame;
      frameset.origin.y =_VW_login.frame.origin.y+ _VW_login.frame.size.height;
      frameset.size.width = _scroll_contents.frame.size.width;
      _VW_billing.frame = frameset;
      
      scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height;



      
     //  [self viewDidLayoutSubviews];
      
  }
     [self TEXT_hidden];
  
}
-(void)Button_edit_billing_action
{
    if([_BTN_edit_billing.titleLabel.text isEqualToString:@""])
    {
        [_BTN_edit_billing setTitle:@"" forState:UIControlStateNormal];
        _BTN_save_billing.hidden = YES;
        
        CGRect frameset = _VW_layer_billing.frame;
        frameset.size.height = _TXT_zipcode.frame.origin.y + _TXT_zipcode.frame.size.height + 12;
        _VW_layer_billing.frame = frameset;

        if(_BTN_save.hidden == YES)
        {
            scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height -_BTN_save.frame.size.height;
            
        }
        else
        {
            scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height +_BTN_save.frame.size.height+10;
        }

    }
    else
    {
        [_BTN_edit_billing setTitle:@"" forState:UIControlStateNormal];
        _BTN_save_billing.hidden = NO;
        
        CGRect frameset = _VW_billing.frame;
        frameset.size.height = _BTN_save_billing.frame.origin.y + _BTN_save_billing.frame.size.height;
        _VW_billing.frame = frameset;
        
        
        frameset = _VW_layer_billing.frame;
        frameset.size.height = _BTN_save_billing.frame.origin.y + _BTN_save_billing.frame.size.height + 12;
        _VW_layer_billing.frame = frameset;
        
        if(_BTN_save.hidden == YES)
        {
            scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height -_BTN_save.frame.size.height;
 
        }
        else
        {
        scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height +_BTN_save.frame.size.height-40;
        }


    }
    [self TEXT_billing_hidden];
}
-(void)BTN_bank_customer_action
{
    if(_BTN_bank_customer.tag == 0)
    {
        [_BTN_bank_customer setBackgroundImage:[UIImage imageNamed:@"checked_order"] forState:UIControlStateNormal];
        _BTN_bank_customer.tag = 1;
    }
    else
    {
        [_BTN_bank_customer setBackgroundImage:[UIImage imageNamed:@"uncheked_order"] forState:UIControlStateNormal];
        _BTN_bank_customer.tag = 0;
    }

    
}
-(void)BTN_bank_employee_action
{
    if(_BTN_bank_employee.tag == 1)
    {
    [_BTN_bank_employee setBackgroundImage:[UIImage imageNamed:@"checked_order"] forState:UIControlStateNormal];
        _BTN_bank_employee.tag = 0;
    }
    else
    {
    [_BTN_bank_employee setBackgroundImage:[UIImage imageNamed:@"uncheked_order"] forState:UIControlStateNormal];
        _BTN_bank_employee.tag = 1;
    }

}
-(void)BTN_male_action
{
    if(_BTN_male.tag == 1)
    {
        [_BTN_male setBackgroundImage:[UIImage imageNamed:@"radiobtn"] forState:UIControlStateNormal];
        _BTN_male.tag = 0;
          _BTN_feamle.tag = 1;
        [_BTN_feamle setBackgroundImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];

    }
    else
    {
        [_BTN_male setBackgroundImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        _BTN_male.tag = 1;
        _BTN_feamle.tag = 0;
    }

    
}
-(void)BTN_female_action
{
    if(_BTN_feamle.tag == 1)
    {
        [_BTN_feamle setBackgroundImage:[UIImage imageNamed:@"radiobtn"] forState:UIControlStateNormal];
        [_BTN_male setBackgroundImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];

        _BTN_feamle.tag = 0;
        _BTN_male.tag = 1;
    }
    else
    {
        [_BTN_feamle setBackgroundImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        _BTN_feamle.tag = 1;
        _BTN_male.tag = 0;
    }
    

}

#pragma Textfield delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == _TXT_city )
    {
        scroll_ht = scroll_ht + 100;
        [self viewDidLayoutSubviews];
    }
    else if(textField  == _TXT_address1)
    {
        scroll_ht = scroll_ht + 150;
        [self viewDidLayoutSubviews];
    }
    else if(textField == _TXT_zipcode)
    {
        scroll_ht = scroll_ht  + 200;
        [self viewDidLayoutSubviews];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _TXT_city )
    {
        scroll_ht = scroll_ht - 100;
       // [self viewDidLayoutSubviews];
    }
    else if(textField  == _TXT_address1)
    {
        scroll_ht = scroll_ht - 150;
       // [self viewDidLayoutSubviews];
    }
    else if(textField == _TXT_zipcode)
    {
        scroll_ht = scroll_ht  - 200;
        //[self viewDidLayoutSubviews];
    }
    

    
}
#pragma Picker_Actions

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == _contry_pickerView) {
        return 1;
    }if(pickerView==_state_pickerView)
    {
        return 1;
    }
    if(pickerView == _group_pickerVIEW)
    {
        return 1;
    }
    
    return 0;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _contry_pickerView) {
        return [countrypicker count];
    }
    if (pickerView == _state_pickerView) {
        return [statepicker count];
    }
    if(pickerView == _group_pickerVIEW)
    {
        return [[grouppicker allValues] count];
    }
    
    
    return 0;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == _contry_pickerView) {
        return countrypicker[row];
    }
    if (pickerView == _state_pickerView) {
        return statepicker[row];
    }
    if(pickerView == _group_pickerVIEW)
    {
        return [grouppicker allValues][row];
    }
    
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == _contry_pickerView) {
        self.TXT_country.text = countrypicker[row];
        NSLog(@"the text is:%@",_TXT_country.text);
       NSArray *temp_arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"country_arr"];

        [self states_API:[NSString stringWithFormat:@"%@",[temp_arr[row]valueForKey:@"id"]]];
        self.TXT_state.enabled=YES;
    }
    if (pickerView == _state_pickerView) {
        
        self.TXT_state.text=statepicker[row];
        self.TXT_email.enabled=YES;
    }
    if(pickerView == _group_pickerVIEW)
    {
        self.TXT_group.text  = [grouppicker allValues][row];
        [[NSUserDefaults standardUserDefaults] setValue:[grouppicker allKeys][row] forKey:@"groupid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [_contry_pickerView rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(_contry_pickerView.bounds, 0.0, (CGRectGetHeight(_contry_pickerView.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_contry_pickerView]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [_contry_pickerView selectedRowInComponent:0];
            [self pickerView:_contry_pickerView didSelectRow:selectedRow inComponent:0];
        }
    }
}
- (IBAction)tappedToSelectRowstate:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [_state_pickerView rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(_state_pickerView.bounds, 0.0, (CGRectGetHeight(_state_pickerView.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_state_pickerView]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [_state_pickerView selectedRowInComponent:0];
            [self pickerView:_state_pickerView didSelectRow:selectedRow inComponent:0];
        }
    }
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}
#pragma states API
-(void)states_API :(NSString *)country_id
{
    //http://192.168.0.171/dohasooq/apis/getstatebyconapi/countryid.json
    @try
    {
        NSError *error;
        // NSError *err;
        NSHTTPURLResponse *response = nil;
        //   Languages/getLangByCountry/"+countryid+".json
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/getstatebyconapi/%@.json",SERVER_URL,country_id];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        // [request setHTTPBody:postData];
        //[request setAllHTTPHeaderFields:headers];
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(aData)
        {
            NSArray *json_DATA = (NSArray *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response Api post sighn up API %@",json_DATA);
            statepicker = [[NSMutableArray alloc]init];
            for(int i= 0;i<json_DATA.count;i++)
            {
                [statepicker addObject:[[json_DATA objectAtIndex:i] valueForKey:@"value"]];
            }
            
            
            
        }
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }

}
-(void)customer_GROUP_API
{
    //http://192.168.0.171/dohasooq/apis/getstatebyconapi/countryid.json
    @try
    {
        NSError *error;
        // NSError *err;
        NSHTTPURLResponse *response = nil;
        //   Languages/getLangByCountry/"+countryid+".json
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/customerGroupapi.json",SERVER_URL];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        // [request setHTTPBody:postData];
        //[request setAllHTTPHeaderFields:headers];
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(aData)
        {
            grouppicker = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response Api post sighn up API %@",grouppicker);
            
          //  [grouppicker addObject:[json_DATA allValues]];
            
        }
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}
#pragma API VIEW user data
-(void)View_user_data
{
    //http://192.168.0.171/dohasooq/apis/getstatebyconapi/countryid.json
    @try
    {
        NSError *error;
        // NSError *err;
        NSHTTPURLResponse *response = nil;
        //   Languages/getLangByCountry/"+countryid+".json
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/my-account/1/%@.json",SERVER_URL,user_id];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        // [request setHTTPBody:postData];
        //[request setAllHTTPHeaderFields:headers];
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(aData)
        {
           user_dictionary = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response Api post sighn up API %@",user_dictionary);
            
            [self set_DATA];
        }
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
}
-(void)set_DATA
{
    NSString *STR_fname = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"firstname"]];
     NSString *STR_lname = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"lastname"]];
     NSString *STR_land_phone = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"lnumber"]];
     NSString *STR_mobile = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"mnumber"]];
     NSString *STR_dob = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"bdate"]];
    NSArray *temp_arr = [STR_dob componentsSeparatedByString:@"T"];
    STR_dob = [temp_arr objectAtIndex:0];
     NSString *STR_customer_group = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"customer_grp_name"]];
     NSString *STR_bank_customer = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"doha_bank_customer"]];
     NSString *STR_bank_employee = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"doha_bank_employee"]];
     NSString *STR_gender = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"gender"]];
     NSString *STR_city = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"city"]];
     NSString *STR_address = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"address"]];
     NSString *STR_country = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"country_name"]];
     NSString *STR_state= [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"state_name"]];
    NSString *STR_zip_code= [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"zipcode"]];
    
    
    STR_fname = [STR_fname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_fname = [STR_fname stringByReplacingOccurrencesOfString:@"(ull)" withString:@""];
    STR_lname = [STR_lname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_lname = [STR_lname stringByReplacingOccurrencesOfString:@"(ull)" withString:@""];
    STR_land_phone = [STR_land_phone stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_land_phone = [STR_land_phone stringByReplacingOccurrencesOfString:@"(ull)" withString:@""];
    STR_mobile = [STR_mobile stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_mobile = [STR_mobile stringByReplacingOccurrencesOfString:@"(ull)" withString:@""];
    STR_dob = [STR_dob stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_dob = [STR_dob stringByReplacingOccurrencesOfString:@"(ull)" withString:@""];
    STR_customer_group = [STR_customer_group stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_customer_group = [STR_customer_group stringByReplacingOccurrencesOfString:@"(ull)" withString:@""];
    STR_bank_customer = [STR_bank_customer stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_bank_customer = [STR_bank_customer stringByReplacingOccurrencesOfString:@"(ull)" withString:@""];
    STR_bank_employee = [STR_bank_customer stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_bank_employee = [STR_bank_customer stringByReplacingOccurrencesOfString:@"(ull)" withString:@""];
    STR_gender = [STR_gender stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_gender = [STR_gender stringByReplacingOccurrencesOfString:@"(ull)" withString:@""];
    STR_city = [STR_city stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_city = [STR_city stringByReplacingOccurrencesOfString:@"(ull)" withString:@""];
    STR_address = [STR_address stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_address = [STR_address stringByReplacingOccurrencesOfString:@"(ull)" withString:@""];
    STR_country = [STR_country stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_country = [STR_country stringByReplacingOccurrencesOfString:@"(ull)" withString:@""];
    STR_state = [STR_state stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_state = [STR_state stringByReplacingOccurrencesOfString:@"(ull)" withString:@""];
    STR_zip_code = [STR_zip_code stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_zip_code = [STR_zip_code stringByReplacingOccurrencesOfString:@"(ull)" withString:@""];
    
    
    
    _TXT_first_name.text = STR_fname;
    _TXT_last_name.text = STR_lname;
    _TXT_land_phone.text = STR_land_phone;
    _TXT_mobile_phone.text = STR_mobile;
    _TXT_Dob.text = STR_dob;
    _TXT_group.text = STR_customer_group;
    _TXT_name.text = [NSString stringWithFormat:@"%@%@",STR_fname,STR_lname];
    _TXT_country.text = STR_country;
    _TXT_state.text = STR_state;
    _TXT_address1.text = STR_address;
    _TXT_city.text = STR_city;
    _TXT_zipcode.text = STR_zip_code;
    _TXT_email.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_email"];
    
    
    if([STR_bank_customer isEqualToString:@"No"])
    {
        
        _BTN_bank_customer.tag = 1;
    }
    else if([STR_bank_customer isEqualToString:@"Yes"])
    {
        _BTN_bank_customer.tag = 0;
    }
    [self BTN_bank_customer_action];
    
    if([STR_bank_employee isEqualToString:@"No"])
    {
        
        _BTN_bank_employee.tag = 0;
    }
    else if([STR_bank_employee isEqualToString:@"Yes"])
    {
        _BTN_bank_employee.tag = 1;
    }
    [self BTN_bank_employee_action];
    
    if([STR_gender isEqualToString:@"Male"])
    {
       
        _BTN_male.tag = 1;
        
    }
    else
    {
        _BTN_male.tag = 0;
    }
    [self BTN_male_action];
    if([STR_gender isEqualToString:@"Female"])
    {
        
        _BTN_feamle.tag = 1;
        
        
    }
    else
    {
        _BTN_feamle.tag = 0;
    }
   [self BTN_female_action];

    
    NSString *img_url = [NSString stringWithFormat:@"%@%@%@",SERVER_URL,[[user_dictionary valueForKey:@"detail"] valueForKey:@"profile_path"],[[user_dictionary valueForKey:@"detail"] valueForKey:@"profile_img"]];
    
    [_IMG_Profile_pic sd_setImageWithURL:[NSURL URLWithString:img_url]
                     placeholderImage:[UIImage imageNamed:@"logo.png"]
                              options:SDWebImageRefreshCached];

    
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    
}

-(void)TEXT_hidden
{
    if(_BTN_save.hidden == YES )
    {
        _TXT_first_name.enabled = NO;
        _TXT_last_name.enabled = NO;
        _TXT_name.enabled = NO;
        _TXT_land_phone.enabled = NO;
        _TXT_mobile_phone.enabled = NO;
        _TXT_group.enabled = NO;
        _TXT_Dob.enabled = NO;
        _TXT_email.enabled = NO;
        _BTN_male.enabled = NO;
        _BTN_feamle.enabled = NO;
        _BTN_bank_customer.enabled = NO;
        
        
        
    }
    else{
        _TXT_first_name.enabled = NO;
        _TXT_last_name.enabled = NO;
        _TXT_name.enabled = NO;
        _TXT_land_phone.enabled = YES;
        _TXT_mobile_phone.enabled = YES;
        _TXT_group.enabled = YES;
        _TXT_Dob.enabled = YES;
        _TXT_email.enabled = NO;
        _BTN_male.enabled = YES;
        _BTN_feamle.enabled = YES;
        _BTN_bank_customer.enabled = YES;

        
    }
}
-(void)TEXT_billing_hidden
{
    if(_BTN_save_billing.hidden == YES)
    {
    _TXT_country.enabled = NO;
    _TXT_state.enabled = NO;
    _TXT_city.enabled = NO;
    _TXT_address1.enabled = NO;
    _TXT_address2.enabled = NO;
    _TXT_zipcode.enabled = NO;
    }
    else
    {
    _TXT_country.enabled = YES;
    _TXT_state.enabled = YES;
    _TXT_city.enabled = YES;
    _TXT_address1.enabled = YES;
    _TXT_address2.enabled = YES;
    _TXT_zipcode.enabled = YES;

    }
}
-(void)fromdateTextField
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = _date_picker.date;
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    _TXT_Dob.text = [NSString stringWithFormat:@"%@",dateString];
}
- (IBAction)back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma Post Data
-(void)Save_button_clicked
{
    NSString *msg;
    if ([_TXT_land_phone.text isEqualToString:@""])
    {
        [_TXT_land_phone becomeFirstResponder];
        msg = @"Please enter Phone Number";
        
        
        
    }
    
    else if (_TXT_land_phone.text.length < 5)
    {
        [_TXT_land_phone becomeFirstResponder];
        msg = @"Phone Number cannot be less than 5 digits";
        
        
        
    }
    else if(_TXT_land_phone.text.length>15)
    {
        [_TXT_land_phone becomeFirstResponder];
        msg = @"Phone Number should not be more than 15 characters";
        
        
    }
    else if([_TXT_land_phone.text isEqualToString:@" "])
    {
        [_TXT_land_phone becomeFirstResponder];
        msg = @"Blank space are not allowed";
        
        
    }

    else if ([_TXT_mobile_phone.text isEqualToString:@""])
    {
        [_TXT_mobile_phone becomeFirstResponder];
        msg = @"Please enter Phone Number";
        
        
        
    }
    
    else if (_TXT_mobile_phone.text.length < 5)
    {
        [_TXT_mobile_phone becomeFirstResponder];
        msg = @"Phone Number cannot be less than 5 digits";
        
        
        
    }
    else if(_TXT_mobile_phone.text.length>15)
    {
        [_TXT_mobile_phone becomeFirstResponder];
        msg = @"Phone Number should not be more than 15 characters";
        
        
    }
    else if([_TXT_mobile_phone.text isEqualToString:@" "])
    {
        [_TXT_mobile_phone becomeFirstResponder];
        msg = @"Blank space are not allowed";
        
        
    }
    else if([_TXT_group.text isEqualToString:@" "])
    {
        [_TXT_group becomeFirstResponder];
        msg = @"Blank space are not allowed";
        
        
    }
  else if( _BTN_male.tag == 1 && _BTN_feamle.tag == 1)
   {
    msg = @"Please select gender";
   }
  else
  {
      VW_overlay.hidden = NO;
      [activityIndicatorView startAnimating];
      
      [self performSelector:@selector(Edit_user_data) withObject:nil afterDelay:0.01];
      
  }

    if(msg)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
    }

    
    
}
-(void)Edit_user_data
{
    @try
    {
        NSString *gender;
        if(_BTN_male.tag == 0 && _BTN_feamle.tag == 1)
        {
            gender = @"Male";
        }
        else if(_BTN_feamle.tag == 0 && _BTN_male.tag == 1)
        {
            gender = @"Female";
        }
        
        NSString *fname = _TXT_first_name.text;
        NSString *lname = _TXT_last_name.text;
      //  NSString *email = _TXT_email.text;
        NSString *phone_num = _TXT_land_phone.text;
        NSString *mobile_num = _TXT_mobile_phone.text;
        NSString *customer_group = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"groupid"]];
        NSString *dob = _TXT_Dob.text;
        NSString *dohabank_customer;
       
        dohabank_customer = [NSString stringWithFormat:@"%ld",(long)_BTN_bank_customer.tag];
        
        NSString *dohabank_employee = @"0";

        
        NSError *error;
        NSError *err;
        NSHTTPURLResponse *response = nil;
        
        NSDictionary *parameters = @{ @"first_name": fname,
                                      @"last_name": lname,
                                      @"phone": phone_num,
                                      @"mobile": mobile_num,
                                      @"dob":dob,
                                      @"customer_group_id":customer_group,
                                      @"dohabank_customer":dohabank_customer,
                                      @"dohabank_employee":dohabank_employee,
                                      @"gender":gender
                                      };
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
        NSLog(@"the posted data is:%@",parameters);
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/my-account/2/%@.json",SERVER_URL,user_id];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        //[request setAllHTTPHeaderFields:headers];
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(aData)
        {
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;
            
            NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSString *status = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
            if([status isEqualToString:@"1"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
                
            }
            [self View_user_data];
        }
        else
        {
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    }
    @catch(NSException *exception)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
    }
    
}
-(void)Save_button_Billing_clicked
{
    NSString *msg;
    if ([_TXT_state.text isEqualToString:@""])
    {
        [_TXT_state becomeFirstResponder];
        msg = @"Please select State";
        
    }
    
    else if ([_TXT_country.text isEqualToString:@""])
    {
        [_TXT_country becomeFirstResponder];
        msg = @"Please select State";
        
        
        
    }
    else if(_TXT_city.text.length < 3)
    {
        [_TXT_city becomeFirstResponder];
        msg = @"City name should be more than 3 characters";
        
        
    }
    else if(_TXT_city.text.length < 1)
    {
        [_TXT_city becomeFirstResponder];
        msg = @"Please enter city";
        
        
    }
    else if(_TXT_address1.text.length < 3)
    {
        [_TXT_address1 becomeFirstResponder];
        msg = @"Address name should be more than 3 characters";
        
        
    }
    else if(_TXT_address1.text.length < 1)
    {
        [_TXT_address1 becomeFirstResponder];
        msg = @"Please enter Address";
        
        
    }

    else if(_TXT_zipcode.text.length < 3)
    {
        [_TXT_zipcode becomeFirstResponder];
        msg = @"Zipcode name should be more than 3 characters";
        
        
    }
    else if(_TXT_zipcode.text.length < 1)
    {
        [_TXT_zipcode becomeFirstResponder];
        msg = @"Please enter Zipcode";
        
        
    }
    else
    {
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(Edit_billing_addres) withObject:nil afterDelay:0.01];
    }
    if(msg)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
    }

}
-(void)Edit_billing_addres
{
    @try
    {
    NSString *country = _TXT_country.text;
    NSString *state = _TXT_state.text;
    NSString *city = _TXT_city.text;
    NSString *address = _TXT_address1.text;
    NSString *zipcode = _TXT_zipcode.text;
    
    NSError *error;
    NSError *err;
    NSHTTPURLResponse *response = nil;
    
    NSDictionary *parameters = @{ @"country_id": country,
                                  @"state_id": state,
                                  @"city": city,
                                  @"address1": address,
                                  @"zip_code":zipcode
                                  };
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
    NSLog(@"the posted data is:%@",parameters);
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/my-account/3/%@.json",SERVER_URL,user_id];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    //[request setAllHTTPHeaderFields:headers];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(aData)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        
        NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
        NSString *status = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
        if([status isEqualToString:@"1"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
             [self View_user_data];
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            
        }
       
    }
    else
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    }

@catch(NSException *exception)
{
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}

}
-(void)take_Picture
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick From"
                                                             delegate:self
                                                    cancelButtonTitle:@"cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"From Gallery", nil];
    
    [actionSheet showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if (buttonIndex == 0)
    {
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else if (buttonIndex == 1)
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[refURL] options:nil];
    NSString *filename = [[result firstObject] filename];
    
    _IMG_Profile_pic.image = chosenImage;
    [self send_Image:filename];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)send_Image:(NSString *)image
{
//    NSHTTPURLResponse *response = nil;
//    NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
//                               @"cache-control": @"no-cache",
//                               @"postman-token": @"41e487bc-2105-a77f-084e-d4281f54dc43" };
//    NSArray *parameters = @[ @{ @"name": @"logo", @"fileName": image } ];
//    NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
//    
//    NSError *error;
//    NSMutableString *body = [NSMutableString string];
//    for (NSDictionary *param in parameters) {
//        [body appendFormat:@"--%@\r\n", boundary];
//        if (param[@"fileName"]) {
//            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
//            [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
//            [body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
//            if (error) {
//                NSLog(@"%@", error);
//            }
//        } else {
//            [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
//            [body appendFormat:@"%@", param[@"value"]];
//        }
//    }
//    [body appendFormat:@"\r\n--%@--\r\n", boundary];
//    NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
//    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
//    NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/my-account/3/%@.json",SERVER_URL,user_id];
//    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:urlProducts];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
//    [request setAllHTTPHeaderFields:headers];
//    [request setHTTPShouldHandleCookies:NO];
//    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if(aData)
//    {
//        NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
//        NSString *status = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
//        if([status isEqualToString:@"1"])
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//            [alert show];
//            [self  View_user_data];
//            NSString *img_url = [NSString stringWithFormat:@"%@%@%@",SERVER_URL,[[user_dictionary valueForKey:@"detail"] valueForKey:@"profile_path"],[[user_dictionary valueForKey:@"detail"] valueForKey:@"profile_img"]];
//            
//            [_IMG_Profile_pic sd_setImageWithURL:[NSURL URLWithString:img_url]
//                                placeholderImage:[UIImage imageNamed:@"logo.png"]
//                                         options:SDWebImageRefreshCached];
//
//            
//        }
//        else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//            [alert show];
//            
//        }
//
//
//    }
    
    
    
        NSDictionary *headers = @{ @"content-type": @"multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
                                   @"cache-control": @"no-cache",
                                   @"postman-token": @"00352018-826e-50fd-ce31-ac69b40ab330" };
        NSArray *parameters = @[ @{ @"name": @"logo", @"fileName": image } ];
        NSString *boundary = @"----WebKitFormBoundary7MA4YWxkTrZu0gW";
        
        NSError *error;
        NSMutableString *body = [NSMutableString string];
        for (NSDictionary *param in parameters) {
            [body appendFormat:@"--%@\r\n", boundary];
            if (param[@"fileName"]) {
                [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"; filename=\"%@\"\r\n", param[@"name"], param[@"fileName"]];
                [body appendFormat:@"Content-Type: %@\r\n\r\n", param[@"contentType"]];
                [body appendFormat:@"%@", [NSString stringWithContentsOfFile:param[@"fileName"] encoding:NSUTF8StringEncoding error:&error]];
                if (error) {
                    NSLog(@"%@", error);
                }
            } else {
                [body appendFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n\r\n", param[@"name"]];
                [body appendFormat:@"%@", param[@"value"]];
            }
        }
        [body appendFormat:@"\r\n--%@--\r\n", boundary];
        NSData *postData = [body dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.0.171/dohasooq/customers/my-account/4/27.json"]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:10.0];
        [request setHTTPMethod:@"POST"];
        [request setAllHTTPHeaderFields:headers];
        [request setHTTPBody:postData];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            NSLog(@"%@", error);
                                                        } else {
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                            NSLog(@"%@", httpResponse);
                                                        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:&error];
                                                                if(aData)
                                                                {
                                                                    NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
                                                                    NSLog(@"THe data is:%@",json_DATA);
                                                                }

                                                        }
                                                    }];
        [dataTask resume];
    //    if(aData)
    //    {
    //        NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];

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
