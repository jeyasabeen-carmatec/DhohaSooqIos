//
//  Home_detail.m
//  Dohasooq_mobile
//
//  Created by Test User on 20/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "Home_detail.h"
#import "events_cell.h"
#import "Movies_cell.h"
#import "qtickets_cell.h"
#import "upcoming_cell.h"
#import "HttpClient.h"
#import "Helper_activity.h"

#import <SDWebImage/UIImageView+WebCache.h>


@interface Home_detail ()<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *Movies_arr,*Events_arr,*Sports_arr,*Leisure_arr,*movie,*lang,*venues;

    NSArray *langugage_arr,*halls_arr,*venues_arr,*sports_venues,*leisure_venues;
    NSString *halls_text,*leng_text;
    NSDictionary *temp_dicts;
    NSString *headre_name;
    UIButton *all;
    
    NSString *selectedPicker;
    // NSInteger rowValue;
    BOOL isScrolled;
}
@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;


@end

@implementation Home_detail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self.Collection_movies registerNib:[UINib nibWithNibName:@"Movies_cell" bundle:nil]  forCellWithReuseIdentifier:@"movie_cell"];

    [self.Collection_movies registerNib:[UINib nibWithNibName:@"Image_qtickets" bundle:nil]  forCellWithReuseIdentifier:@"Image_qtickets"];
    
    [self.Collection_movies registerNib:[UINib nibWithNibName:@"upcoming_cell" bundle:nil]  forCellWithReuseIdentifier:@"upcoming_cell"];
    
    [_logo_home addTarget:self action:@selector(logo_home_target) forControlEvents:UIControlEventTouchUpInside];

    [self set_UP_VIEW];

    Movies_arr = [[NSMutableArray alloc]init];
    Leisure_arr = [[NSMutableArray alloc] init];
    Sports_arr = [[NSMutableArray alloc] init];
    Events_arr = [[NSMutableArray alloc] init];
    
    
    //  For Filtering
    
    movie = [[NSMutableArray alloc]init];
     lang = [[NSMutableArray alloc]init];
     venues = [[NSMutableArray alloc]init];
    
    CGRect frameset = _VW_empty.frame;
    frameset.size.width = 200;
    frameset.size.height = 200;
    _VW_empty.frame = frameset;
    _VW_empty.center = self.view.center;
    [self.view addSubview:_VW_empty];
    _VW_empty.hidden = YES;
    
    _BTN_empty.layer.cornerRadius = self.BTN_empty.frame.size.width / 2;
    _BTN_empty.layer.masksToBounds = YES;
    

   
    _BTN_leisure_venues.text = _BTN_venues.text;
    _BTN_sports_venues.text = _BTN_venues.text;
    leng_text = @"LANGUAGES";
    halls_text =@"CINEMA";
    
    [self ATTRIBUTE_TEXT];
    [self Events_API_CALL];
    [self picker_view_set_UP];
    [self addSEgmentedControl];
    
   
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    
    NSLog(@"Header name label %@",_Header_name.titleLabel.text);
    headre_name =[[NSUserDefaults standardUserDefaults] valueForKey:@"header_name"];
   
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor = [UIColor colorWithRed:0.98 green:0.69 blue:0.19 alpha:1.0];
    [self.navigationController.view addSubview:view];

//    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    VW_overlay.clipsToBounds = YES;
//    //    VW_overlay.layer.cornerRadius = 10.0;
//    
//    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
//    activityIndicatorView.center = VW_overlay.center;
//    [VW_overlay addSubview:activityIndicatorView];
//   
//    VW_overlay.hidden = YES;
    
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
    [self VIew_APPEAR];

}
-(void)VIew_APPEAR
{
   if([headre_name isEqualToString:@"MOVIES"])
   {
        [self Movies_view];
       [Helper_activity animating_images:self];
       [self performSelector:@selector(movie_API_CALL) withObject:nil afterDelay:0.01];
       [self.Tab_MENU setSelectedItem:[[self.Tab_MENU items] objectAtIndex:0]];
       
    
    
  }
   else if([headre_name isEqualToString:@"EVENTS"])
   {
       [self Events_view];
       [Helper_activity animating_images:self];
       [self performSelector:@selector(Events_API_CALL) withObject:nil afterDelay:0.01];
       [self.Tab_MENU setSelectedItem:[[self.Tab_MENU items] objectAtIndex:1]];

       
    }
    else if([headre_name isEqualToString:@"SPORTS"])
   {
        [self Sports_view];
        //[self.view addSubview:VW_overlay];
//        VW_overlay.hidden = NO;
          _VW_sports.hidden = NO;
//        [activityIndicatorView startAnimating];
       [Helper_activity animating_images:self];
       
        [self performSelector:@selector(Sports_API_call) withObject:nil afterDelay:0.01];
       [self.Tab_MENU setSelectedItem:[[self.Tab_MENU items] objectAtIndex:2]];

      
       
    }
    else if([headre_name isEqualToString:@"LEISURE"])
   {
        [self Leisure_view];
       // [self.view addSubview:VW_overlay];
       // VW_overlay.hidden = NO;
       _VW_Leisure.hidden = NO;
       // [activityIndicatorView startAnimating];
       [Helper_activity animating_images:self];
       [self performSelector:@selector(Leisure_API_call) withObject:nil afterDelay:0.01];
       [self.Tab_MENU setSelectedItem:[[self.Tab_MENU items] objectAtIndex:3]];

      
       
    }
    else
    {
        
        [self Movies_view];
        //[self.view addSubview:VW_overlay];
      //  VW_overlay.hidden = NO;
      //  [activityIndicatorView startAnimating];
        [Helper_activity animating_images:self];
        [self performSelector:@selector(movie_API_CALL) withObject:nil afterDelay:0.01];
        [self.Tab_MENU setSelectedItem:[[self.Tab_MENU items] objectAtIndex:0]];
        [_Header_name setTitle:@"Movies" forState:UIControlStateNormal];


        
    }

    
}
- (IBAction)LOGO_ACTION:(id)sender {
    [self VIew_APPEAR];
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
    
    UIToolbar* conutry_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    conutry_close.barStyle = UIBarStyleBlackTranslucent;
    [conutry_close sizeToFit];
    
  
    
//    UIButton *close=[[UIButton alloc]init];
//    close.frame=CGRectMake(conutry_close.frame.origin.x -20, 0, 100, conutry_close.frame.size.height);
//    [close setTitle:@"Close" forState:UIControlStateNormal];
//    [close addTarget:self action:@selector(close_action) forControlEvents:UIControlEventTouchUpInside];
//    [conutry_close addSubview:close];
    
    UIButton *done=[[UIButton alloc]init];
    done.frame=CGRectMake(conutry_close.frame.size.width - 100, 0, 100, conutry_close.frame.size.height);
    [done setTitle:@"Done" forState:UIControlStateNormal];
    [done addTarget:self action:@selector(countrybuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [conutry_close addSubview:done];
    

    
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
    
    _BTN_all_lang.delegate=self;
    _BTN_all_halls.delegate=self;
    _BTN_leisure_venues.delegate=self;
    _BTN_sports_venues.delegate=self;
    _BTN_venues.delegate=self;
    
}
-(void)countrybuttonClick
{
    if (!isScrolled) {
         [self pickerCustomAction:0];
    }
    
    [self.BTN_all_lang resignFirstResponder];
    [self.BTN_all_halls resignFirstResponder];
    [_BTN_sports_venues resignFirstResponder];
    [_BTN_leisure_venues resignFirstResponder];
    [_BTN_venues resignFirstResponder];
}
-(void)close_action
{
    [self.BTN_all_lang resignFirstResponder];
    [self.BTN_all_halls resignFirstResponder];
    [_BTN_sports_venues resignFirstResponder];
    [_BTN_leisure_venues resignFirstResponder];
    [_BTN_venues resignFirstResponder];
}

-(void)set_UP_VIEW
{
     [self tab_BAR_set_UP];
    [_BTN_event_filter addTarget:self action:@selector(filter_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_sports_filter addTarget:self action:@selector(filter_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_leisure_filter addTarget:self action:@selector(filter_action) forControlEvents:UIControlEventTouchUpInside];


}



-(void)Events_view
{
    
    _VW_event.hidden = NO;
    CGRect frameset = _VW_event.frame;
    frameset.origin.y = _Tab_MENU.frame.origin.y + _Tab_MENU.frame.size.height;
    frameset.size.height = self.view.frame.size.height - _Tab_MENU.frame.origin.y  - _Tab_MENU.frame.size.height;
    frameset.size.width =  self.view.frame.size.width;
    _VW_event.frame = frameset;
    [self.view addSubview:_VW_event];
    [self Event_API_CALL];
    
    

}
-(void)Movies_view
{
   
  
    _VW_Movies.hidden = NO;
    CGRect frameset = _VW_Movies.frame;
    frameset.origin.y = _Tab_MENU.frame.origin.y + _Tab_MENU.frame.size.height;
    frameset.size.height = self.view.frame.size.height - _Tab_MENU.frame.origin.y  - _Tab_MENU.frame.size.height;
    frameset.size.width =  self.view.frame.size.width;
    _VW_Movies.frame = frameset;
    [self.view addSubview:_VW_Movies];
       self.segmentedControl4.selectedSegmentIndex = 0;
 
    
  

   
}
-(void)Leisure_view
{

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
    

    _VW_sports.hidden = NO;
    CGRect frameset = _VW_sports.frame;
    frameset.origin.y = _Tab_MENU.frame.origin.y + _Tab_MENU.frame.size.height;
    frameset.size.height = self.view.frame.size.height - _Tab_MENU.frame.origin.y  - _Tab_MENU.frame.size.height;
    frameset.size.width =  self.view.frame.size.width;
    _VW_sports.frame = frameset;
    [self.view addSubview:_VW_sports];
    

}
-(void)tab_BAR_set_UP
{
   
    CGRect frameset = _Tab_MENU.frame;
    frameset.origin.y= self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    frameset.size.height = 70;
    _Tab_MENU.frame = frameset;
    
    _Tab_MENU.delegate = self;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0f],NSForegroundColorAttributeName:[UIColor whiteColor]
                                                        } forState:UIControlStateNormal];
   
    
    
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
    NSUserDefaults *user_defafults = [NSUserDefaults standardUserDefaults];

    if([item.title isEqualToString:@"Events"])
    {
          _VW_event.hidden = NO;
        self.VW_sports.hidden = YES;
        _VW_Movies.hidden = YES;
        
        _VW_Leisure.hidden =YES;

        if(_VW_sports.hidden == YES || _VW_Movies.hidden == YES ||  _VW_Leisure.hidden == YES)
        {
            
            [self Events_view];
        }
        else
        {
            self.VW_sports.hidden = YES;
            _VW_Movies.hidden = YES;
           
            _VW_Leisure.hidden =YES;
            [self Events_view];
            
        }
      
       // [self.VW_event addSubview:VW_overlay];
       
         [_Header_name setTitle:@"EVENTS" forState:UIControlStateNormal];
      
        [user_defafults setValue:@"Events" forKey:@"header_name"];
        [self ATTRIBUTE_TEXT];
      [Helper_activity animating_images:self];
        [self performSelector:@selector(Events_API_CALL) withObject:nil afterDelay:0.01];
        [self Event_API_CALL];

       
        
    }
    else if([item.title isEqualToString:@"Sports"])
    {
        _VW_sports.hidden = NO;
        self.VW_event.hidden = YES;
        _VW_Movies.hidden = YES;
        
        _VW_Leisure.hidden =YES;


        if(_VW_event.hidden == YES || _VW_Movies.hidden == YES||_VW_Leisure.hidden == YES)
        {
            [self Sports_view];
        }
        else
        {
            self.VW_event.hidden = YES;
            _VW_Movies.hidden = YES;
           
            _VW_Leisure.hidden =YES;
            [self Sports_view];
            
        }
      //  [self.VW_sports addSubview:VW_overlay];
        [_Header_name setTitle:@"SPORTS" forState:UIControlStateNormal];
        [user_defafults setValue:@"SPORTS" forKey:@"header_name"];
//              VW_overlay.hidden = NO;
//        [activityIndicatorView startAnimating];
        [self performSelector:@selector(Sports_API_call) withObject:nil afterDelay:0.01];
        

        

    }
    else if([item.title isEqualToString:@"Movies"])
    {
        //[self API_movie];
       
        
          _VW_Movies.hidden = NO;
        self.VW_event.hidden = YES;
        _VW_sports.hidden = YES;
        
        _VW_Leisure.hidden =YES;


        if(_VW_event.hidden == YES || _VW_sports.hidden == YES||_VW_Leisure.hidden == YES)
        {
            [self Movies_view];
        }
        else
        {
            self.VW_event.hidden = YES;
            _VW_sports.hidden = YES;
          
            _VW_Leisure.hidden =YES;
            [self Movies_view];
            
        }
        //[self.VW_Movies addSubview:VW_overlay];
          [_Header_name setTitle:@"MOVIES" forState:UIControlStateNormal];
        [user_defafults setValue:@"MOVIES" forKey:@"header_name"];

        _VW_filter.hidden = NO;
        [Helper_activity animating_images:self];
//        VW_overlay.hidden = NO;
//        [activityIndicatorView startAnimating];
        [self performSelector:@selector(movie_API_CALL) withObject:nil afterDelay:0.01];
        
        
    }
    else if([item.title isEqualToString:@"Leisure"])
    {
        _VW_Leisure.hidden = NO;
        self.VW_event.hidden = YES;
        _VW_sports.hidden = YES;
        _VW_Movies.hidden = YES;


        if(_VW_event.hidden == YES || _VW_sports.hidden == YES || _VW_Movies.hidden == YES)
        {
            [self Leisure_view];
        }
        else
        {
            self.VW_event.hidden = YES;
            _VW_sports.hidden = YES;
            _VW_Movies.hidden = YES;
         
            [self Leisure_view];
            
        }
//               [self.VW_Leisure addSubview:VW_overlay];
           [_Header_name setTitle:@"LEISURE" forState:UIControlStateNormal];
        [user_defafults setValue:@"LEISURE" forKey:@"header_name"];
          [Helper_activity animating_images:self];
//        VW_overlay.hidden = NO;
//        [activityIndicatorView startAnimating];
        [self performSelector:@selector(Leisure_API_call) withObject:nil afterDelay:0.01];
       
      
        
    }
    [user_defafults synchronize];
    [self close_action];
}


-(void)ATTRIBUTE_TEXT
{
    @try {
   
    
    NSString *str = @"";
    NSString *text = [NSString stringWithFormat:@"VENUES %@",str];
    if ([_BTN_venues  respondsToSelector:@selector(setAttributedText:)]) {
        
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
        NSString *leisure_str = @"";
        NSString *leisure_text = [NSString stringWithFormat:@"VENUES %@",str];
        if ([_BTN_venues  respondsToSelector:@selector(setAttributedText:)]) {
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:_BTN_leisure_venues.textColor,
                                      NSFontAttributeName: _BTN_leisure_venues.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
            
            
            
            NSRange ename = [leisure_text rangeOfString:leisure_str];
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
            _BTN_leisure_venues.attributedText = attributedText;
        }
        else
        {
            _BTN_leisure_venues.text = text;
        }

        NSString *sports_str = @"";
        NSString *sports_text = [NSString stringWithFormat:@"VENUES %@",str];
        if ([_BTN_venues  respondsToSelector:@selector(setAttributedText:)]) {
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:_BTN_leisure_venues.textColor,
                                      NSFontAttributeName: _BTN_leisure_venues.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
            
            
            
            NSRange ename = [sports_text rangeOfString:sports_str];
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
            _BTN_sports_venues.attributedText = attributedText;
        }
        else
        {
            _BTN_sports_venues.text = text;
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
    @catch(NSException *exception)
    {
        
    }
    
}


#pragma Table view delegates


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //array is your db, here we just need how many they are
    
    if(tableView == _TBL_event_list)
    {
        if([Events_arr isKindOfClass:[NSArray class]])
        {
            return Events_arr.count;
        }
        else
        {
            
         return 1;
        }
    }
    else if(tableView == _TBL_sports_list)
    {
         return Sports_arr.count;
    }
    else
    {
        return Leisure_arr.count;
    }
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
                
                NSLog(@"the event array count is:%lu",(unsigned long)Events_arr.count);
                
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
                NSLog(@"Event array tabl exception %@",exception);
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Sports Available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
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
                NSLog(@"event name eeee %@",exception);
            }
            return cell;
            
            
        }
    }
    // Lesire list Table
    else
    {
        events_cell *cell = (events_cell *)[tableView dequeueReusableCellWithIdentifier:@"event_cell"];
        
        if(Leisure_arr.count < 1)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"no_data_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Leisure events found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
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
                NSLog(@"nnn event name %@",exception);
            }
        }
            return cell;
            
            
        }
        
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float ht = 0;
    if(tableView == _TBL_event_list)
    {
        if(indexPath.section %2 !=0 )
        {
            ht = 263;
        }
        else
        {
            
            ht = 219;
        }
    }
    else if(tableView == _TBL_sports_list)
    {
        if(indexPath.section %2 !=0)
        {
            
            ht = 263;
        }
        else
        {
            
            ht = 219;
        }
    }
    else if(tableView == _TBL_lisure_list)
    {
        if(indexPath.section %2 != 0)
        {
            
            ht = 263;
        }
        else
        {
            
            ht = 219;
        }

    }
    
    return ht;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _TBL_event_list)
    {
        @try
        {
        NSMutableDictionary *event_dtl = [Events_arr objectAtIndex:indexPath.section];
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
       [Helper_activity animating_images:self];
            [self performSelector:@selector(event_detail) withObject:nil afterDelay:0.01];
        }
        }
        @catch (NSException *exception)
        {
            NSLog(@"aaa sdf %@",exception);
            
        }

        }
   else  if(tableView == _TBL_sports_list)
    {
        @try
        {
        NSMutableDictionary *sports_dtl = [Sports_arr objectAtIndex:indexPath.section];
        NSLog(@"the detail of sports is:%@",sports_dtl);
        //NSString *show_browser = [NSString stringWithFormat:@"%@",[sports_dtl valueForKey:@"_showBrowser"]];
        [[NSUserDefaults standardUserDefaults] setObject:sports_dtl forKey:@"event_detail"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
//        if([show_browser intValue] == 1)
//        {
            [self performSegueWithIdentifier:@"sports_webview" sender:self];
//        }
//        
//        else
//        {
//         [HttpClient animating_images:self];
//            [self performSelector:@selector(sports_detail) withObject:nil afterDelay:0.01];
//        }
        }
    
        @catch (NSException *exception)
        {
            NSLog(@"sr rtwe we %@",exception);
        }
    }
   else  if(tableView == _TBL_lisure_list)
   {
       @try
       {
           NSMutableDictionary *leisure = [Leisure_arr objectAtIndex:indexPath.section];
           NSLog(@"the detail of sports is:%@",leisure);
           NSString *show_browser = [NSString stringWithFormat:@"%@",[leisure valueForKey:@"_showBrowser"]];
           [[NSUserDefaults standardUserDefaults] setObject:leisure forKey:@"event_detail"];
           [[NSUserDefaults standardUserDefaults] synchronize];
           
           
           
           if([show_browser intValue] == 1)
           {
               [self performSegueWithIdentifier:@"leisure_webview" sender:self];
           }
           
           else
           {
              [Helper_activity animating_images:self];
               [self performSelector:@selector(event_detail) withObject:nil afterDelay:0.01];
           }
       }
       
       @catch (NSException *exception)
       {
           NSLog(@" swer  rt r %@",exception);
       }
   }

    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    return 7;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}
#pragma didselct Actions
-(void)sports_detail
{
    [self performSegueWithIdentifier:@"Home_sports_detail" sender:self];
    [Helper_activity stop_activity_animation:self];
}
-(void)event_detail
{
    
    [self performSegueWithIdentifier:@"leisure_detail_segue" sender:self];
  [Helper_activity stop_activity_animation:self];

}

#pragma Collection delegates
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   // float  i = Movies_arr.count / 5;
   // int j  =  roundf(i);
    
    return Movies_arr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *cellidentifier = @"movie_cell";
        
        int i = (int)indexPath.row;
        Movies_cell *cell = (Movies_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellidentifier forIndexPath:indexPath];
        NSDictionary *dict = [Movies_arr objectAtIndex:indexPath.row];
        
        
        if(self.segmentedControl4.selectedSegmentIndex == 0)
        {
            @try
            {
            
                cell.LBL_movie_name.text =  [dict valueForKey:@"_name"];
                cell.LBL_rating.text = [NSString stringWithFormat:@"%@/10",[dict valueForKey:@"_IMDB_rating"]];
                cell.LBL_censor.text = [dict valueForKey:@"_Censor"];
                NSString *img_url = [dict valueForKey:@"_iphonethumb"];
             //  img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
                
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
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.39 green:0.78 blue:0.05 alpha:1.0]}
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
            @catch(NSException *exception)
            {
                
            }
            
                
            
            return cell;
        }
        else  if(self.segmentedControl4.selectedSegmentIndex == 1)
            
        {
            static NSString *cellidentifier = @"upcoming_cell";
            upcoming_cell *cell = (upcoming_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellidentifier forIndexPath:indexPath];
            
            NSDictionary *dict = [Movies_arr objectAtIndex:indexPath.row];
            
            @try
            {
                
            
                cell.LBL_movie_name.text =  [dict valueForKey:@"_name"];
                cell.LBL_rating.text = [NSString stringWithFormat:@"%@ votes",[dict valueForKey:@"_willwatch"]];
                //cell.LBL_censor.text = [dict valueForKey:@"_Censor"];
                NSString *img_url = [dict valueForKey:@"_thumbURL"];
               // img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
                
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
            @catch(NSException *exception)
            {
                
            }
          
            
            return cell;
            
        }
        
        
        
        else
            
        {
            @try
            {
                cell.LBL_movie_name.text =  [dict valueForKey:@"_name"];
                cell.LBL_rating.text = [NSString stringWithFormat:@"%@/10",[dict valueForKey:@"_IMDB_rating"]];
                cell.LBL_censor.text = [dict valueForKey:@"_Censor"];
                NSString *img_url = [dict valueForKey:@"_iphonethumb"];
                //img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
                
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
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.39 green:0.78 blue:0.05 alpha:1.0]}
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
            @catch(NSException *exception)
            {
                
            }
            
            return cell;
        }
    }
    



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_Collection_movies.frame.size.width /2.02,224);
    
   
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
       return 4;
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,4,0);  // top, left, bottom, right
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    if(self.segmentedControl4.selectedSegmentIndex == 1)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[Movies_arr objectAtIndex:indexPath.row] forKey:@"Movie_detail"];
        NSLog(@"..........Movie Detail . dgdf ......%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Movie_detail"]);
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSegueWithIdentifier:@"upcoming_movies" sender:self];
    }
    else
    {
        NSLog(@"..........Movie Detail .. asf asdf.....%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Movie_detail"]);
        
        [[NSUserDefaults standardUserDefaults]  setValue:[[Movies_arr objectAtIndex:indexPath.row] valueForKey:@"_id"] forKey:@"id"];
        [[NSUserDefaults standardUserDefaults]  synchronize];
        [self performSegueWithIdentifier:@"Movies_Booking" sender:self];
        
        
    }
    
    

}

#pragma segment methods
-(void) addSEgmentedControl
{
    self.segmentedControl4 = [[HMSegmentedControl alloc] initWithFrame:_VW_segment.frame];
    CGRect frame = self.segmentedControl4.frame;
    frame.size.width = self.navigationController.navigationBar.frame.size.width;
    self.segmentedControl4.frame = frame;
    
    self.segmentedControl4.sectionTitles = @[@"Now Showing", @"Coming Soon",@"Top Movies"];
    
    self.segmentedControl4.backgroundColor = [UIColor clearColor];
    self.segmentedControl4.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:16]};
    self.segmentedControl4.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0],NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:16]};
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
        [Helper_activity animating_images:self];
        
        [self performSelector:@selector(movie_API_CALL) withObject:nil afterDelay:0.01];
        
        
        
    }
    else if(self.segmentedControl4.selectedSegmentIndex == 1)
    {
        _VW_filter.hidden = YES;
        [Helper_activity animating_images:self];

        [self performSelector:@selector(up_coming_API) withObject:nil afterDelay:0.01];
        
        
    }
    else{
        _VW_filter.hidden = YES;
        [Helper_activity animating_images:self];

        [self performSelector:@selector(Top_movies_API) withObject:nil afterDelay:0.01];
        
        
    }
}
-(void)Book_now_action:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults]  setValue:[[Movies_arr objectAtIndex:sender.tag] valueForKey:@"_id"] forKey:@"id"];
    [[NSUserDefaults standardUserDefaults]  synchronize];
    [self performSegueWithIdentifier:@"Movies_Booking" sender:self];
    
}

#pragma Button_Actions
- (IBAction)back_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma API call
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
     //   int index = 0;
        
     //   int tags = 0;
        
        for (int i = 0; i < count;i++ )
        {
//            i= i+1;
//            if ((i % 5) == 0 && i != 0)
//            {
//                NSDictionary *tmp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Qtickets",@"Movies", nil];
//                [new_arr addObject:tmp_dictin];
//                count = count + 1;
//                tags = tags + 1;
//            }
//            else
//            {
                //index = i - tags - 1;
                [new_arr addObject:[old_arr objectAtIndex:i]];
           // }
        }
      
        [Helper_activity stop_activity_animation:self];
        [Movies_arr removeAllObjects];
        Movies_arr = [new_arr mutableCopy];
        [_Collection_movies reloadData];
        
        NSLog(@"Moview count %lu",(unsigned long)Movies_arr.count);
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception %@",exception);
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
        //int index = 0;
        
        //int tags = 0;
        
        for (int i = 0; i < count;i++ )
        {
//            i= i+1;
//            if ((i % 5) == 0 && i != 0)
//            {
//                NSDictionary *tmp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Qtickets",@"Movies", nil];
//                [new_arr addObject:tmp_dictin];
//                count = count + 1;
//                tags = tags + 1;
//            }
//            else
//            {
//                index = i - tags - 1;
                [new_arr addObject:[old_arr objectAtIndex:i]];
           // }
        }
        
        
        [Helper_activity stop_activity_animation:self];
        [Movies_arr removeAllObjects];
        Movies_arr = [new_arr mutableCopy];
        [_Collection_movies reloadData];
        
        NSLog(@"M count %lu",(unsigned long)Movies_arr.count);
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception %@",exception);
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
//        int index = 0;
//        
//        int tags = 0;
        
        for (int i = 0; i < count;i++ )
        {
//            i= i+1;
//            if ((i % 5) == 0 && i != 0)
//            {
//                NSDictionary *tmp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Qtickets",@"Movies", nil];
//                [new_arr addObject:tmp_dictin];
//                count = count + 1;
//                tags = tags + 1;
//            }
//            else
//            {
//                index = i - tags - 1;
                [new_arr addObject:[old_arr objectAtIndex:i]];
           // }
        }
        
        
        [Helper_activity stop_activity_animation:self];
        [Movies_arr removeAllObjects];
        Movies_arr = [new_arr mutableCopy];
        [_Collection_movies reloadData];
        
        NSLog(@"MM cx momovie count %lu",(unsigned long)Movies_arr.count);
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception %@",exception);
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
         // [new_arr addObject:@"ALL VENUES"];
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
        
        
        [_TBL_event_list reloadData];
        
        [Helper_activity stop_activity_animation:self];
        
        //  [self performSegueWithIdentifier:@"Home_to_detail" sender:self];
        
        
    }
    @catch(NSException *exception)
    {
        NSLog(@"Event api call exception %@",exception);
        [Helper_activity stop_activity_animation:self];
    }
    
}

-(void)Event_API_CALL
{
    [Helper_activity stop_activity_animation:self];
    //[Events_arr removeAllObjects];
    Events_arr = [[[NSUserDefaults standardUserDefaults] valueForKey:@"Events_arr"] mutableCopy];
    if(Events_arr.count<1)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Events found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
        _VW_event.hidden= YES;
        _VW_empty.hidden = NO;
        
        _VW_sports_filter.hidden = YES;
        [_BTN_empty setImage:[UIImage imageNamed:@"spot.png"] forState:UIControlStateNormal];
        _LBL_no_products.text = @"No Events found";

        
    }
    else
    {
        [_TBL_event_list reloadData];
    }
}

-(void)Sports_API_call

{
    [Helper_activity stop_activity_animation:self];
    Sports_arr = [[[NSUserDefaults standardUserDefaults] valueForKey:@"Sports_arr"] mutableCopy];
    if(Sports_arr.count < 1)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Events found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
      _VW_sports.hidden= YES;
        _VW_empty.hidden = NO;
        
        _VW_sports_filter.hidden = YES;
        [_BTN_empty setImage:[UIImage imageNamed:@"spot.png"] forState:UIControlStateNormal];
        _LBL_no_products.text = @"No Sporting events found";
        

        
    }else
        if(Sports_arr.count == 1)
        {
            _VW_sports.hidden= NO;
            [_TBL_sports_list reloadData];
            _VW_sports_filter.hidden = YES;
            _VW_empty.hidden = YES;
        }
        else
        {
            _VW_sports.hidden= NO;
            [_TBL_sports_list reloadData];
            _VW_sports_filter.hidden = NO;
            _VW_empty.hidden = YES;
        }
    
    
}
-(void)Leisure_API_call
{
     [Helper_activity stop_activity_animation:self];
    
    Leisure_arr = [[[NSUserDefaults standardUserDefaults] valueForKey:@"leisure_arr"] mutableCopy];
    if(Leisure_arr.count < 1)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Events found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
        _VW_leisure_filter.hidden = YES;
        _VW_Leisure.hidden = YES;
        _VW_empty.hidden = NO;
        [_BTN_empty setImage:[UIImage imageNamed:@"leis.png"] forState:UIControlStateNormal];
               _LBL_no_products.text = @"No Leisure events found";

        
        
    }else
        if(Leisure_arr.count == 1)
        { _VW_Leisure.hidden = NO;
            [_TBL_lisure_list reloadData];
            _VW_leisure_filter.hidden = YES;
             _VW_empty.hidden = YES;
        }
        else
        {   _VW_Leisure.hidden = NO;
            [_TBL_lisure_list reloadData];
            _VW_leisure_filter.hidden = NO;
             _VW_empty.hidden = YES;
        }
    
}


-(void)API_movie
{
    [Helper_activity animating_images:self];
    [self performSelector:@selector(movie_API_CALL) withObject:nil afterDelay:0.01];
    
}

#pragma mark - UIPickerView Delegate DataSourse

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


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == _halls_picker) {
        [all setTitle:@"ALL CINEMA HALLS" forState:UIControlStateNormal];
        return halls_arr[row];
    }
    if (pickerView == _lang_picker) {
        [all setTitle:@"ALL LANGUAGES" forState:UIControlStateNormal];

        return langugage_arr[row];
    }
    if (pickerView == _venue_picker) {
        [all setTitle:@"ALL VENUES" forState:UIControlStateNormal];

        return venues_arr[row];
    }
    else if (pickerView == _sports_venue_picker) {
        [all setTitle:@"ALL VENUES" forState:UIControlStateNormal];

        return sports_venues[row];
    }
    else if (pickerView == _leisure_venues) {
        [all setTitle:@"ALL VENUES" forState:UIControlStateNormal];

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
    
    isScrolled = YES;
   // rowValue = row;
    
    
    [self pickerCustomAction:row];
    
   /* NSMutableArray *movie = [[NSMutableArray alloc]init];
    NSMutableArray *lang = [[NSMutableArray alloc]init];
    NSMutableArray *venues = [[NSMutableArray alloc]init];
    
    if (pickerView == _halls_picker)
    {
        if([halls_arr[row] isEqualToString:@"ALL CINEMA HALLS"])
        {
            [self movie_API_CALL];
        }
        else
        {
            [self movie_API_CALL];
            
            for(int i=0;i<Movies_arr.count;i++)
            {
                @try
                {
                    //   [movie addObject:@"ALL"];
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
                    // [movie addObject:@"ALL"];
                    
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
        
    }
    if (pickerView == _lang_picker) {
        
        if([langugage_arr[row] isEqualToString:@"ALL LANGUAGES"])
        {
            [self movie_API_CALL];
        }
        else
        {
            
            [self movie_API_CALL];
            // [lang addObject:@"ALL"];
            for(int l = 0;l<Movies_arr.count;l++)
            {
                if([[[Movies_arr objectAtIndex:l]valueForKey:@"_Languageid"] isEqualToString:langugage_arr[row]])
                {
                    [lang addObject:[Movies_arr objectAtIndex:l]];
                }
            }
            
            
            NSLog(@"The langauge arr:%@",langugage_arr[row]);
            
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
        
    }
    if (pickerView == _venue_picker)
    {
        if([venues_arr[row] isEqualToString:@"ALL VENUES"])
        {
            [self Events_API_CALL];
            [self Event_API_CALL];
        }
        else
        {
            [self Events_API_CALL];
            [self Event_API_CALL];
            //  [venues addObject:@"ALL"];
            for(int l = 0;l<Events_arr.count;l++)
            {
                if([[[Events_arr objectAtIndex:l]valueForKey:@"_Venue"] isEqualToString:venues_arr[row]])
                {
                    [venues addObject:[Events_arr objectAtIndex:l]];
                }
            }
            
            NSLog(@"The venue arr:%@",venues_arr[row]);
            [Events_arr removeAllObjects];
            [Events_arr addObjectsFromArray:venues];
            [_TBL_event_list reloadData];
        }
        
    }
    if(pickerView == _leisure_venues)
    {
        if([venues_arr[row] isEqualToString:@"ALL VENUES"])
        {
            [self Events_API_CALL];
            [self Event_API_CALL];
        }
        else
        {
            
            [self Events_API_CALL];
            [self Event_API_CALL];
            //  [venues addObject:@"ALL"];
            
            for(int l = 0;l<Leisure_arr.count;l++)
            {
                if([[[Leisure_arr objectAtIndex:l]valueForKey:@"_Venue"] isEqualToString:leisure_venues[row]])
                {
                    [venues addObject:[Leisure_arr objectAtIndex:l]];
                }
            }
            NSLog(@"Venue arr:%@",venues_arr[row]);
            [Leisure_arr removeAllObjects];
            [Leisure_arr addObjectsFromArray:venues];
            [_TBL_lisure_list reloadData];
        }
        
    }
    if(pickerView == _sports_venue_picker)
    {
        if([venues_arr[row] isEqualToString:@"ALL VENUES"])
        {
            [self Events_API_CALL];
            [self Event_API_CALL];
        }
        else
        {
            
            [self Events_API_CALL];
            [self Event_API_CALL];
            // [venues addObject:@"ALL"];
            
            for(int l = 0;l<Sports_arr.count;l++)
            {
                if([[[Sports_arr objectAtIndex:l]valueForKey:@"_Venue"] isEqualToString:sports_venues[row]])
                {
                    [venues addObject:[Sports_arr objectAtIndex:l]];
                }
            }
            
            NSLog(@"Venue arr:%@",venues_arr[row]);
            [Sports_arr removeAllObjects];
            [Sports_arr addObjectsFromArray:venues];
            [_TBL_sports_list reloadData];
        }
        
    }*/
}
-(void)pickerCustomAction:(NSInteger)row{
    /*        selectedPicker = @"languages";
     selectedPicker = @"halls";
     selectedPicker = @"sportsVenue";
     selectedPicker = @"leisureVenue";
     selectedPicker = @"venues";
*/
    [movie removeAllObjects];
    [lang removeAllObjects];
   [venues removeAllObjects];
    
    
    if ([selectedPicker isEqualToString:@"languages"]) {
        
        if([langugage_arr[row] isEqualToString:@"ALL LANGUAGES"])
        {
            [self movie_API_CALL];
        }
        else
        {
            
            [self movie_API_CALL];
            // [lang addObject:@"ALL"];
            for(int l = 0;l<Movies_arr.count;l++)
            {
                if([[[Movies_arr objectAtIndex:l]valueForKey:@"_Languageid"] isEqualToString:langugage_arr[row]])
                {
                    [lang addObject:[Movies_arr objectAtIndex:l]];
                }
            }
            
            
            NSLog(@"The langauge arr:%@",langugage_arr[row]);
            
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
 
    }
    else if ([selectedPicker isEqualToString:@"halls"]){
        
        if([halls_arr[row] isEqualToString:@"ALL CINEMA HALLS"])
        {
            [self movie_API_CALL];
        }
        else
        {
            [self movie_API_CALL];
            
            for(int i=0;i<Movies_arr.count;i++)
            {
                @try
                {
                    //   [movie addObject:@"ALL"];
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
                    // [movie addObject:@"ALL"];
                    
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
    }
// ***************** SportsVenue**************
    else if ([selectedPicker isEqualToString:@"sportsVenue"]){
        
        if([venues_arr[row] isEqualToString:@"ALL VENUES"])
        {
            [self Events_API_CALL];
            [self Event_API_CALL];
        }
        else
        {
            
            [self Events_API_CALL];
            [self Event_API_CALL];
            // [venues addObject:@"ALL"];
            
            for(int l = 0;l<Sports_arr.count;l++)
            {
                if([[[Sports_arr objectAtIndex:l]valueForKey:@"_Venue"] isEqualToString:sports_venues[row]])
                {
                    [venues addObject:[Sports_arr objectAtIndex:l]];
                }
            }
            
            NSLog(@"Venue arr:%@",venues_arr[row]);
            [Sports_arr removeAllObjects];
            [Sports_arr addObjectsFromArray:venues];
            [_TBL_sports_list reloadData];
        }
 
    }
 //****************** leisureVenue ************
    else if ([selectedPicker isEqualToString:@"leisureVenue"]){
        
        if([venues_arr[row] isEqualToString:@"ALL VENUES"])
        {
            [self Events_API_CALL];
            [self Event_API_CALL];
        }
        else
        {
            
            [self Events_API_CALL];
            [self Event_API_CALL];
            //  [venues addObject:@"ALL"];
            
            for(int l = 0;l<Leisure_arr.count;l++)
            {
                if([[[Leisure_arr objectAtIndex:l]valueForKey:@"_Venue"] isEqualToString:leisure_venues[row]])
                {
                    [venues addObject:[Leisure_arr objectAtIndex:l]];
                }
            }
            NSLog(@"Venue arr:%@",venues_arr[row]);
            [Leisure_arr removeAllObjects];
            [Leisure_arr addObjectsFromArray:venues];
            [_TBL_lisure_list reloadData];
        }
        
    }
 // ****************** venues **************
    else if ([selectedPicker isEqualToString:@"venues"]){
        if([venues_arr[row] isEqualToString:@"ALL VENUES"])
        {
            [self Events_API_CALL];
            [self Event_API_CALL];
        }
        else
        {
            [self Events_API_CALL];
            [self Event_API_CALL];
            //  [venues addObject:@"ALL"];
            for(int l = 0;l<Events_arr.count;l++)
            {
                if([[[Events_arr objectAtIndex:l]valueForKey:@"_Venue"] isEqualToString:venues_arr[row]])
                {
                    [venues addObject:[Events_arr objectAtIndex:l]];
                }
            }
            
            NSLog(@"The venue arr:%@",venues_arr[row]);
            [Events_arr removeAllObjects];
            [Events_arr addObjectsFromArray:venues];
            [_TBL_event_list reloadData];
        }
 
    }
    
    
}




- (void)filter_action
{
    [self performSegueWithIdentifier:@"events_filter" sender:self];
}

- (IBAction)back_ACTION:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)logo_home_target
{
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)shop_action:(id)sender {
    
}


#pragma mark UItextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    isScrolled = NO;
    
       return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _BTN_all_lang) {
        selectedPicker = @"languages";
       // [self.lang_picker selectRow:0 inComponent:0 animated:YES];

    }
    else if (textField == _BTN_all_halls){
        
        selectedPicker = @"halls";
        //[self.halls_picker selectRow:2 inComponent:0 animated:YES];
    }
    else if (textField == _BTN_sports_venues)
    {
        selectedPicker = @"sportsVenue";
        
    }
    else if (textField == _BTN_leisure_venues){
        selectedPicker = @"leisureVenue";
    }
    else if (textField == _BTN_venues){
        selectedPicker = @"venues";
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
