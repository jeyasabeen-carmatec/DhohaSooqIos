//
//  VC_event_user.m
//  Dohasooq_mobile
//
//  Created by Test User on 28/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_event_user.h"
#import "XMLDictionary/XMLDictionary.h"

@interface VC_event_user ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIWebViewDelegate>
{
    float scroll_height;
    NSMutableArray *phone_code_arr;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSArray *country_arr;
    //NSTimer *timer;
}

@end

@implementation VC_event_user

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
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
  /*  NSDictionary *codes = @{
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
                            };*/

//    phone_code_arr = [NSMutableArray arrayWithArray:[codes allValues]];
//    country_arr = [codes allKeys];
//    [[NSUserDefaults standardUserDefaults] setObject:country_arr forKey:@"country_array"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    phone_code_arr = (NSMutableArray *)parsedObject;
    
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
        [self performSelector:@selector(get_oreder_ID) withObject:activityIndicatorView afterDelay:0.01];

     
    }
    

    if(msg)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
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
        
        
        NSString *str_url = [NSString stringWithFormat:@"https://api.q-tickets.com/V2.0/eventbookings?eventid=%@&ticket_id=%@&amount=%@&tkt_count=%@&NoOftktPerid=%@&camount=0&email=%@&name=%@&phone=%@&prefix=%@&bdate=%@&btime=%@&balamount=0&couponcodes=null&AppSource=4&AppVersion=1.0",event_id,event_master_id,str_price,str_count,event_price_id,_TXT_mail.text,_TXT_name.text,_TXT_phone.text,_TXT_code.text,start_date,start_time];
        
        NSURL *URL = [[NSURL alloc] initWithString:str_url];
        
        NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
        NSLog(@"The booking_data is:%@",xmlDoc);
        
        
        //_Transaction_Id
        
        // Saving User Data And Transaction ID
        //full_name, email, mobile, bookingId, movie_event,user_id
        
        NSDictionary *save_booking_dic = @{@"full_name":_TXT_name.text,@"email":_TXT_mail.text,@"mobile":_TXT_phone.text };
        
        [[NSUserDefaults standardUserDefaults]setObject:save_booking_dic forKey:@"savebooking"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:[[xmlDoc valueForKey:@"result"] valueForKey:@"_orderid"] forKey:@"order_details"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        
        // Move to next 
        [self performSegueWithIdentifier:@"user_detail_pay" sender:self];
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
   return [NSString stringWithFormat:@"%@   %@",[phone_code_arr[row] valueForKey:@"name"],[phone_code_arr[row] valueForKey:@"dial_code"]];
    
}

// #6
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   
        self.TXT_code.text = [phone_code_arr[row] valueForKey:@"dial_code"];
        NSLog(@"the text is:%@",_TXT_code.text);
        
    
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
    
    [activityIndicatorView startAnimating];
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
