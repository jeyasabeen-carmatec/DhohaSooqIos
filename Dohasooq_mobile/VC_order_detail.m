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


@interface VC_order_detail ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

{
    NSMutableArray *arr_product,*stat_arr,*reload_section,*arr_states,*picker_Arr,*response_picker_arr;
    NSString *TXT_count, *product_id,*item_count,*qr_code;
    int i,j;
    NSInteger edit_tag,cntry_ID;
    NSMutableArray  *temp_arr;
    BOOL isfirstTimeTransform,isAddClicked,is_Txt_date,isCountrySelected,orderCheckSelected;;
    float scroll_height,shiiping_ht;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSMutableDictionary *jsonresponse_dic,*jsonresponse_dic_address,*delivary_slot_dic,*response_countries_dic;
    NSString *merchent_id,*date_str,*time_str;  //for payment parameters
    NSArray *slot_keys_arr; // time_slot keys for  PickerView
    UIToolbar *accessoryView;
    
    NSString *cntry_selection,*state_selection;//*selection_str,
    NSIndexPath *textfield_indexpath;
    
    //payment parameters
    NSDictionary *shippinglatlog_dic,*billiinglatlog_dic;
    NSString *payment_type_str,*billcheck_clicked,*blng_cntry_ID,*ship_cntry_ID,*blng_state_ID,*ship_state_ID;
    NSMutableArray *date_time_merId_Arr;
    BOOL select_blng_ctry_state; // finding which state/country selected instead of creating new pickerview
    
    
}
//@property(nonatomic,strong) NSMutableDictionary *data_dict;
//@property(nonatomic,strong) NSMutableDictionary *address_new_dict;
//@property(nonatomic,strong) NSMutableDictionary *edit_addr_dict;




@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation VC_order_detail
#define TRANSFORM_CELL_VALUE CGAffineTransformMakeScale(0.8, 0.8)
#define ANIMATION_SPEED 0.2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isfirstTimeTransform = YES;
    stat_arr = [[NSMutableArray alloc]init];
    stat_arr = [NSMutableArray arrayWithObjects:@"0", nil];
    billcheck_clicked = @"0";
    
    //[apply_promo_action
   
    [_BTN_close addTarget:self action:@selector(close_ACTION) forControlEvents:UIControlEventTouchUpInside];
    [self set_UP_VIEW];
    jsonresponse_dic  = [[NSMutableDictionary alloc]init];
    jsonresponse_dic_address = [[NSMutableDictionary alloc]init];
    
    response_picker_arr = [NSMutableArray array];
    
    @try
    {
        [_BTN_fav setBadgeEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 4)];
        [_BTN_cart setBadgeEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 4)];
    }
    @catch(NSException *exception)
    {
        
    }
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(order_detail_API_call) withObject:activityIndicatorView afterDelay:0.01];
    [self Shipp_address_API];
    [self set_UP_VIEW];
    
    
    [_BTN_apply_promo addTarget:self action:@selector(apply_promo_action) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    VW_overlay = [[UIView alloc]init];
    CGRect vwframe;
    vwframe = VW_overlay.frame;
    vwframe.origin.y = self.navigationController.navigationBar.frame.origin.y;
    vwframe.size.height = self.view.frame.size.height - _VW_next.frame.size.height - self.navigationController.navigationBar.frame.size.height;
    vwframe.size.width = self.view.frame.size.width;
    VW_overlay.frame = vwframe;
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]; //[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    // VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    // VW_overlay.hidden = YES;
    
    
    
}
-(void)set_UP_VIEW
{
    
    isfirstTimeTransform = YES;
    
    _LBL_stat.tag = 0;
    
//    _data_dict = [[NSMutableDictionary alloc]init]; // for paramaters
//    _edit_addr_dict = [[NSMutableDictionary alloc]init];
//    _address_new_dict = [[NSMutableDictionary alloc]init];
    
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
    
     _TBL_address.hidden = YES;
    
    [_TBL_address reloadData];
    frame_set = _TBL_address.frame;
    frame_set.origin.y = _VW_BILLING_ADDRESS.frame.origin.y + _VW_BILLING_ADDRESS.frame.size.height;
    frame_set.size.height = _TBL_address.frame.origin.y + _TBL_address.contentSize.height;
    _TBL_address.frame =frame_set;
    
    [self.scroll_shipping addSubview:_TBL_address];
     _TBL_address.hidden = YES;
    _VW_SHIIPING_ADDRESS.hidden = YES;

    
    shiiping_ht = _VW_BILLING_ADDRESS.frame.origin.y + _VW_BILLING_ADDRESS.frame.size.height;
    
    
    
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
    
    
    
    _BTN_fav  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain  target:self action:
                 @selector(btnfav_action)];
    _BTN_cart = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain   target:self action:@selector(btn_cart_action)];
   
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
        next_text = [NSString stringWithFormat:@"%@ NEXT",next];
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
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
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
    
    accessoryView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    accessoryView.barStyle = UIBarStyleBlackTranslucent;
    [accessoryView sizeToFit];
   
    
    _TXT_country.inputView = _staes_country_pickr;
    _TXT_state.inputView = _staes_country_pickr;
    
    
    _TXT_ship_country.inputView =_staes_country_pickr;
    _TXT_ship_state.inputView =_staes_country_pickr;


    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(accessoryView.frame.size.width - 100, 0, 100, accessoryView.frame.size.height);
    [close setTitle:@"DONE" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(picker_done_btn_action:) forControlEvents:UIControlEventTouchUpInside];
    [accessoryView addSubview:close];
    
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
        NSString *str_fname,*str_lname,*str_addr1,*str_addr2,*str_city,*str_zip_code,*str_phone,*str_country,*str_state,*str_email;
        
        str_fname = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"firstname"];
        str_lname = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"lastname"];
        str_addr1 = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"address1"];
        str_addr2 = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"address2"];
        str_city = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"city"];
        str_zip_code = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"zip_code"];
        str_phone = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"phone"];
        str_country = country;
        str_state =state;
        str_email = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"user_email"]];
        
        //cell.Btn_save.hidden = YES;
        
        blng_cntry_ID = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"country_id"];
        blng_state_ID = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"state_id"];
        
        
        str_fname = [str_fname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        
        str_lname = [str_lname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_addr1 = [str_addr1 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_addr2 = [str_addr2 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_city = [str_city stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_zip_code = [str_zip_code stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_phone = [str_phone stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    

        
        
        _TXT_fname.text =  str_fname;
        _TXT_lname.text =  str_lname;
        _TXT_addr1.text =  str_addr1;
        _TXT_addr2.text =  str_addr2;
        _TXT_city.text =  str_city;
        _TXT_zip.text =  str_zip_code;
        _TXT_email.text =  str_email;
        _TXT_phone.text =  str_phone;
        
        
        str_country = [str_country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Select Country"];
        
        str_state = [str_state stringByReplacingOccurrencesOfString:@"<null>" withString:@""];        str_email = [str_state stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        
         _TXT_country.text =  str_country;
         _TXT_state.text =  str_state;

        
    }
    @catch(NSException *exception)
    {
    }

}
-(void)set_data_to_product_Summary_View{
  
    @try {
        
    NSString *sub_total = [NSString stringWithFormat:@"%@",[jsonresponse_dic valueForKey:@"subsum"]];
    
    sub_total = [sub_total stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
    
    _LBL_sub_total.text = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"currency"],sub_total];
    
    
    NSString *shippijng_charge = [NSString stringWithFormat:@"%@",[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:@"1"]];
    shippijng_charge = [shippijng_charge stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
    
    int total = [sub_total intValue]+ [shippijng_charge  intValue];
    //_LBL_total.text = [NSString stringWithFormat:@"QAR %d",total];
    
//    NSString *qr = @"QR";
          NSString *currency = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
    NSString *price =[NSString stringWithFormat:@"%d",total];
    
    NSString *text = [NSString stringWithFormat:@"%@ %@",currency,price];
    if ([_LBL_product_summary respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_product_summary.textColor,
                                  NSFontAttributeName:_LBL_product_summary.font
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
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0]}
                                    range:ename];
        }
        NSRange cmp = [text rangeOfString:price];
        //        [attributedText addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [prec_price length])];
        //
        
        
        //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:21.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:cmp ];
        }
        
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
        
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            [paragraphStyle setAlignment:NSTextAlignmentRight];
            
        }
        else{
            [paragraphStyle setAlignment:NSTextAlignmentLeft];
            
            
        }
        
        
        [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
        
        
        
        _LBL_product_summary.attributedText = attributedText;
        
        
    }
    else
    {
        _LBL_product_summary.text = text;
    }
    _LBL_product_summary.numberOfLines = 0;
    [_LBL_product_summary sizeToFit];
    
    //        frame_set = _LBL_arrow.frame;
    //        frame_set.origin.x = _LBL_total.frame.origin.x+_LBL_total.frame.size.width + 2;
    //        frame_set.origin.y = _LBL_total.frame.origin.y;
    //        _LBL_arrow.frame = frame_set;
    //        [self.VW_next addSubview:_LBL_arrow];
    
    
//    NSString *current_price = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
    NSString *prec_price = [NSString stringWithFormat:@"%d",total];
    NSString *summary_text = [NSString stringWithFormat:@"%@ %@",currency,prec_price];
    
    if ([_LBL_total respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_total.textColor,
                                  NSFontAttributeName:_LBL_total.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:summary_text attributes:attribs];
        
        
        
        NSRange ename = [summary_text rangeOfString:currency];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0]}
                                    range:ename];
        }
        NSRange cmp = [summary_text rangeOfString:prec_price];
        //        [attributedText addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [prec_price length])];
        //
        
        
        //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:21.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0],NSForegroundColorAttributeName:[UIColor redColor],}
                                    range:cmp ];
        }
        _LBL_total.attributedText = attributedText;
    }
    else
    {
        _LBL_total.text = summary_text;
    }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
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
        
        
        //NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
//        if(indexPath.row == totalRow -1){
//            
//            cell.LBL_charge.hidden = NO;
//            cell.LBL_stat.hidden = NO;
//            cell.BTN_stat.hidden = NO;
//            cell.BTN_calendar.hidden =NO;
//            
//        }
//        else{
//            cell.LBL_charge.hidden = YES;
//            cell.LBL_stat.hidden = YES;
//            cell.BTN_stat.hidden = YES;
//            cell.BTN_calendar.hidden =YES;
//        }
        
        if([[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] isKindOfClass:[NSDictionary class]])
        {
            
            
            
            NSArray *keys_arr = [[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] allKeys];
            arr_product = [[[jsonresponse_dic valueForKey:@"data"] valueForKey:@"pdts"] valueForKey:[keys_arr objectAtIndex:indexPath.section]];
            
            @try
            {
                NSString *str = [[arr_product objectAtIndex:indexPath.row] valueForKey:@"merchantId"];
                //  str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                NSString *img_url = [NSString stringWithFormat:@"%@Merchant%@/Small/%@",MERCHANT_URL,str,[[arr_product objectAtIndex:indexPath.row] valueForKey:@"productimage"]];
                [cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:img_url]
                                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                                          options:SDWebImageRefreshCached];
                
                NSString *item_name =[NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"product_name"]];
                
                item_name = [item_name stringByReplacingOccurrencesOfString:@"<null>" withString:@"not mentioned"];
                NSString *item_seller =[NSString stringWithFormat:@"Seller: %@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"merchantname"]];
                
                
                
                item_name = [item_name stringByReplacingOccurrencesOfString:@"<null>" withString:@"not mentioned"];
                cell.LBL_item_name.text = item_name;
                cell.LBL_seller.text = item_seller;
                

                
                
#pragma mark LBL_item_name Attributed Text
                
//                if ([cell.LBL_item_name respondsToSelector:@selector(setAttributedText:)]) {
//                    
//                    // Define general attributes for the entire text
//                    NSDictionary *attribs = @{
//                                              NSForegroundColorAttributeName:cell.LBL_item_name.textColor,
//                                              NSFontAttributeName:cell.LBL_item_name.font
//                                              };
//                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:name_text attributes:attribs];
//                    
//                    
//                    
//                    NSRange ename = [name_text rangeOfString:item_name];
//                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                    {
//                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
//                                                range:ename];
//                    }
//                    else
//                    {
//                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:17.0]}
//                                                range:ename];
//                    }
//                    NSRange cmp = [name_text rangeOfString:item_seller];
//                    
//                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                    {
//                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:21.0]}
//                                                range:cmp];
//                    }
//                    else
//                    {
//                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:13.0]}
//                                                range:cmp ];
//                    }
//                    cell.LBL_item_name.attributedText = attributedText;
//                }
//                else
//                {
//                    cell.LBL_item_name.text = name_text;
//                }
//                
//                
                
                NSString *qr = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"currencycode"]];
                qr_code = qr;
                NSString *mils;
                NSString *price = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"specialPrice"]];
                NSString *prev_price = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"productprice"]];
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
                }
                
                
//                NSString *text = [NSString stringWithFormat:@"%@ %@ %@%@ / %@ %@",qr,price,qr,prev_price,doha_miles,mils];
                NSString *only_price = [NSString stringWithFormat:@"%@ %@ / %@ %@",qr,prev_price,doha_miles,mils];
                NSString *india_currency = [NSString stringWithFormat:@"%@ %@ %@%@",qr,price,qr,prev_price];
                
#pragma mark LBL_current_price Attributed Text
                
                
                if ([cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)])
                {
                    
                    if ([price isEqualToString:@""] && ![doha_miles isEqualToString:@""]) {
                        
                        //                        NSDictionary *attribs = @{
                        //                                                  NSForegroundColorAttributeName:cell.LBL_current_price.textColor,
                        //                                                  NSFontAttributeName:@"Poppins-Regular"
                        //                                                  };
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:only_price attributes:nil];
                        
                        NSRange qrs = [only_price rangeOfString:qr];
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                                range:qrs];
                        
                        NSRange ename = [only_price rangeOfString:prev_price];
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                                range:ename];
                        NSRange miles_price = [only_price rangeOfString:doha_miles];
                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:21.0]}
                                                    range:miles_price];
                        }
                        else
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                                    range:miles_price];
                        }
                        
                        
                        cell.LBL_current_price.attributedText = attributedText;
                        cell.LBL_discount.text = @"";

//                        cell.LBL_discount.text = @"0 %off";
                        
                        
                    }
                    else if (![price isEqualToString:@""] && [doha_miles isEqualToString:@""]){
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:india_currency attributes:nil];
                        
                        NSRange qrs = [india_currency rangeOfString:qr];
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                                range:qrs];
                        
                        NSRange ename = [india_currency rangeOfString:prev_price];
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                                range:ename];
                        
                        NSRange ePrice = [india_currency rangeOfString:price];
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                                range:ePrice];
                        
                        cell.LBL_current_price.attributedText = attributedText;
                        //                        cell.LBL_discount.text = @"0 %off";
                        
                    }
                    // when sno offer and  No doha miles
                    else if ([price isEqualToString:@""] && [doha_miles isEqualToString:@""]){
                        
                        NSString *text = [NSString stringWithFormat:@"%@ %@",qr,prev_price];
                        
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                        
                        NSRange qrs = [text rangeOfString:prev_price];
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                                range:qrs];
                        cell.LBL_current_price.attributedText = attributedText;
                        cell.LBL_discount.text = @"0 %off";
                        
                        
                    }
                    
                    
                    else{
                        
                        
//                         NSString *text = [NSString stringWithFormat:@"%@ %@ %@%@ / %@ %@",qr,price,qr,prev_price,doha_miles,mils];
                        
                        int  k = [prev_price intValue]-[price intValue];
                        float discount = (k*100)/[prev_price intValue];
                        NSString *str_off = @"% off";
                        cell.LBL_discount.text = [NSString stringWithFormat:@"%.f%@",discount,str_off];
                        
                        
                        prev_price= [qr stringByAppendingString:prev_price];
                         NSString *text = [NSString stringWithFormat:@"%@ %@ %@ / %@ %@",qr,price,prev_price,doha_miles,mils];
                        
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                        
                        NSRange qrs = [text rangeOfString:qr];
                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                                    range:qrs];
                        }
                        else
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                                    range:qrs];
                        }
                        
                        
                        
                        NSRange ename = [text rangeOfString:price];
                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                                    range:ename];
                        }
                        else
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
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
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                                    range:cmp];
                        }
                        @try {
//                            [attributedText addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(price.length+qr.length+2, [prev_price length]+[qr length])];
                            
                             [attributedText addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(price.length+qr.length+2, [prev_price length])];
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        
                        
                        NSRange miles_price = [text rangeOfString:doha_miles];
                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:21.0]}
                                                    range:miles_price];
                        }
                        else
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                                    range:miles_price];
                        }
                        NSRange miles = [text rangeOfString:mils];
                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:21.0]}
                                                    range:miles];
                        }
                        else
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                                    range:miles];
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
                
                
                
                cell._TXT_count.text = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"product_qty"]];
                
                TXT_count = cell._TXT_count.text;
                
                
                [cell.BTN_plus addTarget:self action:@selector(plus_action:) forControlEvents:UIControlEventTouchUpInside];
                [cell.BTN_minus addTarget:self action:@selector(minus_action:) forControlEvents:UIControlEventTouchUpInside];
                //[[NSString stringWithFormat:@"%@",[arr_product objectAtIndex:indexPath.row] valueForKey:@"product_id"]] ];
                cell.BTN_plus.tag = [[[arr_product objectAtIndex:indexPath.row] valueForKey:@"product_id"] intValue];
                cell.BTN_minus.tag = [[[arr_product objectAtIndex:indexPath.row] valueForKey:@"product_id"] intValue];
                
                
                cell.BTN_calendar.tag = [[NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"merchantId"]] integerValue];
                [cell.BTN_calendar addTarget:self action:@selector(calendar_action:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.BTN_stat addTarget:self action:@selector(BTN_check_clickds:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.BTN_stat.tag = [[NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"merchantId"]] integerValue];
                
                cell.LBL_stat.tag =j;
                
                //                if(cell.BTN_stat.tag == 0)
                
                cell._TXT_count.layer.borderWidth = 0.4f;
                cell._TXT_count.layer.borderColor = [UIColor grayColor].CGColor;
                
                cell.BTN_plus.layer.borderWidth = 0.4f;
                cell.BTN_plus.layer.borderColor = [UIColor grayColor].CGColor;
                cell.BTN_minus.layer.borderWidth = 0.4f;
                cell.BTN_minus.layer.borderColor = [UIColor grayColor].CGColor;
                
                //Delivary Slot checking Condition
                
                
        NSString *delivery_slot_available  =[NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"delivery_slot_available"]];
                
                
            NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
                
                if(indexPath.row == totalRow -1){ //last row
                    
                    if ([delivery_slot_available isEqualToString:@"No"] || [delivery_slot_available isEqualToString:@"<null>"])
                    {
                        
                        cell.BTN_calendar.hidden = YES;
                    }
                    else{
                        cell.BTN_calendar.hidden = NO;
                    }
                    
                }
                else{ //Not last row
                    
                    cell.BTN_calendar.hidden = YES;
                }
                
                
               //Expected Delivary Date customization
                NSString *expected_delivary_date  =[NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"expecteddelivery"]];
                
                 NSString *text1 = [NSString stringWithFormat:@"%@",expected_delivary_date];
                text1 = [text1 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                
                cell.LBL_date.text = text1;
                
               // NSString *text1 = [NSString stringWithFormat:@"Delivery on %@",expected_delivary_date];
                
//                if ([cell.LBL_date respondsToSelector:@selector(setAttributedText:)]) {
//                    
//                    if ([expected_delivary_date isEqualToString:@"<null>"] || [expected_delivary_date isEqualToString:@""]) {
//                        cell.LBL_date.text = @"Delivary Date Not Allocated";
//                    }
//                    
//                    else{                    // Define general attributes for the entire text
//                        NSDictionary *attribs = @{
//                                                  NSForegroundColorAttributeName:cell.LBL_date.textColor,
//                                                  NSFontAttributeName:cell.LBL_date .font
//                                                  };
//                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text1 attributes:attribs];
//                        
//                        NSRange ename = [text1 rangeOfString:expected_delivary_date];
//                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//                        {
//                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
//                                                    range:ename];
//                        }
//                        else
//                        {
//                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0],NSForegroundColorAttributeName:[UIColor redColor]}
//                                                    range:ename];
//                        }
//                        
//                        cell.LBL_date .attributedText = attributedText;
//                    }
//                }
//                else
//                {
//                    cell.LBL_date .text = text1;
//                }
                
        // PickUp from merchant location condition checking
                
                if(indexPath.row == totalRow -1){ //last row
                    if ([[jsonresponse_dic valueForKey:@"pickup"] isKindOfClass:[NSDictionary class]]) {
                        NSArray *pickUpkeys = [[jsonresponse_dic valueForKey:@"pickup"]allKeys];
                        
                        @try {
                            
                            for (int k=0; k<pickUpkeys.count; k++) {
                                if ([str isEqualToString:[pickUpkeys objectAtIndex:k]]) {
                                    cell.LBL_stat.hidden = NO;
                                    cell.BTN_stat.hidden = NO;
                                }
                            }
                            
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        
                    }
                    else{ // not last row
                        cell.LBL_stat.hidden = YES;
                        cell.BTN_stat.hidden = YES;
                    }
                }
                else{
                    cell.LBL_stat.hidden = YES;
                    cell.BTN_stat.hidden = YES;
                }
                
                
                
             // Shipping Charge labelcustomization
                NSString *CHRGE;
                NSString *qrcode = [NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"currencycode"]];
                NSString *shipping_type;
                if(indexPath.row == totalRow -1){
                   
                    
                    @try
                    {
                        NSArray *key_ship_arr =[[jsonresponse_dic valueForKey:@"shipcharge"] allKeys];
                        
                        for(int m =0 ;m< key_ship_arr.count;m++)
                        {
                            if([str intValue] == [[key_ship_arr objectAtIndex:m] intValue])
                            {
                                
                                @try {
                                    CHRGE = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:[key_ship_arr objectAtIndex:m]] valueForKey:@"charge"]];
                                    shipping_type = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:[key_ship_arr objectAtIndex:m]] valueForKey:@"methodname"]];
                                    
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
                    }
                    @catch(NSException *exception)
                    {
                        CHRGE = [NSString stringWithFormat:@"%@", [jsonresponse_dic valueForKey:@"shipcharge"]];
                        
                    }

                
                }
                else{
                    cell.LBL_charge.hidden = YES;
                }
                
            
//                @try
//                {
//                    NSArray *key_ship_arr =[[jsonresponse_dic valueForKey:@"shipcharge"] allKeys];
//                    
//                    for(int m =0 ;m< key_ship_arr.count;m++)
//                    {
//                        if([str intValue] == [[key_ship_arr objectAtIndex:m] intValue])
//                        {
//                            
//                            @try {
//                                NSLog(@"???????      :: %@",str);
//                                  cell.LBL_charge.hidden = NO;
//                                CHRGE = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:[key_ship_arr objectAtIndex:m]] valueForKey:@"charge"]];
//                                shipping_type = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:[key_ship_arr objectAtIndex:m]] valueForKey:@"methodname"]];
//                                
//                            } @catch (NSException *exception) {
//                                
//                                CHRGE = @"";
//                                shipping_type =@"";
//                                
//                                NSLog(@"%@",exception);
//                            }
//                        }
//                        else{
//                            cell.LBL_charge.hidden = YES;
//                        }
//                    }
//                }
//                @catch(NSException *exception)
//                {
//                    CHRGE = [NSString stringWithFormat:@"%@", [jsonresponse_dic valueForKey:@"shipcharge"]];
//                    
//                }
                CHRGE = [CHRGE stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
                NSString *text2 = [NSString stringWithFormat:@"%@  Shipping Charge %@ %@",shipping_type,qr,CHRGE]
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
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0]}
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
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:16.0]}
                                                range:flatrate];
                    }
                    
                    
                    
                    
                    NSRange chrge = [text2 rangeOfString:CHRGE];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                                range:chrge];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                                range:chrge];
                    }
                    
                    
                    cell.LBL_charge .attributedText = attributedText;
                }
                else
                {
                    cell.LBL_charge .text = text1;
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
        if(!orderCheckSelected)
        {
            cell.LBL_stat.image = [UIImage imageNamed:@"profile_checkbox.png"];
            //[cell.LBL_stat setTag:1];
            //cell.BTN_calendar.hidden = NO;
        }
        else
            
        {
            
            cell.LBL_stat.image = [UIImage imageNamed:@"checkbox_select.png"];
            //[cell.LBL_stat setTag:0];
        
            
            
            cell.LBL_charge.text = @"";
            
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
                
                
                NSString *name_str =[NSString stringWithFormat:@"%@ %@",[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"firstname"],[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"lastname"]];
                name_str = [name_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
                
                cell.LBL_name.text = name_str;
                // NSString *country;
                NSString *state = [[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"state"];
                NSString *country = [[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"country"];
                
                
                
                state = [state stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
                
                country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
                
                
                NSString *address_str = [NSString stringWithFormat:@"%@,\n %@ \n%@,%@,%@",[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"address1"],[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"city"],state,country,[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"zip_code"]];
                
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
    
           
           /* else
            {
                
                billing_address *cell = [tableView dequeueReusableCellWithIdentifier:identifier_billing];
                
                if (cell == nil)
                {
                    NSArray *nib;
                    nib = [[NSBundle mainBundle] loadNibNamed:@"billing_address" owner:self options:nil];
                    cell = [nib objectAtIndex:index];
                }
                
                cell.BTN_check.tag = 0;
                
//                cell.TXT_first_name.delegate = self;
//                cell.TXT_last_name.delegate = self;
//                cell.TXT_address1.delegate = self;
//                cell.TXT_address2.delegate = self;
//                cell.TXT_city.delegate = self;
                cell.TXT_state.delegate = self;
                cell.TXT_country.delegate = self;
//                cell.TXT_zip.delegate = self;
//                cell.TXT_email.delegate = self;
//                cell.TXT_phone.delegate = self;
                
                
//                cell.TXT_first_name.tag = indexPath.row;
//                cell.TXT_last_name.tag = indexPath.row;
//                cell.TXT_address1.tag = indexPath.row;
//                cell.TXT_address2.tag = indexPath.row;
//                cell.TXT_city.tag = indexPath.row;
//                cell.TXT_state.tag = indexPath.row;
//                cell.TXT_country.tag = indexPath.row;
//                cell.TXT_zip.tag = indexPath.row;
//                cell.TXT_email.tag = indexPath.row;
//                cell.TXT_phone.tag = indexPath.row;
                
                
                
                
                [cell.TXT_first_name addTarget:self action:@selector(TXT_first_name:) forControlEvents:UIControlEventEditingChanged];
                 [cell.TXT_last_name addTarget:self action:@selector(TXT_last_name:) forControlEvents:UIControlEventEditingChanged];
                
                 [cell.TXT_address1 addTarget:self action:@selector(TXT_address1:) forControlEvents:UIControlEventEditingChanged];
                 [cell.TXT_address2 addTarget:self action:@selector(TXT_address2:) forControlEvents:UIControlEventEditingChanged];
                [cell.TXT_city addTarget:self action:@selector(TXT_city:) forControlEvents:UIControlEventEditingChanged];
                 [cell.TXT_state addTarget:self action:@selector(TXT_state:) forControlEvents:UIControlEventEditingChanged];
                
                [cell.TXT_country addTarget:self action:@selector(TXT_country:) forControlEvents:UIControlEventEditingChanged];
                [cell.TXT_zip addTarget:self action:@selector(TXT_zip:) forControlEvents:UIControlEventEditingChanged];
                
                [cell.TXT_email addTarget:self action:@selector(TXT_email:) forControlEvents:UIControlEventEditingChanged];
                 [cell.TXT_phone addTarget:self action:@selector(TXT_phone:) forControlEvents:UIControlEventEditingChanged];
                
                
                
                
//                
//                                [cell.TXT_first_name addTarget:self action:@selector(textfieldvalid:) forControlEvents:UIControlEventEditingChanged];
//                                 [cell.TXT_last_name addTarget:self action:@selector(textfieldvalid:) forControlEvents:UIControlEventEditingChanged];
//                
//                                 [cell.TXT_address1 addTarget:self action:@selector(textfieldvalid:) forControlEvents:UIControlEventEditingChanged];
//                                 [cell.TXT_address2 addTarget:self action:@selector(textfieldvalid:) forControlEvents:UIControlEventEditingChanged];
//                                [cell.TXT_city addTarget:self action:@selector(textfieldvalid:) forControlEvents:UIControlEventEditingChanged];
//                                 [cell.TXT_state addTarget:self action:@selector(textfieldvalid:) forControlEvents:UIControlEventEditingChanged];
//                
//                                [cell.TXT_country addTarget:self action:@selector(textfieldvalid:) forControlEvents:UIControlEventEditingChanged];
//                                [cell.TXT_zip addTarget:self action:@selector(textfieldvalid:) forControlEvents:UIControlEventEditingChanged];
//                
//                                [cell.TXT_email addTarget:self action:@selector(textfieldvalid:) forControlEvents:UIControlEventEditingChanged];
//                                 [cell.TXT_phone addTarget:self action:@selector(textfieldvalid:) forControlEvents:UIControlEventEditingChanged];
//                
                
                
                
                
                 NSString *str_fname,*str_lname,*str_addr1,*str_addr2,*str_city,*str_zip_code,*str_phone,*str_country,*str_state;
                if ([[jsonresponse_dic_address valueForKey:@"billaddress"] isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *dict = [jsonresponse_dic_address valueForKey:@"billaddress"];
                    
                           str_fname = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"firstname"]];
                str_lname = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"lastname"]];
                str_addr1 = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"address1"]];
                str_addr2 = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"address2"]];
                str_city = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"city"]];
                str_zip_code  = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"zip_code"]];
                
                str_phone = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"phone"]];
                str_country = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"country"]];
                str_state =[NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"state"]];
                    
                    NSLog(@"22222222 %@",indexPath);
                
                    }
                
                //[[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]]
                
                
                if (indexPath.section == 2 && !isAddClicked) {
                    
                    
                    cell.LBL_Blng_title.text = @"SHIPPING ADDRESS";
                    NSString *state = [[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"state"];
                    NSString *country = [[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"country"];
                    //  state = [state stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
                    
                    //  country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
                    str_fname = [[[dict_shipping valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"firstname"];
                    str_lname = [[[dict_shipping valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"lastname"];
                    str_addr1 = [[[dict_shipping valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"address1"];
                    str_addr2 = [[[dict_shipping valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"address2"];
                    str_city = [[[dict_shipping valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"city"];
                    str_zip_code = [[[dict_shipping valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"zip_code"];
                    str_phone = [[[dict_shipping valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"phone"];
                    str_country = country;
                    str_state =state;
                    
                    cell.LBL_shipping.hidden=YES;
                    cell.checkBtnView.hidden = YES;
                    //cell.Btn_save.hidden = YES;
                    
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
                
                
                
                cell.TXT_first_name.text = str_fname;
                cell.TXT_last_name.text = str_lname;
                cell.TXT_address1.text = str_addr1;
                cell.TXT_address2.text = str_addr2;
                cell.TXT_city.text = str_city;
                cell.TXT_state.text = str_state;
                cell.TXT_country.text = str_country;
                cell.TXT_zip.text = str_zip_code;
                cell.TXT_phone.text = str_phone;
                
                
                if ( (isAddClicked && indexPath.section == 2) || (![[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]] && indexPath.section == 1)) {
                    
                    cell.LBL_shipping.hidden=YES;
                    cell.checkBtnView.hidden = YES;
                    //cell.Btn_save.hidden = YES;
                    
                    cell.LBL_Blng_title.text = @"SHIPPING ADDRESS";
                    
                    cell.TXT_first_name.text = @"";
                    cell.TXT_last_name.text = @"";
                    cell.TXT_address1.text = @"";
                    cell.TXT_address2.text = @"";
                    cell.TXT_city.text = @"";
                    cell.TXT_state.text = @"";
                    cell.TXT_country.text = @"";
                    cell.TXT_zip.text = @"";
                    cell.TXT_phone.text = @"";
                    
                }
                if (indexPath.section == 0) {
                    cell.LBL_Blng_title.text = @"BILLING ADDRESS";
                    cell.LBL_shipping.hidden=NO;
                    cell.checkBtnView.hidden = NO;
                }
                
                
                
                [cell.BTN_check addTarget:self action:@selector(BTN_chek_action:) forControlEvents:UIControlEventTouchUpInside];
                cell.LBL_stat.tag = [[stat_arr objectAtIndex:0] intValue];
                
                if(cell.LBL_stat.tag == 0)
                {
                    cell.LBL_stat.image = [UIImage imageNamed:@"checkbox_select.png"];
                    [cell.LBL_stat setTag:1];
                }
                else if(cell.LBL_stat.tag == 1)
                {
                    cell.LBL_stat.image = [UIImage imageNamed:@"profile_checkbox.png"];
                    [cell.LBL_stat setTag:0];
                }
                cell.TXT_email.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"email"];
                
                return cell;
            }
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
    }*/
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _TBL_orders)
    {
        //        if([[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] isKindOfClass:[NSDictionary class]])
        //        {
        //            NSInteger ct = 0;
        //            NSArray *keys_arr = [[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] allKeys];
        //             for(int m = 0;m< keys_arr.count;m++) {
        //                 if(indexPath.section == m)
        //                 {
        //                     ct = [[[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] valueForKey:[keys_arr objectAtIndex:m]]count];
        //                 }
        //            }
        //            
        //            
        //            if(indexPath.row ==  ct-1){
        
        return 215.0;
        //                
        //            }
        //            else{
        //                NSLog(@"********%ld",indexPath.row);
        //                return 170;
        //            }
        //
        //        }
        //        else{
        //            return 0;
        //        }
        
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
        shiiping_ht = _VW_BILLING_ADDRESS.frame.origin.y + _VW_BILLING_ADDRESS.frame.size.height;


        
    }
    else
    {
        billcheck_clicked = @"1"; // for place order

        isCompare = YES;
        self.LBL_stat.image = [UIImage imageNamed:@"profile_checkbox.png"];
    
        
        if([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]]){
            _TBL_address.hidden = NO;
            [_TBL_address reloadData];
            shiiping_ht = _TBL_address.frame.origin.y + _TBL_address.frame.size.height;
        }
        else{ //shipping address is nil load billing address
            _TBL_address.hidden = YES;
            _VW_SHIIPING_ADDRESS.hidden = NO;
            
            CGRect frameset = _VW_SHIIPING_ADDRESS.frame;
            frameset.origin.y = _VW_BILLING_ADDRESS.frame.origin.y + _VW_BILLING_ADDRESS.frame.size.height;
            frameset.size.width = _VW_shipping.frame.size.width;
            _VW_SHIIPING_ADDRESS.frame = frameset;
            [self.scroll_shipping addSubview:_VW_SHIIPING_ADDRESS];
            
            shiiping_ht = _VW_SHIIPING_ADDRESS.frame.origin.y + _VW_SHIIPING_ADDRESS.frame.size.height;
            [self viewDidLayoutSubviews];

        }
        
        
      
    }
     [self viewDidLayoutSubviews];
   }
-(void)calendar_action:(UIButton *)sender
{
    merchent_id = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self delivary_slot_API];

    VW_overlay.hidden = NO;
    
    _BTN_done.layer.cornerRadius = 2.0f;
    _BTN_done.layer.masksToBounds = YES;
    _VW_delivery_slot.center = VW_overlay.center;
    _VW_delivery_slot.layer.cornerRadius = 2.0f;
    _VW_delivery_slot.layer.masksToBounds = YES;
    [VW_overlay addSubview:_VW_delivery_slot];
    _VW_delivery_slot.hidden = NO;
    
}
//-(void)deliveryslot_action
//{
//    VW_overlay.hidden = YES;
//    _VW_delivery_slot.hidden = YES;
//}
-(void)next_page
{
    
    
    
    if([_LBL_navigation.title isEqualToString:@"ORDER DETAILS"])
    {
        
        if(_VW_summary.hidden == NO)
        {
            VW_overlay.hidden = NO;
            _VW_summary.hidden = NO;
        }
        else
        {
            
            _TBL_orders.hidden = YES;
            _LBL_navigation.title = @"SHIPPING";
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
            
        }
        
    }
    else  if([_LBL_navigation.title isEqualToString:@"SHIPPING"])
    {
        
        if(_VW_summary.hidden == NO)
        {
            VW_overlay.hidden = NO;
            _VW_summary.hidden = NO;
            
        }
        else
        {
            [self validatingTextField];
        }
    }
    
      else if ([_LBL_navigation.title isEqualToString:@"PAYMENT"] && _VW_payment.hidden == NO) {
          
          [self move_to_payment_integration]; // load web view page
    }
    
}
-(void)move_to_payment_integration{
   
        
        
        NSLog(@"%@",payment_type_str);
        
        if ([payment_type_str isEqualToString:@"1"]||[payment_type_str isEqualToString:@"2"] ||[payment_type_str isEqualToString:@"3"] ||[payment_type_str isEqualToString:@"4"] || [payment_type_str isEqualToString:@"5"]) {
            
            
            [self place_oredr_API];
            
            
        }
        else{
            [HttpClient createaAlertWithMsg:@"Please Select Payment Type" andTitle:@""];
        }
    }



-(void)move_to_payment_types{
    
    [self performSelector:@selector(payment_methods_API) withObject:activityIndicatorView afterDelay:0.001];
    _TBL_address.hidden = YES;
    _LBL_navigation.title = @"PAYMENT";
    //  [_Collection_cards reloadData];
    //[_TBL_orders removeFromSuperview];
    CGRect frame_set = _VW_payment.frame;
    frame_set.origin.y = _VW_top.frame.origin.y + _VW_top.frame.size.height;
    frame_set.size.width = _TBL_orders.frame.size.width;
    frame_set.size.height = _VW_next.frame.origin.y - _TBL_orders.frame.origin.y;
    _VW_payment.frame = frame_set;
    [self.view addSubview:_VW_payment];
    _LBL_shipping.backgroundColor = _LBL_order_detail.backgroundColor;
    _TXT_second.backgroundColor = _LBL_order_detail.backgroundColor;

    
}

-(void)product_clicked
{
    if([_LBL_navigation.title isEqualToString:@"ORDER DETAILS"])
    {
        [self.view addSubview:VW_overlay];
        [self sumary_VIEW];
    }
    
    else if([_LBL_navigation.title isEqualToString:@"SHIPPING"])
    {
        [self.view addSubview:VW_overlay];
        [self sumary_VIEW];
        
    }
    else if([_LBL_navigation.title isEqualToString:@"PAYMENT"])
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
        VW_overlay.hidden = NO;
        _VW_summary.hidden = NO;
        
        //_LBL_arrow.text = @"";
    }
    else
    {
        _LBL_arrow.text =@"";
        VW_overlay.hidden = YES;
        _VW_summary.hidden =  YES;
        
    }
    
}
-(void)apply_promo_action{
    
    if ([self.TXT_cupon.text isEqualToString:@""]) {
    
        [self.TXT_cupon becomeFirstResponder];
        [HttpClient createaAlertWithMsg:@"Please enter cupon code" andTitle:@""];
    }
    else{
     
    [self performSelector:@selector(apply_promo_Code) withObject:activityIndicatorView afterDelay:0.001];
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
    frameset.origin.y = _TBL_address.frame.origin.y + _TBL_address.frame.size.height;
    frameset.size.width = _VW_shipping.frame.size.width;
    _VW_SHIIPING_ADDRESS.frame = frameset;
    [self.scroll_shipping addSubview:_VW_SHIIPING_ADDRESS];
    
    shiiping_ht = _VW_SHIIPING_ADDRESS.frame.origin.y + _VW_SHIIPING_ADDRESS.frame.size.height;
    [self viewDidLayoutSubviews];
    
    isAddClicked = NO;
    i = 3;
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
        NSString *str_fname,*str_lname,*str_addr1,*str_addr2,*str_city,*str_zip_code,*str_phone,*str_country,*str_state,*str_email;
        
        str_fname = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"firstname"];
        str_lname = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"lastname"];
        str_addr1 = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"address1"];
        str_addr2 = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"address2"];
        str_city = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"city"];
        str_zip_code = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"zip_code"];
        str_phone = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"phone"];
        str_country = country;
        str_state =state;
         str_email = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"user_email"]];
        
        //cell.Btn_save.hidden = YES;
        
    ship_state_ID = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"state_id"];
         ship_cntry_ID = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"country_id"];
        
    
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
        
        

    
      /*
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
        [self.TBL_address endUpdates];*/
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}
-(void)add_new_address:(UIButton*)sender{
    
    i = 3;
    isAddClicked = YES;
    [self.TBL_address reloadData];
    
}


/*
-(void)BTN_chek_action
{
    UIImage *secondImage = [UIImage imageNamed:@"checkbox_select.png"];
    
    NSData *imgData1 = UIImagePNGRepresentation(self.LBL_stat.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompare =  [imgData1 isEqualToData:imgData2];
    if (isCompare) {
        
        isCompare = NO;
        self.LBL_stat.image = [UIImage imageNamed:@"profile_checkbox.png"];
    }
    else{
        isCompare = YES;
        
        self.LBL_stat.image = [UIImage imageNamed:@"checkbox_select.png"];
    }
    
    
}*/
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
    }
    else{
        [HttpClient createaAlertWithMsg:@"Plese select Time and  Day/Date" andTitle:@""];
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
    
    
    NSLog(@"******%@",indexPathsec);
    
    [self.TBL_orders beginUpdates];
    
    [self.TBL_orders reloadSections:[NSIndexSet indexSetWithIndex:indexPathsec.section] withRowAnimation:UITableViewRowAnimationNone];
    
  [self.TBL_orders endUpdates];
    
    
    merchent_id = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    //checkbox selection status adding to placeorder paramaters
    for (int m=0; m<date_time_merId_Arr.count; m++) {
     
     if ([merchent_id isEqualToString:[[date_time_merId_Arr objectAtIndex:m] valueForKey:@"mer_id"]]) {
     
     NSMutableDictionary *dic = [NSMutableDictionary dictionary];
     [dic addEntriesFromDictionary:[date_time_merId_Arr objectAtIndex:m]];
     
         
         if (orderCheckSelected) {
              [dic setObject:@"1" forKey:@"pickMethod"];
         }else{
            [dic setObject:@"0" forKey:@"pickMethod"];
         }

     [date_time_merId_Arr replaceObjectAtIndex:m withObject:dic];
     
     }
     }
    NSLog(@"@@@@@@@@@@ %@",date_time_merId_Arr);

    
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
    
//    int s = [cell._TXT_count.text intValue];
//    if (s<=1) {
//        s = 1;
//        [HttpClient createaAlertWithMsg:@"Min. Quantity is 1 " andTitle:@""];
//    }
//    else{
//        s = s - 1;
//        TXT_count = [NSString stringWithFormat:@"%d",s];
//        cell._TXT_count.text = TXT_count;
        item_count = cell._TXT_count.text;
        
        product_id = [NSString stringWithFormat:@"%ld",(long)btn.tag];//Getting product Id
        
        
        merchent_id = [NSString stringWithFormat:@"%ld",cell.BTN_calendar.tag]; //Getting Mer Id
        
        NSLog(@"id_m %@  id_p %@",product_id,merchent_id);
        [self updating_cart_List_api];
        
   // }
    
    
}
-(void)plus_action:(UIButton*)btn
{
    CGPoint center= btn.center;
    CGPoint rootViewPoint = [btn.superview convertPoint:center toView:self.TBL_orders];
    NSIndexPath *indexPath = [self.TBL_orders indexPathForRowAtPoint:rootViewPoint];
    order_cell *cell = (order_cell*)[self.TBL_orders cellForRowAtIndexPath:indexPath];
//    
//    int s = [cell._TXT_count.text intValue];
//    s = s + 1;
//    TXT_count = [NSString stringWithFormat:@"%d",s];
//    cell._TXT_count.text = TXT_count;
    
    item_count = cell._TXT_count.text;
    
    product_id = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    
    merchent_id = [NSString stringWithFormat:@"%ld",cell.BTN_calendar.tag];
    
    NSLog(@"id_m %@  id_p %@",product_id,merchent_id);
    [self updating_cart_List_api];

}

- (IBAction)back_action_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark text field delgates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if(textField.tag == 6 || textField.tag == 7 || textField.tag == 8 || textField == _TXT_cupon)
    {
        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,-120,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
        
        
    }
    //[textField becomeFirstResponder];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    //    if(textField)
    //    {
    //        scroll_height = scroll_height + 100;
    //        [self viewDidLayoutSubviews];
    //    }
    [textField becomeFirstResponder];
    if (textField == _TXT_Date ) {
        
        @try {
            
            is_Txt_date = YES;
            [picker_Arr removeAllObjects];
            
           // NSLog(@"%@",[[delivary_slot_dic valueForKey:@"days"] valueForKey:@"1"]);
            
            if ([[delivary_slot_dic valueForKey:@"days"] isKindOfClass:[NSDictionary class]]) {
                
                slot_keys_arr = [[delivary_slot_dic valueForKey:@"days"]allKeys];
                
                for (int slot = 0; slot< slot_keys_arr.count; slot++) {
                    
                    
                    [picker_Arr addObject:[[delivary_slot_dic valueForKey:@"days"] valueForKey:[slot_keys_arr objectAtIndex:slot]]];
                }
            }
            [self.pickerView becomeFirstResponder];
            [self.pickerView reloadAllComponents];
            
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
    }
    if (textField == _TXT_Time ) {
        
        [picker_Arr removeAllObjects];
        
        is_Txt_date= NO;
        if ([[delivary_slot_dic valueForKey:@"delivery"] isKindOfClass:[NSDictionary class]]) {
            
            slot_keys_arr = [[delivary_slot_dic valueForKey:@"delivery"]allKeys];
            
            for (int slot = 0; slot< slot_keys_arr.count; slot++) {
                
                [picker_Arr addObject:[[delivary_slot_dic valueForKey:@"delivery"] valueForKey:[slot_keys_arr objectAtIndex:slot]]];
            }
        }
        [self.pickerView becomeFirstResponder];
        [self.pickerView reloadAllComponents];
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
        [self performSelector:@selector(CountryAPICall) withObject:activityIndicatorView afterDelay:0];
        
    }
    if (textField.tag == 6) {
        
        isCountrySelected = NO;
        textField.inputView = _staes_country_pickr;
        textField.inputAccessoryView = accessoryView;
        [self.pickerView becomeFirstResponder];
        [self performSelector:@selector(stateApiCall) withObject:activityIndicatorView afterDelay:0];
        
    }
    
    if(textField == _TXT_phone || _TXT_email || _TXT_country || _TXT_state)
    {
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,-120,self.view.frame.size.width,self.view.frame.size.height);
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
    
    
    
   
//    if (textField == _TXT_Time || textField == _TXT_Date) {
//        [self.pickerView resignFirstResponder];
//    }
    
    
//    billing_address *textFieldRowCell;
//    textFieldRowCell = (billing_address *) textField.superview.superview.superview;
//    NSIndexPath *indexPath = [self.TBL_address indexPathForCell:textFieldRowCell];
//    
//    switch (textField.tag)
//    {
//        case 1:
//            
//            if ([textField.text isEqualToString:@""]) {
//                [HttpClient createaAlertWithMsg:@"Name should not be empty at least two characters " andTitle:@""];
//            }
//            else if ([textField.text length]<2 || [textField.text length]>30){
//                [HttpClient createaAlertWithMsg:@"Name length should be between 2 and 30 characters " andTitle:@""];
//            }
//            else{
//                
//                if (isAddClicked) {
//                  [_address_new_dict setValue:textField.text forKey:@"fname"];
//                }
//                else if (indexPath.row == 0 && indexPath.section == 0){
//                    [_data_dict setValue:textField.text forKey:@"fname"];
//
//                }
//                
//                
//                else{
//                    [_edit_addr_dict setValue:textField.text forKey:@"fname"];
//                }
//              
//            }
//            break;
//            
//        case 2:
//            
//            if ([textField.text isEqualToString:@""]) {
//                [HttpClient createaAlertWithMsg:@"Name should not be empty at least two characters " andTitle:@""];
//            }
//            else if ([textField.text length]<2 || [textField.text length]>30){
//                [HttpClient createaAlertWithMsg:@"Name length should be between 2 and 30 characters " andTitle:@""];
//            }
//            else{
//                if (isAddClicked) {
//                    [_address_new_dict setValue:textField.text forKey:@"lname"];
//                }
//                else if (indexPath.row == 0 && indexPath.section == 0){
//                    [_data_dict setValue:textField.text forKey:@"lname"];
//                    
//                }
//                else{
//                    [_edit_addr_dict setValue:textField.text forKey:@"lname"];
//                }
//                
//            }
//            
//            break;
//            
//        case 3:
//            if ([textField.text isEqualToString:@""]) {
//                [HttpClient createaAlertWithMsg:@"Name should not be empty at least two characters " andTitle:@""];
//            }
//            else{
//                if (isAddClicked) {
//                    [_address_new_dict setValue:textField.text forKey:@"address1"];
//                }
//                else if (indexPath.row == 0 && indexPath.section == 0){
//                    [_data_dict setValue:textField.text forKey:@"address1"];
//                    
//                }
//                else{
//                    [_edit_addr_dict setValue:textField.text forKey:@"address1"];
//                }
//            }
//            
//            break;
//            
//        case 4:
//            
//            [_data_dict setValue:textField.text forKey:@"address2"];
//            
//            break;
//            
//            
//        case 5:
//            if ([textField.text isEqualToString:@""]) {
//                [HttpClient createaAlertWithMsg:@"city should not be empty at least two characters " andTitle:@""];
//            }
//            else if ([textField.text length]<2 || [textField.text length]>30){
//                [HttpClient createaAlertWithMsg:@"city length should be between 2 and 30 characters " andTitle:@""];
//            }
//            else{
//                if (isAddClicked) {
//                    [_address_new_dict setValue:textField.text forKey:@"city"];
//                }
//                else{
//                    [_edit_addr_dict setValue:textField.text forKey:@"city"];
//                }
//            }
//            
//            break;
//            
//        case 6:
//            textField.text = state_selection;
//            
//                        if ([textField.text isEqualToString:@""]) {
//                            [HttpClient createaAlertWithMsg:@"Please select state " andTitle:@""];
//                        }
//                        else{
//            
//                            if (isAddClicked) {
//                                [_address_new_dict setValue:textField.text forKey:@"state"];
//                            }
//                            else{
//                                [_edit_addr_dict setValue:textField.text forKey:@"state"];
//                            }
//                        }
//            
//            break;
//            
//        case 7:
//            if ([textField.text isEqualToString:@""]) {
//                [HttpClient createaAlertWithMsg:@"Please enter Zip code " andTitle:@""];
//            }
//            else if ([textField.text length]<3 || [textField.text length]>8){
//                [HttpClient createaAlertWithMsg:@"Please enter valid Zip code" andTitle:@""];
//            }
//            else{
//                if (isAddClicked) {
//                    [_address_new_dict setValue:textField.text forKey:@"zip_code"];
//                }
//                else{
//                    [_edit_addr_dict setValue:textField.text forKey:@"zip_code"];
//                }
//            }
//            
//            break;
//            
//        case 8:
//            
//            break;
//        case 9:
//            
//            if (![textField.text isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]]) {
//                
//                [HttpClient createaAlertWithMsg:@"Sorry u r email id is wrong" andTitle:@""];
//            }
//            
//            break;
//        case 10:
//            
//            if ([textField.text isEqualToString:@""]) {
//                [HttpClient createaAlertWithMsg:@"Please enter Mobile No " andTitle:@""];
//            }
//            else if ([textField.text length]<5 || [textField.text length]>15){
//                [HttpClient createaAlertWithMsg:@"Please enter valid Mobile No" andTitle:@""];
//            }
//            else{
//                if (isAddClicked) {
//                    [_address_new_dict setValue:textField.text forKey:@"phone"];
//                }
//                else{
//                    [_edit_addr_dict setValue:textField.text forKey:@"phone"];
//                }            }
//           
//            break;
//        default:
//            break;
//    }
    
    
    
    
    if (textField.tag == 6) {
        
        textField.text = state_selection;
//                if ([textField.text isEqualToString:@""]) {
//                [HttpClient createaAlertWithMsg:@"Please select state " andTitle:@""];
//        }
        
    }
    if (textField.tag == 8) {
        
        
        textField.text = cntry_selection;
        
        
        if (textField == _TXT_country) {
            _TXT_state.placeholder = @"select State";

        }
        if (textField == _TXT_ship_country) {
             _TXT_ship_state.placeholder = @"select State";
        }
        
        if ([textField.text isEqualToString:@""]) {
            [HttpClient createaAlertWithMsg:@"Please Select Country " andTitle:@""];
       }
          //  else{
//            if (isAddClicked) {
//                [_address_new_dict setValue:textField.text forKey:@"country"];
//            }
//            else{
//                [_edit_addr_dict setValue:textField.text forKey:@"country"];
//            }
//        }
//
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
    
    
    int charge_ship = 0;
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
    
    //Product Summary View setting Ship Charge
    self.LBL_shipping_charge.text = [NSString stringWithFormat:@"%@ %d",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],charge_ship];
    
    NSLog(@"charge for all products%d %@",charge_ship,date_time_merId_Arr);
}

#pragma mark order_detail_API_call

-(void)order_detail_API_call
{
    @try {
        
        date_time_merId_Arr = [NSMutableArray array];
        jsonresponse_dic  = [[NSMutableDictionary alloc]init];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
        
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/orderdetailsapi/%@/%@/%@.json",SERVER_URL,user_id,country,languge];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        
                        VW_overlay.hidden = YES;
                        [activityIndicatorView stopAnimating];
                        if (data) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self cart_count];
                            });
                            
                            
                            
                            @try {
                                if ([data isKindOfClass:[NSDictionary class]]) {
                                    jsonresponse_dic = data;
                                    
                                    [self set_UP_VIEW];
                                    [self set_data_to_product_Summary_View];
                                    NSLog(@"order_detail_API Response:::%@*********",data);
                                    [self filtering_MerchantId];
                                    [_TBL_orders reloadData];
                                    [self Shipp_address_API];
                                    [self cart_count];
                                    VW_overlay.hidden = YES;
                                    [activityIndicatorView stopAnimating];
                                    
                                }
                                else{
                                    [HttpClient createaAlertWithMsg:@"The Data could not be read It is not in correct format" andTitle:@""];
                                    VW_overlay.hidden = YES;
                                    [activityIndicatorView stopAnimating];
                                }
                                
                            } @catch (NSException *exception) {
                                NSLog(@"%@",exception);
                                VW_overlay.hidden = YES;
                                [activityIndicatorView stopAnimating];
                                
                            }
                        }
                        
                        
                        
                    }
                    
                });
                
            }];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
            VW_overlay.hidden = YES;
            [activityIndicatorView stopAnimating];
        }
        
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}

#pragma mark Shipp_address_API_Call

-(void)Shipp_address_API
{
    @try {
        
        jsonresponse_dic_address = [[NSMutableDictionary alloc]init];
        
        isAddClicked = NO;
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
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        
                        VW_overlay.hidden = YES;
                        [activityIndicatorView stopAnimating];
                        
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
            NSLog(@"%@",exception);
        }
        
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}


#pragma mark updating_cart_API
/*
 Update cart
 apis/updatecartapi.json
 Parameters :
 
 quantity,
 productId,
 customerId
 
 Method : POST
 */

-(void)updating_cart_List_api{
    
    
    @try {
        
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *custmr_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
        
        NSDictionary *parameters = @{@"productId":product_id,@"customerId":custmr_id,@"subttl":item_count,@"merchantId":merchent_id};
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/updateqtycheckoutapi.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        
        [HttpClient api_with_post_params:urlGetuser andParams:parameters completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    NSLog(@"%@",data);
                    
                    
                    @try {
                        [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                        [self order_detail_API_call];
                        
                    } @catch (NSException *exception) {
                        NSLog(@"exception:: %@",exception);
                    }
                    
                    
                }
                
            });
            
        }];
    } @catch (NSException *exception) {
        
        NSLog(@"%@",exception);
    }
    
}
#pragma mark  cart_count_api

-(void)cart_count{
    @try {
        NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
        [HttpClient cart_count:user_id completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            if (error) {
                [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
                 ];
            }
            if (data) {
                NSLog(@"%@",data);
                @try {
                    NSString *badge_value = [NSString stringWithFormat:@"%@",[data valueForKey:@"cartcount"]];
                    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"language_id"] == 2) {
                        
                        if(badge_value.length > 2)
                        {
                            self.navigationItem.leftBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
                            
                        }
                        else{
                            self.navigationItem.leftBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
                            
                        }
                    }
                    else{
                        if(badge_value.length > 2)
                        {
                            self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
                            
                        }
                        else{
                            self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
                            
                        }
                    }
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                }
                
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        
    }
    
}
#pragma mark Delivary_slot_API

-(void)delivary_slot_API{
    @try {
        delivary_slot_dic = [[NSMutableDictionary alloc]init];
        picker_Arr = [NSMutableArray array];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/deliveryslotapi.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
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
                    
                    
                }
                
            });
        }];
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
}
#pragma mark CountryAPI Call
//http://192.168.0.171/dohasooq/'apis/countriesapi.json
-(void)CountryAPICall{
    @try {
        response_countries_dic = [NSMutableDictionary dictionary];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/countriesapi.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        @try {
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                [response_countries_dic addEntriesFromDictionary:data];
                                [response_picker_arr removeAllObjects];
                                //[response_picker_arr addObjectsFromArray:[response_countries_dic allKeys]]
                                for (int x=0; x<[[response_countries_dic allKeys] count]; x++) {
                                    NSDictionary *dic = @{@"cntry_id":[[response_countries_dic allKeys] objectAtIndex:x],@"cntry_name":[response_countries_dic valueForKey:[[response_countries_dic allKeys] objectAtIndex:x]]};
                                    
                                    [response_picker_arr addObject:dic];
                                }
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
                    
                });
                
            }];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    
}



#pragma mark StateAPI Call

//http://192.168.0.171/dohasooq/'apis/getstatebyconapi/countryid.json
-(void)stateApiCall{
    
    @try {
        arr_states = [NSMutableArray array];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/getstatebyconapi/%ld.json",SERVER_URL,(long)cntry_ID];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
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
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    
}




#pragma mark UIPickerViewDelegate and UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (pickerView == _staes_country_pickr) {
        return response_picker_arr.count;
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
    else{
        
        return [picker_Arr objectAtIndex:row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerView == _pickerView) {
        
        if (is_Txt_date) {
            _TXT_Date.text = [picker_Arr objectAtIndex:row];
            date_str = [NSString stringWithFormat:@"%@",[slot_keys_arr objectAtIndex:row]];
            
        }
        else{
            _TXT_Time.text = [picker_Arr objectAtIndex:row];
            time_str = [NSString stringWithFormat:@"%@",[slot_keys_arr objectAtIndex:row]];
            
        }
    }
    if (pickerView == _staes_country_pickr) {
        
        if (isCountrySelected) {
            @try {
                
                cntry_selection = [[response_picker_arr objectAtIndex:row] valueForKey:@"cntry_name"];
                    cntry_ID = [[[response_picker_arr objectAtIndex:row] valueForKey:@"cntry_id"] integerValue];
                state_selection = @"";
                
                if (select_blng_ctry_state) {
                    blng_cntry_ID = [[response_picker_arr objectAtIndex:row] valueForKey:@"cntry_id"];
                }
                else{
                    ship_cntry_ID = [[response_picker_arr objectAtIndex:row] valueForKey:@"cntry_id"];
                }
                
                
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
        else{
            @try {
                state_selection = [[response_picker_arr objectAtIndex:row] valueForKey:@"value"];
                
                if (select_blng_ctry_state) {
                    blng_cntry_ID = [[response_picker_arr objectAtIndex:row] valueForKey:@"key"];
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

#pragma mark Payment method API Types

-(void)payment_methods_API{
    
    @try {
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/paymentmethapi.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        @try {
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                NSLog(@"Payment Methods %@",data);
                                
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
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
}

#pragma mark Apply apply_promo_Code  API
/*Applycoupon
 Function Name : apis/applycouponapi.json
 Parameters :customerId,couponcode,subtotal
 Method : GET*/
-(void)apply_promo_Code{
    
    
    @try {
        
        NSString *sub_total = [NSString stringWithFormat:@"%@",[jsonresponse_dic valueForKey:@"subsum"]];
        sub_total = [sub_total stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
        
        NSString *prome_value = [NSString stringWithFormat:@"%@",self.TXT_cupon.text];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/applycouponapi/%@/%@/%@.json",SERVER_URL, [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"],prome_value,sub_total];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
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
            NSLog(@"%@",exception);
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    
}

#pragma mark validatingTextField

-(void)validatingTextField
{
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        NSString *msg;
  
    NSString *text_to_compare_email = _TXT_email.text;
       
       if ([_TXT_fname.text isEqualToString:@""])
       {
           [_TXT_fname becomeFirstResponder];
           msg = @"Please enter First Name field";
           
       }
       else if(_TXT_fname.text.length < 3 )
       {
           [_TXT_fname becomeFirstResponder];
           msg = @"First name should not be less than 3 characters";
           
       }
       else if([_TXT_fname.text isEqualToString:@" "])
       {
           [_TXT_fname becomeFirstResponder];
           msg = @"Blank space are not allowed";
           
       }
       else if ([_TXT_lname.text isEqualToString:@""])
       {
           [_TXT_lname becomeFirstResponder];
           msg = @"Please enter Last Name field";
           
       }
       else if(_TXT_lname.text.length < 1)
       {
           [_TXT_lname becomeFirstResponder];
           msg = @"Last name should not be less than 1 character";
           
           
       }
       else if([_TXT_lname.text isEqualToString:@" "])
       {
           [_TXT_lname becomeFirstResponder];
           msg = @"Blank space are not allowed";
           
           
       }
       else if(_TXT_addr1.text.length < 1)
       {
           [_TXT_addr1 becomeFirstResponder];
           msg = @"Address name should not be less than 1 character";
           
           
       }
       else if([_TXT_addr1.text isEqualToString:@" "])
       {
           [_TXT_addr1 becomeFirstResponder];
           msg = @"Blank space are not allowed";
       }
       else if(_TXT_addr1.text.length > 256)
       {
           [_TXT_addr1 becomeFirstResponder];
           msg = @"Address name should not be greater than 256 character";
           
           
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
       


       else if([_TXT_email.text isEqualToString:@""])
       {
           [_TXT_email becomeFirstResponder];
           msg = @"Please enter Email";
           
       }
       
       else if([emailTest evaluateWithObject:text_to_compare_email] == NO)
       {
           [_TXT_email becomeFirstResponder];
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
       else if([_TXT_city.text isEqualToString:@""])
       {
           [_TXT_city becomeFirstResponder];
           msg = @"Please enter city";
           
           
       }
       else if (_TXT_city.text.length < 1)
       {
           [_TXT_city becomeFirstResponder];
          msg = @"Blank space are not allowed";
           
       }
       else if([_TXT_state.text isEqualToString:@""])
       {
           [_TXT_state becomeFirstResponder];
           msg = @"Please enter state";
           
           
       }
       else if (_TXT_state.text.length < 1)
       {
           [_TXT_state becomeFirstResponder];
           msg = @"Blank space are not allowed";
           
           
           
       }
       else if([_TXT_country.text isEqualToString:@""])
       {
           [_TXT_country becomeFirstResponder];
           msg = @"Please enter country";
           
           
       }
       else if (_TXT_country.text.length < 1)
       {
           [_TXT_country becomeFirstResponder];
           msg = @"Blank space are not allowed";
           
           
           
       }
       else if([_TXT_zip.text isEqualToString:@""])
       {
           [_TXT_zip becomeFirstResponder];
           msg = @"Please enter Zip code";
           
           
       }
       else if (_TXT_zip.text.length < 1)
       {
           [_TXT_zip becomeFirstResponder];
           msg = @"Blank space are not allowed";
       }
       
  
      if(  _VW_SHIIPING_ADDRESS.hidden == NO)
    {
        NSString *text_to_compare_email = _TXT_ship_email.text;
        
        if ([_TXT_ship_fname.text isEqualToString:@""])
        {
            [_TXT_ship_fname becomeFirstResponder];
            msg = @"Please enter First Name field";
            
        }
        else if(_TXT_ship_fname.text.length < 3)
        {
            [_TXT_ship_fname becomeFirstResponder];
            msg = @"First name should not be less than 3 characters";
            
        }
        else if([_TXT_ship_fname.text isEqualToString:@" "])
        {
            [_TXT_ship_fname becomeFirstResponder];
            msg = @"Blank space are not allowed";
            
        }
        else if ([_TXT_ship_lname.text isEqualToString:@""])
        {
            [_TXT_ship_lname becomeFirstResponder];
            msg = @"Please enter Last Name field";
            
        }
        else if(_TXT_ship_lname.text.length < 1)
        {
            [_TXT_ship_lname becomeFirstResponder];
            msg = @"Last name should not be less than 1 character";
            
            
        }
        else if([_TXT_ship_lname.text isEqualToString:@" "])
        {
            [_TXT_ship_lname becomeFirstResponder];
            msg = @"Blank space are not allowed";
            
            
        }
        else if(_TXT_ship_addr1.text.length < 1)
        {
            [_TXT_ship_addr1 becomeFirstResponder];
            msg = @"Address name should not be less than 1 character";
            
            
        }
        else if([_TXT_ship_addr1.text isEqualToString:@" "])
        {
            [_TXT_ship_addr1 becomeFirstResponder];
            msg = @"Blank space are not allowed";
        }
        else if(_TXT_ship_addr1.text.length > 256)
        {
            [_TXT_ship_addr1 becomeFirstResponder];
            msg = @"Address name should not be greater than 256 character";
            
            
        }
        
        else if(_TXT_ship_addr2.text.length < 1)
        {
            [_TXT_ship_addr2 becomeFirstResponder];
            msg = @"Address name should not be less than 1 character";
            
            
        }
        else if(_TXT_ship_addr2.text.length > 256)
        {
            [_TXT_ship_addr2 becomeFirstResponder];
            msg = @"Address name should not be greater than 256 character";
            
            
        }
        else if([_TXT_ship_addr2.text isEqualToString:@" "])
        {
            [_TXT_ship_addr2 becomeFirstResponder];
            msg = @"Blank space are not allowed";
        }
        
        
        
        else if([_TXT_ship_email.text isEqualToString:@""])
        {
            [_TXT_ship_email becomeFirstResponder];
            msg = @"Please enter Email";
            
        }
        
        else if([emailTest evaluateWithObject:text_to_compare_email] == NO)
        {
            [_TXT_ship_email becomeFirstResponder];
            msg = @"Please enter valid email address";
            
            
            
        }
        else if ([_TXT_ship_phone.text isEqualToString:@""])
        {
            [_TXT_ship_phone becomeFirstResponder];
            msg = @"Please enter Phone Number";
            
            
            
        }
        
        else if (_TXT_ship_phone.text.length < 5)
        {
            [_TXT_ship_phone becomeFirstResponder];
            msg = @"Phone Number cannot be less than 5 digits";
            
            
            
        }
        else if(_TXT_ship_phone.text.length>15)
        {
            [_TXT_ship_phone becomeFirstResponder];
            msg = @"Phone Number should not be more than 15 characters";
            
            
        }
        else if([_TXT_ship_phone.text isEqualToString:@" "])
        {
            [_TXT_ship_phone becomeFirstResponder];
            msg = @"Blank space are not allowed";
            
            
        }
        else if([_TXT_ship_city.text isEqualToString:@""])
        {
            [_TXT_ship_city becomeFirstResponder];
            msg = @"Please enter city";
            
            
        }
        else if (_TXT_ship_city.text.length < 1)
        {
            [_TXT_ship_city becomeFirstResponder];
            msg = @"Blank space are not allowed";
            
        }
        else if([_TXT_ship_state.text isEqualToString:@""])
        {
            [_TXT_ship_state becomeFirstResponder];
            msg = @"Please enter state";
            
            
        }
        else if (_TXT_ship_state.text.length < 1)
        {
            [_TXT_ship_state becomeFirstResponder];
            msg = @"Blank space are not allowed";
            
            
            
        }
        else if([_TXT_ship_country.text isEqualToString:@""])
        {
            [_TXT_ship_country becomeFirstResponder];
            msg = @"Please enter country";
            
            
        }
        else if (_TXT_ship_country.text.length < 1)
        {
            [_TXT_ship_country becomeFirstResponder];
            msg = @"Blank space are not allowed";
            
            
            
        }
        else if([_TXT_ship_zip.text isEqualToString:@""])
        {
            [_TXT_ship_zip becomeFirstResponder];
            msg = @"Please enter Zip code";
            
            
        }
        else if (_TXT_ship_zip.text.length < 1)
        {
            [_TXT_ship_zip becomeFirstResponder];
            msg = @"Blank space are not allowed";
        }

            }
    if(msg)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        //[alert show];
        [HttpClient createaAlertWithMsg:msg andTitle:@""];
        
    }
    

    else{
        // checking billing a nd shippindg address are valid or not
        
        if (self.VW_SHIIPING_ADDRESS.hidden == NO ) {
           
        [self checking_address:_TXT_zip.text];
            
       // [self checking_shipping_address_zipcode:_TXT_ship_zip.text];
            
        }
        else{
            
         [self checking_address:_TXT_zip.text];
        
        }
     
        
        }

}

#pragma mark radioButton Actions
// Payment Type Radio Buttons Setting
-(void)credit_cerd_action
{
    payment_type_str = @"1";
    if(_BTN_credit.tag == 1)
    {
        [_BTN_credit setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_cod setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_credit.tag = 0;
        
    }
    else
    {
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
    payment_type_str = @"2";
    
    if(_BTN_debit_card.tag == 1)
    {
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_credit setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_cod setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_debit_card.tag = 0;
        
    }
    else
    {
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
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_credit setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_cod setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_doha_bank_account.tag = 0;
        
    }
    else
    {
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
    payment_type_str = @"4";
    if(_BTN_doha_miles.tag == 1)
    {
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_credit setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_cod setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_doha_miles.tag = 0;
        
    }
    else
    {
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
    payment_type_str = @"5";
    if(_BTN_cod.tag == 1)
    {
        [_BTN_cod setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_credit setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        _BTN_cod.tag = 0;
        
    }
    else
    {
        [_BTN_cod setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        _BTN_cod.tag = 1;
        _BTN_doha_miles.tag = 1;
        _BTN_doha_bank_account.tag = 1;
        _BTN_debit_card.tag = 1;
        _BTN_credit.tag = 1;
        
    }

}

#pragma mark address checking
/* http://maps.google.com/maps/api/geocode/json?address="+s_user_zip_code+"&sensor=false
 
 [3:48 PM] Saurabh:
  
     
 
 in.putExtra("b_user_firstname", user_firstname);
         in.putExtra("b_user_lastname", user_lastname);
         in.putExtra("b_user_address1", user_address1);
         in.putExtra("b_user_address2", user_address2);
         in.putExtra("b_user_city", user_city);
         in.putExtra("b_user_zip_code", user_zip_code);
         in.putExtra("b_user_phone", user_phone);
         in.putExtra("b_user_country", user_countrys);
         in.putExtra("b_user_state", user_state);
 
 in.putExtra("s_user_firstname", user_firstname1);
         in.putExtra("s_user_lastname", user_lastname1);
         in.putExtra("s_user_address1", user_address11);
         in.putExtra("s_user_address2", user_address21);
         in.putExtra("s_user_city", user_city1);
         in.putExtra("s_user_zip_code", user_zip_code1);
         in.putExtra("s_user_phone", user_phone1);
         in.putExtra("s_user_country", user_countrys1);
         in.putExtra("s_user_state", user_state1);
         in.putExtra("check", sameas_billing);
 
 
         in.putExtra("day",day);
         in.putExtra("time",time);
         in.putExtra("charge",charge);
         in.putExtra("picmethod",picmethod);
         in.putExtra("shipmethod",shipmethod);
         in.putExtra("sub_sub_of_product",sub_sub_of_product);
         in.putExtra("codflag",codflag);
 
 */
-(void)checking_address:(NSString *)zip_Code{
    
    @try {
    
        //http://maps.google.com/maps/api/geocode/json?address="+s_user_zip_code+"&sensor=false
        
        //zip_codeDic = [[NSMutableDictionary alloc]init];
        NSLog(@".......%@",zip_Code);
        NSString *urlGetuser =[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=%@&sensor=false",zip_Code];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSLog(@"%@",urlGetuser);
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                
                        NSLog(@"datatttt  ::%@",data);
                        
                        
                        @try {
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                
                                //zip_codeDic = data;
                                
                                
                                
                                if (self.VW_SHIIPING_ADDRESS.hidden == YES && [[data valueForKey:@"status"] isEqualToString:@"OK"]) {
                                    
                                    
                                     billiinglatlog_dic = [[[[data valueForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"];
                                    NSLog(@"billing lat and lan %@",[[[[data valueForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"]);
                                    
                                    
                                    shippinglatlog_dic = [[[[data valueForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"];
                                    NSLog(@"billing lat and lan %@",[[[[data valueForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"]);
                                   
                                    [self move_to_payment_types];
                                }
                                else if (self.VW_SHIIPING_ADDRESS.hidden == NO && [[data valueForKey:@"status"] isEqualToString:@"OK"])
                                {
                                    billiinglatlog_dic = [[[[data valueForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"];
                                 [self checking_shipping_address_zipcode:_TXT_ship_zip.text];
                                
                                }
                                
                                else{
                                    [HttpClient createaAlertWithMsg:@"Please enter valid zipcode in Billingaddress" andTitle:@""];
                                }
                                
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }

                       
                        
                    }
                    
                });
                
            }];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];

    
}

-(void)checking_shipping_address_zipcode:(NSString *)zip_Code{
    
    @try {
        
        
        //http://maps.google.com/maps/api/geocode/json?address="+s_user_zip_code+"&sensor=false
        
        
        NSLog(@".......%@",zip_Code);
        NSString *urlGetuser =[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=%@&sensor=false",zip_Code];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSLog(@"%@",urlGetuser);
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        
                        @try {
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                
                                if ([[data valueForKey:@"status"] isEqualToString:@"OK"]) {
                                    
                                    
                                    shippinglatlog_dic = [[[[data valueForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"];
                                    
                                     NSLog(@"shipping lat and lan %@",[[[[data valueForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"]);
                                    
                                    [self move_to_payment_types];
                                }
                                else{
                                    [HttpClient createaAlertWithMsg:@"please enter valid zip_code in shipping address" andTitle:@""];
                                }
                                
                                
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        
                        
                    }
                    
                });
                
            }];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
  }

#pragma mark Place Order API Integration
-(void)place_oredr_API{
    @try {
        
   
   NSString *ctry_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    
     NSMutableArray *form_arr = [NSMutableArray array];
        
    NSString *sub_total = [NSString stringWithFormat:@"%@",[jsonresponse_dic valueForKey:@"subsum"]];
        sub_total = [sub_total stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
        
        NSDictionary *Formpaymenthidden;
        @try {
             Formpaymenthidden = @{@"amount":sub_total,@"locale":@"en",@"version":@"1"};
        } @catch (NSException *exception) {
            
        }
        [form_arr removeAllObjects];
        [form_arr addObject:Formpaymenthidden];
        NSString * Formpaymenthidden_str = [form_arr componentsJoinedByString:@","];

        
        
   
        
     
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
        
        
        
        NSString *fname,*lname,*addr1,*addr2,*city,*state,*zip_code,*country,*phone;
        
        fname =_TXT_fname.text;
        lname = _TXT_lname.text;
        addr1 =_TXT_addr1.text;
        addr2 = _TXT_addr2.text;
        city =_TXT_city.text;
        state = blng_state_ID;
        zip_code = _TXT_zip.text;
        country = blng_cntry_ID;
        phone = _TXT_phone.text;
    
        
        NSDictionary *FormBilling;
        @try {
            FormBilling = @{@"FirstName":fname,@"LastName":lname,@"address1":addr1,@"address2":addr2,@"city":city,@"state":state,@"country":country,@"phone":phone,@"zipcode":zip_code,@"userId":[[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"]};
        } @catch (NSException *exception) {
            
        }
        [form_arr removeAllObjects];
        [form_arr addObject:FormBilling];
        NSString * form_billing_str = [form_arr componentsJoinedByString:@","];

        
        
          NSString *sfname,*slname,*saddr1,*saddr2,*scity,*sstate,*szip_code,*scountry,*sphone;
        
        sfname =_TXT_ship_fname.text;
        slname = _TXT_ship_lname.text;
        saddr1 =_TXT_ship_addr1.text;
        saddr2 = _TXT_ship_addr2.text;
        scity =_TXT_ship_city.text;
        sstate = ship_state_ID;
        szip_code = _TXT_zip.text;
        scountry = ship_cntry_ID;
        sphone = _TXT_ship_phone.text;
//        NSMutableArray *Formshipping_arr = [[NSMutableArray alloc]init];
        NSDictionary *Formshipping;
        if ([billcheck_clicked isEqualToString:@"0"]) {
            
            
            @try {
              
                 Formshipping = @{@"FirstName1":fname,@"LastName1":lname,@"address11":addr1,@"address12":addr2,@"city1":city,@"state":state,@"country":country,@"phone1":phone,@"zipcode1":zip_code};
            } @catch (NSException *exception) {
                
            }
            
        }
        else{
            
            @try {
                 Formshipping = @{@"FirstName1":sfname,@"LastName1":slname,@"address11":saddr1,@"address12":saddr2,@"city1":scity,@"state":sstate,@"country":scountry,@"phone1":sphone,@"zipcode1":szip_code};
            } @catch (NSException *exception) {
                
            }
            
           
            
        }
        [form_arr removeAllObjects];
          [form_arr addObject:Formshipping];
        
        NSString *form_shipping_str = [form_arr componentsJoinedByString:@","];
       
        
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
        [form_arr removeAllObjects];
        [form_arr addObject:FormpickupMethod];
        NSString *FormpickupMethod_str = [form_arr componentsJoinedByString:@","];
        
        
        NSDictionary *FormPayment = @{@"paymenttype":payment_type_str};
        [form_arr removeAllObjects];
        [form_arr addObject:FormPayment];
        NSString *FormPayment_str = [form_arr componentsJoinedByString:@","];
        
        
        //hot coding "payment_type_str"
        NSDictionary  *FormshipMethod = @{@"charge":shiip_charge,@"shipmethod":ship_method};
        [form_arr removeAllObjects];
        [form_arr addObject:FormshipMethod];
        NSString *FormshipMethod_str = [form_arr componentsJoinedByString:@","];
        
        
        NSDictionary *FormDeliverySlot = @{@"deliveydate":deliveydate,@"deliveytime":deliveytime};
        [form_arr removeAllObjects];
        [form_arr addObject:FormDeliverySlot];
        NSString *FormDeliverySlot_str = [form_arr componentsJoinedByString:@","];
        
        
        NSDictionary *FormSameasBilling = @{@"check":billcheck_clicked};
        [form_arr removeAllObjects];
        [form_arr addObject:FormSameasBilling];
        NSString *FormSameasBilling_str = [form_arr componentsJoinedByString:@","];
        
        
        NSDictionary *Formcouponcode = @{@"couponcode":@""};
        [form_arr removeAllObjects];
        [form_arr addObject:Formcouponcode];
        NSString *Formcouponcode_str = [form_arr componentsJoinedByString:@","];
        
        
        
        [form_arr removeAllObjects];
        [form_arr addObject:shippinglatlog_dic];
        NSString *shippinglatlog_str = [form_arr componentsJoinedByString:@","];
        
        
        
        [form_arr removeAllObjects];
        [form_arr addObject:billiinglatlog_dic];
        NSString *billiinglatlog_str = [form_arr componentsJoinedByString:@","];

        
        NSDictionary *params;

        @try {
            
            
            
             params = @{@"countryId":ctry_id,@"Formpaymenthidden":FormPayment_str,@"FormpickupMethod":FormpickupMethod_str,@"FormPayment":FormPayment_str,@"Formshipping":form_shipping_str,@"FormshipMethod":FormshipMethod_str,@"FormBilling":form_billing_str,@"billinglatlog":billiinglatlog_str,@"FormDeliverySlot":FormDeliverySlot_str,@"FormSameasBilling":FormSameasBilling_str,@"shippinglatlog":shippinglatlog_str,@"Formcouponcode":Formcouponcode_str};
            
            
            
            
            
//             params = @{@"countryId":ctry_id,@"Formpaymenthidden":Formpaymenthidden,@"FormpickupMethod":FormpickupMethod,@"FormPayment":FormPayment,@"Formshipping":form_shipping_str,@"FormshipMethod":FormshipMethod,@"FormBilling":form_billing_str,@"billinglatlog":billiinglatlog_dic,@"FormDeliverySlot":FormDeliverySlot,@"FormSameasBilling":FormSameasBilling,@"shippinglatlog":shippinglatlog_dic,@"Formcouponcode":Formcouponcode};
            
            
        } @catch (NSException *exception) {
            NSLog(@"Some values are missing in dic");
            NSLog(@"%@",exception);
        }
        
        NSLog(@"%@",params);
        
        
       // NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/placeorderapi.json",SERVER_URL];
    
        @try
        {
            
            NSString *urlString =[NSString stringWithFormat:@"%@apis/placeorderapi.json",SERVER_URL];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
           // [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            NSMutableData *body = [NSMutableData data];
            //    [request setHTTPBody:body];
            
            
            
            
            // FormBilling
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"FormBilling\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",form_billing_str]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            // Formshipping
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Formshipping\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",form_shipping_str]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            //FormPayment
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"FormPayment\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",FormPayment_str]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            //FormSameasBilling
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"FormSameasBilling\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",FormSameasBilling_str]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

            
            //FormshipMethod
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"FormshipMethod\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",FormshipMethod_str]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            
            //Formcouponcode
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Formcouponcode\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",Formcouponcode_str]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

            
            //FormpickupMethod
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"FormpickupMethod\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",FormpickupMethod_str]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

            
            
            //FormDeliverySlot
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"FormDeliverySlot\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",FormDeliverySlot_str]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            
            
            //Formpaymenthidden
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Formpaymenthidden\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",Formpaymenthidden_str]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];


            
            
            //billinglatlog
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"billinglatlog\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",billiinglatlog_str]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            
            //shippinglatlog
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"shippinglatlog\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",shippinglatlog_str]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            
            
            //countryId
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"countryId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",ctry_id]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

            
                        NSError *er;
            //    NSHTTPURLResponse *response = nil;
            
            // close form
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // set request body
            [request setHTTPBody:body];
            
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            
            if (returnData) {
                
                NSLog(@"returnData :: %@",returnData);
                           // json_DATA = [[NSMutableDictionary alloc]init];
                id            json_DATA = (id )[NSJSONSerialization JSONObjectWithData:returnData options:NSASCIIStringEncoding error:&er];
                
                if (er) {
                    NSLog(@"er:%@",[er localizedDescription]);
                }
                
                     NSLog(@"%@", [NSString stringWithFormat:@"JSON DATA OF ORDER DETAIL: %@", json_DATA]);
                //            dispatch_async(dispatch_get_main_queue(), ^{
                //                [self.TBL_orders reloadData];
                
                // });
                
                
            }
            
        }
        @catch(NSException *exception)
        {
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;
            NSLog(@"THE EXception:%@",exception);
            
        }

        
        
        
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}




/*-(void)orders_LIST_Detail
{
    @try
    {
       
        
        
        NSString *urlString =[NSString stringWithFormat:@"%@Apis/orderviewapi.json",SERVER_URL];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        //    [request setHTTPBody:body];
        
        
        
        
        // text parameter
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"customerId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
        [body appendData:[[NSString stringWithFormat:@"%@",user_id]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // another text parameter
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"orderId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",ORDER_ID]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        
        
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"langId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",languge]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        
        //    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //    [body appendData:[[NSString stringWithFormat:@"%@",GET_prof_ID]dataUsingEncoding:NSUTF8StringEncoding]];
        //    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        //
        //
        //    NSData *webData = UIImageJPEGRepresentation(_img_Profile.image, 100);
        //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //    NSString *documentsDirectory = [paths objectAtIndex:0];//@"sample.png"
        //    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[self randomStringWithLength:7]]];
        //    [webData writeToFile:localFilePath atomically:YES];
        //    NSLog(@"localFilePath.%@",localFilePath);
        //
        //    [[NSUserDefaults standardUserDefaults]setValue:localFilePath forKey:@"new_PP"];
        //    [[NSUserDefaults standardUserDefaults]synchronize];
        //
        //    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: multipart/form-data; name=\"uploaded_file\"; filename=\"%@\"\r\n",localFilePath] dataUsingEncoding:NSUTF8StringEncoding]];
        //    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        //    [body appendData:[NSData dataWithData:imageData]];
        //    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //
        NSError *er;
        //    NSHTTPURLResponse *response = nil;
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        if (returnData) {
        
//            json_DATA = [[NSMutableDictionary alloc]init];
//            json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:returnData options:NSASCIIStringEncoding error:&er];
//            NSLog(@"%@", [NSString stringWithFormat:@"JSON DATA OF ORDER DETAIL: %@", json_DATA]);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.TBL_orders reloadData];
            
           // });
            
            
        }
        
    }
    @catch(NSException *exception)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        NSLog(@"THE EXception:%@",exception);
        
    }
    
}
*/

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     VC_DS_Checkout *check_out_cntroller = [segue destinationViewController];
    
 }
-(void)close_ACTION
{
    VW_overlay.hidden = YES;
    _VW_delivery_slot.hidden = YES;
}

@end
