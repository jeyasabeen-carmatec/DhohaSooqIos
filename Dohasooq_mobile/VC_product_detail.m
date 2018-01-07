 //
//  VC_product_detail.m
//  Dohasooq_mobile
//
//  Created by Test User on 26/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_product_detail.h"
#import "UIBarButtonItem+Badge.h"
#import "product_detail_cell.h"
#import "HCSStarRatingView.h"
#import "HttpClient.h"
#import "collection_variants_cell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "review_cell.h"
#import "ViewController.h"
#import "product_cell.h"


@interface VC_product_detail ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,UIWebViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray   *images_arr,*color_arr,*size_arr,*indexPaths, *noDuplicates,*variant_arr;
    NSArray *keys,*variant_arr1;
    NSArray *picker_arr;
    
    HCSStarRatingView *starRatingView;
    NSMutableDictionary *json_Response_Dic,*temp_DICT;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSMutableArray *data_arr;
    NSInteger tag;
    float scroll_ht,web_ht;
    NSString *product_id,*wish_param,*url_share;
    NSMutableArray *varinat_first;
   
    

    //NSString *actuel_price,*avg_rating,*discount,*review_count;
    //NSString **product_description,*img_Url,*title_str,*current_price;
}
@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;


@end

@implementation VC_product_detail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self set_appear];
    json_Response_Dic = [[NSMutableDictionary alloc]init];
    temp_DICT = [[NSMutableDictionary alloc]init];
    starRatingView = [[HCSStarRatingView alloc] init];
    starRatingView.frame = CGRectMake(_LBL_item_name.frame.origin.x-2, _LBL_item_name.frame.origin.y+_LBL_item_name.frame.size.height + 3, 100.0f,20);
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.tintColor = [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];
    starRatingView.allowsHalfStars = YES;
    //  starRatingView.value = 2.5f;
    [self.VW_second addSubview:starRatingView];

    [self.collection_images registerNib:[UINib nibWithNibName:@"product_detail_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_image"];
    [self.collection_related_products registerNib:[UINib nibWithNibName:@"product_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_product"];
    _TXTVW_description.delegate = self;
    
    _BTN_left.layer.cornerRadius = _BTN_left.frame.size.width/2;
    _BTN_left.layer.masksToBounds = YES;
    
    _BTN_right.layer.cornerRadius = _BTN_left.frame.size.width/2;
    _BTN_right.layer.masksToBounds = YES;


    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        [_collectionview_variants setTransform:CGAffineTransformMakeScale(-1, 1)];
        
        [_collection_related_products setTransform:CGAffineTransformMakeScale(-1, 1)];
    }

    [_BTN_cart addTarget:self action:@selector(product_detail_cart_page) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_wish addTarget:self action:@selector(add_to_wish_list) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_buy_now addTarget:self action:@selector(buy_action) forControlEvents:UIControlEventTouchUpInside];

    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    
}
-(void)set_appear
{
    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(cart_count) withObject:nil afterDelay:0.01];
    });
    [self performSelector:@selector(product_detail_API) withObject:activityIndicatorView afterDelay:0.01];
}


-(void)set_UP_VIEW
{
        _TXT_count.delegate = self;
        
    
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                      forBarMetrics:UIBarMetricsDefault];
        
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
           NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
           } forState:UIControlStateNormal];
        
        _TXT_count.text =  @"1";
        
        CGRect  frame_set = _VW_First.frame;
        frame_set.size.height = _custom_story_page_controller.frame.origin.y + _custom_story_page_controller.frame.size.height;
        frame_set.size.width = self.Scroll_content.frame.size.width;
        _VW_First.frame = frame_set;
        [self.Scroll_content addSubview:_VW_First];
        //  [self set_Data_to_UIElements];
        
        
        
        @try
        {
            NSString *str_name = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_descriptions"] objectAtIndex:0] valueForKey:@"title"]];
            str_name = [str_name stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            str_name = [str_name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            _LBL_item_name.text = str_name;
            
            
        }
        @catch(NSException *exception)
        {
            
        }
        
        [_LBL_item_name sizeToFit];
        frame_set = _LBL_item_name.frame;
        frame_set.size.width= _LBL_discount.frame.size.width;
        _LBL_item_name.frame =  frame_set;
        
        frame_set = starRatingView.frame;
        frame_set.origin.y = _LBL_item_name.frame.origin.y + _LBL_item_name.frame.size.height +5;
        starRatingView.frame = frame_set;
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            frame_set = starRatingView.frame;
            frame_set.origin.x = self.view.frame.size.width-starRatingView.frame.size.width-17;//-starRatingView.frame.size.width - 20;
            frame_set.origin.y = _LBL_item_name.frame.origin.y + _LBL_item_name.frame.size.height +5;
            starRatingView.frame = frame_set;
            
        }
        @try
        {
            
            NSString *rating = [NSString stringWithFormat:@"%@",[json_Response_Dic valueForKey:@"avgRating"]];
            rating = [rating stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
            starRatingView.value = [rating floatValue];
        }
        @catch(NSException *exception)
        {
            
        }
    
        frame_set = _LBL_prices.frame;
        frame_set.origin.y = starRatingView.frame.origin.y + starRatingView.frame.size.height;
//        frame_set.size.width= self.view.frame.size.width-50;
          frame_set.size.width= _LBL_item_name.frame.size.width;
        _LBL_prices.frame = frame_set;
  
        
        
    @try
    {
        NSString *currency = [NSString stringWithFormat:@"%@",[[json_Response_Dic valueForKey:@"products"] valueForKey:@"currency_code"]];
        
        
        NSString *mileValue = [NSString stringWithFormat:@"%@",[[json_Response_Dic valueForKey:@"products"] valueForKey:@"mileValue"]];
        
        // Storing product id into User Defaults
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_descriptions"] objectAtIndex:0] valueForKey:@"product_id"]] forKey:@"product_id"];
        
        
        NSString  *actuel_price = [NSString stringWithFormat:@"%@ %@",currency,[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_price"]];
        
        NSString *special_price = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"special_price"]];
        
        
        NSString *doha_miles = [NSString stringWithFormat:@"%@",mileValue];
        NSString *mils  = @"Doha Miles";
        
        
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        
        if ([special_price isEqualToString:@""]|| [special_price isEqualToString:@"<null>"]||[special_price isEqualToString:@"<null>"]) {
            
            
            
            NSString *text = [NSString stringWithFormat:@"%@ / %@ %@",actuel_price,mils,doha_miles];
            NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
            
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                paragraphStyle.alignment                = NSTextAlignmentRight;
                
            }else{
                
                paragraphStyle.alignment                = NSTextAlignmentLeft;
            }
            
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
            
            attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                    range:[text rangeOfString:actuel_price]];
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0],NSForegroundColorAttributeName:[UIColor darkGrayColor]}
                                    range:[text rangeOfString:mils]];
            
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                    range:[text rangeOfString:doha_miles]];
            
            _LBL_prices.attributedText = attributedText;
            _LBL_discount.text = @"";
            
        }
        else{
            
            
            // NSString *doha_miles = @"QR 6758";
            //actuel_price = [currency stringByAppendingString:actuel_price];
            // actuel_price = [NSString stringWithFormat:@"%@%@",currency,actuel_price];
            
            NSString *text = [NSString stringWithFormat:@"%@ %@ %@ / %@ %@",currency,special_price,actuel_price,mils,doha_miles];
            
            if ([_LBL_prices respondsToSelector:@selector(setAttributedText:)]) {
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                        range:[text rangeOfString:currency]];
                
                
                NSRange ename = [text rangeOfString:special_price];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                        range:ename];
                
                
                NSRange cmp = [text rangeOfString:actuel_price];
                //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                        range:cmp];
                
                
                NSRange miles_price = [text rangeOfString:doha_miles];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                        range:miles_price];
                
                NSRange miles = [text rangeOfString:mils];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0]}
                                        range:miles];
                
                
                [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                       value:@2
                                       range:NSMakeRange([special_price length]+currency.length+2, [actuel_price length])];
                
                _LBL_prices.attributedText = attributedText;
            }
            else
            {
                _LBL_prices.text = text;
            }
            
            
            
        }
        
    }@catch(NSException *exception)
    {
        
    }
    
        frame_set = _LBL_discount.frame;
        frame_set.origin.y = _LBL_prices.frame.origin.y + _LBL_prices.frame.size.height;
        _LBL_discount.frame = frame_set;
    
    
        @try
        {
            //
            //        NSString  *actuelprice = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_price"]];
            //
            //        NSString *specialprice = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"special_price"]];
            
            NSString *str_discount = [NSString stringWithFormat:@"%@",[[json_Response_Dic valueForKey:@"products"] valueForKey:@"discount"]];
            
            //        float disc = [actuelprice integerValue]-[specialprice integerValue];
            //        float digits = disc/[actuelprice integerValue];
            //        int discount = digits *100;
            NSString *of;
            if([str_discount isEqualToString: @"0"])
            {
                of=@"";
                _LBL_discount.text =[NSString stringWithFormat:@""];
            }
            else if([str_discount isEqualToString: @"100"])
            {
                of=@"";
                _LBL_discount.text =[NSString stringWithFormat:@""];
                
            }
            else
            {
                of = @"% off";
                _LBL_discount.text =[NSString stringWithFormat:@"%@%@",str_discount,of];
            }
            
            
        }
        @catch(NSException *exception)
        {
            
        }
        
        frame_set = _VW_second.frame;
        frame_set.origin.y = _VW_First.frame.origin.y + _VW_First.frame.size.height + 1;
        frame_set.size.height = _LBL_discount.frame.origin.y + _LBL_discount.frame.size.height + 10;
        frame_set.size.width = self.Scroll_content.frame.size.width;
        _VW_second.frame = frame_set;
        
        [self.Scroll_content addSubview:_VW_second];
        
        frame_set = _BTN_play.frame;
        frame_set.origin.x = self.view.frame.size.width - _BTN_play.frame.size.width - 20;
        frame_set.origin.y = (self.VW_second.frame.origin.y - _BTN_play.frame.size.height / 2) - 4 ;
        _BTN_play.frame = frame_set;
        [self.Scroll_content addSubview:_BTN_play];
    
         frame_set = _BTN_wish.frame;
         frame_set.origin.x = _BTN_play.frame.origin.x  - _BTN_wish.frame.size.width - 20;
         frame_set.origin.y = (self.VW_second.frame.origin.y - _BTN_play.frame.size.height / 2) - 4 ;
         _BTN_wish.frame = frame_set;
         [self.Scroll_content addSubview:_BTN_wish];
    
    
    
    
        frame_set = _BTN_share.frame;
        frame_set.origin.x = 20;
        frame_set.origin.y = (self.VW_second.frame.origin.y - _BTN_share.frame.size.height / 2) - 4 ;
        _BTN_share.frame = frame_set;
        [self.Scroll_content addSubview:_BTN_share];
        
        @try
        {
            NSString *str_srock = [[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"stock_status"];
            str_srock = [str_srock stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            if([str_srock isEqualToString:@"In stock"])
            {
                _LBL_stock.textColor = [UIColor colorWithRed:0.24 green:0.33 blue:0.62 alpha:1.0];
            }
            else
            {
                _LBL_stock.textColor = [UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0];
                
            }
            
            _LBL_stock.text = [str_srock uppercaseString];
            
            NSString *str_cod =[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"cod"];
            if([str_cod isEqualToString:@"Yes"])
            {
                str_cod =  @"available";
                
            }
            else
            {
                str_cod =  @"not available";
            }
            NSString *cod_TEXT;
            NSString *str_shipp = [NSString stringWithFormat:@"%@",[[json_Response_Dic valueForKey:@"products"] valueForKey:@"freeShipping"]];
            NSString *str_dispatch_shipp = [NSString stringWithFormat:@"%@",[[json_Response_Dic valueForKey:@"products"] valueForKey:@"dispatchTime"]];
            
            if([str_shipp isEqualToString:@""""] || [str_shipp isEqualToString:@"<null>"] )
            {
                if([str_shipp isEqualToString:@"<null>"]||[str_shipp isEqualToString:@""""])
                {
                    if([str_dispatch_shipp isEqualToString:@"<null>"]||[str_dispatch_shipp isEqualToString:@""""])
                    {
                        cod_TEXT = [NSString stringWithFormat:@""];
                    }
                    else
                    {
                        cod_TEXT = [NSString stringWithFormat:@"> %@",str_dispatch_shipp];
                        
                        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                        {
                            cod_TEXT = [NSString stringWithFormat:@"%@ <",str_dispatch_shipp];
                        }
                        
                    }
                }
                else{
                    cod_TEXT = [NSString stringWithFormat:@"> Cash on Delivery is %@\n> %@",str_cod,str_shipp];
                    
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        cod_TEXT = [NSString stringWithFormat:@" Cash on Delivery is %@ <\n %@ <",str_cod,str_shipp];
                    }
                    
                    
                }
                
            }
            else
            {
                
                if([str_shipp isEqualToString:@"<null>"]||[str_shipp isEqualToString:@""""])
                {
                    if([str_dispatch_shipp isEqualToString:@"<null>"]||[str_dispatch_shipp isEqualToString:@""""])
                    {
                        cod_TEXT = [NSString stringWithFormat:@"> Cash on Delivery is %@",str_cod];
                        
                        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                        {
                            cod_TEXT = [NSString stringWithFormat:@"Cash on Delivery is %@ <",str_cod];
                        }
                        
                        
                    }
                    else
                    {
                        cod_TEXT = [NSString stringWithFormat:@"> Cash on Delivery is %@\n> %@",str_cod,str_dispatch_shipp];
                        
                        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                        {
                            cod_TEXT = [NSString stringWithFormat:@"Cash on Delivery is %@ <\n %@ <",str_cod,str_dispatch_shipp];
                        }
                        
                        
                    }
                }
                else{
                    
                    if([str_dispatch_shipp isEqualToString:@"<null>"]||[str_dispatch_shipp isEqualToString:@""""])
                    {
                        cod_TEXT = [NSString stringWithFormat:@"> Cash on Delivery is %@\n> %@",str_cod,str_shipp];
                        
                        
                        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                        {
                            cod_TEXT = [NSString stringWithFormat:@"Cash on Delivery is %@ <\n %@ <",str_cod,str_shipp];
                        }
                        
                    }
                    else
                    {
                        cod_TEXT = [NSString stringWithFormat:@"> Cash on Delivery is %@\n> %@\n> %@",str_cod,str_shipp,str_dispatch_shipp];
                        
                        
                        
                        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                        {
                            cod_TEXT = [NSString stringWithFormat:@"Cash on Delivery is %@ <\n %@ <\n> %@",str_cod,str_shipp,str_dispatch_shipp];
                        }
                        
                    }
                    
                    
                }
                
                
            }
            
            cod_TEXT = [cod_TEXT stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
            cod_TEXT = [cod_TEXT stringByReplacingOccurrencesOfString:@"""" withString:@"Not Mentioned"];
            
            _LBL_delivery_cod.text = cod_TEXT;
            
            
        }
        @catch(NSException *exception)
        {
            
        }
        _LBL_delivery_cod.numberOfLines = 0;
        [_LBL_delivery_cod sizeToFit];
        
        
        frame_set = _LBL_sold_by.frame;
        frame_set.origin.y = _LBL_delivery_cod.frame.origin.y + _LBL_delivery_cod.frame.size.height + 5;
        frame_set.size.width= _VW_filter.frame.size.width;
        _LBL_sold_by.frame = frame_set;
        
        @try
        {
            
            NSString *str_merchant = [NSString stringWithFormat:@"%@",[[json_Response_Dic valueForKey:@"products"] valueForKey:@"merchant_name"]];
            str_merchant = [str_merchant stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
            str_merchant = [str_merchant stringByReplacingOccurrencesOfString:@"" withString:@"Not Mentioned"];
            _LBL_merchant_sellers.text  = str_merchant;
        }
        @catch(NSException *exception)
        {
            
        }
        
        
        frame_set = _LBL_merchant_sellers.frame;
        // frame_set.origin.x = _LBL_sold_by.frame.origin.x + _LBL_sold_by.frame.size.width + 5;
        frame_set.origin.y = _LBL_delivery_cod.frame.origin.y + _LBL_delivery_cod.frame.size.height + 5;
        _LBL_merchant_sellers.frame = frame_set;
        
        [_LBL_merchant_sellers sizeToFit];
        _LBL_merchant_sellers.numberOfLines = 0;
        
        
        @try
        {
            
            NSString *str_merchant_IMG = [NSString stringWithFormat:@"%@%@",IMG_URL,[json_Response_Dic valueForKey:@"merchant_logo"]];
            [_IMG_merchant sd_setImageWithURL:[NSURL URLWithString:str_merchant_IMG]
                             placeholderImage:[UIImage imageNamed:@"logo.png"]
                                      options:SDWebImageRefreshCached];
        }
        @catch(NSException *exception)
        {
            
        }
        
        frame_set = _IMG_merchant.frame;
        frame_set.origin.y = _LBL_sold_by.frame.origin.y + _LBL_sold_by.frame.size.height +5;
        _IMG_merchant.frame = frame_set;
        
        if ([[json_Response_Dic valueForKey:@"products"] isKindOfClass:[NSDictionary class]]) {
            
            @try
            {
                
                NSString *string = [NSString stringWithFormat:@"%@",[[json_Response_Dic valueForKey:@"multipleSellers"]valueForKey:@"min_amount"]];
                if([[json_Response_Dic valueForKey:@"multipleSellers"] isKindOfClass:[NSDictionary class]])
                {
                    NSString *str_sellers =[NSString stringWithFormat:@"%lu more Sellers(above %@)",[[[json_Response_Dic valueForKey:@"multipleSellers"] allKeys] count] - 1,string];
                    [_LBL_more_sellers setTitle:str_sellers forState:UIControlStateNormal];
                    
                }
                else
                {
                    [_LBL_more_sellers setTitle:@"" forState:UIControlStateNormal];
                    
                }
            }
            @catch(NSException *exception)
            {
                
            }
        }
        NSString *str_more_text  = [_LBL_more_sellers currentTitle];
        if([str_more_text isEqualToString:@""])
        {
            _LBL_more_sellers.hidden = YES;
        }
        else
        {
            _LBL_more_sellers.hidden = NO;
            frame_set = _LBL_more_sellers.frame;
            frame_set.origin.y = _IMG_merchant.frame.origin.y + _IMG_merchant.frame.size.height +5;
            _LBL_more_sellers.frame = frame_set;
        }
        
        
        frame_set = _QTY.frame;
        
        if([str_more_text isEqualToString:@""])
        {
            frame_set.origin.y = _IMG_merchant.frame.origin.y + _IMG_merchant.frame.size.height +5;
            
        }
        else
        {
            frame_set.origin.y = _LBL_more_sellers.frame.origin.y + _LBL_more_sellers.frame.size.height +5;
        }
        _QTY.frame = frame_set;
        
        frame_set = _BTN_minus.frame;
        if([str_more_text isEqualToString:@""])
        {
            frame_set.origin.y = _IMG_merchant.frame.origin.y + _IMG_merchant.frame.size.height +5;
            
        }
        else
        {
            frame_set.origin.y = _LBL_more_sellers.frame.origin.y + _LBL_more_sellers.frame.size.height+5;
        }
        _BTN_minus.frame = frame_set;
        
        frame_set = _TXT_count.frame;
        if([str_more_text isEqualToString:@""])
        {
            frame_set.origin.y = _IMG_merchant.frame.origin.y + _IMG_merchant.frame.size.height +5;
            
        }
        else
        {
            frame_set.origin.y = _LBL_more_sellers.frame.origin.y + _LBL_more_sellers.frame.size.height+5;
        }
        _TXT_count.frame = frame_set;
        
        frame_set = _BTN_plus.frame;
        if([str_more_text isEqualToString:@""])
        {
            frame_set.origin.y = _IMG_merchant.frame.origin.y + _IMG_merchant.frame.size.height +5;
            
        }
        else
        {
            frame_set.origin.y = _LBL_more_sellers.frame.origin.y + _LBL_more_sellers.frame.size.height +5;
        }
        _BTN_plus.frame = frame_set;
        
        frame_set = _collectionview_variants.frame;
        frame_set.origin.y = _TXT_count.frame.origin.y + _TXT_count.frame.size.height + 20;
        _collectionview_variants.frame = frame_set;
        
        
        
        @try
        {
            if([[json_Response_Dic valueForKey:@"getVariantNames"] isKindOfClass:[NSArray class]])
            {
                data_arr = [[NSMutableArray alloc]init];
                for(int i = 0; i<[[json_Response_Dic valueForKey:@"getVariantNames"] count];i++)
                {
                    [data_arr insertObject:@"" atIndex:i];
                    
                }
                
            }
        }
        @catch(NSException *exception)
        {
            
        }
        
        
        @try
        {
            
            
            if([[json_Response_Dic valueForKey:@"getVariantNames"] isKindOfClass:[NSArray class]])
            {
                
                if([[json_Response_Dic valueForKey:@"getVariantNames"] count] < 1)
                {
                    
                    frame_set = _VW_third.frame;
                    frame_set.origin.y = _VW_second.frame.origin.y + _VW_second.frame.size.height + 1;
                    frame_set.size.height =_TXT_count.frame.origin.y +_TXT_count.frame.size.height + 10;
                    frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
                    _VW_third.frame = frame_set;
                    
                    
                }
                else
                {
                    [self.collectionview_variants reloadData];
                    frame_set = _collectionview_variants.frame;
                    
                    frame_set.size.height = _collectionview_variants.collectionViewLayout.collectionViewContentSize.height;
                    _collectionview_variants.frame = frame_set;
                    
                    frame_set = _VW_third.frame;
                    frame_set.origin.y = _VW_second.frame.origin.y + _VW_second.frame.size.height + 1;
                    frame_set.size.height =_collectionview_variants.frame.origin.y + _collectionview_variants.frame.size.height+10;
                    frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
                    _VW_third.frame = frame_set;
                    
                }
                
            }
            else
            {
                frame_set = _VW_third.frame;
                frame_set.origin.y = _VW_second.frame.origin.y + _VW_second.frame.size.height + 1;
                frame_set.size.height =_TXT_count.frame.origin.y +_TXT_count.frame.size.height + 10;
                frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
                _VW_third.frame = frame_set;
                
                
            }
        }
        @catch(NSException *exception)
        {
            
        }
        
        
        [self.Scroll_content addSubview:_VW_third];
        
        
        frame_set = _VW_segemnt.frame;
        frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
        _VW_segemnt.frame = frame_set;
        
        // _TXTVW_description.numberOfLines = 0;
        
        
        
        frame_set = _VW_fourth.frame;
        frame_set.origin.y = _VW_third.frame.origin.y + _VW_third.frame.size.height + 1;
        frame_set.size.height = _VW_segemnt.frame.origin.y + _VW_segemnt.frame.size.height;
        //_TXTVW_description.frame.origin.y +  _TXTVW_description.frame.size.height;
        frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
        _VW_fourth.frame = frame_set;
        [self.Scroll_content addSubview:_VW_fourth];
        
        @try
        {
            if([[json_Response_Dic valueForKey:@"relatedProducts"] isKindOfClass:[NSArray class]])
            {
                [_collection_related_products reloadData];
                frame_set = _collection_related_products.frame;
                frame_set.origin.y = _LBL_colection.frame.origin.y + _LBL_colection.frame.size.height +5;
                if([[json_Response_Dic valueForKey:@"relatedProducts"] count]<1)
                {
                    frame_set.size.height = 0;
                }
//                else{
//                    
//                    frame_set.size.height =  _collection_related_products.frame.origin.y + _collection_related_products.frame.size.height;
//                    
//                }
                _collection_related_products.frame = frame_set;
                
                frame_set = _VW_fifth.frame;
                frame_set.origin.y = _VW_fourth.frame.origin.y + _VW_fourth.frame.size.height;
              //  frame_set.size.height =  750;
                
                frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
                _VW_fifth.frame = frame_set;
                
                [self.Scroll_content addSubview:_VW_fifth];
                
                scroll_ht = _VW_fifth.frame.origin.y + _VW_fifth.frame.size.height;
                
            }
            else
            {
                frame_set = _VW_fifth.frame;
                frame_set.origin.y = _VW_fourth.frame.origin.y + _VW_fourth.frame.size.height;
                if([[json_Response_Dic valueForKey:@"relatedProducts"] count]<1)
                {
                    frame_set.size.height = 0;
                }
//                else
//                {
//                    frame_set.size.height = 350;
//                    
//                }
                
                frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
                _VW_fifth.frame = frame_set;
                [self.Scroll_content addSubview:_VW_fifth];
                
                scroll_ht = _VW_fourth.frame.origin.y + _VW_fourth.frame.size.height ;
                
            }
        }
        @catch(NSException *exception)
        {
            
        }
        
        
        
        _TXT_count.layer.borderWidth = 0.4f;
        _TXT_count.layer.borderColor = [UIColor grayColor].CGColor;
        
        _BTN_plus.layer.borderWidth = 0.4f;
        _BTN_plus.layer.borderColor = [UIColor grayColor].CGColor;
        _BTN_minus.layer.borderWidth = 0.4f;
        _BTN_minus.layer.borderColor = [UIColor grayColor].CGColor;
        
        
        
        [_BTN_minus addTarget:self action:@selector(minus_action) forControlEvents:UIControlEventTouchUpInside];
        [_BTN_plus addTarget:self action:@selector(plus_action) forControlEvents:UIControlEventTouchUpInside];
        
        
        _BTN_play.layer.cornerRadius = self.BTN_play.frame.size.width / 2;
        _BTN_play.layer.masksToBounds = YES;
        
        _BTN_share.layer.cornerRadius = self.BTN_play.frame.size.width / 2;
        _BTN_share.layer.masksToBounds = YES;
    
        _BTN_wish.layer.cornerRadius = self.BTN_play.frame.size.width / 2;
        _BTN_wish.layer.masksToBounds = YES;
    
        UIImage *newImage = [_IMG_cart.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIGraphicsBeginImageContextWithOptions(_IMG_cart.image.size, NO, newImage.scale);
        [[UIColor whiteColor] set];
        [newImage drawInRect:CGRectMake(0, 0, _IMG_cart.image.size.width, newImage.size.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _IMG_cart.image = newImage;
        [_BTN_share addTarget:self action:@selector(share_action) forControlEvents:UIControlEventTouchUpInside];
        [_LBL_more_sellers addTarget:self action:@selector(sellers_details) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self viewDidLayoutSubviews];
        
    
}

-(void)set_Data_to_UIElements
{
    if ([[json_Response_Dic valueForKey:@"products"] isKindOfClass:[NSDictionary class]]) {
    
                @try
                {
                    
                    if([[[json_Response_Dic valueForKey:@"products"]valueForKey:@"wishStatus"] isEqualToString:@"No"])
                    {
                         [_BTN_wish setTitle:@"" forState:UIControlStateNormal];
                    }
                    else
                    {
                    wish_param = @"";
                    NSString *Stat = [NSString stringWithFormat:@"%@",wish_param];
                    if ([_BTN_wish.titleLabel respondsToSelector:@selector(setAttributedText:)])
                    {
                        
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:Stat attributes:nil];
                        
                        NSRange ename = [Stat rangeOfString:wish_param];
                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0]}
                                                    range:ename];
                        }
                        else
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]}
                                                    range:ename];
                        }
                        [_BTN_wish setAttributedTitle:attributedText forState:UIControlStateNormal];
                        
                        
                    }
                    else
                    {
                        [_BTN_wish setTitle:Stat forState:UIControlStateNormal];
                    }
                    
                    }

                }
                @catch(NSException *exception)
                {
                    
                }
                
                
                
             }
    
    
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_content layoutIfNeeded];
    _Scroll_content.contentSize = CGSizeMake(_Scroll_content.frame.size.width,scroll_ht + _VW_filter.frame.size.height);
    
    
}
#pragma Button Actions


-(void)minus_action
{
    int s = [_TXT_count.text intValue];
    
    if (s<= 0) {
        _TXT_count.text = 0;
    }
    else{
    s = s - 1;
    _TXT_count.text = [NSString stringWithFormat:@"%d",s];
    }
    
    
    
}
- (IBAction)back_action:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)plus_action
{
    int s = [_TXT_count.text intValue];
    s = s + 1;
    _TXT_count.text = [NSString stringWithFormat:@"%d",s];
//     [[NSUserDefaults standardUserDefaults]setObject:_TXT_count.text forKey:@"item_count"];
//    [self updating_cart_List_api];
    
    
}

#pragma collection view delagets
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _collection_images) {
        
        return images_arr.count;

    }
    if(collectionView == _collectionview_variants)
    {
        NSInteger count = 0;
        @try
        {
        if([[json_Response_Dic valueForKey:@"getVariantNames"] isKindOfClass:[NSArray class]])
        {
            count =[[json_Response_Dic valueForKey:@"getVariantNames"] count];

        }
        else{
            count = 0;
        }
        }
        @catch(NSException *exception)
        {
        }
        
        return count;
        
    }
    else
    {
        NSInteger count = 0;
        @try
        {
            if([[json_Response_Dic valueForKey:@"relatedProducts"] isKindOfClass:[NSArray class]])
            {
                count =[[json_Response_Dic valueForKey:@"relatedProducts"] count];
                
            }
            else{
                count = 0;
            }
        }
        @catch(NSException *exception)
        {
        }
        
        return count;

    }
    
    
}
    - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
    {

        if (collectionView == _collection_images) {
            product_detail_cell *img_cell = (product_detail_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_image" forIndexPath:indexPath];
            
          #pragma Webimage URl Cachee
            
            
            @try {
                
                
                NSString *img_url = [NSString stringWithFormat:@"%@",[images_arr objectAtIndex:indexPath.row]];
                
                [img_cell.img sd_setImageWithURL:[NSURL URLWithString:img_url]
                                placeholderImage:[UIImage imageNamed:@"logo.png"]
                                         options:SDWebImageRefreshCached];
                
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
            
            
            
            
            img_cell.img.contentMode = UIViewContentModeScaleAspectFit;
            
            
            return img_cell;

        }
       
            if(collectionView == _collectionview_variants)
            {
                collection_variants_cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
                
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                     [cell.contentView setTransform:CGAffineTransformMakeScale(-1, 1)];
                }
                
                
                cell.LBL_title.text = [[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:indexPath.row] valueForKey:@"variant"];
                //cell.TXT_variant.text = [picker_arr]
                [cell.TXT_variant addTarget:self action:@selector(picker_selection:) forControlEvents:UIControlEventAllEvents];
                
                cell.TXT_variant.tag = indexPath.row;
                _variant_picker = [[UIPickerView alloc] init];
                _variant_picker.delegate = self;
                
                
                
                
                           
                UIToolbar* conutry_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
                conutry_close.barStyle = UIBarStyleBlackTranslucent;
                [conutry_close sizeToFit];
                
                UIButton *Done=[[UIButton alloc]init];
                Done.frame=CGRectMake(conutry_close.frame.size.width - 100, 0, 100, conutry_close.frame.size.height);
                [Done setTitle:@"Done" forState:UIControlStateNormal];
                [Done addTarget:self action:@selector(countrybuttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [conutry_close addSubview:Done];
                
                UIButton *close=[[UIButton alloc]init];
                close.frame=CGRectMake(conutry_close.frame.origin.x, 0, 100, conutry_close.frame.size.height);
                [close setTitle:@"Close" forState:UIControlStateNormal];
                [close addTarget:self action:@selector(Close_action) forControlEvents:UIControlEventTouchUpInside];
                [conutry_close addSubview:close];
                
                close.tag = indexPath.row;
               cell.TXT_variant.inputAccessoryView=conutry_close;
               cell.TXT_variant.inputView = _variant_picker;
                cell.TXT_variant.delegate = self;
                NSString *str_qty;
                @try
                {
                str_qty = [NSString stringWithFormat:@"%@",[[varinat_first objectAtIndex:indexPath.row] valueForKey:@"variant_name"]];
                }
                @catch(NSException *exception)
                {
                    str_qty = @"";
                }
                str_qty = [str_qty stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
               // cell.TXT_variant.text = str_qty;
                

               cell.TXT_variant.text = [data_arr objectAtIndex:indexPath.row];
                
                if([cell.TXT_variant.text isEqualToString:@""])
                {
                    cell.TXT_variant.text =str_qty;
                }
               // cell.TXT_variant.layer.cornerRadius = 2.0f;
                cell.TXT_variant.layer.borderWidth = 0.2f;
                cell.TXT_variant.layer.borderColor = [UIColor lightGrayColor].CGColor;
                
           
                
                return cell;
                
            }
            else{
                product_cell *pro_cell = (product_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_product" forIndexPath:indexPath];
               
#pragma Webimage URl Cachee
                  @try
                {
                    NSString *img_url = [NSString stringWithFormat:@"%@",[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row] objectAtIndex:0] valueForKey:@"product_image"]];
                    [pro_cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:img_url]
                                         placeholderImage:[UIImage imageNamed:@"logo.png"]
                                                  options:SDWebImageRefreshCached];
                    @try
                    {
                        NSString *str = [NSString stringWithFormat:@"%@",[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row]objectAtIndex:0]  valueForKey:@"stock_status"]];
                        str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                        
                        
                        if([str isEqualToString:@"In stock"])
                        {
                             pro_cell.LBL_stock.text = @"";
                        }
                        else{
                            pro_cell.LBL_stock.text =[str uppercaseString];
                        }
                        
                    }
                    @catch(NSException *exception)
                    {
                        
                    }
                    pro_cell.LBL_item_name.text = [[[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row] objectAtIndex:0] valueForKey:@"product_descriptions"] objectAtIndex:0]valueForKey:@"title"];
                    
                    
                    @try
                    {
                        float rating = [[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row]objectAtIndex:0]  valueForKey:@"rating"] floatValue];
                        rating =lroundf(rating);
                        
                        if(rating <= 1)
                        {
                            pro_cell.LBL_rating.backgroundColor = [UIColor colorWithRed:0.92 green:0.39 blue:0.25 alpha:1.0];
                        }
                        else if(rating <= 2)
                        {
                            pro_cell.LBL_rating.backgroundColor =[UIColor colorWithRed:0.96 green:0.69 blue:0.24 alpha:1.0];
                        }
                        else if(rating <= 3)
                        {
                            pro_cell.LBL_rating.backgroundColor = [UIColor colorWithRed:0.19 green:0.56 blue:0.78 alpha:1.0];
                        }
                        else
                        {
                            pro_cell.LBL_rating.backgroundColor = [UIColor colorWithRed:0.25 green:0.80 blue:0.51 alpha:1.0];
                        }
                        pro_cell.LBL_rating.text = [NSString stringWithFormat:@"%.f  ",rating];
                        
                    }
                    @catch(NSException *exception)
                    {
                        
                    }
                    
                    NSString *currency_code = [[NSUserDefaults standardUserDefaults]valueForKey:@"currency"];
                    
                    NSString *current_price = [NSString stringWithFormat:@"%@",[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row]objectAtIndex:0]  valueForKey:@"special_price"]];
                    
                    NSString *prec_price = [NSString stringWithFormat:@"%@",[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row]objectAtIndex:0]  valueForKey:@"product_price"]];
                    NSString *text ;
                    
                   
                    
                    if ([pro_cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
                        
                        
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        [paragraphStyle setAlignment:NSTextAlignmentCenter];
                        
                        if ([current_price isEqualToString:@"<null>"] || [current_price isEqualToString:@"<nil>"] || [current_price isEqualToString:@" "]) {
                            
                            
                
                            
                            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                            {
        
                                
                                text = [NSString stringWithFormat:@"%@ %@",prec_price,currency_code];
                            }
                            else{
                                 text = [NSString stringWithFormat:@"%@ %@",currency_code,prec_price];
                            }
                            
                            
                            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                            
                            
                            
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:[text rangeOfString:currency_code] ];
                            
                            
                            
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:[text rangeOfString:prec_price] ];
                            
                            
                            
                            
                            [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                            //NSParagraphStyleAttributeName
                            pro_cell.LBL_current_price.attributedText = attributedText;
                            
                            pro_cell.LBL_discount.text = @"";
                            
                        }
                        
                        else{
                            
                           
                            prec_price = [NSString stringWithFormat:@"%@ %@",currency_code,prec_price];
                            text = [NSString stringWithFormat:@"%@ %@ %@",currency_code,current_price,prec_price];
                            
                            
                            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                            {
                                //                    prec_price = [prec_price stringByAppendingString:currency_code];
                                text = [NSString stringWithFormat:@"%@ %@ %@",prec_price,current_price,currency_code];
                            }
                            
                            
                            
                            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                            
                            
                            
                            NSRange ename = [text rangeOfString:current_price];
                            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:25.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                                        range:ename];
                            }
                            else
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                                        range:ename];
                            }
                            
                            
                            NSRange qrname = [text rangeOfString:currency_code];
                            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:25.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                                        range:qrname];
                            }
                            else
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                                        range:qrname];
                            }
                            
                            
                            
                            
                            NSRange cmp = [text rangeOfString:prec_price];
                            //        [attributedText addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:3] range:[text rangeOfString:prec_price]];
                            
                            
                            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:21.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                                        range:cmp];
                            }
                            else
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:14.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:cmp ];
                            }
                            [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                            
                            
                            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                            {
                                [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                                       value:@2
                                                       range:NSMakeRange(0 ,[prec_price length])];
                            }
                            
                            else{
                                [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                                       value:@2
                                                       range:NSMakeRange([current_price length]+[currency_code length]+2 ,[prec_price length])];
                            }
                            
                            
                            pro_cell.LBL_current_price.attributedText = attributedText;
                            
                        }
                    }
                    else
                    {
                        pro_cell.LBL_current_price.text = text;
                    }
                
                
                    NSString *str = @"%off";
                    pro_cell.LBL_discount.text = [NSString stringWithFormat:@"%@ %@",[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row]objectAtIndex:0]  valueForKey:@"discount"],str];
                    
                    [pro_cell.BTN_fav setTag:indexPath.row];//wishListStatus
                    @try
                    {
                        
                        if ([[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row]objectAtIndex:0]  valueForKey:@"wishStatus"] isEqualToString:@"Yes"]) {
                            [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                            
                            [pro_cell.BTN_fav setTitleColor:[UIColor colorWithRed:244.f/255.f green:176.f/255.f blue:77.f/255.f alpha:1] forState:UIControlStateNormal];
                        }
                        else{
                            [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                            
                            [pro_cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        }
                    }
                    @catch(NSException *exception)
                    {
                        [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                        
                        [pro_cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        
                    }
                    [pro_cell.BTN_fav addTarget:self action:@selector(Wishlist_add:) forControlEvents:UIControlEventTouchUpInside];
                    //  }
                    return pro_cell;
                }
                @catch(NSException *exception)
                {
                    
                }
                
                return pro_cell;

                
            }
        
        
  }
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collection_images) {
        return CGSizeMake(_collection_images.frame.size.width ,_collection_images.frame.size.height);

    }
    if(collectionView == _collectionview_variants){
        return CGSizeMake(_collectionview_variants.frame.size.width/3, 64);
    }
    else
    {
       return CGSizeMake(self.view.bounds.size.width/2.1, 320);
    }

    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if(collectionView == _collection_related_products)
    {
    return 1.5;
    }
     return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if(collectionView == _collection_related_products)
    {
        return 1.5;
    }
    return 0;
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(2,0,2,0);  // top, left, bottom, right
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(collectionView == _collection_related_products)
    {
    
    NSUserDefaults *userDflts = [NSUserDefaults standardUserDefaults];
  //  NSString *merchant_ID = [NSString stringWithFormat:@"%c",firstLetter];
    [userDflts setObject:[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row]objectAtIndex:0]  valueForKey:@"url_key"] forKey:@"product_list_key_sub"];
    [userDflts setValue:[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row]objectAtIndex:0]  valueForKey:@"merchant_id"]  forKey:@"Mercahnt_ID"];
    [userDflts synchronize];
        
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(product_detail_API) withObject:activityIndicatorView afterDelay:0.01];
        
    
       }
    
    
    
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
    {
        @try
        {
        NSString *cellIdentifier;
        for (UICollectionViewCell *cell in [scrollView subviews])
        {
            cellIdentifier = [cell reuseIdentifier];
        }
        if ([cellIdentifier isEqualToString:@"collection_image"])
        {
            float pageWidth = _collection_images.frame.size.width; // width + space
            
            float currentOffset = _collection_images.contentOffset.x;
            float targetOffset = targetContentOffset->x;
            float newTargetOffset = 1;
            
            if (targetOffset > currentOffset)
                newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
            else
                newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
            
            if (newTargetOffset < 0)
                newTargetOffset = 0;
            else if (newTargetOffset > _collection_images.contentSize.width)
                newTargetOffset = _collection_images.contentSize.width;
            
            targetContentOffset->x = currentOffset;
            [_collection_images setContentOffset:CGPointMake(newTargetOffset  , _collection_images.contentOffset.y) animated:YES];
            CGPoint visiblePoint = CGPointMake(newTargetOffset, _collection_images.contentOffset.y);
            NSIndexPath *visibleIndexPath = [self.collection_images indexPathForItemAtPoint:visiblePoint];
            
            self.custom_story_page_controller.currentPage = visibleIndexPath.row;
            
        }
        }
        @catch(NSException *exception)
        {
            
        }
        
    }
#pragma text fields
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == _TXT_count)
    {
        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
        
    }
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    
}
#pragma segment methods
-(void) addSEgmentedControl
{
   self.segmentedControl4 = [[HMSegmentedControl alloc] initWithFrame:_VW_segemnt.frame];
    CGRect frame = self.segmentedControl4.frame;
    frame.size.width = self.navigationController.navigationBar.frame.size.width;
    self.segmentedControl4.frame = frame;
    
    NSString *count = [NSString stringWithFormat:@"%@",[json_Response_Dic valueForKey:@"reviewCount"]];
    count = [count stringByReplacingOccurrencesOfString:@"(null)" withString:@"0"];
    count = [count stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
    if([count isEqualToString:@"0"])
    {
        count = [NSString stringWithFormat:@"  REVIEWS  "];
       //@"  REVIEWS(%@)  "
    }
    else
    {
        count = [NSString stringWithFormat:@"  REVIEWS(%@)  ",[json_Response_Dic valueForKey:@"reviewCount"]];
 
    }

    
    self.segmentedControl4.sectionTitles = @[@" DESCRIPTION  ",count];
    
    self.segmentedControl4.backgroundColor = [UIColor clearColor];
    self.segmentedControl4.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15]};
    self.segmentedControl4.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15]};
    self.segmentedControl4.selectionIndicatorColor = [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];
    self.segmentedControl4.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl4.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl4.selectionIndicatorHeight = 2.0f;
    
    
    [self.segmentedControl4 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.VW_fourth addSubview:self.segmentedControl4];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl4
{
    NSLog(@"Selected index %ld (via UIControlEventValueChanged) aaa", (long)segmentedControl4.selectedSegmentIndex);
  
    if(segmentedControl4.selectedSegmentIndex == 0)
    {
        NSString *description;
        
        @try
        {
   
        description =[NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"]valueForKey:@"0"]valueForKey:@"product_descriptions"] objectAtIndex:0]valueForKey:@"description"]];
        }
        @catch(NSException *exception)
        {
           description =[NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"]valueForKey:@"0"]valueForKey:@"product_descriptions"]];
        }
        description = [description stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: 'Poppins-Regular'; font-size:%dpx;}</style>",17]];

        
        [_TXTVW_description loadHTMLString:description baseURL:nil];

        _TXTVW_description.hidden = NO;
        [_TXTVW_description sizeToFit];
        

         CGRect  frame_set = _VW_fourth.frame;
        frame_set.size.height =_TXTVW_description.frame.origin.y + _TXTVW_description.scrollView.contentSize.height;
        frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
        _VW_fourth.frame = frame_set;
        
        [_collection_related_products reloadData];
         if([[json_Response_Dic valueForKey:@"relatedProducts"] isKindOfClass:[NSArray class]])
         {
        
        frame_set = _VW_fifth.frame;
        frame_set.origin.y = _VW_fourth.frame.origin.y + _VW_fourth.frame.size.height;
        if([[json_Response_Dic valueForKey:@"relatedProducts"] count]<1)
        {
            frame_set.size.height = 0;
        }
//        else{
//             frame_set.size.height = 281;
//            
//        }

        frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
        _VW_fifth.frame = frame_set;
        
        
        scroll_ht = _VW_fifth.frame.origin.y+ _VW_fifth.frame.size.height;
         }
         else{
             scroll_ht = _VW_fourth.frame.origin.y+ _VW_fourth.frame.size.height;

             
         }
         [self viewDidLayoutSubviews];
        _TBL_reviews.hidden = YES;
       
        
    }
    else
    {
        [_TBL_reviews reloadData];
        _TBL_reviews.hidden = NO;
        _TXTVW_description.hidden = YES;
        
        CGRect frame_set = _TBL_reviews.frame;
        frame_set.origin.y = _TXTVW_description.frame.origin.y;
        frame_set.size.height = _TBL_reviews.frame.origin.y + _TBL_reviews.contentSize.height;
        frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
        _TBL_reviews.frame = frame_set;
        [self.VW_fourth addSubview:_TBL_reviews];
        
        frame_set = _VW_fourth.frame;
        frame_set.size.height = _TBL_reviews.frame.origin.y + _TBL_reviews.contentSize.height;
        frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
        _VW_fourth.frame = frame_set;
        
        [_collection_related_products reloadData];
        if([[json_Response_Dic valueForKey:@"relatedProducts"] isKindOfClass:[NSArray class]])
        {

        frame_set = _VW_fifth.frame;
        frame_set.origin.y = _VW_fourth.frame.origin.y + _VW_fourth.frame.size.height +3;
        if([[json_Response_Dic valueForKey:@"relatedProducts"] count]<1)
        {
            frame_set.size.height = 0;
        }
//        else{
//             frame_set.size.height = 281;
//            
//        }
        frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
        _VW_fifth.frame = frame_set;
        
        scroll_ht = _VW_fifth.frame.origin.y+ _VW_fifth.frame.size.height ;
        }
        else{
            scroll_ht = _VW_fourth.frame.origin.y+ _VW_fourth.frame.size.height;

        }
       
         [self viewDidLayoutSubviews];

    }

}
-(void)picker_selection:(UITextField *)sender
{
  picker_arr = [[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:sender.tag] valueForKey:@"0"] allObjects];
    NSLog(@"variant_count%lu",(unsigned long)picker_arr.count);
    tag = [sender tag];
    
    
   
}
-(void)Wishlist_add:(UIButton *)sender
{
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    @try
    {
        //        NSUserDefaults *user_dflts = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        if([user_id isEqualToString:@"(null)"])
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
            alert.tag = 1;
            [alert show];
            
        }
        else
        {
            
            
            
            
           // NSLog(@"%@",productDataArray);
         product_id =[NSString stringWithFormat:@"%@", [[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:sender.tag] objectAtIndex:0] valueForKey:@"id"]];
            //[[NSUserDefaults standardUserDefaults]setObject:product_id forKey:@"product_id"];
            
            if ([[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:sender.tag] objectAtIndex:0]valueForKey:@"wishStatus"] isEqualToString:@"Yes"]) {
                [self delete_from_wishLis];
                //[self product_detail_API];
            }
            
                
                NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/addToWishList/%@/%@.json",SERVER_URL,product_id,user_id];
                urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error) {
                            
                            VW_overlay.hidden=YES;
                            [activityIndicatorView stopAnimating];
                            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                        }
                        if (data) {
                            
                            if([data isKindOfClass:[NSDictionary class]])
                            {
                                json_Response_Dic = data;
                                
                                VW_overlay.hidden=YES;
                                [activityIndicatorView stopAnimating];
                                NSLog(@"The Wishlist %@",json_Response_Dic);
                                
                                @try {
                                    if ([[json_Response_Dic valueForKey:@"msg"] isEqualToString:@"add"]) {
                                        
                                        [self product_detail_API];
                                        
                                        
                                        [HttpClient createaAlertWithMsg:@"Item added successfully" andTitle:@""];
                                        
                                        
                                    }
                                    else{
                                        
                                         [self product_detail_API];                         }
                                    
                                    
                                } @catch (NSException *exception) {
                                    NSLog(@"%@",exception);
                                     [self product_detail_API];
                                    
                                }
                                
                            }
                            else
                            {
                                VW_overlay.hidden=YES;
                                [activityIndicatorView stopAnimating];
                                
                                [HttpClient createaAlertWithMsg:@"Connection error" andTitle:@""];
                                NSLog(@"The Wishlist%@",json_Response_Dic);
                                
                                
                            }
                            
                            
                        }
                        
                    });
                }];
            }
        
    }
    @catch(NSException *exception)
    {
        VW_overlay.hidden=YES;
        [activityIndicatorView stopAnimating];
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"already added" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        //            [alert show];
        
        NSLog(@"The error is:%@",exception);
        [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
    }
    
    VW_overlay.hidden=YES;
    [activityIndicatorView stopAnimating];
}

-(void)delete_from_wishLis{
    
    /* Del WishList
     
     http://192.168.0.171/dohasooq/apis/delFromWishList/1/24.json
     
     example
     Product_id =1
     User_Id = 24
     
     */
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_ID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    NSString *pdId = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_descriptions"] objectAtIndex:0] valueForKey:@"product_id"]];

    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/delFromWishList/%@/%@.json",SERVER_URL,pdId,user_ID];
    
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    @try {
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    NSLog(@"%@",data);
                    
                    
                    @try {
                        VW_overlay.hidden = YES;
                        [activityIndicatorView stopAnimating];
                        if ([[data valueForKey:@"msg"] isEqualToString:@"del"])
                        {
                            @try {
                           wish_param = @"";
                            NSString *Stat = [NSString stringWithFormat:@"%@",wish_param];
                            if ([_BTN_wish.titleLabel respondsToSelector:@selector(setAttributedText:)])
                            {
                                
                                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:Stat attributes:nil];
                                
                                NSRange ename = [Stat rangeOfString:wish_param];
                                                                 [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:17.0]}
                                                            range:ename];
                                
                            [_BTN_wish setAttributedTitle:attributedText forState:UIControlStateNormal];
                                
                                
                            }
                            else
                            {
                                [_BTN_wish setTitle:Stat forState:UIControlStateNormal];
                            }
                            
                        
                        
                    }
                    @catch(NSException *exception)
                    {
                        
                    }

                        [HttpClient createaAlertWithMsg:@"Item deleted Succesfully" andTitle:@""];
                            VW_overlay.hidden = YES;
                            [activityIndicatorView stopAnimating];


                       // [self product_detail_API];
                        }
                        
                    } @catch (NSException *exception) {
                        NSLog(@"%@",exception);
                        VW_overlay.hidden = YES;
                        [activityIndicatorView stopAnimating];

                        
                    }
                    
                }
                
            });
            
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];

        
    }
}


-(void)set_data_to_ThirdView{
    //[json_Response_Dic valueForKey:@"getVariantNames"] ,[[json_Response_Dic valueForKey:@"getVariantNames"] count]
    if ([[json_Response_Dic valueForKey:@"getVariantNames"] isKindOfClass:[NSArray class]]) {
        for (int i=0; i<[[json_Response_Dic valueForKey:@"getVariantNames"] count]; i++) {
            NSLog(@"%@",[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i]);
            //NSLog(@"%@")
            
        }

    }
    else if ([[json_Response_Dic valueForKey:@"getVariantNames"] isKindOfClass:[NSDictionary class]]){
        
    }
    
}
#pragma  mark addToWishList

-(void)wish_list_API
{
    @try
    {
        //        NSUserDefaults *user_dflts = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
       if([user_id isEqualToString:@"(null)"])
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
            alert.tag = 1;
            [alert show];
            
        }
        else
        {

        
        NSString *poduct_id = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"]valueForKey:@"0"] valueForKey:@"id"]];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/addToWishList/%@/%@.json",SERVER_URL,poduct_id,user_id];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                    
                    VW_overlay.hidden=YES;
                    [activityIndicatorView stopAnimating];

                }
                if (data) {
                    json_Response_Dic = data;
                    if(json_Response_Dic)
                    {
                        VW_overlay.hidden=YES;
                        [activityIndicatorView stopAnimating];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Added to your wishlist" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];
                        NSLog(@"The Wishlist%@",json_Response_Dic);
                        [self product_detail_API];
                        [self cart_count];
                    }
                    else
                    {
                        
                        VW_overlay.hidden=YES;
                        [activityIndicatorView stopAnimating];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];
                        NSLog(@"The Wishlist%@",json_Response_Dic);

                        
                    }
                    
                    
                }
                
            });
         }];
        
        }
    }
    @catch(NSException *exception)
    {
        VW_overlay.hidden=YES;
        [activityIndicatorView stopAnimating];
        NSLog(@"The error is:%@",exception);
        [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
    }
    
    

    
}
- (IBAction)add_cart_action:(id)sender
{
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(add_to_cart_API_calling) withObject:activityIndicatorView afterDelay:0.01];
    
}

#pragma buy now action
-(void)buy_action
{
    noDuplicates = [[NSMutableArray alloc]init];
    NSString *items_count = _TXT_count.text;
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    
    
    
    if([user_id isEqualToString:@"(null)"])
    {
        VW_overlay.hidden=YES;
        [activityIndicatorView stopAnimating];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please login to Purchase" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        alert.tag = 1;
        [alert show];
        
    }
    
    else
    {
        [noDuplicates addObject:temp_DICT];
        NSArray *hasDuplicates = noDuplicates;
        variant_arr1 = [[NSSet setWithArray: hasDuplicates] allObjects];
        NSLog(@"%@",variant_arr1);
        
        NSString *stock =  [[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"stock_status"];
        stock = [stock stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        stock = [stock stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        if([stock isEqualToString:@""] || [stock isEqualToString:@"Out of stock"])
        {
            VW_overlay.hidden=YES;
            [activityIndicatorView stopAnimating];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Out of Stock" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
        else
        {
            
            
            
            NSString *stock =  [[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"stock_status"];
            stock = [stock stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            stock = [stock stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            if([stock isEqualToString:@""] || [stock isEqualToString:@"Out of stock"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Out of Stock" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alert show];
                VW_overlay.hidden=YES;
                [activityIndicatorView stopAnimating];
                
            }
            else if([items_count isEqualToString:@"0"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Select Quantity" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alert show];
                VW_overlay.hidden=YES;
                [activityIndicatorView stopAnimating];
                
            }
            else
            {
                
                NSString *items_count = _TXT_count.text;
                NSString *pdId = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_descriptions"] objectAtIndex:0] valueForKey:@"product_id"]];
                NSString *variant = [[json_Response_Dic valueForKey:@"products"] valueForKey:@"variant"];
                NSString *custom = [[json_Response_Dic valueForKey:@"products"] valueForKey:@"customOption"];
                NSString *variant_stat; NSDictionary *parameters;
                NSLog(@"THE VARIANT COUNT:%lu",(unsigned long)variant_arr1.count);
                NSString *variant_str = [variant_arr1 componentsJoinedByString:@","];
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                
                
                NSData *data = [NSJSONSerialization dataWithJSONObject:variant_arr1 options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonStr = [[NSString alloc] initWithData:data
                                                          encoding:NSUTF8StringEncoding];
                
                NSLog(@"json_str ::  %@",jsonStr);
                NSString *str_custom,*str_varient;
                
                
                
                
                if([custom isEqualToString:@"Yes"] && [variant isEqualToString:@"No"])
                {
                    variant_stat = @"custom";
                    
                    // if([[variant_arr1 objectAtIndex:0] count] < 1)
                    // {
                    NSMutableDictionary *dict_ids= [NSMutableDictionary dictionary];
                    for(int i = 0; i<[varinat_first count];i++)
                    {
                        
                        
                        [dict_ids addEntriesFromDictionary:[[varinat_first objectAtIndex:i] valueForKey:@"0"]];
                    }
                    
                    NSLog(@"000000 %@",dict_ids);
                    
                    NSData *data = [NSJSONSerialization dataWithJSONObject:dict_ids options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *jsonStr = [[NSString alloc] initWithData:data
                                                              encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"json_str ::  %@",jsonStr);
                    
                    str_custom = jsonStr;
                    str_varient = @"";
                    
                    
                    
                }
                else if([custom isEqualToString:@"No"] && [variant isEqualToString:@"Yes"])
                {
                    
                    variant_stat = @"variant";
                    
                    //         if([[variant_arr1 objectAtIndex:0] count] < 1)
                    //         {
                    NSMutableDictionary *dict_ids= [NSMutableDictionary dictionary];
                    for(int i = 0; i<[varinat_first count];i++)
                    {
                        
                        
                        [dict_ids addEntriesFromDictionary:[[varinat_first objectAtIndex:i] valueForKey:@"0"]];
                    }
                    
                    NSLog(@"000000 %@",dict_ids);
                    
                    NSData *data = [NSJSONSerialization dataWithJSONObject:dict_ids options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *jsonStr = [[NSString alloc] initWithData:data
                                                              encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"json_str ::  %@",jsonStr);
                    str_custom = @"";
                    str_varient = jsonStr;
                    
                    
                    parameters = @{@"pdtId":pdId,@"userId":user_id,@"quantity":items_count,variant_stat:[arr componentsJoinedByString:@","],@"custom":@""};
                }
                else
                {
                    variant_stat = @"variant";
                    parameters = @{@"pdtId":pdId,@"userId":user_id,@"quantity":items_count,@"custom":@"",@"variant":@""};
                    str_custom = @"";
                    str_varient = @"";
                    
                }
                
                @try
                {
                    
                    NSString *urlString =[NSString stringWithFormat:@"%@apis/addcartapi.json",SERVER_URL];
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
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pdtId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
                    [body appendData:[[NSString stringWithFormat:@"%@",pdId]dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    // another text parameter
                    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"%@",user_id]dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"quantity\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"%@",items_count]dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    
                    //Custom
                    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"custom\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"%@",str_custom]dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    
                    
                    //Varient
                    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"variant\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"%@",str_varient]dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    
                    
                    
                    
                    
                    
                    //
                    NSError *er;
                    //    NSHTTPURLResponse *response = nil;
                    
                    // close form
                    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    // set request body
                    [request setHTTPBody:body];
                    
                    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                    [activityIndicatorView stopAnimating];
                    VW_overlay.hidden = YES;
                    
                    if (returnData) {
                        NSMutableDictionary *json_DATA = [[NSMutableDictionary alloc]init];
                        json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:returnData options:NSASCIIStringEncoding error:&er];
                        NSString *stat =[NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
                        if([stat isEqualToString:@"1"])
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            
                            [alert show];
                            [self cart_count];
                            [self performSegueWithIdentifier:@"detail_checkout" sender:self];

                            
                        }
                        else{
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                            
                            [alert show];
                            
                        }
                    }
                    else{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        
                        [alert show];
                    }
                }
                @catch(NSException *exception)
                {
                    [activityIndicatorView stopAnimating];
                    VW_overlay.hidden = YES;
                    NSLog(@"THE EXception:%@",exception);
                    
                }
            }
        }
        
        }

    
}

 #pragma mark add_to_cart_API_calling

 -(void)add_to_cart_API_calling
{
     
      noDuplicates = [[NSMutableArray alloc]init];
        NSString *items_count = _TXT_count.text;

         NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
         NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    
    
    
         if([user_id isEqualToString:@"(null)"])
         {
             VW_overlay.hidden=YES;
             [activityIndicatorView stopAnimating];

             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please login to add items to cart" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
             alert.tag = 1;
             [alert show];
             
         }
       
         else
         {
             [noDuplicates addObject:temp_DICT];
             NSArray *hasDuplicates = noDuplicates;
             variant_arr1 = [[NSSet setWithArray: hasDuplicates] allObjects];
             NSLog(@"%@",variant_arr1);
             
                         NSString *stock =  [[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"stock_status"];
                         stock = [stock stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                         stock = [stock stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                         if([stock isEqualToString:@""] || [stock isEqualToString:@"Out of stock"])
                         {
                             VW_overlay.hidden=YES;
                             [activityIndicatorView stopAnimating];

                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Out of Stock" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             
                             [alert show];
                             
                         }
                         else
                         {


             
             NSString *stock =  [[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"stock_status"];
             stock = [stock stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
             stock = [stock stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
             if([stock isEqualToString:@""] || [stock isEqualToString:@"Out of stock"])
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Out of Stock" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                 [alert show];
                 VW_overlay.hidden=YES;
                 [activityIndicatorView stopAnimating];
 
             }
             else if([items_count isEqualToString:@"0"])
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Select Quantity" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 
                 [alert show];
                 VW_overlay.hidden=YES;
                 [activityIndicatorView stopAnimating];
                 
             }
             else
             {

                NSString *items_count = _TXT_count.text;
                NSString *pdId = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_descriptions"] objectAtIndex:0] valueForKey:@"product_id"]];
                 NSString *variant = [[json_Response_Dic valueForKey:@"products"] valueForKey:@"variant"];
                 NSString *custom = [[json_Response_Dic valueForKey:@"products"] valueForKey:@"customOption"];
                 NSString *variant_stat; NSDictionary *parameters;
                 NSLog(@"THE VARIANT COUNT:%lu",(unsigned long)variant_arr1.count);
                 NSString *variant_str = [variant_arr1 componentsJoinedByString:@","];
                 NSMutableArray *arr = [[NSMutableArray alloc]init];
                 
                 
                 NSData *data = [NSJSONSerialization dataWithJSONObject:variant_arr1 options:NSJSONWritingPrettyPrinted error:nil];
                 NSString *jsonStr = [[NSString alloc] initWithData:data
                                                           encoding:NSUTF8StringEncoding];
                 
                 NSLog(@"json_str ::  %@",jsonStr);
                 NSString *str_custom,*str_varient;
                 
                 
                 
                 
     if([custom isEqualToString:@"Yes"] && [variant isEqualToString:@"No"])
     {
         variant_stat = @"custom";
         
        // if([[variant_arr1 objectAtIndex:0] count] < 1)
        // {
            NSMutableDictionary *dict_ids= [NSMutableDictionary dictionary];
             for(int i = 0; i<[varinat_first count];i++)
             {
                 
                 
                 [dict_ids addEntriesFromDictionary:[[varinat_first objectAtIndex:i] valueForKey:@"0"]];
             }
             
             NSLog(@"000000 %@",dict_ids);
             
             NSData *data = [NSJSONSerialization dataWithJSONObject:dict_ids options:NSJSONWritingPrettyPrinted error:nil];
             NSString *jsonStr = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
             
             NSLog(@"json_str ::  %@",jsonStr);

             str_custom = jsonStr;
             str_varient = @"";

             

     }
     else if([custom isEqualToString:@"No"] && [variant isEqualToString:@"Yes"])
     {
         
         variant_stat = @"variant";
         
//         if([[variant_arr1 objectAtIndex:0] count] < 1)
//         {
             NSMutableDictionary *dict_ids= [NSMutableDictionary dictionary];
             for(int i = 0; i<[varinat_first count];i++)
             {
                 
                 
                 [dict_ids addEntriesFromDictionary:[[varinat_first objectAtIndex:i] valueForKey:@"0"]];
             }
             
             NSLog(@"000000 %@",dict_ids);
             
             NSData *data = [NSJSONSerialization dataWithJSONObject:dict_ids options:NSJSONWritingPrettyPrinted error:nil];
             NSString *jsonStr = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
             
             NSLog(@"json_str ::  %@",jsonStr);
             str_custom = @"";
             str_varient = jsonStr;


         parameters = @{@"pdtId":pdId,@"userId":user_id,@"quantity":items_count,variant_stat:[arr componentsJoinedByString:@","],@"custom":@""};
     }
     else
     {
         variant_stat = @"variant";
         parameters = @{@"pdtId":pdId,@"userId":user_id,@"quantity":items_count,@"custom":@"",@"variant":@""};
         str_custom = @"";
         str_varient = @"";

     }
        
     @try
    {
        
                     NSString *urlString =[NSString stringWithFormat:@"%@apis/addcartapi.json",SERVER_URL];
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
                     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pdtId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
                     [body appendData:[[NSString stringWithFormat:@"%@",pdId]dataUsingEncoding:NSUTF8StringEncoding]];
                     [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                     
                     // another text parameter
                     [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                     [body appendData:[[NSString stringWithFormat:@"%@",user_id]dataUsingEncoding:NSUTF8StringEncoding]];
                     [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                     
                     [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"quantity\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                     [body appendData:[[NSString stringWithFormat:@"%@",items_count]dataUsingEncoding:NSUTF8StringEncoding]];
                     [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        //Custom
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"custom\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",str_custom]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        //Varient
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"variant\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",str_varient]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        

        
        
      

        
                     //
                     NSError *er;
                     //    NSHTTPURLResponse *response = nil;
                     
                     // close form
                     [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                     
                     // set request body
                     [request setHTTPBody:body];
                     
                     NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            [activityIndicatorView stopAnimating];
             VW_overlay.hidden = YES;

                     if (returnData) {
                        NSMutableDictionary *json_DATA = [[NSMutableDictionary alloc]init];
                         json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:returnData options:NSASCIIStringEncoding error:&er];
                         NSString *stat =[NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
                         if([stat isEqualToString:@"1"])
                         {
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                             [self cart_count];

                             [alert show];

                     }
                         else{
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                             
                             [alert show];

                         }
                     }
                     else{
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         
                         [alert show];
                     }
                 }
                 @catch(NSException *exception)
                 {
                     [activityIndicatorView stopAnimating];
                     VW_overlay.hidden = YES;
                     NSLog(@"THE EXception:%@",exception);
                     
                 }
             }
         }
    

/* NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
 NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@apis/addcartapi.json",SERVER_URL]];
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
 [request setURL:urlProducts];
 [request setHTTPMethod:@"POST"];
 [request setHTTPBody:postData];
 [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 if (error) {
//     VW_overlay.hidden=YES;
     [activityIndicatorView stopAnimating];
 }
 
 if(aData)
 {
      NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingAllowFragments error:&error];
      NSLog(@"Response  Error %@ Response %@",error,dict);
      //[HttpClient createaAlertWithMsg:[dict valueForKey:@"message"] andTitle:@""];
     
     if([[dict valueForKey:@"success"] intValue] == 1)
     {
         VW_overlay.hidden=YES;
         [activityIndicatorView stopAnimating];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[dict valueForKey:@"message"]delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
         [alert show];
         NSLog(@"The Wishlist%@",json_Response_Dic);
     }
     else{
         VW_overlay.hidden=YES;
         [activityIndicatorView stopAnimating];
     }
 }
 }
     }
     }
     @catch(NSException *exception)
     {
         VW_overlay.hidden=YES;
         [activityIndicatorView stopAnimating];
     }
     */
         }
    
 }

/*-(void)add_cart_action
{
 
 
    @try
    {
        //        NSUserDefaults *user_dflts = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
        NSString *poduct_id = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] valueForKey:[keys objectAtIndex:0]]valueForKey:@"id"]];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/addcartapi/%@/%@/1.json",SERVER_URL,user_id,poduct_id];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                if (data) {
                    json_Response_Dic = data;
                    if(json_Response_Dic)
                    {
                        if([[json_Response_Dic valueForKey:@"success"] intValue] == 1)
                        {
                        VW_overlay.hidden=YES;
                        [activityIndicatorView stopAnimating];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_Response_Dic valueForKey:@"message"]delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];
                        NSLog(@"The Wishlist%@",json_Response_Dic);
                        }
                    }
                    else
                    {
                        VW_overlay.hidden=YES;
                        [activityIndicatorView stopAnimating];
                        
                        NSLog(@"The Wishlist%@",json_Response_Dic);
                        
                        
                    }
                    
                    
                }
                VW_overlay.hidden=YES;
                [activityIndicatorView stopAnimating];

                
            });
        }];
    }
    @catch(NSException *exception)
    {
        VW_overlay.hidden=YES;
        [activityIndicatorView stopAnimating];
        NSLog(@"The error is:%@",exception);
        [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
    }
 

    
}*/
- (IBAction)productdetail_to_cartPage:(id)sender {
    [self performSegueWithIdentifier:@"productDetail_to_cart" sender:self];
}

#pragma _product_Detail_api_integration Method Calling

-(void)product_detail_API
{
    
    @try
    {
        varinat_first = [[NSMutableArray alloc]init];
        images_arr = [[NSMutableArray alloc]init];
        variant_arr = [[NSMutableArray alloc]init];
        
        NSUserDefaults *user_dflts = [NSUserDefaults standardUserDefaults];
        NSString *country = [user_dflts valueForKey:@"country_id"];
        NSString *languge = [user_dflts valueForKey:@"language_id"];
        NSString *mercahnt_ID = [NSString stringWithFormat:@"%@",[user_dflts valueForKey:@"Mercahnt_ID"]];
     
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        NSString *urlGetuser;
        @try
        {
            //        NSUserDefaults *user_dflts = [NSUserDefaults standardUserDefaults];
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
            user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
            if([user_id isEqualToString:@"(null)"])
            {
                 urlGetuser =[NSString stringWithFormat:@"%@Pages/details/%@/%@/%@/%@/Customer.json",SERVER_URL,[user_dflts valueForKey:@"product_list_key_sub"],mercahnt_ID,country,languge];
                url_share =[NSString stringWithFormat:@"%@Pages/details/%@/%@/%@/%@",SERVER_URL,[user_dflts valueForKey:@"product_list_key_sub"],mercahnt_ID,country,languge];
                
            }
            else
            {
               urlGetuser =[NSString stringWithFormat:@"%@Pages/details/%@/%@/%@/%@/%@/Customer.json",SERVER_URL,[user_dflts valueForKey:@"product_list_key_sub"],mercahnt_ID,country,languge,user_id];
                url_share =[NSString stringWithFormat:@"%@Pages/details/%@/%@/%@/%@/%@",SERVER_URL,[user_dflts valueForKey:@"product_list_key_sub"],mercahnt_ID,country,languge,user_id];
                
                
            }
        }
        @catch(NSException *excepion)
        {
             urlGetuser =[NSString stringWithFormat:@"%@Pages/details/%@/%@/%@/%@/Customer.json",SERVER_URL,[user_dflts valueForKey:@"product_list_key_sub"],mercahnt_ID,country,languge];
        }

        
     
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                if (data) {
                    json_Response_Dic = data;
                    if(json_Response_Dic)
                    {
                        VW_overlay.hidden=YES;
                       [activityIndicatorView stopAnimating];
                   
                        
                    //NSLog(@"Color and  :::%@",[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:1]);
                    @try {
                        
                        
                        #pragma mark retriving all images
                        
                        
                        //https://codewebber.s3.amazonaws.com/Merchant1/Medium/09596.jpg
                        
                        
                        
                         keys = [[json_Response_Dic valueForKey:@"products"]allKeys];
                        NSLog(@"All keys  %@",keys);
                        
                        NSLog(@"%@",[NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_image"]]);
                        
                        //NSLog(@"%@",[[[json_Response_Dic valueForKey:@"products"] valueForKey:[keys objectAtIndex:0]] valueForKey:@"product_image"]);
                        [images_arr addObject:[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_image"]];
                        
                        for ( int i=0; i<[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_medias"] count]; i++) {
                            
                            if ([[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_medias"] objectAtIndex:i] valueForKey:@"media_type"] isEqualToString:@"Image"]) {
                                
                                NSString *imageUrl = [NSString stringWithFormat:@"https://codewebber.s3.amazonaws.com/Merchant%@/Medium/%@",[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"merchant_id"],[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_medias"] objectAtIndex:i] valueForKey:@"media"]];
                                
                                [images_arr addObject:imageUrl];
                                
                                                        }
                        }
                        
                        self.custom_story_page_controller.numberOfPages = images_arr.count;
                        
                        
                        if([[json_Response_Dic valueForKey:@"getVariantNames"] isKindOfClass:[NSArray class]])
                        {
                            for(int i =0;i<[[json_Response_Dic valueForKey:@"getVariantNames"] count];i++)
                            {
                                NSArray *key_arr = [[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i] valueForKey:@"0"] allKeys];
                                
                                NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
                                NSArray* sortedArray = [key_arr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                                key_arr = sortedArray;

                                
                                NSString *str  = [[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i] valueForKey:@"0"] valueForKey:[key_arr objectAtIndex:0]];
                              
                                NSDictionary *temp_dict;
                                NSString *variant = [[json_Response_Dic valueForKey:@"products"] valueForKey:@"variant"];
                                NSString *custom = [[json_Response_Dic valueForKey:@"products"] valueForKey:@"customOption"];
                                NSString *main_variant_ID;
                                if([custom isEqualToString:@"Yes"] && [variant isEqualToString:@"No"])
                                {
                                     main_variant_ID = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i]  valueForKey:@"custom_option_id"]];
                                }
                                else if([custom isEqualToString:@"No"] && [variant isEqualToString:@"Yes"])
                                {
                                   main_variant_ID = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i]  valueForKey:@"variant_id"]];
                                }
                              
                                NSString *sub_ID = [key_arr objectAtIndex:0];
                                //temp_str =[NSString stringWithFormat:@"%@ : %@",main_variant_ID,sub_ID];
                                temp_dict = @{@"variant_name":str,@"0":@{main_variant_ID:sub_ID}};
                                [varinat_first addObject:temp_dict];
                            }
                             [self update_price];
                        }                       
                          NSLog(@"%@",json_Response_Dic);
                        NSLog(@"%@",varinat_first);
                        
                        NSArray *size_Color_arr = [json_Response_Dic valueForKey:@"getVariantNames"];
                        if([size_Color_arr isKindOfClass:[NSArray class]])
                        {
                        color_arr=[[NSMutableArray alloc]init];
                       size_arr = [[NSMutableArray alloc]init];
                        
                        for (int i=0; i<size_Color_arr.count; i++) {
                            @try {
                                if ([[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i] valueForKey:@"variant"] isEqualToString:@"Colour"]) {
                                    [color_arr addObject:[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i] valueForKey:@"0"]];
                                }
                                if ([[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i] valueForKey:@"variant"] isEqualToString:@"Size"]) {
                                    [size_arr addObject:[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i] valueForKey:@"0"]];
                                }
                                
                            } @catch (NSException *exception) {
                                NSLog(@"%@",exception);
                            }
                    
                        }
                            
                        [self set_Data_to_UIElements];
                        [self.collection_images reloadData];
                        [self.collectionview_variants reloadData];
                        [_collection_related_products reloadData];
                            [self addSEgmentedControl];
                        [self set_UP_VIEW];
                       [self update_price];
                        self.segmentedControl4.selectedSegmentIndex = 0;
                        [self segmentedControlChangedValue:self.segmentedControl4];
                            
                        }
                        else
                        {
                            [self set_Data_to_UIElements];
                            [self.collection_images reloadData];
                             [self.collectionview_variants reloadData];
                             [_collection_related_products reloadData];
                             [self addSEgmentedControl];
                            [self set_UP_VIEW];
                            self.segmentedControl4.selectedSegmentIndex = 0;
                            [self segmentedControlChangedValue:self.segmentedControl4];

                        }
                       

                    } @catch (NSException *exception) {
                        VW_overlay.hidden = YES;
                    [activityIndicatorView stopAnimating];
                         [self set_UP_VIEW];

                        NSLog(@"%@",exception);
                    }
                    }
                    /**********Required Data**************/
                    //NSLog(@" Color %@",[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:0] valueForKey:@"0"]);
                    
                    //                        NSLog(@" Color %@",[[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:0] valueForKey:@"0"] allKeys]);
                    //                         NSLog(@"%@",[[[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:1] valueForKey:@"0"] allKeys]objectAtIndex:0]);
                   
                    //NSLog(@"%@",[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:1]valueForKey:0])
                    
                    //****************Required Data****************
                    //title_str = [[[[[json_Response_Dic valueForKey:@"products"] objectAtIndex:0]valueForKey:@"product_descriptions"] objectAtIndex:0]valueForKey:@"title"];
                    
                    //current_price = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] objectAtIndex:0] valueForKey:@"product_price"]];
                    
                    //avg_rating = [NSString stringWithFormat:@"%@",[json_Response_Dic valueForKey:@"avgRating"]];
                    
                    //product_description = [[[[[json_Response_Dic valueForKey:@"products"] objectAtIndex:0]valueForKey:@"product_descriptions"] objectAtIndex:0]valueForKey:@"description"];
                    //NSLog(@"%@",product_description);
                    
                    //img_Url = [[[json_Response_Dic valueForKey:@"products"] objectAtIndex:0] valueForKey:@"product_image"];
                    //NSLog(@"PRODUCT IMAGE IS  %@",[[[json_Response_Dic valueForKey:@"products"] objectAtIndex:0] valueForKey:@"product_image"]);
                    //                    NSLog(@"%@",actuel_price);
                    //                    NSLog(@"%@",avg_rating);
                    
                    //NSLog(@"%@",title_str);
                    
                    
                }
                
            });
        }];
    }
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
    }
}



#pragma UIWebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    CGRect frame = webView.frame;
    frame.size.height = 5.0f;
    webView.frame = frame;
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error
{
    [activityIndicatorView stopAnimating];
    NSLog(@"%@",[error localizedDescription]);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    CGSize mWebViewTextSize = [webView sizeThatFits:CGSizeMake(1.0f, 1.0f)]; // Pass about any size
    CGRect mWebViewFrame = webView.frame;
    mWebViewFrame.size.height = mWebViewTextSize.height;
    webView.frame = mWebViewFrame;
    
    CGRect  frame_set = _VW_fourth.frame;
    frame_set.size.height = webView.frame.origin.y +  mWebViewFrame.size.height+10;
    frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
    _VW_fourth.frame = frame_set;
    
    if([[json_Response_Dic valueForKey:@"relatedProducts"] isKindOfClass:[NSArray class]])
    {
        
        frame_set = _VW_fifth.frame;
        frame_set.origin.y = _VW_fourth.frame.origin.y + _VW_fourth.frame.size.height + 1;
        if([[json_Response_Dic valueForKey:@"relatedProducts"] count]<1)
        {
            frame_set.size.height = 0;
        }
//        else{
//            frame_set.size.height = 281;
//            
//        }
        
        frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
        _VW_fifth.frame = frame_set;
        scroll_ht = _VW_fifth.frame.origin.y+ _VW_fifth.frame.size.height;
    }
    else{
        scroll_ht = _VW_fourth.frame.origin.y+ _VW_fourth.frame.size.height;
        
        
    }
    [self viewDidLayoutSubviews];

    
   
    
    //Disable bouncing in webview
    for (id subview in webView.subviews) {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
            [subview setBounces:NO];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark cart_count_api
-(void)cart_count{
    
    NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
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
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *custmr_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    NSString *product_ids = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_descriptions"] objectAtIndex:0] valueForKey:@"product_id"]];
    
   // NSDictionary *parameters = @{@"quantity":_TXT_count.text,@"productId":product_ids,@"customerId":custmr_id};

    @try
    {
    NSString *urlString =[NSString stringWithFormat:@"%@apis/updatecartapi.json",SERVER_URL];
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
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"quantity\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",_TXT_count.text]dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"productId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
    [body appendData:[[NSString stringWithFormat:@"%@",product_ids]dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // another text parameter
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"customerId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",custmr_id]dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    
    
    //
    NSError *er;
    //    NSHTTPURLResponse *response = nil;
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    
    if (returnData) {
        NSMutableDictionary *json_DATA = [[NSMutableDictionary alloc]init];
        json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:returnData options:NSASCIIStringEncoding error:&er];
        NSString *stat =[NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
        if([stat isEqualToString:@"1"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}
@catch(NSException *exception)
{
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    NSLog(@"THE EXception:%@",exception);
    
}
}



//    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/updatecartapi.json",SERVER_URL];
//    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//
//
//    [HttpClient api_with_post_params:urlGetuser andParams:parameters completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (error) {
//                NSLog(@"%@",[error localizedDescription]);
//            }
//            if (data) {
//                //NSLog(@"%@",data);
//
//
//                @try {
//                    [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
//                } @catch (NSException *exception) {
//                    NSLog(@"exception:: %@",exception);
//                }
//
//
//            }
//
//        });
//
//    }];
//}
#pragma picket_actions
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    return picker_arr.count;
//
//}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return picker_arr.count;
    
    }
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return picker_arr[row];
    
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"picker_component:%@",picker_arr[row]);
    
    
    [self set_data_variant:picker_arr[row]];
    [data_arr replaceObjectAtIndex:tag withObject:picker_arr[row]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:
                              0];
    
    
    indexPaths = [[NSMutableArray alloc] initWithObjects:indexPath, nil];
   
    
    
}

-(void)set_data_variant :(NSString *)str_var
{
    NSString *main_variant_ID;NSString *sub_ID ;
    NSString *variant = [[json_Response_Dic valueForKey:@"products"] valueForKey:@"variant"];
    NSString *custom = [[json_Response_Dic valueForKey:@"products"] valueForKey:@"customOption"];

    for(int i= 0;i< [[json_Response_Dic valueForKey:@"getVariantNames"] count];i++)
    {
        for(int j =0 ; j<[[[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i]valueForKey:@"0"] allObjects] count];j++)
        {
                if([str_var isEqualToString:[[[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i]valueForKey:@"0"] allObjects]objectAtIndex:j]])
                {
                    
                    
                    if([custom isEqualToString:@"Yes"] && [variant isEqualToString:@"No"])
                    {
                        main_variant_ID = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i]  valueForKey:@"custom_option_id"]];
                    }
                    else if([custom isEqualToString:@"No"] && [variant isEqualToString:@"Yes"])
                        
                    {
                        main_variant_ID = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i]  valueForKey:@"variant_id"]];
                        
                    }

                    sub_ID = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i] valueForKey:@"0"] allKeys] objectAtIndex:j]];
                    [temp_DICT setObject:sub_ID forKey:main_variant_ID];
                }
            
        }
    }
    
    NSDictionary *temp_dct = @{@"0":@{main_variant_ID:sub_ID}};
    [varinat_first replaceObjectAtIndex:tag withObject:temp_dct];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_reviews"];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    review_cell *cell = (review_cell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"review_cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    cell.LBL_review.text =[NSString stringWithFormat: @"%@ ",[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_reviews"] objectAtIndex:indexPath.row]valueForKey:@"rating"]];
    cell.LBL_type_rate.text = @"Excellent";
    
    NSString *str_name = @"";
    NSString *str_date = @"";
    NSString *str_rview = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_reviews"] objectAtIndex:indexPath.row]valueForKey:@"comment"]];
    
    NSString *str_review = [NSString stringWithFormat:@"%@ %@\n%@",str_name,str_date,str_rview];
  
    
    
    if ([cell.LBL_name respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:cell.LBL_name.textColor,
                                  NSFontAttributeName:cell.LBL_name.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str_review attributes:attribs];
        
        
        
        NSRange ename = [str_review rangeOfString:str_name];
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
        
        
        
        
        NSRange cmp = [str_review rangeOfString:str_date];
        //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:21.0]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor lightGrayColor]}
                                    range:cmp];
        }
        NSRange cmps = [str_review rangeOfString:str_rview];
        //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:21.0]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor darkGrayColor]}
                                    range:cmps];
        }

        cell.LBL_name.attributedText = attributedText;
    }
    else
    {
        cell.LBL_name.text = str_review;
    }

    
    

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma Button ACIONS

-(void)Close_action
{
     [self.view endEditing:YES];
    
}
-(void)countrybuttonClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    NSString *main_variant_ID;NSString *sub_ID ;
    NSString *variant = [[json_Response_Dic valueForKey:@"products"] valueForKey:@"variant"];
    NSString *custom = [[json_Response_Dic valueForKey:@"products"] valueForKey:@"customOption"];
    NSLog(@"The variant ARR:%@",data_arr);
    
    for(int i= 0;i< [[json_Response_Dic valueForKey:@"getVariantNames"] count];i++)
    {
        for(int j =0 ; j<[[[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i]valueForKey:@"0"] allObjects] count];j++)
        {
            for(int k = 0;k<[data_arr count];k++)
            {
                if([[data_arr objectAtIndex:k] isEqualToString:[[[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i]valueForKey:@"0"] allObjects]objectAtIndex:j]])
                {
                    
                    if([custom isEqualToString:@"Yes"] && [variant isEqualToString:@"No"])
                    {
                        main_variant_ID = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i]  valueForKey:@"custom_option_id"]];
                    }
                    else if([custom isEqualToString:@"No"] && [variant isEqualToString:@"Yes"])
                        
                    {
                        main_variant_ID = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i]  valueForKey:@"variant_id"]];
                        
                    }
                    
                    sub_ID = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i] valueForKey:@"0"] allKeys] objectAtIndex:j]];
                    
                    
                    
                    [temp_DICT setObject:sub_ID forKey:main_variant_ID];
                }
            }
        }
    }
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [_collectionview_variants reloadItemsAtIndexPaths:indexPaths];
    [UIView setAnimationsEnabled:animationsEnabled];
    
    noDuplicates = [[NSMutableArray alloc]init];
    [noDuplicates addObject:temp_DICT];
    NSArray *hasDuplicates = noDuplicates;
    variant_arr1 = [[NSSet setWithArray: hasDuplicates] allObjects];
    ///////////////
    NSLog(@"%@",variant_arr1);
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(update_price) withObject:activityIndicatorView afterDelay:0.01];
    
    
    
 }
-(void)update_price
{
    NSString *variant = [[json_Response_Dic valueForKey:@"products"] valueForKey:@"variant"];
    NSString *custom = [[json_Response_Dic valueForKey:@"products"] valueForKey:@"customOption"];
    NSString *pdId = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_descriptions"] objectAtIndex:0] valueForKey:@"product_id"]];
    
    NSString *variant_stat; NSDictionary *parameters;
    NSLog(@"THE VARIANT COUNT:%lu",(unsigned long)variant_arr1.count);
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dict_ids= [NSMutableDictionary dictionary];
    for(int i = 0; i<[varinat_first count];i++)
    {
        
        [dict_ids addEntriesFromDictionary:[[varinat_first objectAtIndex:i] valueForKey:@"0"]];
    }
    
    NSLog(@"000000 %@",dict_ids);
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict_ids options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    
    NSLog(@"json_str ::  %@",jsonStr);
    NSString *str_custom,*str_varient;
    
    
    if([custom isEqualToString:@"Yes"] && [variant isEqualToString:@"No"])
    {
        variant_stat = @"custom";
        
        
        parameters = @{@"pdtId":pdId,variant_stat:[arr componentsJoinedByString:@","],@"varaint":@""};
        
        str_custom = jsonStr;
        str_varient = @"";
        
        
    }
    else if([custom isEqualToString:@"No"] && [variant isEqualToString:@"Yes"])
    {
        
        variant_stat = @"variant";
        
        parameters = @{@"pdtId":pdId,variant_stat:[arr componentsJoinedByString:@","],@"custom":@""};
        
        str_custom = @"";
        str_varient = jsonStr;
        
    }
    else
    {
        variant_stat = @"variant";
        parameters = @{@"pdtId":pdId,@"custom":@"",@"variant":@""};
        
        str_custom = @"";
        str_varient = @"";
    }
    @try
    {
        //pdtId,custom,variant
        
        NSString *urlString =[NSString stringWithFormat:@"%@apis/VariantcomCheckapi.json",SERVER_URL];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        //    [request setHTTPBody:body];
        
        // pdtId
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pdtId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
        [body appendData:[[NSString stringWithFormat:@"%@",pdId]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        //Custom
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"custom\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",str_custom]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        //Varient
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"variant\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",str_varient]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        //
        NSError *er;
        //    NSHTTPURLResponse *response = nil;
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&er];
      
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        
        if (returnData) {
            NSMutableDictionary *json_DATA = [[NSMutableDictionary alloc]init];
            json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:returnData options:NSASCIIStringEncoding error:&er];
            
            NSLog(@" After Varient Combination The Data is ::%@",json_DATA);
            
            NSString *stat =[NSString stringWithFormat:@"%@",[[json_DATA  allKeys]objectAtIndex:0]];
            if([stat isEqualToString:@"variant"])
            {
                if([[[json_DATA valueForKey:@"variant"] valueForKey:@"message"] isEqualToString:@"Sorry, This Combination is not available"])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[[json_DATA valueForKey:@"variant"] valueForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [alert show];

                }
                else
                {
                      [self update_product:json_DATA];
                }
                
              
            }
            else
            {
                [self update_product_custom:json_DATA];
                
                
                
            }
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            VW_overlay.hidden = YES;
            [activityIndicatorView stopAnimating];

        }
    }
    @catch(NSException *exception)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        NSLog(@"THE EXception:%@",exception);
        
    }

}


- (void)add_to_wish_list
{
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please login to add items to wishlist" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
        alert.tag = 1;
        [alert show];
        
    }
    else
    {

    if ([wish_param isEqualToString:@""])
    {
        VW_overlay.hidden=NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(delete_from_wishLis) withObject:activityIndicatorView afterDelay:0.01];


    }
    else{
        VW_overlay.hidden=NO;
        [activityIndicatorView startAnimating];

        [self performSelector:@selector(wish_list_API) withObject:activityIndicatorView afterDelay:0.01];


        
        
    }
    }
}
- (IBAction)BTN_back_action:(id)sender
{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
//- (IBAction)BTN_cart_action:(id)sender
//{
//    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
//    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
//    if([user_id isEqualToString:@"(null)"])
//    {
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
//        alert.tag = 1;
//        [alert show];
//        
//    }
//    else
//    {
//
//    [self performSegueWithIdentifier:@"productDetail_to_wishList" sender:self];
//    }
//
//}
- (IBAction)BTN_wish_list:(id)sender
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        alert.tag = 1;
        [alert show];
        
    }
    else
    {
        [self performSegueWithIdentifier:@"productDetail_to_wishList" sender:self];


//    if ([[[json_Response_Dic valueForKey:@"products"] valueForKey:@"wishStatus"] isEqualToString:@"No"]) {
//        
//        [self performSelector:@selector(wish_list_API) withObject:activityIndicatorView afterDelay:0.01];
//
//        
//    }
//    else{
//          [HttpClient createaAlertWithMsg:@"already added" andTitle:@""];
//        
//        
  //  }
    }
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
        if(alertView.tag == 1)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login_VC"];
            [self presentViewController:login animated:NO completion:nil];
           
            
            
        }
        else
        {
             NSLog(@"cancel:");
           
        }
        
        
    }
    
    
    
}
-(void)sellers_details
{
    if([[json_Response_Dic valueForKey:@"multipleSellers"] isKindOfClass:[NSDictionary class]])
    {
    [[NSUserDefaults standardUserDefaults] setObject:[json_Response_Dic valueForKey:@"multipleSellers"] forKey:@"multiple_seller_detail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSegueWithIdentifier:@"details_sellers" sender:self];
    }
    
}
- (void)share_action
{
//    if([[detail_dict valueForKey:@"_TrailerURL"] isEqualToString:@""])
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No video available to share" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
//        
//        
//    }
//    else
//    {
    
 //   NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
 //   NSString *custmr_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    NSString *trailer_URL= url_share;
        NSArray* sharedObjects=[NSArray arrayWithObjects:trailer_URL,  nil];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc]                                                                initWithActivityItems:sharedObjects applicationActivities:nil];
        activityViewController.popoverPresentationController.sourceView = self.view;
        [self presentViewController:activityViewController animated:YES completion:nil];
   // }
}

-(void)update_product_custom:(NSMutableDictionary *)update_dic
{
    @try
    {
        NSString *currency = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
        
        
        NSString *mileValue = [NSString stringWithFormat:@"%@",[[json_Response_Dic valueForKey:@"products"] valueForKey:@"mileValue"]];
        
        NSString  *actuel_price = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_price"]];
        
        NSString *special_price = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"special_price"]];
        
        
        NSString *doha_miles = [NSString stringWithFormat:@"%@",mileValue];
        NSString *mils  = @"Doha Miles";
        
        
        
        
        if ([special_price isEqualToString:@""]|| [special_price isEqualToString:@"<null>"]||[special_price isEqualToString:@"<null>"]) {
            
            NSString *str = [[update_dic valueForKey:@"custom"] valueForKey:@"price"];
            NSString *str_custom;int VAL;
            if([str containsString:@"+"])
            {
                str_custom = [str stringByReplacingOccurrencesOfString:@"+" withString:@""];
                
                VAL = [actuel_price intValue] + [str_custom intValue];
                
            }
            else if([str containsString:@"-"])
            {
                str_custom = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
                VAL = [actuel_price intValue] - [str_custom intValue];
            }
            
            NSLog(@"THE UPDATED PRICE%d",VAL);
            doha_miles = [NSString stringWithFormat:@"%d",[special_price intValue]*[[[update_dic valueForKey:@"custom"] valueForKey:@"oneQARtoDM"]intValue]];
            
            NSString *text = [NSString stringWithFormat:@"%@ %@ / %@ %@",currency,actuel_price,mils,doha_miles];
            
            NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
            
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                paragraphStyle.alignment                = NSTextAlignmentRight;
                
            }else{
                
                paragraphStyle.alignment                = NSTextAlignmentLeft;
            }
            
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
            
            //attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:17.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:[text rangeOfString:actuel_price]];
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:17.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:[text rangeOfString:doha_miles]];
            
            
            
            
            _LBL_prices.attributedText = attributedText;
            _LBL_discount.text = @"";
            
            
        }
        else{
            
            
            actuel_price = [currency stringByAppendingString:actuel_price];
            
            NSString *str = [[update_dic valueForKey:@"custom"] valueForKey:@"price"];
            NSString *str_custom;int VAL;
            if([str containsString:@"+"])
            {
                str_custom = [str stringByReplacingOccurrencesOfString:@"+" withString:@""];
                
                VAL = [special_price intValue] + [str_custom intValue];
                
            }
            else if([str containsString:@"-"])
            {
                str_custom = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
                VAL = [special_price intValue] - [str_custom intValue];
            }
            
            NSLog(@"THE UPDATED PRICE%d",VAL);
            special_price = [NSString stringWithFormat:@"%d",VAL];
            doha_miles = [NSString stringWithFormat:@"%d",[special_price intValue]*[[[update_dic valueForKey:@"custom"] valueForKey:@"oneQARtoDM"]intValue]];
            
            
            NSString *text = [NSString stringWithFormat:@"%@ %@ %@ / %@ %@",currency,special_price,actuel_price,mils,doha_miles];
            
            
            
            
            
            if ([_LBL_prices respondsToSelector:@selector(setAttributedText:)]) {
                
                NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
                
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    paragraphStyle.alignment                = NSTextAlignmentRight;
                    
                }else{
                    
                    paragraphStyle.alignment                = NSTextAlignmentLeft;
                }
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
                
                NSRange ename = [text rangeOfString:special_price];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:17.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                        range:ename];
                
                
                NSRange cmp = [text rangeOfString:actuel_price];
                //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0]}
                                        range:cmp];
                
                
                NSRange miles_price = [text rangeOfString:doha_miles];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:17.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                        range:miles_price];
                
                NSRange miles = [text rangeOfString:mils];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0]}
                                        range:miles];
                
                
                [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                       value:@2
                                       range:NSMakeRange([special_price length]+currency.length+2, [actuel_price length])];
                
                _LBL_prices.attributedText = attributedText;
            }
            else
            {
                _LBL_prices.text = text;
            }
            //            float disc = [[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_price"] integerValue]-[special_price integerValue];
            //            float digits = disc/[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_price"] integerValue];
            //            int discount = digits *100;
            //            NSString *of;
            //            if(discount == 0)
            //            {
            //                of=@"";
            //                _LBL_discount.text =[NSString stringWithFormat:@""];
            //            }
            //            else if(discount == 100)
            //            {
            //                of=@"";
            //                _LBL_discount.text =[NSString stringWithFormat:@""];
            //
            //            }
            //            else
            //            {
            //                of = @"% off";
            //                _LBL_discount.text =[NSString stringWithFormat:@"%d%@",discount,of];
            //            }
            //
            
            
        }
        
    }@catch(NSException *exception)
    {
        
    }
    
    
}


-(void)update_product:(NSMutableDictionary *)update_dic
{
    @try
    {
        NSString *currency = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
        
        
        NSString *mileValue = [NSString stringWithFormat:@"%@",[[update_dic valueForKey:@"variant"] valueForKey:@"dohamiles"]];
        
        
        NSString  *actuel_price = [NSString stringWithFormat:@"%@ %@",currency,[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_price"]];
        
        NSString *special_price = [NSString stringWithFormat:@"%@",[[update_dic valueForKey:@"variant"] valueForKey:@"newPrice"]];
        
        
        NSString *doha_miles = [NSString stringWithFormat:@"%@",mileValue];
        NSString *mils  = @"Doha Miles";
        
        
        if ([special_price isEqualToString:@""]|| [special_price isEqualToString:@"<null>"]||[special_price isEqualToString:@"<null>"]) {
            
            
            
            NSString *text = [NSString stringWithFormat:@"%@ %@ / %@ %@",currency,actuel_price,mils,doha_miles];
            NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
            
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                paragraphStyle.alignment                = NSTextAlignmentRight;
                
            }else{
                
                paragraphStyle.alignment                = NSTextAlignmentLeft;
            }
            
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
            
           // attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:[text rangeOfString:actuel_price]];
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0],NSForegroundColorAttributeName:[UIColor darkGrayColor]}
                                    range:[text rangeOfString:doha_miles]];
            
            
            _LBL_prices.attributedText = attributedText;
            _LBL_discount.text = @"";
            
        }
        else{
            
            
            // NSString *doha_miles = @"QR 6758";
          //  actuel_price = [currency stringByAppendingString:actuel_price];
            
            NSString *text = [NSString stringWithFormat:@"%@ %@ %@ / %@ %@",currency,special_price,actuel_price,mils,doha_miles];
            
            
            
            
            if ([_LBL_prices respondsToSelector:@selector(setAttributedText:)]) {
                
                NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
                
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    paragraphStyle.alignment                = NSTextAlignmentRight;
                    
                }else{
                    
                    paragraphStyle.alignment                = NSTextAlignmentLeft;
                }
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                        range:[text rangeOfString:currency]];

                
                NSRange ename = [text rangeOfString:special_price];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                        range:ename];
                
                
                NSRange cmp = [text rangeOfString:actuel_price];
                //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                        range:cmp];
                
                
                NSRange miles_price = [text rangeOfString:doha_miles];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                        range:miles_price];
                
                NSRange miles = [text rangeOfString:mils];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0],NSForegroundColorAttributeName:[UIColor darkGrayColor]}
                                        range:miles];
                
                
                [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                       value:@2
                                       range:NSMakeRange([special_price length]+currency.length+2, [actuel_price length])];
                
                _LBL_prices.attributedText = attributedText;
            }
            else
            {
                _LBL_prices.text =text;
            }
            
        }
        
    }@catch(NSException *exception)
    {
        
    }
    
}
// product Detail to Wish List

- (void)product_detail_cart_page {
   
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        alert.tag = 1;
        [alert show];
        
    }
    else
    {
           [self performSegueWithIdentifier:@"product_detail_cart_page" sender:self];
   
    }
}
@end
