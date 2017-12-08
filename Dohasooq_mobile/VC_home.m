//
//  VC_home.m
//  Dohasooq_mobile
//
//  Created by Test User on 23/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_home.h"
#import "collection_img_cell.h"
#import "hot_deals_cell.h"
#import "Best_deals_cell.h"
#import "Fashion_categorie_cell.h"
#import "UIBarButtonItem+Badge.h"
#import "cell_features.h"
#import "cell_brands.h"
#import "categorie_cell.h"
#import "dynamic_categirie_cell.h"
#import "HttpClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "product_cell.h"
#import "VC_product_detail.h"

@interface VC_home ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *temp_arr,*temp_hot_deals,*fashion_categirie_arr,*brands_arr,*ARR_category,*lang_arr;
    NSIndexPath *INDX_selected;
    NSInteger i,lang_count;
    int tag;
    NSMutableDictionary *json_Response_Dic;
    float scroll_ht;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    
}
//@property(nonatomic, readonly) NSArray<__kindof UICollectionViewCell *> *visibleCells;
@property(nonatomic,strong) UIView *overlayView;

@end

@implementation VC_home

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _Scroll_contents.delegate =self;
    
    
    
    [self.collection_images registerNib:[UINib nibWithNibName:@"cell_image" bundle:nil]  forCellWithReuseIdentifier:@"collection_image"];
    [self.collection_features registerNib:[UINib nibWithNibName:@"cell_features" bundle:nil]  forCellWithReuseIdentifier:@"features_cell"];
    //         [self.collection_brands registerNib:[UINib nibWithNibName:@"cell_brands" bundle:nil]  forCellWithReuseIdentifier:@"brands_cell"];
    [self.collection_hot_deals registerNib:[UINib nibWithNibName:@"product_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_product"];
    [self.collection_best_deals registerNib:[UINib nibWithNibName:@"product_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_product"];
    [self.collection_fashion_categirie registerNib:[UINib nibWithNibName:@"Fashion_categorie_cell" bundle:nil]  forCellWithReuseIdentifier:@"fashion_categorie"];
    _Hot_deals.text = @"WOMEN'S FASHION ACCESORIES";
    brands_arr = [[NSMutableArray alloc]init];
    [self set_up_VIEW];
    // [self menu_set_UP];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.hidden = NO;
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    VW_overlay.hidden = YES;

    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(API_call_total) withObject:activityIndicatorView afterDelay:0.01];


    
  
    
}

-(void)menu_set_UP
{
    // [self.TBL_menu reloadData];
    
    
    int statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
    statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
    _menuDraw_width = [UIApplication sharedApplication].statusBarFrame.size.width * 0.80;
    _menyDraw_X = self.navigationController.view.frame.size.width; //- menuDraw_width;
    _VW_swipe.frame = CGRectMake(0, self.view.frame.origin.y, _menuDraw_width, self.navigationController.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
    
    _overlayView = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
    _overlayView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [self.navigationController.view addSubview:_overlayView];
    [_overlayView addSubview:_VW_swipe];
    
    _IMG_profile.layer.cornerRadius = _IMG_profile.frame.size.width / 2;
    _IMG_profile.layer.masksToBounds = YES;
    _IMG_profile.layer.borderWidth = 2.0f;
    _IMG_profile.layer.borderColor = [UIColor blackColor].CGColor;
    
    [_LBL_profile sizeToFit];
    CGRect frameset = _BTN_myorder.frame;
    frameset.size.width = (_VW_swipe.frame.size.width/3) - 2;
    _BTN_myorder.frame = frameset;
    
    frameset = _BTN_wishlist.frame;
    frameset.origin.x = _BTN_myorder.frame.origin.x + _BTN_myorder.frame.size.width + 1;
    frameset.size.width = (_VW_swipe.frame.size.width/3);
    _BTN_wishlist.frame = frameset;
    
    frameset = _BTN_address.frame;
    frameset.origin.x = _BTN_wishlist.frame.origin.x + _BTN_wishlist.frame.size.width + 1;
    frameset.size.width = (_VW_swipe.frame.size.width/3) - 1;
    _BTN_address.frame = frameset;
    
    
    frameset=_LBL_order_icon.frame;
    frameset.origin.y = _BTN_myorder.frame.origin.y + _LBL_order_icon.frame.size.height;
    frameset.size.width = _BTN_myorder.frame.size.width;
    _LBL_order_icon.frame = frameset;
    
    frameset = _LBL_order.frame;
    frameset.origin.y = _LBL_order_icon.frame.origin.y + _LBL_order_icon.frame.size.height;
    frameset.size.width = _BTN_myorder.frame.size.width;
    _LBL_order.frame = frameset;
    
    
    frameset=_LBL_wish_list_icon.frame;
    frameset.origin.x = _BTN_wishlist.frame.origin.x;
    frameset.origin.y = _BTN_wishlist.frame.origin.y + _LBL_wish_list_icon.frame.size.height;
    frameset.size.width = _BTN_wishlist.frame.size.width;
    _LBL_wish_list_icon.frame = frameset;
    
    frameset = _LBL_wish_list.frame;
    frameset.origin.x = _BTN_wishlist.frame.origin.x;
    frameset.origin.y = _LBL_wish_list_icon.frame.origin.y + _LBL_wish_list_icon.frame.size.height;
    frameset.size.width = _BTN_wishlist.frame.size.width;
    _LBL_wish_list.frame = frameset;
    
    
    frameset=_LBL_address_icon.frame;
    frameset.origin.x = _BTN_address.frame.origin.x;
    frameset.origin.y = _BTN_address.frame.origin.y + _LBL_address_icon.frame.size.height;
    frameset.size.width = _BTN_address.frame.size.width;
    _LBL_address_icon.frame = frameset;
    
    frameset = _LBL_address.frame;
    frameset.origin.x = _BTN_address.frame.origin.x;
    frameset.origin.y = _LBL_address_icon.frame.origin.y + _LBL_address_icon.frame.size.height;
    frameset.size.width = _BTN_address.frame.size.width;
    _LBL_address.frame = frameset;
    
    //    frameset = _VW_swipe.frame;
    //    frameset.size.height =  self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height;
    //    _VW_swipe.frame = frameset;
    
    _overlayView.hidden = YES;
    
    NSMutableArray *arr_tmp = [[NSMutableArray alloc] init];
    [arr_tmp addObject:@{@"Name":@"Item 0",@"level":@"0"}];
    NSMutableArray *arr_MUT = [[NSMutableArray alloc]init];
    NSMutableArray *test_ARR =  [[NSMutableArray alloc]init];
    [test_ARR addObject:@{@"Name":@"SubItem 1",@"level":@"2"}];
    [arr_MUT addObject:@{@"Name":@"SubItem 0",@"SubItems":test_ARR,@"level":@"1"}];
    [arr_MUT addObject:@{@"Name":@"SubItem 1",@"level":@"1"}];
    [arr_tmp addObject:@{@"Name":@"Item 1",@"SubItems":arr_MUT,@"level":@"0"}];
    
    arr_MUT = [[NSMutableArray alloc]init];
    [arr_MUT addObject:@{@"Name":@"SubItem 1",@"level":@"1"}];
    [arr_MUT addObject:@{@"Name":@"SubItem 2",@"level":@"1"}];
    [arr_tmp addObject:@{@"Name":@"Item 2",@"SubItems":arr_MUT,@"level":@"0"}];
    
    [arr_tmp addObject:@{@"Name":@"Item 3",@"level":@"0"}];
    [arr_tmp addObject:@{@"Name":@"Item 4",@"level":@"0"}];
    [arr_tmp addObject:@{@"Name":@"Item 5",@"level":@"0"}];
    [arr_tmp addObject:@{@"Name":@"Item 6",@"level":@"0"}];
    [arr_tmp addObject:@{@"Name":@"Item 7",@"level":@"0"}];
    [arr_tmp addObject:@{@"Name":@"Item 8",@"level":@"0"}];
    
    
    NSDictionary *temp = @{@"Items":arr_tmp};
    
    self.items=[temp valueForKey:@"Items"];
    ARR_category = [[NSMutableArray alloc]init];
    [ARR_category addObjectsFromArray:self.items];
    
    
    i = ARR_category.count;
    
    lang_arr = [[NSMutableArray alloc]init];
    lang_arr = [NSMutableArray arrayWithObjects:@"ENGLISH", nil];
    lang_count = lang_arr.count;
    UISwipeGestureRecognizer *SwipeLEFT = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeLeft:)];
    SwipeLEFT.direction = UISwipeGestureRecognizerDirectionLeft;
    [_overlayView addGestureRecognizer:SwipeLEFT];
    
    UISwipeGestureRecognizer *SwipeRIGHT = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRight:)];
    SwipeRIGHT.direction = UISwipeGestureRecognizerDirectionRight;
    //    [self.view addGestureRecognizer:SwipeRIGHT];
    [_overlayView addGestureRecognizer:SwipeRIGHT];
    
}

-(void)set_up_VIEW
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
       } forState:UIControlStateNormal];
    
    _BTN_fav  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain  target:self action:
                 @selector(btnfav_action)];
    
    _LBL_best_selling.text = @"BEST SELLING\nPRODUCTS";
    _LBL_fashio.text = @"FASHION\nACCSESORIES";
    
    
    NSString *badge_value = @"25";
    _BTN_cart.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
    if(badge_value.length > 2)
    {
        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
        
    }
    else{
        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
        
    }
    //    brands_arr = [NSMutableArray arrayWithObjects:@"brand.png",@"brand.png",@"brand.png",@"brand.png",@"brand.png",@"brand.png",@"brand.png",@"brand.png",nil];
    
    temp_arr = [[NSMutableArray alloc]init];
    temp_arr = [NSMutableArray arrayWithObjects:@"featured_banner.jpg",@"banner.jpg",@"featured_banner.jpg",@"banner.jpg",nil];
    
    temp_hot_deals = [[NSMutableArray alloc]init];
    fashion_categirie_arr = [[NSMutableArray alloc]init];
    NSDictionary *fashion_dict;
    fashion_dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"70% off",@"key2",@"shop now",@"key3",@"upload-2.png",@"key5",nil];
    [fashion_categirie_arr addObject:fashion_dict];
    fashion_dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"70% off",@"key2",@"shop now",@"key3",@"upload-2.png",@"key5",nil];
    [fashion_categirie_arr addObject:fashion_dict];
    fashion_dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"70% off",@"key2",@"shop now",@"key3",@"upload-2.png",@"key5",nil];
    [fashion_categirie_arr addObject:fashion_dict];
    fashion_dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"70% off",@"key2",@"shop now",@"key3",@"upload-2.png",@"key5",nil];
    [fashion_categirie_arr addObject:fashion_dict];
    
    NSDictionary *temp_dictin;
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR 799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [temp_hot_deals addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR 799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [temp_hot_deals addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR 799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [temp_hot_deals addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR 799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [temp_hot_deals addObject:temp_dictin];
    
    
    CGRect setupframe = _VW_First.frame;
    //setupframe.origin.y =  _VW_nav.frame.size.height;
    setupframe.size.width = _Scroll_contents.frame.size.width;
    _VW_First.frame = setupframe;
    [self.Scroll_contents addSubview:_VW_First];
    
    @try {
        
    NSString *hot_deals_IMG_url = [NSString stringWithFormat:@"%@uploads/widgets/%@",SERVER_URL,[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"widget_image"]];
    hot_deals_IMG_url = [hot_deals_IMG_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [_IMG_hot_deals sd_setImageWithURL:[NSURL URLWithString:hot_deals_IMG_url]
                      placeholderImage:[UIImage imageNamed:@"logo.png"]
                               options:SDWebImageRefreshCached];
    
    
    NSString *best_deals_IMG_url = [NSString stringWithFormat:@"%@uploads/widgets/%@",SERVER_URL,[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0]objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"widget_image"]];
    best_deals_IMG_url = [best_deals_IMG_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [_IMG_best_deals sd_setImageWithURL:[NSURL URLWithString:best_deals_IMG_url]
                       placeholderImage:[UIImage imageNamed:@"logo.png"]
                                options:SDWebImageRefreshCached];
    
    
    _IMG_hot_deals .userInteractionEnabled = YES;
    
    UITapGestureRecognizer *hot_deals_hesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(hot_deals_action)];
    
    hot_deals_hesture.numberOfTapsRequired = 1;
    
    [hot_deals_hesture setDelegate:self];
    
    [_IMG_hot_deals addGestureRecognizer:hot_deals_hesture];
    
    _IMG_best_deals .userInteractionEnabled = YES;
    
    UITapGestureRecognizer *best_deals_gesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(best_deals_action)];
    
    best_deals_gesture.numberOfTapsRequired = 1;
    
    [best_deals_gesture setDelegate:self];
    
    [_IMG_best_deals addGestureRecognizer:best_deals_gesture];
    
    

    
    setupframe = _VW_second.frame;
    setupframe.origin.y = _VW_First.frame.origin.y + _VW_First.frame.size.height;
    setupframe.size.height = _collection_hot_deals.frame.origin.y + _collection_hot_deals.collectionViewLayout.collectionViewContentSize.height+10;
    setupframe.size.width = _Scroll_contents.frame.size.width;
    _VW_second.frame = setupframe;
    [self.Scroll_contents addSubview:_VW_second];
    
    [_collection_best_deals reloadData];
    
    
    setupframe = _VW_third.frame;
    setupframe.origin.y = _VW_second.frame.origin.y + _VW_second.frame.size.height +10;
    setupframe.size.height = _collection_best_deals.frame.origin.y + _collection_best_deals.collectionViewLayout.collectionViewContentSize.height+10;
    setupframe.size.width = _Scroll_contents.frame.size.width;
    _VW_third.frame = setupframe;
    [self.Scroll_contents addSubview:_VW_third];
    
    [_collection_fashion_categirie reloadData];
    
    setupframe = _VW_Fourth.frame;
    setupframe.origin.y = _VW_third.frame.origin.y + _VW_third.frame.size.height +10;
    setupframe.size.height = _collection_fashion_categirie.frame.origin.y + _collection_fashion_categirie.collectionViewLayout.collectionViewContentSize.height+10;
    setupframe.size.width = _Scroll_contents.frame.size.width;
    _VW_Fourth.frame = setupframe;
    [self.Scroll_contents addSubview:_VW_Fourth];
        NSArray *fashion = [[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-2"];
        NSLog(@"THE count:%lu",(unsigned long)fashion.count);
    
    
    
        if([[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"]count] < 1)
        {
            _VW_second.hidden = YES;
            if([[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"]count] < 1)
            {
                _VW_third.hidden = YES;
                if(brands_arr.count < 1)
                {
                    if([[json_Response_Dic valueForKey:@"bannerFashion"]count] < 1)
                    {
                        _VW_Fourth.hidden = YES;
                    }
                    
                }
                else
                {
                    _VW_Fourth.hidden = NO;
                    if([[json_Response_Dic valueForKey:@"bannerFashion"]count]< 1)
                    {
                        _collection_fashion_categirie.hidden = YES;
                    }
                    else
                    {
                        setupframe = _VW_Fourth.frame;
                        setupframe.origin.y  = _VW_First.frame.origin.y + _VW_First.frame.size.height;
                        _VW_Fourth.frame = setupframe;
                        
                    }
                }
                
            }
            else
            {
                setupframe = _VW_third.frame;
                setupframe.origin.y  = _VW_First.frame.origin.y + _VW_First.frame.size.height;
                _VW_third.frame = setupframe;
                if(brands_arr.count < 1)
                {
                    if([[json_Response_Dic valueForKey:@"bannerFashion"]count] < 1)
                    {
                        _VW_Fourth.hidden = YES;
                    }
                    
                }
                else
                {
                    _VW_Fourth.hidden = NO;
                    if([[json_Response_Dic valueForKey:@"bannerFashion"]count]< 1)
                    {
                        _collection_fashion_categirie.hidden = YES;
                    }
                    else
                    {
                        setupframe = _VW_Fourth.frame;
                        setupframe.origin.y  = _VW_third.frame.origin.y + _VW_third.frame.size.height;
                        _VW_Fourth.frame = setupframe;
                        
                    }
                }
                
            }
            
            
        }
        else
        {
            _VW_second.hidden = NO;
            
            if([[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"]count] < 1)
            {
                _VW_third.hidden = YES;
                if(brands_arr.count < 1)
                {
                    if([[json_Response_Dic valueForKey:@"bannerFashion"]count] < 1)
                    {
                        _VW_Fourth.hidden = YES;
                    }
                    
                }
                else
                {
                    _VW_Fourth.hidden = NO;
                    if([[json_Response_Dic valueForKey:@"bannerFashion"]count] < 1)
                    {
                        _collection_fashion_categirie.hidden = YES;
                    }
                    else
                    {
                        setupframe = _VW_Fourth.frame;
                        setupframe.origin.y  = _VW_second.frame.origin.y + _VW_second.frame.size.height;
                        _VW_Fourth.frame = setupframe;
                        
                    }
                }
                
            }
            else
            {
                _VW_third.hidden = NO;
                setupframe = _VW_third.frame;
                setupframe.origin.y  = _VW_second.frame.origin.y + _VW_second.frame.size.height;
                _VW_third.frame = setupframe;
                if(brands_arr.count < 1)
                {
                    if([[json_Response_Dic valueForKey:@"bannerFashion"]count] < 1)
                    {
                        _VW_Fourth.hidden = YES;
                    }
                    
                }
                else
                {
                    _VW_Fourth.hidden = NO;
                    if([[json_Response_Dic valueForKey:@"bannerFashion"]count] < 1)
                    {
                        _collection_fashion_categirie.hidden = YES;
                    }
                    else
                    {
                        setupframe = _VW_Fourth.frame;
                        setupframe.origin.y  = _VW_third.frame.origin.y + _VW_third.frame.size.height;
                        _VW_Fourth.frame = setupframe;
                        
                    }
                }
                
                
                
            }
            
            
        }
    if(_VW_second.hidden == YES)
    {
        if(_VW_third.hidden == YES)
        {
            if(_VW_Fourth.hidden == YES)
            {
                scroll_ht = _VW_First.frame.origin.y + _VW_First.frame.size.height;
            }
            else
            {
                scroll_ht = _VW_Fourth.frame.origin.y + _VW_Fourth.frame.size.height;
                
            }
        }
        else
        {
            if(_VW_Fourth.hidden == YES)
            {
                scroll_ht = _VW_third.frame.origin.y + _VW_third.frame.size.height;
                
            }
            else
            {
                scroll_ht = _VW_Fourth.frame.origin.y + _VW_Fourth.frame.size.height;
                
            }
            
            
        }
        
    }
    else
    {
        if(_VW_third.hidden == YES)
        {
            if(_VW_Fourth.hidden == YES)
            {
                scroll_ht = _VW_second.frame.origin.y + _VW_second.frame.size.height;
            }
            else
            {
                scroll_ht = _VW_Fourth.frame.origin.y + _VW_Fourth.frame.size.height;

            }
        }
        else
        {
            if(_VW_Fourth.hidden == YES)
            {
                scroll_ht = _VW_third.frame.origin.y + _VW_third.frame.size.height;
                
            }
            else
            {
                
            scroll_ht = _VW_Fourth.frame.origin.y + _VW_Fourth.frame.size.height;
 
            }
        }
        
    }
    
   
    
    self.search_bar.layer.borderWidth = 0.3f;
    self.search_bar.layer.masksToBounds = [UIColor blackColor];
    self.custom_story_page_controller.numberOfPages=[[json_Response_Dic valueForKey:@"banners"] count];
    _BTN_left.layer.cornerRadius = _BTN_left.frame.size.width/2;
    _BTN_left.layer.masksToBounds = YES;
    _BTN_right.layer.cornerRadius = _BTN_right.frame.size.width/2;
    _BTN_right.layer.masksToBounds = YES;
    [_collection_brands reloadData];
    
    [_BTN_right addTarget:self action:@selector(BTN_right_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_left addTarget:self action:@selector(BTN_left_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_menu addTarget:self action:@selector(MENU_action) forControlEvents:UIControlEventTouchUpInside];
     
        _BTN_fashion.tag = 1;
        [_BTN_fashion addTarget:self action:@selector(BTN_fashhion_cahnge) forControlEvents:UIControlEventTouchUpInside];

    }
    @catch(NSException *exception)
    {
        
    }
    [self viewDidLayoutSubviews];
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_contents layoutIfNeeded];
    
    
    _Scroll_contents.contentSize = CGSizeMake(_Scroll_contents.frame.size.width,scroll_ht);
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == _collection_images)
    {
        @try {
            return [[json_Response_Dic valueForKey:@"banners"] count];
            
        } @catch (NSException *exception) {
            return 1;
        }
    }
    else if(collectionView == _collection_features)
    {
        //return temp_arr.count;
        NSLog(@"Max count %lu",[[json_Response_Dic valueForKey:@"bannerLarge"]count]);
        return [[json_Response_Dic valueForKey:@"bannerLarge"]count];
        
    }
    else if(collectionView == _collection_hot_deals )
    {
        //return temp_hot_deals.count;
        return [[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] count];
        
    }
    else if( collectionView == _collection_best_deals)
    {
        //return temp_hot_deals.count; dealWidget-1
        return [[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] count];
        
    }
    else if( collectionView == _collection_brands)
    {
        return brands_arr.count;
    }
    
    else if(collectionView == _collection_fashion_categirie)
    {
        return [[json_Response_Dic valueForKey:@"bannerFashion"]count];
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(collectionView == _collection_images)
    {
        collection_img_cell *img_cell = (collection_img_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_image" forIndexPath:indexPath];
        NSString *url_Img_FULL = [NSString stringWithFormat:@"%@uploads/banners/%@",SERVER_URL,[[[json_Response_Dic valueForKey:@"banners"] objectAtIndex:indexPath.row] valueForKey:@"banner"]];
        url_Img_FULL  =[url_Img_FULL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [img_cell.img sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                        placeholderImage:[UIImage imageNamed:@"logo.png"]
                                 options:SDWebImageRefreshCached];
        
        
        
        //img_cell.img.image = [UIImage imageNamed:[temp_arr objectAtIndex:indexPath.row]];
        
        return img_cell;
    }
    else if(collectionView == _collection_features)
    {
        cell_features *cell = (cell_features *)[collectionView dequeueReusableCellWithReuseIdentifier:@"features_cell" forIndexPath:indexPath];
        //cell.img.image = [UIImage imageNamed:[temp_arr objectAtIndex:indexPath.row]];
        
        @try {
            NSString *url_Img_FULL = [NSString stringWithFormat:@"%@uploads/banners_ads/%@",SERVER_URL,[[[json_Response_Dic valueForKey:@"bannerLarge"] objectAtIndex:indexPath.row] valueForKey:@"banner"]];
            url_Img_FULL  =[url_Img_FULL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            [cell.img sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                        placeholderImage:[UIImage imageNamed:@"logo.png"]];
            
            _LBL_featured.text = [[[json_Response_Dic valueForKey:@"bannerLarge"] objectAtIndex:indexPath.row] valueForKey:@"title"];
        } @catch (NSException *exception) {
            NSLog(@"Exception from cell item indexpath %@",exception);
        }
        
        
        return cell;
        
        
    }

    else if(collectionView == _collection_hot_deals)
    {
        product_cell *pro_cell = (product_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_product" forIndexPath:indexPath];
        
        @try
        {
            
            
#pragma Webimage URl Cachee
            
            NSString *url_Img_FULL =[NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"product_image"]];
            
            [pro_cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                                          options:SDWebImageRefreshCached];
            
            
            
            pro_cell.LBL_item_name.text = [[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"ProductDescriptions"] valueForKey:@"title"];
            
            pro_cell.LBL_rating.text = [NSString stringWithFormat:@"%@  ",[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"product_reviews"] valueForKey:@"rating"]];
            int rating = [[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"product_reviews"] valueForKey:@"rating"] intValue];
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
            
           
            pro_cell.LBL_current_price.text = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"special_price"]];
            
            NSString *current_price = [NSString stringWithFormat:@"QR %@", [[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"special_price"]];
            
            NSString *prec_price = [NSString stringWithFormat:@"QR %@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"product_price"]];
            NSString *text = [NSString stringWithFormat:@"%@ %@",current_price,prec_price];
            
            if ([pro_cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
                
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setAlignment:NSTextAlignmentCenter];
                
                if ([current_price isEqualToString:@"QR <null>"]) {
                    
                    
                    NSString *text = [NSString stringWithFormat:@" %@",prec_price];
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor],}range:[text rangeOfString:prec_price] ];
                    
                    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                    //NSParagraphStyleAttributeName
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    
                    
                    
                }
                
                else{
                    
                    // Define general attributes for the entire text
                    //        NSDictionary *attribs = @{
                    //                                  NSForegroundColorAttributeName:pro_cell.LBL_current_price.textColor,
                    //                                  NSFontAttributeName:pro_cell.LBL_current_price.font
                    //                                  };
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
                    [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                           value:@2
                                           range:NSMakeRange([prec_price length]+4, [current_price length]-3)];
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    
                }
            }
            else
            {
                pro_cell.LBL_current_price.text = text;
            }
            if([prec_price isEqualToString:@"QR (null)"])
            {
                prec_price = 0;
            }
            else if([current_price isEqualToString:@"QR (null)"])
            {
                current_price =0;
            }
            
            int prev_pricee = [[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"product_price"] intValue];
            int current_pricee =  [[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"special_price"] intValue];
            
            int  n = prev_pricee-current_pricee;
            float discount = (n*100)/prev_pricee;
            
            NSString *str = @"% off";
            pro_cell.LBL_discount.text = [NSString stringWithFormat:@"%.0f%@",discount,str];
            [pro_cell.BTN_fav setTag:indexPath.row];//wishListStatus
            
            if ([[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"wishListStatus"] isEqualToString:@"Yes"]) {
                
                [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                [pro_cell.BTN_fav setTitleColor:[UIColor colorWithRed:244.f/255.f green:176.f/255.f blue:77.f/255.f alpha:1] forState:UIControlStateNormal];
            }
            else{
                [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                
                [pro_cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            [pro_cell.BTN_fav addTarget:self action:@selector(Wishlist_add:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
        }
        @catch(NSException *exception)
        {
            
        }
        //hotdeals_cell.LBL_discount.text = [temp_dict valueForKey:@"key4"];
        
        NSLog(@"The cell frame is :%@",NSStringFromCGRect(pro_cell.frame));
        NSLog(@"The hot_deals frame is :%@",NSStringFromCGRect(_collection_hot_deals.frame));
        
        return pro_cell;
    }
    //collection Best deals
    else if(collectionView == _collection_best_deals)
    {
        product_cell *pro_cell = (product_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_product" forIndexPath:indexPath];
        
        @try
        {
             NSString *url_Img_FULL =[NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"product_image"]];
            [pro_cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                                          options:SDWebImageRefreshCached];
            
            
            
            pro_cell.LBL_item_name.text = [[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"ProductDescriptions"] valueForKey:@"title"];
            
            pro_cell.LBL_rating.text = [NSString stringWithFormat:@"%@  ",[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"product_reviews"] valueForKey:@"rating"]];
            int rating = [[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"product_reviews"] valueForKey:@"rating"] intValue];
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
            

            pro_cell.LBL_current_price.text = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"special_price"]];
            
            NSString *current_price = [NSString stringWithFormat:@"QR %@", [[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"special_price"]];
            
            NSString *prec_price = [NSString stringWithFormat:@"QR %@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"product_price"]];
            NSString *text = [NSString stringWithFormat:@"%@ %@",current_price,prec_price];
            
            if ([pro_cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
                
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setAlignment:NSTextAlignmentCenter];
                
                if ([current_price isEqualToString:@"QR <null>"]) {
                    
                    
                    NSString *text = [NSString stringWithFormat:@" %@",prec_price];
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor],}range:[text rangeOfString:prec_price] ];
                    
                    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                    //NSParagraphStyleAttributeName
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    
                    
                    
                }
                
                else{
                    
                    // Define general attributes for the entire text
                    //        NSDictionary *attribs = @{
                    //                                  NSForegroundColorAttributeName:pro_cell.LBL_current_price.textColor,
                    //                                  NSFontAttributeName:pro_cell.LBL_current_price.font
                    //                                  };
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
                    [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                           value:@2
                                           range:NSMakeRange([prec_price length]+4, [current_price length]-3)];
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    
                }
            }
            else
            {
                pro_cell.LBL_current_price.text = text;
            }
            if([prec_price isEqualToString:@"QR (null)"])
            {
                prec_price = 0;
            }
            else if([current_price isEqualToString:@"QR (null)"])
            {
                current_price =0;
            }
            
            
            int prev_pricee = [[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"product_price"] intValue];
            int current_pricee =  [[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"special_price"] intValue];
            
            int  n = prev_pricee-current_pricee;
            float discount = (n*100)/prev_pricee;
            NSString *str = @"% off";
            pro_cell.LBL_discount.text = [NSString stringWithFormat:@"%.0f%@",discount,str];
            [pro_cell.BTN_fav setTag:indexPath.row];//wishListStatus
            
            if ([[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"wishListStatus"] isEqualToString:@"Yes"]) {
                
                [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                [pro_cell.BTN_fav setTitleColor:[UIColor colorWithRed:244.f/255.f green:176.f/255.f blue:77.f/255.f alpha:1] forState:UIControlStateNormal];
            }
            else{
                [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                
                [pro_cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            [pro_cell.BTN_fav addTarget:self action:@selector(Wishlist_add:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
        }
        @catch(NSException *exception)
        {
            
        }
        return pro_cell;
        
        
    }
    else if(collectionView == _collection_brands)
    {
        cell_brands *cell = (cell_brands *)[collectionView dequeueReusableCellWithReuseIdentifier:@"brands_cell" forIndexPath:indexPath];
        
        @try
        {
            NSString *img_URL = [NSString stringWithFormat:@"%@uploads/brands/%@",SERVER_URL,[[brands_arr objectAtIndex:indexPath.row]  valueForKey:@"logo"]];
            img_URL = [img_URL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            [cell.img sd_setImageWithURL:[NSURL URLWithString:img_URL]
                        placeholderImage:[UIImage imageNamed:@"brand.png"]
                                 options:SDWebImageRefreshCached];
            
            cell.contentView.layer.cornerRadius = 2.0f;
            cell.contentView.layer.masksToBounds = YES;
            cell.img.layer.cornerRadius = 2.0f;
            cell.img.layer.masksToBounds = YES;
            
        }
        @catch (NSException *exception) {
            NSLog(@"Exception from cell item indexpath %@",exception);
        }
        
        return cell;
        
        
        
    }
    //Collection Fashion categories
    else if(collectionView == _collection_fashion_categirie)
    {
        Fashion_categorie_cell *pro_cell = (Fashion_categorie_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"fashion_categorie" forIndexPath:indexPath];
        
        @try
        {
            NSString *url_Img_FULL =[NSString stringWithFormat:@"%@uploads/banners_ads/%@",SERVER_URL,[[[json_Response_Dic valueForKey:@"bannerFashion"] objectAtIndex:indexPath.row] valueForKey:@"banner"]];
            url_Img_FULL = [url_Img_FULL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

            [pro_cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                                          options:SDWebImageRefreshCached];
            
        }
        @catch(NSException *exception)
        {
            
        }
        
                   return pro_cell;
        
        
    }
    return 0;
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _collection_images)
    {
        
        return CGSizeMake(_collection_images.frame.size.width ,_collection_images.frame.size.height);
    }
    else if( collectionView == _collection_features)
    {
        return CGSizeMake(_collection_features.frame.size.width ,_collection_features.frame.size.height);
        
    }
    else if(collectionView == _collection_best_deals)
    {
        return CGSizeMake(_collection_best_deals.frame.size.width/2.011, 281);
        
    }
    else if(collectionView == _collection_hot_deals)
    {
        return CGSizeMake(self.collection_hot_deals.frame.size.width/2.011, 281);
        
    }
    else if( collectionView == _collection_brands)
    {
        return CGSizeMake(_collection_features.frame.size.width/3 ,_collection_features.frame.size.height);
        
    }
    else
    {
//        if( [[json_Response_Dic valueForKey:@"bannerFashion"]count] == 1 || [[json_Response_Dic valueForKey:@"bannerFashion"]count] == 3)
//        {
//            if(indexPath.row == 0)
//            {
//                return CGSizeMake(self.collection_fashion_categirie.bounds.size.width, 180);
//            }
//            else
////            {
//                return CGSizeMake(self.collection_fashion_categirie.bounds.size.width/2.011, 180);
//        //    }
//            
//            
//        }
//        else
//        {
            return CGSizeMake(self.collection_fashion_categirie.bounds.size.width/2.011, 180);
     //   }
    
    }
    
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    int ht = 0;
    if(collectionView == _collection_hot_deals)
    {
        ht = 0;
    }
    
    if(collectionView == _collection_best_deals)
    {
        ht = 0;
    }
    
    return ht;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    int ht = 0;
    if(collectionView == _collection_hot_deals)
    {
        ht = 2;
    }
    
    if(collectionView == _collection_best_deals)
    {
        ht = 2;
    }
    if(collectionView == _collection_fashion_categirie)
    {
        ht = 2;
    }
    return ht;
    
}

//- (UIEdgeInsets)collectionView:
//(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    // return UIEdgeInsetsMake(0,8,0,8);
//    // top, left, bottom, right
//    if(collectionView == _collection_best_deals)
//    {
//          return UIEdgeInsetsMake(0,0,0,0);
//    }
//   else if(collectionView == _collection_hot_deals)
//    {
//        return UIEdgeInsetsMake(0,0,0,0);
//    }
//    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
      if(collectionView == _collection_hot_deals)
    {
        NSString *merchant_id = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"merchant_id"]];
        [[NSUserDefaults standardUserDefaults] setValue:merchant_id forKey:@"Mercahnt_ID"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        [self.delegate collection_acttion:[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"url_key"]:[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0]objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"title"]];

    }
    else if (collectionView == _collection_best_deals)
    {
        NSString *merchant_id = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"merchant_id"]];
        [[NSUserDefaults standardUserDefaults] setValue:merchant_id forKey:@"Mercahnt_ID"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.delegate collection_acttion:[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row] valueForKey:@"url_key"]:[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0]objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"title"]];


        
    }
    else if(collectionView == _collection_brands)
    {
        
        [self.delegate brands_action:[[brands_arr objectAtIndex:indexPath.row] valueForKey:@"url_key"] :[[[[brands_arr objectAtIndex:indexPath.row] valueForKey:@"_matchingData"]valueForKey:@"BrandDescriptions"] valueForKey:@"name"]];
        
        
    }
    
     else if(collectionView == _collection_features)
    {
        
      
            NSString *hot_deals_url = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"bannerLarge"] objectAtIndex:indexPath.row] valueForKey:@"url"]];
            hot_deals_url = [hot_deals_url stringByReplacingOccurrencesOfString:@"catalog/" withString:@""];
            hot_deals_url = [hot_deals_url stringByReplacingOccurrencesOfString:@"discount/" withString:@""];
            NSString *url_key;
            if([hot_deals_url containsString:@"/"])
            {
                url_key = [NSString stringWithFormat:@"%@",hot_deals_url];
                
            }
            else
            {
                url_key =[NSString stringWithFormat:@"%@/0",hot_deals_url];
            }
        
       [self.delegate features_slection:url_key :[[[json_Response_Dic valueForKey:@"bannerLarge"] objectAtIndex:indexPath.row] valueForKey:@"title"]];

                      
            
        
        
        
    }
    else if(collectionView == _collection_images)
    {
        
        NSString *hot_deals_url = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"banners"] objectAtIndex:indexPath.row] valueForKey:@"url"]];
        hot_deals_url = [hot_deals_url stringByReplacingOccurrencesOfString:@"catalog/" withString:@""];
        hot_deals_url = [hot_deals_url stringByReplacingOccurrencesOfString:@"discount/" withString:@""];
        NSString *url_key;
        if([hot_deals_url containsString:@"/"])
        {
            url_key = [NSString stringWithFormat:@"%@",hot_deals_url];
            
        }
        else
        {
            url_key =[NSString stringWithFormat:@"%@/0",hot_deals_url];
        }
        
        [self.delegate features_slection:url_key :[[[json_Response_Dic valueForKey:@"bannerLarge"] objectAtIndex:indexPath.row] valueForKey:@"title"]];
        
        
    }
    else if(collectionView == _collection_fashion_categirie)
    {
        NSString *hot_deals_url = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"bannerFashion"] objectAtIndex:indexPath.row] valueForKey:@"url"]];
        hot_deals_url = [hot_deals_url stringByReplacingOccurrencesOfString:@"catalog/" withString:@""];
        hot_deals_url = [hot_deals_url stringByReplacingOccurrencesOfString:@"discount/" withString:@""];
        NSString *url_key;
        if([hot_deals_url containsString:@"/"])
        {
            url_key = [NSString stringWithFormat:@"%@",hot_deals_url];
            
        }
        else
        {
            url_key =[NSString stringWithFormat:@"%@/0",hot_deals_url];
        }
        
        [self.delegate features_slection:url_key :[[[json_Response_Dic valueForKey:@"bannerFashion"] objectAtIndex:indexPath.row] valueForKey:@"title"]];
        

    }
    
    
}

#pragma Tableview delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger ceel_count = 0;
    if(section == 0)
    {
        ceel_count = ARR_category.count;
    }
    if(section == 1)
    {
        ceel_count = 2;
    }
    if(section == 2)
    {
        ceel_count = 2;
    }
    if(section == 3)
    {
        ceel_count = lang_arr.count;
    }
    if(section == 4)
    {
        ceel_count = 5;
    }
    
    return ceel_count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    categorie_cell *cell = (categorie_cell *)[tableView dequeueReusableCellWithIdentifier:@"cate_cell"];
    
    
    if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"categorie_cell" owner:self options:nil];
        cell = [nib objectAtIndex:1];
    }
    cell.LBL_arrow.hidden = YES;
    
    if(indexPath.section == 0)
    {
        //        cell.LBL_name.text = [ARR_category objectAtIndex:indexPath.row];
        //        if([cell.LBL_name.text isEqualToString:@"MORE"])
        //        {
        //            cell.LBL_arrow.hidden = NO;
        //            tag = 0;
        //            if(i < ARR_category.count)
        //            {
        //                cell.LBL_arrow.text = @"";
        //                tag = 1;
        //            }
        //
        //        }
        NSString *Title= [[ARR_category objectAtIndex:indexPath.row] valueForKey:@"Name"];
        
        return [self createCellWithTitle:Title image:[[ARR_category objectAtIndex:indexPath.row] valueForKey:@"Image name"] indexPath:indexPath];
        
        
    }
    if(indexPath.section == 1)
    {
        NSArray *ARR_info = [NSArray arrayWithObjects:@"MY PROFILE",@"CHANGE PASSWORD", nil];
        cell.LBL_name.text = [ARR_info objectAtIndex:indexPath.row];
    }
    if(indexPath.section == 2)
    {
        NSArray *mer_arr = [NSArray arrayWithObjects:@"PRODUCT LIST",@"MERCHANT LIST", nil];
        cell.LBL_name.text = [mer_arr objectAtIndex:indexPath.row];
    }
    if(indexPath.section == 3)
    {
        cell.LBL_name.text = [lang_arr objectAtIndex:indexPath.row];
        
        if(indexPath.row == 0)
        {
            cell.LBL_arrow.hidden = NO;
            tag = 0;
            if(lang_count < lang_arr.count)
            {
                cell.LBL_arrow.text = @"";
                tag = 1;
            }
        }
        
    }
    if(indexPath.section == 4)
    {
        
        NSArray *ARR_info = [NSArray arrayWithObjects:@"ABOUT US",@"CONTACT US",@"TERMS AND CONDITIONS",@"PRIVACY POLACY",@"HELP DESK", nil];
        cell.LBL_name.text = [ARR_info objectAtIndex:indexPath.row];
    }
    
    
    
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str;
    if(section == 0)
    {
        str =@"ALL CATEGORIES";
    }
    if(section == 1)
    {
        str = @"ACCOUNT INFO";
    }
    if(section == 2)
    {
        str = @"MERCHANT LIST";
    }
    if(section == 3)
    {
        str = @"LANGUAGE";
    }
    if(section == 4)
    {
        str = @"QUICK LINKS";
    }
    
    return  str;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
////    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
////    [header setBackgroundColor:[UIColor whiteColor]];
////    UILabel  *LBL_title = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 320, 40)];
////    LBL_title.font = [UIFont fontWithName:@"Poppins-Medium" size:17];
////    LBL_title.textColor = [UIColor darkGrayColor];
//    NSString *str;
//    if(section == 0)
//    {
//        str =@"ALL CATEGORIES";
//    }
//    if(section == 1)
//    {
//        str = @"ACCOUNT INFO";
//    }
//    if(section == 2)
//    {
//        str = @"MERCHANT LIST";
//    }
//    if(section == 3)
//    {
//        str = @"LANGUAGE";
//    }
//    if(section == 4)
//    {
//        str = @"QUICK LINKS";
//    }
//
//   str;
//   // [header addSubview:LBL_title];
//    return header;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch (indexPath.section)
    {
        case 0:
            if(indexPath.row)
            {
                NSMutableDictionary *dic=[ARR_category objectAtIndex:indexPath.row];
                
                NSLog(@"Selected dict = %@",dic);
                
                if([dic valueForKey:@"SubItems"])
                {
                    NSArray *arr=[dic valueForKey:@"SubItems"];
                    BOOL isTableExpanded=NO;
                    
                    for(NSDictionary *subitems in arr )
                    {
                        NSInteger index=[ARR_category indexOfObjectIdenticalTo:subitems];
                        isTableExpanded=(index>0 && index!=NSIntegerMax);
                        if(isTableExpanded) break;
                    }
                    
                    if(isTableExpanded)
                    {
                        [self CollapseRows:arr];
                    }
                    else
                    {
                        NSUInteger count=indexPath.row+1;
                        NSMutableArray *arrCells=[NSMutableArray array];
                        for(NSDictionary *dInner in arr )
                        {
                            [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                            [ARR_category insertObject:dInner atIndex:count++];
                            
                            NSLog(@"Inserted dictin %@",dInner);
                        }
                        [self.TBL_menu insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationLeft];
                    }
                }
            }
            
            //            if(indexPath.row == i - 1)
            //            {
            //
            //                NSMutableArray *s = [NSMutableArray arrayWithObjects:@"hsdf",@"dfghhy",@"hsdf",@"dfghhy",nil];
            //                if(tag == 0)
            //                {
            //
            //                    [ARR_category addObjectsFromArray:s];
            //
            //                    int sectionIndex = 0;
            //                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:sectionIndex];
            //                    [self tableView:_TBL_menu commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:iPath];
            //                    [_TBL_menu reloadData];
            //                }
            //                else if(tag == 1)
            //                {
            //
            //                    NSMutableArray *cellIndicesToBeDeleted = [[NSMutableArray alloc] init];
            //                    long minVAL = indexPath.row;
            //                    long maxVal = indexPath.row + [s count];
            //
            //                    [ARR_category removeObjectsInRange:NSMakeRange(minVAL+1, s.count)];
            //                    for (long j =  minVAL; j < maxVal; j++) {
            //                        NSIndexPath *p = [NSIndexPath indexPathForRow:j inSection:indexPath.section];
            //                        if ([tableView cellForRowAtIndexPath:p])
            //                        {
            //                            [cellIndicesToBeDeleted addObject:p];
            //
            //                        }
            //                    }
            //                    [_TBL_menu reloadData];
            //
            //                }
            
            
            
            break;
        case 1:
            [self swipe_left];
            if(indexPath.row == 1)
            {
                [self performSegueWithIdentifier:@"login_forgot_pwd" sender:self];
            }
            break;
        case 2:
            [self swipe_left];
            if(indexPath.row == 0)
            {
                NSUserDefaults *userDflts = [NSUserDefaults standardUserDefaults];
                
                [userDflts setObject:[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:0]valueForKey:@"url_key"] forKey:@"url_key_home"];
                NSLog(@"%@",[userDflts valueForKey:@"url_key_hotDeals"]);
                [self performSegueWithIdentifier:@"homw_product_list" sender:self];
                
                
            }
            else
                [self performSegueWithIdentifier:@"merchant_segue" sender:self];
            break;
        case 3:
            if(indexPath.section == 3)
            {
                NSMutableArray *s = [NSMutableArray arrayWithObjects:@"HINDI",@"ARABIC",@"TELUGU",@"MALAYALA",nil];
                if(tag == 0)
                {
                    
                    [lang_arr addObjectsFromArray:s];
                    
                    int sectionIndex = 0;
                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:sectionIndex];
                    [self tableView:_TBL_menu commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:iPath];
                    [_TBL_menu reloadData];
                }
                else if(tag == 1)
                {
                    
                    NSMutableArray *cellIndicesToBeDeleted = [[NSMutableArray alloc] init];
                    long minVAL = indexPath.row;
                    long maxVal = indexPath.row + [s count];
                    
                    [lang_arr removeObjectsInRange:NSMakeRange(minVAL+1, s.count)];
                    for (long j =  minVAL; j < maxVal; j++) {
                        NSIndexPath *p = [NSIndexPath indexPathForRow:j inSection:indexPath.section];
                        if ([tableView cellForRowAtIndexPath:p])
                        {
                            [cellIndicesToBeDeleted addObject:p];
                            
                        }
                    }
                    [_TBL_menu reloadData];
                    
                }
                
                
                
            }
            break;
            
        case 4:
            [self swipe_left];
            if(indexPath.row == 0)
            {
                NSLog(@"selected");
            }
            if(indexPath.row == 1)
            {
                [self performSegueWithIdentifier:@"contact_us_segue" sender:self];
            }
            if(indexPath.row == 2)
            {
                NSLog(@"selected");
            }
            if(indexPath.row == 3)
            {
                NSLog(@"selected");
            }
            if(indexPath.row == 4)
            {
                NSLog(@"selected");
            }
            break;
        default:
            break;
    }
    
    
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing == NO || !indexPath)
        return UITableViewCellEditingStyleNone;
    
    if (self.editing && indexPath.row == ([ARR_category count]))
        return UITableViewCellEditingStyleInsert;
    else
        if (self.editing && indexPath.row == ([ARR_category count]))
            return UITableViewCellEditingStyleDelete;
    
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
    }
    else if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    @try {
        
        
        NSString *cellIdentifier;
        for (UICollectionViewCell *cell in [scrollView subviews])
        {
            cellIdentifier = [cell reuseIdentifier];
        }
        if ([cellIdentifier isEqualToString:@"collection_image"]) {
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
        else if([cellIdentifier isEqualToString:@"features_cell"])
        {
            float pageWidth = _collection_features.frame.size.width; // width + space
            
            float currentOffset = _collection_features.contentOffset.x;
            float targetOffset = targetContentOffset->x;
            float newTargetOffset = 1;
            
            if (targetOffset > currentOffset)
                newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
            else
                newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
            
            if (newTargetOffset < 0)
                newTargetOffset = 0;
            else if (newTargetOffset > _collection_features.contentSize.width)
                newTargetOffset = _collection_features.contentSize.width;
            
            targetContentOffset->x = currentOffset;
            [_collection_features setContentOffset:CGPointMake(newTargetOffset  , _collection_features.contentOffset.y) animated:YES];
            
            CGPoint visiblePoint = CGPointMake(newTargetOffset, _collection_features.contentOffset.y);
            NSIndexPath *visibleIndexPath = [_collection_features indexPathForItemAtPoint:visiblePoint];
            
            INDX_selected = visibleIndexPath;
            //self.custom_story_page_controller.currentPage = visibleIndexPath.row;
            
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception:%@",exception);
        
    }
}
#pragma Buton action

- (IBAction)cart_action:(id)sender
{
    [self performSegueWithIdentifier:@"home_to_cart" sender:self];
}
- (IBAction)wish_list_Action:(id)sender
{
    [self performSegueWithIdentifier:@"wishlist_segue" sender:self];
    
}

-(void)BTN_right_action
{
    @try
    {
        NSIndexPath *newIndexPath;
        if (!INDX_selected)
        {
            newIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            INDX_selected = newIndexPath;
        }
        else if ([[json_Response_Dic valueForKey:@"bannerLarge"] count]  > INDX_selected.row)
        {
            if ([[json_Response_Dic valueForKey:@"bannerLarge"] count] == INDX_selected.row + 1) {
                newIndexPath = [NSIndexPath indexPathForRow:[[json_Response_Dic valueForKey:@"bannerLarge"] count] - 1 inSection:0];
                INDX_selected = newIndexPath;
            }
            else
            {
                newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row + 1 inSection:0];
                INDX_selected = newIndexPath;
            }
        }
        
        
        if (!newIndexPath) {
            newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            INDX_selected = newIndexPath;
        }
        
        @try {
            [_collection_features scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:INDX_selected.row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            
        } @catch (NSException *exception) {
            int max_val = (int)[[json_Response_Dic valueForKey:@"bannerLarge"] count];
            [_collection_features scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:max_val -1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            NSLog(@"Exception from collection cell %@",exception);
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception:%@",exception);
    }
}
-(void)BTN_left_action
{
    /*    @try
     {
     NSIndexPath *newIndexPath;
     if (INDX_selected)
     {
     newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row -1 inSection:0];
     INDX_selected = newIndexPath;
     }
     
     else if ([[json_Response_Dic valueForKey:@"bannerLarge"] count]  < INDX_selected.row)
     {
     if ([[json_Response_Dic valueForKey:@"bannerLarge"] count] == INDX_selected.row - 1)
     {
     newIndexPath = [NSIndexPath indexPathForRow:[[json_Response_Dic valueForKey:@"bannerLarge"] count] + 1 inSection:0];
     INDX_selected = newIndexPath;
     }
     else
     {
     newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row - 1 inSection:0];
     INDX_selected = newIndexPath;
     }
     }
     if (newIndexPath)
     {
     newIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
     INDX_selected = newIndexPath;
     }
     
     [_collection_features scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
     }
     @catch (NSException *exception)
     {
     NSLog(@"exception:%@",exception);
     }
     */
    @try
    {
        NSIndexPath *newIndexPath;
        if (!INDX_selected)
        {
            newIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            INDX_selected = newIndexPath;
        }
        else if ([[json_Response_Dic valueForKey:@"bannerLarge"] count]  > INDX_selected.row)
        {
            if ([[json_Response_Dic valueForKey:@"bannerLarge"] count] == INDX_selected.row - 1) {
                newIndexPath = [NSIndexPath indexPathForRow:[[json_Response_Dic valueForKey:@"bannerLarge"] count] + 1 inSection:0];
                INDX_selected = newIndexPath;
            }
            else
            {
                newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row - 1 inSection:0];
                INDX_selected = newIndexPath;
            }
        }
        
        
        if (!newIndexPath) {
            newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            INDX_selected = newIndexPath;
        }
        
        //        int max_val = (int)[[json_Response_Dic valueForKey:@"bannerLarge"] count];
        if (INDX_selected.row <= 0) {
            newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            INDX_selected = newIndexPath;
        }
        
        @try {
            [_collection_features scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:INDX_selected.row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            
        } @catch (NSException *exception) {
            int max_val = (int)[[json_Response_Dic valueForKey:@"bannerLarge"] count];
            [_collection_features scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:max_val -1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            NSLog(@"Exception from collection cell %@",exception);
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception:%@",exception);
    }
}
-(void)CollapseRows:(NSArray*)ar
{
    for(NSDictionary *dInner in ar )
    {
        NSUInteger indexToRemove=[ARR_category indexOfObjectIdenticalTo:dInner];
        NSArray *arInner=[dInner valueForKey:@"SubItems"];
        if(arInner && [arInner count]>0)
        {
            [self CollapseRows:arInner];
        }
        
        if([ARR_category indexOfObjectIdenticalTo:dInner]!=NSNotFound)
        {
            [ARR_category removeObjectIdenticalTo:dInner];
            [self.TBL_menu deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                   [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                   ]
                                 withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

- (UITableViewCell*)createCellWithTitle:(NSString *)title image:(UIImage *)image  indexPath:(NSIndexPath*)indexPath
{
    NSString *CellIdentifier = @"Cell";
    dynamic_categirie_cell* cell = [self.TBL_menu dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"categorie_cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = bgView;
    cell.LBL_name.text = title;
    cell.LBL_name.textColor = [UIColor blackColor];
    
    [cell setIndentationLevel:[[[ARR_category objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
    cell.indentationWidth = 25;
    
    float indentPoints = cell.indentationLevel * cell.indentationWidth;
    
    cell.contentView.frame = CGRectMake(indentPoints,cell.contentView.frame.origin.y,cell.contentView.frame.size.width - indentPoints,cell.contentView.frame.size.height);
    
    NSDictionary *d1=[ARR_category objectAtIndex:indexPath.row] ;
    
    if([d1 valueForKey:@"SubItems"])
    {
        cell.btnExpand.alpha = 1.0;
        [cell.btnExpand addTarget:self action:@selector(showSubItems:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        cell.btnExpand.alpha = 0.0;
    }
    return cell;
}

-(void)showSubItems :(id) sender
{
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.TBL_menu];
    NSIndexPath *indexPath = [self.TBL_menu  indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    
    if ([btn.titleLabel.text  isEqualToString:@""])
    {
        //  btn.titleLabel.text = @"";
        [btn setTitle:@"" forState:UIControlStateNormal];
    }
    else
    {
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn.titleLabel setText:@""];
    }
    
    
    
    NSDictionary *d=[ARR_category objectAtIndex:indexPath.row] ;
    NSArray *arr=[d valueForKey:@"SubItems"];
    if([d valueForKey:@"SubItems"])
    {
        BOOL isTableExpanded=NO;
        for(NSDictionary *subitems in arr )
        {
            NSInteger index=[ARR_category indexOfObjectIdenticalTo:subitems];
            isTableExpanded=(index>0 && index!=NSIntegerMax);
            if(isTableExpanded) break;
        }
        
        if(isTableExpanded)
        {
            [self CollapseRows:arr];
        }
        else
        {
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arrCells=[NSMutableArray array];
            for(NSDictionary *dInner in arr )
            {
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [ARR_category insertObject:dInner atIndex:count++];
            }
            [self.TBL_menu insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
    
    
}


-(void)MENU_action
{
    
    _overlayView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:-5];
    
    CGFloat new_X = 0;
    if (_VW_swipe.frame.origin.x == self.view.frame.origin.x)
    {
        new_X = _VW_swipe.frame.origin.x;
    }
    else
    {
        new_X = _VW_swipe.frame.origin.x - _menuDraw_width;
        
    }
    _VW_swipe.frame = CGRectMake(0, self.navigationController.view.frame.origin.y, _menuDraw_width, self.navigationController.view.frame.size.height);
    [UIView commitAnimations];
}
- (void) SwipeLeft:(UISwipeGestureRecognizer *)sender
{
    
    [self swipe_left];
    
}
-(void)swipe_left
{
    
    if ( UISwipeGestureRecognizerDirectionLeft )
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:-5];
        
        int statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
        statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
        _VW_swipe.frame = CGRectMake(0, self.navigationController.view.frame.origin.y, _menuDraw_width, self.navigationController.view.frame.size.height);
        [UIView commitAnimations];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:-5];
        _overlayView.hidden = YES;
        [UIView commitAnimations];
        
    }
    
}
-(void)SwipeRight:(UISwipeGestureRecognizer *)sender
{
    if ( sender.direction | UISwipeGestureRecognizerDirectionRight )
    {
        _overlayView.hidden = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:-5];
        
        CGFloat new_X = 0;
        if (_VW_swipe.frame.origin.x == self.view.frame.origin.x)
        {
            new_X = _VW_swipe.frame.origin.x;
        }
        else
        {
            new_X = _VW_swipe.frame.origin.x - _menuDraw_width;
            
        }
        _VW_swipe.frame = CGRectMake(0, self.navigationController.view.frame.origin.y, _menuDraw_width, self.navigationController.view.frame.size.height);
        [UIView commitAnimations];
        
    }
    
}
-(void)brands_API_call
{
    
    @try
    {
        NSError *error;
        
        NSHTTPURLResponse *response = nil;
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        NSString *urlGetuser;
        if(_BTN_fashion.tag == 0)
        {
            urlGetuser =[NSString stringWithFormat:@"%@brands/getFashionBrands/male/%@/%@.json",SERVER_URL,country,languge];
        }
        else
        {
            urlGetuser =[NSString stringWithFormat:@"%@brands/getFashionBrands/female/%@/%@.json",SERVER_URL,country,languge];
            
            
        }
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(aData)
        {
            // [activityIndicatorView stopAnimating];
            // VW_overlay.hidden = YES;
            VW_overlay.hidden = YES;
            [activityIndicatorView stopAnimating];
            brands_arr= (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            [self.collection_brands reloadData];
            [[NSUserDefaults standardUserDefaults] setObject:brands_arr forKey:@"brands_LIST"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"The response Api form Brands%@",brands_arr);
            
            
        }
        else
        {
            VW_overlay.hidden=YES;
            [activityIndicatorView stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
    }
    
    
}


#pragma ShopHome_api_integration Method Calling

-(void)API_call_total
{
    
    @try
    {
        //Pages/home/" + country_val+ "/" + language_val + "/.json
        
        /**********   After passing Language Id and Country ID ************/
        NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [user_defaults valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];

        NSString *urlGetuser =[NSString stringWithFormat:@"%@Pages/home/%ld/%ld/%@/Customer.json",SERVER_URL,(long)[user_defaults   integerForKey:@"country_id"],[user_defaults integerForKey:@"language_id"],user_id];
        NSLog(@"%ld,%ld",[user_defaults integerForKey:@"country_id"],[user_defaults integerForKey:@"language_id"]);
        
        //NSString *urlGetuser =[NSString stringWithFormat:@"%@Pages/home/1/1/.json",SERVER_URL];
        
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    
                    
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                if (data) {
                    
                    json_Response_Dic = data;
                    // NSLog(@"the api_collection_product%@",json_Response_Dic);
                    @try {
                        if(json_Response_Dic )
                        [self brands_API_call];
                        VW_overlay.hidden = YES;
                        [activityIndicatorView stopAnimating];
                        [_collection_images reloadData];
                        [_collection_features reloadData];
                        [_collection_hot_deals reloadData];
                        [_collection_best_deals reloadData];
                        [_collection_fashion_categirie reloadData];

                         [self set_up_VIEW];
                    } @catch (NSException *exception) {
                        NSLog(@"%@",exception);
                    }
                    NSLog(@"the api_collection_product%@",json_Response_Dic);
                    
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
#pragma mark Add_to_wishList_API Calling
-(void)Wishlist_add:(UIButton *)sender
{
    
    @try
    {
        
        //        NSUserDefaults *user_dflts = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        NSString *urlGetuser;
        if(_collection_best_deals)
        {
            urlGetuser =[NSString stringWithFormat:@"%@apis/addToWishList/%@/%@.json",SERVER_URL,[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:sender.tag]valueForKey:@"id"],user_id];
            
        }
        else if(_collection_hot_deals)
        {
            urlGetuser =[NSString stringWithFormat:@"%@apis/addToWishList/%@/%@.json",SERVER_URL,[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:sender.tag]valueForKey:@"id"],user_id];
        }
        else if(_collection_fashion_categirie)
        {
            urlGetuser =[NSString stringWithFormat:@"%@apis/addToWishList/%@/%@.json",SERVER_URL,[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-2"] objectAtIndex:0] objectAtIndex:sender.tag]valueForKey:@"id"],user_id];
            
        }
        
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    
                    VW_overlay.hidden=YES;
                    [activityIndicatorView stopAnimating];
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                if (data) {
                    json_Response_Dic = data;
                    if(json_Response_Dic)
                    {
                        VW_overlay.hidden=YES;
                        [activityIndicatorView stopAnimating];
                        NSLog(@"The Wishlist %@",json_Response_Dic);
                        
                        NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];
                        product_cell *cell;
                        if(_collection_hot_deals)
                        {
                            cell = (product_cell *)[self.collection_hot_deals cellForItemAtIndexPath:index];
                        }
                        else  if(_collection_fashion_categirie)
                        {
                            cell = (product_cell *)[self.collection_fashion_categirie cellForItemAtIndexPath:index];
                        }
                        else  if(_collection_best_deals)
                        {
                            cell = (product_cell *)[self.collection_best_deals cellForItemAtIndexPath:index];
                        }
                        
                        
                        
                        
                        @try {
                            if ([[json_Response_Dic valueForKey:@"msg"] isEqualToString:@"add"]) {
                                
                                //  [self startAnimation:sender];
                                [cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                                
                                [cell.BTN_fav setTitleColor:[UIColor colorWithRed:244.f/255.f green:176.f/255.f blue:77.f/255.f alpha:1] forState:UIControlStateNormal];
                                [HttpClient createaAlertWithMsg:@"Item added successfully" andTitle:@""];
                                
                                
                            }
                            else{
                                
                                [cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            }
                            
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                            [cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        }
                        
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"already added" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
        NSLog(@"The error is:%@",exception);
        [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
    }
    
    VW_overlay.hidden=YES;
    [activityIndicatorView stopAnimating];
    
    
}
-(void)hot_deals_action
{
    
    [ self.delegate images_action:[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0]objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"title"] :[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0]objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"title"]];
    
}
-(void)best_deals_action
{
      [ self.delegate images_action:[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0]objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"title"] :[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0]objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"title"]];
}
-(void)BTN_fashhion_cahnge
{
    if(_BTN_fashion.tag == 1)
    {
        _IMG_Person_banner.image = [UIImage imageNamed:@"men"];
        _IMG_Things_banner.image = [UIImage imageNamed:@"shoes_prod"];
        [_BTN_fashion setBackgroundImage:[UIImage imageNamed:@"men_icon"] forState:UIControlStateNormal];
        [_BTN_fashion setTag:0];
        [self brands_API_call];
         _Hot_deals.text = @"MEN'S FASHION ACCESORIES";
        [_collection_brands reloadData];
        
    }
    else
    {
        _IMG_Person_banner.image = [UIImage imageNamed:@"upload-4"];
        _IMG_Things_banner.image = [UIImage imageNamed:@"bag"];
        [_BTN_fashion setBackgroundImage:[UIImage imageNamed:@"women_logo"] forState:UIControlStateNormal];
        [_BTN_fashion setTag:1];
        [self brands_API_call];
         _Hot_deals.text = @"WOMEN'S FASHION ACCESORIES";
        [_collection_brands reloadData];
        
    }
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
