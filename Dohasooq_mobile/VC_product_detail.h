//
//  VC_product_detail.h
//  Dohasooq_mobile
//
//  Created by Test User on 26/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"



@interface VC_product_detail : UIViewController
@property(nonatomic,weak) IBOutlet UIScrollView *Scroll_content;


@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_cart;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_fav;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_back;

//first view
@property(nonatomic,weak) IBOutlet UIView *VW_First;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_images;
@property(nonatomic,weak) IBOutlet UIPageControl *custom_story_page_controller;
@property(nonatomic,strong) IBOutlet UIButton *BTN_play;

//second view
@property(nonatomic,weak) IBOutlet UIView *VW_second;
@property(nonatomic,weak) IBOutlet UILabel *LBL_prices;
@property(nonatomic,weak) IBOutlet UILabel *LBL_discount;
@property(nonatomic,weak) IBOutlet UILabel *LBL_item_name;

//third view
@property(nonatomic,weak) IBOutlet UIView *VW_third;
@property(nonatomic,weak) IBOutlet UITextField *TXT_count;
@property(nonatomic,weak) IBOutlet UIButton *BTN_minus;
@property(nonatomic,weak) IBOutlet UIButton *BTN_plus;
@property(nonatomic,weak) IBOutlet UIButton *BTN_s;
@property(nonatomic,weak) IBOutlet UIButton *BTN_m;
@property(nonatomic,weak) IBOutlet UIButton *BTN_xL;
@property(nonatomic,weak) IBOutlet UIButton *BTN_XXL;
@property(nonatomic,weak) IBOutlet UIButton *BTN_S_color;
@property(nonatomic,weak) IBOutlet UIButton *BTN_M_color;
@property(nonatomic,weak) IBOutlet UIButton *BTN_XL_color;

//fourth view
@property(nonatomic,weak) IBOutlet UIView *VW_fourth;
@property(nonatomic,retain) IBOutlet UIView *VW_segemnt;

//fifth_view
@property(nonatomic,retain) IBOutlet UIView *VW_fifth;
@property(nonatomic,weak) IBOutlet UILabel *LBL_description;
@property(nonatomic,weak) IBOutlet UIWebView *TXTVW_description;

@property(nonatomic,weak) IBOutlet UIView *VW_filter;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_cart;

- (IBAction)productdetail_to_cartPage:(id)sender;
- (IBAction)productDetail_to_wishPage:(id)sender;


//@property(nonatomic,weak) IBOutlet UILabel *LBL_review;













@end
