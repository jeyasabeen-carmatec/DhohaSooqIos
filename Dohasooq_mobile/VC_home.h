//
//  VC_home.h
//  Dohasooq_mobile
//
//  Created by Test User on 23/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol collection_protocol <NSObject>


-(void)collection_acttion:(NSString *) hot_deals_url : (NSString *)item_name;
-(void)images_action:(NSString *)deals_url : (NSString *)item_name;
-(void)brands_action:(NSString *)brands_url : (NSString *)item_name;
-(void)images_selction:(NSString *)images_url : (NSString *)item_name;
-(void)features_slection:(NSString *)features_url : (NSString *)item_name;
-(void)search_results:(NSString *)search_url :(NSString *)item_name;
-(void)Total_search;



@end

@interface VC_home : UIViewController
@property(nonatomic,strong) NSArray *items;
@property(nonatomic,assign) id<collection_protocol>delegate;

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
@property(nonatomic,weak) IBOutlet UIButton *BTN_back;
@property(nonatomic,weak) IBOutlet UIButton *BTN_cart_list;
@property(nonatomic,weak) IBOutlet UIButton *BTN_wish_list;





//view First View
@property(nonatomic,weak) IBOutlet UIView *VW_First;
@property(nonatomic,weak) IBOutlet UITextField *search_bar;
@property(nonatomic,weak) IBOutlet UITableView *TBL_search_results;

@property(nonatomic,weak) IBOutlet UICollectionView *collection_images;
@property(nonatomic,weak) IBOutlet UIPageControl *custom_story_page_controller;
@property(nonatomic,weak) IBOutlet UILabel *LBL_featured;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_features;
@property(nonatomic,weak) IBOutlet UIButton *BTN_left;
@property(nonatomic,weak) IBOutlet UIButton *BTN_right;
@property(nonatomic,weak) IBOutlet UIButton *BTN_search;




//Second view
@property(nonatomic,weak) IBOutlet UIView *VW_second;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_hot_deals;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_hot_deals_banner;

@property(nonatomic,weak) IBOutlet UILabel *Hot_deals;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_hot_deals;
//Third view
@property(nonatomic,weak) IBOutlet UIImageView *IMG_best_deals;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_best_deals_banner;

@property(nonatomic,weak) IBOutlet UIView *VW_third;
@property(nonatomic,weak) IBOutlet UILabel *LBL_Best_deals;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_best_deals;

//Fourth  view
@property(nonatomic,weak) IBOutlet UIView *VW_Fourth;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_fashion;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_fashion_banner;

@property(nonatomic,weak) IBOutlet UILabel *LBL_fashion_categiries;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_fashion_categirie;
@property(nonatomic,weak) IBOutlet UIView *VW_Fashion;
@property(nonatomic,weak) IBOutlet UILabel *LBL_profile;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_brands;



@property(nonatomic,weak) IBOutlet UILabel *LBL_best_selling;
@property(nonatomic,weak) IBOutlet UILabel *LBL_fashio;
@property(nonatomic,weak) IBOutlet UIButton *BTN_fashion;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_Person_banner;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_Things_banner;


@end
