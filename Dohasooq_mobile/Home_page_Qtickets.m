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






@interface Home_page_Qtickets ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *temp_arr,*temp_hot_deals,*fashion_categirie_arr,*brands_arr,*ARR_category,*lang_arr,*image_Top_ARR,*search_ARR;
    NSIndexPath *INDX_selected;
    NSInteger j,lang_count;
    int tag,collection_tag;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    VC_home *home;
    NSMutableDictionary *json_Response_Dic;
    float scroll_ht;
    NSMutableArray *Movies_arr,*Events_arr,*Sports_arr,*Leisure_arr;
    NSArray *langugage_arr,*halls_arr,*venues_arr,*sports_venues,*leisure_venues,*menu_arr;
    NSString *halls_text,*leng_text;

    NSDictionary *temp_dicts;
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
    
   search_ARR =  [[NSMutableArray alloc]init];
    [self.collection_images registerNib:[UINib nibWithNibName:@"cell_image" bundle:nil]  forCellWithReuseIdentifier:@"collection_image"];
    [self.collection_features registerNib:[UINib nibWithNibName:@"cell_features" bundle:nil]  forCellWithReuseIdentifier:@"features_cell"];
    [self.collection_showing_movies registerNib:[UINib nibWithNibName:@"cell_features" bundle:nil]  forCellWithReuseIdentifier:@"showing_movies_cell"];
     [self.collection_hot_deals registerNib:[UINib nibWithNibName:@"product_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_product"];
     [self.collection_best_deals registerNib:[UINib nibWithNibName:@"product_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_product"];
    [self.collection_fashion_categirie registerNib:[UINib nibWithNibName:@"Fashion_categorie_cell" bundle:nil]  forCellWithReuseIdentifier:@"fashion_categorie"];

    
     [self.Collection_movies registerNib:[UINib nibWithNibName:@"Movies_cell" bundle:nil]  forCellWithReuseIdentifier:@"movie_cell"];
    
    [self.Collection_movies registerNib:[UINib nibWithNibName:@"Image_qtickets" bundle:nil]  forCellWithReuseIdentifier:@"Image_qtickets"];
    [self.Collection_movies registerNib:[UINib nibWithNibName:@"upcoming_cell" bundle:nil]  forCellWithReuseIdentifier:@"upcoming_cell"];
    @try
    {
    
    [_BTN_cart setBadgeEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 4)];
    }
    @catch(NSException *exception)
    {
        
    }

    
    tag =0;
    
    leng_text = @"LANGUAGES";
    halls_text =@"THEATERS";
    _Hot_deals.text = @"WOMEN'S FASHION ACCESORIES";
   
  
 
  //  Leisure_arr = [[NSMutableArray alloc] init];
    //Sports_arr = [[NSMutableArray alloc] init];
  //  Events_arr = [[NSMutableArray alloc] init];

    
    [self ATTRIBUTE_TEXT];
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
    
       
    //[self Sports_API_call];
   //[self Leisure_API_call];
    
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    //    VW_overlay.layer.cornerRadius = 10.0;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    VW_overlay.center = self.view.center;
    [self.navigationController.view addSubview:VW_overlay];
    VW_overlay.hidden = YES;
    
   
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(API_call_total) withObject:activityIndicatorView afterDelay:0.01];
  
  
    [self set_up_VIEW];
    

   

   
    
    
   // self.Tab_MENU.selectedItem = nil;
}
-(void)picker_view_set_UP
{
    _halls_picker = [[UIPickerView alloc] init];
    _halls_picker.delegate = self;
    _halls_picker.dataSource = self;
    _lang_picker = [[UIPickerView alloc] init];
    _lang_picker.delegate = self;
    _lang_picker.dataSource = self;
     _venue_picker= [[UIPickerView alloc] init];
    _venue_picker.delegate = self;
    _venue_picker.dataSource = self;
    _leisure_venues= [[UIPickerView alloc] init];
    _leisure_venues.delegate = self;
    _leisure_venues.dataSource = self;
    _sports_venue_picker= [[UIPickerView alloc] init];
    _sports_venue_picker.delegate = self;
    _sports_venue_picker.dataSource = self;
    
    
    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(tappedToSelectRow:)];
    tapToSelect.delegate = self;
    [_halls_picker addGestureRecognizer:tapToSelect];
    UITapGestureRecognizer *satetap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(tappedToSelectRowstate:)];
    satetap.delegate = self;
    [_lang_picker addGestureRecognizer:satetap];
    UITapGestureRecognizer *venue_tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(tappedToSelectRowsvenue:)];
    venue_tap.delegate = self;
    [_venue_picker addGestureRecognizer:venue_tap];

    
    
    
    UIToolbar* conutry_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    conutry_close.barStyle = UIBarStyleBlackTranslucent;
    [conutry_close sizeToFit];
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(conutry_close.frame.size.width - 100, 0, 100, conutry_close.frame.size.height);
    [close setTitle:@"close" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(countrybuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [conutry_close addSubview:close];
    _BTN_all_lang.inputAccessoryView=conutry_close;
    _BTN_all_halls.inputAccessoryView=conutry_close;
    _BTN_leisure_venues.inputAccessoryView = conutry_close;
    _BTN_sports_venues.inputAccessoryView = conutry_close;
    _BTN_venues.inputAccessoryView=conutry_close;
    self.BTN_all_lang.inputView = _lang_picker;
    self.BTN_all_halls.inputView=_halls_picker;
    _BTN_venues.inputView = _venue_picker;
    _BTN_leisure_venues.inputView = _leisure_venues;
     _BTN_sports_venues.inputView = _sports_venue_picker;
    _BTN_all_lang.tintColor=[UIColor clearColor];
    _BTN_all_halls.tintColor=[UIColor clearColor];
     _BTN_venues.tintColor=[UIColor clearColor];
    _BTN_sports_venues.tintColor=[UIColor clearColor];
    _BTN_leisure_venues.tintColor=[UIColor clearColor];

}
-(void)countrybuttonClick
{
    [self.BTN_all_lang resignFirstResponder];
    [self.BTN_all_halls resignFirstResponder];
    [_BTN_sports_venues resignFirstResponder];
    [_BTN_leisure_venues resignFirstResponder];
    [_BTN_venues resignFirstResponder];
}

-(void)Events_view
{
     _Scroll_contents.hidden = YES;
    _VW_event.hidden = NO;
    CGRect frameset = _VW_event.frame;
    frameset.origin.y = _Tab_MENU.frame.origin.y + _Tab_MENU.frame.size.height;
    frameset.size.height = self.view.frame.size.height - _Tab_MENU.frame.origin.y  - _Tab_MENU.frame.size.height;
    frameset.size.width =  self.view.frame.size.width;
    _VW_event.frame = frameset;
    [self.view addSubview:_VW_event];
    
    
    
}
-(void)Movies_view
{
    
   // [self API_movie];
    
    _Scroll_contents.hidden = YES;
    _VW_Movies.hidden = NO;
    CGRect frameset = _VW_Movies.frame;
    frameset.origin.y = _Tab_MENU.frame.origin.y + _Tab_MENU.frame.size.height;
    frameset.size.height = self.view.frame.size.height - _Tab_MENU.frame.origin.y  - _Tab_MENU.frame.size.height;
    frameset.size.width =  self.view.frame.size.width;
    _VW_Movies.frame = frameset;
    [self.view addSubview:_VW_Movies];
    

    
    
}
-(void)Leisure_view
{
    
     _Scroll_contents.hidden = YES;
    _VW_Leisure.hidden = NO;
    CGRect frameset = _VW_Leisure.frame;
    frameset.origin.y = _Tab_MENU.frame.origin.y + _Tab_MENU.frame.size.height;
    frameset.size.height = self.view.frame.size.height - _Tab_MENU.frame.origin.y  - _Tab_MENU.frame.size.height;
    frameset.size.width =  self.view.frame.size.width;
    _VW_Leisure.frame = frameset;
    [self.view addSubview:_VW_Leisure];
}
-(void)Sports_view
{
    
     _Scroll_contents.hidden = YES;
    _VW_sports.hidden = NO;
    CGRect frameset = _VW_sports.frame;
    frameset.origin.y = _Tab_MENU.frame.origin.y + _Tab_MENU.frame.size.height;
    frameset.size.height = self.view.frame.size.height - _Tab_MENU.frame.origin.y  - _Tab_MENU.frame.size.height;
    frameset.size.width =  self.view.frame.size.width;
    _VW_sports.frame = frameset;
    [self.view addSubview:_VW_sports];
    
    
}
//-(void)Shop_view
//{
//     _Scroll_contents.hidden = YES;
//    home = [self.storyboard instantiateViewControllerWithIdentifier:@"shop_home"];
//     home.delegate = self;
//    home.view.frame = CGRectMake(0, _Tab_MENU.frame.origin.y + _Tab_MENU.frame.size.height , self.Scroll_contents.frame.size.width,self.Scroll_contents.frame.size.height-20 );
//    self.Scroll_contents.hidden =YES;
//    [self.view addSubview:home.view];
//    
//    
//}

-(void)ATTRIBUTE_TEXT
{
    NSString *str = @"";
    NSString *text = [NSString stringWithFormat:@"VENUES %@",str];
    if ([_BTN_venues respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_BTN_venues.textColor,
                                  NSFontAttributeName: _BTN_venues.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
        
        
        NSRange ename = [text rangeOfString:str];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:15.0]}
                                    range:ename];
        }
        _BTN_venues.attributedText = attributedText;
    }
    else
    {
         _BTN_venues.text = text;
    }
    
    
    NSString *lang = @"";
    
    NSString *lang_text = [NSString stringWithFormat:@"%@ %@",leng_text,lang];
    
    
    if ([_BTN_all_lang respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_BTN_all_lang.textColor,
                                  NSFontAttributeName: _BTN_all_lang.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:lang_text attributes:attribs];
        
        
        
        NSRange ename = [lang_text rangeOfString:lang];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:15.0],NSForegroundColorAttributeName :[UIColor grayColor]}
                                    range:ename];
        }
        _BTN_all_lang.attributedText = attributedText;
    }
    else
    {
         _BTN_all_lang.text = text;
    }
    NSString *cinema = @"";
    NSString *cinema_text = [NSString stringWithFormat:@"%@ %@",halls_text,cinema];
    
    
    if ([_BTN_all_halls respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_BTN_all_lang.textColor,
                                  NSFontAttributeName: _BTN_all_lang.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:cinema_text attributes:attribs];
        
        
        
        NSRange ename = [cinema_text rangeOfString:cinema];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0],NSForegroundColorAttributeName :[UIColor grayColor]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:15.0],NSForegroundColorAttributeName :[UIColor grayColor]}
                                    range:ename];
        }
        _BTN_all_halls.attributedText = attributedText;
    }
    else
    {
        _BTN_all_halls.text = text;
    }
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item

{
    
    CGFloat highlightedWidth = self.view.frame.size.width/_Tab_MENU.items.count;
    [_Tab_MENU setItemWidth:highlightedWidth];
    CGRect rect = CGRectMake(0, 0, highlightedWidth, _Tab_MENU.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.85 green:0.56 blue:0.04 alpha:1.0] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _Tab_MENU.selectionIndicatorImage = img;
    
    if([item.title isEqualToString:@"Events"])
    {
        
        if(_VW_sports.hidden == YES || _VW_Movies.hidden == YES || home.view.hidden == YES|| _VW_Leisure.hidden == YES)
        {
            
            [self Events_view];
        }
        else
        {
            self.VW_sports.hidden = YES;
            _VW_Movies.hidden = YES;
            home.view.hidden = YES;
            _VW_Leisure.hidden =YES;
            [self Events_view];
            
        }
        [self.VW_event addSubview:VW_overlay];
        
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(Events_API_CALL) withObject:activityIndicatorView afterDelay:0.01];
        
        [self Event_API_CALL];
        
        [self ATTRIBUTE_TEXT];
        
    }
    else if([item.title isEqualToString:@"Sports"])
    {
        
        if(_VW_event.hidden == YES || _VW_Movies.hidden == YES|| home.view.hidden == YES||_VW_Leisure.hidden == YES)
        {
            [self Sports_view];
        }
        else
        {
            self.VW_event.hidden = YES;
            _VW_Movies.hidden = YES;
            home.view.hidden = YES;
            _VW_Leisure.hidden =YES;
            [self Sports_view];
            
        }
        [self.VW_sports addSubview:VW_overlay];
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(Sports_API_call) withObject:activityIndicatorView afterDelay:0.01];
        
        
    }
    else if([item.title isEqualToString:@"Movies"])
    {
        //[self API_movie];
        if(_VW_event.hidden == YES || _VW_sports.hidden == YES|| home.view.hidden == YES||_VW_Leisure.hidden == YES)
        {
            [self Movies_view];
        }
        else
        {
            self.VW_event.hidden = YES;
            _VW_sports.hidden = YES;
            home.view.hidden = YES;
            _VW_Leisure.hidden =YES;
            [self Movies_view];
            
        }
        
        [self.VW_Movies addSubview:VW_overlay];
        
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(movie_API_CALL) withObject:activityIndicatorView afterDelay:0.01];
       
        
        
    }
    else if([item.title isEqualToString:@"Leisure"])
    {
        
        if(_VW_event.hidden == YES || _VW_sports.hidden == YES || _VW_Movies.hidden == YES|| home.view.hidden == YES)
        {
            [self Leisure_view];
        }
        else
        {
            self.VW_event.hidden = YES;
            _VW_sports.hidden = YES;
            _VW_Movies.hidden = YES;
            home.view.hidden = YES;
            [self Leisure_view];
            
        }
        [self.VW_Leisure addSubview:VW_overlay];
        
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(Leisure_API_call) withObject:activityIndicatorView afterDelay:0.01];
        
    }


    else if([item.title isEqualToString:@"Shop"])
    {
        
        if(_VW_event.hidden == YES || _VW_sports.hidden == YES || _VW_Movies.hidden == YES|| _VW_Leisure.hidden == YES)
        {
        }
        else
        {
            self.VW_event.hidden = YES;
            _VW_sports.hidden = YES;
            _VW_Movies.hidden = YES;
            _VW_Leisure.hidden = YES;
            
        }
        [self.VW_Leisure addSubview:VW_overlay];
        

    }
}

-(void)menu_set_UP
{
   // [self.TBL_menu reloadData];
    
        NSDictionary *user_data = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *str,*full_name;
    @try
    {
     str = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"firstname"]];
        full_name = [NSString stringWithFormat:@"%@ %@ ",[user_data valueForKey:@"firstname"],[user_data valueForKey:@"lastname"]];
     if([str isEqualToString:@"(null)"])
         
     {
         str = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"fname"]];
         full_name = [NSString stringWithFormat:@"%@ %@ ",[user_data valueForKey:@"fname"],[user_data valueForKey:@"lname"]];
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
    

    int statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
    statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
    _menuDraw_width = [UIApplication sharedApplication].statusBarFrame.size.width * 0.80;
    _menyDraw_X = self.navigationController.view.frame.size.width; //- menuDraw_width;
    _VW_swipe.frame = CGRectMake(0, self.view.frame.origin.y, _menuDraw_width, self.navigationController.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
    
    _overlayView = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
    _overlayView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [self.navigationController.view addSubview:_overlayView];
    [_overlayView addSubview:_VW_swipe];
    
    NSString *url_Img_FULL = [NSString stringWithFormat:@"%@uploads/banners/%@",SERVER_URL,[user_data valueForKey:@"profile_pic"]];
    url_Img_FULL  =[url_Img_FULL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [_IMG_profile sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                    placeholderImage:[UIImage imageNamed:@"profile_pic.png"]
                             options:SDWebImageRefreshCached];

    
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
    
    
    @try {
        NSMutableArray *sortedArray = [[NSMutableArray alloc]init];
        sortedArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"menu_detail"] mutableCopy];
        
        
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                     ascending:YES];
        NSArray *srt_arr = [sortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
        [ARR_category addObjectsFromArray:srt_arr];
        
        NSLog(@"Sorted Array :::%@",ARR_category);
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
    //[ARR_category addObjectsFromArray:self.items];
    
    
    j = ARR_category.count;
    
//    NSMutableArray *temp_arrs= [NSMutableArray array];
//    lang_arr = [NSMutableArray array];
//    language_model *model = [[language_model alloc]init];
//    [temp_arrs addObject:model];
//    lang_arr = [temp_arrs copy];
//    model = [lang_arr objectAtIndex:0];
//    NSLog(@"THE model array is:%@",model.languages_arr);
    NSString *language = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"languge"]];
    
    lang_arr = [NSMutableArray arrayWithObjects:language, nil];
    lang_count = lang_arr.count;
    UISwipeGestureRecognizer *SwipeLEFT = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeLeft:)];
    SwipeLEFT.direction = UISwipeGestureRecognizerDirectionLeft;
    [_overlayView addGestureRecognizer:SwipeLEFT];
    
    UISwipeGestureRecognizer *SwipeRIGHT = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRight:)];
    SwipeRIGHT.direction = UISwipeGestureRecognizerDirectionRight;
    //    [self.view addGestureRecognizer:SwipeRIGHT];
    [_overlayView addGestureRecognizer:SwipeRIGHT];
    [_BTN_log_out addTarget:self action:@selector(BTN_log_out) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_address addTarget:self action:@selector(btn_address_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_myorder addTarget:self action:@selector(btn_orders_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_wishlist addTarget:self action:@selector(_BTN_wishlist_action) forControlEvents:UIControlEventTouchUpInside];


    

    
}

-(void)set_up_VIEW
{
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    [self addSEgmentedControl];
    self.segmentedControl4.selectedSegmentIndex =  0;
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
       } forState:UIControlStateNormal];
   _BTN_fav  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain  target:self action:
                 @selector(btnfav_action)];
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        
        [_BTN_log_out setTitle:@"LOGIN" forState:UIControlStateNormal];
    }
    else
    {
          [_BTN_log_out setTitle:@"LOG OUT" forState:UIControlStateNormal];
    }

    _LBL_badge.layer.cornerRadius = self.LBL_badge.frame.size.width/2;
    _LBL_badge.layer.masksToBounds = YES;
    
    [self  cart_count];
    
    @try
    {
    _LBL_best_selling.text = [NSString stringWithFormat:@"%@",[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:0]valueForKey:@"Widgets"] valueForKey:@"title"]];
    }
    @catch(NSException *exception)
    {
        
    }

    //_LBL_best_selling.text = @"BEST SELLING\nPRODUCTS";
    //_LBL_fashio.text = @"FASHION\nACCSESORIES";
    @try
    {
    _LBL_fashio.text = [NSString stringWithFormat:@"%@",[[[[json_Response_Dic valueForKey:@"bannerFashion"]  objectAtIndex:0] valueForKey:@"BannerAdTypes"] valueForKey:@"position"]];
    }
    @catch(NSException *exception)
    {
        
    }
    @try
    {
    _Hot_deals_banner.text = [NSString stringWithFormat:@"%@",[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:0]valueForKey:@"Widgets"] valueForKey:@"title"]];
    }
    @catch(NSException *exception)
    {
    }
    

    
   
    menu_arr = [NSArray arrayWithObjects:@"Movies.png",@"Events.png",@"Sports.png",@"leisure.png",nil];
    
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
    
//    setupframe = _collection_hot_deals.frame;
//    setupframe.size.width = _IMG_hot_deals.frame.size.width ;
//    _collection_hot_deals.frame = setupframe;
//    
//    setupframe = _collection_best_deals.frame;
//    setupframe.size.width = _VW_third.frame.size.width ;
//    _collection_best_deals.frame = setupframe;
//
//    setupframe = _collection_fashion_categirie.frame;
//    setupframe.size.width = _VW_Fourth.frame.size.width;
//    _collection_fashion_categirie.frame = setupframe;
//
    
//    NSString *hot_deals_IMG_url = [NSString stringWithFormat:@"%@uploads/widgets/%@",SERVER_URL,[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"widget_image"]];
//    hot_deals_IMG_url = [hot_deals_IMG_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    
//    [_IMG_hot_deals sd_setImageWithURL:[NSURL URLWithString:hot_deals_IMG_url]
//                         placeholderImage:[UIImage imageNamed:@"logo.png"]
//                                  options:SDWebImageRefreshCached];
//    
//    
//    NSString *best_deals_IMG_url = [NSString stringWithFormat:@"%@uploads/widgets/%@",SERVER_URL,[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0]objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"widget_image"]];
//    best_deals_IMG_url = [best_deals_IMG_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    
//    [_IMG_best_deals sd_setImageWithURL:[NSURL URLWithString:best_deals_IMG_url]
//                      placeholderImage:[UIImage imageNamed:@"logo.png"]
//                               options:SDWebImageRefreshCached];
//    
    
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
        return image_Top_ARR.count;
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
        if(indexPath.row == 0)
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
            
            NSString *url_Img_FULL =[NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"product_image"]];
            [pro_cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                                          options:SDWebImageRefreshCached];
            
            @try
            {
            NSString *str =[NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"stock_status"]];
            str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            if([str isEqualToString:@"In stock"])
            {
                pro_cell.LBL_stock.text =@"";
            }
            else{
            pro_cell.LBL_stock.text =str;
            }
            }
            @catch(NSException *exception)
            {
                
            }
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
            
            
            NSString *currency = [NSString stringWithFormat:@"%@",[json_Response_Dic valueForKey:@"currency"]];
            
            
            NSString *current_price = [NSString stringWithFormat:@"%@", [[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"special_price"]];
            
            NSString *prec_price = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"product_price"]];
            NSString *text ;
            if ([pro_cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
                
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setAlignment:NSTextAlignmentCenter];
                
                if ([current_price isEqualToString:@"<null>"] || [current_price isEqualToString:@"<nil>"]) {
                    
                    
                    text = [NSString stringWithFormat:@"%@ %@",currency,prec_price];
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor],}range:[text rangeOfString:prec_price] ];
                    
                    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                    //NSParagraphStyleAttributeName
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    pro_cell.LBL_discount.text = @"";
                    
                    
                    
                }
                
                else{
                    
                    // Define general attributes for the entire text
                    //        NSDictionary *attribs = @{
                    //                                  NSForegroundColorAttributeName:pro_cell.LBL_current_price.textColor,
                    //                                  NSFontAttributeName:pro_cell.LBL_current_price.font
                    //                                  };
                    
                    //                    current_price = [NSString stringWithFormat:@"%@ %@",currency,current_price];
                    //prec_price = [currency stringByAppendingString:prec_price];
                    
                    
                    int prev_pricee = [[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"product_price"] intValue];
                    int current_pricee =  [[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"special_price"] intValue];
                    
                    int  n = prev_pricee-current_pricee;
                    float discount = (n*100)/prev_pricee;
                    
                    NSString *str = @"% off";
                    pro_cell.LBL_discount.text = [NSString stringWithFormat:@"%.0f%@",discount,str];
                    
                    
                    prec_price = [currency stringByAppendingString:prec_price];
                    text = [NSString stringWithFormat:@"%@ %@ %@",currency,current_price,prec_price];
                    
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
                                           range:NSMakeRange([current_price length]+currency.length+2, [prec_price length])];
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    
                }
            }
            else
            {
                pro_cell.LBL_current_price.text = text;
            }
            //            if([prec_price isEqualToString:@"QR (null)"])
            //            {
            //                prec_price = 0;
            //            }
            //            else if([current_price isEqualToString:@"QR (null)"])
            //            {
            //                current_price =0;
            //            }
            
            
            
            [pro_cell.BTN_fav setTag:indexPath.row];//wishListStatus
            
            
            if ([[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"wishListStatus"] isEqualToString:@"Yes"]) {
                
                [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                [pro_cell.BTN_fav setTitleColor:[UIColor colorWithRed:244.f/255.f green:176.f/255.f blue:77.f/255.f alpha:1] forState:UIControlStateNormal];
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
            NSString *url_Img_FULL =[NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"product_image"]];
            url_Img_FULL = [url_Img_FULL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            [pro_cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                                          options:SDWebImageRefreshCached];
            @try
            {
                NSString *str =[NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"stock_status"]];
                str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                
                if([str isEqualToString:@"In stock"])
                {
                    pro_cell.LBL_stock.text =@"";

                }
                else
                {
                    pro_cell.LBL_stock.text =str;
                }
            }
            @catch(NSException *exception)
            {
                
            }

            
            
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
            
            NSString *currency = [NSString stringWithFormat:@"%@",[json_Response_Dic valueForKey:@"currency"]];;
            
            NSString *current_price = [NSString stringWithFormat:@"%@", [[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"special_price"]];
            
            NSString *prec_price = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"product_price"]];
            NSString *text;
            
            if ([pro_cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
                
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setAlignment:NSTextAlignmentCenter];
                
                if ([current_price isEqualToString:@"<null>"] || [current_price isEqualToString:@"<nil>"]) {
                    
                    
                    text = [NSString stringWithFormat:@"%@ %@",currency,prec_price];
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor],}range:[text rangeOfString:prec_price] ];
                    
                    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                    //NSParagraphStyleAttributeName
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    
                    pro_cell.LBL_discount.text = @"";
                    
                    
                    
                }
                
                else{
                    
                    int prev_pricee = [[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"product_price"] intValue];
                    int current_pricee =  [[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"special_price"] intValue];
                    
                    int  n = prev_pricee-current_pricee;
                    float discount = (n*100)/prev_pricee;
                    NSString *str = @"% off";
                    pro_cell.LBL_discount.text = [NSString stringWithFormat:@"%.0f%@",discount,str];
                    
                    
                    prec_price = [currency stringByAppendingString:prec_price];
                    text = [NSString stringWithFormat:@"%@ %@ %@",currency,current_price,prec_price];
                    
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
                                           range:NSMakeRange([current_price length]+currency.length+2, [prec_price length])];
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    
                }
            }
            else
            {
                pro_cell.LBL_current_price.text = text;
            }
            
            
            [pro_cell.BTN_fav setTag:indexPath.row];//wishListStatus
            
            if ([[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"wishListStatus"] isEqualToString:@"Yes"]) {
                
                [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                [pro_cell.BTN_fav setTitleColor:[UIColor colorWithRed:244.f/255.f green:176.f/255.f blue:77.f/255.f alpha:1] forState:UIControlStateNormal];
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
        return pro_cell;
        
        
    }      else if(collectionView == _collection_brands)
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
//            NSString *url_Img_FULL =[NSString stringWithFormat:@"%@",[menu_arr objectAtIndex:indexPath.row]];
//            
//            [pro_cell.IMG_menu sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
//                                 placeholderImage:[UIImage imageNamed:@"logo.png"]
//                                          options:SDWebImageRefreshCached];
            pro_cell.IMG_menu.image = [UIImage imageNamed:[menu_arr objectAtIndex:indexPath.row]];
            
            
            
        }
        @catch(NSException *exception)
        {
            
        }
        
        return pro_cell;

        
    }
    
      // collection Movies
    else if(collectionView == _Collection_movies)
    {
        static NSString *cellidentifier = @"movie_cell";
        
        int i = (int)indexPath.row;
        i = i +1;
        Movies_cell *cell = (Movies_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellidentifier forIndexPath:indexPath];
       
        NSDictionary *dict = [Movies_arr objectAtIndex:indexPath.row];
        
      

        if(self.segmentedControl4.selectedSegmentIndex == 0)
        {
            
            
            if(indexPath.row % 5 == 0 && indexPath.row==0)
            {
                    cell.LBL_movie_name.text =  [dict valueForKey:@"_name"];
                cell.LBL_rating.text = [NSString stringWithFormat:@"%@/10",[dict valueForKey:@"_IMDB_rating"]];
                cell.LBL_censor.text = [dict valueForKey:@"_Censor"];
                NSString *img_url = [dict valueForKey:@"_thumbURL"];
                img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
                
                [cell.IMG_banner sd_setImageWithURL:[NSURL URLWithString:img_url]
                                   placeholderImage:[UIImage imageNamed:@"upload-8.png"]
                                            options:SDWebImageRefreshCached];
                
                NSString *str = [dict valueForKey:@"_Languageid"];
                NSString *sub_str = [dict valueForKey:@"_MovieType"];
                int time = [[dict valueForKey:@"_Duration"] intValue];
                int hours = time / 60;
                int minutes = time % 60;
                cell.LBL_duration.text = [NSString stringWithFormat:@"%d hr %d min",hours,minutes];
                
                NSString *text = [NSString stringWithFormat:@"%@      %@",str,sub_str];
                
                
                if ([cell.LBL_language respondsToSelector:@selector(setAttributedText:)]) {
                    
                    NSDictionary *attribs = @{
                                              NSForegroundColorAttributeName:cell.LBL_language.textColor,
                                              NSFontAttributeName:cell.LBL_language.font
                                              };
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
                    
                    
                    
                    NSRange ename = [text rangeOfString:sub_str];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0]}
                                                range:ename];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.39 green:0.78 blue:0.05 alpha:1.0]}
                                                range:ename];
                    }
                    cell.LBL_language.attributedText = attributedText;
                }
                else
                {
                    cell.LBL_language.text = text;
                }
                [cell.BTN_book_now setTag:indexPath.row];
                [cell.BTN_book_now addTarget:self action:@selector(Book_now_action:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            }
            
            
            else if(i % 5 == 0 && i!=0)
            {
                [self.Collection_movies registerNib:[UINib nibWithNibName:@"qtickets_cell" bundle:nil] forCellWithReuseIdentifier:@"qtickets_image"];
                qtickets_cell *cell1 = (qtickets_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"qtickets_image" forIndexPath:indexPath];
                return cell1;
            }
            else
            {
                
                cell.LBL_movie_name.text =  [dict valueForKey:@"_name"];
                cell.LBL_rating.text = [NSString stringWithFormat:@"%@/10",[dict valueForKey:@"_IMDB_rating"]];
                cell.LBL_censor.text = [dict valueForKey:@"_Censor"];
                NSString *img_url = [dict valueForKey:@"_thumbURL"];
                img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
                
                [cell.IMG_banner sd_setImageWithURL:[NSURL URLWithString:img_url]
                                   placeholderImage:[UIImage imageNamed:@"upload-8.png"]
                                            options:SDWebImageRefreshCached];
                int time = [[dict valueForKey:@"_Duration"] intValue];
                int hours = time / 60;
                int minutes = time % 60;
                cell.LBL_duration.text = [NSString stringWithFormat:@"%d hr %d min",hours,minutes];
                
                NSString *str = [dict valueForKey:@"_Languageid"];
                NSString *sub_str = [dict valueForKey:@"_MovieType"];
                NSString *text = [NSString stringWithFormat:@"%@      %@",str,sub_str];
                
                
                if ([cell.LBL_language respondsToSelector:@selector(setAttributedText:)]) {
                    
                    NSDictionary *attribs = @{
                                              NSForegroundColorAttributeName:cell.LBL_language.textColor,
                                              NSFontAttributeName:cell.LBL_language.font
                                              };
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
                    
                    
                    
                    NSRange ename = [text rangeOfString:sub_str];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0]}
                                                range:ename];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.39 green:0.78 blue:0.05 alpha:1.0]}
                                                range:ename];
                    }
                    cell.LBL_language.attributedText = attributedText;
                }
                else
                {
                    cell.LBL_language.text = text;
                }
                [cell.BTN_book_now setTag:indexPath.row];
                [cell.BTN_book_now addTarget:self action:@selector(Book_now_action:) forControlEvents:UIControlEventTouchUpInside];
                
                
            }
                  return cell;
        }
        else  if(self.segmentedControl4.selectedSegmentIndex == 1)
        
        {
            static NSString *cellidentifier = @"upcoming_cell";
            upcoming_cell *cell = (upcoming_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellidentifier forIndexPath:indexPath];

            NSDictionary *dict = [Movies_arr objectAtIndex:indexPath.row];
            
            
            if(indexPath.row % 5 == 0 && indexPath.row==0)
            {
                cell.LBL_movie_name.text =  [dict valueForKey:@"_name"];
                cell.LBL_rating.text = [NSString stringWithFormat:@"%@ votes",[dict valueForKey:@"_willwatch"]];
             //   cell.LBL_censor.text = [dict valueForKey:@"_Censor"];
                NSString *img_url = [dict valueForKey:@"_thumbURL"];
                img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
                
                [cell.IMG_banner sd_setImageWithURL:[NSURL URLWithString:img_url]
                                   placeholderImage:[UIImage imageNamed:@"upload-8.png"]
                                            options:SDWebImageRefreshCached];
                
                NSString *str = [dict valueForKey:@"_language"];
                int time = [[dict valueForKey:@"_Duration"] intValue];
                int hours = time / 60;
                int minutes = time % 60;
                cell.LBL_duration.text = [NSString stringWithFormat:@"%d hr %d min",hours,minutes];
                
                NSString *sub_str = [dict valueForKey:@"_MovieType"];
                NSString *text = [NSString stringWithFormat:@"%@      %@",str,sub_str];
                
                
                if ([cell.LBL_language respondsToSelector:@selector(setAttributedText:)]) {
                    
                    NSDictionary *attribs = @{
                                              NSForegroundColorAttributeName:cell.LBL_language.textColor,
                                              NSFontAttributeName:cell.LBL_language.font
                                              };
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
                    
                    
                    
                    NSRange ename = [text rangeOfString:sub_str];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0]}
                                                range:ename];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.39 green:0.78 blue:0.05 alpha:1.0]}
                                                range:ename];
                    }
                    cell.LBL_language.attributedText = attributedText;
                }
                else
                {
                    cell.LBL_language.text = text;
                }
//                [cell.BTN_book_now setTag:indexPath.row];
//                [cell.BTN_book_now addTarget:self action:@selector(Book_now_action:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            
            
            else if(i % 5 == 0 && i!=0)
            {
                [self.Collection_movies registerNib:[UINib nibWithNibName:@"qtickets_cell" bundle:nil] forCellWithReuseIdentifier:@"qtickets_image"];
                qtickets_cell *cell1 = (qtickets_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"qtickets_image" forIndexPath:indexPath];
                return cell1;
            }
            else
            {
                
                cell.LBL_movie_name.text =  [dict valueForKey:@"_name"];
                cell.LBL_rating.text = [NSString stringWithFormat:@"%@ votes",[dict valueForKey:@"_willwatch"]];
                //cell.LBL_censor.text = [dict valueForKey:@"_Censor"];
                NSString *img_url = [dict valueForKey:@"_thumbURL"];
                img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
                
                [cell.IMG_banner sd_setImageWithURL:[NSURL URLWithString:img_url]
                                   placeholderImage:[UIImage imageNamed:@"upload-8.png"]
                                            options:SDWebImageRefreshCached];
                
                NSString *str = [dict valueForKey:@"_language"];
                int time = [[dict valueForKey:@"_Duration"] intValue];
                int hours = time / 60;
                int minutes = time % 60;
                cell.LBL_duration.text = [NSString stringWithFormat:@"%d hr %d min",hours,minutes];
                
                NSString *sub_str = [dict valueForKey:@"_MovieType"];
                NSString *text = [NSString stringWithFormat:@"%@      %@",str,sub_str];
                
                
                if ([cell.LBL_language respondsToSelector:@selector(setAttributedText:)]) {
                    
                    NSDictionary *attribs = @{
                                              NSForegroundColorAttributeName:cell.LBL_language.textColor,
                                              NSFontAttributeName:cell.LBL_language.font
                                              };
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
                    
                    
                    
                    NSRange ename = [text rangeOfString:sub_str];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0]}
                                                range:ename];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.39 green:0.78 blue:0.05 alpha:1.0]}
                                                range:ename];
                    }
                    cell.LBL_language.attributedText = attributedText;
                }
                else
                {
                    cell.LBL_language.text = text;
                }
                
            }
            
            return cell;
            
        }
            

    
        else
        
            {
                if(indexPath.row % 5 == 0 && indexPath.row==0)
                {
                    cell.LBL_movie_name.text =  [dict valueForKey:@"_name"];
                    cell.LBL_rating.text = [NSString stringWithFormat:@"%@/10",[dict valueForKey:@"_IMDB_rating"]];
                    cell.LBL_censor.text = [dict valueForKey:@"_Censor"];
                    NSString *img_url = [dict valueForKey:@"_thumbURL"];
                    img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
                    
                    [cell.IMG_banner sd_setImageWithURL:[NSURL URLWithString:img_url]
                                       placeholderImage:[UIImage imageNamed:@"upload-8.png"]
                                                options:SDWebImageRefreshCached];
                    
                    NSString *str = [dict valueForKey:@"_Languageid"];
                    NSString *sub_str = [dict valueForKey:@"_MovieType"];
                    int time = [[dict valueForKey:@"_Duration"] intValue];
                    int hours = time / 60;
                    int minutes = time % 60;
                    cell.LBL_duration.text = [NSString stringWithFormat:@"%d hr %d min",hours,minutes];
                    
                    NSString *text = [NSString stringWithFormat:@"%@      %@",str,sub_str];
                    
                    
                    if ([cell.LBL_language respondsToSelector:@selector(setAttributedText:)]) {
                        
                        NSDictionary *attribs = @{
                                                  NSForegroundColorAttributeName:cell.LBL_language.textColor,
                                                  NSFontAttributeName:cell.LBL_language.font
                                                  };
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
                        
                        
                        
                        NSRange ename = [text rangeOfString:sub_str];
                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0]}
                                                    range:ename];
                        }
                        else
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.39 green:0.78 blue:0.05 alpha:1.0]}
                                                    range:ename];
                        }
                        cell.LBL_language.attributedText = attributedText;
                    }
                    else
                    {
                        cell.LBL_language.text = text;
                    }
                    [cell.BTN_book_now setTag:indexPath.row];
                    [cell.BTN_book_now addTarget:self action:@selector(Book_now_action:) forControlEvents:UIControlEventTouchUpInside];
                    
                    return cell;
                }
                
                
                else if(i % 5 == 0 && i!=0)
                {
                    [self.Collection_movies registerNib:[UINib nibWithNibName:@"qtickets_cell" bundle:nil] forCellWithReuseIdentifier:@"qtickets_image"];
                    qtickets_cell *cell1 = (qtickets_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"qtickets_image" forIndexPath:indexPath];
                    return cell1;
                }
                else
                {
                    
                    cell.LBL_movie_name.text =  [dict valueForKey:@"_name"];
                    cell.LBL_rating.text = [NSString stringWithFormat:@"%@/10",[dict valueForKey:@"_IMDB_rating"]];
                    cell.LBL_censor.text = [dict valueForKey:@"_Censor"];
                    NSString *img_url = [dict valueForKey:@"_thumbURL"];
                    img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
                    
                    [cell.IMG_banner sd_setImageWithURL:[NSURL URLWithString:img_url]
                                       placeholderImage:[UIImage imageNamed:@"upload-8.png"]
                                                options:SDWebImageRefreshCached];
                    int time = [[dict valueForKey:@"_Duration"] intValue];
                    int hours = time / 60;
                    int minutes = time % 60;
                    cell.LBL_duration.text = [NSString stringWithFormat:@"%d hr %d min",hours,minutes];
                    
                    NSString *str = [dict valueForKey:@"_Languageid"];
                    NSString *sub_str = [dict valueForKey:@"_MovieType"];
                    NSString *text = [NSString stringWithFormat:@"%@      %@",str,sub_str];
                    
                    
                    if ([cell.LBL_language respondsToSelector:@selector(setAttributedText:)]) {
                        
                        NSDictionary *attribs = @{
                                                  NSForegroundColorAttributeName:cell.LBL_language.textColor,
                                                  NSFontAttributeName:cell.LBL_language.font
                                                  };
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
                        
                        
                        
                        NSRange ename = [text rangeOfString:sub_str];
                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0]}
                                                    range:ename];
                        }
                        else
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.39 green:0.78 blue:0.05 alpha:1.0]}
                                                    range:ename];
                        }
                        cell.LBL_language.attributedText = attributedText;
                    }
                    else
                    {
                        cell.LBL_language.text = text;
                    }
                    [cell.BTN_book_now setTag:indexPath.row];
                    [cell.BTN_book_now addTarget:self action:@selector(Book_now_action:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                }
                
                return cell;
            }
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
        return CGSizeMake(_collection_best_deals.frame.size.width/2.011, 285);
        
    }
    else if(collectionView == _Collection_QT_menu)
    {
        return CGSizeMake(_Collection_QT_menu.frame.size.width/4.2, 70);
    }
    else if(collectionView == _collection_hot_deals)
    {
        NSLog(@"the size is width %f: THE height%d",(_collection_hot_deals.bounds.size.width/2),285);

        return CGSizeMake(_collection_hot_deals.frame.size.width/2.011, 285);
        
    }
    else if( collectionView == _collection_brands)
    {
        return CGSizeMake(_collection_features.frame.size.width/3 ,_collection_features.frame.size.height);
        
    }
    else if(collectionView == _Collection_movies)
    {
        int i = (int)indexPath.row;
        i = i +1;
        if(indexPath.row % 5 == 0 && indexPath.row==0)
        {
            return CGSizeMake(_Collection_movies.frame.size.width /2.02,232);
            
        }
        if(i % 5 == 0 && i!=0)
        {
            return CGSizeMake(_Collection_movies.frame.size.width,40);
            
        }
        
        else
        {
            return CGSizeMake(_Collection_movies.frame.size.width /2.02,232);
        }
        

    }
    else
    {
//       if( [[json_Response_Dic valueForKey:@"bannerFashion"]count] == 1 || [[json_Response_Dic valueForKey:@"bannerFashion"]count] == 3)
//       {
//           if(indexPath.row == 0)
//           {
//           return CGSizeMake(self.collection_fashion_categirie.bounds.size.width, 180);
//           }
//           else
//           {
//               return CGSizeMake(self.collection_fashion_categirie.bounds.size.width/2.011, 180);
//           }
//           
//           
//       }
//       else
//       {
        return CGSizeMake(self.collection_fashion_categirie.bounds.size.width/2.011, 180);
     //  }
        
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
    else
    if(collectionView == _Collection_movies)
    {
        ht =1.5;
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
    else
    if(collectionView == _Collection_movies)
    {
        ht =1.5;
    }
   
    return ht;
    
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    
//    if(collectionView == _collection_hot_deals || _collection_best_deals)
//    {
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//    }
//    else{
//        return UIEdgeInsetsMake(0, 0, 0, 0);
//    }
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _collection_hot_deals)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"url_key"] forKey:@"product_list_key_sub"];
        
        NSString *merchant_id = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"merchant_id"]];
         [[NSUserDefaults standardUserDefaults] setValue:merchant_id forKey:@"Mercahnt_ID"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self performSegueWithIdentifier:@"QT_home_product_detail" sender:self];
    }
    else if(collectionView == _collection_best_deals)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"url_key"] forKey:@"product_list_key_sub"];
        NSString *merchant_id = [NSString stringWithFormat:@"%@",[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:indexPath.row]valueForKey:@"merchant_id"]];
        [[NSUserDefaults standardUserDefaults] setValue:merchant_id forKey:@"Mercahnt_ID"];

        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"QT_home_product_detail" sender:self];

    }
      else if(collectionView == _collection_brands)
    {
        
        
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        
        NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
        
        NSString *url_key = [NSString stringWithFormat:@"%@",[[brands_arr objectAtIndex:indexPath.row] valueForKey:@"url_key"]];
        NSString *list_TYPE = @"brandsList";
        [[NSUserDefaults standardUserDefaults] setValue:url_key forKey:@"product_list_key"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/%@/Customer.json",SERVER_URL,list_TYPE,url_key,country,languge,user_id];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setValue:[[[[brands_arr objectAtIndex:indexPath.row] valueForKey:@"_matchingData"]valueForKey:@"BrandDescriptions"] valueForKey:@"name"] forKey:@"item_name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];
    
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
        [[NSUserDefaults standardUserDefaults] setValue:[[[json_Response_Dic valueForKey:@"bannerLarge"] objectAtIndex:indexPath.row] valueForKey:@"title"] forKey:@"item_name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
        
        NSString *list_TYPE = @"productList";
        NSString *url_key_val =[[[json_Response_Dic valueForKey:@"bannerLarge"] objectAtIndex:indexPath.row] valueForKey:@"url"];
        url_key_val = [url_key_val stringByReplacingOccurrencesOfString:@"catalog/" withString:@""];
        
        [[NSUserDefaults standardUserDefaults] setValue:url_key_val forKey:@"product_list_key"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/%@/Customer.json",SERVER_URL,list_TYPE,url_key,country,languge,user_id];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];

        
    }
    else if(collectionView == _collection_images)
    {
        @try
        {
        if(indexPath.row == 0)
        {
            NSLog(@"First Index");
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
        NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
        
        NSString *list_TYPE = @"productList";
            NSString *url_key_val =[[image_Top_ARR objectAtIndex:indexPath.row] valueForKey:@"url"];
            url_key_val = [url_key_val stringByReplacingOccurrencesOfString:@"catalog/" withString:@""];
            [[NSUserDefaults standardUserDefaults] setValue:url_key_val forKey:@"product_list_key"];
            [[NSUserDefaults standardUserDefaults] synchronize];

        NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/%@/Customer.json",SERVER_URL,list_TYPE,url_key,country,languge,user_id];
        
        
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
        NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
        
        NSString *list_TYPE = @"productList";
        
        
        NSString *url_key_val =[[[json_Response_Dic valueForKey:@"bannerFashion"] objectAtIndex:indexPath.row] valueForKey:@"url"];
        url_key_val = [url_key_val stringByReplacingOccurrencesOfString:@"catalog/" withString:@""];
         url_key_val = [url_key_val stringByReplacingOccurrencesOfString:@"discount/" withString:@""];
        [[NSUserDefaults standardUserDefaults] setValue:url_key_val forKey:@"product_list_key"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/%@/Customer.json",SERVER_URL,list_TYPE,url_key,country,languge,user_id];
        
        
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
            [user_defafults setValue:@"Movies" forKey:@"header_name"];
            
        }
        if(indexPath.row == 1)
        {
            [user_defafults setValue:@"Events" forKey:@"header_name"];
            
        }

        if(indexPath.row == 2)
        {
            [user_defafults setValue:@"Sports" forKey:@"header_name"];
            
        }

        if(indexPath.row == 3)
        {
            [user_defafults setValue:@"Leisure" forKey:@"header_name"];
            
        }
        [user_defafults synchronize];
         [self performSegueWithIdentifier:@"QTickets_identifier" sender:self];
        

    
    }

    else if(collectionView == _Collection_movies)
    {
        if(self.segmentedControl4.selectedSegmentIndex == 0)
        {
        int i = (int)indexPath.row;
        i = i +1;
        if(i % 5 == 0 && i!=0)
        {
            NSLog(@"mydata");
        }
        }
        if(self.segmentedControl4.selectedSegmentIndex == 1)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[Movies_arr objectAtIndex:indexPath.row] forKey:@"Movie_detail"];
            NSLog(@"..........Movie Detail .......%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Movie_detail"]);
             [[NSUserDefaults standardUserDefaults] synchronize];
             [self performSegueWithIdentifier:@"upcoming_movies" sender:self];
        }
        else
        {
            NSLog(@"..........Movie Detail .......%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Movie_detail"]);
            
            [[NSUserDefaults standardUserDefaults]  setValue:[[Movies_arr objectAtIndex:indexPath.row] valueForKey:@"_id"] forKey:@"id"];
            [[NSUserDefaults standardUserDefaults]  synchronize];
            [self performSegueWithIdentifier:@"Movies_Booking" sender:self];


        }
        

    }
    
}
#pragma Tableview delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == _TBL_menu)
    {
        return 5;
    }
    if(tableView == _TBL_event_list)
    {
        if([Events_arr isKindOfClass:[NSDictionary class]])
        {
            return 1;
        }
        else{
        return Events_arr.count;
        }
    }
     if(tableView == _TBL_sports_list)
    {
        return Sports_arr.count;
    }
    if(tableView == _TBL_search_results)
    {
        return 0;
    }
    else{
         return Leisure_arr.count;
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
        ceel_count = lang_arr.count;
    }
    if(section == 4)
    {
        ceel_count = 5;
    }
         return ceel_count;
    }
    if(_TBL_event_list||_TBL_lisure_list||_TBL_sports_list)
    {
        return 1;
    }
     if(_TBL_search_results)
    {
        ceel_count =  search_ARR.count;;
        
    }
  
    return ceel_count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   
    categorie_cell *cell = (categorie_cell *)[tableView dequeueReusableCellWithIdentifier:@"cate_cell"];
     // Menu table
    
    if(tableView == _TBL_menu)
    {
    if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"categorie_cell" owner:self options:nil];
        cell = [nib objectAtIndex:1];
    }
        CGRect frameset = cell.frame;
        frameset.size.width = _TBL_menu.frame.size.width;
        cell.frame = frameset;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.LBL_arrow.hidden = YES;
   
    if(indexPath.section == 0)
    {
        cell.LBL_arrow.hidden = NO;
        
   
        NSString *Title= [[ARR_category objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.LBL_name.text = Title;
        [cell.LBL_arrow addTarget:self action:@selector(sub_category_action:) forControlEvents:UIControlEventTouchUpInside];
        cell.LBL_arrow.tag = indexPath.row;

//    return [self createCellWithTitle:Title image:[[ARR_category objectAtIndex:indexPath.row] valueForKey:@"Image name"] indexPath:indexPath];
        
    }
    if(indexPath.section == 1)
    {
        NSArray *ARR_info = [NSArray arrayWithObjects:@"HOME",@"MY PROFILE",@"CHANGE PASSWORD", nil];
        cell.LBL_name.text = [ARR_info objectAtIndex:indexPath.row];
    }
    if(indexPath.section == 2)
    {
        cell.LBL_name.text = @"MERCHANT LIST";
    }
    if(indexPath.section == 3)
    {
        cell.LBL_name.text = [lang_arr objectAtIndex:indexPath.row];
        
        if(indexPath.row == 0){
            cell.LBL_arrow.hidden = NO;
            tag = 0;
            //               if(lang_count < lang_arr.count)
            //               {
            //                  cell.LBL_arrow.text = @"";
            //               }
        }
        
//        if(indexPath.row == 0)
//        {
//            cell.LBL_arrow.hidden = NO;
//            [cell.LBL_arrow addTarget:self action:@selector(picker_view_raise:) forControlEvents:UIControlEventTouchUpInside];
//           cell.LBL_arrow.tag = tag;
//            if(cell.LBL_arrow.tag == 0)
//            {
//                [cell.LBL_arrow setTitle:@"" forState:UIControlStateNormal];
//            }
//            else
//            {
//                [cell.LBL_arrow setTitle:@"" forState:UIControlStateNormal];
// 
//            }
//            
//        
//        }
        
    }
    if(indexPath.section == 4)
    {
        
        NSArray *ARR_info = [NSArray arrayWithObjects:@"ABOUT US",@"CONTACT US",@"TERMS AND CONDITIONS",@"PRIVACY POLACY",@"HELP DESK", nil];
        cell.LBL_name.text = [ARR_info objectAtIndex:indexPath.row];
       }
         return cell;
        
    }
    
    // Evets list Table
    if(tableView == _TBL_search_results)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[search_ARR objectAtIndex:indexPath.row] valueForKey:@"title"]];
        return cell;

        
    }
    if(tableView == _TBL_event_list)
    {
        events_cell *cell = (events_cell *)[tableView dequeueReusableCellWithIdentifier:@"event_cell"];
        
        if(Events_arr.count < 1)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"no_data_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Events found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            
        }
        else
        {

        
        NSMutableArray *events_dict;
         if([Events_arr isKindOfClass:[NSDictionary class]])
         {
             events_dict = Events_arr;
         }
         else
         {
              events_dict = [Events_arr objectAtIndex:indexPath.section];
            
         }
        
        
        if (cell == nil)
            
        {
            
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"events_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            if(indexPath.section %2!=0)
            {
                cell.IMG_qtickets.hidden = NO;
            }
            else
            {
                
                cell.IMG_qtickets.hidden = YES;
            }
            
        }
        @try
        {
            
            NSLog(@"the array count is:%lu",(unsigned long)Events_arr.count);
            
            cell.LBL_event_name.text = [events_dict valueForKey:@"_eventname"];
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            NSDateFormatter *df1 = [[NSDateFormatter alloc]init];

            [df1 setDateFormat:@"yyyy-MM-dd"];
            [df setDateFormat:@"dd MMM yyyy"];
            NSString *temp_str = [NSString stringWithFormat:@"%@",[events_dict valueForKey:@"_startDate"]];
            NSString *end_str =[NSString stringWithFormat:@"%@",[events_dict valueForKey:@"_endDate"]];
            NSDate *str_date = [df1 dateFromString:temp_str];
            NSDate *en_date =[df1 dateFromString:end_str];
            NSString *start_date = [df stringFromDate:str_date];
            NSString *end_date = [df stringFromDate:en_date];
            
            
            cell.LBL_event_date.text = [NSString stringWithFormat:@"%@ - %@",start_date,end_date];
            cell.LBL_event_location.text =  [events_dict valueForKey:@"_Venue"];
            cell.LBL_banner_label.hidden = YES;
            NSString *img_url = [events_dict valueForKey:@"_bannerURL"];
            img_url = [img_url stringByReplacingOccurrencesOfString:@"App" withString:@"movie"];
            
            [cell.IMG_event sd_setImageWithURL:[NSURL URLWithString:img_url]
                              placeholderImage:[UIImage imageNamed:@"upload-8.png"]
                                       options:SDWebImageRefreshCached];
            
        }
        @catch(NSException *exception)
        {
            NSLog(@"%@",exception);
        }
        
        
         return cell;
        
        }
    }
    // Sports List Tbale
    else if(tableView == _TBL_sports_list)
    {
        if(Sports_arr.count < 1)
        {
            events_cell *cell = (events_cell *)[tableView dequeueReusableCellWithIdentifier:@"no_data_cell"];

            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"no_data_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Sports events found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];


        }
        else
        {
        events_cell *cell = (events_cell *)[tableView dequeueReusableCellWithIdentifier:@"event_cell"];

        NSMutableArray *sports_dict = [Sports_arr objectAtIndex:indexPath.section];
        
        
        if (cell == nil)
            
        {
            
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"events_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            if(indexPath.section %2 !=0 )
            {
                
                cell.IMG_qtickets.hidden = NO;
            }
            else
            {
                
                cell.IMG_qtickets.hidden = YES;
            }
            
        }
        
        @try
        {
            cell.LBL_event_name.text = [sports_dict valueForKey:@"_eventname"];
            
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
            
            [df1 setDateFormat:@"yyyy-MM-dd"];
            [df setDateFormat:@"dd MMM yyyy"];
            NSString *temp_str = [NSString stringWithFormat:@"%@",[sports_dict valueForKey:@"_startDate"]];
            NSString *end_str =[NSString stringWithFormat:@"%@",[sports_dict valueForKey:@"_endDate"]];
            NSDate *str_date = [df1 dateFromString:temp_str];
            NSDate *en_date =[df1 dateFromString:end_str];
            NSString *start_date = [df stringFromDate:str_date];
            NSString *end_date = [df stringFromDate:en_date];
            
            cell.LBL_event_date.text = [NSString stringWithFormat:@"%@ - %@",start_date,end_date];
            cell.LBL_event_location.text =  [sports_dict valueForKey:@"_Venue"];
            cell.LBL_banner_label.hidden = YES;
            NSString *img_url = [sports_dict valueForKey:@"_bannerURL"];
            img_url = [img_url stringByReplacingOccurrencesOfString:@"App" withString:@"movie"];
            
            [cell.IMG_event sd_setImageWithURL:[NSURL URLWithString:img_url]
                              placeholderImage:[UIImage imageNamed:@"logo.png"]
                                       options:SDWebImageRefreshCached];
            
            
        }
        @catch(NSException *exception)
        {
            NSLog(@"%@",exception);
        }
        return cell;
        
        
    }
    }
    // Lesire list Table
    else if(tableView == _TBL_lisure_list)
    {
        events_cell *cell = (events_cell *)[tableView dequeueReusableCellWithIdentifier:@"event_cell"];
        
        if(Leisure_arr.count < 1)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"no_data_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No events found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            
        }
        else{

        NSMutableArray *leisure_dict = [Leisure_arr objectAtIndex:indexPath.section];
        
        
        if (cell == nil)
            
        {
            
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"events_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            if(indexPath.section %2 !=0 )
            {
                
                cell.IMG_qtickets.hidden = NO;
            }
            else
            {
                
                cell.IMG_qtickets.hidden = YES;
            }
            
        }
        
        @try
        {
            cell.LBL_event_name.text = [leisure_dict valueForKey:@"_eventname"];
            
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
            
            [df1 setDateFormat:@"yyyy-MM-dd"];
            [df setDateFormat:@"dd MMM yyyy"];
            NSString *temp_str = [NSString stringWithFormat:@"%@",[leisure_dict valueForKey:@"_startDate"]];
            NSString *end_str =[NSString stringWithFormat:@"%@",[leisure_dict valueForKey:@"_endDate"]];
            NSDate *str_date = [df1 dateFromString:temp_str];
            NSDate *en_date =[df1 dateFromString:end_str];
            NSString *start_date = [df stringFromDate:str_date];
            NSString *end_date = [df stringFromDate:en_date];

            cell.LBL_event_date.text = [NSString stringWithFormat:@"%@ - %@",start_date,end_date];
            cell.LBL_event_location.text =  [leisure_dict valueForKey:@"_Venue"];
            cell.LBL_banner_label.hidden = YES;
            NSString *img_url = [leisure_dict valueForKey:@"_bannerURL"];
            img_url = [img_url stringByReplacingOccurrencesOfString:@"App" withString:@"movie"];
            
            [cell.IMG_event sd_setImageWithURL:[NSURL URLWithString:img_url]
                              placeholderImage:[UIImage imageNamed:@"logo.png"]
                                       options:SDWebImageRefreshCached];
            
            
        }
        @catch(NSException *exception)
        {
            NSLog(@"%@",exception);
        }
        return cell;
        
        
    }
    

     return cell;
    
    }
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
            NSString *list_key = [[ARR_category objectAtIndex:indexPath.row] valueForKey:@"url_key"];
            [[NSUserDefaults standardUserDefaults] setValue:list_key forKey:@"product_list_key"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
            NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
            NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
            
            NSString *list_TYPE = @"productList";
            NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/0/%@/%@/%@/Customer.json",SERVER_URL,list_TYPE,list_key,country,languge,user_id];
            
            
            [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self didelct_sub_categoies];
            

                  break;
        }
        case 1:
            [self swipe_left];
            if(indexPath.row == 0)
            {
                self.VW_Movies.hidden = YES;
                self.VW_Leisure.hidden =YES;
                self.VW_event.hidden = YES;
                self.VW_sports.hidden =YES;
                home.view.hidden = YES;
                _Tab_MENU.selectedItem = nil;
                self.Scroll_contents.hidden = NO;
                
            }
            if(indexPath.row == 1)
            {
                NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
                NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
                if([user_id isEqualToString:@"(null)"])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
                    alert.tag = 1;
                    [alert show];
                    
                }
                else
                {

                [self performSegueWithIdentifier:@"edot_profile_VC" sender:self];
                }
  
            }

            if(indexPath.row == 2)
            {
                NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
                NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
                if([user_id isEqualToString:@"(null)"])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
                    alert.tag = 1;
                    [alert show];
                    
                }
                else
                {

                [self performSegueWithIdentifier:@"login_forgot_pwd" sender:self];
                }
            }
            else{
                NSLog(@"ACCount selected");
            }
            break;
        case 2:
            [self swipe_left];
            
            [self performSegueWithIdentifier:@"merchant_segue" sender:self];
            
                        
            break;
        case 3:
            if(indexPath.section == 3)
            {
                
                NSArray *languages;
                languages = [[[NSUserDefaults standardUserDefaults] valueForKey:@"languages"] mutableCopy];
                if(tag == 0)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Caution" message:@"If you want to change the languge you need to login agian.Would you like to do?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                    alert.tag = 2;
                    [alert show];
                   
                    
//                    
//                    [lang_arr addObjectsFromArray:languages];
//                    
//                    int sectionIndex = 0;
//                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:sectionIndex];
//                    [self tableView:_TBL_menu commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:iPath];
                    //[_TBL_menu reloadData];
                }
                else if(tag == 1)
                {
                    tag = 0;
                    
//                    NSMutableArray *cellIndicesToBeDeleted = [[NSMutableArray alloc] init];
//                    long minVAL = indexPath.row;
//                    long maxVal = indexPath.row + [languages count];
//                    
//                    [lang_arr removeObjectsInRange:NSMakeRange(minVAL+1, languages.count)];
//                    for (long k =  minVAL; k < maxVal; k++) {
//                        NSIndexPath *p = [NSIndexPath indexPathForRow:k inSection:indexPath.section];
//                        if ([tableView cellForRowAtIndexPath:p])
//                        {
//                            [cellIndicesToBeDeleted addObject:p];
//                            
//                        }
//                    }
                   // [_TBL_menu reloadData];
                    
                }
                
                
                
            }
            break;
            
        case 4:
            [self swipe_left];
            if(indexPath.row == 0)
            {
                [self performSegueWithIdentifier:@"Home_about_us" sender:self];

            }
            if(indexPath.row == 1)
            {
                [self performSegueWithIdentifier:@"contact_us_segue" sender:self];
            }
            if(indexPath.row == 2)
            {
                [self performSegueWithIdentifier:@"Home_terms" sender:self];
            }
            if(indexPath.row == 3)
            {
                [self performSegueWithIdentifier:@"Home_privacy" sender:self];
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
    if(tableView == _TBL_event_list)
    {
        if(Events_arr.count < 1)
        {
            NSLog(@"NO data");
        }
        else
        {
        
        @try
        {
            NSDictionary *event_dtl;
            if([Events_arr isKindOfClass:[NSDictionary class]])
            {
                event_dtl = Events_arr;
            }
            else
            {
                
               event_dtl = [Events_arr objectAtIndex:indexPath.section];

                
            }

            
            NSLog(@"the detail of event is:%@",event_dtl);
            NSString *show_browser = [NSString stringWithFormat:@"%@",[event_dtl valueForKey:@"_showBrowser"]];
            [[NSUserDefaults standardUserDefaults] setObject:event_dtl forKey:@"event_detail"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            if([show_browser intValue] == 1)
            {
                [self performSegueWithIdentifier:@"Event_WebVIEW" sender:self];
            }
            
            else
            {
                VW_overlay.hidden = NO;
                [activityIndicatorView startAnimating];
                [self performSelector:@selector(event_detail) withObject:activityIndicatorView afterDelay:0.01];
            }
        }
        @catch (NSException *exception)
        {
            NSLog(@"%@",exception);
            
        }
        }
    }
    else  if(tableView == _TBL_sports_list)
    {
        if(Sports_arr.count < 1)
        {
            NSLog(@"NO data");
        }
        else{

        @try
        {
            NSDictionary *sports_dtl = [Sports_arr objectAtIndex:indexPath.section];
            NSLog(@"the detail of sports is:%@",sports_dtl);
            NSString *show_browser = [NSString stringWithFormat:@"%@",[sports_dtl valueForKey:@"_showBrowser"]];
            [[NSUserDefaults standardUserDefaults] setObject:sports_dtl forKey:@"event_detail"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            if([show_browser intValue] == 1)
            {
                [self performSegueWithIdentifier:@"sports_webview" sender:self];
            }
            
            else
            {
                VW_overlay.hidden = NO;
                [activityIndicatorView startAnimating];
                [self performSelector:@selector(sports_detail) withObject:activityIndicatorView afterDelay:0.01];
            }
        }
        
        @catch (NSException *exception)
        {
            NSLog(@"%@",exception);
        }
        }
    }
    else  if(tableView == _TBL_lisure_list)
    {
        if(Leisure_arr.count < 1)
        {
            NSLog(@"NO data");
        }
        else{
        @try
        {
            NSDictionary *leisure = [Leisure_arr objectAtIndex:indexPath.section];
            NSLog(@"the detail of sports is:%@",leisure);
            NSString *show_browser = [NSString stringWithFormat:@"%@",[leisure valueForKey:@"_showBrowser"]];
            [[NSUserDefaults standardUserDefaults] setObject:leisure forKey:@"event_detail"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            if([show_browser intValue] == 1)
            {
                [self performSegueWithIdentifier:@"Event_WebVIEW" sender:self];
            }
            
            else
            {
                VW_overlay.hidden = NO;
                [activityIndicatorView startAnimating];
                [self performSelector:@selector(event_detail) withObject:activityIndicatorView afterDelay:0.01];
            }
        }
        
        @catch (NSException *exception)
        {
            NSLog(@"%@",exception);
        }
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
    float ht = 0;
    if(tableView == _TBL_event_list)
    {
        if(indexPath.section %2 !=0 )
        {
            ht = 310;
        }
        else
        {
            
            ht = 275;
        }
         return ht;
    }
    else if(tableView == _TBL_sports_list)
    {
        if(indexPath.section %2 !=0)
        {
            
            ht = 310;
        }
        
        else
        {
            
            ht = 275;
        }
         return ht;
    }
    else if(tableView == _TBL_lisure_list)
    {
        if(indexPath.section %2 != 0)
        {
            
            ht = 310;
        }
        else
        {
            
            ht = 275;
        }
        return ht;
        
    }
    
    return tableView.rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
     if(_TBL_event_list||_TBL_lisure_list||_TBL_sports_list)
     {
    
    return 4;
     }
    return 32;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320,244)];
    
    NSString *str;
    if(tableView == _TBL_menu)
    {
        UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-7,320,30)];

       // tempLabel.backgroundColor = [UIColor whiteColor];
        tempLabel.textColor = [UIColor grayColor]; //here you can change the text color of header.
        tempLabel.font = [UIFont fontWithName:@"Poppins-Regular" size:12];

        tempView.backgroundColor=[UIColor whiteColor];

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
        tempLabel.text =str;
        [tempView addSubview:tempLabel];
         return tempView;
    }
    else
    {
        UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-10,320,40)];
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
    NSString *list_key = [[ARR_category objectAtIndex:sender.tag] valueForKey:@"url_key"];
    [[NSUserDefaults standardUserDefaults] setValue:list_key forKey:@"product_list_key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self swipe_left];
    [self performSegueWithIdentifier:@"qt_home_sub_brands" sender:self];
    
    
    
}
-(void)didelct_sub_categoies
{
     [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];
    
    
}
//-(void)picker_view_raise:(UIButton *)sender
//{
//    if(sender.tag == 0)
//    {
//    NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:3];
//
//    categorie_cell *cell = (categorie_cell *)[_TBL_menu cellForRowAtIndexPath:index];
//    _lang_picker = [[UIPickerView alloc] init];
//    _lang_picker.delegate = self;
//    _lang_picker.dataSource = self;
//    
//    
//    UIToolbar* conutry_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//    conutry_close.barStyle = UIBarStyleBlackTranslucent;
//    [conutry_close sizeToFit];
//    
//    UIButton *close=[[UIButton alloc]init];
//    close.frame=CGRectMake(conutry_close.frame.size.width - 100, 0, 100, conutry_close.frame.size.height);
//    [close setTitle:@"Done" forState:UIControlStateNormal];
//    [close addTarget:self action:@selector(countrybuttonClick) forControlEvents:UIControlEventTouchUpInside];
//    [conutry_close addSubview:close];
//    cell.LBL_name.inputAccessoryView=conutry_close;
//     cell.LBL_name.inputView = _lang_picker;
//     cell.LBL_name.tintColor=[UIColor clearColor];
//        
//    }
//
//    
//   
//}
#pragma didselct Actions
-(void)sports_detail
{
    [self performSegueWithIdentifier:@"Home_sports_detail" sender:self];
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
}
-(void)event_detail
{
    
    [self performSegueWithIdentifier:@"leisure_detail_segue" sender:self];
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    
    
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

//- (IBAction)cart_action:(id)sender
//{
//    [self performSegueWithIdentifier:@"homeQtkt_to_cart" sender:self];
//}
-(void)_BTN_wishlist_action
{
    [self swipe_left];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please login to continue" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
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
-(void)CollapseRows:(NSArray*)ar
{
    for(NSDictionary *dInner in ar )
    {
        NSUInteger indexToRemove=[ARR_category indexOfObjectIdenticalTo:dInner];
        NSArray *arInner=[dInner valueForKey:@"child_categories"];
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
    bgView.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = bgView;
    cell.LBL_name.text = title;
    cell.LBL_name.textColor = [UIColor blackColor];
    
    [cell setIndentationLevel:[[[ARR_category objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
    cell.indentationWidth = 25;
    
    float indentPoints = cell.indentationLevel * cell.indentationWidth;
    
    cell.contentView.frame = CGRectMake(indentPoints,cell.contentView.frame.origin.y,cell.contentView.frame.size.width - indentPoints,cell.contentView.frame.size.height);
    
    NSDictionary *d1=[ARR_category objectAtIndex:indexPath.row] ;
    
    if([d1 valueForKey:@"child_categories"])
    {
        cell.btnExpand.alpha = 1.0;
       // [cell.btnExpand addTarget:self action:@selector(showSubItems:) forControlEvents:UIControlEventTouchUpInside];
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
    NSArray *arr=[d valueForKey:@"child_categories"];
    if([d valueForKey:@"child_categories"])
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

-(void) addSEgmentedControl
{
    self.segmentedControl4 = [[HMSegmentedControl alloc] initWithFrame:_VW_segment.frame];
    CGRect frame = self.segmentedControl4.frame;
    frame.size.width = self.navigationController.navigationBar.frame.size.width;
    self.segmentedControl4.frame = frame;
    
    self.segmentedControl4.sectionTitles = @[@"Now Showing", @"Coming Soon",@"Top Movies"];
    
    self.segmentedControl4.backgroundColor = [UIColor clearColor];
    self.segmentedControl4.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:16]};
    self.segmentedControl4.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0],NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:16]};
    self.segmentedControl4.selectionIndicatorColor = [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];
    //    self.segmentedControl4.selectionIndicatorColor
    self.segmentedControl4.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl4.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl4.selectionIndicatorHeight = 0.0f;
    
    
    [self.segmentedControl4 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.VW_Movies addSubview:self.segmentedControl4];
    
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl4
{
    if(self.segmentedControl4.selectedSegmentIndex == 0)
    {
        _VW_filter.hidden = NO;
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        
        [self performSelector:@selector(movie_API_CALL) withObject:activityIndicatorView afterDelay:0.01];
        
        
        
    }
    else if(self.segmentedControl4.selectedSegmentIndex == 1)
    {
        _VW_filter.hidden = YES;
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(up_coming_API) withObject:activityIndicatorView afterDelay:0.01];
        
        
    }
    else{
        _VW_filter.hidden = YES;
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(Top_movies_API) withObject:activityIndicatorView afterDelay:0.01];

        
    }
}
-(void)Book_now_action:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[Movies_arr objectAtIndex:sender.tag] forKey:@"Movie_detail"];
    NSLog(@"..........Movie Detail .......%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Movie_detail"]);
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"Movies_Booking" sender:self];
    
    
}
#pragma API call
-(void)movie_API_CALL
{
    @try
    {
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
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
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
-(void)up_coming_API
{
    @try {
        NSURL *URL = [[NSURL alloc] initWithString:@"https://api.q-tickets.com/V2.0/getupcomingmovies"];
        NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
        //NSLog(@"Response dictionary: %@", xmlDoc);
        
        temp_dicts = [xmlDoc valueForKey:@"Movies"];
        NSMutableArray *tmp_arr = [temp_dicts valueForKey:@"movie"];
        NSArray *old_arr = tmp_arr;//[json_RESULT mutableCopy];
        
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
        
        
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        [Movies_arr removeAllObjects];
        Movies_arr = [new_arr mutableCopy];
        [_Collection_movies reloadData];
        
        NSLog(@"%lu",(unsigned long)Movies_arr.count);
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception%@",exception);
    }
    
}
-(void)Top_movies_API
{
    @try {
        NSURL *URL = [[NSURL alloc] initWithString:@"http://api.q-tickets.com/V4.0/gettopfivemovies"];
        NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
        //NSLog(@"Response dictionary: %@", xmlDoc);
        
        temp_dicts = [xmlDoc valueForKey:@"Movies"];
        NSMutableArray *tmp_arr = [temp_dicts valueForKey:@"movie"];
        NSArray *old_arr = tmp_arr;//[json_RESULT mutableCopy];
        
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
        
        
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        [Movies_arr removeAllObjects];
        Movies_arr = [new_arr mutableCopy];
        [_Collection_movies reloadData];
        
        NSLog(@"%lu",(unsigned long)Movies_arr.count);
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception%@",exception);
    }

    
}
-(void)Events_API_CALL
{
    @try
    {
        NSURL *URL = [[NSURL alloc] initWithString:@"https://api.q-tickets.com/V2.0/getalleventsdetailsbycountry?Country=Qatar"];
        NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
        
        NSDictionary *temp_dict = [xmlDoc valueForKey:@"EventDetails"];
        NSArray *tmp_arr = [temp_dict valueForKey:@"eventdetail"];
         NSMutableArray *new_arr = [[NSMutableArray alloc]init];
           NSMutableArray *sports_arr = [[NSMutableArray alloc]init];
           NSMutableArray *leisure_arr = [[NSMutableArray alloc]init];
        
        [Leisure_arr removeAllObjects];
        [Sports_arr removeAllObjects];
        
        for(int dictconut = 0; dictconut< tmp_arr.count;dictconut++)
        {
            NSMutableDictionary *temp_dict = [tmp_arr objectAtIndex:dictconut];
            int category = [[temp_dict valueForKey:@"_CategoryId"] intValue];
            if(category == 12)
            {
                [Leisure_arr addObject:temp_dict];
                [leisure_arr addObject:[temp_dict valueForKey:@"_Venue"]];

            }
            else if(category == 8)
            {
                [Sports_arr addObject:temp_dict];
                [sports_arr addObject:[temp_dict valueForKey:@"_Venue"]];
            }
            [new_arr addObject:[temp_dict valueForKey:@"_Venue"]];
            
        }
        [new_arr sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSOrderedSet *orderedSet1 = [NSOrderedSet orderedSetWithArray:new_arr];
        
        venues_arr = [orderedSet1 array];
        [leisure_arr sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSOrderedSet *orderedSet2 = [NSOrderedSet orderedSetWithArray:leisure_arr];
        
        leisure_venues = [orderedSet2 array];

        [sports_arr sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        NSOrderedSet *orderedSet3 = [NSOrderedSet orderedSetWithArray:sports_arr];
        
        sports_venues = [orderedSet3 array];

        

        
        [[NSUserDefaults standardUserDefaults] setObject:tmp_arr forKey:@"Events_arr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:Sports_arr forKey:@"Sports_arr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:Leisure_arr forKey:@"leisure_arr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        
        //  [self performSegueWithIdentifier:@"Home_to_detail" sender:self];
        
        
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
    }
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
}

-(void)Event_API_CALL
{
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
  //  [Events_arr removeAllObjects];
    Events_arr = [[[NSUserDefaults standardUserDefaults] valueForKey:@"Events_arr"] mutableCopy];
    if(Events_arr.count<1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Events found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];

    }
    else
    {
    [_TBL_event_list reloadData];
    }
}

-(void)Sports_API_call
{
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    Sports_arr = [[[NSUserDefaults standardUserDefaults] valueForKey:@"Sports_arr"] mutableCopy];
    if(Sports_arr.count < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Events found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        _VW_sports_filter.hidden = YES;
        
    }else
        if(Sports_arr.count == 1)
        {
            [_TBL_sports_list reloadData];
            _VW_sports_filter.hidden = YES;
        }
        else
        {
            [_TBL_sports_list reloadData];
            _VW_sports_filter.hidden = NO;
        }
    

}
-(void)Leisure_API_call
{
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    
    Leisure_arr = [[[NSUserDefaults standardUserDefaults] valueForKey:@"leisure_arr"] mutableCopy];
    if(Leisure_arr.count < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Events found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        _VW_leisure_filter.hidden = YES;
        
    }else
     if(Leisure_arr.count == 1)
     {
      [_TBL_lisure_list reloadData];
      _VW_leisure_filter.hidden = YES;
     }
     else
     {
     [_TBL_lisure_list reloadData];
     _VW_leisure_filter.hidden = NO;
     }

}


-(void)API_movie
{
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(movie_API_CALL) withObject:activityIndicatorView afterDelay:0.01];
    
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
                        //[self Events_API_CALL];
                      //  [self Event_API_CALL];
                       // [self picker_view_set_UP];
                        
                        image_Top_ARR = [[NSMutableArray alloc]init];
                        [image_Top_ARR addObject:@"banner_main.png"];
                        
                        for(int  i= 0; i<[[json_Response_Dic valueForKey:@"banners"]count];i++)
                        {
                            
                            [image_Top_ARR addObject:[[json_Response_Dic valueForKey:@"banners"]objectAtIndex:i]];
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
                      
                        
                        VW_overlay.hidden=YES;
                        [activityIndicatorView stopAnimating];

                        
                       

                        NSLog(@"the api_collection_product%@",json_Response_Dic);

                       
                       
                    } @catch (NSException *exception) {
                        NSLog(@"%@",exception);
                        VW_overlay.hidden=YES;
                        [activityIndicatorView stopAnimating];
                        [self viewWillAppear:NO];


                    }
                }
                    else
                    {
                        VW_overlay.hidden = YES;
                        [activityIndicatorView stopAnimating];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];
                        [self viewWillAppear:NO];


                    }
                
                
                
            });
        }];
    }
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        [self viewWillAppear:NO];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
//        

    }
    
}

-(void)BTN_log_out
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userdata"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login_VC"];
    [self presentViewController:login animated:NO completion:nil];
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
    else if(pickerView == _lang_picker)
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
    else if(pickerView == _lang_picker)
    {
        return [[[NSUserDefaults standardUserDefaults] valueForKey:@"languages"]count];
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
    else if(pickerView == _lang_picker)
    {
        return [[NSUserDefaults standardUserDefaults] valueForKey:@"languages"][row];
    }


    
    return nil;
}

// #6
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSMutableArray *movie = [[NSMutableArray alloc]init];
    NSMutableArray *lang = [[NSMutableArray alloc]init];
    NSMutableArray *venues = [[NSMutableArray alloc]init];


    
    
    if (pickerView == _halls_picker)
    {
       [self movie_API_CALL];
        
        for(int i=0;i<Movies_arr.count;i++)
        {
            @try
            {
            for(int k=0;k< [[[Movies_arr objectAtIndex:i]valueForKey:@"Theatre"] count];k++)
            {
                
                if([[[[[Movies_arr objectAtIndex:i]valueForKey:@"Theatre"] objectAtIndex:k]valueForKey:@"_name"] isEqualToString:halls_arr[row]])
                {
                    [movie addObject:[Movies_arr objectAtIndex:i]];
                }
            }

                
                
            }
                @catch(NSException *exception)
                {
                    
                    if([[[[Movies_arr objectAtIndex:i]valueForKey:@"Theatre"]valueForKey:@"_name"] isEqualToString:halls_arr[row]])
                    {
                        
                        [movie addObject:[Movies_arr objectAtIndex:i]];
                
                        
                        
                    }

                    
                }

        
         
        }
        [Movies_arr removeAllObjects];
        [Movies_arr addObjectsFromArray:movie];
        [_Collection_movies reloadData];
        halls_text = halls_arr[row];
        [self ATTRIBUTE_TEXT];
     
    
    }
    if (pickerView == _lang_picker) {
        [self movie_API_CALL];
        for(int l = 0;l<Movies_arr.count;l++)
        {
             if([[[Movies_arr objectAtIndex:l]valueForKey:@"_Languageid"] isEqualToString:langugage_arr[row]])
             {
                 [lang addObject:[Movies_arr objectAtIndex:l]];
             }
        }
        
         NSLog(@"The arr:%@",langugage_arr[row]);
       
        if(lang.count < 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No movies found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];

        }
        else
        {
            [Movies_arr removeAllObjects];
            [Movies_arr addObjectsFromArray:lang];
            [_Collection_movies reloadData];
            leng_text = langugage_arr[row];
        }
      
        [self ATTRIBUTE_TEXT];
       // _BTN_all_lang.text = halls_text;
        
        
    }
    if (pickerView == _venue_picker)
    {
        [self Events_API_CALL];
        [self Event_API_CALL];
        for(int l = 0;l<Events_arr.count;l++)
        {
            if([[[Events_arr objectAtIndex:l]valueForKey:@"_Venue"] isEqualToString:venues_arr[row]])
            {
                [venues addObject:[Events_arr objectAtIndex:l]];
            }
        }

        NSLog(@"The arr:%@",venues_arr[row]);
        [Events_arr removeAllObjects];
        [Events_arr addObjectsFromArray:venues];
        [_TBL_event_list reloadData];
        
    }
    if(pickerView == _leisure_venues)
    {
        [self Events_API_CALL];
        [self Event_API_CALL];
        for(int l = 0;l<Leisure_arr.count;l++)
        {
            if([[[Leisure_arr objectAtIndex:l]valueForKey:@"_Venue"] isEqualToString:leisure_venues[row]])
            {
                [venues addObject:[Leisure_arr objectAtIndex:l]];
            }
        }
        
        NSLog(@"The arr:%@",venues_arr[row]);
        [Leisure_arr removeAllObjects];
        [Leisure_arr addObjectsFromArray:venues];
        [_TBL_lisure_list reloadData];

    }
    if(pickerView == _sports_venue_picker)
    {
        [self Events_API_CALL];
        [self Event_API_CALL];
        for(int l = 0;l<Sports_arr.count;l++)
        {
            if([[[Sports_arr objectAtIndex:l]valueForKey:@"_Venue"] isEqualToString:sports_venues[row]])
            {
                [venues addObject:[Sports_arr objectAtIndex:l]];
            }
        }
        
        NSLog(@"The arr:%@",venues_arr[row]);
        [Sports_arr removeAllObjects];
        [Sports_arr addObjectsFromArray:venues];
        [_TBL_sports_list reloadData];
        
    }
    


    
}
- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [_halls_picker rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(_halls_picker.bounds, 0.0, (CGRectGetHeight(_halls_picker.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_halls_picker]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [_halls_picker selectedRowInComponent:0];
            [self pickerView:_halls_picker didSelectRow:selectedRow inComponent:0];
        }
    }
}
- (IBAction)tappedToSelectRowstate:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [_lang_picker rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(_lang_picker.bounds, 0.0, (CGRectGetHeight(_lang_picker.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_lang_picker]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [_lang_picker selectedRowInComponent:0];
            [self pickerView:_lang_picker didSelectRow:selectedRow inComponent:0];
        }
    }
}
- (IBAction)tappedToSelectRowsvenue:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [_venue_picker rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(_venue_picker.bounds, 0.0, (CGRectGetHeight(_venue_picker.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_venue_picker]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [_venue_picker selectedRowInComponent:0];
            [self pickerView:_venue_picker didSelectRow:selectedRow inComponent:0];
        }
    }
}
-(void)btn_address_action
{
    [self swipe_left];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
        alert.tag = 1;
        [alert show];
        
    }
    else
    {

    [self performSegueWithIdentifier:@"home_address" sender:self];
    }
}
-(void)btn_orders_action
{
    [self swipe_left];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
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
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/addToWishList/%@/%@.json",SERVER_URL,[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0] objectAtIndex:sender.tag]valueForKey:@"id"],user_id];
   
     [self Wishlist_add:urlGetuser];

   
        
    

}
-(void)best_dels_wishlist:(UIButton *)sender
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/addToWishList/%@/%@.json",SERVER_URL,[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0] objectAtIndex:sender.tag]valueForKey:@"id"],user_id];
    [self Wishlist_add:urlGetuser];

    
}
-(void)fashion_dels_wishlist:(UIButton *)sender
{
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/addToWishList/%@/%@.json",SERVER_URL,[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-2"] objectAtIndex:0] objectAtIndex:sender.tag]valueForKey:@"id"],user_id];
    [self Wishlist_add:urlGetuser];

    
}
-(void)Wishlist_add:(NSString *)str_URL
{
    
    @try 
    {
        
        //        NSUserDefaults *user_dflts = [NSUserDefaults standardUserDefaults];
               NSString *urlGetuser = [NSString stringWithFormat:@"%@",str_URL];
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
                        VW_overlay.hidden = NO;
                        [activityIndicatorView startAnimating];
                        [self performSelector:@selector(API_call_total) withObject:activityIndicatorView afterDelay:0.01];

                       
                        
//                        NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];
//                        product_cell *cell;
//                        if(_collection_hot_deals)
//                        {
//                          cell = (product_cell *)[self.collection_hot_deals cellForItemAtIndexPath:index];
//                        }
//                        else  if(_collection_fashion_categirie)
//                        {
//                            cell = (product_cell *)[self.collection_fashion_categirie cellForItemAtIndexPath:index];
//                        }
//                        else  if(_collection_best_deals)
//                       {
//                           cell = (product_cell *)[self.collection_best_deals cellForItemAtIndexPath:index];
//                       }
//
//
//                        
//                        
//                        @try {
//                            if ([[json_Response_Dic valueForKey:@"msg"] isEqualToString:@"add"]) {
//                                
//                                //  [self startAnimation:sender];
//                                [cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
//                                
//                                [cell.BTN_fav setTitleColor:[UIColor colorWithRed:244.f/255.f green:176.f/255.f blue:77.f/255.f alpha:1] forState:UIControlStateNormal];
//                                [HttpClient createaAlertWithMsg:@"Item added successfully" andTitle:@""];
//                                
//                                
//                            }
//                            else{
//                                
//                                [cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                            }
                        
                            
//                        } @catch (NSException *exception) {
//                            NSLog(@"%@",exception);
//                            [cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                        }
                        
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
       // [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
    }
    
    VW_overlay.hidden=YES;
    [activityIndicatorView stopAnimating];
    
    
}

#pragma IMAGE ACTIONS
-(void)hot_deals_action
{
    [[NSUserDefaults standardUserDefaults] setValue:[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0]objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"title"] forKey:@"item_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
    
    NSString *url_key = [NSString stringWithFormat:@"%@",[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-0"] objectAtIndex:0]objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"title"]];
    NSString *list_TYPE = @"dealsList";
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/%@/Customer.json",SERVER_URL,list_TYPE,url_key,country,languge,user_id];
  
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
    NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
    
    NSString *url_key = [NSString stringWithFormat:@"%@",[[[[[[json_Response_Dic valueForKey:@"deal"] valueForKey:@"dealWidget-1"] objectAtIndex:0]objectAtIndex:0] valueForKey:@"Widgets"] valueForKey:@"title"]];
    NSString *list_TYPE = @"dealsList";
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/%@/Customer.json",SERVER_URL,list_TYPE,url_key,country,languge,user_id];
    
     [[NSUserDefaults standardUserDefaults] setValue:url_key forKey:@"product_list_key"];
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];

}
-(void)collection_acttion:(NSString *) hot_deals_url : (NSString *)item_name
{

    
    [[NSUserDefaults standardUserDefaults] setValue:item_name forKey:@"item_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
    
    NSString *url_key = [NSString stringWithFormat:@"%@",hot_deals_url];
    NSString *list_TYPE = @"dealsList";
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/%@/Customer.json",SERVER_URL,list_TYPE,url_key,country,languge,user_id];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    [self performSegueWithIdentifier:@"homw_product_list_detail" sender:self];

    
}
-(void)images_action:(NSString *)deals_url :(NSString *)item_name
{
    [[NSUserDefaults standardUserDefaults] setValue:item_name forKey:@"item_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
    
    NSString *url_key = [NSString stringWithFormat:@"%@",deals_url];
    NSString *list_TYPE = @"dealsList";
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/%@/Customer.json",SERVER_URL,list_TYPE,url_key,country,languge,user_id];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[NSUserDefaults standardUserDefaults] setValue:item_name forKey:@"item_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];

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
            brands_arr= (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            [[NSUserDefaults standardUserDefaults] setObject:brands_arr forKey:@"brands_LIST"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            
            [self.collection_brands reloadData];
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

-(void)brands_action:(NSString *)brands_url : (NSString *)item_name
{
    
    
    [[NSUserDefaults standardUserDefaults] setValue:item_name forKey:@"item_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
    
    NSString *url_key = [NSString stringWithFormat:@"%@",brands_url];
    NSString *list_TYPE = @"brandsList";
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/%@/Customer.json",SERVER_URL,list_TYPE,url_key,country,languge,user_id];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setValue:item_name forKey:@"item_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];
  
}
-(void)features_slection:(NSString *)features_url : (NSString *)item_name
{
      NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
    
    NSString *list_TYPE = @"productList";
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/%@/Customer.json",SERVER_URL,list_TYPE,features_url,country,languge,user_id];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setValue:item_name forKey:@"item_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];

}
-(void)search_results:(NSString *)search_url :(NSString *)item_name
{
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *user_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"];
    
    NSString *list_TYPE = @"productList";
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/txt_%@/0/%@/%@/%@/Customer.json",SERVER_URL,list_TYPE,search_url,country,languge,user_id];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setValue:item_name forKey:@"item_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];

}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 2)
    {
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        NSLog(@"cancel:");
        
   
    }

    else{
        [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"country_id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"language_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        VC_intial *intial = [self.storyboard instantiateViewControllerWithIdentifier:@"intial_VC"];
        [self presentViewController:intial animated:NO completion:nil];

        
    }
    }
    else if(alertView.tag == 1)
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
        NSError *error;
        
        NSHTTPURLResponse *response = nil;
        NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
        //    NSString *urlGetuser =[NSString stringWithFormat:@"%@menuList/%ld/%ld.json",SERVER_URL,(long)[user_defaults   integerForKey:@"country_id"],[user_defaults integerForKey:@"language_id"]];
        NSString *lang = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        
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
            
            [[NSUserDefaults standardUserDefaults] setObject:json_DATA forKey:@"menu_detail"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self performSegueWithIdentifier:@"logint_to_home" sender:self];
            
            NSLog(@"the api_collection_product%@",json_DATA);
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
        
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
     [self performSegueWithIdentifier:@"home_dohasooq_search" sender:self];
}

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
                    
                    
                }
                else{
                    [_BTN_cart setBadgeString: [NSString stringWithFormat:@"%@",badge_value]];
                    
                    
                }
                
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
            
        }
    }];
}

#pragma mark TimerMethod
-(void)set_timer_to_collection_images{
    
    
    [NSTimer scheduledTimerWithTimeInterval:8
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
