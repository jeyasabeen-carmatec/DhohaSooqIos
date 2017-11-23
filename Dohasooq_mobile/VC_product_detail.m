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


@interface VC_product_detail ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,UIWebViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray   *images_arr,*color_arr,*size_arr;
    NSArray *keys;
    NSArray *picker_arr;
    
    HCSStarRatingView *starRatingView;
    NSMutableDictionary *json_Response_Dic;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSMutableArray *data_arr;
    NSInteger tag;
    float scroll_ht;

    //NSString *actuel_price,*avg_rating,*discount,*review_count;
    //NSString **product_description,*img_Url,*title_str,*current_price;
}
@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;


@end

@implementation VC_product_detail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _TXTVW_description.delegate = self;
    json_Response_Dic = [[NSMutableDictionary alloc]init];
    images_arr = [[NSMutableArray alloc]init];
    
    [self.collection_images registerNib:[UINib nibWithNibName:@"product_detail_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_image"];

    
    
    
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
    
    [self performSelector:@selector(cart_count) withObject:nil afterDelay:0.01];
    [self performSelector:@selector(product_detail_API) withObject:activityIndicatorView afterDelay:0.01];
    
   
    
}



-(void)set_UP_VIEW
{
    [self addSEgmentedControl];
    _TXT_count.delegate = self;
//    temp_arr = [[NSMutableArray alloc]init];
//    temp_arr = [NSMutableArray arrayWithObjects:@"upload-2.png",@"upload-2.png",@"upload-2.png",@"upload-2.png",nil];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
       } forState:UIControlStateNormal];
    
    
    
//    [_Btn_addto_wish addTarget:self action:@selector(add_to_wish_list:) forControlEvents:UIControlEventTouchUpInside];
//    [_Btn_addto_cart addTarget:self action:@selector(add_to_cart:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _BTN_fav  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain  target:self action:
                 @selector(btnfav_action:)];
    _BTN_cart = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain   target:self action:@selector(btn_cart_action:)];
//    
//       NSString *badge_value = @"25";
//    
//    
//    if(badge_value.length > 2)
//    {
//        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
//        
//    }
//    else{
//        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
//        
//    }
    
    CGRect frame_set = _Scroll_content.frame;
    //frame_set.origin.y = 0;
    frame_set.origin.y = self.navigationController.navigationBar.frame.origin.y +  self.navigationController.navigationBar.frame.size.height;
    frame_set.size.width = self.Scroll_content.frame.size.width;
    frame_set.size.height =self.view.frame.size.height - self.navigationController.navigationBar.frame.origin.y +  self.navigationController.navigationBar.frame.size.height;
    _Scroll_content.frame = frame_set;
    
    
     frame_set = _VW_First.frame;
    frame_set.origin.y = -(self.navigationController.navigationBar.frame.origin.y +  self.navigationController.navigationBar.frame.size.height);
   frame_set.size.height = _custom_story_page_controller.frame.origin.y + _custom_story_page_controller.frame.size.height;
    frame_set.size.width = self.Scroll_content.frame.size.width;
    _VW_First.frame = frame_set;
    
    
    _LBL_item_name.numberOfLines = 0;
    
    
    starRatingView = [[HCSStarRatingView alloc] init];
    starRatingView.frame = CGRectMake(_LBL_item_name.frame.origin.x, _LBL_item_name.frame.origin.y+_LBL_item_name.frame.size.height + 3, 100.0f, _LBL_item_name.frame.size.height - 15);
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 0;
   
    starRatingView.tintColor = [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];
    //[starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [self.VW_second addSubview:starRatingView];
    starRatingView.allowsHalfStars = YES;
    starRatingView.value = 2.5f;
    
   
    frame_set = _LBL_prices.frame;
    frame_set.origin.y = starRatingView.frame.origin.y + starRatingView.frame.size.height + 3;
    _LBL_prices.frame = frame_set;
    
    frame_set = _LBL_discount.frame;
    frame_set.origin.y = _LBL_prices.frame.origin.y + _LBL_prices.frame.size.height;
    _LBL_discount.frame = frame_set;
    
    frame_set = _VW_second.frame;
    frame_set.origin.y = _VW_First.frame.origin.y + _VW_First.frame.size.height + 3;
    frame_set.size.height = _LBL_discount.frame.origin.y + _LBL_discount.frame.size.height + 10;
    frame_set.size.width = self.Scroll_content.frame.size.width;
    _VW_second.frame = frame_set;
    
    frame_set = _BTN_play.frame;
    frame_set.origin.x = self.view.frame.size.width - _BTN_play.frame.size.width - 20;
    frame_set.origin.y = (self.VW_second.frame.origin.y - _BTN_play.frame.size.height / 2) - 4 ;
    _BTN_play.frame = frame_set;
//    
//    [_collectionview_variants reloadData];
//    
//    frame_set = _collectionview_variants.frame;
//    frame_set.size.height =  _collectionview_variants.contentSize.height;
//    _collectionview_variants.frame = frame_set;
//    
    // [_collectionview_variants reloadData];
    
    frame_set = _VW_third.frame;
    frame_set.origin.y = _VW_second.frame.origin.y + _VW_second.frame.size.height + 3;
    frame_set.size.height =_collectionview_variants.frame.origin.y + _collectionview_variants.collectionViewLayout.collectionViewContentSize.height;
    frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
    _VW_third.frame = frame_set;
    
    

    frame_set = _VW_segemnt.frame;
    frame_set.origin.y = _VW_fourth.frame.origin.y;
    frame_set.size.height = 100;
    frame_set.size.width = self.VW_second.frame.size.width;
    _VW_segemnt.frame = frame_set;
    
    frame_set = _VW_fourth.frame;
    frame_set.origin.y = _VW_third.frame.origin.y + _VW_third.frame.size.height + 3;
   // frame_set.size.height = _VW_segemnt.frame.origin.y+_VW_segemnt.frame.size.height;
    frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
    _VW_fourth.frame = frame_set;
    
    [_TXTVW_description layoutIfNeeded];
    [_TXTVW_description sizeToFit];
    
   frame_set = _TXTVW_description.frame;
    frame_set.size.height = _TXTVW_description.frame.origin.y +  _TXTVW_description.contentSize.height;
    _TXTVW_description.frame = frame_set;
    
    
    
    NSString *description =[NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"]valueForKey:@"0"]valueForKey:@"product_descriptions"] objectAtIndex:0]valueForKey:@"description"]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: 'Poppins-Regular'; font-size:%dpx;}</style>",17]];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[description dataUsingEncoding:NSUTF8StringEncoding]options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}documentAttributes:nil error:nil];
    _TXTVW_description.attributedText = attributedString;
    NSString *str = _TXTVW_description.text;
    str = [str stringByReplacingOccurrencesOfString:@"/" withString:@"\n"];
    _TXTVW_description.text = str;

   
    frame_set = _VW_fifth.frame;
    frame_set.origin.y = _VW_fourth.frame.origin.y + _VW_fourth.frame.size.height;
    frame_set.size.height = _TXTVW_description.frame.origin.y + _TXTVW_description.contentSize.height;//_TXTVW_description.contentSize.height;
    frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
    _VW_fifth.frame = frame_set;

  
    
    [self.Scroll_content addSubview:_VW_First];
    [self.Scroll_content addSubview:_VW_second];
    [self.Scroll_content addSubview:_BTN_play];
    [self.Scroll_content addSubview:_VW_third];
    [self.Scroll_content addSubview:_VW_fourth];
    [self.Scroll_content addSubview:_VW_fifth];
    
    
   
    
    
    
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
    
//    self.custom_story_page_controller.numberOfPages = [[json_Response_Dic valueForKey:@"products"] count];
    UIImage *newImage = [_IMG_cart.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(_IMG_cart.image.size, NO, newImage.scale);
    [[UIColor whiteColor] set];
    [newImage drawInRect:CGRectMake(0, 0, _IMG_cart.image.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _IMG_cart.image = newImage;
    
    data_arr = [[NSMutableArray alloc]init];
    for(int i = 0; i<[[json_Response_Dic valueForKey:@"getVariantNames"] count];i++)
    {
        [data_arr insertObject:@"" atIndex:i];

    }
    scroll_ht = _VW_fifth.frame.origin.y+ _VW_fifth.frame.size.height + self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height - _VW_filter.frame.size.height;
    [self viewDidLayoutSubviews];

}


-(void)set_Data_to_UIElements{
    
    @try {
        
        if ([[json_Response_Dic valueForKey:@"products"] isKindOfClass:[NSDictionary class]]) {

    
            
            _LBL_item_name.text = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_descriptions"] objectAtIndex:0] valueForKey:@"title"]];
           
            // Storing product id into User Defaults
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_descriptions"] objectAtIndex:0] valueForKey:@"product_id"]] forKey:@"product_id"];
    
            
            NSString  *actuel_price = [NSString stringWithFormat:@"QR %@",[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"product_price"]];
            
            NSString *special_price = [NSString stringWithFormat:@"QR %@",[[[json_Response_Dic valueForKey:@"products"] valueForKey:@"0"] valueForKey:@"special_price"]];
            
            
            if ([special_price isEqualToString:@"QR "]|| [special_price isEqualToString:@"null"]||[special_price isEqualToString:@"QR <null>"]) {
                
                NSString *text = [NSString stringWithFormat:@"%@",actuel_price];
                  NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];

                attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                        range:[text rangeOfString:actuel_price]];
                
              _LBL_prices.attributedText = attributedText;
                _LBL_discount.text = @"";
                
            }
            else{
                
                
                NSString *doha_miles = @"QR 6758";
                NSString *mils  = @"Doha Miles";
            NSString *text = [NSString stringWithFormat:@"%@ %@ / %@ %@",special_price,actuel_price,doha_miles,mils];
                
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
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:19.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                                        range:ename];
                            }
                    
                    
                    
                    
                            NSRange cmp = [text rangeOfString:actuel_price];
                            //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
                            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:21.0]}
                                                        range:cmp];
                            }
                            else
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:13.0]}
                                                        range:cmp];
                            }
                    
                            NSRange miles_price = [text rangeOfString:doha_miles];
                            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:21.0]}
                                                        range:miles_price];
                            }
                            else
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:19.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                                        range:miles_price];
                            }
                            NSRange miles = [text rangeOfString:mils];
                            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:21.0]}
                                                        range:miles];
                            }
                            else
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:13.0]}
                                                        range:miles];
                            }
                            
                    [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                            value:@2
                                            range:NSMakeRange([special_price length]+4, [actuel_price length]-3)];
                    
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
    _Scroll_content.contentSize = CGSizeMake(_Scroll_content.frame.size.width,scroll_ht);
    
    
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
    else
    {          return [[json_Response_Dic valueForKey:@"getVariantNames"] count];
        
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
       
            else
            {
              

                collection_variants_cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
                cell.LBL_title.text = [[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:indexPath.row] valueForKey:@"variant"];
                [cell.TXT_variant addTarget:self action:@selector(picker_selection:) forControlEvents:UIControlEventAllEvents];
                cell.TXT_variant.tag = indexPath.row;
                _variant_picker = [[UIPickerView alloc] init];
                _variant_picker.delegate = self;
                
                UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                             action:@selector(tappedToSelectRow:)];
                tapToSelect.delegate = self;
                [_variant_picker addGestureRecognizer:tapToSelect];
                UIToolbar* conutry_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
                conutry_close.barStyle = UIBarStyleBlackTranslucent;
                [conutry_close sizeToFit];
                
                UIButton *close=[[UIButton alloc]init];
                close.frame=CGRectMake(conutry_close.frame.size.width - 100, 0, 100, conutry_close.frame.size.height);
                [close setTitle:@"close" forState:UIControlStateNormal];
                [close addTarget:self action:@selector(countrybuttonClick:) forControlEvents:UIControlEventTouchUpInside];
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
                cell.TXT_variant.layer.cornerRadius = 2.0f;
                cell.TXT_variant.layer.borderWidth = 0.5f;
                cell.TXT_variant.layer.borderColor = [UIColor lightGrayColor].CGColor;
                
           
                
                return cell;
                
            }
        
        
  }
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collection_images) {
        return CGSizeMake(_collection_images.frame.size.width ,_collection_images.frame.size.height);

    }
    else{
        return CGSizeMake(_collectionview_variants.frame.size.width/5, 64);
    }
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
    {
        for(UIScrollView *scroll in _collection_images.subviews)
        {
            scrollView = scroll;
        }
        
        if (scrollView) {
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
#pragma text fields
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)countrybuttonClick:(UIButton *)sender
{
    [self.view endEditing:YES]; //assuming self is your top view controller.
    //[sender setHidden:YES];
    //_collectionview_variants.keyboardDismissMode = UIControlStateNormal ;
    
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
    
    self.segmentedControl4.sectionTitles = @[@" DESCRIPTION  ", @" REVIEWS(235) "];
    
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
  //  [_TXTVW_description layoutIfNeeded];
    //[_TXTVW_description sizeToFit];
    if(segmentedControl4.selectedSegmentIndex == 0)
    {
        
     //   [_TXTVW_description loadHTMLString:[[[[[json_Response_Dic valueForKey:@"products"]valueForKey:@"0"]valueForKey:@"product_descriptions"] objectAtIndex:0]valueForKey:@"description"] baseURL:nil];
        NSString *description =[NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"products"]valueForKey:@"0"]valueForKey:@"product_descriptions"] objectAtIndex:0]valueForKey:@"description"]];
        description = [description stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: 'Poppins-Regular'; font-size:%dpx;}</style>",17]];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[description dataUsingEncoding:NSUTF8StringEncoding]options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}documentAttributes:nil error:nil];
        _TXTVW_description.attributedText = attributedString;
        NSString *str = _TXTVW_description.text;
        str = [str stringByReplacingOccurrencesOfString:@"/" withString:@"\n"];
        _TXTVW_description.text = str;
        
        CGRect frame_set = _VW_fifth.frame;
        frame_set.size.height = _TXTVW_description.frame.origin.y + _TXTVW_description.contentSize.height;
        frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
        _VW_fifth.frame = frame_set;

        
       scroll_ht = _VW_fifth.frame.origin.y+ _VW_fifth.frame.size.height + self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height + _VW_filter.frame.size.height;
         [self viewDidLayoutSubviews];
        _TBL_reviews.hidden = YES;
       
        
    }
    else
    {
        [_TBL_reviews reloadData];
        _TBL_reviews.hidden = NO;
        
        CGRect frame_set = _TBL_reviews.frame;
        frame_set.size.height = _TBL_reviews.frame.origin.y + _TBL_reviews.contentSize.height;
        frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
        _TBL_reviews.frame = frame_set;
        
        frame_set = _VW_fifth.frame;
        frame_set.size.height = _TBL_reviews.frame.origin.y + _TBL_reviews.contentSize.height;
        frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
        _VW_fifth.frame = frame_set;
        
        [self.VW_fifth addSubview:_TBL_reviews];
        
         scroll_ht = _VW_fifth.frame.origin.y+ _VW_fifth.frame.size.height + self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height+_VW_filter.frame.size.height;
         [self viewDidLayoutSubviews];

    }

}
-(void)picker_selection:(UITextField *)sender
{
  picker_arr = [[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:sender.tag] valueForKey:@"0"] allObjects];
    NSLog(@"variant_count%lu",(unsigned long)picker_arr.count);
    tag = [sender tag];
    
   
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
        NSString *poduct_id = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] objectAtIndex:0]valueForKey:@"id"]];
        
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
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Item added successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];
                        NSLog(@"The Wishlist%@",json_Response_Dic);
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

 -(void)add_to_cart_API_calling{
     
     
     //apis/addcartapi.json
     
     //    this->request->data['pdtId'];
     //    $userId = $this->request->data['userId'];
     //    $qtydtl = $this->request->data['quantity'];
     //    $custom = $this->request->data['custom'];
     //    $variant = $this->request->data['variant'];
     
 NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
 NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
 NSString *items_count = [[NSUserDefaults standardUserDefaults]valueForKey:@"item_count"];
 NSError *error;
 NSHTTPURLResponse *response = nil;
 NSString *pdId = [[NSUserDefaults standardUserDefaults] valueForKey:@"product_id"];
 NSDictionary *parameters = @{@"pdtId":pdId,@"userId":user_id,@"quantity":items_count,@"custom":@"",@"variant":@""};
 NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
 NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@apis/addcartapi.json",SERVER_URL]];
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
 [request setURL:urlProducts];
 [request setHTTPMethod:@"POST"];
 [request setHTTPBody:postData];
 [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 if (error) {
    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
     VW_overlay.hidden=YES;
     [activityIndicatorView stopAnimating];
 }
 
 if(aData)
 {
      NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
      NSLog(@"Response  Error %@ Response %@",error,dict);
      [HttpClient createaAlertWithMsg:[dict valueForKey:@"message"] andTitle:@""];
     
     if([[dict valueForKey:@"success"] intValue] == 1)
     {
         VW_overlay.hidden=YES;
         [activityIndicatorView stopAnimating];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_Response_Dic valueForKey:@"message"]delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
         [alert show];
         NSLog(@"The Wishlist%@",json_Response_Dic);
     }
     else{
         VW_overlay.hidden=YES;
         [activityIndicatorView stopAnimating];
     }
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
        NSUserDefaults *user_dflts = [NSUserDefaults standardUserDefaults];
        NSString *country = [user_dflts valueForKey:@"country_id"];
        NSString *languge = [user_dflts valueForKey:@"language_id"];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@Pages/details/%@/%@/%@.json",SERVER_URL,[user_dflts valueForKey:@"product_list_key_sub"],country,languge];
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
                        [self set_UP_VIEW];
                        [_collectionview_variants reloadData];
                        [_TBL_reviews reloadData];
//                        [self.collectionview_size reloadData];
//                        [self.collectionView_color reloadData];
                        [self.collection_images reloadData];
                        [self set_Data_to_UIElements];
                        NSArray *size_Color_arr = [json_Response_Dic valueForKey:@"getVariantNames"];
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


-(void)cart_count_API
{
    
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
            @try {
                NSString *badge_value = [NSString stringWithFormat:@"%@",[data valueForKey:@"count"]];
                //NSString *badge_value = @"11";
                if(badge_value.length > 2)
                {
                    self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
                    
                }
                else{
                    self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
                    
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
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithObjects:indexPath, nil];
    
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [_collectionview_variants reloadItemsAtIndexPaths:indexPaths];
    [UIView setAnimationsEnabled:animationsEnabled];
    
    
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
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0]}
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
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:18.0],NSForegroundColorAttributeName:[UIColor lightGrayColor]}
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
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:18.0],NSForegroundColorAttributeName:[UIColor darkGrayColor]}
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
    return 10;
}

- (IBAction)add_to_wih_list:(id)sender {
    
    
    if ([[[json_Response_Dic valueForKey:@"products"] valueForKey:@"wishStatus"] isEqualToString:@"No"]) {
        
        [HttpClient createaAlertWithMsg:@"already added" andTitle:@""];
        
    }
    else{
        [self performSelector:@selector(wish_list_API) withObject:activityIndicatorView afterDelay:0.01];
        
        
    }
}

// product Detail to Wish List

- (IBAction)product_detail_cart_page:(id)sender {
   
        [self performSegueWithIdentifier:@"productDetail_to_wishList" sender:self];
   
}
@end
