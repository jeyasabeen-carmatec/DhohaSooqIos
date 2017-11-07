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
#import <SDWebImage/UIImageView+WebCache.h>


@interface VC_product_detail ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,UIWebViewDelegate>
{
    NSMutableArray *temp_arr,*color_arr,*size_arr;
    
    HCSStarRatingView *starRatingView;
    NSMutableDictionary *json_Response_Dic;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;

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
    
    [self.collection_images registerNib:[UINib nibWithNibName:@"product_detail_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_image"];

    [self set_UP_VIEW];
    
    
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
    [self performSelector:@selector(product_detail_API) withObject:activityIndicatorView afterDelay:0.01];
    
   
    
}



-(void)set_UP_VIEW
{
    [self addSEgmentedControl];
    _TXT_count.delegate = self;
    temp_arr = [[NSMutableArray alloc]init];
    temp_arr = [NSMutableArray arrayWithObjects:@"upload-2.png",@"upload-2.png",@"upload-2.png",@"upload-2.png",nil];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
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
    
    frame_set = _VW_third.frame;
    frame_set.origin.y = _VW_second.frame.origin.y + _VW_second.frame.size.height + 3;
    frame_set.size.height = _VW_third.frame.size.height;
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
    
//    _TXTVW_description.text = @"Glasses, also known as eyeglasses or spectacles, are devices consisting of glass or hard plastic lenses mounted in a frame that holds them in front of a person's eyes, typically using a bridge over the nose and arms which rest over the ears. Glasses are typically used for vision correction, such as with reading glasses and glasses used for nearsightedness.\n                        Safety glasses provide eye protection against flying debris for construction workers or lab technicians; these glasses may have protection for the sides of the eyes as well as in the lenses. Some types of safety glasses are used to protect against visible and near-visible light or radiation. Glasses are worn for eye protection in some sports, such as squash. Glasses wearers may use a strap to prevent the glasses\n \u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!";

   frame_set = _TXTVW_description.frame;
    frame_set.size.height = _TXTVW_description.frame.origin.y +  _TXTVW_description.scrollView.contentSize.height;
    _TXTVW_description.frame = frame_set;
    
   
    frame_set = _VW_fifth.frame;
    frame_set.origin.y = _VW_fourth.frame.origin.y + _VW_fourth.frame.size.height;
    frame_set.size.height = _TXTVW_description.frame.origin.y + _TXTVW_description.frame.size.height;//_TXTVW_description.contentSize.height;
    frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
    _VW_fifth.frame = frame_set;


    
    [self.Scroll_content addSubview:_VW_First];
    [self.Scroll_content addSubview:_VW_second];
    [self.Scroll_content addSubview:_BTN_play];
    [self.Scroll_content addSubview:_VW_third];
    [self.Scroll_content addSubview:_VW_fourth];
    [self.Scroll_content addSubview:_VW_fifth];
    
    

    
//    _LBL_item_name.text = @"Shining Diva Fashion";
//    
//    NSString *price = @"QR 499";
//    NSString *prev_price = @"QR 799";
//    NSString *doha_miles = @"6758";
//    NSString *mils  = @"Doha Miles";
//    NSString *text = [NSString stringWithFormat:@"%@ %@ / %@ %@",price,prev_price,doha_miles,mils];
//    
//    if ([_LBL_prices respondsToSelector:@selector(setAttributedText:)]) {
//        
//        // Define general attributes for the entire text
//        NSDictionary *attribs = @{
//                                  NSForegroundColorAttributeName:_LBL_prices.textColor,
//                                  NSFontAttributeName: _LBL_prices.font
//                                  };
//        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
//        
//        NSRange ename = [text rangeOfString:price];
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:25.0]}
//                                    range:ename];
//        }
//        else
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:19.0],NSForegroundColorAttributeName:[UIColor redColor]}
//                                    range:ename];
//        }
//        
//        
//        
//        
//        NSRange cmp = [text rangeOfString:prev_price];
//        //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:21.0]}
//                                    range:cmp];
//        }
//        else
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:13.0]}
//                                    range:cmp];
//        }
//        
//        NSRange miles_price = [text rangeOfString:doha_miles];
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:21.0]}
//                                    range:miles_price];
//        }
//        else
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:19.0],NSForegroundColorAttributeName:[UIColor redColor]}
//                                    range:miles_price];
//        }
//        NSRange miles = [text rangeOfString:mils];
//        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:21.0]}
//                                    range:miles];
//        }
//        else
//        {
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:13.0]}
//                                    range:miles];
//        }
//        
//
//        
//        _LBL_prices.attributedText = attributedText;
//    }
//    else
//    {
//        _LBL_prices.text = text;
//    }
//    self.LBL_discount.text = @"35% off";
    
    
    _TXT_count.layer.borderWidth = 0.4f;
    _TXT_count.layer.borderColor = [UIColor grayColor].CGColor;

    _BTN_plus.layer.borderWidth = 0.4f;
    _BTN_plus.layer.borderColor = [UIColor grayColor].CGColor;
    _BTN_minus.layer.borderWidth = 0.4f;
    _BTN_minus.layer.borderColor = [UIColor grayColor].CGColor;
    
    _BTN_s.layer.borderWidth = 0.4f;
    _BTN_s.layer.borderColor = [UIColor grayColor].CGColor;
    _BTN_m.layer.borderWidth = 0.4f;
    _BTN_m.layer.borderColor = [UIColor grayColor].CGColor;
    _BTN_xL.layer.borderWidth = 0.4f;
    _BTN_xL.layer.borderColor = [UIColor grayColor].CGColor;
    _BTN_XXL.layer.borderWidth = 0.4f;
    _BTN_XXL.layer.borderColor = [UIColor grayColor].CGColor;
    
    [_BTN_minus addTarget:self action:@selector(minus_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_plus addTarget:self action:@selector(plus_action) forControlEvents:UIControlEventTouchUpInside];


    _BTN_play.layer.cornerRadius = self.BTN_play.frame.size.width / 2;
    _BTN_play.layer.masksToBounds = YES;
    
    self.custom_story_page_controller.numberOfPages = [[json_Response_Dic valueForKey:@"products"] count];
    UIImage *newImage = [_IMG_cart.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(_IMG_cart.image.size, NO, newImage.scale);
    [[UIColor whiteColor] set];
    [newImage drawInRect:CGRectMake(0, 0, _IMG_cart.image.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _IMG_cart.image = newImage;

    

}
-(void)set_Data_to_UIElements{
    
    _LBL_item_name.text = [[[[[json_Response_Dic valueForKey:@"products"] objectAtIndex:0]valueForKey:@"product_descriptions"] objectAtIndex:0]valueForKey:@"title"];
     starRatingView.value = [[json_Response_Dic valueForKey:@"avgRating"] floatValue];
    
   NSString  *actuel_price =@"799";
    NSString *doha_miles = @"6758";
    NSString *mils  = @"Doha Miles";
    NSString *text = [NSString stringWithFormat:@"QR %@ QR %@ / %@ %@",[NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] objectAtIndex:0] valueForKey:@"product_price"]],actuel_price,doha_miles,mils];
    
    /************/
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName:_LBL_prices.textColor,
                              NSFontAttributeName: _LBL_prices.font
                              };
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
    //[attributedText addAttribute:NSStrikethroughStyleAttributeName value:@2 range:[text rangeOfString:actuel_price]];
    [attributedText addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(actuel_price.length+7, actuel_price.length)];
    self.LBL_prices.attributedText =attributedText;
    [attributedText addAttribute:NSBaselineOffsetAttributeName value:@5 range:[text rangeOfString:actuel_price]];
    
    _LBL_prices.attributedText = attributedText;
    /****************/
    
    if ([_LBL_prices respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
//        NSDictionary *attribs = @{
//                                  NSForegroundColorAttributeName:_LBL_prices.textColor,
//                                  NSFontAttributeName: _LBL_prices.font
//                                  };
//        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        

        
        NSRange ename = [text rangeOfString:[NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] objectAtIndex:0] valueForKey:@"product_price"]]];
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
        
        
        
        _LBL_prices.attributedText = attributedText;
    }
    else
    {
        _LBL_prices.text = text;
    }
    NSString *discount;
    if (discount.length == 0) {
        self.LBL_discount.text = @"0% off";
    }
    else{
    NSString *str = @"%off";
        self.LBL_discount.text = [NSString stringWithFormat:@"%@ %@",discount,str];
    }
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_content layoutIfNeeded];
    _Scroll_content.contentSize = CGSizeMake(_Scroll_content.frame.size.width,_VW_fifth.frame.origin.y+ _VW_fifth.frame.size.height + self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height + _VW_filter.frame.size.height );
    
    
}

#pragma Button Actions
-(void)btnfav_action
{
    
}
-(void)btn_cart_action
{
    
}
-(void)minus_action
{
    int s = [_TXT_count.text intValue];
    s = s - 1;
    _TXT_count.text = [NSString stringWithFormat:@"%d",s];
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
}

#pragma collection view delagets
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _collection_images) {
        //return temp_arr.count;
        return [[json_Response_Dic valueForKey:@"products"] count];

    }
    else if(collectionView == self.collectionview_size){
        
        return [[[size_arr lastObject] allKeys] count];
    }
    else {
        return [[[color_arr lastObject] allKeys] count];
        
    }
    
    
}
    - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
    {

        if (collectionView == _collection_images) {
            product_detail_cell *img_cell = (product_detail_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_image" forIndexPath:indexPath];
            
          #pragma Webimage URl Cachee
            
            NSString *img_url = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] objectAtIndex:indexPath.row] valueForKey:@"product_image"]];
            [img_cell.img sd_setImageWithURL:[NSURL URLWithString:img_url]
                            placeholderImage:[UIImage imageNamed:@"logo.png"]
                                     options:SDWebImageRefreshCached];
            
            
            
            //img_cell.img.image = [UIImage imageNamed:[temp_arr objectAtIndex:indexPath.row]];
            img_cell.img.contentMode = UIViewContentModeScaleAspectFit;
            
            
            return img_cell;

        }
        else if (collectionView == _collectionview_size){
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"size_cell" forIndexPath:indexPath];
            UIButton *size_btn = (UIButton *)[cell viewWithTag:1];

            [size_btn setTitle:[NSString stringWithFormat:@"%@",[[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:0] valueForKey:@"0"] valueForKey:[[[[[json_Response_Dic valueForKey:@"getVariantNames"] objectAtIndex:0] valueForKey:@"0"] allKeys]objectAtIndex:indexPath.row]]] forState:UIControlStateNormal];

            return cell;
        }
        else{
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"color_cell" forIndexPath:indexPath];
            UIButton *btn = (UIButton*)[cell viewWithTag:1];
            if (indexPath.row%2 != 0) {
                btn.backgroundColor = [UIColor blueColor];

            }
            return cell;
            
        }
        
        
        
           }
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _collection_images) {
        return CGSizeMake(_collection_images.frame.size.width ,_collection_images.frame.size.height);

    }
    else{
        return CGSizeMake(_collectionView_color.frame.size.width/10, 25);
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
        
//        _TXTVW_description.text = @"Glasses, also known as eyeglasses or spectacles, are devices consisting of glass or hard plastic lenses mounted in a frame that holds them in front of a person's eyes, typically using a bridge over the nose and arms which rest over the ears. Glasses are typically used for vision correction, such as with reading glasses and glasses used for nearsightedness.\n                                Safety glasses provide eye protection against flying debris for construction workers or lab technicians; these glasses may have protection for the sides of the eyes as well as in the lenses. Some types of safety glasses are used to protect against visible and near-visible light or radiation. Glasses are worn for eye protection in some sports, such as squash. Glasses wearers may use a strap to prevent the glasses\n \u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!\n\u2022 This is a list item!";
        
        [_TXTVW_description loadHTMLString:[[[[[json_Response_Dic valueForKey:@"products"] objectAtIndex:0]valueForKey:@"product_descriptions"] objectAtIndex:0]valueForKey:@"description"] baseURL:nil];
        
         CGRect frame_set = _VW_fifth.frame;
         frame_set.origin.y = _VW_fourth.frame.origin.y + _VW_fourth.frame.size.height;
        frame_set.size.height = _TXTVW_description.frame.origin.y + _TXTVW_description.scrollView.contentSize.height + 100;
        frame_set.size.width = self.navigationController.navigationBar.frame.size.width;

        _VW_fifth.frame = frame_set;
        [self viewDidLayoutSubviews];
       
        
    }
    else
    {
//        _TXTVW_description.text = @"Glasses, also known as eyeglasses or spectacles, are devices consisting of glass or hard  ";
//        
        CGRect frame_set = _VW_fifth.frame;
        frame_set.origin.y = _VW_fourth.frame.origin.y + _VW_fourth.frame.size.height;
        frame_set.size.height = _TXTVW_description.frame.origin.y + _TXTVW_description.scrollView.contentSize.height;
        frame_set.size.width = self.navigationController.navigationBar.frame.size.width;
        _VW_fifth.frame = frame_set;
         [self viewDidLayoutSubviews];

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
- (IBAction)Wish_list_action:(id)sender
{
    @try
    {
//        NSUserDefaults *user_dflts = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        NSString *poduct_id = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"products"] objectAtIndex:0]valueForKey:@"id"]];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@/addToWishList/%@/%@",SERVER_URL,poduct_id,user_id];
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
                        NSLog(@"The Wishlist%@",json_Response_Dic);
                    }
                    
                    
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

- (IBAction)productdetail_to_cartPage:(id)sender {
    [self performSegueWithIdentifier:@"productDetail_to_cart" sender:self];
}

//- (IBAction)productDetail_to_wishPage:(id)sender {
//    [self performSegueWithIdentifier:@"productDetail_to_wishList" sender:self];
//}

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
                         NSLog(@"%@",json_Response_Dic);
                        [self.collectionview_size reloadData];
                        [self.collectionView_color reloadData];
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

@end
