//
//  VC_order_detail.m
//  Dohasooq_mobile
//
//  Created by Test User on 28/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//


#import "VC_order_detail.h"
#import "UIBarButtonItem+Badge.h"
#import "order_cell.h"
#import "shipping_cell.h"
#import "pay_cell.h"
#import "HttpClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "VC_DS_Checkout.h"
#import "Helper_activity.h"


@interface VC_order_detail ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>

{
       NSMutableArray *arr_product,*stat_arr,*reload_section,*arr_states,*picker_Arr,*response_picker_arr;
    NSString *TXT_count, *product_id,*item_count,*qr_code,*qar_miles_value;
    int i,j;
    NSInteger edit_tag,cntry_ID;
    NSMutableArray  *temp_arr;
    BOOL isfirstTimeTransform,isAddClicked,is_Txt_date,isCountrySelected,orderCheckSelected,isCash_on_delivary;
    float scroll_height,shiiping_ht;
    UIView *VW_overlay;
    //UIActivityIndicatorView *activityIndicatorView;
    NSMutableDictionary *jsonresponse_dic,*jsonresponse_dic_address,*delivary_slot_dic,*response_countries_dic;
    NSString *merchent_id,*date_str,*time_str;  //for payment parameters
    NSArray *slot_keys_arr; // time_slot keys for  PickerView
    UIToolbar *accessoryView;
    
    NSString *cntry_selection,*state_selection;//*selection_str,
    NSIndexPath *textfield_indexpath;
    
    float total;
    float charge_ship; //For lbl shipping charge
    
    //payment parameters
    NSString *payment_type_str,*billcheck_clicked,*blng_cntry_ID,*ship_cntry_ID,*blng_state_ID,*ship_state_ID,*newaddressinput;
    NSMutableArray *date_time_merId_Arr;
    BOOL select_blng_ctry_state; // finding which state/country selected instead of creating new pickerview
    
    NSString *title_page_str;
    
    //Country Code
    NSMutableArray *phone_code_arr;
    NSString *flag;
    
    //Delivary Slot
    NSDateFormatter *dateFormatter;
    
   //OneTime Pwd
    NSTimer *timer;
    int currMinute;
    int currSeconds;
    NSString *otp_str;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation VC_order_detail
#define TRANSFORM_CELL_VALUE CGAffineTransformMakeScale(0.8, 0.8)
#define ANIMATION_SPEED 0.2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //_TBL_address.backgroundColor = [UIColor yellowColor];
    //self.TBL_address.backgroundColor = [UIColor orangeColor];
    
    [_BTN_logo addTarget:self action:@selector(go_To_Home) forControlEvents:UIControlEventTouchUpInside];
    
    _TXT_instructions.delegate = self;
    title_page_str = @"ORDER DETAIL";
    
    // Do any additional setup after loading the view.
    isfirstTimeTransform = YES;
    stat_arr = [[NSMutableArray alloc]init];
    stat_arr = [NSMutableArray arrayWithObjects:@"0", nil];
    
    // For Payment
    newaddressinput=@"0";
    billcheck_clicked = @"0";
    
    //[apply_promo_action
   
    [_BTN_close addTarget:self action:@selector(close_ACTION) forControlEvents:UIControlEventTouchUpInside];
  
    jsonresponse_dic  = [[NSMutableDictionary alloc]init];
    jsonresponse_dic_address = [[NSMutableDictionary alloc]init];
    
    response_picker_arr = [NSMutableArray array];
    
   
    [_BTN_apply_promo addTarget:self action:@selector(apply_promo_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_resend_otp addTarget:self action:@selector(resend_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_validate_otp addTarget:self action:@selector(validate_OTP) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_validate_otp setBackgroundColor:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]];
    
    //Country Code Related
    [self phone_code_view];
    
    dateFormatter = [[NSDateFormatter alloc] init];

    
    _LBL_arrow.hidden = YES;
    isCash_on_delivary = YES;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationItem.hidesBackButton = YES;
    VW_overlay = [[UIView alloc]init];
    CGRect vwframe;
    vwframe = VW_overlay.frame;
    vwframe.origin.y = self.navigationController.navigationBar.frame.origin.y;
    vwframe.size.height = self.view.frame.size.height;
    vwframe.size.width = self.view.frame.size.width;
    VW_overlay.frame = vwframe;
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]; //[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    // VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
     VW_overlay.hidden = YES;
    
    UITapGestureRecognizer *close_Views = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Close_Views_on_overLay:)];
    close_Views.delegate = self;
    close_Views.numberOfTapsRequired = 1;
    [VW_overlay addGestureRecognizer:close_Views];
    
    [self performSelector:@selector(order_detail_API_call) withObject:nil afterDelay:0.01];
   
}

// Implementing tap Gesture For VW_overLay
-(void)Close_Views_on_overLay:(UITapGestureRecognizer *)tapGesture{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:-5];
    VW_overlay.hidden = YES;
    [UIView commitAnimations];
}


-(void)set_UP_VIEW
{
    
    isfirstTimeTransform = YES;
    
    _LBL_stat.tag = 0;

    
    temp_arr = [[NSMutableArray alloc]init];
    arr_product = [[NSMutableArray alloc]init];
    temp_arr = [NSMutableArray arrayWithObjects:@"debit_card.png",@"credit_card.png",@"net_banking.png",@"cod.png",nil];
    
    i = 1,j = 0;;
    CGRect frame_set ;
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        CGRect frame_set = _TXT_first.frame;
        frame_set.origin.x = _LBL_shipping.frame.origin.x + _LBL_shipping.frame.size.width - 1;
        frame_set.size.width = _LBL_order_detail.frame.origin.x - ( _LBL_shipping.frame.origin.x + _LBL_shipping.frame.size.width)  + 2 ;
        _TXT_first.frame = frame_set;
        
        
        
        frame_set = _TXT_second.frame;
        frame_set.origin.x = _LBL_Payment.frame.origin.x + _LBL_Payment.frame.size.width - 1;
        frame_set.size.width = _LBL_shipping.frame.origin.x - ( _LBL_Payment.frame.origin.x + _LBL_Payment.frame.size.width) + 2 ;
        _TXT_second.frame = frame_set;
        
    }
    else{
        
        CGRect frame_set = _TXT_first.frame;
        frame_set.origin.x = _LBL_order_detail.frame.origin.x + _LBL_order_detail.frame.size.width - 1;
        frame_set.size.width = _LBL_shipping.frame.origin.x - ( _LBL_order_detail.frame.origin.x + _LBL_order_detail.frame.size.width)  + 2 ;
        _TXT_first.frame = frame_set;
        
        frame_set = _TXT_second.frame;
        frame_set.origin.x = _LBL_shipping.frame.origin.x + _LBL_shipping.frame.size.width - 1;
        frame_set.size.width = _LBL_Payment.frame.origin.x - ( _LBL_shipping.frame.origin.x + _LBL_shipping.frame.size.width) + 2 ;
        _TXT_second.frame = frame_set;
        
    }
    frame_set = _scroll_shipping.frame;
    frame_set.size.width = _VW_shipping.frame.size.width;
    _scroll_shipping.frame = frame_set;
    
   
    
    
    
    frame_set = _VW_BILLING_ADDRESS.frame;
    frame_set.size.height = _VW_BILLING_ADDRESS.frame.size.height;
    frame_set.size.width =_VW_shipping.frame.size.width;
    _VW_BILLING_ADDRESS.frame = frame_set;
    
    [self.scroll_shipping addSubview:_VW_BILLING_ADDRESS];
    
    // ADD Special Instructions
    
    
    frame_set  = _VW_special.frame;
    frame_set.origin.x = _TXT_Cntry_code.frame.origin.x;
    frame_set.origin.y = _VW_BILLING_ADDRESS.frame.origin.y + _VW_BILLING_ADDRESS.frame.size.height;
    _VW_special.frame = frame_set;
    [self.scroll_shipping addSubview:_VW_special];

    _VW_special.layer.borderWidth = 0.5f;
    _VW_special.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
     _TBL_address.hidden = YES;
    
    [_TBL_address reloadData];
    frame_set = _TBL_address.frame;
    frame_set.origin.y = _VW_BILLING_ADDRESS.frame.origin.y + _VW_BILLING_ADDRESS.frame.size.height;
    frame_set.size.height = _TBL_address.frame.origin.y + _TBL_address.contentSize.height;
    _TBL_address.frame =frame_set;
    
    [self.scroll_shipping addSubview:_TBL_address];
     _TBL_address.hidden = YES;
    _VW_SHIIPING_ADDRESS.hidden = YES;

    
    shiiping_ht = _VW_special.frame.origin.y + _VW_special.frame.size.height;
    
    
    
    frame_set = _VW_pay_cards.frame;
   // frame_set.origin.y = _collectionView.frame.origin.y + _collectionView.frame.size.height;
    frame_set.size.width = _Scroll_card.frame.size.width;
    frame_set.size.height = _VW_pay_cards.frame.origin.y + _VW_pay_cards.frame.size.height;
    _VW_pay_cards.frame = frame_set;
    [self.Scroll_card addSubview:_VW_pay_cards];
    scroll_height = _VW_pay_cards.frame.origin.y + _VW_pay_cards.frame.size.height;
    
    
    
    frame_set = _VW_summary.frame;
    frame_set.origin.y = _VW_next.frame.origin.y - _VW_summary.frame.size.height - 20;
    frame_set.size.width = _TBL_orders.frame.size.width;
    //  frame_set.size.height = _VW_next.frame.origin.y - _TBL_orders.frame.origin.y;
    _VW_summary.frame = frame_set;
    [VW_overlay addSubview:_VW_summary];
    _VW_summary.hidden = YES;
    
    
    //  NSArray *arr = [[jsonresponse_dic valueForKey:@"shipcharge"] allKeys];
    //    for(int l = 0; l < arr.count;l++)
    //    {
    
    //  }
    
    
    _BTN_apply_promo.layer.cornerRadius = 2.0f;
    _BTN_apply_promo.layer.masksToBounds = YES;
    
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:17.0f]
       } forState:UIControlStateNormal];
    
    
    
//    _BTN_fav  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain  target:self action:
//                 @selector(btnfav_action)];
//    _BTN_cart = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain   target:self action:@selector(btn_cart_action)];
   
//    NSString *badge_value = @"25";
//    if(badge_value.length > 2)
//    {
//        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
//        
//    }
//    else{
//        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
//        
//    }
    
    
    
    
    _LBL_order_detail.layer.cornerRadius = _LBL_order_detail.frame.size.width / 2;
    _LBL_order_detail.layer.borderWidth = 2.5f;
    _LBL_order_detail.layer.borderColor = [UIColor whiteColor].CGColor;
    _LBL_order_detail.backgroundColor = [UIColor colorWithRed:0.20 green:0.76 blue:0.33 alpha:1.0];
    _LBL_order_detail.layer.masksToBounds = YES;
    
    
    _LBL_shipping.layer.cornerRadius = _LBL_order_detail.frame.size.width / 2;
    _LBL_shipping.layer.borderWidth = 2.5f;
    _LBL_shipping.layer.borderColor = [UIColor whiteColor].CGColor;
    _LBL_shipping.layer.masksToBounds = YES;
    
    _LBL_Payment.layer.cornerRadius = _LBL_order_detail.frame.size.width / 2;
    _LBL_Payment.layer.borderWidth = 2.5f;
    _LBL_Payment.layer.borderColor = [UIColor whiteColor].CGColor;
    _LBL_Payment.layer.masksToBounds = YES;
    
    _TXT_first.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_first.layer.borderWidth = 1.7f;
    
    _TXT_second.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_second.layer.borderWidth = 1.7f;
    
    _BTN_credit.tag = 1;
    _BTN_debit_card.tag = 1;
    _BTN_doha_bank_account.tag = 1;
    _BTN_doha_miles.tag = 1;
    _BTN_cod.tag = 1;

    [_BTN_cod addTarget:self action:@selector(cod_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_credit addTarget:self action:@selector(credit_cerd_action) forControlEvents:UIControlEventTouchUpInside];
    
    [_BTN_debit_card addTarget:self action:@selector(debit_card_action) forControlEvents:UIControlEventTouchUpInside];
    
    [_BTN_doha_miles addTarget:self action:@selector(doha_miles_action) forControlEvents:UIControlEventTouchUpInside];
    
    [_BTN_doha_bank_account addTarget:self action:@selector(doha_bank_action) forControlEvents:UIControlEventTouchUpInside];

    
    
    NSString *next = @"";
    
    NSString *next_text = [NSString stringWithFormat:@"NEXT %@",next];
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        next  = @"";
        next_text = [NSString stringWithFormat:@"%@ التالي ",next];
    }
    
    if ([_LBL_next respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_next.textColor,
                                  NSFontAttributeName:_LBL_next.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:next_text attributes:attribs];
        
        
        
        NSRange ename = [next_text rangeOfString:next];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:12.0],NSForegroundColorAttributeName:[UIColor whiteColor]}
                                    range:ename];
        }
        
        _LBL_next.attributedText = attributedText;
    }
    else
    {
        _LBL_next.text = next_text;
    }
    
    
    
    NSString *terms = @"terms & conditions";
    NSString *conditions = [NSString stringWithFormat:@"i agree that i have read and accepted our %@ for your purchase",terms];
    if ([_LBL_terms respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_terms.textColor,
                                  NSFontAttributeName:_LBL_terms.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:conditions attributes:attribs];
        
        
        
        NSRange ename = [conditions rangeOfString:terms];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:12.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:ename];
        }
        
        _LBL_terms.attributedText = attributedText;
    }
    else
    {
        _LBL_terms.text = conditions;
    }
    
    
    
    //PickerView
    
    _staes_country_pickr = [[UIPickerView alloc]init];
    _staes_country_pickr.delegate = self;
    _staes_country_pickr.dataSource = self;
    
    _pickerView = [[UIPickerView alloc]init];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    _TXT_Date.delegate = self;
    _TXT_Time.delegate = self;
    
    _TXT_Date.inputView = self.pickerView;
    _TXT_Time.inputView = self.pickerView;
    
    
    // TollBar For PickerView
    accessoryView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    accessoryView.barStyle = UIBarStyleBlackTranslucent;
    [accessoryView sizeToFit];
   
    
    _TXT_country.inputView = _staes_country_pickr;
    _TXT_state.inputView = _staes_country_pickr;
    
    
    _TXT_ship_country.inputView =_staes_country_pickr;
    _TXT_ship_state.inputView =_staes_country_pickr;

   //  Done Button  For Tool Bar
    UIButton *done=[[UIButton alloc]init];
    done.frame=CGRectMake(accessoryView.frame.size.width - 100, 0, 100, accessoryView.frame.size.height);
    [done setTitle:@"Done" forState:UIControlStateNormal];
    [done addTarget:self action:@selector(picker_done_btn_action:) forControlEvents:UIControlEventTouchUpInside];
    [accessoryView addSubview:done];
    
    
    //Close ButtonFor ToolBar
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(accessoryView.frame.origin.x -20, 0, 100, accessoryView.frame.size.height);
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(picker_close_action) forControlEvents:UIControlEventTouchUpInside];
    [accessoryView addSubview:close];
    
    
    // Country Code Picker
    self.country_code_Pickerview = [[UIPickerView alloc]init];
    _country_code_Pickerview.delegate = self;
    _country_code_Pickerview.dataSource = self;
    
    
    //Shipping Address Textfield
    _TXT_ship_cntry_code.inputView = self.country_code_Pickerview;
    _TXT_ship_cntry_code.inputAccessoryView = accessoryView;
    
    //Billing Address Textfield
    _TXT_Cntry_code.inputAccessoryView=accessoryView;
    _TXT_Cntry_code.inputView=_country_code_Pickerview;
    
    
    _TXT_Time.inputAccessoryView = accessoryView;
    _TXT_Date.inputAccessoryView = accessoryView;
    
    
    _TXT_ship_country.inputAccessoryView =accessoryView;
    _TXT_ship_state.inputAccessoryView =accessoryView;
    
    _TXT_country.inputAccessoryView =accessoryView;
    _TXT_state.inputAccessoryView =accessoryView;

        [_BTN_next addTarget:self action:@selector(next_page) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_Product_summary addTarget:self action:@selector(product_clicked) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_done addTarget:self action:@selector(deliveryslot_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_check addTarget:self action:@selector(BTN_check_clickd) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
}
-(void)set_DATA
{
    @try {
        
        NSString *state = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"state"];
        NSString *country = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"country"];
        //  state = [state stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        //  country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        NSString *str_fname,*str_lname,*str_addr1,*str_addr2,*str_city,*str_zip_code,*str_phone,*str_country,*str_state,*str_email,*str_cntry_code;
        
        //fnaem
        str_fname = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"firstname"];
        str_fname = [str_fname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        _TXT_fname.text =  str_fname;
        
        //lname
        str_lname = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"lastname"];
        str_lname = [str_lname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        _TXT_lname.text =  str_lname;
        
        //phone
        str_phone = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"phone"];
        
        if ([str_phone isEqualToString:@"<null>"] ||[str_phone isEqualToString:@"<nil>"]||[str_phone isEqualToString:@""] ) {
            str_phone = @"";
            _TXT_phone.userInteractionEnabled = YES;
            _TXT_phone.backgroundColor = [UIColor clearColor];
        }
        else{
            _TXT_phone.userInteractionEnabled = NO;
            _TXT_phone.backgroundColor = [UIColor lightGrayColor];
        }
        str_phone = [str_phone stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        _TXT_phone.text =  str_phone;
        
        //Phone_Country_code
        str_cntry_code = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"phonecode"];
        str_cntry_code = [str_cntry_code stringByReplacingOccurrencesOfString:@"<null>" withString:@"974"];
        
        if ([str_cntry_code isEqualToString:@"<null>"] ||[str_cntry_code isEqualToString:@"<nil>"]||[str_cntry_code isEqualToString:@""] ) {
            str_cntry_code = @"974";
        }
        
        _TXT_Cntry_code.text = [NSString stringWithFormat:@"+%@",str_cntry_code];
        
        
        //Country_code for ShipCntryCode
        _TXT_ship_cntry_code.text = [NSString stringWithFormat:@"+%@",str_cntry_code];
        
        
        //Address1
        str_addr1 = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"address1"];
        
        str_addr2 = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"address2"];
        str_city = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"city"];
        str_zip_code = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"zip_code"];
        
        str_country = country;
        str_state =state;
        
        // Country
        if ([str_country isEqualToString:@"<null>"] ||[str_country isEqualToString:@"<nil>"]||[str_country isEqualToString:@"null"] ||[str_country isEqualToString:@""]) {
            str_country = @"";
            _TXT_country.placeholder = @"Select Country";
        }
        
        //State
        if ([str_state isKindOfClass:[NSNull class]]||[str_state isEqualToString:@"<null>"] ||[str_state isEqualToString:@"<nil>"]||[str_state isEqualToString:@"null"] ||[str_state isEqualToString:@""]) {
            str_state = @"";
            _TXT_state.placeholder = @"Select State*";
        }
        
        
        //str_email = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"user_email"]];
        
        //cell.Btn_save.hidden = YES;
        
        
        // Getting State_id and Cntry_Id for Payment
        blng_cntry_ID = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"country_id"]];
        blng_state_ID = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"state_id"]];
        
        
        // Shipping Country  ID Must Be  Qatar Country ID
        ship_cntry_ID = @"173";
        
        
        
        str_fname = [str_fname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        
        str_lname = [str_lname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_addr1 = [str_addr1 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_addr2 = [str_addr2 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_city = [str_city stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_zip_code = [str_zip_code stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_phone = [str_phone stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        
        
        if ([str_zip_code isEqualToString:@"<null>"] ||[str_zip_code isEqualToString:@"<nil>"]||[str_zip_code isEqualToString:@"null"] ) {
            str_zip_code = @"";
        }
        
        _TXT_addr1.text =  str_addr1;
        _TXT_addr2.text =  str_addr2;
        _TXT_city.text =  str_city;
        _TXT_zip.text =  str_zip_code;
        _TXT_email.text =  str_email;
        
        
        //_TXT_phone.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];;
        
        
        
        str_state = [str_state stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        
        _TXT_country.text =  str_country;
        _TXT_state.text =  str_state;
        
        _TXT_ship_country.text = @"Qatar";
        
        
    }
    @catch(NSException *exception)
    {
    }
    
}

-(void)set_data_to_product_Summary_View{
  
    @try {
        
       
        
        qar_miles_value = [NSString stringWithFormat:@"%@",[jsonresponse_dic valueForKey:@"oneQARtoDM"]];
        
     
    NSString *sub_total = [NSString stringWithFormat:@"%@",[jsonresponse_dic valueForKey:@"subsum"]];
    
    sub_total = [sub_total stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
        
    NSString *sub_total_seperator = [HttpClient currency_seperator:sub_total];
        

        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
             _LBL_sub_total.text = [NSString stringWithFormat:@"%@ %@",sub_total_seperator,[[NSUserDefaults standardUserDefaults]valueForKey:@"currency"]];
        }else{
             _LBL_sub_total.text = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"currency"],sub_total_seperator];
        }
        
        

    total = [sub_total floatValue]+ charge_ship;
        
    float doha_val = [qar_miles_value intValue]*total;
   

        
        
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            self.LBL_shipping_charge.text = [NSString stringWithFormat:@"%.2f %@",charge_ship,[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
        }
        else{
            self.LBL_shipping_charge.text = [NSString stringWithFormat:@"%@ %.2f",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],charge_ship];
        }


//    NSString *prec_price = [NSString stringWithFormat:@"%.2f",total];
         NSString *prec_price = [HttpClient currency_seperator:[NSString stringWithFormat:@"%.2f",total]];
        
    
        [self fill_value_to_Lbl_product_summary:@" "];
        
          NSString *currency = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
    NSString *summary_text;
        NSString *doha_value = [NSString stringWithFormat:@"%f",doha_val];
        doha_value = [HttpClient doha_currency_seperator:doha_value];
        
        
        NSString *str_miles;
        NSString *str_or;
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
        summary_text = [NSString stringWithFormat:@"%@ %@",prec_price,currency];
         str_or = @"(أو)";
        str_miles = [NSString stringWithFormat:@"%@\nأميال الدوحة %@",doha_value,str_or];
        
        }
        else{
             summary_text = [NSString stringWithFormat:@"%@ %@",currency,prec_price];
             str_or = @"(OR)";
            str_miles= [NSString stringWithFormat:@"%@\n Doha Miles %@",str_or,doha_value];
        }
        
    if ([_LBL_total respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_total.textColor,
                                  NSFontAttributeName:_LBL_total.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:summary_text attributes:attribs];
        
        
        
        NSRange ename = [summary_text rangeOfString:currency];
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:16.0]}
                                    range:ename];
        
        NSRange cmp = [summary_text rangeOfString:prec_price];
        
        
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:16.0],NSForegroundColorAttributeName:[UIColor blackColor],}
                                    range:cmp ];
        
          _LBL_total.attributedText = attributedText;
    }
    else
    {
        _LBL_total.text = summary_text;
    }

        
        if ([_LBL_summry_miles respondsToSelector:@selector(setAttributedText:)]) {
            
            // Define general attributes for the entire text
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:_LBL_summry_miles.textColor,
                                      NSFontAttributeName:_LBL_summry_miles.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str_miles attributes:attribs];
            
            
            NSRange doha_va = [str_miles rangeOfString:str_miles];
            
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:16.0],NSForegroundColorAttributeName:[UIColor blackColor],}
                                    range:doha_va ];
            
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:12.0],NSForegroundColorAttributeName:[UIColor blackColor],}
                                    range:[str_miles rangeOfString:str_or] ];
        

       
        _LBL_summry_miles.attributedText = attributedText;
        
        // _LBL_summry_miles.text = str_miles;
        
      
    }
    else
    {
        _LBL_summry_miles.text = str_miles;
    }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
   }
// Data for LBL Summary
-(void)fill_value_to_Lbl_product_summary:(NSString *)arrow{
    
    
    NSString *seperator = [HttpClient currency_seperator:[NSString stringWithFormat:@"%.2f",total]];
    
      NSString *price;
    
    NSString *currency = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];

    
    NSString *text;
    
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        price =[NSString stringWithFormat:@"%@ %@",arrow,seperator];
        text = [NSString stringWithFormat:@"%@ %@ ",price,currency];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        
    }
    else{
        price =[NSString stringWithFormat:@"%@ %@",seperator,arrow];
        text = [NSString stringWithFormat:@"%@ %@ ",currency,price];
        [paragraphStyle setAlignment:NSTextAlignmentLeft];
        
        
    }
    
    
    if ([_LBL_product_summary respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_product_summary.textColor,
                                  NSFontAttributeName:_LBL_product_summary.font,
                                  NSParagraphStyleAttributeName:paragraphStyle
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
        
        
        NSRange ename = [text rangeOfString:currency];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:16.0]}
                                    range:ename];
        }
        NSRange cmp = [text rangeOfString:price];
        //        [attributedText addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [prec_price length])];
        //
        
        
        //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:21.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:16.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:cmp ];
        }
        
        _LBL_product_summary.attributedText = attributedText;
        
        
    }
    else
    {
        _LBL_product_summary.text = text;
    }

}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_card layoutIfNeeded];
    if(_scroll_shipping)
    {
        _scroll_shipping.contentSize = CGSizeMake(_scroll_shipping.frame.size.width,shiiping_ht);
    }
    else{
    _Scroll_card.contentSize = CGSizeMake(_Scroll_card.frame.size.width,scroll_height);
    }
}
#pragma tableview delagates
#pragma tableview delagates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    @try {
        if(tableView == _TBL_address)
        {
            return 1;
            // return sec;
        }
        else
        {
            NSInteger count = 0;
            NSArray *keys_arr;
            
            if([[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] isKindOfClass:[NSDictionary class]])
            {
                keys_arr = [[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] allKeys];
                count = keys_arr.count;
                
            }
            else
            {
                count = 0;
            }
            
            
            return count;
            
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        
        if(tableView == _TBL_orders)
        {
            NSInteger ct = 0;
            
            if([[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] isKindOfClass:[NSDictionary class]])
            {
                NSArray *keys_arr = [[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] allKeys];
                
                
                for(int m = 0;m< keys_arr.count;m++)
                {
                    if(section == m)
                    {
                        ct = [[[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] valueForKey:[keys_arr objectAtIndex:m]]count];
                    }
                    
                }
                
                
            }
            else
            {
                ct = 0;
            }
            
            
            return ct;
        }
        else      // TableView Address
        {
            NSInteger ct = 0;
            if(section == 0)
            {
                
                if([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]])
                {
                    NSArray *keys_arr = [[jsonresponse_dic_address valueForKey:@"shipaddress"] allKeys];
                    ct = keys_arr.count;
                    
                    
                }
                else{
                    ct = 0;  ////
                    
                }
                
                
                
                
                return ct;
            }
           
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *identifier_order,*identifier_shipping;//,*identifier_billing
    NSInteger index;
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        //identifier_billing = @"Qbilling_address";
        identifier_order = @"Qorder_cell";
        identifier_shipping = @"Qshipping_cell";
        index = 1;
        
    }
    else{
        
        //identifier_billing = @"billing_address";
        identifier_order = @"order_cell";
        identifier_shipping = @"shipping_cell";
        index = 0;
        
        
    }
    if(tableView == _TBL_orders)
    {
        order_cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_order];
        
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"order_cell" owner:self options:nil];
            cell = [nib objectAtIndex:index];
        }
        NSLog(@"IndexPatha :: %@",indexPath);
        
        
        if([[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] isKindOfClass:[NSDictionary class]])
        {
            
            
            
            NSArray *keys_arr = [[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] allKeys];
            arr_product = [[[jsonresponse_dic valueForKey:@"data"] valueForKey:@"pdts"] valueForKey:[keys_arr objectAtIndex:indexPath.section]];
            
            @try
            {
                NSString *str = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"merchantId"]];
               
                
                NSString *img_url = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"productimage"]];

                [cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:img_url]
                                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                                          options:SDWebImageRefreshCached];
                
                NSString *item_name =[NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"product_name"]];
                
                item_name = [item_name stringByReplacingOccurrencesOfString:@"<null>" withString:@"not mentioned"];
                NSString *item_seller =[NSString stringWithFormat:@"Seller: %@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"merchantname"]];
                
                
                
                item_name = [item_name stringByReplacingOccurrencesOfString:@"<null>" withString:@"not mentioned"];
                cell.LBL_item_name.text = item_name;
                
                
                if ([cell.LBL_seller respondsToSelector:@selector(setAttributedText:)])
                {
                                      // Define general attributes for the entire text
                    NSDictionary *attribs = @{
                                              NSForegroundColorAttributeName:[UIColor colorWithRed:84.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1],
                                              NSFontAttributeName:cell.LBL_date .font
                                              };
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:item_seller attributes:attribs];
                    
                    cell.LBL_seller.attributedText = attributedText;
                    
                }
                else{
                    cell.LBL_seller.text = item_seller;
                  }
                
                
   // Product Quantity
                cell._TXT_count.text = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"product_qty"]];
                NSString *qnty = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"product_qty"]];
                if([qnty isEqualToString:@""]|| [qnty isEqualToString:@"null"]||[qnty isEqualToString:@"<null>"])
                {
                    qnty = @"0";
                }
                
                TXT_count = cell._TXT_count.text;
                
#pragma mark Lbl_Price Attributed Text
                
                NSString *qr = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"currencycode"]];
                qr_code = qr;
                NSString *mils;
               
                NSString *prev_price = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"productprice"]];
                
                NSString *price = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"specialPrice"]];
                price = [price stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                price = [price stringByReplacingOccurrencesOfString:@"null" withString:@""];
                
                NSString *doha_miles = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"dohamileprice"]];
                doha_miles = [doha_miles stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                doha_miles = [doha_miles stringByReplacingOccurrencesOfString:@"null" withString:@""];
                
                if([doha_miles isEqualToString:@""]|| [doha_miles isEqualToString:@"null"]||[doha_miles isEqualToString:@"<null>"])
                {
                    mils  = @"";
                }
                else
                {
                    mils  = @"Doha Miles";
                    
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                         mils  = @"أميال الدوحة";
                    }
                }
                
    // Calculating Dohamiles Value and Prices Based on Quantity
                
                @try {
                    int quantity = [qnty intValue];
                    
                    
                        @try {
                            //Product Price Multiplication

                        float productprice = [prev_price floatValue];
                        productprice = quantity*productprice;
                        prev_price = [HttpClient currency_seperator:[NSString stringWithFormat:@"%.2f",productprice]];
                            //prev_price = [NSString stringWithFormat:@"%.2f",productprice];
                           
                            //Miles Price Multiplication
                            float price_mls = [doha_miles floatValue];
                            price_mls = quantity * price_mls;
                            doha_miles = [NSString stringWithFormat:@"%f",price_mls];
                            doha_miles = [HttpClient doha_currency_seperator:doha_miles];
                           
                            
                            if([price isEqualToString:@""]|| [price isEqualToString:@"null"]||[price isEqualToString:@"<null>"])
                            {
                                
                            }
                            else{
                                float spcl_prc = [price floatValue];
                                spcl_prc = quantity * spcl_prc;
                                
                                price = [HttpClient currency_seperator:[NSString stringWithFormat:@"%.2f",spcl_prc]];
                               // price = [NSString stringWithFormat:@"%.2f",spcl_prc];
                            }
                            
                    } @catch (NSException *exception) {
                        
                    }
                    
                } @catch (NSException *exception) {
                    
                }
                
        
                

                NSString *only_price;
                
         if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {

                 only_price = [NSString stringWithFormat:@"/  %@ %@ ",qr,prev_price];

                }
                else
                {
                    only_price = [NSString stringWithFormat:@"%@ %@ ",qr,prev_price];
                }
        
               // NSString *india_currency = [NSString stringWithFormat:@"%@ %@ %@%@",qr,price,qr,prev_price];
                
            // Font size Based on Screen
                
                
                float font_size;
                
                CGSize result = [[UIScreen mainScreen] bounds].size;
                if(result.height <= 480)
                {
                    // iPhone Classic
                    font_size = 13.0;
                    
                }
                else if(result.height <= 568)
                {
                    // iPhone 5
                    font_size = 13.0;
                }
                else
                {
                    font_size = 15.0;
                }

                
#pragma mark LBL_current_price Attributed Text
                
                
                if ([cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)])
                {
                    
                    if ([price isEqualToString:@""] && ![doha_miles isEqualToString:@""]) {
                        
                    
                        
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:only_price attributes:nil];
                        
                        NSRange qrs = [only_price rangeOfString:qr];
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:font_size],NSForegroundColorAttributeName:[UIColor grayColor]}
                                                range:qrs];
                        
                        NSRange ename = [only_price rangeOfString:prev_price];
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:font_size],NSForegroundColorAttributeName:[UIColor grayColor]}
                                                range:ename];
                        
                        
                        cell.LBL_current_price.attributedText = attributedText;
                        
                        
                        
                    }

                    
                    else{
                        
                    NSString *text;
                        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                        {
                            prev_price = [NSString stringWithFormat:@"%@ %@",prev_price,qr];
                            price = [NSString stringWithFormat:@"%@ %@",price,qr];
//                            text = [NSString stringWithFormat:@" %@ %@ / %@ %@ %@",mils,doha_miles,prev_price,price,qr];
                            text = [NSString stringWithFormat:@"/  %@ %@",prev_price,price];

                        }else{
                            prev_price = [NSString stringWithFormat:@"%@ %@",qr,prev_price];
                            price = [NSString stringWithFormat:@"%@ %@",qr,price];

                            text = [NSString stringWithFormat:@"%@ %@ /",price,prev_price];
  
                        }
                        
                        
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                        
//                        NSRange qrs = [text rangeOfString:qr];
//                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                        {
//                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:21.0],NSForegroundColorAttributeName:[UIColor redColor]}
//                                                    range:qrs];
//                        }
//                        else
//                        {
//                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:font_size],NSForegroundColorAttributeName:[UIColor redColor]}
//                                                    range:qrs];
//                        }
                        
                        
                        
                        NSRange ename = [text rangeOfString:price];
                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                                    range:ename];
                        }
                        else
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:font_size],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                                    range:ename];
                        }
                        
                        
                        
                        
                        NSRange cmp = [text rangeOfString:prev_price];
                        //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:21.0]}
                                                    range:cmp];
                        }
                        else
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:font_size],NSForegroundColorAttributeName:[UIColor grayColor]}
                                                    range:cmp];
                        }
                        @try {

                            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                            {
                                 [attributedText addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(3, [prev_price length])];
                            }
                            else{
                                 [attributedText addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(price.length+1, [prev_price length])];
                            }
                            
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        
                    
                        
                        
                        cell.LBL_current_price .attributedText = attributedText;
                    }
                
                    
                }
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    cell.LBL_current_price.textAlignment = NSTextAlignmentRight;
                }
                
                //pro_cell.LBL_prev_price.text =  [temp_dict valueForKey:@"key3"];
                // cell.LBL_discount.text = @"35% off";
       
   // Custom text For DohaMiles Label
                
                
                NSString *doha_text = [NSString stringWithFormat:@"%@ %@",mils,doha_miles];
                if ([cell._LBL_Doha_Miles respondsToSelector:@selector(setAttributedText:)])
                {
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:doha_text attributes:nil];
                    
                    NSRange qrs = [doha_text rangeOfString:doha_miles];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:21.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                                range:qrs];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:font_size],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                                range:qrs];
                    }
                    cell._LBL_Doha_Miles.attributedText = attributedText;
                
                }
                else{
                    cell._LBL_Doha_Miles.text = doha_text;
                }
                
                
                
                
                
        // Add Target For Buttons in cell
                
                [cell.BTN_plus addTarget:self action:@selector(plus_action:) forControlEvents:UIControlEventTouchUpInside];
                [cell.BTN_minus addTarget:self action:@selector(minus_action:) forControlEvents:UIControlEventTouchUpInside];
                cell.BTN_plus.tag = [[[arr_product objectAtIndex:indexPath.row] valueForKey:@"product_id"] intValue];
                cell.BTN_minus.tag = [[[arr_product objectAtIndex:indexPath.row] valueForKey:@"product_id"] intValue];
            
                
                
                cell.BTN_calendar.tag = [[NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"merchantId"]] integerValue];
                [cell.BTN_calendar addTarget:self action:@selector(calendar_action:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.BTN_stat addTarget:self action:@selector(BTN_check_clickds:) forControlEvents:UIControlEventTouchUpInside];
                [cell.BTN_box addTarget:self action:@selector(BTN_check_clickds:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.BTN_stat.tag = [[NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"merchantId"]] integerValue];
                cell.BTN_box.tag = cell.BTN_stat.tag;
                
                cell.LBL_stat.tag =j;
                
                //                if(cell.BTN_stat.tag == 0)
                
                cell._TXT_count.layer.borderWidth = 0.4f;
                cell._TXT_count.layer.borderColor = [UIColor grayColor].CGColor;
                
                cell.BTN_plus.layer.borderWidth = 0.4f;
                cell.BTN_plus.layer.borderColor = [UIColor grayColor].CGColor;
                cell.BTN_minus.layer.borderWidth = 0.4f;
                cell.BTN_minus.layer.borderColor = [UIColor grayColor].CGColor;
                

    // seperator View Border Setting
                cell.seperator_view.layer.borderWidth = 0.2f;
                cell.seperator_view.layer.borderColor = [UIColor lightGrayColor].CGColor;
                
                
     //Checking Cash On Delivary Available or Not For Payment Options
                if ([[NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"cod"]] isEqualToString:@"No"]) {
                    isCash_on_delivary = NO;
                }
//                else
//                {
//                    isCash_on_delivary = YES;
//                }
                
    //Delivary Slot checking Condition
                
                
        NSString *delivery_slot_available  =[NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"delivery_slot_available"]];
                
                
            NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
                
                if(indexPath.row == totalRow -1){ //last row
                    
                   // cell.seperator_view.hidden = NO;
                    
                    //[cell.seperator_view removeFromSuperview];
                    
                    if ([delivery_slot_available isEqualToString:@"No"] || [delivery_slot_available isEqualToString:@"<null>"])
                    {
                        
                        cell.BTN_calendar.hidden = YES;
                    }
                    else{
                        cell.BTN_calendar.hidden = NO;
                    }
                    
                }
                else{ //Not last row
                  //  cell.seperator_view.hidden = YES;

                    cell.BTN_calendar.hidden = YES;
                }
                
                
     //Expected Delivary Date customization
                
                NSString *expected_delivary_date  =[NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"expecteddelivery"]];
                
                if ([expected_delivary_date isEqualToString:@"No delivery date allocated"]) {
                    
                    cell.LBL_date.text = nil;
//                    cell.LBL_date.text = expected_delivary_date;
//                    cell.LBL_date.textColor = [UIColor redColor];
                }
                else{
                    expected_delivary_date = [expected_delivary_date stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                    
                    //cell.LBL_date.text = text1;
                    
                    NSString *text1 = [NSString stringWithFormat:@"Expected Delivery On %@",expected_delivary_date];
                    
                    if ([cell.LBL_date respondsToSelector:@selector(setAttributedText:)]) {
                        
                    // Define general attributes for the entire text
                            NSDictionary *attribs = @{
                                                      NSForegroundColorAttributeName:cell.LBL_date.textColor,
                                                      NSFontAttributeName:cell.LBL_date .font
                                                      };
                            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text1 attributes:attribs];
                            
                            NSRange ename = [text1 rangeOfString:expected_delivary_date];
                            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                                        range:ename];
                            }
                            else
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:12.0],NSForegroundColorAttributeName:[UIColor greenColor]}
                                                        range:ename];
                            }
                            
                            NSRange order = [text1 rangeOfString:@"Expected Delivery On"];
                            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                                        range:order];
                            }
                            else
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:12.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                                        range:order];
                            }
                            
                            
                            
                            cell.LBL_date .attributedText = attributedText;
                        }
              
                    else
                    {
                        cell.LBL_date .text = text1;
                    }
                }
            
                
    // PickUp from merchant location condition checking
                

                
                
                if(indexPath.row == totalRow -1){ //last row
                    
                    if ([[jsonresponse_dic valueForKey:@"pickup"] isKindOfClass:[NSDictionary class]]) {
                        NSArray *pickUpkeys = [[jsonresponse_dic valueForKey:@"pickup"]allKeys];
                        
                        @try {
                            
                            if ([pickUpkeys containsObject:str]) {
                                
                                NSLog(@"Available %@",str);
                               // cell.LBL_stat.hidden = NO;
                                cell.BTN_box.hidden = NO;
                                cell.BTN_stat.hidden = NO;
                            }else{
                                //cell.LBL_stat.hidden = YES;
                                cell.BTN_box.hidden = YES;
                                cell.BTN_stat.hidden = YES;
                            }
                            
                            
                            
                        } @catch (NSException *exception) {
                            //cell.LBL_stat.hidden = YES;
                            cell.BTN_box.hidden = YES;
                            cell.BTN_stat.hidden = YES;
                            NSLog(@"%@",exception);
                        }
                        
                    }
                    else{ //Not Dictionary
                        //cell.LBL_stat.hidden = YES;
                        cell.BTN_box.hidden = YES;
                        cell.BTN_stat.hidden = YES;
                    }
                }
                else{ // not last row
                    //cell.LBL_stat.hidden = YES;
                    cell.BTN_box.hidden = YES;
                    cell.BTN_stat.hidden = YES;
                }

                
// Shipping Charge labelcustomization
                NSString *CHRGE;
                NSString *qrcode = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"currencycode"]];
                NSString *shipping_type;
                
//                if(indexPath.row == totalRow -1){
//            @try
//                    {
//                        NSArray *key_ship_arr =[[jsonresponse_dic valueForKey:@"shipcharge"] allKeys];
//                        
//                        for(int m =0 ;m< key_ship_arr.count;m++)
//                        {
//                            if([str intValue] == [[key_ship_arr objectAtIndex:m] intValue])
//                            {
//                                
//                                @try {
//                                    cell.LBL_charge.hidden = NO;
//                                    
//                                    CHRGE = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:[key_ship_arr objectAtIndex:m]] valueForKey:@"charge"]];
//                                    
//                                    shipping_type = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:[key_ship_arr objectAtIndex:m]] valueForKey:@"methodname"]];
//                                    
//                                } @catch (NSException *exception) {
//                                    
//                                    CHRGE = @"";
//                                    shipping_type =@"";
//                                    
//                                    NSLog(@"%@",exception);
//                                }
//                            }
//                            else{
//                                cell.LBL_charge.hidden = YES;
//                            }
//                        }
//                    }
//                    @catch(NSException *exception)
//                    {
//                        CHRGE = [NSString stringWithFormat:@"%@", [jsonresponse_dic valueForKey:@"shipcharge"]];
//                        
//                    }
//                    
//                    
//                }
//                else{
//                    cell.LBL_charge.hidden = YES;
//                }

                //    *******or********
                NSArray *key_ship_arr;
                if(indexPath.row == totalRow -1){
                    @try
                    {
                      key_ship_arr =[[jsonresponse_dic valueForKey:@"shipcharge"] allKeys];
                        
                    
                            if([key_ship_arr containsObject:str])
                            {
                                
                                @try {
                                    cell.LBL_charge.hidden = NO;
                                    
                                    CHRGE = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:str] valueForKey:@"charge"]];
                                    
                                    shipping_type = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:str] valueForKey:@"methodname"]];
                                    
                                } @catch (NSException *exception) {
                                    
                                    CHRGE = @"";
                                    shipping_type =@"";
                                    
                                    NSLog(@"%@",exception);
                                }
                            }
                            else{
                                cell.LBL_charge.hidden = YES;
                            }
                        
                    }
                    @catch(NSException *exception)
                    {
                        CHRGE = [NSString stringWithFormat:@"%@", [jsonresponse_dic valueForKey:@"shipcharge"]];
                        
                    }
                    
                    
                }
                else{
                    cell.LBL_charge.hidden = YES;
                }

                
                
            
                CHRGE = [CHRGE stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
                NSString *text2 = [NSString stringWithFormat:@"%@    Shipping Charge %@ %@",shipping_type,qr,CHRGE]
                ;
                NSLog(@"........%@",text2);
                
                
                if ([cell.LBL_charge respondsToSelector:@selector(setAttributedText:)]) {
                    
                    // Define general attributes for the entire text
                    NSDictionary *attribs = @{
                                              NSForegroundColorAttributeName:cell.LBL_charge.textColor,
                                              NSFontAttributeName:cell.LBL_charge .font
                                              };
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text2 attributes:attribs];
                    
                    NSRange ename = [text2 rangeOfString:qrcode];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                                range:ename];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0]}
                                                range:ename];
                    }
                    
                    NSRange flatrate = [text2 rangeOfString:shipping_type];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                                range:flatrate];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0]}
                                                range:flatrate];
                    }
                    
                    
                    
                    
                    NSRange chrge = [text2 rangeOfString:CHRGE];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                                range:chrge];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                                range:chrge];
                    }
                    
                    
                    cell.LBL_charge .attributedText = attributedText;
                }
                else
                {
                    cell.LBL_charge .text = text2;
                }
                
           // CheckBox Pick From Merchant Location customization
                
                if (indexPath.row == totalRow-1) {
                    
                    if ([[[date_time_merId_Arr objectAtIndex:indexPath.section] valueForKey:@"pickMethod"]isEqualToString:@"1"]) {
                     cell.LBL_stat.image = [UIImage imageNamed:@"checkbox_select.png"];
                        [cell.BTN_box setBackgroundImage:[UIImage imageNamed:@"checkbox_select.png"] forState:UIControlStateNormal];
                        
                      // Calander
                        if ([delivery_slot_available isEqualToString:@"Yes"]) {
                            
                            cell.BTN_calendar.hidden = YES;
                        }
                      //Ship Charge
                        if([key_ship_arr containsObject:str])
                        {
                            cell.LBL_charge.text=nil;
                            //cell.LBL_charge.hidden = YES;
                        }
                        
                    }
                    else{
                       
                        cell.LBL_stat.image = [UIImage imageNamed:@"profile_checkbox.png"];
                         [cell.BTN_box setBackgroundImage:[UIImage imageNamed:@"profile_checkbox.png"] forState:UIControlStateNormal];
                        
                        //Calender
                        if ([delivery_slot_available isEqualToString:@"Yes"]) {
                            
                            cell.BTN_calendar.hidden = NO;
                        }
                        //Chgarge 
                        if([key_ship_arr containsObject:str])
                        {
                            cell.LBL_charge.hidden = NO;
                        }


                    }
                    
                    
            

                }
                
                
            }
            
            @catch(NSException *exception)
            {
                NSLog(@"%@",exception);
            }
            
            
            
            
            
            
        }
        
        else{
            
            [HttpClient createaAlertWithMsg:@"No orders Found" andTitle:@""];
            
        }
        
        return cell;
        
    }
    
    else
    {
        // ***************TableView Address**************
        
        shipping_cell *cell;
        
        @try {
            NSMutableDictionary *dict_shipping = [jsonresponse_dic_address valueForKey:@"shipaddress"];
            NSArray *keys_arr;
            
            if ([dict_shipping isKindOfClass:[NSDictionary class]]) {
                keys_arr = [dict_shipping allKeys];
            }
            
            if([dict_shipping isKindOfClass:[NSDictionary class]])
            {
                
                
                cell = [tableView dequeueReusableCellWithIdentifier:identifier_shipping];
                
                if (cell == nil)
                {
                    NSArray *nib;
                    nib = [[NSBundle mainBundle] loadNibNamed:@"shipping_cell" owner:self options:nil];
                    cell = [nib objectAtIndex:index];
                }
                
                cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
                cell.layer.shadowOffset = CGSizeMake(0.0, 0.0);
                cell.layer.shadowOpacity = 1.0;
                cell.layer.shadowRadius = 4.0;
                
                
                [cell.BTN_edit addTarget:self action:@selector(BTN_edit_clickd:) forControlEvents:UIControlEventTouchUpInside];
                cell.BTN_edit.tag = indexPath.row;

                
                
                if (keys_arr.count <3 && indexPath.row == keys_arr.count - 1) {
                    
                    //                if(indexPath.row == keys_arr.count - 1 )
                    //                {
                    cell.BTN_edit_addres.hidden = NO;
                    //}
                    
                }
                else{
                    cell.BTN_edit_addres.hidden = YES;
                }
                
#pragma Shipping address Table DATA
                NSString *name_str =[NSString stringWithFormat:@"%@ %@",[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"firstname"],[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"lastname"]];
                name_str = [name_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
                
                cell.LBL_name.text = name_str;
                // NSString *country;
                NSString *state = [[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"state"];
                NSString *country = [[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"country"];
                
                
                
                state = [state stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
                
                country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
                
                
                NSString *address_str = [NSString stringWithFormat:@"%@,\n%@ \n%@,\n%@, %@",[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"address1"],[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"city"],state,country,[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"zip_code"]];
                
                address_str = [address_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
                
                
                cell.LBL_address.text = address_str;
            
                [cell.BTN_edit_addres addTarget:self action:@selector(add_new_address:) forControlEvents:UIControlEventTouchUpInside];
                cell.BTN_edit_addres.tag = indexPath.row;
                
                cell.BTN_radio.tag = indexPath.row;
                [cell.BTN_radio addTarget:self action:@selector(radio_btn_action:) forControlEvents:UIControlEventTouchUpInside];
                
                //Radio Button Status Checking
                
                if ([[reload_section objectAtIndex:indexPath.row] isEqualToString:@"Yes"]) {
                    
                    [cell.BTN_radio setBackgroundImage:[UIImage imageNamed:@"radiobtn.png"] forState:UIControlStateNormal];
                   // cell.BTN_edit.enabled = YES;
                    
                    
                }
                else{
                    [cell.BTN_radio setBackgroundImage:[UIImage imageNamed:@"radio_unSlt.png"] forState:UIControlStateNormal];
                   // cell.BTN_edit.enabled = NO;
                    
                }
            }
            
            
            }
            @catch(NSException *exception)
            {
                
            }
        return cell;
            }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _TBL_orders)
    {
        NSInteger ct;
        
        @try {
            NSArray *keys_arr = [[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] allKeys];
            
             ct = [[[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] valueForKey:[keys_arr objectAtIndex:indexPath.section]]count];
            
            if (ct-1 == indexPath.row) {
                return 210.0;
                //return UITableViewAutomaticDimension;
            }
            
            else{
                return 160;
                //return UITableViewAutomaticDimension;
                
                
            }

        } @catch (NSException *exception) {
            
        }
    
    
    }
    else
    {
        
        if(indexPath.section == 0)
        {
            return 200;
            
            
        }
        else
        {//[jsonresponse_dic_address valueForKey:@"shipaddress"];
            if ([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]]) {
                return 200;
            }
            else{
                return 624.0;
            }
            
        }
        
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView == _TBL_orders)
    {
        return 5;
    }
    return 0;
}
#pragma mark - CollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return temp_arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    pay_cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0 && isfirstTimeTransform) { // make a bool and set YES initially, this check will prevent fist load transform
        isfirstTimeTransform = NO;
    }else{
        cell.transform = TRANSFORM_CELL_VALUE; // the new cell will always be transform and without animation
    }
    cell.IMG_card.image = [UIImage imageNamed:[temp_arr objectAtIndex:indexPath.row]];
    return cell;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    float pageWidth = 200 + 30; // width + space
    
    float currentOffset = scrollView.contentOffset.x;
    float targetOffset = targetContentOffset->x;
    float newTargetOffset = 0;
    
    if (targetOffset > currentOffset)
        newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
    else
        newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
    
    if (newTargetOffset < 0)
        newTargetOffset = 0;
    else if (newTargetOffset > scrollView.contentSize.width)
        newTargetOffset = scrollView.contentSize.width;
    
    targetContentOffset->x = currentOffset;
    [scrollView setContentOffset:CGPointMake(newTargetOffset, 0) animated:YES];
    
    int index = newTargetOffset / pageWidth;
    
    if (index == 0) { // If first index
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index  inSection:0]];
        
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{
            cell.transform = CGAffineTransformIdentity;
        }];
        cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index + 1  inSection:0]];
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{
            cell.transform = TRANSFORM_CELL_VALUE;
        }];
    }else{
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{
            cell.transform = CGAffineTransformIdentity;
        }];
        
        index --; // left
        cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{
            cell.transform = TRANSFORM_CELL_VALUE;
        }];
        if(index == temp_arr.count)
        {
            
            
            [UIView animateWithDuration:ANIMATION_SPEED animations:^{
                cell.transform = CGAffineTransformIdentity;
            }];
            cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index - 1  inSection:0]];
            [UIView animateWithDuration:ANIMATION_SPEED animations:^{
                cell.transform = TRANSFORM_CELL_VALUE;
            }];
            
        }
        
        
        index ++;
        index ++; // right
        cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        if(index == temp_arr.count)
        {
            
            
            [UIView animateWithDuration:ANIMATION_SPEED animations:^{
                cell.transform = CGAffineTransformIdentity;
            }];
            cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0  inSection:0]];
            [UIView animateWithDuration:ANIMATION_SPEED animations:^{
                cell.transform = TRANSFORM_CELL_VALUE;
            }];
            
        }
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{
            cell.transform = TRANSFORM_CELL_VALUE;
        }];
    }
}



#pragma button_actions
-(void)stat_chenged

{
    if(j == 1)
    {
        j =0;
        [self.TBL_orders reloadData];
    }
    else if(j == 0)
    {
        j = 1;
        [self.TBL_orders reloadData];
    }
    
    
    
}

//Terms and Conditions Button in Billing Address
-(void)BTN_check_clickd
{
    //profile_checkbox.png
    //checkbox_select.png

    NSData *imgData1 = UIImagePNGRepresentation(self.LBL_stat.image);
    NSData *imgData2 = UIImagePNGRepresentation([UIImage imageNamed:@"profile_checkbox.png"]);
    BOOL isCompare =  [imgData1 isEqualToData:imgData2];
    if (isCompare) {
        
        isCompare = NO;
        billcheck_clicked = @"0"; // for place order
        self.LBL_stat.image = [UIImage imageNamed:@"checkbox_select.png"];
       _TBL_address.hidden = YES;
        _VW_SHIIPING_ADDRESS.hidden = YES;
       CGRect frame_set  = _VW_special.frame;
        frame_set.origin.y = _VW_BILLING_ADDRESS.frame.origin.y + _VW_BILLING_ADDRESS.frame.size.height;
        _VW_special.frame = frame_set;
        shiiping_ht = _VW_special.frame.origin.y + _VW_special.frame.size.height;


        
    }
    else
    {
        //Checking Shippng Country is Quater Or Not
        
        billcheck_clicked = @"1"; // for place order

        isCompare = YES;
        self.LBL_stat.image = [UIImage imageNamed:@"profile_checkbox.png"];
    
        
        if([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]]){
            _TBL_address.hidden = NO;
            NSLog(@"Before lay Out frame%@",NSStringFromCGRect(_TBL_address.frame));
            NSLog(@"Before lay Out frame Content Hesigtht%f",_TBL_address.contentSize.height);

            [_TBL_address reloadData];
            NSLog(@"After lay Out frame%@",NSStringFromCGRect(_TBL_address.frame));
            NSLog(@"After lay Out frame Content Hesigtht%f",_TBL_address.contentSize.height);


           
            
             CGRect frame_set = _TBL_address.frame;
            frame_set.size.height = _TBL_address.frame.origin.y + _TBL_address.contentSize.height;
            _TBL_address.frame= frame_set;
            
            frame_set = _VW_special.frame;
            frame_set.origin.y =  _TBL_address.frame.origin.y+  _TBL_address.contentSize.height + ([[[jsonresponse_dic_address valueForKey:@"shipaddress"] allKeys]count] *180);
            _VW_special.frame = frame_set;
            
            shiiping_ht = _VW_special.frame.origin.y + _VW_special.frame.size.height;
             [self viewDidLayoutSubviews];
            
        }
        else{ //shipping address is nil load billing address
            _TBL_address.hidden = YES;
            _VW_SHIIPING_ADDRESS.hidden = NO;
            
            CGRect frameset = _VW_SHIIPING_ADDRESS.frame;
            frameset.origin.y = _VW_BILLING_ADDRESS.frame.origin.y + _VW_BILLING_ADDRESS.frame.size.height;
            frameset.size.width = _VW_shipping.frame.size.width;
            _VW_SHIIPING_ADDRESS.frame = frameset;
            [self.scroll_shipping addSubview:_VW_SHIIPING_ADDRESS];
            
            frameset = _VW_special.frame;
            frameset.origin.y = _VW_SHIIPING_ADDRESS.frame.origin.y + _VW_SHIIPING_ADDRESS.frame.size.height;
            _VW_special.frame = frameset;
            
            shiiping_ht = _VW_special.frame.origin.y + _VW_special.frame.size.height;
            [self viewDidLayoutSubviews];

        }
        
        
      
    }
     [self viewDidLayoutSubviews];
   }
-(void)calendar_action:(UIButton *)sender
{
    merchent_id = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self delivary_slot_API];
    //[self performSelector:@selector(delivary_slot_API) withObject:activityIndicatorView afterDelay:0.001];

   
    VW_overlay.hidden = NO;
    _VW_delivery_slot.hidden = NO;
    _BTN_done.layer.cornerRadius = 2.0f;
    _BTN_done.layer.masksToBounds = YES;
    _VW_delivery_slot.center = VW_overlay.center;
    _VW_delivery_slot.layer.cornerRadius = 2.0f;
    _VW_delivery_slot.layer.masksToBounds = YES;
    [VW_overlay addSubview:_VW_delivery_slot];
    //_VW_delivery_slot.hidden = NO;
    
}
//-(void)deliveryslot_action
//{
//    VW_overlay.hidden = YES;
//    _VW_delivery_slot.hidden = YES;
//}
-(void)next_page
{
    
    if([title_page_str isEqualToString:@"ORDER DETAIL"])
    {

            VW_overlay.hidden = YES;
//            [activityIndicatorView startAnimating];
        
            [self performSelector:@selector(move_to_shipping) withObject:nil afterDelay:0.01];

           
      
        
    }
    else  if([title_page_str isEqualToString:@"SHIPPING"])
    {
        
       
             VW_overlay.hidden = YES;
//            [activityIndicatorView startAnimating];
        
            [self performSelector:@selector(validatingTextField) withObject:nil afterDelay:0.01];
           
        
    }
    
      else if ([title_page_str isEqualToString:@"PAYMENT"] && _VW_payment.hidden == NO) {
        VW_overlay.hidden = YES;
//          [activityIndicatorView startAnimating];
          
          [self performSelector:@selector(move_to_payment_integration) withObject:nil afterDelay:0.01];
          
       
    }
    
}

-(void)move_to_shipping
{
    _TBL_orders.hidden = YES;
    
    title_page_str = @"SHIPPING";
    //_LBL_navigation.title = @"SHIPPING";
    //_scroll_shipping.hidden = NO;
    _VW_shipping.hidden = NO;

    _TBL_address.estimatedRowHeight = 4.0;
    _TBL_address.rowHeight = UITableViewAutomaticDimension;
    
    
    [self.TBL_address reloadData];
    _TBL_address.hidden = YES;
    
    //[_TBL_orders removeFromSuperview];
    CGRect frame_set = _VW_shipping.frame;
    frame_set.origin.y = _VW_top.frame.origin.y + _VW_top.frame.size.height;
    frame_set.size.width = _TBL_orders.frame.size.width;
    frame_set.size.height = _VW_next.frame.origin.y - _TBL_orders.frame.origin.y;
    _VW_shipping.frame = frame_set;
    [self.view addSubview:_VW_shipping];
    _TXT_first.backgroundColor = _LBL_order_detail.backgroundColor;
    _LBL_shipping.backgroundColor =_LBL_order_detail.backgroundColor;
    
//    VW_overlay.hidden = YES;
//    [activityIndicatorView stopAnimating];

    
}

-(void)move_to_payment_integration{
   
    
    
        NSLog(@"%@",payment_type_str);
    
        if ([payment_type_str isEqualToString:@"1"]||[payment_type_str isEqualToString:@"2"] ||[payment_type_str isEqualToString:@"3"] ||[payment_type_str isEqualToString:@"4"] || [payment_type_str isEqualToString:@"5"]) {
            
        
            
            VW_overlay.hidden = NO;
            [self.view addSubview:VW_overlay];
            
            
            [_LBL_timer_lbl setText:@"02:00"];
            currMinute=02;
            currSeconds=00;
            
            [_BTN_resend_otp setEnabled:NO];
            [_BTN_resend_otp setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

            if ([payment_type_str isEqualToString:@"5"]) {
                [self gettingOtpForCashOnDelivary];
                
                self.VW_otp_vw.hidden = NO;
                self.VW_otp_vw.frame = self.VW_otp_vw.frame;
                self.VW_otp_vw.center = VW_overlay.center;
                [self->VW_overlay addSubview:self.VW_otp_vw];
                timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
                
                
                
            }
            else{
                self.VW_otp_vw.hidden = YES;
               [self performSelector:@selector(place_oredr_API) withObject:nil afterDelay:0.01];
            }

            
            
        }
        else{
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
           
            [HttpClient createaAlertWithMsg:@"الرجاء تحديد نوع الدفع" andTitle:@""];
            }
            else{
            [HttpClient createaAlertWithMsg:@"Please Select Payment Type" andTitle:@""];
            }
        }
    }
#pragma mark Timer Implementation

-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1)
            [_LBL_timer_lbl setText:[NSString stringWithFormat:@"%d%@%02d",currMinute,@":",currSeconds]];
    }
    else
    {
        [timer invalidate];
        [_BTN_resend_otp setEnabled:YES];
         [_BTN_resend_otp setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
   }
// Validate_OTP Action
-(void)validate_OTP{
    if ([_TXT_message_field.text isEqualToString:otp_str]) {
       NSLog(@"VAlidate");
        [self place_oredr_API];
    }
    else{
        NSLog(@"Please Enter Valid OTP");
        [_TXT_message_field becomeFirstResponder];
    }
   }
//resend_action
-(void)resend_action{
    [self gettingOtpForCashOnDelivary];
    [_LBL_timer_lbl setText:@"02:00"];
    currMinute=02;
    currSeconds=00;
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}


-(void)move_to_payment_types{
    
    [self performSelector:@selector(payment_methods_API) withObject:nil afterDelay:0.001];
    _TBL_address.hidden = YES;
    title_page_str =@"PAYMENT";
    //_LBL_navigation.title = @"PAYMENT";
    //  [_Collection_cards reloadData];
    //[_TBL_orders removeFromSuperview];
    CGRect frame_set = _VW_payment.frame;
    frame_set.origin.y = _VW_top.frame.origin.y + _VW_top.frame.size.height;
    frame_set.size.width = _TBL_orders.frame.size.width;
    frame_set.size.height = _VW_next.frame.origin.y - _TBL_orders.frame.origin.y;
    _VW_payment.frame = frame_set;
    [self.view addSubview:_VW_payment];
    //_LBL_shipping.backgroundColor = _LBL_order_detail.backgroundColor;
    _TXT_second.backgroundColor = _LBL_order_detail.backgroundColor;
    _LBL_Payment.backgroundColor=_LBL_order_detail.backgroundColor;

    
}

-(void)product_clicked
{
    if([title_page_str isEqualToString:@"ORDER DETAIL"])
    {
        [self.view addSubview:VW_overlay];
        [self sumary_VIEW];
    }
    
    else if([title_page_str isEqualToString:@"SHIPPING"])
    {
        [self.view addSubview:VW_overlay];
        [self sumary_VIEW];
        
    }
    else if([title_page_str isEqualToString:@"PAYMENT"])
    {
        [self.view addSubview:VW_overlay];
        [self sumary_VIEW];
        
    }
    
}
-(void)sumary_VIEW
{
    if([_LBL_arrow.text isEqualToString:@""])
    {
        _LBL_arrow.text = @"";
        CGRect frameset = VW_overlay.frame;
        frameset.size.height = self.view.frame.size.height - _VW_next.frame.size.height-20;
        VW_overlay.frame = frameset;
        VW_overlay.hidden = NO;
       _VW_summary.hidden = NO;
        
        //_LBL_arrow.text = @"";
        
        [self fill_value_to_Lbl_product_summary:@""];
    }
    else
    {
        _LBL_arrow.text =@"";
        CGRect frameset = VW_overlay.frame;
        frameset.size.height = self.view.frame.size.height;
        VW_overlay.frame = frameset;

        VW_overlay.hidden = YES;
        _VW_summary.hidden =  YES;
        
         [self fill_value_to_Lbl_product_summary:@""];
        
    }
    
}
-(void)apply_promo_action{
    
    if ([self.TXT_cupon.text isEqualToString:@""]) {
    
        [self.TXT_cupon becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            
        [HttpClient createaAlertWithMsg:@"الرجاء إدخال رمز الكوبون" andTitle:@""];
        }
        else{
             [HttpClient createaAlertWithMsg:@"Please enter cupon code" andTitle:@""];
        }
    }
    else{
     
    [self performSelector:@selector(apply_promo_Code) withObject:nil afterDelay:0.001];
    }
}

//Tbl Orders Check Button Clicked
-(void)stat_chenged:(id)sender

{
    if(j == 1)
    {
        j =0;
        [self.TBL_orders reloadData];
    }
    else if(j == 0)
    {
        j = 1;
        [self.TBL_orders reloadData];
    }
    
    
    
}
-(void)BTN_edit_clickd:(UIButton*)sender
{
   
    
    _VW_SHIIPING_ADDRESS.hidden = NO;
    CGRect frameset = _VW_SHIIPING_ADDRESS.frame;
    frameset.origin.y = _TBL_address.frame.origin.y + _TBL_address.contentSize.height + 20;
    frameset.size.width = _VW_shipping.frame.size.width;
    _VW_SHIIPING_ADDRESS.frame = frameset;
    [self.scroll_shipping addSubview:_VW_SHIIPING_ADDRESS];
    
    frameset = _VW_special.frame;
    frameset.origin.y = _VW_SHIIPING_ADDRESS.frame.origin.y + _VW_SHIIPING_ADDRESS.frame.size.height;
    _VW_special.frame = frameset;
    
    shiiping_ht = _VW_special.frame.origin.y + _VW_special.frame.size.height;
    [self viewDidLayoutSubviews];
    
//    isAddClicked = NO;
//    i = 3;
    edit_tag = [sender tag];
    
    @try {
        
        NSArray *keys_arr = [[jsonresponse_dic_address valueForKey:@"shipaddress"] allKeys];
        
        
        
        for (int keys=0; keys<[keys_arr count]; keys++) {
            
            if (keys == sender.tag) {
                
                [reload_section replaceObjectAtIndex:keys withObject:@"Yes"];
            }
            else{
                [reload_section replaceObjectAtIndex:keys withObject:@"No"];
            }
            
            
        }
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TBL_address];
        NSIndexPath *indexPath = [self.TBL_address indexPathForRowAtPoint:buttonPosition];
        
        //Reload Particular Section in TableView
        [self.TBL_address beginUpdates];
        [self.TBL_address reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        [self.TBL_address endUpdates];

        

        NSString *state = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"state"];
        NSString *country = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"country"];
        //  state = [state stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        //  country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        NSString *str_fname,*str_lname,*str_addr1,*str_addr2,*str_city,*str_zip_code,*str_phone,*str_country,*str_state,*str_email,*str_phone_code;
        
        str_fname = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"firstname"];
        str_lname = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"lastname"];
        str_addr1 = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"address1"];
        str_addr2 = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"address2"];
        str_city = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"city"];
        str_zip_code = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"zip_code"];
        str_phone = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"phone"];
        str_country = country;
        str_state =state;
        
        
        //cell.Btn_save.hidden = YES;
        
    ship_state_ID = [NSString stringWithFormat:@"%@",[[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"state_id"]];
        
    ship_cntry_ID = [NSString stringWithFormat:@"%@",[[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"country_id"]];
        
      str_phone_code=[[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"phonecode"];
        
        if ([str_phone_code isEqualToString:@"<null>"] ||[str_phone_code isEqualToString:@"<nil>"]||[str_phone_code isEqualToString:@""] ) {
            str_phone_code = @"+974";
        }
    
    str_fname = [str_fname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    
    str_lname = [str_lname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    str_addr1 = [str_addr1 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    str_addr2 = [str_addr2 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    str_city = [str_city stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    str_zip_code = [str_zip_code stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    str_phone = [str_phone stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    
    str_country = [str_country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Select Country"];
    
    str_state = [str_state stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_email = [str_email stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        
        
        if ([str_zip_code isEqualToString:@"<null>"] ||[str_zip_code isEqualToString:@"<nil>"]||[str_zip_code isEqualToString:@"null"] ) {
            str_zip_code = @"";
        }

        
        _TXT_ship_fname.text =  str_fname;
         _TXT_ship_lname.text =  str_lname;
         _TXT_ship_addr1.text =  str_addr1;
        _TXT_ship_addr2.text =  str_addr2;
         _TXT_ship_city.text =  str_city;
         _TXT_ship_state.text =  str_state;
         _TXT_ship_zip.text =  str_zip_code;
         _TXT_ship_country.text =  str_country;
        _TXT_ship_email.text =  str_email;
        _TXT_ship_phone.text =  str_phone;
        _TXT_ship_cntry_code.text =str_phone_code;
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}
-(void)add_new_address:(UIButton*)sender{
    
    //Shipping Address  For PAyment Paramater
     newaddressinput= @"1";
    
    _VW_SHIIPING_ADDRESS.hidden = NO;
    CGRect frameset = _VW_SHIIPING_ADDRESS.frame;
    frameset.origin.y = _TBL_address.frame.origin.y + _TBL_address.contentSize.height + 20;
    frameset.size.width = _VW_shipping.frame.size.width;
    _VW_SHIIPING_ADDRESS.frame = frameset;
    [self.scroll_shipping addSubview:_VW_SHIIPING_ADDRESS];
    
    frameset = _VW_special.frame;
    frameset.origin.y = _VW_SHIIPING_ADDRESS.frame.origin.y + _VW_SHIIPING_ADDRESS.frame.size.height;
    _VW_special.frame = frameset;
    
    shiiping_ht = _VW_special.frame.origin.y + _VW_special.frame.size.height;
    [self viewDidLayoutSubviews];
    
    _TXT_ship_fname.text =  nil;
    _TXT_ship_lname.text =  nil;
    _TXT_ship_addr1.text =  nil;
    _TXT_ship_addr2.text =  nil;
    _TXT_ship_city.text =  nil;
    _TXT_ship_state.text =  nil;
    _TXT_ship_zip.text =  nil;
    _TXT_ship_country.text =  @"Qatar";
    _TXT_ship_email.text =  nil;
    _TXT_ship_phone.text =  nil;
    
    _TXT_ship_cntry_code.text = @"+974";
    
}

-(void)deliveryslot_action // Done Button
{
    if ([_TXT_Date.text length] != 0 && [_TXT_Time.text length] != 0) {
        
        // Getting merchant Id ,Day/Date and time Id for payment
        for (int m=0; m<date_time_merId_Arr.count; m++) {
            
            if ([merchent_id isEqualToString:[[date_time_merId_Arr objectAtIndex:m] valueForKey:@"mer_id"]]) {
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic addEntriesFromDictionary:[date_time_merId_Arr objectAtIndex:m]];
                
                [dic setObject:time_str forKey:@"time"];
                [dic setObject:date_str forKey:@"date"];

               // NSDictionary *dic = @{@"mer_id":merchent_id,@"time":time_str,@"date":date_str};
                
                [date_time_merId_Arr replaceObjectAtIndex:m withObject:dic];
                
            }
        }NSLog(@"@@@@@@@@@@ %@",date_time_merId_Arr);
        
        
        VW_overlay.hidden = YES;
        _VW_delivery_slot.hidden = YES;
        
        _TXT_Date.text = nil;
        _TXT_Time.text = nil;
        
        
    }
    else{
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            
            [HttpClient createaAlertWithMsg:@"بليز حدد الوقت واليوم / التاريخ" andTitle:@""];;
        }
        else{
            [HttpClient createaAlertWithMsg:@"Plese select Time and  Day/Date" andTitle:@""];
        }
       
    }
    
    
    
}
// Billing Address Check Button  Clicked

//-(void)BTN_chek_action:(id)sender
//{
//    if([[stat_arr objectAtIndex:0] isEqualToString:@"1"])
//    {
//        [stat_arr replaceObjectAtIndex:0 withObject:@"0"];
//        i= 1;
//        
//        
//    }
//    else
//    {
//        [stat_arr replaceObjectAtIndex:0 withObject:@"1"];
//        i = 2;
//        
//    }
//    [self.TBL_address reloadData];
//}

//Radio_button_action
-(void)radio_btn_action:(UIButton*)sender{
    
    
    @try {
        
        if ([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]]) {
            NSArray *keys_arr = [[jsonresponse_dic_address valueForKey:@"shipaddress"] allKeys];
            for (int keys=0; keys<[keys_arr count]; keys++) {
                
                if (keys == sender.tag) {
                    
                    [reload_section replaceObjectAtIndex:keys withObject:@"Yes"];
                }
                else{
                    [reload_section replaceObjectAtIndex:keys withObject:@"No"];
                }
                
                
            }
        }
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TBL_address];
        NSIndexPath *indexPath = [self.TBL_address indexPathForRowAtPoint:buttonPosition];
        
        //Reload Particular Section in TableView
        [self.TBL_address beginUpdates];
        [self.TBL_address reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        [self.TBL_address endUpdates];
        if (edit_tag != sender.tag) {
           CGRect frameset = _VW_special.frame;
            frameset.origin.y = _TBL_address.frame.origin.y + _TBL_address.frame.size.height - 150;
            _VW_special.frame = frameset;
            
            shiiping_ht = _VW_special.frame.origin.y + _VW_special.frame.size.height;
            [self viewDidLayoutSubviews];
            [self.VW_SHIIPING_ADDRESS removeFromSuperview];
            
        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
    
}
-(void)radioButton_values{
    
    @try {
        
        reload_section = [NSMutableArray array];
        
        if ([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]]) {
            
            
            NSArray *keys_arr = [[jsonresponse_dic_address valueForKey:@"shipaddress"] allKeys];
            for (int keys=0; keys<[keys_arr count]; keys++) {
                
                [reload_section addObject:[[[[jsonresponse_dic_address valueForKey:@"shipaddress"] valueForKey:[keys_arr objectAtIndex:keys]] valueForKey:@"shippingaddress"] valueForKey:@"default"]];
                
                
            }
            NSLog(@"reload_section ::::%@",reload_section);
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}


// TableView orders Cell check Clicked

-(void)BTN_check_clickds:(UIButton *)sender
{
    if (orderCheckSelected) {
        orderCheckSelected = NO;
    }else{
        orderCheckSelected = YES;
    }
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TBL_orders];
    NSIndexPath *indexPathsec = [self.TBL_orders indexPathForRowAtPoint:buttonPosition];
    
    merchent_id = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    //checkbox selection status adding to placeorder paramaters
    
    for (int m=0; m<date_time_merId_Arr.count; m++) {
     
     if ([merchent_id isEqualToString:[[date_time_merId_Arr objectAtIndex:m] valueForKey:@"mer_id"]]) {
     
     NSMutableDictionary *dic = [NSMutableDictionary dictionary];
     [dic addEntriesFromDictionary:[date_time_merId_Arr objectAtIndex:m]];
     
         
         if (orderCheckSelected) {
              [dic setObject:@"1" forKey:@"pickMethod"];
             [self Updating_ship_charge_when_pick_up_selection:@"minus"]; // Reduce amount
         }else{
            [dic setObject:@"0" forKey:@"pickMethod"];
             
             [self Updating_ship_charge_when_pick_up_selection:@"plus"]; // Add Amount
             
         }

     [date_time_merId_Arr replaceObjectAtIndex:m withObject:dic];
         
         
         [self.TBL_orders beginUpdates];
         
         [self.TBL_orders reloadSections:[NSIndexSet indexSetWithIndex:indexPathsec.section] withRowAnimation:UITableViewRowAnimationNone];
         
         [self.TBL_orders endUpdates];
     
     }
     }
}
#pragma mark Updating Shipping Charge When pick From Merchant location

-(void)Updating_ship_charge_when_pick_up_selection:(NSString *)reduce{
    
    @try {
        
        NSString *reduce_amount = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:merchent_id] valueForKey:@"charge"]];
        
        if ([reduce_amount isEqualToString:@"<null>"]||[reduce_amount isEqualToString:@"<nil>"]||[reduce_amount isEqualToString:@""]) {
            reduce_amount=@"0";
        }
        if ([reduce isEqualToString:@"minus"]) {
            charge_ship = charge_ship-[reduce_amount floatValue];
        }
        else{
            charge_ship = charge_ship+[reduce_amount floatValue];
        }
        
        
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            self.LBL_shipping_charge.text = [NSString stringWithFormat:@"%.2f %@",charge_ship,[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
        }
        else{
          self.LBL_shipping_charge.text = [NSString stringWithFormat:@"%@ %.2f",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],charge_ship];
        }
        
    } @catch (NSException *exception) {
        
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            self.LBL_shipping_charge.text = [NSString stringWithFormat:@"%.2f %@",charge_ship,[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
        }
        else{
        
        self.LBL_shipping_charge.text = [NSString stringWithFormat:@"%@ %.2f",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],charge_ship];
        }
        
    }
    [self set_data_to_product_Summary_View];

}


-(void)btnfav_action
{
    //[self performSegueWithIdentifier:@"" sender:self];
    
    NSLog(@"fav_clicked");
}
-(void)btn_cart_action
{
    //[self performSegueWithIdentifier:@"" sender:self];
    NSLog(@"cart_clicked");
}
-(void)tapGesture_close
{
    // [self dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"the cancel clicked");
}
-(void)minus_action:(UIButton*)btn
{
    CGPoint center= btn.center;
    CGPoint rootViewPoint = [btn.superview convertPoint:center toView:self.TBL_orders];
    NSIndexPath *indexPath = [self.TBL_orders indexPathForRowAtPoint:rootViewPoint];
    
    order_cell *cell = (order_cell*)[self.TBL_orders cellForRowAtIndexPath:indexPath];
    
    if ([cell._TXT_count.text isEqualToString:@"1"]) {
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            
            [HttpClient createaAlertWithMsg:@"يجب أن يكون الحد الأدنى من الكمية 1." andTitle:@""];;
        }
        else{
            [HttpClient createaAlertWithMsg:@"Minimum Quantity Should be 1." andTitle:@""];
        }

        
        }else{
        
        NSString *cnt = [NSString stringWithFormat:@"%ld",[cell._TXT_count.text integerValue]-1];
        
        item_count = cnt;
        
        
        product_id = [NSString stringWithFormat:@"%ld",(long)btn.tag];//Getting product Id
        
        
        merchent_id = [NSString stringWithFormat:@"%ld",cell.BTN_calendar.tag]; //Getting Mer Id
        
        NSLog(@"id_m %@  id_p %@",product_id,merchent_id);
        
        //[self updating_cart_List_api];
        
        
        
        //    NSArray *keys_arr = [[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] allKeys];
        //    arr_product = [[[jsonresponse_dic valueForKey:@"data"] valueForKey:@"pdts"] valueForKey:[keys_arr objectAtIndex:indexPath.section]];
        
        //    NSString *prev_price = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"productprice"]];
        //
        //    NSString *price = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"specialPrice"]];
        //    NSInteger subTtl;
        @try {
            //subTtl = total + [price integerValue];
            [self  updating_cart_List_api:[NSString stringWithFormat:@"%@",item_count]];
            
        } @catch (NSException *exception) {
            
            //subTtl = total + [prev_price integerValue];
            [self  updating_cart_List_api:[NSString stringWithFormat:@"%@",item_count]];
            
        }
        
    }
}
-(void)plus_action:(UIButton*)btn
{
    CGPoint center= btn.center;
    CGPoint rootViewPoint = [btn.superview convertPoint:center toView:self.TBL_orders];
    NSIndexPath *indexPath = [self.TBL_orders indexPathForRowAtPoint:rootViewPoint];
    order_cell *cell = (order_cell*)[self.TBL_orders cellForRowAtIndexPath:indexPath];
    
    NSString *cnt = [NSString stringWithFormat:@"%ld",[cell._TXT_count.text integerValue]+1];
    
    item_count = cnt;
    
    product_id = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    
    merchent_id = [NSString stringWithFormat:@"%ld",cell.BTN_calendar.tag];
    
    NSLog(@"id_m %@  id_p %@",product_id,merchent_id);
    
    //    NSArray *keys_arr = [[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] allKeys];
    //    arr_product = [[[jsonresponse_dic valueForKey:@"data"] valueForKey:@"pdts"] valueForKey:[keys_arr objectAtIndex:indexPath.section]];
    //
    //    NSString *prev_price = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"productprice"]];
    //
    //    NSString *price = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"specialPrice"]];
    //    //[self updating_cart_List_api];
    //    NSInteger subTtl;
    @try {
        //subTtl = total + [price integerValue];
        [self  updating_cart_List_api:[NSString stringWithFormat:@"%@",item_count]];
        
    } @catch (NSException *exception) {
        
        //subTtl = total + [prev_price integerValue];
        [self  updating_cart_List_api:[NSString stringWithFormat:@"%@",item_count]];
        
    }
    
    
}

- (IBAction)back_action_clicked:(id)sender {
    
    if([title_page_str isEqualToString:@"ORDER DETAIL"])
    {
        
    /*    VW_overlay.hidden = YES;
        //            [activityIndicatorView startAnimating];
        
        [self performSelector:@selector(move_to_shipping) withObject:nil afterDelay:0.01];*/
        
        
        [self.navigationController popViewControllerAnimated:NO];
        
    }
    else  if([title_page_str isEqualToString:@"SHIPPING"])
    {
        _TBL_orders.hidden = NO;
        [self.view addSubview:_TBL_orders];
        _VW_shipping.hidden = YES;
         _Scroll_card.hidden = YES;
        title_page_str =  @"ORDER DETAIL";
        _TXT_first.backgroundColor = [UIColor clearColor];
        _LBL_shipping.backgroundColor =[UIColor clearColor];

      //  [self set_UP_VIEW];
        
        
    }
    
    else if ([title_page_str isEqualToString:@"PAYMENT"] && _VW_payment.hidden == NO) {
        
        VW_overlay.hidden = YES;
        _VW_pay_cards.hidden = YES;
          title_page_str =  @"SHIPPING";
        _TXT_second.backgroundColor = [UIColor clearColor];
        _LBL_Payment.backgroundColor =[UIColor clearColor];

        
         //            [activityIndicatorView startAnimating];
        [self performSelector:@selector(move_to_shipping) withObject:nil afterDelay:0.01];
        
        
        
    }

    
   // [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark text field delgates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
  
    [textField becomeFirstResponder];
    if (textField == _TXT_Date ) {
        
        @try {
            
            is_Txt_date = YES;
            [picker_Arr removeAllObjects];
            
            NSDate *day_date;
            if ([[delivary_slot_dic valueForKey:@"days"] isKindOfClass:[NSDictionary class]]) {
                
                slot_keys_arr = [[delivary_slot_dic valueForKey:@"days"]allKeys];
                for (int slot = 0; slot< slot_keys_arr.count; slot++) {
                    
                    NSString *str = [[delivary_slot_dic valueForKey:@"days"] valueForKey:[slot_keys_arr objectAtIndex:slot]];
                    NSRange startRange = [str rangeOfString:@"(" options:NSBackwardsSearch];
                    str= [str substringFromIndex:startRange.location+startRange.length];
                    str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
                    
                    dateFormatter.dateFormat = @"MMM d,yyyy";
                    
                    // Converting String(Eg.. Jan 29,2018) To Date
                    day_date = [dateFormatter dateFromString:str];
                    [picker_Arr addObject: @{@"key1":day_date,@"key2":[[delivary_slot_dic valueForKey:@"days"] valueForKey:[slot_keys_arr objectAtIndex:slot]],@"key3":[slot_keys_arr objectAtIndex:slot]}];
                    
                }
                // Sorting By Using Date
                NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"key1" ascending:YES];
                NSArray *descriptors=[NSArray arrayWithObject: descriptor];
                NSArray *reverseOrder=[picker_Arr sortedArrayUsingDescriptors:descriptors];
                NSLog(@" After sorting%@",reverseOrder);
                 [picker_Arr removeAllObjects];
                [picker_Arr addObjectsFromArray:reverseOrder];
                
           }
        
            if (!picker_Arr.count) {
                NSLog(@"Sorry! There is no options." );
            }else{
                [self.pickerView becomeFirstResponder];
                [self.pickerView reloadAllComponents];
            }
            
            
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
    }
    if (textField == _TXT_Time ) {
        
       [self delivary_slot_time_related:textField];
    }
    if (textField == _TXT_country|| textField == _TXT_state) {
        select_blng_ctry_state = YES;
    }
    if (textField == _TXT_ship_country || textField == _TXT_ship_state ) {
        select_blng_ctry_state = NO;

    }
    
    if (textField.tag == 8) {
        isCountrySelected = YES;
        
        textField.inputView = _staes_country_pickr;
        textField.inputAccessoryView = accessoryView;
        [self.pickerView becomeFirstResponder];
        [self performSelector:@selector(CountryAPICall) withObject:nil afterDelay:0];
       
        
    }
    if (textField.tag == 6) {
        
        isCountrySelected = NO;
        textField.inputView = _staes_country_pickr;
        textField.inputAccessoryView = accessoryView;
        [self.pickerView becomeFirstResponder];
        [self performSelector:@selector(stateApiCall) withObject:nil afterDelay:0];
        
    }
    
    if(textField == _TXT_phone ||textField == _TXT_Cntry_code || textField ==_TXT_ship_cntry_code || textField ==_TXT_country || textField ==_TXT_state||textField == _TXT_ship_phone||textField == _TXT_city||textField == _TXT_zip||textField == _TXT_ship_zip||textField == _TXT_ship_city||textField == _TXT_ship_country||textField == _TXT_ship_state||textField == _TXT_ship_addr2 || textField == _TXT_instructions)
    {
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,-190,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];

    }
    if(textField == _TXT_cupon)
    {
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,-150,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
    }

    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
   
        
        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
    
    [textField resignFirstResponder];
    
    if (textField == _TXT_ship_cntry_code) {
        textField.text = flag;
    }
    if (textField == _TXT_Cntry_code) {
         textField.text = flag;
    }
    
    if (textField.tag == 6) {
        
        textField.text = state_selection;
        
    }
    if (textField.tag == 8) {
        
        
        textField.text = cntry_selection;
        
        
        if (textField == _TXT_country) {
            _TXT_state.placeholder = @"Select State";

        }
        if (textField == _TXT_ship_country) {
             _TXT_ship_state.placeholder = @"Select State";
        }
        
        if ([textField.text isEqualToString:@""]) {
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
            [HttpClient createaAlertWithMsg:@"الرجاء تحديد البلد" andTitle:@""];
            }
            else{
              [HttpClient createaAlertWithMsg:@"Please Select Country " andTitle:@""];
            }
       }
}
    
}

#pragma mark Delivary Slot Time Related
-(void)delivary_slot_time_related:(UITextField*)textfield{
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    [picker_Arr removeAllObjects];
    
    is_Txt_date= NO;
    if ([[delivary_slot_dic valueForKey:@"delivery"] isKindOfClass:[NSDictionary class]]) {
        
        slot_keys_arr = [[delivary_slot_dic valueForKey:@"delivery"]allKeys];
        
        //            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        dateFormatter.dateFormat = @"hh:mm a";
        
        
        for (int slot = 0; slot< slot_keys_arr.count; slot++) {
            
            // [picker_Arr addObject:[[delivary_slot_dic valueForKey:@"delivery"] valueForKey:[slot_keys_arr objectAtIndex:slot]]];
            
            NSString *str = [[delivary_slot_dic valueForKey:@"delivery"] valueForKey:[slot_keys_arr objectAtIndex:slot]];
            NSRange equalRange = [str rangeOfString:@"-" options:NSBackwardsSearch];
            
            
            if (equalRange.location != NSNotFound) {
                
                NSString *result_before = [str substringWithRange:NSMakeRange(0, equalRange.location)];
                NSDate *time1 = [dateFormatter dateFromString:result_before];
                [picker_Arr addObject: @{@"time":[[delivary_slot_dic valueForKey:@"delivery"] valueForKey:[slot_keys_arr objectAtIndex:slot]],@"id":[slot_keys_arr objectAtIndex:slot],@"strt_time_to_sort":time1}];
            }//Close If
            
        }//close for
        // Sorting By Using Date
        NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"strt_time_to_sort" ascending:YES];
        NSArray *descriptors=[NSArray arrayWithObject: descriptor];
        NSArray *reverseOrder=[picker_Arr sortedArrayUsingDescriptors:descriptors];
        NSLog(@" After sorting%@",reverseOrder);
        [picker_Arr removeAllObjects];
        [picker_Arr addObjectsFromArray:reverseOrder];
    }
    
    // Comparing Current time with below time(API Response)
    if ([_TXT_Date.text containsString:@"Today"]) {
        
        
        [dateFormatter setTimeZone:timeZone];
        NSDate *now = [NSDate date];
        dateFormatter.dateFormat = @"hh:mm a";
        
        
        
        NSTimeInterval secondsInEightHours = 3 * 60 * 60;
        NSDate *datethreeHoursAhead=[now dateByAddingTimeInterval:secondsInEightHours];
        
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        
        NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
        
        NSString *current_date = [dateFormatter stringFromDate:datethreeHoursAhead];
        NSDate *current_time= [dateFormatter dateFromString:current_date];
        
        NSLog(@"current_time After Adding time %@",[dateFormatter stringFromDate:datethreeHoursAhead]);
        
        NSMutableArray *data_arr = [[NSMutableArray alloc]initWithArray:picker_Arr];
        
        for (int b=0; b<picker_Arr.count; b++) {
            
            NSString *str = [[picker_Arr objectAtIndex:b] valueForKey:@"time"];
            NSRange equalRange = [str rangeOfString:@"-" options:NSBackwardsSearch];
            
            
            if (equalRange.location != NSNotFound) {
                
                //NSString *result_after = [str substringFromIndex:equalRange.location + equalRange.length];
                NSString *result_before = [str substringWithRange:NSMakeRange(0, equalRange.location)];
                // NSLog(@"The result%@ = %@",result_before,result_after);
                
                
                //Converting starting time into NSDate
                NSDate *time1 = [dateFormatter dateFromString:result_before];
                NSLog(@" %d::::b  %@  ------- %@",b,time1,current_time);
                
                @try {
                    NSComparisonResult result = [current_time compare:time1];
                    
                    //Comparing Starting Time with Current time
                    if(result == NSOrderedDescending)
                    {
                        NSLog(@"Current Time %@ is later than time1 %@",current_date,result_before);
                        
                        //[picker_Arr removeObjectAtIndex:b];
                        [data_arr removeObject:[picker_Arr objectAtIndex:b]];
                    }
                    else if (result == NSOrderedAscending){
                        
                        NSLog(@"Current Time %@ is less than time1 %@",current_date,result_before);
                    }
                    else{
                        NSLog(@"Current Time %@  time1 %@ are equal",current_date,result_before);
                    }
                } @catch (NSException *exception) {
                    NSLog(@"**********");
                }
                
                
            } else {
                NSLog(@"There is no = in the string");
            } //eof If
            
            
        }
        [picker_Arr removeAllObjects];
        [picker_Arr addObjectsFromArray:data_arr];
    }
    if (!picker_Arr.count) {
        [HttpClient createaAlertWithMsg:@"No Slots Available For This Day." andTitle:@""];
        NSLog(@"Sorry! There is no options,Please Select Another Day" );
        [textfield resignFirstResponder];
    }else{
        [self.pickerView becomeFirstResponder];
        [self.pickerView reloadAllComponents];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)order_to_cartPage:(id)sender {
    [self performSegueWithIdentifier:@"order_to_cart" sender:self];
}

- (IBAction)order_to_wishListPage:(id)sender {
    [self performSegueWithIdentifier:@"order_to_wish" sender:self];
}
#pragma mark filtering place order method paramaters

-(void)filtering_MerchantId{
    
    
    charge_ship = 0;
    if([[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] isKindOfClass:[NSDictionary class]])
    {
        
        NSString *shipChrge,*shipMethod;
        
        NSArray *keys_arr = [[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] allKeys];
        for (int k=0; k<keys_arr.count; k++) {
            
            
            @try {
                shipChrge = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:[keys_arr objectAtIndex:k]] valueForKey:@"charge"]];
                
                charge_ship = charge_ship+[shipChrge intValue];
                
              shipMethod = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:[keys_arr objectAtIndex:k]] valueForKey:@"methodid"]];
            } @catch (NSException *exception) {
            
                shipChrge = @"";
                shipMethod = @"";
                
            }
            NSDictionary *dic = @{@"mer_id":[keys_arr objectAtIndex:k],@"time":@"",@"date":@"",@"ship_chrge":shipChrge,@"ship_method":shipMethod,@"pickMethod":@"0"};
            [date_time_merId_Arr addObject:dic];
            
            
        }
    }
      [_TBL_orders reloadData];
     [self set_data_to_product_Summary_View];
    
    //Product Summary View setting Ship Charge
   // self.LBL_shipping_charge.text = [NSString stringWithFormat:@"%@ %d",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],charge_ship];
    
    NSLog(@"charge for all products %.2f %@",charge_ship,date_time_merId_Arr);
}

#pragma mark order_detail_API_call

-(void)order_detail_API_call
{
    @try {
        
        [Helper_activity animating_images:self];
        date_time_merId_Arr = [NSMutableArray array];
        jsonresponse_dic  = [[NSMutableDictionary alloc]init];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
        
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
       
         NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/orderdetailsapi/%@/%@/%@.json",SERVER_URL,user_id,languge,country];
        NSLog(@"order_detail_API URL::::::%@",urlGetuser);
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                        [Helper_activity stop_activity_animation:self];

                    }
                    if (data) {
                        
                       [Helper_activity stop_activity_animation:self];
                            @try {
                                
                               
                                if ([data isKindOfClass:[NSDictionary class]]) {
                                    jsonresponse_dic = data;
                                    
                                  
                                    NSLog(@"order_detail_API Response:::%@*********",data);
                                    [self filtering_MerchantId];
                                    [self Shipp_address_API];
                                    [self set_UP_VIEW];
                                   // [self next_page];
                                  
                                   
                                    
                                }
                                else{
                                    [HttpClient createaAlertWithMsg:@"The Data could not be read It is not in correct format" andTitle:@""];
                                    
                                }
                                
                            } @catch (NSException *exception) {
                                NSLog(@"%@",exception);
                               
                                
                            }
                        }
                    
                });
                
            }];
        } @catch (NSException *exception) {
             [Helper_activity stop_activity_animation:self];
            NSLog(@"%@",exception);
                  }
        
      
    } @catch (NSException *exception) {
         [Helper_activity stop_activity_animation:self];
        NSLog(@"%@",exception);
       

        
    }
    
}

#pragma mark Shipp_address_API_Call

-(void)Shipp_address_API
{
    @try {
        
        [Helper_activity animating_images:self];
        jsonresponse_dic_address = [[NSMutableDictionary alloc]init];
        
        //isAddClicked = NO;
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
        
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/shipaddressessapi/%@/%@/%@.json",SERVER_URL,user_id,country,languge];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        [Helper_activity stop_activity_animation:self];
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        
                        [Helper_activity stop_activity_animation:self];
                        
                        @try {
                            
                            
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                jsonresponse_dic_address = data;
                                [self radioButton_values];
                                [self set_DATA];
                                [_TBL_address reloadData];
                            }
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        NSLog(@"Shipp_address_API:::%@*********",data);
                    }
                    
                });
                
            }];
        } @catch (NSException *exception) {
            [Helper_activity stop_activity_animation:self];
            NSLog(@"%@",exception);
        }
        
       
    }
    @catch (NSException *exception) {
        [Helper_activity stop_activity_animation:self];

        NSLog(@"%@",exception);
    }
    
}


#pragma mark updating_cart_API
/*
 Update cart
 apis/updatecartapi.json
 Parameters :
 {quantity=1, merchantId=6, customerId=6, subttl=1050.0, productId=10}
 
 Method : POST
 
 
 */

-(void)updating_cart_List_api:(NSString *)sbttl{
    
    
    @try {
        
        [Helper_activity animating_images:self];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *custmr_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
        
       
        
        NSDictionary *parameters = @{@"productId":product_id,@"customerId":custmr_id,@"quantity":item_count,@"merchantId":merchent_id,@"subttl":sbttl};
        
        
        NSLog(@"******************** %@",parameters);
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/updateqtycheckoutapi.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        
        [HttpClient api_with_post_params:urlGetuser andParams:parameters completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [Helper_activity stop_activity_animation:self];
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    NSLog(@"%@",data);
                     [Helper_activity stop_activity_animation:self];
                    @try {
                        if ([[NSString stringWithFormat:@"%@",[data valueForKey:@"success"]] isEqualToString:@"1"]) {
                            [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                            [self order_detail_API_call];
                        }
                        else{
                            [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                        }
                    
                    } @catch (NSException *exception) {
                        NSLog(@"exception:: %@",exception);
                    }
                    
                    
                }
                
            });
            
        }];
    } @catch (NSException *exception) {
        
         [Helper_activity stop_activity_animation:self];
        NSLog(@"%@",exception);
    }
    
}
#pragma mark  cart_count_api

-(void)cart_count{
   
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *str_id = @"user_id";
    NSString *user_id;
    for(int h = 0;h<[[dict allKeys] count];h++)
    {
        if([[[dict allKeys] objectAtIndex:h] isEqualToString:str_id])
        {
            user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:str_id]];
            break;
        }
        else
        {
            
            user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        }
        
    }
    [HttpClient cart_count:user_id completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        if (error) {
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
             ];
            
                   }
        if (data) {
            
         
            NSLog(@"%@",data);
            NSDictionary *dict = data;
            @try {
                NSString *badge_value = [NSString stringWithFormat:@"%@",[dict valueForKey:@"cartcount"]];
                NSString *wishlist = [NSString stringWithFormat:@"%@",[dict valueForKey:@"wishlistcount"]];
                
                
                //NSString *badge_value = @"11";
                if([wishlist intValue] > 0)
                {
                    
                    @try
                    {
                        [_BTN_fav setBadgeEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 4)];
                        [_BTN_fav setBadgeString:[NSString stringWithFormat:@"%@",wishlist]];
                    }
                    @catch(NSException *Exception)
                    {
                        
                    }
                    
                }
                
                if([badge_value intValue] > 0 )
                {
                    @try
                    {
                        
                        [_BTN_cart setBadgeEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 4)];
                    }
                    @catch(NSException *Exception)
                    {
                        
                    }
                    
                    [_BTN_cart setBadgeString:[NSString stringWithFormat:@"%@",badge_value]];
                    
                    
                }
                
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
                
               
            }
            
        }
    }];
}
#pragma mark Delivary_slot_API

-(void)delivary_slot_API{
    
    @try {
        
        
        [Helper_activity animating_images:self];
        delivary_slot_dic = [[NSMutableDictionary alloc]init];
        picker_Arr = [NSMutableArray array];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/deliveryslotapi.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [Helper_activity stop_activity_animation:self];
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    
                    @try {
                        NSLog(@"%@",data);
                       
                        if ([data isKindOfClass:[NSDictionary class]]) {
                            [delivary_slot_dic addEntriesFromDictionary:data];
                            
                        }
                        
                    } @catch (NSException *exception) {
                        
                        
                    }
                    
                  [Helper_activity stop_activity_animation:self];
                }
                
            });
        }];
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
         [Helper_activity stop_activity_animation:self];
    }
//    VW_overlay.hidden = YES;
//    [activityIndicatorView stopAnimating];
}
#pragma mark CountryAPI Call
//http://192.168.0.171/dohasooq/'apis/countriesapi.json
-(void)CountryAPICall{
    @try {
        
         [Helper_activity animating_images:self];
        
        response_countries_dic = [NSMutableDictionary dictionary];
         NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/countriesapi/%@.json",SERVER_URL,country];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                         [Helper_activity stop_activity_animation:self];
                        
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        @try {
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                
                                NSLog(@".............%@",data);
                                
                                [response_countries_dic addEntriesFromDictionary:data];
                                [response_picker_arr removeAllObjects];
                             
                                for (int x=0; x<[[response_countries_dic allKeys] count]; x++) {
                                    NSDictionary *dic = @{@"cntry_id":[[response_countries_dic allKeys] objectAtIndex:x],@"cntry_name":[response_countries_dic valueForKey:[[response_countries_dic allKeys] objectAtIndex:x]]};
                                    
                                    [response_picker_arr addObject:dic];
                                }
                                
                                NSSortDescriptor *sortDescriptor;
                                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cntry_name"
                                                                             ascending:YES];
                                NSArray *sortedArr = [response_picker_arr sortedArrayUsingDescriptors:@[sortDescriptor]];
                                
                                
                                NSMutableArray  *required_format = [NSMutableArray array];
                                for (int l =0; l<sortedArr.count; l++) {
                                    
                                    if ([[[sortedArr objectAtIndex:l] valueForKey:@"cntry_name"] isEqualToString:@"Qatar"] ) {
                                        
                                        [required_format addObject:[sortedArr objectAtIndex:l]];
                                        
                                    }
                                    
                                }
                                for (int l =0; l<sortedArr.count; l++) {
                                    
                                    if ([[[sortedArr objectAtIndex:l] valueForKey:@"cntry_name"] isEqualToString:@"India"]) {
                                        
                                        [required_format addObject:[sortedArr objectAtIndex:l]];
                                        
                                    }
                                    
                                }
                                
                                for (int m =0; m<sortedArr.count; m++) {
                                    
                                    if (![[[sortedArr objectAtIndex:m] valueForKey:@"cntry_name"] isEqualToString:@"Qatar"] && ![[[sortedArr objectAtIndex:m] valueForKey:@"cntry_name"] isEqualToString:@"India"]) {
                                        
                                        [required_format addObject:[sortedArr objectAtIndex:m]];
                                        
                                    }
                                    
                                }
                                
                                                               
                                NSLog(@"sortedArr %@",sortedArr);
                                [response_picker_arr removeAllObjects];
                                if (!select_blng_ctry_state) {
                                    
                                    @try {
                                        [response_picker_arr addObject:[required_format objectAtIndex:0]];
                                    } @catch (NSException *exception) {
                                        NSLog(@"No Countries");
                                    }
                                }
                                
                                else{
                                    @try {
                                     [response_picker_arr addObjectsFromArray:required_format];
                                    } @catch (NSException *exception) {
                                        NSLog(@"No Countries");
                                    }
                                    
                            
                                }
                                [_staes_country_pickr reloadAllComponents];
                                
                                [self.staes_country_pickr reloadAllComponents];
                                NSLog(@"%@",response_picker_arr);
                            }
                            else{
                                [HttpClient createaAlertWithMsg:@"The Data could not be read" andTitle:@""];
                            }
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        
                    }
                     [Helper_activity stop_activity_animation:self];
                    
                });
                
            }];
        } @catch (NSException *exception) {
             [Helper_activity stop_activity_animation:self];
            NSLog(@"%@",exception);
        }
        
    } @catch (NSException *exception) {
         [Helper_activity stop_activity_animation:self];
        NSLog(@"%@",exception);
    }
   
    
}



#pragma mark StateAPI Call

//http://192.168.0.171/dohasooq/'apis/getstatebyconapi/countryid.json
-(void)stateApiCall{
    
    @try {
        
        
        arr_states = [NSMutableArray array];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/getstatebyconapi/%ld.json",SERVER_URL,(long)cntry_ID];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [Helper_activity animating_images:self];
            
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                        [Helper_activity stop_activity_animation:self];
                    }
                    if (data) {
                        [Helper_activity stop_activity_animation:self];
                        @try {
                            if ([data isKindOfClass:[NSArray class]]) {
                                [arr_states addObjectsFromArray:data];
                                [response_picker_arr removeAllObjects];
                                
                                [response_picker_arr addObjectsFromArray:arr_states];
                                
                                [_staes_country_pickr reloadAllComponents];
                                
                            }
                            else{
                                [HttpClient createaAlertWithMsg:@"The Data could not be read" andTitle:@""];
                            }
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        
                    }
                    
                });
                
            }];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
            [Helper_activity stop_activity_animation:self];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
         [Helper_activity stop_activity_animation:self];
        
    }
   
    
}




#pragma mark UIPickerViewDelegate and UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (pickerView == _staes_country_pickr) {
        return response_picker_arr.count;
    }
    else if (pickerView == _country_code_Pickerview){
        return phone_code_arr.count;
    }
    else{
        return picker_Arr.count;
    }
    
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView == _staes_country_pickr) {
        
        if (isCountrySelected) {
            return [[response_picker_arr objectAtIndex:row] valueForKey:@"cntry_name"];
        }
        else{
            
            return [[response_picker_arr objectAtIndex:row] valueForKey:@"value"];
        }
    }
    else if (pickerView ==_country_code_Pickerview){
       
        @try {
              return [NSString stringWithFormat:@"%@   %@",[phone_code_arr[row] valueForKey:@"name"],[phone_code_arr[row] valueForKey:@"code"]];
            
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
        
        }
    else{
          if (is_Txt_date) {
        return [[picker_Arr objectAtIndex:row] valueForKey:@"key2"];
          }
          else{
              return  [[picker_Arr objectAtIndex:row] valueForKey:@"time"];
          }
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerView == _country_code_Pickerview) {
        
        flag = [NSString stringWithFormat:@"%@ ",[phone_code_arr[row] valueForKey:@"code"]];
    }
    
    if (pickerView == _pickerView) {
        
        @try {
            if (is_Txt_date) {
                _TXT_Date.text = [[picker_Arr objectAtIndex:row] valueForKey:@"key2"];
                date_str = [NSString stringWithFormat:@"%@",[[picker_Arr objectAtIndex:row] valueForKey:@"key3"]];
                _TXT_Time.text = nil;
                _TXT_Time.placeholder = @"Select Time";
                
            }
            else{
                _TXT_Time.text = [[picker_Arr objectAtIndex:row] valueForKey:@"time"];
                time_str = [NSString stringWithFormat:@"%@",[[picker_Arr objectAtIndex:row] valueForKey:@"id"]];
                
            }
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }     }
    if (pickerView == _staes_country_pickr) {
        
        if (isCountrySelected) {
            @try {
                
                cntry_selection = [[response_picker_arr objectAtIndex:row] valueForKey:@"cntry_name"];
                    cntry_ID = [[[response_picker_arr objectAtIndex:row] valueForKey:@"cntry_id"] integerValue];
                state_selection = @"";
                
                if (select_blng_ctry_state) {
                    _TXT_state.text = nil;
                    blng_cntry_ID = [[response_picker_arr objectAtIndex:row] valueForKey:@"cntry_id"];
                }
                else{
                    ship_cntry_ID = [[response_picker_arr objectAtIndex:row] valueForKey:@"cntry_id"];
                    _TXT_ship_state.text = nil;
                }
                
                
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
        else{
            @try {
                state_selection = [[response_picker_arr objectAtIndex:row] valueForKey:@"value"];
                
                if (select_blng_ctry_state) {
                    blng_state_ID = [[response_picker_arr objectAtIndex:row] valueForKey:@"key"];
                }
                else{
                    ship_state_ID = [[response_picker_arr objectAtIndex:row] valueForKey:@"key"];
                }
                
            } @catch (NSException *exception) {
                state_selection = @"";
            }
            
        }
    }
    
}
#pragma mark picker_done_btn_action
-(void)picker_done_btn_action:(id)sender{
    
    [self.view endEditing:YES];
    
    //[textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}
#pragma mark picker_close_action
-(void)picker_close_action{
    [self.view endEditing:YES];
}



#pragma mark Payment method API Types

-(void)payment_methods_API{
    
    @try {
        
        
        [Helper_activity animating_images:self];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/paymentmethapi.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        [Helper_activity stop_activity_animation:self];
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        [Helper_activity stop_activity_animation:self];
                        @try {
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                NSLog(@"Payment Methods %@",data);
                                
                         // Checking Cash on Delivary is Available or Not
//                                _BTN_cod.hidden = YES;
//                                _LBL_cash_on_Delivary.hidden = YES;
                                
                                //                                        isCash_on_delivary = YES;
                                
//                                NSArray *keys = [data allKeys];
//                                for (int kl = 0; kl < [keys count]; kl ++) {
//                                    NSString *KY = [NSString stringWithFormat:@"%d",kl];
//                                    NSString *STR_check = [data valueForKey:KY];
//                                    if ([STR_check isEqualToString:@"Cash On Delivery"]) {
//
//                                        _BTN_cod.hidden = NO;
//                                        _LBL_cash_on_Delivary.hidden = NO;
//                                        kl = (int)[keys count];
//                                    }
//                                }
//                                for (NSString *key in data) {
//                                    id value = data[key];
//                                    NSLog(@"Value: %@ for key: %@", value, key);
//                                    if ([value isEqualToString:@"Cash On Delivery"]) {
//                                        _BTN_cod.hidden = NO;
//                                        _LBL_cash_on_Delivary.hidden = NO;
//                                    }
//                                }
                              //////////////
                               if (isCash_on_delivary) {
                                    _BTN_cod.hidden = NO;
                                    _LBL_cash_on_Delivary.hidden = NO;
                                    
                                }
                                else{
                                    _BTN_cod.hidden = YES;
                                     _LBL_cash_on_Delivary.hidden = YES;
                                }
                               
                            }
                            else{
                                [HttpClient createaAlertWithMsg:@"The Data could not be read" andTitle:@""];
                            }
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        
                    }
                    
                });
                
            }];
        } @catch (NSException *exception) {
            [Helper_activity stop_activity_animation:self];
            NSLog(@"%@",exception);
        }
        
    } @catch (NSException *exception) {
        [Helper_activity stop_activity_animation:self];
        NSLog(@"%@",exception);
    }
    
}

#pragma mark Apply apply_promo_Code  API
/*Applycoupon
 Function Name : apis/applycouponapi.json
 Parameters :customerId,couponcode,subtotal
 Method : GET*/
-(void)apply_promo_Code{
    
    
    @try {
        
        
        [Helper_activity animating_images:self];
        NSString *sub_total = [NSString stringWithFormat:@"%@",[jsonresponse_dic valueForKey:@"subsum"]];
        sub_total = [sub_total stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
        
        NSString *prome_value = [NSString stringWithFormat:@"%@",self.TXT_cupon.text];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/applycouponapi/%@/%@/%@.json",SERVER_URL, [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"],prome_value,sub_total];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        [Helper_activity stop_activity_animation:self];
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        [Helper_activity stop_activity_animation:self];
                        @try {
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                
//                                if ([[data valueForKey:@"success"] isEqualToString:@"0"]) {
//                                    
//                                    [self.TXT_cupon becomeFirstResponder];
//                                    
//                                 }
//                                else{
                                   [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                               // }
                                
                               
                            }
                            else{
                                [HttpClient createaAlertWithMsg:@"The Data could not be read" andTitle:@""];
                            }
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        
                    }
                    
                });
                
            }];
        } @catch (NSException *exception) {
            [Helper_activity stop_activity_animation:self];
            NSLog(@"%@",exception);
        }
       
    } @catch (NSException *exception) {
        [Helper_activity stop_activity_animation:self];
        NSLog(@"%@",exception);
    }
   
    
}

#pragma mark validatingTextField

-(void)validatingTextField
{
   
   
    [Helper_activity animating_images:self];
     NSString *msg;
  
       if ([_TXT_fname.text isEqualToString:@""])
       {
           [_TXT_fname becomeFirstResponder];
           msg = @"Please Enter First Name field";
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"يرجى تعبئة حقل الاسم الأول";
           }
           
       }
       else if(_TXT_fname.text.length < 3 )
       {
           [_TXT_fname becomeFirstResponder];
           msg = @"First Name should not be less than 3 characters";
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"يجب ألا يقل الاسم الأول عن 3 حروف";
           }
           
       }
       else if(_TXT_fname.text.length >30)
       {
           [_TXT_fname becomeFirstResponder];
           msg = @"First name should not be more than 30 characters";
           
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"يجب ألا يزيد الاسم الأول عن 30 حرفاً";
           }
           
       }
       else if ([_TXT_lname.text isEqualToString:@""])
       {
           [_TXT_lname becomeFirstResponder];
           msg = @"Please Enter Last Name field";
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"يرجى تعبئة حقل الاسم الأخير ";
           }

           
       }
       else if(_TXT_lname.text.length < 3)
       {
           [_TXT_lname becomeFirstResponder];
           msg = @"Last Name should not be less than 3 character";
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"الكنية ألا يقل الاسم الأول عن 3 حروف";
           }
           
           
       }
       else if(_TXT_lname.text.length >30)
       {
           [_TXT_lname becomeFirstResponder];
           msg = @"Last name should not be more than 30 characters";
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"ألا يزيد اسم العائلة عن 30 حرفا";
           }
           
           
       }
     /*  else if(_TXT_addr1.text.length < 3)
       {
           [_TXT_addr1 becomeFirstResponder];
           msg = @"Address1 should not be less than 10 characters";
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"يجب1 ألا يقل العنوان عن 10 رموز";
           }
           
       }*/
       else if([_TXT_addr1.text isEqualToString:@""])
       {
           [_TXT_addr1 becomeFirstResponder];
           msg = @"Address1 Should Not be Empty";
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"يجب  1 عدم ترك حقل العنوان فارغا";
           }

       }
       else if(_TXT_addr1.text.length > 200)
       {
           [_TXT_addr1 becomeFirstResponder];
           msg = @"Address should not be more than 200 characters";
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"يجب ألا يزيد العنوان عن 200 رمز";
           }
           
           
       }

//       else if(_TXT_addr2.text.length < 1)
//       {
//           [_TXT_addr2 becomeFirstResponder];
//           msg = @"Address name should not be less than 1 character";
//           
//           
//       }
//       else if(_TXT_addr2.text.length > 256)
//       {
//           [_TXT_addr2 becomeFirstResponder];
//           msg = @"Address name should not be greater than 256 character";
//           
//           
//       }
//       else if([_TXT_addr2.text isEqualToString:@" "])
//       {
//           [_TXT_addr2 becomeFirstResponder];
//           msg = @"Blank space are not allowed";
//       }
       


    else if ([_TXT_phone.text isEqualToString:@""])
       {
           [_TXT_phone becomeFirstResponder];
           msg = @"Please Enter Phone Number";
           
           
           
       }
       
       else if (_TXT_phone.text.length < 5)
       {
           [_TXT_phone becomeFirstResponder];
           msg = @"Phone Number cannot be less than 5 digits";
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"لا يجب ألا يقلّ رقم الجوال عن 5 أرقام ";
           }
           
           
       }
       else if(_TXT_phone.text.length>8)
       {
           [_TXT_phone becomeFirstResponder];
           msg = @"Phone Number should not be more than 8 characters";
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"يجب أن لا يتجاوز رقم الجوال 8 رقماً";
           }
           
       }
       else if([_TXT_phone.text isEqualToString:@""])
       {
           [_TXT_phone becomeFirstResponder];
           msg = @"Phone Number  Should Not be Empty";
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"رقم الهاتف ترك حقل المدينة فارغاً";
           }
           
           
       }
       else if ([_TXT_Cntry_code.text isEqualToString:@""])
       {
           [_TXT_Cntry_code becomeFirstResponder];
           msg = @"Country Code and Phone Number is required";
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"رمز البلد ورقم الهاتف مطلوبين";
           }


       }
    
       else if([_TXT_city.text isEqualToString:@""])
       {
           [_TXT_city becomeFirstResponder];
           msg = @"City Should Not be Empty";
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"يجب عدم ترك حقل المدينة فارغاً";
           }
           
           
       }
       else if (_TXT_city.text.length < 3)
       {
           [_TXT_city becomeFirstResponder];
           msg = @"City should not be less than 3 characters";
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"يجب ألا يقل حقل المدينة عن 3 أحرف";
           }
           
       }
       else if (_TXT_city.text.length > 30)
       {
           [_TXT_city becomeFirstResponder];
           msg = @"City should not be more than 30 characters";
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"يجب ألا يزيد حقل المدينة عن 30 حرفاً";
           }
           
       }
       else if([_TXT_state.text isEqualToString:@""])
       {
           [_TXT_state becomeFirstResponder];
           msg = @"Please Select State";//يرجى تحديد البلد
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"يرجى تحديد الدولة";
           }
 
       }
    
       else if([_TXT_country.text isEqualToString:@""])
       {
           [_TXT_country becomeFirstResponder];
           msg = @"Please Select Country";
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
           {
               msg = @"يرجى تحديد البلد";
           }
           
       }
//    if (![blng_cntry_ID isEqualToString:@"173"]) {
//        [HttpClient createaAlertWithMsg:@"Sorry We Cannott ship Products out side of Qatar,Please Enter Diffirent Shipping Address to Proceed" andTitle:@""];
//    }

       else if(![blng_cntry_ID isEqualToString:@"173"])
       {
           [_TXT_country becomeFirstResponder];
           msg = @"Sorry we cannot ship products out side Qatar, Please enter different shipping address to proceed";
           
           
       }
//       else if (_TXT_zip.text.length < 1)
//       {
//           [_TXT_zip becomeFirstResponder];
//          msg = @"Blank Space are Not Allowed";       }
    
  
      if(  _VW_SHIIPING_ADDRESS.hidden == NO)
    {
       
        
        if ([_TXT_ship_fname.text isEqualToString:@""])
        {
            [_TXT_ship_fname becomeFirstResponder];
            msg = @"Please Enter First Name field";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يرجى تعبئة حقل الاسم الأول";
            }
            
        }
        else if(_TXT_ship_fname.text.length < 3)
        {
            [_TXT_ship_fname becomeFirstResponder];
            msg = @"First Name should not be less than 3 characters";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب ألا يقل الاسم الأول عن 3 حروف";
            }
            
        }
        else if(_TXT_ship_fname.text.length > 30)
        {
            [_TXT_ship_fname becomeFirstResponder];
            msg = @"First name should not be more than 30 characters";
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب ألا يزيد الاسم الأول عن 30 حرفاً";
            }
            
        }
        else if ([_TXT_ship_lname.text isEqualToString:@""])
        {
            [_TXT_ship_lname becomeFirstResponder];
            msg = @"Please Enter Last Name field";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يرجى تعبئة حقل الاسم الأخير ";
            }
        }
        else if(_TXT_ship_lname.text.length < 3)
        {
            [_TXT_ship_lname becomeFirstResponder];
            msg = @"Last name should not be less than 3 characters";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"الكنية ألا يقل الاسم الأول عن 3 حروف";
            }
        }
        else if(_TXT_ship_lname.text.length>30)
        {
            [_TXT_ship_lname becomeFirstResponder];
            msg = @"Last name should not be more than 30 characters";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"ألا يزيد اسم العائلة عن 30 حرفا";
            }
            
            
        }
        else if(_TXT_ship_addr1.text.length < 3)
        {
            [_TXT_ship_addr1 becomeFirstResponder];
            msg = @"Address1 should not be less than 3characters";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب1 ألا يقل العنوان عن 10 رموز";
            }
            
        }
        else if([_TXT_ship_addr1.text isEqualToString:@""])
        {
            [_TXT_ship_addr1 becomeFirstResponder];
            msg = @"Address1 Should Not be Empty";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب  1 عدم ترك حقل العنوان فارغا";
            }
        }
        else if(_TXT_ship_addr1.text.length > 200)
        {
            [_TXT_ship_addr1 becomeFirstResponder];
            msg = @"Address should not be more than 200 characters";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب ألا يزيد العنوان عن 200 رمز";
            }
            
        }
        
//        else if(_TXT_ship_addr2.text.length < 1)
//        {
//            [_TXT_ship_addr2 becomeFirstResponder];
//            msg = @"Address2 should not be less than 1 character";
//            
//            
//        }
//        else if(_TXT_ship_addr2.text.length > 256)
//        {
//            [_TXT_ship_addr2 becomeFirstResponder];
//            msg = @"Address2 should not be greater than 256 character";
//            
//            
//        }
//        else if([_TXT_ship_addr2.text isEqualToString:@""])
//        {
//            [_TXT_ship_addr2 becomeFirstResponder];
//            msg = @"Blank Space are Not Allowed";
//        }
        
        
        
       
        else if ([_TXT_ship_phone.text isEqualToString:@""])
        {
            [_TXT_ship_phone becomeFirstResponder];
            msg = @"Phone Number  Should Not be Empty";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"رقم الهاتف ترك حقل المدينة فارغاً";
            }
        }
        
        else if (_TXT_ship_phone.text.length < 5)
        {
            [_TXT_ship_phone becomeFirstResponder];
            msg = @"Phone Number cannot be less than 5 digits";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"لا يجب ألا يقلّ رقم الجوال عن 5 أرقام ";
            }
            
            
            
        }
        else if(_TXT_ship_phone.text.length>8)
        {
            [_TXT_ship_phone becomeFirstResponder];
            msg = @"Phone Number cannot be more than 8 digits";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب أن لا يتجاوز رقم الجوال 8 رقماً";
            }
           
        }
      
        else if ([_TXT_ship_cntry_code.text isEqualToString:@""])
        {
            [_TXT_ship_cntry_code becomeFirstResponder];
            msg = @"Country Code and Phone Number is required";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"رمز البلد ورقم الهاتف مطلوبين";
            }

        
        }
        else if([_TXT_ship_city.text isEqualToString:@""])
        {
            [_TXT_ship_city becomeFirstResponder];
            msg = @"City Should Not be Empty";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب عدم ترك حقل المدينة فارغاً";
            }
            
        }
        else if (_TXT_ship_city.text.length < 3)
        {
            [_TXT_ship_city becomeFirstResponder];
            msg = @"City should not be less than 3 characters";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب ألا يقل حقل المدينة عن 3 أحرف";
            }
            
        }
        else if (_TXT_ship_city.text.length > 30)
        {
            [_TXT_ship_city becomeFirstResponder];
            msg = @"City should not be more than 30 characters";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب ألا يزيد حقل المدينة عن 30 حرفاً";
            }
            
        }
        else if([_TXT_ship_state.text isEqualToString:@""])
        {
            [_TXT_ship_state becomeFirstResponder];
            msg = @"Please Select State";//يرجى تحديد البلد
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يرجى تحديد الدولة";
            }
            
            
        }
        else if([_TXT_ship_country.text isEqualToString:@""])
        {
            [_TXT_ship_country becomeFirstResponder];
            msg = @"Please Select Country";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يرجى تحديد البلد";
            }
            
            
        }
        else if(![_TXT_ship_country.text isEqualToString:@"Qatar"])
        {
            [_TXT_ship_country becomeFirstResponder];
            msg = @"Sorry We cannot ship products Outside of Qatar ";
            
            
        }
//        else if (_TXT_ship_zip.text.length < 1)
//        {
//            [_TXT_ship_zip becomeFirstResponder];
//           msg = @"Blank Space are Not Allowed";        }

            }
    if(msg)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        //[alert show];
        [HttpClient createaAlertWithMsg:msg andTitle:@""];
        
    }
    

    else{
           _VW_pay_cards.hidden = NO;
         _Scroll_card.hidden = NO;
          [self move_to_payment_types];
        
        
        // checking billing a nd shippindg address are valid or not
        
//        if (self.VW_SHIIPING_ADDRESS.hidden == NO ) {
//           
//        [self checking_address:_TXT_zip.text];
//            
//      
//            
//        }
//        else{
//            
//         [self checking_address:_TXT_zip.text];
//        
//        }
     
        
        }
//    VW_overlay.hidden = YES;
//    [activityIndicatorView stopAnimating];
    [Helper_activity stop_activity_animation:self];

}

#pragma mark radioButton Actions
// Payment Type Radio Buttons Setting
-(void)credit_cerd_action
{
    
    if(_BTN_credit.tag == 1)
    {
         payment_type_str = @"1";
        [_BTN_credit setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_cod setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_credit.tag = 0;
        
    }
    else
    {
         payment_type_str = @"0";
        [_BTN_credit setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_credit.tag = 1;
        _BTN_debit_card.tag = 1;
        _BTN_doha_bank_account.tag = 1;
        _BTN_doha_miles.tag = 1;
        _BTN_cod.tag = 1;
        
    }

    
}
-(void)debit_card_action
{
    
    
    if(_BTN_debit_card.tag == 1)
    {
        payment_type_str = @"2";
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_credit setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_cod setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_debit_card.tag = 0;
        
    }
    else
    {
         payment_type_str = @"0";
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_debit_card.tag = 1;
        _BTN_credit.tag = 1;
        _BTN_doha_bank_account.tag = 1;
        _BTN_doha_miles.tag = 1;
        _BTN_cod.tag = 1;
        
    }

    
}
-(void)doha_bank_action
{
    
    
    payment_type_str = @"3";
    if(_BTN_doha_bank_account.tag == 1)
    {
          payment_type_str = @"3";
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_credit setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_cod setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_doha_bank_account.tag = 0;
        
    }
    else
    {
         payment_type_str = @"0";
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_doha_bank_account.tag = 1;
        _BTN_debit_card.tag = 1;
        _BTN_credit.tag = 1;
        _BTN_doha_miles.tag = 1;
        _BTN_cod.tag = 1;
        
        
        
    }
 
}

-(void)doha_miles_action
{
    
    
   
    if(_BTN_doha_miles.tag == 1)
    {
         payment_type_str = @"4";
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_credit setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_cod setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_doha_miles.tag = 0;
        
    }
    else
    {
         payment_type_str = @"0";
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        _BTN_doha_miles.tag = 1;
        _BTN_doha_bank_account.tag = 1;
        _BTN_debit_card.tag = 1;
        _BTN_credit.tag = 1;
        _BTN_cod.tag = 1;
        
    }

}
-(void)cod_action
{
    if(_BTN_cod.tag == 1)
    {
        payment_type_str = @"5";
        [_BTN_cod setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_credit setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        _BTN_cod.tag = 0;
        
    }
    else
    {
        payment_type_str = @"0";

        [_BTN_cod setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        _BTN_cod.tag = 1;
        _BTN_doha_miles.tag = 1;
        _BTN_doha_bank_account.tag = 1;
        _BTN_debit_card.tag = 1;
        _BTN_credit.tag = 1;
        
    }

}

#pragma mark Place Order API Grouping Parameters for Integration

-(void)place_oredr_API{
    @try {
        
        
        
        //Special Instruction
        
        NSString *SpecialInstruction = _TXT_instructions.text;
        if ([SpecialInstruction isEqualToString:@""]) {
            SpecialInstruction = @"";
        }
        
        NSString *ctry_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *lan_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        
        //language_id
        
        
        NSString *sub_total = [NSString stringWithFormat:@"%.2f",total];
        
        sub_total = [sub_total stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
        
        NSDictionary *Formpaymenthidden;
        @try {
            
            Formpaymenthidden = @{@"amount":sub_total,@"locale":@"en",@"version":@"1"};
            
        } @catch (NSException *exception) {
            
        }
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:Formpaymenthidden options:NSJSONWritingPrettyPrinted error:nil];
        NSString *Formpaymenthidden_str = [[NSString alloc] initWithData:data
                                                                encoding:NSUTF8StringEncoding];
        
        
        //        NSDictionary *params = @{@"b_user_firstname":@"",@"b_user_lastname":@"",@"b_user_address1":@"",@"b_user_address2":@"",@"b_user_city":@"",@"b_user_zip_code":@"",@"b_user_phone":@"",@"b_user_country":@"",@"b_user_state":@""};
        
        /*Formshipping = {
         "FirstName1": "Venu",
         "LastName1": "Reddy",
         "address11": "Doha",
         "address12": "",
         "city1": "Doha",
         "state": "15",
         "country": "1",
         "phone1": "9742803092",
         "zipcode1": "34567"
         }*/
        
        NSString *fname,*lname,*addr1,*addr2,*city,*state,*zip_code,*country,*phone,*str_code;
        
        fname =_TXT_fname.text;
        lname = _TXT_lname.text;
        addr1 =_TXT_addr1.text;
        addr2 = _TXT_addr2.text;
        city =_TXT_city.text;
        state = blng_state_ID;
        zip_code = _TXT_zip.text;
        country = blng_cntry_ID;
        phone = _TXT_phone.text;
        str_code = _TXT_Cntry_code.text;
        
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *str_id = @"user_id";
        NSString *user_id;
        for(int h = 0;h<[[dict allKeys] count];h++)
        {
            if([[[dict allKeys] objectAtIndex:h] isEqualToString:str_id])
            {
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:str_id]];
                break;
            }
            else
            {
                
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
            }
            
        }
        
        
        
        NSDictionary *FormBilling;
        @try {
            FormBilling = @{@"FirstName":fname,@"LastName":lname,@"address1":addr1,@"address2":addr2,@"city":city,@"state":state,@"country":country,@"phone":phone,@"phonecode":str_code,@"zipcode":zip_code,@"userId":user_id};
        } @catch (NSException *exception) {
            
        }
        
        
        data = [NSJSONSerialization dataWithJSONObject:FormBilling options:NSJSONWritingPrettyPrinted error:nil];
        NSString *form_billing_str = [[NSString alloc] initWithData:data
                                                           encoding:NSUTF8StringEncoding];
        
        
        NSString *sfname,*slname,*saddr1,*saddr2,*scity,*sstate,*szip_code,*scountry,*sphone,*str_ph_code;
        
        sfname =_TXT_ship_fname.text;
        slname = _TXT_ship_lname.text;
        saddr1 =_TXT_ship_addr1.text;
        saddr2 = _TXT_ship_addr2.text;
        scity =_TXT_ship_city.text;
        sstate = ship_state_ID;
        szip_code = _TXT_zip.text;
        scountry = ship_cntry_ID;
        sphone = _TXT_ship_phone.text;
        str_ph_code = _TXT_ship_cntry_code.text;
        
        NSDictionary *Formshipping;
        if ([billcheck_clicked isEqualToString:@"0"]) {
            
            
            @try {
                
                Formshipping = @{@"FirstName1":fname,@"LastName1":lname,@"address11":addr1,@"address12":addr2,@"city1":city,@"state":state,@"country":country,@"phone1":phone,@"zipcode1":zip_code,@"phonecode":str_code,@"newaddressinput":newaddressinput};
            } @catch (NSException *exception) {
                
            }
            
        }
        else{
            
            @try {
                Formshipping = @{@"FirstName1":sfname,@"LastName1":slname,@"address11":saddr1,@"address12":saddr2,@"city1":scity,@"state":sstate,@"country":scountry,@"phone1":sphone,@"zipcode1":szip_code,@"phonecode":str_ph_code,@"newaddressinput":newaddressinput};
            } @catch (NSException *exception) {
                
            }
            
            
            
        }
        
        
        data = [NSJSONSerialization dataWithJSONObject:Formshipping options:NSJSONWritingPrettyPrinted error:nil];
        NSString *form_shipping_str = [[NSString alloc] initWithData:data
                                                            encoding:NSUTF8StringEncoding];
        
        
        
        
        // NSLog(@"THe single string:Form shipping%@",[form_arr componentsJoinedByString:@","]);
        
        
        
        
        /* FormBilling = {
         "FirstName": "Venu",
         "LastName": "Reddy",
         "address1": "Doha",
         "address2": "",
         "city": "Doha",
         "state": "15",
         "country": "1",
         "phone": "9742803092",
         "zipcode": "34567",
         "userId": "17"
         },
         */
        
        
        // Ship charge , ship method ,time and Date
        NSString *shiip_charge,*ship_method,*deliveydate,*deliveytime,*pickMethod;
        
        
        @try {
            
            if (date_time_merId_Arr.count != 0) {
                if ([[date_time_merId_Arr objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
                    //NSArray *param_keys = [[date_time_merId_Arr objectAtIndex:0] allKeys];
                    
                    NSMutableArray *chrg_array = [NSMutableArray array];
                    NSMutableArray *ship_array = [NSMutableArray array];
                    NSMutableArray *deliveydate_arr = [NSMutableArray array];
                    NSMutableArray *deliveytime_arr = [NSMutableArray array];
                    NSMutableArray *pickMethod_arr = [NSMutableArray array];
                    
                    for (int b= 0; b<date_time_merId_Arr.count; b++) {
                        
                        
                        NSString *str = [NSString stringWithFormat:@"%@",[[date_time_merId_Arr objectAtIndex:b] valueForKey:@"ship_chrge"]];
                        
                        str = [str stringByReplacingOccurrencesOfString:@"<nil>" withString:@" "];
                        str = [str stringByReplacingOccurrencesOfString:@"(null)" withString:@" "];
                        
                        
                        NSString *method = [NSString stringWithFormat:@"%@",[[date_time_merId_Arr objectAtIndex:b] valueForKey:@"ship_method"]];
                        
                        method = [method stringByReplacingOccurrencesOfString:@"<nil>" withString:@" "];
                        method = [method stringByReplacingOccurrencesOfString:@"(null)" withString:@" "];
                        
                        NSString *date = [NSString stringWithFormat:@"%@",[[date_time_merId_Arr objectAtIndex:b] valueForKey:@"date"]];
                        date =[date stringByReplacingOccurrencesOfString:@"<nil>" withString:@" "];
                        date = [date stringByReplacingOccurrencesOfString:@"(null)" withString:@" "];
                        
                        
                        
                        NSString *time = [NSString stringWithFormat:@"%@",[[date_time_merId_Arr objectAtIndex:b] valueForKey:@"time"]];
                        time = [time stringByReplacingOccurrencesOfString:@"<nil>" withString:@" "];
                        time = [time stringByReplacingOccurrencesOfString:@"(null)" withString:@" "];
                        
                        
                        NSString *pic_meth = [NSString stringWithFormat:@"%@",[[date_time_merId_Arr objectAtIndex:b] valueForKey:@"pickMethod"]];
                        pic_meth = [pic_meth stringByReplacingOccurrencesOfString:@"<nil>" withString:@" "];
                        pic_meth = [pic_meth stringByReplacingOccurrencesOfString:@"(null)" withString:@" "];
                        
                        [pickMethod_arr addObject:pic_meth];
                        [deliveydate_arr addObject:date];
                        [deliveytime_arr addObject:time];
                        [chrg_array addObject:str];
                        [ship_array addObject:method];
                        
                        NSLog(@" ::::: %@ :::::%@ ",str,method);
                        
                    }
                    shiip_charge = [chrg_array componentsJoinedByString:@","];
                    ship_method = [ship_array componentsJoinedByString:@","];
                    deliveydate = [deliveydate_arr componentsJoinedByString:@","];
                    deliveytime = [deliveydate_arr componentsJoinedByString:@","];
                    pickMethod = [pickMethod_arr componentsJoinedByString:@","];
                    
                    
                    shiip_charge = [shiip_charge stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                    shiip_charge = [shiip_charge stringByReplacingOccurrencesOfString:@"<nil>" withString:@""];
                    
                    ship_method = [ship_method stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                    ship_method = [ship_method stringByReplacingOccurrencesOfString:@"<nil>" withString:@""];
                    
                    deliveydate = [deliveydate stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                    deliveydate = [deliveydate stringByReplacingOccurrencesOfString:@"<nil>" withString:@""];
                    
                    pickMethod = [pickMethod stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                    pickMethod = [pickMethod stringByReplacingOccurrencesOfString:@"<nil>" withString:@""];
                    
                    
                    
                    NSLog(@"%@",deliveytime);
                    
                    
                }
            }
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        NSDictionary *FormpickupMethod = @{@"pickMethod":pickMethod};
        
        data = [NSJSONSerialization dataWithJSONObject:FormpickupMethod options:NSJSONWritingPrettyPrinted error:nil];
        NSString *FormpickupMethod_str = [[NSString alloc] initWithData:data
                                                               encoding:NSUTF8StringEncoding];
        
        
        
        
        NSDictionary *FormPayment = @{@"paymenttype":payment_type_str};
        data = [NSJSONSerialization dataWithJSONObject:FormPayment options:NSJSONWritingPrettyPrinted error:nil];
        NSString *FormPayment_str = [[NSString alloc] initWithData:data
                                                          encoding:NSUTF8StringEncoding];
        
        
        
        NSDictionary  *FormshipMethod = @{@"charge":shiip_charge,@"shipmethod":ship_method};
        
        data = [NSJSONSerialization dataWithJSONObject:FormshipMethod options:NSJSONWritingPrettyPrinted error:nil];
        NSString *FormshipMethod_str = [[NSString alloc] initWithData:data
                                                             encoding:NSUTF8StringEncoding];
        
        
        
        
        NSDictionary *FormDeliverySlot = @{@"deliveydate":deliveydate,@"deliveytime":deliveytime};
        data = [NSJSONSerialization dataWithJSONObject:FormDeliverySlot options:NSJSONWritingPrettyPrinted error:nil];
        NSString *FormDeliverySlot_str = [[NSString alloc] initWithData:data
                                                               encoding:NSUTF8StringEncoding];
        
        
        
        NSDictionary *FormSameasBilling = @{@"check":billcheck_clicked};
        data = [NSJSONSerialization dataWithJSONObject:FormSameasBilling options:NSJSONWritingPrettyPrinted error:nil];
        NSString *FormSameasBilling_str = [[NSString alloc] initWithData:data
                                                                encoding:NSUTF8StringEncoding];
        
        
        NSDictionary *Formcouponcode = @{@"couponcode":@""};
        data = [NSJSONSerialization dataWithJSONObject:Formcouponcode options:NSJSONWritingPrettyPrinted error:nil];
        NSString *Formcouponcode_str = [[NSString alloc] initWithData:data
                                                             encoding:NSUTF8StringEncoding];
        
        
        
        
        //[shippinglatlog_dic removeAllObjects];
        
        //data = [NSJSONSerialization dataWithJSONObject:shippinglatlog_dic options:NSJSONWritingPrettyPrinted error:nil];
        //        NSString *shippinglatlog_str = [[NSString alloc] initWithData:data
        //                                                             encoding:NSUTF8StringEncoding];
        NSString *shippinglatlog_str = [NSString stringWithFormat:@"{}"];
        
        
        
        //        [billiinglatlog_dic removeAllObjects];
        //
        //        data = [NSJSONSerialization dataWithJSONObject:billiinglatlog_dic options:NSJSONWritingPrettyPrinted error:nil];
        //        NSString *billiinglatlog_str = [[NSString alloc] initWithData:data
        //                                                             encoding:NSUTF8StringEncoding];
        NSString *billiinglatlog_str = [NSString stringWithFormat:@"{}"];
        
        NSDictionary *params;
        
        @try {
            
            
            
            params = @{@"countryId":ctry_id,@"lanId":lan_id,@"Formpaymenthidden":Formpaymenthidden_str,@"FormpickupMethod":FormpickupMethod_str,@"FormPayment":FormPayment_str,@"Formshipping":form_shipping_str,@"FormshipMethod":FormshipMethod_str,@"FormBilling":form_billing_str,@"billinglatlog":billiinglatlog_str,@"FormDeliverySlot":FormDeliverySlot_str,@"FormSameasBilling":FormSameasBilling_str,@"shippinglatlog":shippinglatlog_str,@"Formcouponcode":Formcouponcode_str,@"SpecialInstruction":SpecialInstruction};
            
            
            
        } @catch (NSException *exception) {
            NSLog(@"Some values are missing in dic");
            NSLog(@"%@",exception);
        }
        
        /******************Calling Place Order API*******************/
        [self place_order_One_more_method:params];
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
}

 #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     if ([segue.identifier isEqualToString:@"move_to_pay"]) {
         VC_DS_Checkout *check_out_cntroller = [segue destinationViewController];
         check_out_cntroller.rec_dic = sender;
     }
     
 }
-(void)close_ACTION
{
    VW_overlay.hidden = YES;
    _VW_delivery_slot.hidden = YES;
}

#pragma mark Place Order Method API Implementation

-(void)place_order_One_more_method:(NSDictionary *)params{
    @try
        {
            [Helper_activity animating_images:self];
            NSError *error;
            NSError *err;
            NSHTTPURLResponse *response = nil;
    
            NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:NSASCIIStringEncoding error:&err];
            NSLog(@"the posted data is:%@",params);
            //NSString *urlString =[NSString stringWithFormat:@"%@apis/placeorderapi.json",SERVER_URL];

            NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/placeorderapi.json",SERVER_URL];
             urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@"" withString:@"%20"];
    
    
    
            NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:urlProducts];
            [request setHTTPMethod:@"POST"];
            
    
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];

            [request setHTTPBody:postData];
            [request setHTTPShouldHandleCookies:NO];
            NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if (err) {
                [Helper_activity stop_activity_animation:self];
                [err localizedDescription];
            }
            
    
            if(aData)
            {
                [Helper_activity stop_activity_animation:self];
               
                NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"%@",error);
                NSLog(@"The response Api   sighn up API %@",json_DATA);
                NSString *msg = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
                
                if ([msg isEqualToString:@"1"]) {
                   
                    NSLog(@"%@",msg);
                    [self performSegueWithIdentifier:@"move_to_pay" sender:json_DATA];
                }
                else{
                     [HttpClient createaAlertWithMsg:@"Something Went to Wrong Please Try Again Later" andTitle:@""];
                }
            }
            else
            {
               
    
                
                [HttpClient createaAlertWithMsg:@"Something Went to Wrong Please Try Again Later" andTitle:@""];
                
            }
            
        }
        
        @catch(NSException *exception)
        {
              [Helper_activity stop_activity_animation:self];
            NSLog(@"The error is:%@",exception);
        }
   }
#pragma mark Country Code Related
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
    
}

#pragma mark go_To_Home:
-(void)go_To_Home{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
#pragma mark Getting One Time Password For Cash On Delivary (API CALLING)
//http://dohasooq.carmatec.com/apis/productOtpOfCod
//user_id
-(void)gettingOtpForCashOnDelivary{
    @try {
        
        [Helper_activity animating_images:self];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *str_id = @"user_id";
        NSString *user_id;
        for(int h = 0;h<[[dict allKeys] count];h++)
        {
            if([[[dict allKeys] objectAtIndex:h] isEqualToString:str_id])
            {
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:str_id]];
                break;
            }
            else
            {
                
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
            }
            
        }
        
        
        NSString *urlString =[NSString stringWithFormat:@"%@apis/productOtpOfCod",SERVER_URL];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
        
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        
        //User_id
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",user_id]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        NSError *er;
        
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        if (returnData) {
            
            [Helper_activity stop_activity_animation:self];
            NSLog(@"returnData :: %@",returnData);
            // json_DATA = [[NSMutableDictionary alloc]init];
            NSMutableDictionary   *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:returnData options:NSASCIIStringEncoding error:&er];
            
            if (er) {
                [Helper_activity stop_activity_animation:self];
                NSLog(@"er:%@",[er localizedDescription]);
            }

            
            otp_str = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"otp"]];
            NSLog(@"%@", [NSString stringWithFormat:@"OneTimePWD %@", json_DATA]);
            
        }

        
        
    } @catch (NSException *exception) {
        [Helper_activity stop_activity_animation:self];
    }
}

@end
