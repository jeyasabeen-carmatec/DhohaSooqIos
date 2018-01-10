 //
//  Home_page_Qtickets.m
//  Dohasooq_mobile
//
//  Created by Test User on 17/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "Home_page_Qtickets.h"
#import "collection_img_cell.h"
#import "hot_deals_cell.h"
#import "Best_deals_cell.h"
#import "Fashion_categorie_cell.h"
#import "UIBarButtonItem+Badge.h"
#import "cell_features.h"
#import "cell_brands.h"
#import "categorie_cell.h"
#import "dynamic_categirie_cell.h"
#import "menu_cell.h"
#import "events_cell.h"
#import "UIImageView+WebCache.h"
#import "XMLDictionary/XMLDictionary.h"
#import "HMSegmentedControl.h"
#import "Movies_cell.h"
#import "qtickets_cell.h"
#import "events_cell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HttpClient.h"
#import "upcoming_cell.h"
#import "product_cell.h"
#import "VC_intial.h"
#import "collection_MENU.h"
#import "ViewController.h"
#import "language_cellTableViewCell.h"


@interface Home_page_Qtickets ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *temp_arr,*temp_hot_deals,*fashion_categirie_arr,*brands_arr,*ARR_category,*lang_arr,*image_Top_ARR,*deals_ARR,*hot_deals_ARR;
    NSIndexPath *INDX_selected;
    NSInteger j,lang_count;
    int tag,collection_tag;
    
//    UIView *VW_overlay;
//
//    UIActivityIndicatorView *activityIndicatorView;
    
    NSMutableDictionary *json_Response_Dic;
    float scroll_ht;
    NSMutableArray *Movies_arr,*Events_arr,*Sports_arr,*Leisure_arr;
    NSArray *langugage_arr,*halls_arr,*venues_arr,*sports_venues,*leisure_venues,*menu_arr;
    NSString *halls_text,*leng_text;
    int statusbar_HEIGHT;
    NSDictionary *temp_dicts;
    NSString *language;
    int mn;

}
@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;


@property(nonatomic,strong) UIView *overlayView;

@end

@implementation Home_page_Qtickets

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
      _Scroll_contents.delegate =self;
    
    [self.collection_images registerNib:[UINib nibWithNibName:@"cell_image" bundle:nil]  forCellWithReuseIdentifier:@"collection_image"];
    [self.collection_features registerNib:[UINib nibWithNibName:@"cell_features" bundle:nil]  forCellWithReuseIdentifier:@"features_cell"];
    [self.collection_showing_movies registerNib:[UINib nibWithNibName:@"cell_features" bundle:nil]  forCellWithReuseIdentifier:@"showing_movies_cell"];
     [self.collection_hot_deals registerNib:[UINib nibWithNibName:@"product_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_product"];
     [self.collection_best_deals registerNib:[UINib nibWithNibName:@"product_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_product"];
    [self.collection_fashion_categirie registerNib:[UINib nibWithNibName:@"Fashion_categorie_cell" bundle:nil]  forCellWithReuseIdentifier:@"fashion_categorie"];

    
     [self.Collection_movies registerNib:[UINib nibWithNibName:@"Movies_cell" bundle:nil]  forCellWithReuseIdentifier:@"movie_cell"];
    
    [self.Collection_movies registerNib:[UINib nibWithNibName:@"Image_qtickets" bundle:nil]  forCellWithReuseIdentifier:@"Image_qtickets"];
    [self.Collection_movies registerNib:[UINib nibWithNibName:@"upcoming_cell" bundle:nil]  forCellWithReuseIdentifier:@"upcoming_cell"];
   
    
    tag =0;
    
    leng_text = @"LANGUAGES";
    halls_text =@"THEATERS";
  //  _Hot_deals.text = @"WOMEN'S FASHION ACCESORIES";
    
     collection_tag = 0;
    _collection_hot_deals.tag = 1;
    _collection_fashion_categirie.tag = 2;
    _collection_best_deals.tag = 3;
    _BTN_leisure_venues.text = _BTN_venues.text;
    _BTN_sports_venues.text = _BTN_venues.text;
     brands_arr = [[NSMutableArray alloc]init];
    _TXT_search.delegate =self;
    
    
    _TXT_search.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _TXT_search.layer.borderWidth = 0.2f;
    
    
    _hot_deals_more.layer.cornerRadius = 2.0f;
    _hot_deals_more.layer.masksToBounds = YES;
    
    _best_deals_more.layer.cornerRadius = 2.0f;
    _best_deals_more.layer.masksToBounds = YES;
    
    [_BTN_TOP addTarget:self action:@selector(TOP_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_search addTarget:self action:@selector(seacrh_ACTION) forControlEvents:UIControlEventTouchUpInside];
    [_logo addTarget:self action:@selector(logo_api_call) forControlEvents:UIControlEventTouchUpInside];
    [self view_appear];


    
}

-(void)view_appear
{
    CGRect frameset = _VW_nav.frame;
    frameset.size.width = self.navigationController.navigationBar.frame.size.width ;
    _VW_nav.frame = frameset;
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    
//    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    VW_overlay.clipsToBounds = YES;
//    //    VW_overlay.layer.cornerRadius = 10.0;
//    
//    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
//    activityIndicatorView.center = VW_overlay.center;
//    [VW_overlay addSubview:activityIndicatorView];
//    VW_overlay.center = self.view.center;
//    [self.navigationController.view addSubview:VW_overlay];
//    VW_overlay.hidden = YES;
    
    if(json_Response_Dic)
    {
        [self set_up_VIEW];
        [self menu_set_UP];
    }
    else
    {
   
   
    [self performSelector:@selector(API_call_total) withObject:nil afterDelay:0.01];
    [self set_up_VIEW];
    }

}
-(void)logo_api_call
{
//    VW_overlay.hidden = NO;
//    [activityIndicatorView startAnimating];
    
    [self performSelector:@selector(API_call_total) withObject:nil afterDelay:0.01];
    [self set_up_VIEW];
}

-(void)tab_BAR_set_UP
{
    
    CGRect frame_set = _Scroll_contents.frame;
    frame_set.origin.y = _Tab_MENU.frame.origin.y + _Tab_MENU.frame.size.height + 20;
    _Scroll_contents.frame = frame_set;
    
    _Tab_MENU.delegate = self;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0f],NSForegroundColorAttributeName:[UIColor whiteColor]
                                                        } forState:UIControlStateNormal];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self set_up_VIEW];
    [self menu_set_UP];
    [self cart_count];
    self.navigationItem.hidesBackButton = YES;
    
}


-(void)menu_set_UP
{
    // [self.TBL_menu reloadData];
    
    NSDictionary *user_data = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *str,*full_name;
    @try
    {
        str = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"firstname"]];
        full_name = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"firstname"]];
        if([str isEqualToString:@"(null)"])
            
        {
            str = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"fname"]];
            full_name = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"fname"]];
        }
    }
    @catch(NSException *exception)
    {
        str = @"Guest User";
        
    }
    
    if([str isEqualToString:@"(null)"])
    {
        _LBL_profile.text = @"Guest User";
    }
    else
    {
        _LBL_profile.text = [NSString stringWithFormat:@"%@",full_name];
    }
    
    
    statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
    statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
    _menuDraw_width = [UIApplication sharedApplication].statusBarFrame.size.width * 0.80;
    _menyDraw_X = self.navigationController.view.frame.size.width; //- menuDraw_width;
    
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        //self.view.frame.size.width-_VW_swipe.frame.size.width
        _VW_swipe.frame = CGRectMake(self.view.frame.size.width-_VW_swipe.frame.size.width, self.view.frame.origin.y+statusbar_HEIGHT, _menuDraw_width, self.navigationController.view.frame.size.height - self.navigationController.navigationBar.frame.size.height-statusbar_HEIGHT);
    }
    else{
        
        _VW_swipe.frame = CGRectMake(0, self.view.frame.origin.y+statusbar_HEIGHT, _menuDraw_width, self.navigationController.view.frame.size.height - self.navigationController.navigationBar.frame.size.height-statusbar_HEIGHT);
    }
    
    
    _overlayView = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
    _overlayView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [self.navigationController.view addSubview:_overlayView];
    [_overlayView addSubview:_VW_swipe];
    
    NSString *url_Img_FULL = [NSString stringWithFormat:@"%@%@",SERVER_URL,[user_data valueForKey:@"profile_pic"]];
    url_Img_FULL  =[url_Img_FULL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [_IMG_profile sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                    placeholderImage:[UIImage imageNamed:@"upload-27.png"]
                             options:SDWebImageRefreshCached];
    
    
    _IMG_profile.layer.cornerRadius = _IMG_profile.frame.size.width / 2;
    _IMG_profile.layer.masksToBounds = YES;
  
    
  //  [_LBL_profile sizeToFit];
    
    CGRect frameset;
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        
        frameset = _BTN_address.frame;
        frameset.size.width = (_VW_swipe.frame.size.width/3) - 2;
        _BTN_address.frame = frameset;
        
        frameset = _BTN_wishlist.frame;
        frameset.origin.x = _BTN_address.frame.origin.x + _BTN_address.frame.size.width + 1;
        frameset.size.width = (_VW_swipe.frame.size.width/3);
        _BTN_wishlist.frame = frameset;
        
        frameset = _BTN_myorder.frame;
        frameset.origin.x = _BTN_wishlist.frame.origin.x + _BTN_wishlist.frame.size.width + 1;
        frameset.size.width = (_VW_swipe.frame.size.width/3) - 1;
        _BTN_myorder.frame = frameset;
    }
    
    else{
        
        frameset = _BTN_myorder.frame;
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
    }
    
    frameset=_LBL_order_icon.frame;
    frameset.origin.x = _BTN_myorder.frame.origin.x;
    frameset.origin.y = _BTN_myorder.frame.origin.y + _LBL_order_icon.frame.size.height;
    frameset.size.width = _BTN_myorder.frame.size.width;
    _LBL_order_icon.frame = frameset;
    
    frameset = _LBL_order.frame;
    frameset.origin.x = _BTN_myorder.frame.origin.x;
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
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if(result.height <= 480)
    {
        [_LBL_order setFont:[UIFont fontWithName:@"Poppins-Medium" size:10]];
        [_LBL_wish_list setFont:[UIFont fontWithName:@"Poppins-Medium" size:10]];
        [_LBL_address setFont:[UIFont fontWithName:@"Poppins-Medium" size:10]];
    }
    else if(result.height <= 568)
    {
        [_LBL_order setFont:[UIFont fontWithName:@"Poppins-Medium" size:10]];
        [_LBL_wish_list setFont:[UIFont fontWithName:@"Poppins-Medium" size:10]];
        [_LBL_address setFont:[UIFont fontWithName:@"Poppins-Medium" size:10]];
        
        [_LBL_profile setFont:[UIFont fontWithName:@"Poppins-Medium" size:13]];
        

    }
    else
    {
                [_LBL_order setFont:[UIFont fontWithName:@"Poppins-Medium" size:13]];
        [_LBL_wish_list setFont:[UIFont fontWithName:@"Poppins-Medium" size:13]];
        [_LBL_address setFont:[UIFont fontWithName:@"Poppins-Medium" size:13]];
        
    }
    
    
    
    _VW_swipe.layer.cornerRadius = 2.0f;
    _VW_swipe.layer.masksToBounds = YES;
    
    
    _overlayView.hidden = YES;
    ARR_category = [[NSMutableArray alloc]init];
    
    
    @try {
        NSMutableArray *sortedArray = [[NSMutableArray alloc]init];
        sortedArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"pho"] mutableCopy];
        NSMutableArray *arr = [NSMutableArray array];
        
        
        NSMutableSet *seenYears = [NSMutableSet set];
        for (NSDictionary *item in sortedArray) {
            //Extract the part of the dictionary that you want to be unique:
            NSDictionary *yearDict = [item dictionaryWithValuesForKeys:@[@"name"]];
            if ([seenYears containsObject:yearDict]) {
                continue;
            }
            [seenYears addObject:yearDict];
            [arr addObject:item];
            //  [duplicatesRemoved addObject:item];
        }
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                     ascending:YES];
        NSArray *srt_arr = [arr sortedArrayUsingDescriptors:@[sortDescriptor]];
        [ARR_category addObjectsFromArray:[srt_arr mutableCopy]];
        [_TBL_menu reloadData];
        
        NSLog(@"Sorted Array :::%@",ARR_category);
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
    
    
    
    j = ARR_category.count;
    NSArray *lan_arr = [[NSUserDefaults standardUserDefaults]  valueForKey:@"language_arr"];
    NSString *str_lang= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    for(int i =0;i<lan_arr.count;i++)
    {
        NSString *ids = [NSString stringWithFormat:@"%@",[[lan_arr objectAtIndex:i] valueForKey:@"id"]];
        
        
        if([str_lang isEqualToString:ids])
        {
            language = [NSString stringWithFormat:@"%@",[[lan_arr objectAtIndex:i] valueForKey:@"language_name"]];
            
        }
    }
    
    
    
    UISwipeGestureRecognizer *SwipeLEFT = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeLeft:)];
    SwipeLEFT.direction = UISwipeGestureRecognizerDirectionLeft;
    [_overlayView addGestureRecognizer:SwipeLEFT];
    
    UISwipeGestureRecognizer *SwipeRIGHT = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRight:)];
    SwipeRIGHT.direction = UISwipeGestureRecognizerDirectionRight;
    
    [_overlayView addGestureRecognizer:SwipeRIGHT];
    [_BTN_log_out addTarget:self action:@selector(BTN_log_outs) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_address addTarget:self action:@selector(btn_address_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_myorder addTarget:self action:@selector(btn_orders_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_wishlist addTarget:self action:@selector(_BTN_wishlist_action) forControlEvents:UIControlEventTouchUpInside];
    
  
    
}

-(void)set_up_VIEW
{
    self.segmentedControl4.selectedSegmentIndex =  0;
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
       } forState:UIControlStateNormal];
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        
        [_BTN_log_out setTitle:@"LOGIN" forState:UIControlStateNormal];
    }
    else
    {
          [_BTN_log_out setTitle:@"LOGOUT" forState:UIControlStateNormal];
    }

    _LBL_badge.layer.cornerRadius = self.LBL_badge.frame.size.width/2;
    _LBL_badge.layer.masksToBounds = YES;
    
    [self  cart_count];
    
    @try
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height <= 480)
        {
            [_LBL_best_selling setFont:[UIFont fontWithName:@"Poppins-ExtraBold" size:12]];
            [_Hot_deals_banner setFont:[UIFont fontWithName:@"Poppins-ExtraBold" size:12]];

            
        
        }
        else if(result.height <= 568)
        {
            [_LBL_best_selling setFont:[UIFont fontWithName:@"Poppins-ExtraBold" size:14]];
            [_Hot_deals_banner setFont:[UIFont fontWithName:@"Poppins-ExtraBold" size:14]];


        }
        else
        {
            [_LBL_best_selling setFont:[UIFont fontWithName:@"Poppins-ExtraBold" size:17]];
            [_Hot_deals_banner setFont:[UIFont fontWithName:@"Poppins-ExtraBold" size:17]];


        }

        
        _Hot_deals.text = [NSString stringWithFormat:@"Women'S %@",[json_Response_Dic valueForKey:@"fashion_name"]];

      NSString *str_deals =[NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"two"]  valueForKey:@"widgetTitle"]];
        _LBL_best_selling.text = str_deals;
    }
    @catch(NSException *exception)
    {
        
    }

       @try
    {
       
     _LBL_fashion_categiries.text = @"FASHION ACCESSORIES";
    }
    @catch(NSException *exception)
    {
        
    }
    @try
    {
    _Hot_deals_banner.text = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"one"]  valueForKey:@"widgetTitle"]];
    }
    @catch(NSException *exception)
    {
    }
    

    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
  menu_arr = [NSArray arrayWithObjects:@"leisure-2_30x30",@"sports-2_30x30",@"events-2_1_30x30",@"movies-2_30x30",nil];
    }
    else{

  menu_arr = [NSArray arrayWithObjects:@"movies-2_30x30",@"events-2_1_30x30",@"sports-2_30x30",@"leisure-2_30x30",nil];
    }

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
    
    CGRect setupframe = _Scroll_contents.frame;
    setupframe.origin.y = self.navigationController.navigationBar.frame.origin.y +  self.navigationController.navigationBar.frame.size.height;
    
    _Scroll_contents.frame = setupframe;
    
     setupframe = _VW_First.frame;
    //setupframe.origin.y = _Tab_MENU.frame.origin.y + _Tab_MENU.frame.size.height ;
    setupframe.size.width = _Scroll_contents.frame.size.width;
    _VW_First.frame = setupframe;
    [self.Scroll_contents addSubview:_VW_First];
    
    
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
    setupframe.size.height = _collection_hot_deals.frame.origin.y + _collection_hot_deals.collectionViewLayout.collectionViewContentSize.height+10+_best_deals_more.frame.size.height;
    setupframe.size.width = _Scroll_contents.frame.size.width;
    _VW_second.frame = setupframe;
    [self.Scroll_contents addSubview:_VW_second];
    
    CGRect frameset = _best_deals_more.frame;
    frameset.origin.y = _collection_hot_deals.frame.origin.y + _collection_hot_deals.collectionViewLayout.collectionViewContentSize.height + 5;
    _best_deals_more.frame = frameset;

    
    [_collection_best_deals reloadData];
    
    
    setupframe = _VW_third.frame;
    setupframe.origin.y = _VW_second.frame.origin.y + _VW_second.frame.size.height +10;
    setupframe.size.height = _collection_best_deals.frame.origin.y + _collection_best_deals.collectionViewLayout.collectionViewContentSize.height+10+_hot_deals_more.frame.size.height;
    setupframe.size.width = _Scroll_contents.frame.size.width;
    _VW_third.frame = setupframe;
    [self.Scroll_contents addSubview:_VW_third];
    
     frameset = _hot_deals_more.frame;
    frameset.origin.y = _collection_best_deals.frame.origin.y + _collection_best_deals.collectionViewLayout.collectionViewContentSize.height + 5;
    _hot_deals_more.frame = frameset;
    
    
    
    [_collection_fashion_categirie reloadData];
    
    
    
    setupframe = _VW_Fourth.frame;
    setupframe.origin.y = _VW_third.frame.origin.y + _VW_third.frame.size.height +10;
    setupframe.size.height = _collection_fashion_categirie.frame.origin.y + _collection_fashion_categirie.collectionViewLayout.collectionViewContentSize.height+_BTN_TOP.frame.size.height + 15;
    setupframe.size.width = _Scroll_contents.frame.size.width;
    _VW_Fourth.frame = setupframe;
    [self.Scroll_contents addSubview:_VW_Fourth];
    
    
     frameset = _BTN_TOP.frame;
    frameset.origin.y = self.collection_fashion_categirie.frame.origin.y + self.collection_fashion_categirie.frame.size.height  + 5;
    _BTN_TOP.frame = frameset;
    
    _BTN_TOP.titleLabel.numberOfLines = 0;
    NSLog(@"THe deals keya are %@",[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"one"] allKeys]);
    if([deals_ARR count] < 1)
    {
        _VW_second.hidden = YES;
        if([hot_deals_ARR count] < 1)
        {
            _VW_third.hidden = YES;
            if(brands_arr.count < 1)
            {
                if([[json_Response_Dic valueForKey:@"bannerFashion"]count] < 1)
                {
                    _VW_Fourth.hidden = NO;
                }
                else
                {
                    setupframe = _VW_Fourth.frame;
                    setupframe.origin.y  = _VW_First.frame.origin.y + _VW_First.frame.size.height;
                    _VW_Fourth.frame = setupframe;
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
                    _VW_Fourth.hidden = NO;
                }
                else
                {
                    setupframe = _VW_Fourth.frame;
                    setupframe.origin.y  = _VW_third.frame.origin.y + _VW_third.frame.size.height;
                    _VW_Fourth.frame = setupframe;
                    
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
        
        if([hot_deals_ARR count] < 1)
        {
            _VW_third.hidden = YES;
            if(brands_arr.count < 1)
            {
                if([[json_Response_Dic valueForKey:@"bannerFashion"]count] < 1)
                {
                    _VW_Fourth.hidden = NO;
                }
                else
                {
                    setupframe = _VW_Fourth.frame;
                    setupframe.origin.y  = _VW_second.frame.origin.y + _VW_second.frame.size.height;
                    _VW_Fourth.frame = setupframe;
                    
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
                else
                {
                    setupframe = _VW_Fourth.frame;
                    setupframe.origin.y  = _VW_third.frame.origin.y + _VW_third.frame.size.height;
                    _VW_Fourth.frame = setupframe;
                    
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
    
    
    self.page_controller_movies.numberOfPages =[[temp_dicts valueForKey:@"movie"] count];
    self.custom_story_page_controller.numberOfPages=[image_Top_ARR count];
    _BTN_left.layer.cornerRadius = _BTN_left.frame.size.width/2;
    _BTN_left.layer.masksToBounds = YES;
    _BTN_right.layer.cornerRadius = _BTN_right.frame.size.width/2;
    _BTN_right.layer.masksToBounds = YES;
    
    _BTN_Movie_left.layer.cornerRadius = _BTN_left.frame.size.width/2;
    _BTN_Movie_left.layer.masksToBounds = YES;
    _BTN_Movie_right.layer.cornerRadius = _BTN_right.frame.size.width/2;
    _BTN_Movie_right.layer.masksToBounds = YES;

    
    [_BTN_right addTarget:self action:@selector(BTN_right_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_left addTarget:self action:@selector(BTN_left_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_menu addTarget:self action:@selector(MENU_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_Movie_right addTarget:self action:@selector(BTN_movies_right_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_Movie_left addTarget:self action:@selector(BTN_movies_left_action) forControlEvents:UIControlEventTouchUpInside];
    
    _BTN_fashion.tag = 1;
    [_BTN_fashion addTarget:self action:@selector(BTN_fashhion_cahnge) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_QT_view addTarget:self action:@selector(movies_ACTIOn) forControlEvents:UIControlEventTouchUpInside];
    [_best_deals_more addTarget:self action:@selector(hot_deals_action) forControlEvents:UIControlEventTouchUpInside];
    [_hot_deals_more addTarget:self action:@selector(best_deals_action) forControlEvents:UIControlEventTouchUpInside];
    

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
    if(collectionView == _collection_showing_movies)
    {
        return [[temp_dicts valueForKey:@"movie"] count];
    }
    else if(collectionView == _collection_images)
    {
        // return temp_arr.count;
        NSInteger count = 0;
        @try
        {
            
            count = image_Top_ARR.count;
        }
        @catch(NSException *exception)
        {
            count = 0;
        }
        
        
        return count;
    }
    else if(collectionView == _collection_features)
    {
        //return temp_arr.count;
        NSLog(@"Max count %lu",[[json_Response_Dic valueForKey:@"bannerLarge"]count]);
        NSInteger count = 0;
        @try
        {
            
            count =  [[json_Response_Dic valueForKey:@"bannerLarge"]count];
        }
        @catch(NSException *exception)
        {
            count = 0;
        }
        
        
        return count;
        
    }
    else if(collectionView == _collection_hot_deals )
    {
        //return temp_hot_deals.count;
        NSInteger count = 0;
        @try
        {
            
            count =  [deals_ARR count];;
        }
        @catch(NSException *exception)
        {
            count = 0;
        }
        
        
        return count;
        
    }
    else if( collectionView == _collection_best_deals)
    {
        //return temp_hot_deals.count; dealWidget-1
        NSInteger count = 0;
        @try
        {
            
            count =  [hot_deals_ARR count];;
        }
        @catch(NSException *exception)
        {
            count = 0;
        }
        
        return count;
        
    }
    else if( collectionView == _collection_brands)
    {
        NSInteger count = 0;
        @try
        {
            
            count =  [brands_arr count];;
        }
        @catch(NSException *exception)
        {
            count = 0;
        }
        
        return count;
    }
    
    else if(collectionView == _collection_fashion_categirie)
    {
        NSInteger count = 0;
        @try
        {
            
            count =  [[json_Response_Dic valueForKey:@"bannerFashion"]count];
        }
        @catch(NSException *exception)
        {
            count = 0;
        }
        
        return count;
    }
    else if(collectionView == _Collection_movies)
    {
        return Movies_arr.count;
    }
    
    return menu_arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //collection images
    if(collectionView == _collection_images)
    {
        
        collection_img_cell *img_cell = (collection_img_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_image" forIndexPath:indexPath];
        @try
        {
            if(indexPath.row == image_Top_ARR.count-1)
            {
                img_cell.img.image = [UIImage imageNamed:[image_Top_ARR objectAtIndex:indexPath.row]];
            }
            else
            {
                NSString *url_Img_FULL = [NSString stringWithFormat:@"%@uploads/banners/%@",SERVER_URL,[[image_Top_ARR objectAtIndex:indexPath.row] valueForKey:@"banner"]];
                url_Img_FULL  =[url_Img_FULL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                [img_cell.img sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                                placeholderImage:[UIImage imageNamed:@"logo.png"]
                                         options:SDWebImageRefreshCached];
            }
            
            
        }
        @catch(NSException *xception)
        {
            
        }
        
        
        return img_cell;
    }
    // collection now showing movies
    else if(collectionView == _collection_showing_movies)
    {
        cell_features *img_cell = (cell_features *)[collectionView dequeueReusableCellWithReuseIdentifier:@"showing_movies_cell" forIndexPath:indexPath];
        @try
        {
            NSString *img_url = [[[temp_dicts valueForKey:@"movie"]objectAtIndex:indexPath.row]valueForKey:@"_iphonethumb"];
            img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
            [img_cell.img sd_setImageWithURL:[NSURL URLWithString:img_url]
                            placeholderImage:[UIImage imageNamed:@"upload-8.png"]
                                     options:SDWebImageRefreshCached];
        }
        @catch(NSException *exception)
        {
            
        }
        
        
        
        return img_cell;
    }
    //collection features
    else if(collectionView == _collection_features)
    {
        cell_features *cell = (cell_features *)[collectionView dequeueReusableCellWithReuseIdentifier:@"features_cell" forIndexPath:indexPath];
        //cell.img.image = [UIImage imageNamed:[temp_arr objectAtIndex:indexPath.row]];
        
        @try {
            NSString *url_Img_FULL = [NSString stringWithFormat:@"%@uploads/banners_ads/%@",SERVER_URL,[[[json_Response_Dic valueForKey:@"bannerLarge"] objectAtIndex:indexPath.row] valueForKey:@"mobile_banner"]];
            url_Img_FULL  =[url_Img_FULL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            [cell.img sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                        placeholderImage:[UIImage imageNamed:@"logo.png"]];
            
            //            _LBL_featured.text = [[[json_Response_Dic valueForKey:@"bannerLarge"] objectAtIndex:indexPath.row] valueForKey:@"title"];
        } @catch (NSException *exception) {
            NSLog(@"Exception from cell item indexpath %@",exception);
        }
        
        
        return cell;
        
        
    }
    
    //collection hot deals
    else if(collectionView == _collection_hot_deals)
    {
        product_cell *pro_cell = (product_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_product" forIndexPath:indexPath];
        
        @try
        {
            
            
#pragma Webimage URl Cachee
            
          NSString *url_Img_FULL = [NSString stringWithFormat:@"%@",[[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_image"]];
            [pro_cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                                          options:SDWebImageRefreshCached];
            
            @try
            {
                NSString *str =[NSString stringWithFormat:@"%@",[[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"stock_status"]];
                str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                if([str isEqualToString:@"In stock"])
                {
                    pro_cell.LBL_stock.text =@"";
                }
                else{
                    pro_cell.LBL_stock.text =[str uppercaseString];
                }
            }
            @catch(NSException *exception)
            {
                
            }
            pro_cell.LBL_item_name.text = [[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_title"];
            
            
            float rating = [[[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"rating"] floatValue];
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
            //            pro_cell.LBL_current_price.text = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"special_price"]];
            //
            
            NSString *currency = [NSString stringWithFormat:@"%@",[json_Response_Dic valueForKey:@"currency"]];
            
            
            NSString *current_price = [NSString stringWithFormat:@"%@", [[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"special_price"]];
            
            NSString *prec_price = [NSString stringWithFormat:@"%@ %@",currency, [[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_price"]];
            NSString *text ;
            if ([pro_cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
                
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setAlignment:NSTextAlignmentCenter];
                
                if ([current_price isEqualToString:@"<null>"] || [current_price isEqualToString:@"<nil>"]||[current_price isEqualToString:@"0"]) {
                    
                    
                    text = [NSString stringWithFormat:@"%@",prec_price];
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                    
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:[text rangeOfString:currency] ];
                    
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:[text rangeOfString:prec_price] ];
                    
                    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                    //NSParagraphStyleAttributeName
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    pro_cell.LBL_discount.text = @"";
                    
                    
                    
                }
                
                else{
                    
                    
                    NSString *str_discount = [NSString stringWithFormat:@"%@", [[deals_ARR objectAtIndex:indexPath.row]valueForKey:@"discount"]];
                    
                    NSString *str = @"% off";
                    pro_cell.LBL_discount.text = [NSString stringWithFormat:@"%@%@",str_discount,str];
                    
                    
                    // prec_price = [currency stringByAppendingString:prec_price];
                    text = [NSString stringWithFormat:@"%@ %@ %@",currency,current_price,prec_price];
                    
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0],}range:[text rangeOfString:currency] ];
                    
                    NSRange ename = [text rangeOfString:current_price];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:25.0]}
                                                range:ename];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
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
                                           range:NSMakeRange([current_price length]+currency.length+2, [prec_price length])];
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    
                }
            }
            else
            {
                pro_cell.LBL_current_price.text = text;
            }
            
            
            
            [pro_cell.BTN_fav setTag:indexPath.row];//wishListStatus
            
            
            if ([[[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"wishListStatus"] isEqualToString:@"Yes"]) {
                
                [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                [pro_cell.BTN_fav setTitleColor:[UIColor colorWithRed:0.91 green:0.21 blue:0.00 alpha:1.0] forState:UIControlStateNormal];
            }
            else{
                [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                
                [pro_cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            [pro_cell.BTN_fav addTarget:self action:@selector(hot_dels_wishlist:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
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
            
            
#pragma Webimage URl Cachee
            
            NSString *url_Img_FULL =[NSString stringWithFormat:@"%@", [[hot_deals_ARR objectAtIndex:indexPath.row ] valueForKey:@"product_image"]];
            [pro_cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                                          options:SDWebImageRefreshCached];
            
            @try
            {
                NSString *str =[NSString stringWithFormat:@"%@",[[hot_deals_ARR objectAtIndex:indexPath.row ]  valueForKey:@"stock_status"]];
                str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                if([str isEqualToString:@"In stock"])
                {
                    pro_cell.LBL_stock.text =@"";
                }
                else{
                    pro_cell.LBL_stock.text =[str uppercaseString];
                }
            }
            @catch(NSException *exception)
            {
                
            }
            pro_cell.LBL_item_name.text = [[hot_deals_ARR objectAtIndex:indexPath.row ]  valueForKey:@"product_title"];
            
            
            float rating = [[[hot_deals_ARR objectAtIndex:indexPath.row ]  valueForKey:@"rating"] floatValue];
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
            //            pro_cell.LBL_current_price.text = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"special_price"]];
            //
            
            NSString *currency = [NSString stringWithFormat:@"%@",[json_Response_Dic valueForKey:@"currency"]];
            
            
            NSString *current_price = [NSString stringWithFormat:@"%@", [[hot_deals_ARR objectAtIndex:indexPath.row ]  valueForKey:@"special_price"]];
            
            NSString *prec_price = [NSString stringWithFormat:@"%@ %@",currency, [[hot_deals_ARR objectAtIndex:indexPath.row ]  valueForKey:@"product_price"]];
            NSString *text ;
            if ([pro_cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
                
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setAlignment:NSTextAlignmentCenter];
                
                if ([current_price isEqualToString:@"<null>"] || [current_price isEqualToString:@"<nil>"]||[current_price isEqualToString:@"0"]) {
                    
                    
                    text = [NSString stringWithFormat:@"%@",prec_price];
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                    
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:[text rangeOfString:currency] ];
                    
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:[text rangeOfString:prec_price] ];
                    
                    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                    //NSParagraphStyleAttributeName
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    pro_cell.LBL_discount.text = @"";
                    
                    
                    
                }
                
                else{
                    
                    
                    NSString *str_discount = [NSString stringWithFormat:@"%@", [[hot_deals_ARR objectAtIndex:indexPath.row ] valueForKey:@"discount"]];
                    
                    NSString *str = @"% off";
                    pro_cell.LBL_discount.text = [NSString stringWithFormat:@"%@%@",str_discount,str];
                    
                    
                    // prec_price = [currency stringByAppendingString:prec_price];
                    text = [NSString stringWithFormat:@"%@ %@ %@",currency,current_price,prec_price];
                    
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0],}range:[text rangeOfString:currency] ];
                    
                    NSRange ename = [text rangeOfString:current_price];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:25.0]}
                                                range:ename];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
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
                                           range:NSMakeRange([current_price length]+currency.length+2, [prec_price length])];
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    
                }
            }
            else
            {
                pro_cell.LBL_current_price.text = text;
            }
            
            
            
            [pro_cell.BTN_fav setTag:indexPath.row];//wishListStatus
            
            
            if ([ [[hot_deals_ARR objectAtIndex:indexPath.row ]  valueForKey:@"wishListStatus"] isEqualToString:@"Yes"]) {
                
                [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                [pro_cell.BTN_fav setTitleColor:[UIColor colorWithRed:0.91 green:0.21 blue:0.00 alpha:1.0] forState:UIControlStateNormal];
            }
            else{
                [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                
                [pro_cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            [pro_cell.BTN_fav addTarget:self action:@selector(best_dels_wishlist:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
        }
        @catch(NSException *exception)
        {
            
        }
        //hotdeals_cell.LBL_discount.text = [temp_dict valueForKey:@"key4"];
        
        NSLog(@"The cell frame is :%@",NSStringFromCGRect(pro_cell.frame));
        NSLog(@"The hot_deals frame is :%@",NSStringFromCGRect(_collection_hot_deals.frame));
        return pro_cell;
        
        
    }     else if(collectionView == _collection_brands)
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
    else if(collectionView == _Collection_QT_menu)
    {
        collection_MENU *pro_cell = (collection_MENU *)[collectionView dequeueReusableCellWithReuseIdentifier:@"menu_cell" forIndexPath:indexPath];
        @try
        {
            NSArray *arr = [NSArray arrayWithObjects:@"Movies",@"Events",@"Sports",@"Leisure", nil];
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                arr = [NSArray arrayWithObjects:@"Leisure",@"Sports",@"Events",@"Movies", nil];
            }
            
            
            pro_cell.IMG_menu.image = [UIImage imageNamed:[menu_arr objectAtIndex:indexPath.row]];
            pro_cell.LBL_menu.text = [arr objectAtIndex:indexPath.row];
            if(indexPath.row == 0)
            {
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    pro_cell.VW_back_ground.backgroundColor = [UIColor colorWithRed:0.68 green:0.81 blue:0.60 alpha:1.0];
                    pro_cell.VW_select.backgroundColor = [UIColor colorWithRed:0.37 green:0.70 blue:0.14 alpha:1.0];
                }
                else{
                    pro_cell.VW_back_ground.backgroundColor = [UIColor colorWithRed:0.50 green:0.69 blue:0.80 alpha:1.0];
                    pro_cell.VW_select.backgroundColor = [UIColor colorWithRed:0.20 green:0.56 blue:0.76 alpha:1.0];
                }
                
            }
            if(indexPath.row == 1)
            {
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    pro_cell.VW_back_ground.backgroundColor = [UIColor colorWithRed:0.78 green:0.62 blue:0.78 alpha:1.0];
                    pro_cell.VW_select.backgroundColor = [UIColor colorWithRed:0.57 green:0.17 blue:0.56 alpha:1.0];
                }
                else{
                    
                    
                    pro_cell.VW_back_ground.backgroundColor = [UIColor colorWithRed:0.77 green:0.52 blue:0.64 alpha:1.0];
                    pro_cell.VW_select.backgroundColor = [UIColor colorWithRed:0.93 green:0.10 blue:0.51 alpha:1.0];
                }
            }
            if(indexPath.row == 2)
            {
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    pro_cell.VW_back_ground.backgroundColor = [UIColor colorWithRed:0.77 green:0.52 blue:0.64 alpha:1.0];
                    pro_cell.VW_select.backgroundColor = [UIColor colorWithRed:0.93 green:0.10 blue:0.51 alpha:1.0];
                }
                
                else{
                    
                    pro_cell.VW_back_ground.backgroundColor = [UIColor colorWithRed:0.78 green:0.62 blue:0.78 alpha:1.0];
                    pro_cell.VW_select.backgroundColor = [UIColor colorWithRed:0.57 green:0.17 blue:0.56 alpha:1.0];
                }
            }
            if(indexPath.row == 3)
            {
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    pro_cell.VW_back_ground.backgroundColor = [UIColor colorWithRed:0.50 green:0.69 blue:0.80 alpha:1.0];
                    pro_cell.VW_select.backgroundColor = [UIColor colorWithRed:0.20 green:0.56 blue:0.76 alpha:1.0];
                }
                else{
                    
                    pro_cell.VW_back_ground.backgroundColor = [UIColor colorWithRed:0.68 green:0.81 blue:0.60 alpha:1.0];
                    pro_cell.VW_select.backgroundColor = [UIColor colorWithRed:0.37 green:0.70 blue:0.14 alpha:1.0];
                }
            }
            
            
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
      else if(collectionView == _collection_showing_movies)
    {
        
        return CGSizeMake(_collection_showing_movies.frame.size.width ,_collection_showing_movies.frame.size.height);
    }

    else if( collectionView == _collection_features)
    {
        return CGSizeMake(_collection_features.bounds.size.width ,_collection_features.frame.size.height);
        
    }
    else if(collectionView == _collection_best_deals)
    {
        return CGSizeMake(_collection_best_deals.frame.size.width/2.011, 320);
        
    }
    else if(collectionView == _Collection_QT_menu)
    {
        return CGSizeMake(_Collection_QT_menu.frame.size.width/4.1, 80);
    }
    else if(collectionView == _collection_hot_deals)
    {
        NSLog(@"the size is width %f: THE height%d",(_collection_hot_deals.bounds.size.width/2),285);

        return CGSizeMake(_collection_hot_deals.frame.size.width/2.011, 320);
        
    }
    else if( collectionView == _collection_brands)
    {
        return CGSizeMake(_collection_features.frame.size.width/3.28 ,50);
        
    }
    else if(collectionView == _collection_fashion_categirie)
    {
        int count = 0;
        
        
        if(indexPath.row == 0)
        {
            count = 270;
        }
        if(indexPath.row == 1)
        {
            count = 200;
        }
        else{
            count = 200;
        }
        return CGSizeMake(self.collection_fashion_categirie.bounds.size.width, count);
        
        
    }
    else
        return CGSizeMake(0,0);
    
    
    
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _collection_hot_deals)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[deals_ARR objectAtIndex:indexPath.row]valueForKey:@"url_key"] forKey:@"product_list_key_sub"];
        
        NSString *merchant_id = [NSString stringWithFormat:@"%@",[[deals_ARR objectAtIndex:indexPath.row]valueForKey:@"merchant_id"]];
         [[NSUserDefaults standardUserDefaults] setValue:merchant_id forKey:@"Mercahnt_ID"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self performSegueWithIdentifier:@"QT_home_product_detail" sender:self];
    }
    else if(collectionView == _collection_best_deals)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[hot_deals_ARR objectAtIndex:indexPath.row]valueForKey:@"url_key"] forKey:@"product_list_key_sub"];
        NSString *merchant_id = [NSString stringWithFormat:@"%@",[[hot_deals_ARR objectAtIndex:indexPath.row]valueForKey:@"merchant_id"]];
        [[NSUserDefaults standardUserDefaults] setValue:merchant_id forKey:@"Mercahnt_ID"];

        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"QT_home_product_detail" sender:self];

    }
      else if(collectionView == _collection_brands)
    {
        
        @try
        {
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        
        NSString *user_id = [NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"]];
        if([user_id isEqualToString:@"(null)"])
        {
            user_id = @"0";
        }
        
        NSString *url_key = [NSString stringWithFormat:@"%@",[[brands_arr objectAtIndex:indexPath.row] valueForKey:@"url_key"]];
         NSString *list_TYPE = @"brandsList";
        NSString *urlkeyval = [NSString stringWithFormat:@"%@/%@/0",list_TYPE,url_key];
       
        [[NSUserDefaults standardUserDefaults] setValue:urlkeyval forKey:@"product_list_key"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/%@/Customer/1.json",SERVER_URL,list_TYPE,url_key,country,languge,user_id];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setValue:[[[[brands_arr objectAtIndex:indexPath.row] valueForKey:@"_matchingData"]valueForKey:@"BrandDescriptions"] valueForKey:@"name"] forKey:@"item_name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];
        }
        @catch(NSException *exception)
        {
            
        }
    
    }
    else if(collectionView == _collection_features)
    {
        @try
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
        [[NSUserDefaults standardUserDefaults] setValue:[[[json_Response_Dic valueForKey:@"bannerLarge"] objectAtIndex:indexPath.row] valueForKey:@"title"] forKey:@"item_name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
            NSString *list_TYPE = @"productList";
            NSString *user_id = [NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"]];
            if([user_id isEqualToString:@"(null)"])
            {
                user_id = @"0";
            }
            url_key = [NSString stringWithFormat:@"%@/%@",list_TYPE,url_key];
        
       
     //   NSString *url_key_val =[[[json_Response_Dic valueForKey:@"bannerLarge"] objectAtIndex:indexPath.row] valueForKey:@"url"];
            

        
        [[NSUserDefaults standardUserDefaults] setValue:url_key forKey:@"product_list_key"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/Customer/1.json",SERVER_URL,url_key,country,languge,user_id];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];
        }
        @catch(NSException *Exception)
        {
            
        }

        
    }
    else if(collectionView == _collection_images)
    {
        @try
        {
        if(indexPath.row == image_Top_ARR.count - 1)
        {
            [self movies_ACTIOn];
        }
        else
        {
        NSString *hot_deals_url = [NSString stringWithFormat:@"%@",[[image_Top_ARR objectAtIndex:indexPath.row] valueForKey:@"url"]];
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
        [[NSUserDefaults standardUserDefaults] setValue:[[image_Top_ARR objectAtIndex:indexPath.row] valueForKey:@"title"]  forKey:@"item_name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
            NSString *user_id = [NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"]];
            if([user_id isEqualToString:@"(null)"])
            {
                user_id = @"0";
            }
        
        NSString *list_TYPE = @"productList";
            NSString *url_key_val =[[image_Top_ARR objectAtIndex:indexPath.row] valueForKey:@"url"];
            url_key_val = [url_key_val stringByReplacingOccurrencesOfString:@"catalog/" withString:@""];
            url_key = [NSString stringWithFormat:@"%@/%@",list_TYPE,url_key];
            [[NSUserDefaults standardUserDefaults] setValue:url_key forKey:@"product_list_key"];
            [[NSUserDefaults standardUserDefaults] synchronize];

        NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/Customer/1.json",SERVER_URL,url_key,country,languge,user_id];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];
        }
        }
        @catch(NSException *exception)
        {
            
        }

    }
    
    else if(collectionView == _collection_fashion_categirie)
    {
        NSString *fashion_deals_url = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"bannerFashion"] objectAtIndex:indexPath.row] valueForKey:@"url"]];
        fashion_deals_url = [fashion_deals_url stringByReplacingOccurrencesOfString:@"catalog/" withString:@""];
        fashion_deals_url = [fashion_deals_url stringByReplacingOccurrencesOfString:@"discount/" withString:@""];
        NSString *url_key;
        if([fashion_deals_url containsString:@"/"])
        {
            url_key = [NSString stringWithFormat:@"%@",fashion_deals_url];
            
        }
        else
        {
            url_key =[NSString stringWithFormat:@"%@/0",fashion_deals_url];
        }
        [[NSUserDefaults standardUserDefaults] setValue:[[[json_Response_Dic valueForKey:@"bannerFashion"] objectAtIndex:indexPath.row] valueForKey:@"title"] forKey:@"item_name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        NSString *user_id = [NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"]];
        if([user_id isEqualToString:@"(null)"])
        {
            user_id = @"0";
        }
        
        
        NSString *list_TYPE = @"productList";
        url_key = [NSString stringWithFormat:@"%@/%@",list_TYPE,url_key];
        
        
        NSString *url_key_val =[[[json_Response_Dic valueForKey:@"bannerFashion"] objectAtIndex:indexPath.row] valueForKey:@"url"];
        url_key_val = [url_key_val stringByReplacingOccurrencesOfString:@"catalog/" withString:@""];
         url_key_val = [url_key_val stringByReplacingOccurrencesOfString:@"discount/" withString:@""];
        [[NSUserDefaults standardUserDefaults] setValue:url_key forKey:@"product_list_key"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/Customer/1.json",SERVER_URL,url_key,country,languge,user_id];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];

    }
    else if(collectionView == _collection_showing_movies)
    {
        [[NSUserDefaults standardUserDefaults]  setValue:[[[temp_dicts valueForKey:@"movie"] objectAtIndex:indexPath.row] valueForKey:@"_id"]  forKey:@"id"];
        [[NSUserDefaults standardUserDefaults]  synchronize];
        [self performSegueWithIdentifier:@"Movies_Booking" sender:self];
    }

    else if(collectionView == _Collection_QT_menu)
    {
        NSUserDefaults *user_defafults = [NSUserDefaults standardUserDefaults];
        
        if(indexPath.row == 0)
        {
            
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                 [user_defafults setValue:@"LEISURE" forKey:@"header_name"];
            }else{
                 [user_defafults setValue:@"MOVIES" forKey:@"header_name"];
            }
            
            
        }
        if(indexPath.row == 1)
        {
            
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                [user_defafults setValue:@"SPORTS" forKey:@"header_name"];
            }else{
                [user_defafults setValue:@"EVENTS" forKey:@"header_name"];
            }
            
        }

        if(indexPath.row == 2)
        {
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
               [user_defafults setValue:@"EVENTS" forKey:@"header_name"];
            }else{
                [user_defafults setValue:@"SPORTS" forKey:@"header_name"];

            }
            
            
            
        }

        if(indexPath.row == 3)
        {
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                [user_defafults setValue:@"MOVIES" forKey:@"header_name"];
            }else{
                [user_defafults setValue:@"LEISURE" forKey:@"header_name"];
                
            }
            
        }
        [user_defafults synchronize];
        
        [self performSegueWithIdentifier:@"QTickets_identifier" sender:self];
        

    
    }

    
}
#pragma Tableview delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == _TBL_menu)
    {
        return 4;
    }
      return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger ceel_count = 0;
    if(tableView == _TBL_menu)
    {
    if(section == 0)
    {
        ceel_count = ARR_category.count;
    }
    if(section == 1)
    {
        ceel_count = 3;
    }
    if(section == 2)
    {
        ceel_count = 1;
    }
    if(section == 3)
    {
        ceel_count = 5;
    }
         return ceel_count;
    }
    
    return ceel_count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   
    NSInteger index;
    categorie_cell *cell = (categorie_cell *)[tableView dequeueReusableCellWithIdentifier:@"cate_cell"];
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        index = 0;
    }
    else{
        index =1;
    }
    
    // Menu table
    CGRect frameset =  cell.VW_line1.frame;
    frameset.size.height = 0.5;
    cell.VW_line1.frame = frameset;
    if(tableView == _TBL_menu)
    {
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"categorie_cell" owner:self options:nil];
            cell = [nib objectAtIndex:index];
        }
        CGRect frameset = cell.frame;
        frameset.size.width = _TBL_menu.frame.size.width;
        cell.frame = frameset;
        //    cell.LBL_arrow.hidden = YES;
        
        if(indexPath.section == 0)
        {
            cell.LBL_arrow.hidden = NO;
            
            
            NSString *Title= [[ARR_category objectAtIndex:indexPath.row] valueForKey:@"name"];
            
            cell.LBL_name.text = [Title uppercaseString];
            [cell.LBL_arrow addTarget:self action:@selector(sub_category_action:) forControlEvents:UIControlEventTouchUpInside];
            cell.LBL_arrow.tag = indexPath.row;
            if(indexPath.row == [ARR_category count] - 1)
            {
                cell.VW_line1.hidden = NO;
            }
            else{
                cell.VW_line1.hidden = YES;

            }
            
        }
        if(indexPath.section == 1)
        {
              cell.LBL_arrow.hidden = YES;
            NSArray *ARR_info = [NSArray arrayWithObjects:@"MY PROFILE",@"MY ADDRESS",@"CHANGE PASSWORD", nil];
            cell.LBL_name.text = [ARR_info objectAtIndex:indexPath.row];
            if(indexPath.row == [ARR_info count]  - 1)
            {
              cell.VW_line1.hidden = NO;
            }
            else{
                cell.VW_line1.hidden = YES;
                
            }
        }
        if(indexPath.section == 2)
        {
            
            
            //language_cellTableViewCell
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                index = 3;
            }
            else{
                index =2;
            }
            
            
            language_cellTableViewCell *cell = (language_cellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"language_cellTableViewCell"];
            CGRect frameset =  cell.VW_line1.frame;
            frameset.size.height = 0.5;
            cell.VW_line1.frame = frameset;
            
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"categorie_cell" owner:self options:nil];
            cell = [nib objectAtIndex:index];
            cell.TXT_lang.text = language;
            cell.TXT_lang.delegate= self;
            
            cell.VW_line1.hidden = NO;
            
            _lang_pickers = [[UIPickerView alloc] init];
            _lang_pickers.delegate = self;
            _lang_pickers.dataSource = self;
            UIToolbar* conutry_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            conutry_close.barStyle = UIBarStyleBlackTranslucent;
            [conutry_close sizeToFit];
            
            UIButton *close=[[UIButton alloc]init];
            close.frame=CGRectMake(conutry_close.frame.origin.x -20, 0, 100, conutry_close.frame.size.height);
            [close setTitle:@"Close" forState:UIControlStateNormal];
            [close addTarget:self action:@selector(close_action) forControlEvents:UIControlEventTouchUpInside];
            [conutry_close addSubview:close];
            
            
            
            UIButton *done=[[UIButton alloc]init];
            done.frame=CGRectMake(conutry_close.frame.size.width - 100, 0, 100, conutry_close.frame.size.height);
            [done setTitle:@"Done" forState:UIControlStateNormal];
            [done addTarget:self action:@selector(done_action) forControlEvents:UIControlEventTouchUpInside];
            [conutry_close addSubview:done];
            
            done.tag = indexPath.row;
            
            cell.TXT_lang.inputAccessoryView=conutry_close;
            cell.TXT_lang.inputView = _lang_pickers;
            cell.TXT_lang.tintColor=[UIColor clearColor];
            
            return cell;
            
            
        }
        if(indexPath.section == 3)
        {
            
            NSArray *ARR_info = [NSArray arrayWithObjects:@"ABOUT US",@"CONTACT US",@"HELPDESK",@"PRIVACY POLICY",@"TERMS AND CONDITIONS", nil];
            cell.LBL_name.text = [ARR_info objectAtIndex:indexPath.row];
            cell.LBL_arrow.hidden = YES;
            if(indexPath.row == ARR_info.count - 1)
            {
                cell.VW_line1.hidden = NO;
            }
            else{
                cell.VW_line1.hidden = YES;
                
            }

            
        }
        return cell;
        
    }
    
    // Evets list Table
    
     return cell;
    
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str;
    if(tableView == _TBL_menu)
    {
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
    return nil;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == _TBL_menu)
    {
    switch (indexPath.section)
    {
        case 0:
        {
             [self swipe_left];
            NSString *list_TYPE = @"productList";
            NSString *list_key =[NSString stringWithFormat:@"%@/%@/0",list_TYPE,[[ARR_category objectAtIndex:indexPath.row] valueForKey:@"url_key"]];
            [[NSUserDefaults standardUserDefaults] setValue:list_key forKey:@"product_list_key"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
            NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
            NSString *user_id = [NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"]];
            if([user_id isEqualToString:@"(null)"])
            {
                user_id = @"0";
            }
            
            if([user_id isEqualToString:@"(null)"])
            {
                user_id = @"0";
            }
            
            
            NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/Customer/1.json",SERVER_URL,list_key,country,languge,user_id];
            
            
            [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self didelct_sub_categoies];
            

                  break;
        }
        case 1:
            [self swipe_left];
            if(indexPath.row == 1)
            {
                NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
                NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
                if([user_id isEqualToString:@"(null)"])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please login to access this" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
                    alert.tag = 1;
                    [alert show];
                    
                }
                else
                {
                    
                [self performSegueWithIdentifier:@"home_address" sender:self];
                }


               // self.VW_Movies.hidden = YES;
               // self.VW_Leisure.hidden =YES;
               // self.VW_event.hidden = YES;
                //self.VW_sports.hidden =YES;
               // home.view.hidden = YES;
              //  _Tab_MENU.selectedItem = nil;
                self.Scroll_contents.hidden = NO;
                
            }
            if(indexPath.row == 2)
            {
                NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
                NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
                if([user_id isEqualToString:@"(null)"])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please login to access this" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
                    alert.tag = 1;
                    [alert show];
                    
                }
                else
                {
                [self performSegueWithIdentifier:@"login_forgot_pwd" sender:self];
               
                }
  
            }

            if(indexPath.row == 0)
            {
                NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
                NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
                if([user_id isEqualToString:@"(null)"])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please login to access this" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
                    alert.tag = 1;
                    [alert show];
                    
                }
                else
                {
                     [self performSegueWithIdentifier:@"edot_profile_VC" sender:self];

              
                }
            }
            else{
                NSLog(@"ACCount selected");
            }
            break;
             case 2:
            if(indexPath.row == 0)
            {
                
                
            }
            break;
            
        case 3:
            [self swipe_left];
            if(indexPath.row == 0)
            {
                [self performSegueWithIdentifier:@"Home_about_us" sender:self];

            }
            if(indexPath.row == 1)
            {
                [self performSegueWithIdentifier:@"contact_us_segue" sender:self];
            }
            if(indexPath.row == 4)
            {
                [self performSegueWithIdentifier:@"Home_terms" sender:self];
            }
            if(indexPath.row == 3)
            {
                [self performSegueWithIdentifier:@"Home_privacy" sender:self];
            }
            if(indexPath.row == 2)
            {
                 [self performSegueWithIdentifier:@"home_help_desk" sender:self];//home_help_desk
            }
            break;
        default:
            break;
    }
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return tableView.rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
         return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320,0)];
    UILabel *tempLabel;
    
    NSString *str;
    if(tableView == _TBL_menu)
    {
        
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height <= 480)
        {
             tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-7,230,30)];
        }
        else if(result.height <= 568)
        {
             tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-7,230,30)];
        }
        else
        {
            tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-7,275,30)];
        }
        
        
        
        
        
//        UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-7,305,30)];
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            tempLabel.textAlignment = NSTextAlignmentRight;
        }
        
        // tempLabel.backgroundColor = [UIColor whiteColor];
        tempLabel.textColor = [UIColor lightGrayColor]; //here you can change the text color of header.
        tempLabel.font = [UIFont fontWithName:@"Poppins-Regular" size:12];
        
        // tempView.backgroundColor=[UIColor whiteColor];
        
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
            str = @"LANGUAGE";
        }
        if(section == 3)
        {
            str = @"QUICK LINKS";
        }
        tempLabel.text =str;
        tempLabel.backgroundColor = [UIColor whiteColor];
        [tempView addSubview:tempLabel];
        return tempView;
    }
    else
    {
        UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-10,305,40)];
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height <= 480)
        {
            tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-7,230,30)];
        }
        else if(result.height <= 568)
        {
            tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-7,230,30)];
        }
        else
        {
            tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-7,275,30)];
        }
        
        
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            tempLabel.textAlignment = NSTextAlignmentRight;
        }
        
        tempLabel.textColor = [UIColor grayColor]; //here you can change the text color of header.
        tempLabel.font = [UIFont fontWithName:@"Poppins-Regular" size:15];
        [tempView addSubview:tempLabel];
        return tempView;
        
    }
}




-(void)sub_category_action:(UIButton *)sender
{
    NSString *name = [[ARR_category objectAtIndex:sender.tag] valueForKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"item_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:[ARR_category objectAtIndex:sender.tag] forKey:@"product_sub_list"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *list_key = [NSString stringWithFormat:@"%@/0",[[ARR_category objectAtIndex:sender.tag] valueForKey:@"url_key"]];
    [[NSUserDefaults standardUserDefaults] setValue:list_key forKey:@"product_list_key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self swipe_left];
    [self performSegueWithIdentifier:@"qt_home_sub_brands" sender:self];
    
    
    
}
-(void)done_action
{
    [_TBL_menu reloadData];
    
    
    if ([language isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"]]) {
        
    }
    else{
        
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"story_board_language"];
        [[NSUserDefaults  standardUserDefaults] setValue:language forKey:@"story_board_language"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if([language isEqualToString:@"Arabic"])
        {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Arabic" bundle:nil];
            
            Home_page_Qtickets *controller = [storyboard instantiateViewControllerWithIdentifier:@"Home_page_Qtickets"];
            
            
            UINavigationController *navigationController =
            [[UINavigationController alloc] initWithRootViewController:controller];
            [self  presentViewController:navigationController animated:NO completion:nil];
            
        }
        else{
            
            //[HttpClient createaAlertWithMsg:@"Plesase Select English Story board" andTitle:@""];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            Home_page_Qtickets *controller = [storyboard instantiateViewControllerWithIdentifier:@"QT_controller"];
            UINavigationController *navigationController =
            [[UINavigationController alloc] initWithRootViewController:controller];
            [self  presentViewController:navigationController animated:NO completion:nil];
            
            
            
            
        }
        
    }

}
-(void)close_action
{
    [_TBL_menu reloadData];
    [self.view endEditing:YES];
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [UIView setAnimationsEnabled:animationsEnabled];
}
-(void)didelct_sub_categoies
{
     [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];
    
    
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
            CGPoint visiblePoint = CGPointMake(newTargetOffset, _collection_images.contentOffset.y);
            NSIndexPath *visibleIndexPath = [self.collection_images indexPathForItemAtPoint:visiblePoint];
            
            self.custom_story_page_controller.currentPage = visibleIndexPath.row;
            
        }
        else if([cellIdentifier isEqualToString:@"showing_movies_cell"])
        {
            float pageWidth = _collection_showing_movies.frame.size.width; // width + space
            
            float currentOffset = _collection_showing_movies.contentOffset.x;
            float targetOffset = targetContentOffset->x;
            float newTargetOffset = 1;
            
            if (targetOffset > currentOffset)
                newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
            else
                newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
            
            if (newTargetOffset < 0)
                newTargetOffset = 0;
            else if (newTargetOffset > _collection_showing_movies.contentSize.width)
                newTargetOffset = _collection_showing_movies.contentSize.width;
            
            targetContentOffset->x = currentOffset;
            [_collection_showing_movies setContentOffset:CGPointMake(newTargetOffset  , _collection_showing_movies.contentOffset.y) animated:YES];
            
            CGPoint visiblePoint = CGPointMake(newTargetOffset, _collection_showing_movies.contentOffset.y);
            NSIndexPath *visibleIndexPath = [_collection_showing_movies indexPathForItemAtPoint:visiblePoint];
            
            INDX_selected = visibleIndexPath;
            self.page_controller_movies.currentPage = visibleIndexPath.row;
            
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

-(void)_BTN_wishlist_action
{
    [self swipe_left];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please login to access this" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        alert.tag = 1;
        [alert show];
        
    }
    else
    {

        [self performSegueWithIdentifier:@"HomeQ_to_wishList" sender:self];

        
    }
    }

- (IBAction)QTickets_Home_to_CartPage:(id)sender {
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please login to continue" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        alert.tag = 1;
        [alert show];
        
    }
    else
    {
        
        [self performSegueWithIdentifier:@"homeQtkt_to_cart" sender:self];
        
        
    }
}


-(void)BTN_movies_right_action
{
    
    NSIndexPath *newIndexPath;
    if (!INDX_selected)
    {
        newIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        INDX_selected = newIndexPath;
    }
    else if ([[temp_dicts valueForKey:@"movie"] count]  > INDX_selected.row)
    {
        if ([[temp_dicts valueForKey:@"movie"] count] == INDX_selected.row + 1) {
            newIndexPath = [NSIndexPath indexPathForRow:[[temp_dicts valueForKey:@"movie"] count] - 1 inSection:0];
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
    
    
    [_collection_showing_movies scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:INDX_selected.row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    _page_controller_movies.currentPage = INDX_selected.row;
}
-(void)BTN_movies_left_action
{
    @try
    {
        NSIndexPath *newIndexPath;
        if (INDX_selected)
        {
            newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row -1 inSection:0];
            INDX_selected = newIndexPath;
        }
        
        else if ([[temp_dicts valueForKey:@"movie"] count]  < INDX_selected.row)
        {
            if ([[temp_dicts valueForKey:@"movie"] count] == INDX_selected.row - 1)
            {
                newIndexPath = [NSIndexPath indexPathForRow:[[temp_dicts valueForKey:@"movie"] count] + 1 inSection:0];
                INDX_selected = newIndexPath;
            }
            else
            {
                newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row - 1 inSection:0];
                INDX_selected = newIndexPath;
            }
        }
        if (newIndexPath.row == 1)
        {
            newIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            INDX_selected = newIndexPath;
        }
        if(newIndexPath.row < 1)
        {
            newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            INDX_selected = newIndexPath;
        }
        
        [_collection_showing_movies scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:INDX_selected.row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        _page_controller_movies.currentPage = INDX_selected.row;
    }
    
    
    @catch (NSException *exception)
    {
        NSLog(@"exception:%@",exception);
    }
    
}



-(void)BTN_right_action
{
    
    NSIndexPath *newIndexPath;
    if (!INDX_selected)
    {
        newIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        INDX_selected = newIndexPath;
    }
    
    else if ([[json_Response_Dic valueForKey:@"bannerLarge"]count]  > INDX_selected.row)
    {
        if ([[json_Response_Dic valueForKey:@"bannerLarge"]count] == INDX_selected.row + 1) {
            newIndexPath = [NSIndexPath indexPathForRow:[[json_Response_Dic valueForKey:@"bannerLarge"]count] - 1 inSection:0];
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
    
    
    [_collection_features scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:INDX_selected.row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
-(void)BTN_left_action
{
    @try
    {
        NSIndexPath *newIndexPath;
        if (INDX_selected)
        {
            newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row -1 inSection:0];
            INDX_selected = newIndexPath;
        }
        
        else if ([[json_Response_Dic valueForKey:@"bannerLarge"]count]  < INDX_selected.row)
        {
            if ([[json_Response_Dic valueForKey:@"bannerLarge"]count] == INDX_selected.row - 1)
            {
                newIndexPath = [NSIndexPath indexPathForRow:[[json_Response_Dic valueForKey:@"bannerLarge"]count] + 1 inSection:0];
                INDX_selected = newIndexPath;
            }
            else
            {
                newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row - 1 inSection:0];
                INDX_selected = newIndexPath;
            }
        }
        if (newIndexPath.row == 1)
        {
            newIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            INDX_selected = newIndexPath;
        }
        if(newIndexPath.row < 1)
        {
            newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            INDX_selected = newIndexPath;
        }
        [_collection_features scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:INDX_selected.row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    
    @catch (NSException *exception)
    {
        NSLog(@"exception:%@",exception);
    }
    
}


#pragma Button ACTIONS
-(void)movies_ACTIOn
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"header_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"QTickets_identifier" sender:self];
    
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
    
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        
        _VW_swipe.frame = CGRectMake(self.view.frame.size.width-_VW_swipe.frame.size.width, self.navigationController.view.frame.origin.y + statusbar_HEIGHT, _menuDraw_width, self.navigationController.view.frame.size.height-statusbar_HEIGHT);
        
        
    }
    else{
        _VW_swipe.frame = CGRectMake(0, self.navigationController.view.frame.origin.y + statusbar_HEIGHT, _menuDraw_width, self.navigationController.view.frame.size.height-statusbar_HEIGHT);
    }
    
    
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
        
        // int statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
        statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            _VW_swipe.frame = CGRectMake(self.view.frame.size.width-_VW_swipe.frame.size.width, self.navigationController.view.frame.origin.y +statusbar_HEIGHT, _menuDraw_width, self.navigationController.view.frame.size.height-statusbar_HEIGHT);
        }
        else{
            _VW_swipe.frame = CGRectMake(0, self.navigationController.view.frame.origin.y +statusbar_HEIGHT, _menuDraw_width, self.navigationController.view.frame.size.height-statusbar_HEIGHT);
        }
        
        
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
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            _VW_swipe.frame = CGRectMake(self.view.frame.size.width-_VW_swipe.frame.size.width, self.navigationController.view.frame.origin.y +statusbar_HEIGHT, _menuDraw_width, self.navigationController.view.frame.size.height-statusbar_HEIGHT);
        }else{
            
            _VW_swipe.frame = CGRectMake(0, self.navigationController.view.frame.origin.y + 20, _menuDraw_width, self.navigationController.view.frame.size.height-statusbar_HEIGHT);
        }
        
        
        
        
        [UIView commitAnimations];
        
    }
    
}

#pragma API call
-(void)movie_API_CALL
{
    @try
    {
        
      
        [HttpClient animating_images:self];
        
        NSURL *URL = [[NSURL alloc] initWithString:@"https://api.q-tickets.com/V2.0/GetMoviesbyLangAndTheatreid"];
        NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
        //NSLog(@"Response dictionary: %@", xmlDoc);
        
        temp_dicts = [xmlDoc valueForKey:@"Movies"];
        NSMutableArray *tmp_arr = [temp_dicts valueForKey:@"movie"];
        NSMutableArray *langs_arr = [[NSMutableArray alloc]init];
        NSMutableArray *halls_arrs = [[NSMutableArray alloc]init];
        NSMutableArray *halls_ar = [[NSMutableArray alloc]init];
        
        
        
        
        //NSLog(@"Response dictionary: %@", tmp_arr);
        NSArray *old_arr = tmp_arr;//[json_RESULT mutableCopy];
        
        for(int  i=0;i<old_arr.count;i++)
        {
            [langs_arr addObject:[[old_arr objectAtIndex:i] valueForKey:@"_Languageid"]];
            [halls_arrs addObject:[[[old_arr objectAtIndex:i]valueForKey:@"Theatre"] valueForKey:@"_name"]];
            
          
        }
        [langs_arr sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        
        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:langs_arr];
      
        langugage_arr = [orderedSet array];
        
        for (int k= 0; k<halls_arrs.count; k++)
        {
            @try
            {
            for(int m= 0 ;m<[[halls_arrs objectAtIndex:k] count];m++)
            {
                [halls_ar addObject:[[halls_arrs objectAtIndex:k]objectAtIndex:m]];
            }
            }
            @catch(NSException *exception)
            {
                [halls_ar addObject:[halls_arrs objectAtIndex:k]];
            }
        }
        [halls_ar sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
          NSOrderedSet *orderedSet1 = [NSOrderedSet orderedSetWithArray:halls_ar];
        
        halls_arr = [orderedSet1 array];
        
        
        NSMutableArray *new_arr = [[NSMutableArray alloc]init];
        
        int count = (int)[old_arr count];
        int index = 0;
        
        int tags = 0;
        
        for (int i = 0; i < count; )
        {
            i= i+1;
            if ((i % 5) == 0 && i != 0)
            {
                NSDictionary *tmp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Qtickets",@"Movies", nil];
                [new_arr addObject:tmp_dictin];
                count = count + 1;
                tags = tags + 1;
            }
            else
            {
                index = i - tags - 1;
                [new_arr addObject:[old_arr objectAtIndex:index]];
            }
        }
        [HttpClient stop_activity_animation];
        
//        VW_overlay.hidden = YES;
//        [activityIndicatorView stopAnimating];
        [Movies_arr removeAllObjects];
        Movies_arr = [new_arr mutableCopy];
        [_Collection_movies reloadData];
        [_collection_showing_movies reloadData];
        
        NSLog(@"%lu",(unsigned long)Movies_arr.count);
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception%@",exception);
    }
    
   
}

-(void)API_movie
{
//    VW_overlay.hidden = NO;
//    [activityIndicatorView startAnimating];
    
    [self performSelector:@selector(movie_API_CALL) withObject:nil afterDelay:0.01];
    
}
#pragma ShopHome_api_integration Method Calling

-(void)API_call_total
{
    
    @try
    {
        [HttpClient animating_images:self];
        
        /**********   After passing Language Id and Country ID ************/
        NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
        deals_ARR = [[NSMutableArray alloc]init];
        hot_deals_ARR = [[NSMutableArray alloc]init];
        deals_ARR = [[NSMutableArray alloc]init];
        NSDictionary *dict = [user_defaults valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@Pages/home/%ld/%ld/%@/Customer.json",SERVER_URL,(long)[user_defaults   integerForKey:@"country_id"],[user_defaults integerForKey:@"language_id"],user_id];
        NSLog(@"%ld,%ld",[user_defaults integerForKey:@"country_id"],[user_defaults integerForKey:@"language_id"]);
        
     
        
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
//                    [activityIndicatorView stopAnimating];
//                    VW_overlay.hidden = YES;

                    [HttpClient stop_activity_animation];
                }
                if (data) {
                
                    [HttpClient stop_activity_animation];
//                    VW_overlay.hidden=YES;
//                    [activityIndicatorView stopAnimating];
                    @try {
                       @try
                        {
                          [self MENU_api_call];
                        }
                        @catch(NSException *Exception)
                        {
                            
                        }
                        
                        [self brands_API_call];
                        json_Response_Dic = data;
                        [self movie_API_CALL];
                      
                        image_Top_ARR = [[NSMutableArray alloc]init];
                     
                         NSLog(@"the api_collection_product%@",json_Response_Dic);
                        
                        for(int  i= 0; i<[[json_Response_Dic valueForKey:@"banners"]count];i++)
                        {
                            [image_Top_ARR addObject:[[json_Response_Dic valueForKey:@"banners"]objectAtIndex:i]];
                        }
                        
                        [image_Top_ARR addObject:@"banner_main.png"];
                        for(int i=0 ; i < [[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"one"] allKeys] count];i++)
                        {
                            if([[[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"one"] allKeys] objectAtIndex:i] isEqualToString:@"widgetTitle"])
                            {
                                
                            }
                            else
                            {
                                [deals_ARR addObject:[[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"one"] allObjects] objectAtIndex:i]];
                                
                            }
                            
                            
                        }
                        for(int i=0 ; i < [[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"two"] allKeys] count];i++)
                        {
                            if([[[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"two"] allKeys] objectAtIndex:i] isEqualToString:@"widgetTitle"])
                            {
                                
                            }
                            else
                            {
                                [hot_deals_ARR addObject:[[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"one"] allObjects] objectAtIndex:i]];
                                
                            }
                            
                            
                        }

                        NSString *currency = [json_Response_Dic valueForKey:@"currency"];
                        currency = [currency stringByReplacingOccurrencesOfString:@"(null)" withString:@"QAR"];
                        currency = [currency stringByReplacingOccurrencesOfString:@"<null>" withString:@"QAR"];
                        currency = [currency stringByReplacingOccurrencesOfString:@"" withString:@"QAR"];


                        [[NSUserDefaults standardUserDefaults] setValue:currency forKey:@"currency"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [_collection_images reloadData];
                        [self set_timer_to_collection_images];
                        [_collection_features reloadData];
                        [_collection_hot_deals reloadData];
                        [_collection_best_deals reloadData];
                        [_collection_fashion_categirie reloadData];
                        [self menu_set_UP];
                         [self set_up_VIEW];
                      
                        [HttpClient stop_activity_animation];
//                        VW_overlay.hidden=YES;
//                        [activityIndicatorView stopAnimating];

                       

                       
                       
                    } @catch (NSException *exception) {
                        NSLog(@"%@",exception);
//                        VW_overlay.hidden=YES;
//                        [activityIndicatorView stopAnimating];
                        [HttpClient stop_activity_animation];
                        [self viewWillAppear:NO];
                     


                    }
                }
                    else
                    {
                        [HttpClient stop_activity_animation];
//                        VW_overlay.hidden = YES;
//                        [activityIndicatorView stopAnimating];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];
                        [self viewWillAppear:NO];
                       


                    }
                
                [HttpClient stop_activity_animation];
                
            });
        }];
    }
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
//        VW_overlay.hidden = YES;
//        [activityIndicatorView stopAnimating];
        [self viewWillAppear:NO];
        
        [HttpClient stop_activity_animation];
        
    }
    
    
}

-(void)BTN_log_outs
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userdata"];
    [[NSUserDefaults standardUserDefaults] synchronize];
      if([_BTN_log_out.titleLabel.text isEqualToString:@"LOGIN"])
    {
        [self swipe_left];
        ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login_VC"];
        [self presentViewController:login animated:NO completion:nil];

        
    }
    else
    {
         [self swipe_left];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userdata"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Thank you! See you soon!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];

//        VW_overlay.hidden = NO;
//        [activityIndicatorView startAnimating];
        
               [self performSelector:@selector(API_call_total) withObject:nil afterDelay:0.01];

    }
    
}
- (IBAction)filter_action:(id)sender {
    [self performSegueWithIdentifier:@"events_filter" sender:self];
}
#pragma mark - UIPickerViewDataSource

// #3
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == _halls_picker) {
        return 1;
    }
    else if(pickerView==_lang_picker)
    {
        return 1;
    }
    else if(pickerView==_venue_picker)
    {
        return 1;
    }
    else if(pickerView==_sports_venue_picker)
    {
        return 1;
     }
    else if(pickerView==_leisure_venues)
    {
        return 1;
    }
    else if(pickerView == _lang_pickers)
    {
        return 1;
    }


    return 0;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _halls_picker) {
        return [halls_arr count];
    }
    if (pickerView == _lang_picker) {
        return [langugage_arr count];
    }
    else if (pickerView == _venue_picker) {
        return [venues_arr count];
    }
    else if (pickerView == _sports_venue_picker) {
        return [sports_venues count];
    }
    else if (pickerView == _leisure_venues) {
        return [leisure_venues count];
    }
    else if(pickerView == _lang_pickers)
    {
        NSLog(@"The language is:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]);
        return [[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]count];
    }

    return 0;
}

#pragma mark - UIPickerViewDelegate


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == _halls_picker) {
        return halls_arr[row];
    }
    if (pickerView == _lang_picker) {
        return langugage_arr[row];
    }
    if (pickerView == _venue_picker) {
        return venues_arr[row];
    }
    else if (pickerView == _sports_venue_picker) {
        return sports_venues[row];
    }
    else if (pickerView == _leisure_venues) {
        return leisure_venues[row];
    }
    else if(pickerView == _lang_pickers)
    {
        language = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]objectAtIndex:row ] valueForKey:@"language_name"];

        return [[[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]objectAtIndex:row ] valueForKey:@"language_name"];
    }


    
    return nil;
}

// #6
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == _lang_pickers)
    {
    
        language = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]objectAtIndex:row ] valueForKey:@"language_name"];
        
        
    }
    
}
-(void)btn_address_action
{
    [self swipe_left];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please login to access this" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        alert.tag = 1;
        [alert show];
        
    }
    else
    {

       // home_bookings
        [self performSegueWithIdentifier:@"home_bookings" sender:self];

    }
}
-(void)btn_orders_action
{
    [self swipe_left];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please login to access this" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        alert.tag = 1;
        [alert show];
        
    }
    else
    {

    [self performSegueWithIdentifier:@"my_orders" sender:self];
    }
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}
#pragma mark Add_to_wishList_API Calling
-(void)hot_dels_wishlist:(UIButton *)sender
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *str_id = @"user_id";
    NSString *user_id;
    for(int i = 0;i<[[dict allKeys] count];i++)
    {
        if([[[dict allKeys] objectAtIndex:i] isEqualToString:str_id])
        {
            user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:str_id]];
            break;
        }
        else
        {
            
            user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        }
        
    }
    if([user_id isEqualToString:@"(null)"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please login to add items to wishlist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        alert.tag = 1;
        [alert show];
        
    }
    else
    {
        
        if ([sender.titleLabel.text isEqualToString:@""]) {
            NSString *str_id = [NSString stringWithFormat:@"%@",[[hot_deals_ARR objectAtIndex:sender.tag] valueForKey:@"id"]];
                [self hot_delete_from_wishLis:str_id];
        }
        else
        {


    NSString *urlGetuser;
    @try
    {
//    urlGetuser =[NSString stringWithFormat:@"%@apis/addToWishList/%@/%@.json",SERVER_URL,[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:sender.tag] valueForKey:@"ProductDescriptions"]valueForKey:@"id"],user_id];
        
        
        urlGetuser =[NSString stringWithFormat:@"%@apis/addToWishList/%@/%@.json",SERVER_URL,[[hot_deals_ARR objectAtIndex:sender.tag] valueForKey:@"product_id"],user_id];
    }
    @catch(NSException *exception)
    {
        
    }
   
    @try
    {
       
        [HttpClient animating_images:self];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    
//                    VW_overlay.hidden=YES;
//                    [activityIndicatorView stopAnimating];
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                if (data) {
                   NSDictionary  *json_Response = data;
                    if(json_Response)
                    {
                        
                        [HttpClient stop_activity_animation];
                        
//                        VW_overlay.hidden=YES;
//                        [activityIndicatorView stopAnimating];
                        
                        NSLog(@"The Wishlist %@",json_Response);
                        NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];
                        product_cell *cell = (product_cell *)[self.collection_hot_deals cellForItemAtIndexPath:index];
                        
                        
                        @try {
                            if ([[json_Response valueForKey:@"msg"] isEqualToString:@"add"])
                            {
                                
                                //  [self startAnimation:sender];
                              
                                [cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                                
                                [cell.BTN_fav setTitleColor: [UIColor colorWithRed:0.91 green:0.21 blue:0.00 alpha:1.0] forState:UIControlStateNormal];
                                [HttpClient createaAlertWithMsg:@"Added to your wishlist" andTitle:@""];
                                
                                
                            }
                            else
                            {
                                
                                [cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            }
                        }
                            @catch(NSException *exception)
                            {
                                [HttpClient stop_activity_animation];
                                
//                                VW_overlay.hidden=YES;
//                                [activityIndicatorView stopAnimating];

                            }
                        

                        
                        
                    }
                    else
                    {
                        [HttpClient stop_activity_animation];
//                        VW_overlay.hidden=YES;
//                        [activityIndicatorView stopAnimating];
                        
                        
                        
                    }
                    
                    
                }
                
            });
        }];
    }
    @catch(NSException *exception)
    {
        
        [HttpClient stop_activity_animation];
//        VW_overlay.hidden=YES;
//        [activityIndicatorView stopAnimating];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
      

    }
    

   
    }
    }
   
}
-(void)hot_delete_from_wishLis:(NSString *)pd_id
{
    
    /* Del WishList
     
     http://192.168.0.171/dohasooq/apis/delFromWishList/1/24.json
     
     example
     Product_id =1
     User_Id = 24
     
     */
    
    [HttpClient animating_images:self];
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_ID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/delFromWishList/%@/%@.json",SERVER_URL,pd_id,user_ID];
    
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    @try {
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [HttpClient stop_activity_animation];
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    NSLog(@"%@",data);
                    
                    [HttpClient stop_activity_animation];
                    if([[dict valueForKey:@"msg"] isEqualToString:@"del"])
                        
                        @try {
                            
                            [HttpClient createaAlertWithMsg:@"Item deleted Succesfully"andTitle:@""];
                            [self API_call_total];
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                            
                        }
                    
                }
                
            });
            
        }];
    } @catch (NSException *exception) {
        [HttpClient stop_activity_animation];
        
        NSLog(@"%@",exception);
        
    }
}

-(void)best_dels_wishlist:(UIButton *)sender
{
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *str_id = @"user_id";
    NSString *user_id;
    for(int i = 0;i<[[dict allKeys] count];i++)
    {
        if([[[dict allKeys] objectAtIndex:i] isEqualToString:str_id])
        {
            user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:str_id]];
            break;
        }
        else
        {
            
            user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        }
        
    }
    if([user_id isEqualToString:@"(null)"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please login to add items to wishlist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
        alert.tag = 1;
        [alert show];
        
    }
    else
    {
        

    NSString *urlGetuser;
    @try
    {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        
        NSLog(@"Sender ...........%ld",(long)[sender tag]);
        
        
        [HttpClient animating_images:self];
        
     urlGetuser =[NSString stringWithFormat:@"%@apis/addToWishList/%@/%@.json",SERVER_URL,[[deals_ARR objectAtIndex:sender.tag] valueForKey:@"product_id"],user_id];
        
         NSLog(@"URL ...........%@",urlGetuser);
        
            NSError *error;
            
            NSHTTPURLResponse *response = nil;
        
            NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:urlProducts];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            [request setHTTPShouldHandleCookies:NO];
            NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if(aData)
            {
                
                
                NSMutableArray *json_DATA = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingAllowFragments error:&error];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];
                product_cell *cell = (product_cell *)[self.collection_best_deals cellForItemAtIndexPath:index];
                
                
                @try {
                    if ([[json_DATA valueForKey:@"msg"] isEqualToString:@"Added to your Wishlist"]) {
                        
                        //  [self startAnimation:sender];
                        [cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                        
                        [cell.BTN_fav setTitleColor:[UIColor colorWithRed:0.91 green:0.21 blue:0.00 alpha:1.0] forState:UIControlStateNormal];
                        [HttpClient createaAlertWithMsg:@"Added to your wishlist" andTitle:@""];
                        
                        
                    }
                    else{
                        
                        [cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                }
                @catch(NSException *exception)
                {
                }
                
                  [HttpClient stop_activity_animation];
                
                NSLog(@"the api_collection_product%@",json_DATA);
//                [activityIndicatorView stopAnimating];
//                VW_overlay.hidden = YES;
                
            }
        }
        @catch(NSException *exception)
        {
            NSLog(@"%@",exception);
            [HttpClient stop_activity_animation];
//            [activityIndicatorView stopAnimating];
//            VW_overlay.hidden = YES;
        }

    @catch(NSException*exception)
    {
       
    }
    
    }
    
}

#pragma IMAGE ACTIONS
-(void)hot_deals_action
{
    [[NSUserDefaults standardUserDefaults] setValue:[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0]objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"title"] forKey:@"item_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *user_id = [NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        user_id = @"0";
    }
    
    
    NSString *url_key = [NSString stringWithFormat:@"%@",[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0]objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"title"]];
    NSString *list_TYPE = @"dealsList";
    url_key = [NSString stringWithFormat:@"%@/%@",list_TYPE,url_key];
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/Customer/1.json",SERVER_URL,url_key,country,languge,user_id];
  
     [[NSUserDefaults standardUserDefaults] setValue:url_key forKey:@"product_list_key"];
    
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];


}
-(void)best_deals_action
{
    
    [[NSUserDefaults standardUserDefaults] setValue:[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0]objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"title"] forKey:@"item_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   // http://192.168.0.171/dohasooq/apis/dealsList/Best%20Selling%20Products/(null)/(null)/27/Customer.json
    
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *user_id = [NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        user_id = @"0";
    }
    
    
    NSString *url_key = [NSString stringWithFormat:@"%@",[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0]objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"title"]];
    NSString *list_TYPE = @"dealsList";
    url_key = [NSString stringWithFormat:@"%@/%@",list_TYPE,url_key];
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/Customer/1.json",SERVER_URL,url_key,country,languge,user_id];
    
     [[NSUserDefaults standardUserDefaults] setValue:url_key forKey:@"product_list_key"];
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];

}
-(void)brands_API_call
{
    
    @try
    {
        [HttpClient animating_images:self];
        
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
            [HttpClient stop_activity_animation];
            
            brands_arr= (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            [[NSUserDefaults standardUserDefaults] setObject:brands_arr forKey:@"brands_LIST"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            
            [self.collection_brands reloadData];
            NSLog(@"The response Api form Brands%@",brands_arr);
            
            
        }
        else
        {
//            VW_overlay.hidden=YES;
//            [activityIndicatorView stopAnimating];
            [HttpClient stop_activity_animation];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Some thing went to wrong please try again later" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        
        [HttpClient stop_activity_animation];
    }
    
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
      _Hot_deals.text = [NSString stringWithFormat:@"Men's %@",[json_Response_Dic valueForKey:@"fashion_name"]];//@"MEN'S FASHION ACCESORIES";
      [_collection_brands reloadData];
      
  }
  else
  {
      _IMG_Person_banner.image = [UIImage imageNamed:@"upload-4"];
      _IMG_Things_banner.image = [UIImage imageNamed:@"bag"];
      [_BTN_fashion setBackgroundImage:[UIImage imageNamed:@"women_logo"] forState:UIControlStateNormal];
      [_BTN_fashion setTag:1];
      [self brands_API_call];
      _Hot_deals.text = [NSString stringWithFormat:@"Women's %@",[json_Response_Dic valueForKey:@"fashion_name"]];
       [_collection_brands reloadData];

  }
    
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 2)
    {
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"country_id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"language_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        VC_intial *intial = [self.storyboard instantiateViewControllerWithIdentifier:@"intial_VC"];
        [self presentViewController:intial animated:NO completion:nil];

   
    }

    else{
       
        NSLog(@"cancel:");

    }
    }
    else if(alertView.tag == 1)
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
-(void)Total_search
{
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"];
    
    NSString *list_TYPE = @"productList";
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/0/%@/%@/%@/Customer.json",SERVER_URL,list_TYPE,country,languge,user_id];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];
    

    
}

-(void)MENU_api_call
{
    
    @try
    {
        [HttpClient animating_images:self];
        
        NSError *error;
        
        NSHTTPURLResponse *response = nil;
        NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
        //    NSString *urlGetuser =[NSString stringWithFormat:@"%@menuList/%ld/%ld.json",SERVER_URL,(long)[user_defaults   integerForKey:@"country_id"],[user_defaults integerForKey:@"language_id"]];
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *lang = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/menuList/%@/%@.json",SERVER_URL,country,lang];
        
        NSLog(@"%ld,%ld",(long)[user_defaults integerForKey:@"country_id"],(long)[user_defaults integerForKey:@"language_id"]);
        
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(aData)
        {
            
            
            NSMutableArray *json_DATA = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            
            [[NSUserDefaults standardUserDefaults] setObject:json_DATA forKey:@"pho"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
           // [self performSegueWithIdentifier:@"logint_to_home" sender:self];
            
            NSLog(@"the api_collection_product%@",json_DATA);
            [HttpClient stop_activity_animation];
            

            
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
        
        [HttpClient stop_activity_animation];
        
//        [activityIndicatorView stopAnimating];
//        VW_overlay.hidden = YES;
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == _TXT_search)
    {
     [self performSegueWithIdentifier:@"home_dohasooq_search" sender:self];
    }
}

-(void)cart_count{
    
    NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
    [HttpClient cart_count:user_id completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        if (error) {
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
             ];
//            VW_overlay.hidden = YES;
//            [activityIndicatorView stopAnimating];
            

        }
        if (data) {
            NSLog(@"%@",data);
            NSDictionary *dict = data;
            @try {
               
                NSString *badge_value = [NSString stringWithFormat:@"%@",[dict valueForKey:@"cartcount"]];
             //   NSString *wishlist = [NSString stringWithFormat:@"%@",[dict valueForKey:@"wishlistcount"]];
                
                //NSString *badge_value = @"11";
                if([badge_value intValue] < 1)
                {
                    _BTN_cart.badgeBackgroundColor = [UIColor whiteColor];
                    
                }
               else if([badge_value intValue] > 0 )
                {
                    @try
                    {
                        
                        [_BTN_cart setBadgeEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 4)];
                    }
                    @catch(NSException *exception)
                    {
                        
                    }

                    _BTN_cart.badgeBackgroundColor =  [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];
                    [_BTN_cart setBadgeString:[NSString stringWithFormat:@"%@",badge_value]];
                    
                    
                }
                else{
                    @try
                    {
                        
                        [_BTN_cart setBadgeEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 4)];
                    }
                    @catch(NSException *exception)
                    {
                        
                    }

                    _BTN_cart.badgeBackgroundColor =  [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];

                    [_BTN_cart setBadgeString: [NSString stringWithFormat:@"%@",badge_value]];
                    
                    
                }
                
                
            } @catch (NSException *exception) {
//                 VW_overlay.hidden = YES;
//                [activityIndicatorView stopAnimating];
               

                NSLog(@"%@",exception);
            }
            
        }
    }];
}

#pragma mark TimerMethod
-(void)set_timer_to_collection_images{
    
    
    [NSTimer scheduledTimerWithTimeInterval:10
                                     target:self
                                   selector:@selector(scrolling_image:)
                                   userInfo:nil
                                    repeats:YES];
    mn=0;
    
}

-(void)scrolling_image:(NSTimeInterval *)timer{
    
    
    @try {
        mn ++;
        if (mn==image_Top_ARR.count) {
            mn=0;
        }
        NSIndexPath *newIndexPath=[NSIndexPath indexPathForRow:mn inSection:0];
        
        
        [self.custom_story_page_controller setCurrentPage:mn];
        [_collection_images scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
    
    
    
}
- (IBAction)Close_ACTION:(id)sender
{
      [self swipe_left];
}
-(void)TOP_action
{
    [self.Scroll_contents setContentOffset:CGPointZero animated:YES];
}
-(void)seacrh_ACTION
{
    [self performSegueWithIdentifier:@"home_dohasooq_search" sender:self];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*CGSize result = [[UIScreen mainScreen] bounds].size;
 
 NSRange ename = [text rangeOfString:need_sign];
 
 
 if(result.height <= 480)
 {
 // iPhone Classic
 [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0]}
 range:ename];
 }
 else if(result.height <= 568)
 {
 // iPhone 5
 [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0]}
 range:ename];
 }
 else
 {
 [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:17.0]}
 range:ename];
 }*/
@end
