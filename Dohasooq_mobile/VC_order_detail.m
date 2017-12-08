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
#import "billing_address.h"
#import "pay_cell.h"
#import "HttpClient.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface VC_order_detail ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDataSource, UICollectionViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

{
    NSMutableArray *arr_product,*stat_arr,*reload_section,*date_time_merId_Arr,*arr_states,*picker_Arr,*response_picker_arr;
    NSString *TXT_count, *product_id,*item_count;
    int i,j;
    NSInteger edit_tag,cntry_ID,st_ID;
    NSMutableArray  *temp_arr;
    BOOL isfirstTimeTransform,isAddClicked,is_Txt_date,isCountrySelected,orderCheckSelected;;
    float scroll_height;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSMutableDictionary *jsonresponse_dic,*jsonresponse_dic_address,*delivary_slot_dic,*response_countries_dic;
    NSString *merchent_id,*date_str,*time_str;  //for payment parameters
    NSArray *slot_keys_arr; // time_slot keys for  PickerView
    UIToolbar *accessoryView;
    
    NSString *cntry_selection,*state_selection;//*selection_str,
    
    
    
}
@property(nonatomic,strong) NSMutableDictionary *data_dict;

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
    VW_overlay.hidden = YES;
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self cart_count];
    [self performSelector:@selector(order_detail_API_call) withObject:activityIndicatorView afterDelay:0.01];
    [self Shipp_address_API];
    
    response_picker_arr = [NSMutableArray array];
    
    
}
-(void)set_UP_VIEW
{
    
    isfirstTimeTransform = YES;
    
    _LBL_stat.tag = 0;
    
    _data_dict = [[NSMutableDictionary alloc]init]; // for paramaters
    
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
    NSString *badge_value = @"25";
    
    
    if(badge_value.length > 2)
    {
        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
        
    }
    else{
        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
        
    }
    
    
    
    
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
    //
    //    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(picker_done_btn_action:)];
    //
    //    [accessoryView setItems:[NSArray arrayWithObject:doneButton]];
    //    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
    //                                        [UIFont fontWithName:@"Poppins-Regular" size:20.0], NSFontAttributeName,
    //                                        [UIColor whiteColor], NSForegroundColorAttributeName,
    //                                        nil] forState:UIControlStateNormal];
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(accessoryView.frame.size.width - 100, 0, 100, accessoryView.frame.size.height);
    [close setTitle:@"DONE" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(picker_done_btn_action:) forControlEvents:UIControlEventTouchUpInside];
    [accessoryView addSubview:close];
    
    _TXT_Time.inputAccessoryView = accessoryView;
    _TXT_Date.inputAccessoryView = accessoryView;
    
    
    [_BTN_next addTarget:self action:@selector(next_page) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_Product_summary addTarget:self action:@selector(product_clicked) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_done addTarget:self action:@selector(deliveryslot_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_check addTarget:self action:@selector(BTN_check_clickd) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
-(void)set_data_to_product_Summary_View{
    
    NSString *sub_total = [NSString stringWithFormat:@"%@",[jsonresponse_dic valueForKey:@"subsum"]];
    sub_total = [sub_total stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
    _LBL_sub_total.text = [NSString stringWithFormat:@"QAR %@",sub_total];
    NSString *shippijng_charge = [NSString stringWithFormat:@"%@",[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:@"1"]];
    shippijng_charge = [shippijng_charge stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
    
    int total = [sub_total intValue]+ [shippijng_charge  intValue];
    //_LBL_total.text = [NSString stringWithFormat:@"QAR %d",total];
    
    NSString *qr = @"QR";
    NSString *price =[NSString stringWithFormat:@"%d",total];
    
    NSString *text = [NSString stringWithFormat:@"%@ %@",qr,price];
    if ([_LBL_product_summary respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_product_summary.textColor,
                                  NSFontAttributeName:_LBL_product_summary.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
        
        
        NSRange ename = [text rangeOfString:qr];
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
    
    
    NSString *current_price = [NSString stringWithFormat:@"QR"];
    NSString *prec_price = [NSString stringWithFormat:@"%d",total];
    NSString *summary_text = [NSString stringWithFormat:@"%@ %@",current_price,prec_price];
    
    if ([_LBL_total respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_total.textColor,
                                  NSFontAttributeName:_LBL_total.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:summary_text attributes:attribs];
        
        
        
        NSRange ename = [summary_text rangeOfString:current_price];
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
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_card layoutIfNeeded];
    _Scroll_card.contentSize = CGSizeMake(_Scroll_card.frame.size.width,scroll_height);
}
#pragma tableview delagates
#pragma tableview delagates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    @try {
        if(tableView == _TBL_address)
        {
            return i;
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
            if(section == 1)
            {
                
                if([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]])
                {
                    NSArray *keys_arr = [[jsonresponse_dic_address valueForKey:@"shipaddress"] allKeys];
                    ct = keys_arr.count;
                    
                    
                }
                else{
                    ct = 1;  ////
                    
                }
                
                
                
                
                return ct;
            }
            else
            {
                return 1;
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *identifier_order,*identifier_shipping,*identifier_billing;
    NSInteger index;
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        identifier_billing = @"Qbilling_address";
        identifier_order = @"Qorder_cell";
        identifier_shipping = @"Qshipping_cell";
        index = 1;
        
    }
    else{
        
        identifier_billing = @"billing_address";
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
        
        
        NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
        if(indexPath.row == totalRow -1){
            
            cell.LBL_charge.hidden = NO;
            cell.LBL_stat.hidden = NO;
            cell.BTN_stat.hidden = NO;
            cell.BTN_calendar.hidden =NO;
            
        }
        else{
            cell.LBL_charge.hidden = YES;
            cell.LBL_stat.hidden = YES;
            cell.BTN_stat.hidden = YES;
            cell.BTN_calendar.hidden =YES;
        }
        
        if([[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] isKindOfClass:[NSDictionary class]])
        {
            
            
            
            NSArray *keys_arr = [[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] allKeys];
            arr_product = [[[jsonresponse_dic valueForKey:@"data"] valueForKey:@"pdts"] valueForKey:[keys_arr objectAtIndex:indexPath.section]];
            
            @try
            {
                NSString *str = [[arr_product objectAtIndex:indexPath.row] valueForKey:@"merchantId"];
                //  str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                NSString *img_url = [NSString stringWithFormat:@"%@Merchant%@/Medium/%@",MERCHANT_URL,str,[[arr_product objectAtIndex:indexPath.row] valueForKey:@"productimage"]];
                [cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:img_url]
                                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                                          options:SDWebImageRefreshCached];
                
                
                NSString *item_name =[NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"product_name"]];
                
                item_name = [item_name stringByReplacingOccurrencesOfString:@"<null>" withString:@"not mentioned"];
                NSString *item_seller =[NSString stringWithFormat:@" %@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"merchantname"]];
                
                
                
                item_name = [item_name stringByReplacingOccurrencesOfString:@"<null>" withString:@"not mentioned"];
                
                NSString *name_text = [NSString stringWithFormat:@"%@\n%@",item_name,item_seller];
                
                
                
#pragma mark LBL_item_name Attributed Text
                
                if ([cell.LBL_item_name respondsToSelector:@selector(setAttributedText:)]) {
                    
                    // Define general attributes for the entire text
                    NSDictionary *attribs = @{
                                              NSForegroundColorAttributeName:cell.LBL_item_name.textColor,
                                              NSFontAttributeName:cell.LBL_item_name.font
                                              };
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:name_text attributes:attribs];
                    
                    
                    
                    NSRange ename = [name_text rangeOfString:item_name];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                                range:ename];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:17.0]}
                                                range:ename];
                    }
                    NSRange cmp = [name_text rangeOfString:item_seller];
                    
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:21.0]}
                                                range:cmp];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:13.0]}
                                                range:cmp ];
                    }
                    cell.LBL_item_name.attributedText = attributedText;
                }
                else
                {
                    cell.LBL_item_name.text = name_text;
                }
                
                
                
                NSString *qr = @"QR";
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
                
                
                NSString *text = [NSString stringWithFormat:@"%@ %@ %@%@ / %@ %@",qr,price,qr,prev_price,doha_miles,mils];
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
                        cell.LBL_discount.text = @"0 %off";
                        
                        
                    }
                    else if (![price isEqualToString:@""] && [doha_miles isEqualToString:@""]){
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:india_currency attributes:nil];
                        
                        NSRange qrs = [india_currency rangeOfString:qr];
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                                range:qrs];
                        
                        NSRange ename = [india_currency rangeOfString:prev_price];
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor blackColor]}
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
                        
                        
                        // Define general attributes for the entire text
                        //                        NSDictionary *attribs = @{
                        //                                                  NSForegroundColorAttributeName:cell.LBL_current_price.textColor,
                        //                                                  NSFontAttributeName:cell.LBL_current_price .font
                        //                                                  };
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
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                                    range:cmp];
                        }
                        @try {
                            [attributedText addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(price.length+4, [prev_price length]+2)];
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
                    int  k = [prev_price intValue]-[price intValue];
                    float discount = (k*100)/[prev_price intValue];
                    NSString *str_off = @"% off";
                    cell.LBL_discount.text = [NSString stringWithFormat:@"%.f%@",discount,str_off];
                    
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
                
                //cell.BTN_stat.tag = [[stat_arr objectAtIndex:0] intValue];
                
                cell.LBL_stat.tag =j;
                
                //                if(cell.BTN_stat.tag == 0)
                
                cell._TXT_count.layer.borderWidth = 0.4f;
                cell._TXT_count.layer.borderColor = [UIColor grayColor].CGColor;
                
                cell.BTN_plus.layer.borderWidth = 0.4f;
                cell.BTN_plus.layer.borderColor = [UIColor grayColor].CGColor;
                cell.BTN_minus.layer.borderWidth = 0.4f;
                cell.BTN_minus.layer.borderColor = [UIColor grayColor].CGColor;
                
                
                NSString *date  =[NSString stringWithFormat:@"%@",[[arr_product objectAtIndex:indexPath.row] valueForKey:@"delivery_slot_available"]];
                
                
                
                NSString *text1 = [NSString stringWithFormat:@"Delivery on %@",date];
                
                if ([cell.LBL_date respondsToSelector:@selector(setAttributedText:)]) {
                    
                    if ([date isEqualToString:@"<null>"] || [date isEqualToString:@""]) {
                        cell.LBL_date.text = @"Delivary Date Not Allocated";
                    }
                    
                    else{                    // Define general attributes for the entire text
                        NSDictionary *attribs = @{
                                                  NSForegroundColorAttributeName:cell.LBL_date.textColor,
                                                  NSFontAttributeName:cell.LBL_date .font
                                                  };
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text1 attributes:attribs];
                        
                        NSRange ename = [text1 rangeOfString:date];
                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                                    range:ename];
                        }
                        else
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                                    range:ename];
                        }
                        
                        cell.LBL_date .attributedText = attributedText;
                    }
                }
                else
                {
                    cell.LBL_date .text = text1;
                }
                
                NSString *CHRGE;
                NSString *qrcode = @"QR";
                NSString *shipping_type;
                
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
                        
                        
                        
                    }
                }
                @catch(NSException *exception)
                {
                    CHRGE = [NSString stringWithFormat:@"%@", [jsonresponse_dic valueForKey:@"shipcharge"]];
                    
                }
                
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
            [cell.LBL_stat setTag:1];
            //cell.BTN_calendar.hidden = NO;
        }
        else
            
        {
            cell.LBL_stat.image = [UIImage imageNamed:@"checkbox_select.png"];
            [cell.LBL_stat setTag:0];
            cell.BTN_calendar.hidden = YES;
            cell.LBL_charge.text = @"";
            
        }
        
        
        
        return cell;
        
    }
    
    else
    {           // ***************TableView Address**************
        
        @try {
            NSMutableDictionary *dict_shipping = [jsonresponse_dic_address valueForKey:@"shipaddress"];
            NSArray *keys_arr;
            
            if ([dict_shipping isKindOfClass:[NSDictionary class]]) {
                keys_arr = [dict_shipping allKeys];
            }
            
            if(indexPath.section == 1 && [dict_shipping isKindOfClass:[NSDictionary class]])
            {
                
                
                shipping_cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_shipping];
                
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
                [cell.BTN_edit addTarget:self action:@selector(BTN_edit_clickd:) forControlEvents:UIControlEventTouchUpInside];
                cell.BTN_edit.tag = indexPath.row;
                
                [cell.BTN_edit_addres addTarget:self action:@selector(add_new_address:) forControlEvents:UIControlEventTouchUpInside];
                cell.BTN_edit_addres.tag = indexPath.row;
                
                cell.BTN_radio.tag = indexPath.row;
                [cell.BTN_radio addTarget:self action:@selector(radio_btn_action:) forControlEvents:UIControlEventTouchUpInside];
                
                //Radio Button Status Checking
                
                if ([[reload_section objectAtIndex:indexPath.row] isEqualToString:@"Yes"]) {
                    
                    [cell.BTN_radio setBackgroundImage:[UIImage imageNamed:@"radiobtn.png"] forState:UIControlStateNormal];
                }
                else{
                    [cell.BTN_radio setBackgroundImage:[UIImage imageNamed:@"radio_unSlt.png"] forState:UIControlStateNormal];
                }
                
                
                //            if ([[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"default"] isEqualToString:@"Yes"]) {
                //
                //                [cell.BTN_radio setBackgroundImage:[UIImage imageNamed:@"radiobtn.png"] forState:UIControlStateNormal];
                //
                //
                //            }
                //            else{
                //                [cell.BTN_radio setBackgroundImage:[UIImage imageNamed:@"radio_unSlt.png"] forState:UIControlStateNormal];
                //            }
                
                return cell;
            }
            else
            {
                
                billing_address *cell = [tableView dequeueReusableCellWithIdentifier:identifier_billing];
                
                if (cell == nil)
                {
                    NSArray *nib;
                    nib = [[NSBundle mainBundle] loadNibNamed:@"billing_address" owner:self options:nil];
                    cell = [nib objectAtIndex:index];
                }
                
                
                
                NSMutableDictionary *dict = [jsonresponse_dic_address valueForKey:@"billaddress"];
                
                cell.BTN_check.tag = 0;
                cell.TXT_first_name.delegate = self;
                cell.TXT_last_name.delegate = self;
                cell.TXT_address1.delegate = self;
                cell.TXT_address2.delegate = self;
                cell.TXT_city.delegate = self;
                cell.TXT_state.delegate = self;
                cell.TXT_country.delegate = self;
                cell.TXT_zip.delegate = self;
                cell.TXT_email.delegate = self;
                cell.TXT_phone.delegate = self;
                
                //NSString *str = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"country"]];
                // NSString *state = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"state"]];
                
                //state = [state stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
                
                //            cntry_ID = [[[dict valueForKey:@"billingaddress"]  valueForKey:@"country_id"] integerValue];
                //            st_ID = [[[dict valueForKey:@"billingaddress"]  valueForKey:@"state_id"] integerValue];
                
                NSString *str_fname = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"firstname"]];
                NSString *str_lname = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"lastname"]];
                NSString *str_addr1 = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"address1"]];
                NSString *str_addr2 = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"address2"]];
                NSString *str_city = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"city"]];
                NSString *str_zip_code = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"zip_code"]];
                
                NSString *str_phone = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"phone"]];
                NSString *str_country = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"country"]];
                NSString *str_state =[NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"state"]];
                
                
                str_fname = [str_fname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                
                str_lname = [str_lname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                str_addr1 = [str_addr1 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                str_addr2 = [str_addr2 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                str_city = [str_city stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                str_zip_code = [str_zip_code stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                
                
                
                
                
                str_phone = [str_phone stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                
                str_country = [str_country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Select Country"];
                
                str_state = [str_state stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                
                
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
    }
    
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
        
        if(indexPath.section == 0 || indexPath.section == 2)
        {
            return 624.0;
            
            
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


//Terms and Conditions Button
-(void)BTN_check_clickd
{
    UIImage *secondImage = [UIImage imageNamed:@"checked_order.png"];

    NSData *imgData1 = UIImagePNGRepresentation(self.LBL_stat.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompare =  [imgData1 isEqualToData:imgData2];
    if (isCompare) {
        
        self.LBL_stat.image = [UIImage imageNamed:@"uncheked_order"];
    }
    else{
        self.LBL_stat.image = [UIImage imageNamed:@"checked_order.png"];
    }
    
}
-(void)calendar_action:(UIButton *)sender
{
    merchent_id = [NSString stringWithFormat:@"%ld",sender.tag];
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
            _TBL_address.hidden = NO;
            
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
            
            NSLog(@"........................%@",self.data_dict);
        }
    }
    
    
    
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
-(void)apply_promo_action:(UIButton*)sender{
    
    [self performSelector:@selector(apply_promo_Code) withObject:activityIndicatorView afterDelay:0.001];
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
    isAddClicked = NO;
    i = 3;
    edit_tag = [sender tag];
    [self.TBL_address reloadData];
    
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
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}
-(void)add_new_address:(UIButton*)sender{
    
    i = 3;
    isAddClicked = YES;
    [self.TBL_address reloadData];
    
}



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
    
    
}
-(void)deliveryslot_action // Done Button
{
    if ([_TXT_Date.text length] != 0 && [_TXT_Time.text length] != 0) {
        
        // Getting merchant Id ,Day/Date and time Id for payment
        for (int m=0; m<date_time_merId_Arr.count; m++) {
            
            if ([merchent_id isEqualToString:[[date_time_merId_Arr objectAtIndex:m] valueForKey:@"mer_id"]]) {
                
                NSDictionary *dic = @{@"mer_id":merchent_id,@"time":time_str,@"date":date_str};
                
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

-(void)BTN_chek_action:(id)sender
{
    if([[stat_arr objectAtIndex:0] isEqualToString:@"1"])
    {
        [stat_arr replaceObjectAtIndex:0 withObject:@"0"];
        i= 1;
        
        
    }
    else
    {
        [stat_arr replaceObjectAtIndex:0 withObject:@"1"];
        i = 2;
        
    }
    [self.TBL_address reloadData];
}

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
            i = 2;
            [self.TBL_address reloadData];
            
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
{//_TBL_orders
    
    //    if([[stat_arr objectAtIndex:0] isEqualToString:@"1"])
    //    {
    //        [stat_arr replaceObjectAtIndex:0 withObject:@"0"];
    //    }
    //    else
    //    {
    //        [stat_arr replaceObjectAtIndex:0 withObject:@"1"];
    //
    //    }
    if (orderCheckSelected) {
        orderCheckSelected = NO;
    }else{
        orderCheckSelected = YES;
    }
    
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TBL_orders];
    NSIndexPath *indexPath = [self.TBL_orders indexPathForRowAtPoint:buttonPosition];
    [self.TBL_orders beginUpdates];
    [self.TBL_orders reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
    //[self.TBL_orders reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.TBL_orders endUpdates];
    
    
    /* CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TBL_address];
     NSIndexPath *indexPath = [self.TBL_address indexPathForRowAtPoint:buttonPosition];
     
     //Reload Particular Section in TableView
     [self.TBL_address beginUpdates];
     [self.TBL_address reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
     [self.TBL_address endUpdates];*/
    
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
    
    int s = [cell._TXT_count.text intValue];
    if (s<=1) {
        s = 1;
        [HttpClient createaAlertWithMsg:@"Min. Quantity is 1 " andTitle:@""];
    }
    else{
        s = s - 1;
        TXT_count = [NSString stringWithFormat:@"%d",s];
        cell._TXT_count.text = TXT_count;
        item_count = cell._TXT_count.text;
        
        product_id = [NSString stringWithFormat:@"%ld",(long)btn.tag];//Getting product Id
        
        
        merchent_id = [NSString stringWithFormat:@"%ld",cell.BTN_calendar.tag]; //Getting Mer Id
        
        NSLog(@"id_m %@  id_p %@",product_id,merchent_id);
        [self updating_cart_List_api];
        
    }
    
    
}
-(void)plus_action:(UIButton*)btn
{
    CGPoint center= btn.center;
    CGPoint rootViewPoint = [btn.superview convertPoint:center toView:self.TBL_orders];
    NSIndexPath *indexPath = [self.TBL_orders indexPathForRowAtPoint:rootViewPoint];
    order_cell *cell = (order_cell*)[self.TBL_orders cellForRowAtIndexPath:indexPath];
    
    int s = [cell._TXT_count.text intValue];
    s = s + 1;
    TXT_count = [NSString stringWithFormat:@"%d",s];
    cell._TXT_count.text = TXT_count;
    
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
    
    if(textField.tag == 6 || textField.tag == 7 || textField.tag == 8)
    {
        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,-120,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
        
        
    }
    
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
    
    if (textField == _TXT_Date ) {
        
        @try {
            
            is_Txt_date = YES;
            [picker_Arr removeAllObjects];
            
            NSLog(@"%@",[[delivary_slot_dic valueForKey:@"days"] valueForKey:@"1"]);
            
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
    if (textField.tag == 8) {
        
        isCountrySelected = YES;
        
        textField.inputView = _staes_country_pickr;
        textField.inputAccessoryView = accessoryView;
        [self.pickerView becomeFirstResponder];
        [self performSelector:@selector(CountryAPICall) withObject:activityIndicatorView afterDelay:0.01];
        
    }
    if (textField.tag == 6) {
        
        isCountrySelected = NO;
        textField.inputView = _staes_country_pickr;
        textField.inputAccessoryView = accessoryView;
        [self.pickerView becomeFirstResponder];
        [self performSelector:@selector(stateApiCall) withObject:activityIndicatorView afterDelay:0.01];
        
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //    if(textField)
    //    {
    //        scroll_height = scroll_height - 100;
    //        [self viewDidLayoutSubviews];
    //    }
    
    
    
    if(textField.tag == 6 || textField.tag == 7 || textField.tag == 8)
    {
        
        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
        
    }
    if (textField == _TXT_Time || textField == _TXT_Date) {
        [self.pickerView resignFirstResponder];
    }
    
    switch (textField.tag)
    {
        case 1:
            
            if ([textField.text isEqualToString:@""]) {
                [HttpClient createaAlertWithMsg:@"Name should not be empty at least two characters " andTitle:@""];
            }
            else if ([textField.text length]<2 || [textField.text length]>30){
                [HttpClient createaAlertWithMsg:@"Name length should be between 2 and 30 characters " andTitle:@""];
            }
            else{
                [_data_dict setValue:textField.text forKey:@"fname"];
            }
            break;
            
        case 2:
            
            if ([textField.text isEqualToString:@""]) {
                [HttpClient createaAlertWithMsg:@"Name should not be empty at least two characters " andTitle:@""];
            }
            else if ([textField.text length]<2 || [textField.text length]>30){
                [HttpClient createaAlertWithMsg:@"Name length should be between 2 and 30 characters " andTitle:@""];
            }
            else{
                [_data_dict setValue:textField.text forKey:@"lname"];
                
            }
            
            break;
            
        case 3:
            if ([textField.text isEqualToString:@""]) {
                [HttpClient createaAlertWithMsg:@"Name should not be empty at least two characters " andTitle:@""];
            }
            else{
                [_data_dict setValue:textField.text forKey:@"address1"];
            }
            
            break;
            
        case 4:
            
            [_data_dict setValue:textField.text forKey:@"address2"];
            
            break;
            
            
        case 5:
            if ([textField.text isEqualToString:@""]) {
                [HttpClient createaAlertWithMsg:@"city should not be empty at least two characters " andTitle:@""];
            }
            else if ([textField.text length]<2 || [textField.text length]>30){
                [HttpClient createaAlertWithMsg:@"city length should be between 2 and 30 characters " andTitle:@""];
            }
            else{
                [_data_dict setValue:textField.text forKey:@"city"];
            }
            
            break;
            
        case 6:
            textField.text = state_selection;
            
            //            if ([textField.text isEqualToString:@""]) {
            //                [HttpClient createaAlertWithMsg:@"Please select state " andTitle:@""];
            //            }
            //            else{
            //
            //            [_data_dict setValue:textField.text forKey:@"state"];
            //            }
            break;
            
        case 7:
            if ([textField.text isEqualToString:@""]) {
                [HttpClient createaAlertWithMsg:@"Please enter Zip code " andTitle:@""];
            }
            else if ([textField.text length]<3 || [textField.text length]>8){
                [HttpClient createaAlertWithMsg:@"Please enter valid Zip code" andTitle:@""];
            }
            else{
                [_data_dict setValue:textField.text forKey:@"zip_code"];
            }
            
            break;
            
        case 8:
            textField.text = cntry_selection;
            
            if ([textField.text isEqualToString:@""]) {
                [HttpClient createaAlertWithMsg:@"Please Select Country " andTitle:@""];
            }else{
                [_data_dict setValue:textField.text forKey:@"country"];
            }
            
            
            
            
            break;
            //        case 9:
            //
            //            [_data_dict setValue:textField.text forKey:@"email"];
            //
            //break;
        case 10:
            if ([textField.text isEqualToString:@""]) {
                [HttpClient createaAlertWithMsg:@"Please enter Mobile No " andTitle:@""];
            }
            else if ([textField.text length]<5 || [textField.text length]>15){
                [HttpClient createaAlertWithMsg:@"Please enter valid Mobile No" andTitle:@""];
            }
            else{
                [_data_dict setValue:textField.text forKey:@"zip_code"];
            }
            [_data_dict setValue:textField.text forKey:@"phone"];
            break;
        default:
            break;
    }
    if (textField.tag == 8) {
        
        billing_address *textFieldRowCell;
        textFieldRowCell = (billing_address *) textField.superview.superview.superview;
        NSIndexPath *indexPath = [self.TBL_address indexPathForCell:textFieldRowCell];
        
        NSLog(@"The index path is %@",indexPath);
        
        textFieldRowCell = (billing_address *)[self.TBL_address cellForRowAtIndexPath:indexPath];
        textFieldRowCell.TXT_state.text = @" Select State";
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

- (IBAction)order_to_cartPage:(id)sender {
    [self performSegueWithIdentifier:@"order_to_cart" sender:self];
}

- (IBAction)order_to_wishListPage:(id)sender {
    [self performSegueWithIdentifier:@"order_to_wish" sender:self];
}
#pragma mark filtering_MerchantId

-(void)filtering_MerchantId{
    
    if([[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] isKindOfClass:[NSDictionary class]])
    {
        
        NSArray *keys_arr = [[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] allKeys];
        for (int k=0; k<keys_arr.count; k++) {
            NSDictionary *dic = @{@"mer_id":[keys_arr objectAtIndex:k],@"time":@"",@"date":@""};
            [date_time_merId_Arr addObject:dic];
            
            
        }
    }
    NSLog(@"&&&&&&&&&& %@",date_time_merId_Arr);
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
                        
                        @try {
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                jsonresponse_dic = data;
                                
                                [self set_UP_VIEW];
                                [self set_data_to_product_Summary_View];
                                NSLog(@"order_detail_API Response:::%@*********",data);
                                [self filtering_MerchantId];
                                [_TBL_orders reloadData];
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
                            jsonresponse_dic_address = data;
                            [self radioButton_values];
                            [_TBL_address reloadData];
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
                    NSString *badge_value = [NSString stringWithFormat:@"%@",[data valueForKey:@"count"]];
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
                
                //  NSLog(@"country::%@",cntry_selection);
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
        else{
            @try {
                state_selection = [[response_picker_arr objectAtIndex:row] valueForKey:@"value"];
                //NSLog(@"State::%@",state_selection);
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
    
    
    //    [_TXT_Date resignFirstResponder];
    //    [_TXT_Time resignFirstResponder];
    //    [_blng_cell.TXT_country resignFirstResponder];
    //    [_blng_cell.TXT_state resignFirstResponder];
    
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
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/applycouponapi/%@/%@/%@.json",SERVER_URL, [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"],self.TXT_cupon.text,_LBL_sub_total.text];
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
                                [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
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

-(void)validatingTextField{
    billing_address *blng_Cell;
    //textFieldRowCell = (billing_address *) textField.superview.superview.superview;
    NSIndexPath *indexPath = [self.TBL_address indexPathForCell:blng_Cell];
    
    NSLog(@"The index path is %@",indexPath);
    
    blng_Cell = (billing_address *)[self.TBL_address cellForRowAtIndexPath:indexPath];
    if (isAddClicked) {
        
        
        
    }
}
-(void)checking_condition:(NSString *)data  andKey:(NSString *)key{
    if ([ data isEqualToString:@""]) {
        [HttpClient createaAlertWithMsg:@"Name should not be empty at least two characters " andTitle:@""];
    }
    else if ([data length]<2 || [data length]>30){
        [HttpClient createaAlertWithMsg:@"Name length should be between 2 and 30 characters " andTitle:@""];
    }
    else{
        [_data_dict setValue:  data forKey:key];
        
    }
    
}

-(void)credit_cerd_action
{
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

@end
