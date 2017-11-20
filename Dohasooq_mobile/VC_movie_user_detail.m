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

@interface VC_movie_user_detail ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

{
    float scroll_height;
    NSMutableArray *phone_code_arr;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSDictionary *temp_dict;
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
        temp_dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"Amount_dict"];
        _LBL_amount.text = [NSString stringWithFormat:@"%@ QR",[[temp_dict valueForKey:@"result"] valueForKey:@"_ticketprice"]];
        _LBL_service_charges.text = [NSString stringWithFormat:@"%@ QR",[[temp_dict valueForKey:@"result"] valueForKey:@"_servicecharges"]];
        
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
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.hidden = NO;

    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    //    VW_overlay.layer.cornerRadius = 10.0;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    [self.view addSubview:VW_overlay];
    
    VW_overlay.hidden = YES;
    
    
    
    
}

-(void)phone_code_view
{
    NSDictionary *codes = @{
                            @"Canada"                                       : @"+1",
                            @"China"                                        : @"+86",
                            @"France"                                       : @"+33",
                            @"Germany"                                      : @"+49",
                            @"India"                                        : @"+91",
                            @"Japan"                                        : @"+81",
                            @"Pakistan"                                     : @"+92",
                            @"United Kingdom"                               : @"+44",
                            @"United States"                                : @"+1",
                            @"Abkhazia"                                     : @"+7 840",
                            @"Abkhazia"                                     : @"+7 940",
                            @"Afghanistan"                                  : @"+93",
                            @"Albania"                                      : @"+355",
                            @"Algeria"                                      : @"+213",
                            @"American Samoa"                               : @"+1 684",
                            @"Andorra"                                      : @"+376",
                            @"Angola"                                       : @"+244",
                            @"Anguilla"                                     : @"+1 264",
                            @"Antigua and Barbuda"                          : @"+1 268",
                            @"Argentina"                                    : @"+54",
                            @"Armenia"                                      : @"+374",
                            @"Aruba"                                        : @"+297",
                            @"Ascension"                                    : @"+247",
                            @"Australia"                                    : @"+61",
                            @"Australian External Territories"              : @"+672",
                            @"Austria"                                      : @"+43",
                            @"Azerbaijan"                                   : @"+994",
                            @"Bahamas"                                      : @"+1 242",
                            @"Bahrain"                                      : @"+973",
                            @"Bangladesh"                                   : @"+880",
                            @"Barbados"                                     : @"+1 246",
                            @"Barbuda"                                      : @"+1 268",
                            @"Belarus"                                      : @"+375",
                            @"Belgium"                                      : @"+32",
                            @"Belize"                                       : @"+501",
                            @"Benin"                                        : @"+229",
                            @"Bermuda"                                      : @"+1 441",
                            @"Bhutan"                                       : @"+975",
                            @"Bolivia"                                      : @"+591",
                            @"Bosnia and Herzegovina"                       : @"+387",
                            @"Botswana"                                     : @"+267",
                            @"Brazil"                                       : @"+55",
                            @"British Indian Ocean Territory"               : @"+246",
                            @"British Virgin Islands"                       : @"+1 284",
                            @"Brunei"                                       : @"+673",
                            @"Bulgaria"                                     : @"+359",
                            @"Burkina Faso"                                 : @"+226",
                            @"Burundi"                                      : @"+257",
                            @"Cambodia"                                     : @"+855",
                            @"Cameroon"                                     : @"+237",
                            @"Canada"                                       : @"+1",
                            @"Cape Verde"                                   : @"+238",
                            @"Cayman Islands"                               : @"+ 345",
                            @"Central African Republic"                     : @"+236",
                            @"Chad"                                         : @"+235",
                            @"Chile"                                        : @"+56",
                            @"China"                                        : @"+86",
                            @"Christmas Island"                             : @"+61",
                            @"Cocos-Keeling Islands"                        : @"+61",
                            @"Colombia"                                     : @"+57",
                            @"Comoros"                                      : @"+269",
                            @"Congo"                                        : @"+242",
                            @"Congo, Dem. Rep. of (Zaire)"                  : @"+243",
                            @"Cook Islands"                                 : @"+682",
                            @"Costa Rica"                                   : @"+506",
                            @"Ivory Coast"                                  : @"+225",
                            @"Croatia"                                      : @"+385",
                            @"Cuba"                                         : @"+53",
                            @"Curacao"                                      : @"+599",
                            @"Cyprus"                                       : @"+537",
                            @"Czech Republic"                               : @"+420",
                            @"Denmark"                                      : @"+45",
                            @"Diego Garcia"                                 : @"+246",
                            @"Djibouti"                                     : @"+253",
                            @"Dominica"                                     : @"+1 767",
                            @"Dominican Republic"                           : @"+1 809",
                            @"Dominican Republic"                           : @"+1 829",
                            @"Dominican Republic"                           : @"+1 849",
                            @"East Timor"                                   : @"+670",
                            @"Easter Island"                                : @"+56",
                            @"Ecuador"                                      : @"+593",
                            @"Egypt"                                        : @"+20",
                            @"El Salvador"                                  : @"+503",
                            @"Equatorial Guinea"                            : @"+240",
                            @"Eritrea"                                      : @"+291",
                            @"Estonia"                                      : @"+372",
                            @"Ethiopia"                                     : @"+251",
                            @"Falkland Islands"                             : @"+500",
                            @"Faroe Islands"                                : @"+298",
                            @"Fiji"                                         : @"+679",
                            @"Finland"                                      : @"+358",
                            @"France"                                       : @"+33",
                            @"French Antilles"                              : @"+596",
                            @"French Guiana"                                : @"+594",
                            @"French Polynesia"                             : @"+689",
                            @"Gabon"                                        : @"+241",
                            @"Gambia"                                       : @"+220",
                            @"Georgia"                                      : @"+995",
                            @"Germany"                                      : @"+49",
                            @"Ghana"                                        : @"+233",
                            @"Gibraltar"                                    : @"+350",
                            @"Greece"                                       : @"+30",
                            @"Greenland"                                    : @"+299",
                            @"Grenada"                                      : @"+1 473",
                            @"Guadeloupe"                                   : @"+590",
                            @"Guam"                                         : @"+1 671",
                            @"Guatemala"                                    : @"+502",
                            @"Guinea"                                       : @"+224",
                            @"Guinea-Bissau"                                : @"+245",
                            @"Guyana"                                       : @"+595",
                            @"Haiti"                                        : @"+509",
                            @"Honduras"                                     : @"+504",
                            @"Hong Kong SAR China"                          : @"+852",
                            @"Hungary"                                      : @"+36",
                            @"Iceland"                                      : @"+354",
                            @"India"                                        : @"+91",
                            @"Indonesia"                                    : @"+62",
                            @"Iran"                                         : @"+98",
                            @"Iraq"                                         : @"+964",
                            @"Ireland"                                      : @"+353",
                            @"Israel"                                       : @"+972",
                            @"Italy"                                        : @"+39",
                            @"Jamaica"                                      : @"+1 876",
                            @"Japan"                                        : @"+81",
                            @"Jordan"                                       : @"+962",
                            @"Kazakhstan"                                   : @"+7 7",
                            @"Kenya"                                        : @"+254",
                            @"Kiribati"                                     : @"+686",
                            @"North Korea"                                  : @"+850",
                            @"South Korea"                                  : @"+82",
                            @"Kuwait"                                       : @"+965",
                            @"Kyrgyzstan"                                   : @"+996",
                            @"Laos"                                         : @"+856",
                            @"Latvia"                                       : @"+371",
                            @"Lebanon"                                      : @"+961",
                            @"Lesotho"                                      : @"+266",
                            @"Liberia"                                      : @"+231",
                            @"Libya"                                        : @"+218",
                            @"Liechtenstein"                                : @"+423",
                            @"Lithuania"                                    : @"+370",
                            @"Luxembourg"                                   : @"+352",
                            @"Macau SAR China"                              : @"+853",
                            @"Macedonia"                                    : @"+389",
                            @"Madagascar"                                   : @"+261",
                            @"Malawi"                                       : @"+265",
                            @"Malaysia"                                     : @"+60",
                            @"Maldives"                                     : @"+960",
                            @"Mali"                                         : @"+223",
                            @"Malta"                                        : @"+356",
                            @"Marshall Islands"                             : @"+692",
                            @"Martinique"                                   : @"+596",
                            @"Mauritania"                                   : @"+222",
                            @"Mauritius"                                    : @"+230",
                            @"Mayotte"                                      : @"+262",
                            @"Mexico"                                       : @"+52",
                            @"Micronesia"                                   : @"+691",
                            @"Midway Island"                                : @"+1 808",
                            @"Micronesia"                                   : @"+691",
                            @"Moldova"                                      : @"+373",
                            @"Monaco"                                       : @"+377",
                            @"Mongolia"                                     : @"+976",
                            @"Montenegro"                                   : @"+382",
                            @"Montserrat"                                   : @"+1664",
                            @"Morocco"                                      : @"+212",
                            @"Myanmar"                                      : @"+95",
                            @"Namibia"                                      : @"+264",
                            @"Nauru"                                        : @"+674",
                            @"Nepal"                                        : @"+977",
                            @"Netherlands"                                  : @"+31",
                            @"Netherlands Antilles"                         : @"+599",
                            @"Nevis"                                        : @"+1 869",
                            @"New Caledonia"                                : @"+687",
                            @"New Zealand"                                  : @"+64",
                            @"Nicaragua"                                    : @"+505",
                            @"Niger"                                        : @"+227",
                            @"Nigeria"                                      : @"+234",
                            @"Niue"                                         : @"+683",
                            @"Norfolk Island"                               : @"+672",
                            @"Northern Mariana Islands"                     : @"+1 670",
                            @"Norway"                                       : @"+47",
                            @"Oman"                                         : @"+968",
                            @"Pakistan"                                     : @"+92",
                            @"Palau"                                        : @"+680",
                            @"Palestinian Territory"                        : @"+970",
                            @"Panama"                                       : @"+507",
                            @"Papua New Guinea"                             : @"+675",
                            @"Paraguay"                                     : @"+595",
                            @"Peru"                                         : @"+51",
                            @"Philippines"                                  : @"+63",
                            @"Poland"                                       : @"+48",
                            @"Portugal"                                     : @"+351",
                            @"Puerto Rico"                                  : @"+1 787",
                            @"Puerto Rico"                                  : @"+1 939",
                            @"Qatar"                                        : @"+974",
                            @"Reunion"                                      : @"+262",
                            @"Romania"                                      : @"+40",
                            @"Russia"                                       : @"+7",
                            @"Rwanda"                                       : @"+250",
                            @"Samoa"                                        : @"+685",
                            @"San Marino"                                   : @"+378",
                            @"Saudi Arabia"                                 : @"+966",
                            @"Senegal"                                      : @"+221",
                            @"Serbia"                                       : @"+381",
                            @"Seychelles"                                   : @"+248",
                            @"Sierra Leone"                                 : @"+232",
                            @"Singapore"                                    : @"+65",
                            @"Slovakia"                                     : @"+421",
                            @"Slovenia"                                     : @"+386",
                            @"Solomon Islands"                              : @"+677",
                            @"South Africa"                                 : @"+27",
                            @"South Georgia and the South Sandwich Islands" : @"+500",
                            @"Spain"                                        : @"+34",
                            @"Sri Lanka"                                    : @"+94",
                            @"Sudan"                                        : @"+249",
                            @"Suriname"                                     : @"+597",
                            @"Swaziland"                                    : @"+268",
                            @"Sweden"                                       : @"+46",
                            @"Switzerland"                                  : @"+41",
                            @"Syria"                                        : @"+963",
                            @"Taiwan"                                       : @"+886",
                            @"Tajikistan"                                   : @"+992",
                            @"Tanzania"                                     : @"+255",
                            @"Thailand"                                     : @"+66",
                            @"Timor Leste"                                  : @"+670",
                            @"Togo"                                         : @"+228",
                            @"Tokelau"                                      : @"+690",
                            @"Tonga"                                        : @"+676",
                            @"Trinidad and Tobago"                          : @"+1 868",
                            @"Tunisia"                                      : @"+216",
                            @"Turkey"                                       : @"+90",
                            @"Turkmenistan"                                 : @"+993",
                            @"Turks and Caicos Islands"                     : @"+1 649",
                            @"Tuvalu"                                       : @"+688",
                            @"Uganda"                                       : @"+256",
                            @"Ukraine"                                      : @"+380",
                            @"United Arab Emirates"                         : @"+971",
                            @"United Kingdom"                               : @"+44",
                            @"United States"                                : @"+1",
                            @"Uruguay"                                      : @"+598",
                            @"U.S. Virgin Islands"                          : @"+1 340",
                            @"Uzbekistan"                                   : @"+998",
                            @"Vanuatu"                                      : @"+678",
                            @"Venezuela"                                    : @"+58",
                            @"Vietnam"                                      : @"+84",
                            @"Wake Island"                                  : @"+1 808",
                            @"Wallis and Futuna"                            : @"+681",
                            @"Yemen"                                        : @"+967",
                            @"Zambia"                                       : @"+260",
                            @"Zanzibar"                                     : @"+255",
                            @"Zimbabwe"                                     : @"+263"
                            };
    phone_code_arr = [NSMutableArray arrayWithArray:[codes allValues]];
    NSArray *country_arr = [codes allKeys];
    [[NSUserDefaults standardUserDefaults] setObject:country_arr forKey:@"country_array"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(phone_close.frame.size.width - 100, 0, 100, phone_close.frame.size.height);
    [close setTitle:@"close" forState:UIControlStateNormal];
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
        msg = @"please enter your name";
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
        msg = @"please accept term and conditions";
    }
    
    
    else
        
    {

    VW_overlay.hidden = NO;
     [activityIndicatorView startAnimating];
    [self performSelector:@selector(get_transaction_id) withObject:activityIndicatorView afterDelay:0.01];
        
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
    return phone_code_arr[row];
    
}

// #6
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.TXT_code.text = phone_code_arr[row];
    NSLog(@"the text is:%@",_TXT_code.text);
}
-(void)get_transaction_id
{
    NSString *str_url = [NSString stringWithFormat:@"https://api.q-tickets.com/V2.0/send_lock_request?Transaction_Id=%@&name=%@&email=%@&mobile=%@&prefix=91&VoucherCodes=null",[[temp_dict valueForKey:@"result"] valueForKey:@"_Transaction_Id"],_TXT_name.text,_TXT_mail.text,_TXT_phone.text];
    
    NSURL *URL = [[NSURL alloc] initWithString:str_url];
    
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    NSLog(@"The booking_data is:%@",xmlDoc);
    [[NSUserDefaults standardUserDefaults] setValue:[[xmlDoc valueForKey:@"result"] valueForKey:@"_Transaction_Id"] forKey:@"TID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    
    [self performSegueWithIdentifier:@"movie_user_detail_pay" sender:self];
    
    
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
