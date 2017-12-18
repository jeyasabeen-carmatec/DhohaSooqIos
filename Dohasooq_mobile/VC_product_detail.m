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
    float scroll_ht;
    NSString *product_id,*wish_param;

    //NSString *actuel_price,*avg_rating,*discount,*review_count;
    //NSString **product_description,*img_Url,*title_str,*current_price;
}
@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;


@end

@implementation VC_product_detail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    json_Response_Dic = [[NSMutableDictionary alloc]init];
    temp_DICT = [[NSMutableDictionary alloc]init];


    
   

    [self addSEgmentedControl];

    [self.collection_images registerNib:[UINib nibWithNibName:@"product_detail_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_image"];
    [self.collection_related_products registerNib:[UINib nibWithNibName:@"product_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_product"];

    
    
    
}

-(void)viewWillAppear:(BOOL)animated
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
    
   // [self segment_ACTION];

//    temp_arr = [[NSMutableArray alloc]init];
//    temp_arr = [NSMutableArray arrayWithObjects:@"upload-2.png",@"upload-2.png",@"upload-2.png",@"upload-2.png",nil];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
       } forState:UIControlStateNormal];
    @try
    {
  
    [_BTN_fav setBadgeEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 4)];
    [_BTN_cart setBadgeEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 4)];
    }
    @catch(NSException *exception)
    {
        
    }

    
    
   CGRect  frame_set = _VW_First.frame;
   frame_set.size.height = _custom_story_page_controller.frame.origin.y + _custom_story_page_controller.frame.size.height;
    frame_set.size.width = self.Scroll_content.frame.size.width;
    _VW_First.frame = frame_set;
    [self.Scroll_content addSubview:_VW_First];
  //  [self set_Data_to_UIElements];
    _LBL_item_name.numberOfLines = 0;
    [_LBL_item_name sizeToFit];
    

    
    starRatingView = [[HCSStarRatingView alloc] init];
    starRatingView.frame = CGRectMake(_LBL_item_name.frame.origin.x-2, _LBL_item_name.frame.origin.y+_LBL_item_name.frame.size.height + 3, 100.0f, _LBL_item_name.frame.size.height - 10);
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 0;
    starRatingView.tintColor = [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];
    starRatingView.allowsHalfStars = YES;
  //  starRatingView.value = 2.5f;
    [self.VW_second addSubview:starRatingView];
    
    
   
    frame_set = _LBL_prices.frame;
    frame_set.origin.y = starRatingView.frame.origin.y + starRatingView.frame.size.height;
    _LBL_prices.frame = frame_set;
    
    frame_set = _LBL_discount.frame;
    frame_set.origin.y = _LBL_prices.frame.origin.y + _LBL_prices.frame.size.height;
    _LBL_discount.frame = frame_set;
    
    frame_set = _VW_second.frame;
    frame_set.origin.y = _VW_First.frame.origin.y + _VW_First.frame.size.height + 3;
    frame_set.size.height = _LBL_discount.frame.origin.y + _LBL_discount.frame.size.height + 10;
    frame_set.size.width = self.Scroll_content.frame.size.width;
    _VW_second.frame = frame_set;
    [self.Scroll_content addSubview:_VW_second];
    
    frame_set = _BTN_play.frame;
    frame_set.origin.x = self.view.frame.size.width - _BTN_play.frame.size.width - 20;
    frame_set.origin.y = (self.VW_second.frame.origin.y - _BTN_play.frame.size.height / 2) - 4 ;
    _BTN_play.frame = frame_set;
    [self.Scroll_content addSubview:_BTN_play];
    
    frame_set = _BTN_share.frame;
    frame_set.origin.x = 20;
    frame_set.origin.y = (self.VW_second.frame.origin.y - _BTN_share.frame.size.height / 2) - 4 ;
    _BTN_share.frame = frame_set;
    [self.Scroll_content addSubview:_BTN_share];


    
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
    NSString *cod_TEXT = [NSString stringWithFormat:@"> Cash on Delivery %@\n>%@\n>freeShipping%@",[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"cod"],[[json_Response_Dic valueForKey:@"products"] valueForKey:@"dispatchTime"],[[json_Response_Dic valueForKey:@"products"] valueForKey:@"freeShipping"]];
    cod_TEXT = [cod_TEXT stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        _LBL_delivery_cod.text = cod_TEXT;
    }
    @catch(NSException *exception)
    {
        
    }
   
    _LBL_delivery_cod.numberOfLines = 0;
    [_LBL_delivery_cod sizeToFit];
    
    
    frame_set = _LBL_sold_by.frame;
    frame_set.origin.y = _LBL_delivery_cod.frame.origin.y + _LBL_delivery_cod.frame.size.height + 5;
    _LBL_sold_by.frame = frame_set;
    
    frame_set = _IMG_merchant.frame;
    frame_set.origin.y = _LBL_sold_by.frame.origin.y + _LBL_sold_by.frame.size.height +5;
    _IMG_merchant.frame = frame_set;
    
    [_LBL_merchant_sellers sizeToFit];
    
    frame_set = _LBL_merchant_sellers.frame;
    frame_set.origin.y = _LBL_sold_by.frame.origin.y + _LBL_sold_by.frame.size.height + 5;
     _LBL_merchant_sellers.frame = frame_set;
    
    frame_set = _LBL_more_sellers.frame;
    frame_set.origin.y = _LBL_merchant_sellers.frame.origin.y + _LBL_merchant_sellers.frame.size.height +5;
    _LBL_more_sellers.frame = frame_set;
    
    frame_set = _QTY.frame;
    frame_set.origin.y = _LBL_more_sellers.frame.origin.y + _LBL_more_sellers.frame.size.height;
    _QTY.frame = frame_set;
    
    frame_set = _BTN_minus.frame;
   frame_set.origin.y = _LBL_more_sellers.frame.origin.y + _LBL_more_sellers.frame.size.height;
    _BTN_minus.frame = frame_set;
    
    frame_set = _TXT_count.frame;
    frame_set.origin.y = _LBL_more_sellers.frame.origin.y + _LBL_more_sellers.frame.size.height;
    _TXT_count.frame = frame_set;
    
    frame_set = _BTN_plus.frame;
    frame_set.origin.y = _LBL_more_sellers.frame.origin.y + _LBL_more_sellers.frame.size.height;
    _BTN_plus.frame = frame_set;
    
    frame_set = _collectionview_variants.frame;
   frame_set.origin.y = _TXT_count.frame.origin.y + _TXT_count.frame.size.height + 20;
    _collectionview_variants.frame = frame_set;
    
    @try
    {
    
    
    if([[json_Response_Dic valueForKey:@"getVariantNames"] isKindOfClass:[NSArray class]])
    {
        
        if([[json_Response_Dic valueForKey:@"getVariantNames"] count] < 1)
        {
            
            frame_set = _VW_third.frame;
            frame_set.origin.y = _VW_second.frame.origin.y + _VW_second.frame.size.height + 3;
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
            frame_set.origin.y = _VW_second.frame.origin.y + _VW_second.frame.size.height + 3;
            frame_set.size.height =_collectionview_variants.frame.origin.y + _collectionview_variants.frame.size.height;
            frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
            _VW_third.frame = frame_set;
            
        }

    }
    else
    {
                frame_set = _VW_third.frame;
                frame_set.origin.y = _VW_second.frame.origin.y + _VW_second.frame.size.height + 3;
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
    
    _TXTVW_description.numberOfLines = 0;

  /*  NSString *description =[NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"]valueForKey:@"0"]valueForKey:@"product_descriptions"] objectAtIndex:0]valueForKey:@"description"]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: 'Poppins-Regular'; font-size:%dpx;}</style>",17]];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[description dataUsingEncoding:NSUTF8StringEncoding]options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}documentAttributes:nil error:nil];
    _TXTVW_description.attributedText = attributedString;
    NSString *str = _TXTVW_description.text;
    str = [str stringByReplacingOccurrencesOfString:@"/" withString:@"\n"];
    _TXTVW_description.text = str;
    
    [_TXTVW_description sizeToFit];*/
    
    
    frame_set = _VW_fourth.frame;
    frame_set.origin.y = _VW_third.frame.origin.y + _VW_third.frame.size.height + 3;
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
        if([[json_Response_Dic valueForKey:@"relatedProducts"] count]<1)
        {
       frame_set.size.height = 0;
        }
        else{
        frame_set.size.height = 281;
            
        }
    _collection_related_products.frame = frame_set;
        
    frame_set = _VW_fifth.frame;
    frame_set.origin.y = _VW_fourth.frame.origin.y + _VW_fourth.frame.size.height+ 3;
        if([[json_Response_Dic valueForKey:@"relatedProducts"] count]<1)
        {
            frame_set.size.height = 0;
        }
        else
        {
            frame_set.size.height = 281;
            
        }

      frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
    _VW_fifth.frame = frame_set;
    [self.Scroll_content addSubview:_VW_fifth];
        
    scroll_ht = _VW_fifth.frame.origin.y + _VW_fifth.frame.size.height ;
        
    }
    else
    {
    scroll_ht = _VW_fourth.frame.origin.y + _VW_fourth.frame.size.height ;

    }
    }
    @catch(NSException *exception)
    {
        
    }

    

    
   // frame_set = _TXTVW_description.frame;
   // frame_set.origin.y = _VW_fourth.frame.origin.y + _VW_fourth.frame.size.height;
   // frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
   // _TXTVW_description.frame = frame_set;
//[self.Scroll_content addSubview:_TXTVW_description];

    
//    frame_set = _VW_fifth.frame;
//    frame_set.size.height = _TXTVW_description.frame.origin.y + _TXTVW_description.frame.size.height;//_TXTVW_description.contentSize.height;
//    frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
//    _VW_fifth.frame = frame_set;

  
    
    _TXT_count.layer.borderWidth = 0.4f;
    _TXT_count.layer.borderColor = [UIColor grayColor].CGColor;

    _BTN_plus.layer.borderWidth = 0.4f;
    _BTN_plus.layer.borderColor = [UIColor grayColor].CGColor;
    _BTN_minus.layer.borderWidth = 0.4f;
    _BTN_minus.layer.borderColor = [UIColor grayColor].CGColor;
    

    
    [_BTN_minus addTarget:self action:@selector(minus_action:) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_plus addTarget:self action:@selector(plus_action:) forControlEvents:UIControlEventTouchUpInside];


    _BTN_play.layer.cornerRadius = self.BTN_play.frame.size.width / 2;
    _BTN_play.layer.masksToBounds = YES;
    
    _BTN_share.layer.cornerRadius = self.BTN_play.frame.size.width / 2;
    _BTN_share.layer.masksToBounds = YES;
    
    UIImage *newImage = [_IMG_cart.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(_IMG_cart.image.size, NO, newImage.scale);
    [[UIColor whiteColor] set];
    [newImage drawInRect:CGRectMake(0, 0, _IMG_cart.image.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _IMG_cart.image = newImage;
       // + self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height ;
   
//    frame_set = _Scroll_content.frame;
//    frame_set.origin.y = - (self.navigationController.navigationBar.frame.size.height +50);
//    frame_set.size.height = scroll_ht;
  //  _Scroll_content.frame = frame_set;
//    
    
   [self viewDidLayoutSubviews];

}

-(void)set_Data_to_UIElements{
    
    @try {
        
        if ([[json_Response_Dic valueForKey:@"products"] isKindOfClass:[NSDictionary class]]) {
            
            @try
            {
                NSString *rating = [NSString stringWithFormat:@"%@",[json_Response_Dic valueForKey:@"avgRating"]];
                rating = [rating stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
                 starRatingView.value = [rating floatValue];
                
            NSString *str_name =[NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_descriptions"] objectAtIndex:0] valueForKey:@"title"]];
                str_name = [str_name stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            [_header_name setTitle:str_name forState:UIControlStateNormal];
                NSString *str_srock = [[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"stock_status"];
                str_srock = [str_srock stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];

                _LBL_stock.text = str_srock;
                if([[json_Response_Dic valueForKey:@"relatedProducts"] isKindOfClass:[NSArray class]])
                {
                    _LBL_more_sellers.text = [NSString stringWithFormat:@"%lu more Sellers",[[json_Response_Dic valueForKey:@"relatedProducts"] count]];
                }
              
                @try
                {
                    NSString *str_merchant = [NSString stringWithFormat:@"%@",[[json_Response_Dic valueForKey:@"products"] valueForKey:@"merchant_name"]];
                    str_merchant = [str_merchant stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not Mentioned"];
                    str_merchant = [str_merchant stringByReplacingOccurrencesOfString:@"" withString:@"Not Mentioned"];
                    _LBL_merchant_sellers.text  = str_merchant;
                    
                    NSString *str_merchant_IMG = [NSString stringWithFormat:@"%@%@",IMG_URL,[json_Response_Dic valueForKey:@"merchant_logo"]];
                    [_IMG_merchant sd_setImageWithURL:[NSURL URLWithString:str_merchant_IMG]
                                    placeholderImage:[UIImage imageNamed:@"logo.png"]
                                             options:SDWebImageRefreshCached];
                    
                    if([[[json_Response_Dic valueForKey:@"products"]valueForKey:@"wishStatus"] isEqualToString:@"No"])
                    {
                         [_BTN_wish_list setTitle:@" WISHLIST" forState:UIControlStateNormal];
                    }
                    else
                    {
                    wish_param = @"";
                    NSString *Stat = [NSString stringWithFormat:@"%@ WISHLIST",wish_param];
                    if ([_BTN_wish_list.titleLabel respondsToSelector:@selector(setAttributedText:)])
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
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:17.0],NSForegroundColorAttributeName:_BTN_play.backgroundColor}
                                                    range:ename];
                        }
                        [_BTN_wish_list setAttributedTitle:attributedText forState:UIControlStateNormal];
                        
                        
                    }
                    else
                    {
                        [_BTN_wish_list setTitle:Stat forState:UIControlStateNormal];
                    }
                    
                    }

                }
                @catch(NSException *exception)
                {
                    
                }
                
                
                
                
            }
            @catch(NSException *exception)
            {
                
            }
            @try
            {
                _LBL_item_name.text = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_descriptions"] objectAtIndex:0] valueForKey:@"title"]];

              
                

            }
            @catch(NSException *exception)
            {
                
            }
            
           

              NSString *currency = [NSString stringWithFormat:@"%@",[[json_Response_Dic valueForKey:@"products"] valueForKey:@"currency_code"]];
            
            
            NSString *mileValue = [NSString stringWithFormat:@"%@",[[json_Response_Dic valueForKey:@"products"] valueForKey:@"mileValue"]];
            
            // Storing product id into User Defaults
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_descriptions"] objectAtIndex:0] valueForKey:@"product_id"]] forKey:@"product_id"];
            
            
            NSString  *actuel_price = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_price"]];
            
            NSString *special_price = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"special_price"]];
            
            
            NSString *doha_miles = [NSString stringWithFormat:@"%@",mileValue];
            NSString *mils  = @"Doha Miles";
            
            
            if ([special_price isEqualToString:@""]|| [special_price isEqualToString:@"<nil>"]||[special_price isEqualToString:@"<null>"]) {
                
                
                
                NSString *text = [NSString stringWithFormat:@"%@ %@ /%@ %@",currency,actuel_price,doha_miles,mils];
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                
                attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                        range:[text rangeOfString:actuel_price]];
                
                _LBL_prices.attributedText = attributedText;
                _LBL_discount.text = @"";
                
            }
            else{
                
                
                // NSString *doha_miles = @"QR 6758";
                actuel_price = [currency stringByAppendingString:actuel_price];
                
                NSString *text = [NSString stringWithFormat:@"%@ %@ %@ / %@ %@",currency,special_price,actuel_price,doha_miles,mils];
                
                if ([_LBL_prices respondsToSelector:@selector(setAttributedText:)]) {
                    
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                    
                    NSRange ename = [text rangeOfString:special_price];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:25.0]}
                                                range:ename];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:17.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                                range:ename];
                    }
                    
                    
                    
                    
                    NSRange cmp = [text rangeOfString:actuel_price];
                    //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:21.0]}
                                                range:cmp];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0]}
                                                range:cmp];
                    }
                    
                    NSRange miles_price = [text rangeOfString:doha_miles];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:21.0]}
                                                range:miles_price];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:16.0],NSForegroundColorAttributeName:[UIColor redColor]}
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
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0]}
                                                range:miles];
                    }
                    
                    [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                           value:@2
                                           range:NSMakeRange([special_price length]+currency.length+2, [actuel_price length])];
                    
                    _LBL_prices.attributedText = attributedText;
                }
                else
                {
                    _LBL_prices.text = text;
                }
                
                
                NSString  *actuelprice = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_price"]];
                
                NSString *specialprice = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"special_price"]];
                
                float disc = [actuelprice integerValue]-[specialprice integerValue];
                float digits = disc/[actuelprice integerValue];
                int discount = digits *100;
                NSString *of = @"% off";
                _LBL_discount.text =[NSString stringWithFormat:@"%d%@",discount,of];
                
                
            }
        }
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"%@",exception);
    }
    
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_content layoutIfNeeded];
    _Scroll_content.contentSize = CGSizeMake(_Scroll_content.frame.size.width,scroll_ht + _VW_filter.frame.size.height);
    
    
}
#pragma Button Actions


-(void)minus_action:(id)btn
{
    int s = [_TXT_count.text intValue];
    
    if (s<= 0) {
        [btn removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    }
    else{
    s = s - 1;
    _TXT_count.text = [NSString stringWithFormat:@"%d",s];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:_TXT_count.text forKey:@"item_count"];
    
//    NSString *product_id = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:index.row] valueForKey:@"productDetails"] valueForKey:@"productid"]];
//    [[NSUserDefaults standardUserDefaults]setObject:product_id forKey:@"product_id"];
    // Update cart Api method calling
    
    [self updating_cart_List_api];
    
    
    
}
- (IBAction)back_action:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)plus_action:(id)btn
{
    int s = [_TXT_count.text intValue];
    s = s + 1;
    _TXT_count.text = [NSString stringWithFormat:@"%d",s];
     [[NSUserDefaults standardUserDefaults]setObject:_TXT_count.text forKey:@"item_count"];
    [self updating_cart_List_api];
    
    
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
                cell.LBL_title.text = [[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:indexPath.row] valueForKey:@"variant"];
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
                cell.TXT_variant.text = [data_arr objectAtIndex:indexPath.row];
                if([cell.TXT_variant.text isEqualToString:@"0"])
                {
                    cell.TXT_variant.text = @"";
                }
               // cell.TXT_variant.layer.cornerRadius = 2.0f;
                cell.TXT_variant.layer.borderWidth = 0.2f;
                cell.TXT_variant.layer.borderColor = [UIColor lightGrayColor].CGColor;
                
           
                
                return cell;
                
            }
            else{
                
                product_cell *pro_cell = (product_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_product" forIndexPath:indexPath];
                @try
                {
#pragma Webimage URl Cachee
                    
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
                            
                        }
                        else{
                            pro_cell.LBL_stock.text =str;
                        }
                        
                    }
                    @catch(NSException *exception)
                    {
                        
                    }
                    pro_cell.LBL_item_name.text = [[[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row] objectAtIndex:0] valueForKey:@"product_descriptions"] objectAtIndex:0]valueForKey:@"title"];
                    @try
                    {
                        int rating = [[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row]objectAtIndex:0]  valueForKey:@"rating"] intValue];
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
                    }
                    @catch(NSException *exception)
                    {
                        
                    }

                    pro_cell.LBL_rating.text = [NSString stringWithFormat:@"%@  ",[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row]objectAtIndex:0]  valueForKey:@"rating"]];
                    
                    
                    
                    //pro_cell.LBL_current_price.text = [NSString stringWithFormat:@"%@",[[productDataArray objectAtIndex:indexPath.row] valueForKey:@"special_price"]];
                    
                    
                    NSString *current_price = [NSString stringWithFormat:@"%@",[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row]objectAtIndex:0]  valueForKey:@"special_price"]];
                    
                    NSString *prec_price = [NSString stringWithFormat:@"%@",[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row]objectAtIndex:0]  valueForKey:@"product_price"]];
                    NSString *text ;
                    
                    if ([pro_cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
                        
                        
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        [paragraphStyle setAlignment:NSTextAlignmentCenter];
                        
                        if ([current_price isEqualToString:@"<null>"] || [current_price isEqualToString:@"<nil>"] || [current_price isEqualToString:@" "]) {
                            
                            
                            
                            
                            text = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"curremcy"],prec_price];
                            
                            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                            {
                                text = [NSString stringWithFormat:@"%@ %@",prec_price,[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
                            }
                            
                            
                            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                            
                            
                            NSRange ename = [text rangeOfString:prec_price];
                            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                                        range:ename];
                            }
                            else
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor],}range:[text rangeOfString:prec_price] ];
                            }
                            
                            
                            
                            [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                            //NSParagraphStyleAttributeName
                            pro_cell.LBL_current_price.attributedText = attributedText;
                            
                            pro_cell.LBL_discount.text = @"0% off";
                            
                        }
                        
                        else{
                            
                            // Define general attributes for the entire text
                            //        NSDictionary *attribs = @{
                            //                                  NSForegroundColorAttributeName:pro_cell.LBL_current_price.textColor,
                            //                                  NSFontAttributeName:pro_cell.LBL_current_price.font
                            //                                  };
                            
                            prec_price = [[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"] stringByAppendingString:prec_price];
                            
                            text = [NSString stringWithFormat:@"%@ %@ %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],current_price,prec_price];
                            
                            
                            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                            {
                                prec_price = [prec_price stringByAppendingString:[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
                                text = [NSString stringWithFormat:@"%@ %@ %@",prec_price,current_price,[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
                            }
                            
                            
                            
                            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                            
                            
                            
                            NSRange ename = [text rangeOfString:current_price];
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
                            
                            
                            NSRange qrname = [text rangeOfString:[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
                            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                                        range:qrname];
                            }
                            else
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor blackColor]}
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
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:14.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:cmp ];
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
                                                       range:NSMakeRange([current_price length]+[[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"] length]+2 ,[prec_price length])];
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
                        
                    if ([[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row]objectAtIndex:0]  valueForKey:@"wishListStatus"] isEqualToString:@"Yes"]) {
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
       return CGSizeMake(self.view.bounds.size.width/2.1, 281);
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

// Layout: Set Edges
//- (UIEdgeInsets)collectionView:
//(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
//    return UIEdgeInsetsMake(0,0,4,0);  // top, left, bottom, right
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *temp_str = [[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row] valueForKey:@"product_image"];
//    NSRange range = [temp_str rangeOfString:@"/Merchant"];
//    
//    if (range.location == NSNotFound) {
//        NSLog(@"The string (testString) does not contain 'how are you doing' as a substring");
//    }
//    else {
//        NSLog(@"Found the range of the substring at (%lu, %lu)", (unsigned long)range.location, range.location + range.length);
//    }
//    NSString *lastChar = [temp_str substringFromIndex:range.location + range.length];
//    char firstLetter = [lastChar characterAtIndex:0];
//    if(!firstLetter)
//    {
//        firstLetter = '0';
//    }
//    
//    NSLog(@"THE iD:%c",firstLetter);
    
    
    NSUserDefaults *userDflts = [NSUserDefaults standardUserDefaults];
  //  NSString *merchant_ID = [NSString stringWithFormat:@"%c",firstLetter];
    [userDflts setObject:[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row]objectAtIndex:0]  valueForKey:@"url_key"] forKey:@"product_list_key_sub"];
    [userDflts setValue:[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:indexPath.row]objectAtIndex:0]  valueForKey:@"merchant_id"]  forKey:@"Mercahnt_ID"];
    [userDflts synchronize];
    
    [self product_detail_API];
    
    
    
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
            //        CGRect visibleRect = (CGRect){.origin = self.collection_IMG.contentOffset, .size = self.collection_IMG.bounds.size};
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
    
    NSString *count = [NSString stringWithFormat:@"  REVIEWS(%lu)  ",[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_reviews"] count]];
    
    self.segmentedControl4.sectionTitles = @[@" DESCRIPTION  ",count];
    
    self.segmentedControl4.backgroundColor = [UIColor clearColor];
    self.segmentedControl4.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15]};
    self.segmentedControl4.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0],NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15]};
    self.segmentedControl4.selectionIndicatorColor = [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];
    //    self.segmentedControl4.selectionIndicatorColor
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
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[description dataUsingEncoding:NSUTF8StringEncoding]options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}documentAttributes:nil error:nil];
        _TXTVW_description.attributedText = attributedString;
        NSString *str = _TXTVW_description.text;
        str = [str stringByReplacingOccurrencesOfString:@"/" withString:@"\n"];
        _TXTVW_description.text = str;
        
        _TXTVW_description.hidden = NO;
        _TXTVW_description.numberOfLines = 0;
        [_TXTVW_description sizeToFit];
        
//        CGRect frame_set = _TXTVW_description.frame;
//        frame_set.size.height = _TXTVW_description.frame.origin.y +  _TXTVW_description.frame.size.height;
//        frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
//        _TXTVW_description.frame = frame_set;

         CGRect  frame_set = _VW_fourth.frame;
        frame_set.size.height = _TXTVW_description.frame.origin.y + _TXTVW_description.frame.size.height;
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
        else{
             frame_set.size.height = 281;
            
        }

        frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
        _VW_fifth.frame = frame_set;
        
        

        
        scroll_ht = _VW_fifth.frame.origin.y+ _VW_fifth.frame.size.height;
         }
         else{
             scroll_ht = _VW_fourth.frame.origin.y+ _VW_fourth.frame.size.height;

             
         }// + self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height + _VW_filter.frame.size.height;
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
        frame_set.origin.y = _VW_fourth.frame.origin.y + _VW_fourth.frame.size.height;
        if([[json_Response_Dic valueForKey:@"relatedProducts"] count]<1)
        {
            frame_set.size.height = 0;
        }
        else{
             frame_set.size.height = 281;
            
        }
        frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
        _VW_fifth.frame = frame_set;
        
        scroll_ht = _VW_fifth.frame.origin.y+ _VW_fifth.frame.size.height ;
        }
        else{
            scroll_ht = _VW_fourth.frame.origin.y+ _VW_fourth.frame.size.height;

        }
        // + self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height+_VW_filter.frame.size.height;
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
            
            if ([[[[[json_Response_Dic valueForKey:@"relatedProducts"] objectAtIndex:sender.tag] objectAtIndex:0]valueForKey:@"wishListStatus"] isEqualToString:@"Yes"]) {
                [self delete_from_wishLis];
                [self product_detail_API];
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
                        if ([[data valueForKey:@"msg"] isEqualToString:@"del"])
                        {
                            @try {
                           wish_param = @"";
                            NSString *Stat = [NSString stringWithFormat:@"%@ WISHLIST",wish_param];
                            if ([_BTN_wish_list.titleLabel respondsToSelector:@selector(setAttributedText:)])
                            {
                                
                                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:Stat attributes:nil];
                                
                                NSRange ename = [Stat rangeOfString:wish_param];
                                                                 [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:17.0]}
                                                            range:ename];
                                
                            [_BTN_wish_list setAttributedTitle:attributedText forState:UIControlStateNormal];
                                
                                
                            }
                            else
                            {
                                [_BTN_wish_list setTitle:Stat forState:UIControlStateNormal];
                            }
                            
                        
                        
                    }
                    @catch(NSException *exception)
                    {
                        
                    }

                        [HttpClient createaAlertWithMsg:@"Item deleted Succesfully" andTitle:@""];

                       // [self product_detail_API];
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
//            NSString *stock =  [[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"stock_status"];
//            stock = [stock stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
//            stock = [stock stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
//            if([stock isEqualToString:@""] || [stock isEqualToString:@"Out of stock"])
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Out of Stock" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                
//                [alert show];
//                
//            }
//            else
//            {
//

        
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



 #pragma mark add_to_cart_API_calling

 -(void)add_to_cart_API_calling
{
     
      noDuplicates = [[NSMutableArray alloc]init];
     //apis/addcartapi.json
     
     //    this->request->data['pdtId'];
     //    $userId = $this->request->data['userId'];
     //    $qtydtl = $this->request->data['quantity'];
     //    $custom = $this->request->data['custom'];
     //    $variant = $this->request->data['variant'];
    NSString *items_count = _TXT_count.text;

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
             [noDuplicates addObject:temp_DICT];
             NSArray *hasDuplicates = noDuplicates;
             variant_arr1 = [[NSSet setWithArray: hasDuplicates] allObjects];
             NSLog(@"%@",variant_arr1);
             

             
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
       // NSError *error;
      //  NSHTTPURLResponse *response = nil;
        NSString *pdId = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_descriptions"] objectAtIndex:0] valueForKey:@"product_id"]];
     NSString *variant = [[json_Response_Dic valueForKey:@"products"] valueForKey:@"variant"];
     NSString *custom = [[json_Response_Dic valueForKey:@"products"] valueForKey:@"customOption"];
     NSString *variant_stat; NSDictionary *parameters;
     NSString *variant_str = [variant_arr1 componentsJoinedByString:@","];
                 
     if([custom isEqualToString:@"Yes"] && [variant isEqualToString:@"No"])
     {
         variant_stat = @"custom";
         parameters = @{@"pdtId":pdId,@"userId":user_id,@"quantity":items_count,variant_stat:variant_str,@"varaint":@""};

     }
     else if([custom isEqualToString:@"No"] && [variant isEqualToString:@"Yes"])
     {
         variant_stat = @"variant";
         parameters = @{@"pdtId":pdId,@"userId":user_id,@"quantity":items_count,variant_stat:variant_str,@"custom":@""};

     }
     else
     {
         variant_stat = @"variant";
         parameters = @{@"pdtId":pdId,@"userId":user_id,@"quantity":items_count,@"custom":@"",@"variant":@""};

     }
        
     @try
    {
                   //  NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
                   //  NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
                   //  NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
                 //    NSString *ORDER_ID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"order_ID"]];
                     
                     
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
        
        if([custom isEqualToString:@"Yes"] && [variant isEqualToString:@"No"])
        {
           
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"custom\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",variant_str]dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
                       [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"variant\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",@""]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

            

            
          
            
        }
        else if([custom isEqualToString:@"No"] && [variant isEqualToString:@"Yes"])
        {
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"custom\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",@""]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

          
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"variant\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",variant_str]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        else
        {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"custom\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",@""]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"variant\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",@""]dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

        }

        
      

        
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
                
            }
            else
            {
               urlGetuser =[NSString stringWithFormat:@"%@Pages/details/%@/%@/%@/%@/%@/Customer.json",SERVER_URL,[user_dflts valueForKey:@"product_list_key_sub"],mercahnt_ID,country,languge,user_id];
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
                                
                               // [images_arr addObject:[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:[keys objectAtIndex:0]] valueForKey:@"product_medias"] objectAtIndex:i] valueForKey:@"media"]];
                                
                            }
                        }
                        
                        self.custom_story_page_controller.numberOfPages = images_arr.count;
                       
                        
                        NSLog(@"%@",json_Response_Dic);
                        
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
                        [self set_UP_VIEW];
                        self.segmentedControl4.selectedSegmentIndex = 0;
                        [self segmentedControlChangedValue:self.segmentedControl4];
                            
                        }
                        else
                        {
                            [self set_Data_to_UIElements];
                            [self.collection_images reloadData];
                             [self.collectionview_variants reloadData];
                             [_collection_related_products reloadData];
                            [self set_UP_VIEW];
                            self.segmentedControl4.selectedSegmentIndex = 0;
                            [self segmentedControlChangedValue:self.segmentedControl4];

                        }

                    } @catch (NSException *exception) {
                        VW_overlay.hidden = YES;
                    [activityIndicatorView stopAnimating];

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
                if(badge_value.length > 99 || wishlist.length > 99)
                {
                   [_BTN_cart setBadgeString:[NSString stringWithFormat:@"%@+",badge_value]];
                    [_BTN_fav setBadgeString:[NSString stringWithFormat:@"%@+",wishlist]];

                    
                }
                else{
                    [_BTN_cart setBadgeString: [NSString stringWithFormat:@"%@",badge_value]];
                    [_BTN_fav setBadgeString:[NSString stringWithFormat:@"%@",wishlist]];

                    
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
    
    NSDictionary *parameters = @{@"quantity":[[NSUserDefaults standardUserDefaults] valueForKey:@"item_count"],@"productId":[[NSUserDefaults standardUserDefaults]valueForKey:@"product_id"],@"customerId":custmr_id};
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/updatecartapi.json",SERVER_URL];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    
    [HttpClient api_with_post_params:urlGetuser andParams:parameters completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"%@",[error localizedDescription]);
            }
            if (data) {
                //NSLog(@"%@",data);
                
                
                @try {
                    [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                } @catch (NSException *exception) {
                    NSLog(@"exception:: %@",exception);
                }
                
                
            }
            
        });
        
    }];
}
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
    
    
    [data_arr replaceObjectAtIndex:tag withObject:picker_arr[row]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag inSection:
                              0];
    
    
    indexPaths = [[NSMutableArray alloc] initWithObjects:indexPath, nil];
   
    
    
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
    
    NSString *str_name = @"AJ.sabeen";
    NSString *str_date = @"18/04/2017";
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
    NSString  *temp_str;
    [self.view endEditing:YES];
    NSLog(@"The variant ARR:%@",data_arr);
    for(int i= 0;i< [[json_Response_Dic valueForKey:@"getVariantNames"] count];i++)
    {
        for(int j =0 ; j<[[[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i]valueForKey:@"0"] allObjects] count];j++)
        {
            for(int k = 0;k<[data_arr count];k++)
            {
                if([[data_arr objectAtIndex:k] isEqualToString:[[[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i]valueForKey:@"0"] allObjects]objectAtIndex:j]])
                {
                    
                    
                    NSString *main_variant_ID = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i]  valueForKey:@"variant_id"]];
                    NSString *sub_ID = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:i] valueForKey:@"0"] allKeys] objectAtIndex:j]];
                    //temp_str =[NSString stringWithFormat:@"%@ : %@",main_variant_ID,sub_ID];
                    [temp_DICT setObject:sub_ID forKey:main_variant_ID];
                }
        }
        }
    }
      
//    NSArray *key_arr = [[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:indexPath.row] valueForKey:@"0"] allKeys];
//    
//    for(int i=0;i<key_arr.count;i++)
//    {
//        NSLog(@"The seperated :%@",[[[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:indexPath.row] valueForKey:@"0"] allObjects] objectAtIndex:i]);
//        
//        if([[[[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:indexPath.row] valueForKey:@"0"] allObjects]objectAtIndex:i] isEqualToString:picker_arr[row]])
//        {
//            NSLog(@"Variant ID:%@,Color_ID:%@",[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:indexPath.row] valueForKey:@"variant_id"],[key_arr objectAtIndex:i]);
//            
//            NSDictionary *temp_dict;
//            @try {
//                temp_dict = @{[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:indexPath.row] valueForKey:@"variant_id"]:[key_arr objectAtIndex:i]};
//            }
//            @catch(NSException *exception)
//            {
//                temp_dict = @{[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:indexPath.row] valueForKey:@"custom_option_id"]:[key_arr objectAtIndex:i]};
//            }
//            [variant_arr addObject:temp_dict];
//        }
  //  }

    
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [_collectionview_variants reloadItemsAtIndexPaths:indexPaths];
    [UIView setAnimationsEnabled:animationsEnabled];
    
    
}

- (IBAction)add_to_wih_list:(id)sender {
    
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

    if ([wish_param isEqualToString:@""])
    {
        [self performSelector:@selector(delete_from_wishLis) withObject:activityIndicatorView afterDelay:0.01];


    }
    else{
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
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
            NSLog(@"cancel:");
            
            
        }
        else
        {
            ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login_VC"];
            [self presentViewController:login animated:NO completion:nil];
        }
        
        
    }
    
    
    
}
//- (IBAction)share_action:(id)sender
//{
//    if([[detail_dict valueForKey:@"_TrailerURL"] isEqualToString:@""])
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No video available to share" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
//        
//        
//    }
//    else
//    {
//        NSString *trailer_URL= [detail_dict valueForKey:@"_TrailerURL"];
//        NSArray* sharedObjects=[NSArray arrayWithObjects:trailer_URL,  nil];
//        UIActivityViewController *activityViewController = [[UIActivityViewController alloc]                                                                initWithActivityItems:sharedObjects applicationActivities:nil];
//        activityViewController.popoverPresentationController.sourceView = self.view;
//        [self presentViewController:activityViewController animated:YES completion:nil];
//   // }
//}

// product Detail to Wish List

- (IBAction)product_detail_cart_page:(id)sender {
   
        [self performSegueWithIdentifier:@"productDetail_to_wishList" sender:self];
   
}
@end
