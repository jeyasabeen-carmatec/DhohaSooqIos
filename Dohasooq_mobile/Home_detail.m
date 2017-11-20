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
#import <SDWebImage/UIImageView+WebCache.h>


@interface Home_detail ()<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *Movies_arr,*Events_arr,*Sports_arr,*Leisure_arr;
    NSDictionary *temp_dict;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
}
@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;


@end

@implementation Home_detail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [_Header_name setTitle:[[NSUserDefaults standardUserDefaults] valueForKey:@"item_title"] forState:UIControlStateNormal];
    [self.Collection_movies registerNib:[UINib nibWithNibName:@"Movies_cell" bundle:nil]  forCellWithReuseIdentifier:@"movie_cell"];

    [self.Collection_movies registerNib:[UINib nibWithNibName:@"Image_qtickets" bundle:nil]  forCellWithReuseIdentifier:@"Image_qtickets"];
  
    [self set_UP_VIEW];
    [self ATTRIBUTE_TEXT];

    [self addSEgmentedControl];
    
   
}
-(void)viewWillAppear:(BOOL)animated
{
    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    //    VW_overlay.layer.cornerRadius = 10.0;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    [self.view addSubview:VW_overlay];
    VW_overlay.hidden = YES;
    

    
    
    if([_Header_name.titleLabel.text isEqualToString:@"Movies"])
    {
        
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(movie_API_CALL) withObject:activityIndicatorView afterDelay:0.01];
    }
    else if([_Header_name.titleLabel.text isEqualToString:@"Events"])
    {
        
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(Events_API_CALL) withObject:activityIndicatorView afterDelay:0.01];
        
    }
    else if([_Header_name.titleLabel.text isEqualToString:@"Sports"])
    {
        
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(Sports_API_call) withObject:activityIndicatorView afterDelay:0.01];
        
    }
    else if([_Header_name.titleLabel.text isEqualToString:@"Leisure"])
    {
        
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(Leisure_API_call) withObject:activityIndicatorView afterDelay:0.01];
        
    }

    
}

-(void)set_UP_VIEW
{
     [self tab_BAR_set_UP];
    @try
    {
   
    if ([_Header_name.titleLabel.text isEqualToString:@"Events"])
    {
    
        [self Events_view];
    }
    else if([_Header_name.titleLabel.text isEqualToString:@"Sports"])
    {
        
        [self Sports_view];
    }
    else if([_Header_name.titleLabel.text isEqualToString:@"Movies"])
    {
        [self Movies_view];
        
    }
    else if([_Header_name.titleLabel.text isEqualToString:@"Leisure"])
    {
        [self Leisure_view];
    }
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception:%@",exception);
    }
    
//    [_BTN_comin_soon setTitleColor:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0] forState:UIControlStateHighlighted];
//     [_BTN_top_movies setTitleColor:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0] forState:UIControlStateHighlighted];
//     [_BTN_now_showing setTitleColor:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0] forState:UIControlStateHighlighted];

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
    

}
-(void)Movies_view
{
   
    [self API_movie];
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
    
    if([item.title isEqualToString:@"Events"])
    {
       
       if(_VW_sports.hidden == YES || _VW_Movies.hidden == YES)
       {
           
             [self Events_view];
       }
       else
       {
           self.VW_sports.hidden = YES;
           _VW_Movies.hidden = YES;
            [self Events_view];
           
       }
        [self.VW_event addSubview:VW_overlay];

        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(Events_API_CALL) withObject:activityIndicatorView afterDelay:0.01];
       
       
        [self ATTRIBUTE_TEXT];
        
    }
    else if([item.title isEqualToString:@"Sports"])
    {
      
        if(_VW_event.hidden == YES || _VW_Movies.hidden == YES)
        {
            [self Sports_view];
        }
        else
        {
            self.VW_event.hidden = YES;
            _VW_Movies.hidden = YES;
            [self Sports_view];
            
        }
        [self.VW_sports addSubview:VW_overlay];
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(Sports_API_call) withObject:activityIndicatorView afterDelay:0.01];
        
        
    }
    else if([item.title isEqualToString:@"Movies"])
    {
        [self API_movie];
        if(_VW_event.hidden == YES || _VW_sports.hidden == YES)
        {
            [self Movies_view];
        }
        else
        {
            self.VW_event.hidden = YES;
            _VW_sports.hidden = YES;
            [self Movies_view];
            
        }
        
        [self.VW_Movies addSubview:VW_overlay];

        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(movie_API_CALL) withObject:activityIndicatorView afterDelay:0.01];

        
    }
    else if([item.title isEqualToString:@"Leisure"])
    {
       
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
        [self.VW_Leisure addSubview:VW_overlay];
        
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(Leisure_API_call) withObject:activityIndicatorView afterDelay:0.01];
        
    }

    else if([item.title isEqualToString:@"Shop"])
    {
        [self performSegueWithIdentifier:@"Hom_detail_Shop" sender:self];
    }
     [_Header_name setTitle:item.title forState:UIControlStateNormal];
    
}

-(void)ATTRIBUTE_TEXT
{
    NSString *str = @"";
    NSString *text = [NSString stringWithFormat:@"VENUES %@",str];
    
    
    if ([_BTN_venues.titleLabel respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_BTN_venues.titleLabel.textColor,
                                  NSFontAttributeName: _BTN_venues.titleLabel.font
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
        [_BTN_venues setAttributedTitle:attributedText forState:UIControlStateNormal];
    }
    else
    {
        [_BTN_venues setTitle:text forState:UIControlStateNormal];
    }
    
    NSString *lang = @"";
    NSString *lang_text = [NSString stringWithFormat:@"ALL LANGUAGES %@",lang];
    
    
    if ([_BTN_all_lang.titleLabel respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_BTN_all_lang.titleLabel.textColor,
                                  NSFontAttributeName: _BTN_all_lang.titleLabel.font
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
        [_BTN_all_lang setAttributedTitle:attributedText forState:UIControlStateNormal];
    }
    else
    {
        [_BTN_all_lang setTitle:text forState:UIControlStateNormal];
    }
    NSString *cinema = @"";
    NSString *cinema_text = [NSString stringWithFormat:@"ALL CINEMA HALLS %@",cinema];
    
    
    if ([_BTN_all_halls.titleLabel respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_BTN_all_lang.titleLabel.textColor,
                                  NSFontAttributeName: _BTN_all_lang.titleLabel.font
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
        [_BTN_all_halls setAttributedTitle:attributedText forState:UIControlStateNormal];
    }
    else
    {
        [_BTN_all_halls setTitle:text forState:UIControlStateNormal];
    }

    
}

#pragma Table view delegates


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //array is your db, here we just need how many they are
    
    if(tableView == _TBL_event_list)
    {
         return Events_arr.count;
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

        NSMutableArray *events_dict = [Events_arr objectAtIndex:indexPath.section];

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
            cell.LBL_event_date.text = [NSString stringWithFormat:@"%@ - %@",[events_dict valueForKey:@"_startDate"],[events_dict valueForKey:@"_endDate"]];
            cell.LBL_event_location.text =  [events_dict valueForKey:@"_Venue"];
            cell.LBL_banner_label.hidden = YES;
            NSString *img_url = [events_dict valueForKey:@"_bannerURL"];
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
    else if(tableView == _TBL_sports_list)
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
        cell.LBL_event_date.text = [NSString stringWithFormat:@"%@ - %@",[sports_dict valueForKey:@"_startDate"],[sports_dict valueForKey:@"_endDate"]];
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
    else{
        events_cell *cell = (events_cell *)[tableView dequeueReusableCellWithIdentifier:@"event_cell"];
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
            cell.LBL_event_date.text = [NSString stringWithFormat:@"%@ - %@",[leisure_dict valueForKey:@"_startDate"],[leisure_dict valueForKey:@"_endDate"]];
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
   else  if(tableView == _TBL_sports_list)
    {
        @try
        {
        NSMutableDictionary *sports_dtl = [Sports_arr objectAtIndex:indexPath.section];
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   
    return 4;
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
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
}
-(void)event_detail
{
    
    [self performSegueWithIdentifier:@"leisure_detail_segue" sender:self];
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    

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
        NSString *img_url = [dict valueForKey:@"_thumbnail"];
        img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
        
        [cell.IMG_banner sd_setImageWithURL:[NSURL URLWithString:img_url]
                           placeholderImage:[UIImage imageNamed:@"logo.png"]
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
         NSString *img_url = [dict valueForKey:@"_thumbnail"];
         img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
         
         [cell.IMG_banner sd_setImageWithURL:[NSURL URLWithString:img_url]
                            placeholderImage:[UIImage imageNamed:@"logo.png"]
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
    else
    {
        NSDictionary *dict = [Movies_arr objectAtIndex:indexPath.row];
        
        
        if(indexPath.row % 5 == 0 && indexPath.row==0)
        {
            cell.LBL_movie_name.text =  [dict valueForKey:@"_name"];
            cell.LBL_rating.text = [NSString stringWithFormat:@"%@/10",[dict valueForKey:@"_IMDB_rating"]];
            cell.LBL_censor.text = [dict valueForKey:@"_Censor"];
            NSString *img_url = [dict valueForKey:@"_thumbURL"];
            img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
            
            [cell.IMG_banner sd_setImageWithURL:[NSURL URLWithString:img_url]
                               placeholderImage:[UIImage imageNamed:@"logo.png"]
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
                               placeholderImage:[UIImage imageNamed:@"logo.png"]
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
            
        }
        
        return cell;

    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int i = (int)indexPath.row;
    i = i +1;
    if(indexPath.row % 5 == 0 && indexPath.row==0)
    {
        return CGSizeMake(_Collection_movies.frame.size.width /2.02,284);
        
    }
    if(i % 5 == 0 && i!=0)
    {
        return CGSizeMake(_Collection_movies.frame.size.width,40);
        
    }

    else
    {
        return CGSizeMake(_Collection_movies.frame.size.width /2.02,284);
    }
   
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
       return 2;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int i = (int)indexPath.row;
    i = i +1;
    if(i % 5 == 0 && i!=0)
    {
        NSLog(@"mydata");
    }
}

#pragma segment craetion
#pragma segment methods
-(void) addSEgmentedControl
{
    self.segmentedControl4 = [[HMSegmentedControl alloc] initWithFrame:_VW_segment.frame];
    CGRect frame = self.segmentedControl4.frame;
    frame.size.width = self.navigationController.navigationBar.frame.size.width;
    self.segmentedControl4.frame = frame;
    
    self.segmentedControl4.sectionTitles = @[@"Now Showing", @"    Coming Soon  ",];
    
    self.segmentedControl4.backgroundColor = [UIColor clearColor];
    self.segmentedControl4.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:16]};
    self.segmentedControl4.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0],NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:16]};
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
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(movie_API_CALL) withObject:activityIndicatorView afterDelay:0.01];

        
       
    }
    else
    {
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(up_coming_API) withObject:activityIndicatorView afterDelay:0.01];

      
    }
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
-(void)Book_now_action:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[Movies_arr objectAtIndex:sender.tag] forKey:@"Movie_detail"];
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
        
     temp_dict = [xmlDoc valueForKey:@"Movies"];
    NSMutableArray *tmp_arr = [temp_dict valueForKey:@"movie"];
//NSLog(@"Response dictionary: %@", tmp_arr);
    NSArray *old_arr = tmp_arr;//[json_RESULT mutableCopy];
        
        NSMutableArray *new_arr = [[NSMutableArray alloc]init];
        
        int count = (int)[old_arr count];
        int index = 0;
        
        int tag = 0;
        
        for (int i = 0; i < count; )
        {
            i= i+1;
            if ((i % 5) == 0 && i != 0)
            {
                NSDictionary *tmp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Qtickets",@"Movies", nil];
                [new_arr addObject:tmp_dictin];
                count = count + 1;
                tag = tag + 1;
            }
            else
            {
                index = i - tag - 1;
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
-(void)up_coming_API
{
    @try {
        NSURL *URL = [[NSURL alloc] initWithString:@"https://api.q-tickets.com/V2.0/getupcomingmovies"];
        NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
        //NSLog(@"Response dictionary: %@", xmlDoc);
        
        temp_dict = [xmlDoc valueForKey:@"Movies"];
        NSMutableArray *tmp_arr = [temp_dict valueForKey:@"movie"];
        NSArray *old_arr = tmp_arr;//[json_RESULT mutableCopy];
        
        NSMutableArray *new_arr = [[NSMutableArray alloc]init];
        
        int count = (int)[old_arr count];
        int index = 0;
        
        int tag = 0;
        
        for (int i = 0; i < count; )
        {
            i= i+1;
            if ((i % 5) == 0 && i != 0)
            {
                NSDictionary *tmp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Qtickets",@"Movies", nil];
                [new_arr addObject:tmp_dictin];
                count = count + 1;
                tag = tag + 1;
            }
            else
            {
                index = i - tag - 1;
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
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    Events_arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"Events_arr"];
    [_TBL_event_list reloadData];
}
-(void)Sports_API_call
{
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    Sports_arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"Sports_arr"];
    [_TBL_sports_list reloadData];
}
-(void)Leisure_API_call
{
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    Leisure_arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"leisure_arr"];
    [_TBL_lisure_list reloadData];
}

-(void)API_movie
{
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(movie_API_CALL) withObject:activityIndicatorView afterDelay:0.01];
    
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
