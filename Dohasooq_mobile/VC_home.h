//
//  VC_home.h
//  Dohasooq_mobile
//
//  Created by Test User on 23/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_home : UIViewController
@property(nonatomic,strong) NSArray *items;

//side bar
@property (nonatomic, strong) IBOutlet UIView *VW_swipe;
@property (readonly, nonatomic) int menyDraw_X,menuDraw_width;
@property(nonatomic,weak) IBOutlet UIButton *BTN_myorder;
@property(nonatomic,weak) IBOutlet UIButton *BTN_wishlist;
@property(nonatomic,weak) IBOutlet UIButton *BTN_address;
@property(nonatomic,weak) IBOutlet UILabel *LBL_order_icon;
@property(nonatomic,weak) IBOutlet UILabel *LBL_order;
@property(nonatomic,weak) IBOutlet UILabel *LBL_wish_list_icon;
@property(nonatomic,weak) IBOutlet UILabel *LBL_wish_list;
@property(nonatomic,weak) IBOutlet UILabel *LBL_address_icon;
@property(nonatomic,weak) IBOutlet UILabel *LBL_address;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_profile;
@property(nonatomic,weak) IBOutlet UITableView *TBL_menu;

@property(nonatomic,weak) IBOutlet UIScrollView *Scroll_contents;

//view navigation bar
@property(nonatomic,weak) IBOutlet UIButton *BTN_menu;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_fav;
@property(nonatomic,weak) IBOutlet UIBarButtonItem *BTN_cart;



//view First View
@property(nonatomic,weak) IBOutlet UIView *VW_First;
@property(nonatomic,weak) IBOutlet UITextField *search_bar;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_images;
@property(nonatomic,weak) IBOutlet UIPageControl *custom_story_page_controller;
@property(nonatomic,weak) IBOutlet UILabel *LBL_featured;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_features;
@property(nonatomic,weak) IBOutlet UIButton *BTN_left;
@property(nonatomic,weak) IBOutlet UIButton *BTN_right;



//Second view
@property(nonatomic,weak) IBOutlet UIView *VW_second;
@property(nonatomic,weak) IBOutlet UILabel *Hot_deals;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_hot_deals;
//Third view
@property(nonatomic,weak) IBOutlet UIView *VW_third;
@property(nonatomic,weak) IBOutlet UILabel *LBL_Best_deals;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_best_deals;

//Fourth  view
@property(nonatomic,weak) IBOutlet UIView *VW_Fourth;
@property(nonatomic,weak) IBOutlet UILabel *LBL_fashion_categiries;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_fashion_categirie;
@property(nonatomic,weak) IBOutlet UIView *VW_profile;
@property(nonatomic,weak) IBOutlet UILabel *LBL_profile;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_brands;



@property(nonatomic,weak) IBOutlet UILabel *LBL_best_selling;
@property(nonatomic,weak) IBOutlet UILabel *LBL_fashio;








@end
