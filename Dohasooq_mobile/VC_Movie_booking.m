//
//  VC_Movie_booking.m
//  Dohasooq_mobile
//
//  Created by Test User on 23/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_Movie_booking.h"
#import "cell_timings.h"
#import "cell_title_theatre.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XMLDictionary/XMLDictionary.h"
#import "MZDayPickerCell.h"
#import "HttpClient.h"


@interface VC_Movie_booking ()<UITableViewDelegate,UITableViewDataSource,MZDayPickerDelegate, MZDayPickerDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *collection_count,*table_count,*date_Arr;
    NSMutableDictionary *detail_dict;
    CGRect oldframe;
    float scrollheight;
//    UIView *VW_overlay;
//     UIActivityIndicatorView *activityIndicatorView;
    NSMutableArray *ARR_temp;
    NSString *dateString;
    NSDateFormatter *dateFormat;

}
@property (nonatomic,strong) NSDateFormatter *dateFormatter;


@end

@implementation VC_Movie_booking

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dateVIEW];
    [_BTN_trailer_watch addTarget:self action:@selector(BTN_trailer_watch) forControlEvents:UIControlEventTouchUpInside];
    

    detail_dict  = [[NSMutableDictionary alloc]init];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    ARR_temp = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.hidden = NO;
    
//    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    VW_overlay.clipsToBounds = YES;
//    //    VW_overlay.layer.cornerRadius = 10.0;
//    
//    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
//    activityIndicatorView.center = VW_overlay.center;
//    [VW_overlay addSubview:activityIndicatorView];
//    [self.view addSubview:VW_overlay];
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    dateString = [dateFormat stringFromDate:[NSDate date]];
    

    
//    VW_overlay.hidden = YES;
//    VW_overlay.hidden = NO;
//    [activityIndicatorView startAnimating];
     [HttpClient animating_images:self];
    [self performSelector:@selector(movie_detil_api) withObject:nil afterDelay:0.01];
}

-(void)filtering_date{
  
    date_Arr = [[NSMutableArray alloc]init];
  //  detail_dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"Movie_detail"];
    NSLog(@"%@",detail_dict);
    NSMutableArray *att = [[NSMutableArray alloc]init];
    ARR_temp = [[NSMutableArray alloc]init];
    
    @try
    {
        NSArray *temp_ar = [detail_dict valueForKey:@"Theatre"];
        for(int i = 0;i<temp_ar.count;i++)
        {
            
            
            att = [[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i] valueForKey:@"ShowDates"]valueForKey:@"showDate"] ;
            
            if([att isKindOfClass:[NSDictionary class]])
                
            {   //***********************
                [date_Arr addObject:[[[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i] valueForKey:@"ShowDates"] valueForKey:@"showDate"] valueForKey:@"_Date"]];
                //***********************
                
            }
            else{
                // NSLog(@"%lu",(unsigned long)att.count);
                
                for(int j =0;j< att.count;j++)
                {
                    @try
                    {
                        //************************
                        [date_Arr addObject:[[[[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i] valueForKey:@"ShowDates"] valueForKey:@"showDate"] objectAtIndex:j] valueForKey:@"_Date"]];
                        
                    }
                    
                    @catch(NSException *exception)
                    {
                        
                        
                    }
                }
                
            }
        }
        
        
    }
    @catch(NSException *exception)
    {
        
        [date_Arr addObject:[[[[detail_dict valueForKey:@"Theatre"] valueForKey:@"ShowDates"] valueForKey:@"showDate"] valueForKey:@"_Date"]];
    }
    
    
    NSMutableArray *arry_with_Dates = [NSMutableArray array];
    
    NSLog(@"Date Array is :::%@",date_Arr);
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    for (int i=0; i<date_Arr.count; i++) {
        
        if ([[date_Arr objectAtIndex:i] isKindOfClass:[NSArray class]]) {
            
            for (int j=0; j<[[date_Arr objectAtIndex:i] count]; j++) {
                NSDate *tomorrow = [cal dateByAddingUnit:NSCalendarUnitDay
                                                   value:1
                                                  toDate:[dateFormat dateFromString:[[date_Arr objectAtIndex:i] objectAtIndex:j]]
                                                 options:0];
                [arry_with_Dates addObject:tomorrow];
                
                // [arry_with_Dates addObject:[dateFormat dateFromString:[[date_Arr objectAtIndex:i] objectAtIndex:j]]];
                NSLog(@"%@",arry_with_Dates);
            }
        }
        else{
            NSDate *tomorrow = [cal dateByAddingUnit:NSCalendarUnitDay
                                               value:1
                                              toDate:[dateFormat dateFromString:[date_Arr objectAtIndex:i]]
                                             options:0];
            [arry_with_Dates addObject:tomorrow];
            
            
            //[arry_with_Dates addObject:[dateFormat dateFromString:[date_Arr objectAtIndex:i]]];
            NSLog(@"%@",arry_with_Dates);
            
        }
        
    }
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"self"
                                                               ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *reverseOrder = [arry_with_Dates sortedArrayUsingDescriptors:descriptors];
    NSLog(@"Date Array is :::%@",reverseOrder);
    NSDate *endDate = [reverseOrder firstObject];
    //[dateFormat dateFromString:[reverseOrder firstObject]];
    NSLog(@"%@",[reverseOrder lastObject]);
    
    [self.dayPicker setStartDate:[reverseOrder lastObject] endDate:endDate];
    
    NSDate *yesterDay = [cal dateByAddingUnit:NSCalendarUnitDay
                                        value:-1
                                       toDate:[reverseOrder lastObject]
                                      options:0];
    dateString = [dateFormat stringFromDate:yesterDay];
    
    NSLog(@"Tickets available from%@",[reverseOrder lastObject]);
    NSArray *arr = [dateString componentsSeparatedByString:@"/"];
    
    
    [self.dayPicker setCurrentDate:[NSDate dateFromDay:[[arr objectAtIndex:1] intValue] month:[[arr objectAtIndex:0]intValue] year:[[arr objectAtIndex:2]intValue]] animated:NO];
    
//    NSString *temp_s = [arr componentsJoinedByString:@"/"];
//    NSDateFormatter *df = [[NSDateFormatter alloc]init];
//    [df setDateFormat:@"MM/dd/yyyy"];
//    NSDate *dat = [df dateFromString:temp_s];
//    [df setDateFormat:@"yyyy-MM-dd"];
//    NSString *strt = [df stringFromDate:dat];

    [[NSUserDefaults standardUserDefaults] setValue:dateString forKey:@"movie_date"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
}

-(void)getResponse_detail
{
    collection_count = [[NSMutableArray alloc]init];
    table_count = [[NSMutableArray alloc]init];
//    detail_dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"Movie_detail"];
    NSMutableArray *att = [[NSMutableArray alloc]init];
    NSMutableArray *dict_time = [[NSMutableArray alloc]init];
    
    NSLog(@"THE REPONSE DETAIL IS:%@",detail_dict);
     ARR_temp = [[NSMutableArray alloc]init];
    NSMutableArray *temp_arr = [[NSMutableArray alloc]init];;
    
    @try
    {
        NSArray *temp_ar = [detail_dict valueForKey:@"Theatre"];
        NSInteger count;
        if([temp_ar isKindOfClass:[NSDictionary class]])
        {
            count = 1;
            
        }
        else
        {
            count = temp_ar.count;
        }
        for(int i = 0;i<count;i++)
        {
            
            att = [[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i] valueForKey:@"ShowDates"]valueForKey:@"showDate"] ;
            
            if([att isKindOfClass:[NSDictionary class]])
            {

                if([[[[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i] valueForKey:@"ShowDates"]valueForKey:@"showDate"]  valueForKey:@"_Date"] isEqualToString:dateString])

                {
                    [dict_time addObject:@{@"english":[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i] valueForKey:@"_name"],@"arabic":[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i]valueForKey:@"_arabicname"]}];
                    [temp_arr addObject:@{@"theatre":[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i] valueForKey:@"_name"],@"shows":[[[[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i]valueForKey:@"ShowDates"]valueForKey:@"showDate"]valueForKey:@"ShowTimes"] valueForKey:@"showTime"]}];
                   

                   
                }
                
            }
            else{
            NSLog(@"%lu",(unsigned long)att.count);

            for(int j =0;j< att.count;j++)
            {
                @try
                {

                if([[[[[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i] valueForKey:@"ShowDates"]valueForKey:@"showDate"]objectAtIndex:j]  valueForKey:@"_Date"] isEqualToString:dateString])

                {
                    [dict_time addObject:@{@"english":[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i] valueForKey:@"_name"],@"arabic":[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i]valueForKey:@"_arabicname"]}];


                    [temp_arr addObject:@{@"theatre":[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i] valueForKey:@"_name"],@"shows":[[[[[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i]valueForKey:@"ShowDates"]valueForKey:@"showDate"]objectAtIndex:j] valueForKey:@"ShowTimes"] valueForKey:@"showTime"]}];
                   
                   
                }
                }
                
                @catch(NSException *exception)
                {
                  

                }
            }
        
          
                
            }
        }

        
    }
    @catch(NSException *exception)
    {
       
        att = [[[detail_dict valueForKey:@"Theatre"] valueForKey:@"ShowDates"]valueForKey:@"showDate"];
       
        if([att isKindOfClass:[NSDictionary class]])
        {

            if([[[[[detail_dict valueForKey:@"Theatre"] valueForKey:@"ShowDates"]valueForKey:@"showDate"]  valueForKey:@"_Date"] isEqualToString:dateString])

            {
                [dict_time addObject:@{@"english":[[detail_dict valueForKey:@"Theatre"]  valueForKey:@"_name"],@"arabic":[[detail_dict valueForKey:@"Theatre"] valueForKey:@"_arabicname"]}];
                [temp_arr addObject:@{@"theatre":[[detail_dict valueForKey:@"Theatre"]  valueForKey:@"_name"],@"shows":[[[[[detail_dict valueForKey:@"Theatre"] valueForKey:@"ShowDates"]valueForKey:@"showDate"]valueForKey:@"ShowTimes"] valueForKey:@"showTime"]}];
                
            }
        }
            
       
        else{

        for(int j =0; j< att.count;j++)
        {
            @try
            {

            if([[[[[[detail_dict valueForKey:@"Theatre"]  valueForKey:@"ShowDates"]valueForKey:@"showDate"]objectAtIndex:j]  valueForKey:@"_Date"] isEqualToString:dateString])

            {
                [dict_time addObject:@{@"english":[[detail_dict valueForKey:@"Theatre"]  valueForKey:@"_name"],@"arabic":[[detail_dict valueForKey:@"Theatre"] valueForKey:@"_arabicname"]}];
                
                [temp_arr addObject:@{@"theatre":[[detail_dict valueForKey:@"Theatre"] valueForKey:@"_name"],@"shows":[[[[[[detail_dict valueForKey:@"Theatre"] valueForKey:@"ShowDates"]valueForKey:@"showDate"]objectAtIndex:j] valueForKey:@"ShowTimes"] valueForKey:@"showTime"]}];
            }
        }
            @catch(NSException *exception)
            
            {
                
            }
        }
        

    }
    }
    
    [ARR_temp addObjectsFromArray:temp_arr];
    [collection_count addObjectsFromArray:dict_time];
    NSLog(@"the added array is:%@",ARR_temp);

    
    
   // NSLog(@"the added array is:%@",table_count);
    NSLog(@"the added array is:%@",collection_count);
    
    [_tbl_timings reloadData];
    
    
  [self set_UP_VIEW];
    
     [HttpClient stop_activity_animation];
     [self viewDidLayoutSubviews];
}


-(void)set_UP_VIEW
{
    
    _LBL_movie_description.numberOfLines = 3;
    
    CGRect frameset = _VW_dtl_movie.frame;
    frameset.size.width = self.Scroll_contents.frame.size.width;
    _VW_dtl_movie.frame = frameset;
    
    [self.Scroll_contents addSubview:_VW_dtl_movie];
    @try
    {
    _LBL_movie_description.text = [NSString stringWithFormat:@"%@",[detail_dict valueForKey:@"_Description"]];
    }
   @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
                                   

    frameset = _VW_about_movie.frame;
    frameset.origin.y = _VW_dtl_movie.frame.origin.y + _VW_dtl_movie.frame.size.height;
    frameset.size.height = _BTN_view_more.frame.origin.y + _BTN_view_more.frame.size.height;
    frameset.size.width = self.Scroll_contents.frame.size.width;
    _VW_about_movie.frame = frameset;
    oldframe = _LBL_movie_description.frame;
    
    [self.Scroll_contents addSubview:_VW_about_movie];
    
      [_tbl_timings reloadData];
    
    frameset = self.tbl_timings.frame;
    frameset.size.height =  _tbl_timings.contentSize.height;
    self.tbl_timings.frame = frameset;
    
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = CGRectMake(_VW_timings.frame.origin.x, _VW_timings.frame.origin.y, [UIScreen mainScreen].bounds.size.width, _tbl_timings.contentSize.height);
//    gradient.colors = @[(id)[UIColor colorWithRed:0.00 green:0.06 blue:0.11 alpha:1.0].CGColor, (id)[UIColor colorWithRed:0.13 green:0.16 blue:0.17 alpha:1.0].CGColor];
//    
//    [_VW_timings.layer insertSublayer:gradient atIndex:0];
  
    
    frameset = self.VW_timings.frame;
    frameset.origin.y = _VW_about_movie.frame.origin.y + _VW_about_movie.frame.size.height;
    frameset.size.height = _tbl_timings.frame.origin.y + _tbl_timings.frame.size.height;
     frameset.size.width = self.Scroll_contents.frame.size.width;
    _VW_timings.frame = frameset;
    [self.Scroll_contents addSubview:_VW_timings];
    
    scrollheight = _VW_timings.frame.origin.y + _VW_timings.frame.size.height;
    @try
    {
       self.LBL_movie_name.text =  [detail_dict valueForKey:@"_name"];
        self.LBL_rating.text = [NSString stringWithFormat:@"%@/10",[detail_dict valueForKey:@"_IMDB_rating"]];
      _LBL_censor.text = [detail_dict valueForKey:@"_Censor"];
        NSString *img_url = [detail_dict valueForKey:@"_iphonethumb"];
        img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
        [self.IMG_movie sd_setImageWithURL:[NSURL URLWithString:img_url]
                           placeholderImage:[UIImage imageNamed:@"upload-8.png"]
                                    options:SDWebImageRefreshCached];
        int time = [[detail_dict valueForKey:@"_Duration"] intValue];
        int hours = time / 60;
        int minutes = time % 60;
       self.lbl_duration.text = [NSString stringWithFormat:@"%d hr %d min",hours,minutes];

    NSString *str = [detail_dict valueForKey:@"_Languageid"];
    NSString *sub_str = [detail_dict valueForKey:@"_MovieType"];
    NSString *text = [NSString stringWithFormat:@"%@      %@",str,sub_str];
    
    
    if ([_LBL_language respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_language.textColor,
                                  NSFontAttributeName:_LBL_language.font
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
       _LBL_language.attributedText = attributedText;
    }
    else
    {
        _LBL_language.text = text;
    }
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    

    
    _BTN_trailer_watch.layer.cornerRadius = 1.0f;
    _BTN_trailer_watch.layer.masksToBounds = YES;
    [_BTN_view_more addTarget:self action:@selector(viewmore_selcted) forControlEvents:UIControlEventTouchUpInside];
//    [self dateVIEW];
    
}
-(void)BTN_trailer_watch
{
    if([[detail_dict valueForKey:@"_TrailerURL"] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Trailer video is not available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];

        
    }
    else
    {
    NSArray *str_arr = [[detail_dict valueForKey:@"_TrailerURL"] componentsSeparatedByString:@"embed/"];
    
    [[NSUserDefaults standardUserDefaults] setValue:[str_arr objectAtIndex:1]  forKey:@"str_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSegueWithIdentifier:@"player_View" sender:self];
    }
}

-(void)dateVIEW
{
    self.dayPicker.delegate = self;
    self.dayPicker.dataSource = self;
    
    self.dayPicker.dayNameLabelFontSize = 12.0f;
    self.dayPicker.dayLabelFontSize = 18.0f;
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"EE"];
    
    
    
//    [self.dayPicker setStartDate:[NSDate dateFromDay:28 month:9 year:2013] endDate:[NSDate dateFromDay:5 month:10 year:2013]];
//    
//    [self.dayPicker setCurrentDate:[NSDate dateFromDay:3 month:10 year:2013] animated:NO];
    NSDate *sevenDays;
    NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    switch ([component weekday]) {
            
        case 1://Sunday
            sevenDays = [[NSDate date] dateByAddingTimeInterval:60*60*24*3];
            break;
            
        case 2://Monday
            sevenDays = [[NSDate date] dateByAddingTimeInterval:60*60*24*2];
            break;
            
        case 3://Tuesday
            sevenDays = [[NSDate date] dateByAddingTimeInterval:60*60*24*1];
            break;
            
        case 4://wednsday
            sevenDays = [[NSDate date] dateByAddingTimeInterval:60*60*24*7];
            break;
            
        case 5://Thursday
            sevenDays = [[NSDate date] dateByAddingTimeInterval:60*60*24*6];
            
            
            break;
        case 6:  //Friday
            sevenDays = [[NSDate date] dateByAddingTimeInterval:60*60*24*5];
          
            break;

        case 7: //Saturday

            sevenDays = [[NSDate date] dateByAddingTimeInterval:60*60*24*4];
            break;
        default:
            break;
    }
    
    
    
    
//    
//    NSDate *currentDate = [NSDate date];
//    //NSDate *sevenDays = [[NSDate date] dateByAddingTimeInterval:60*60*24*7];
//
//    
//    [self.dayPicker setStartDate:currentDate endDate:sevenDays];
//    [self.dayPicker setCurrentDate:currentDate animated:NO];
//    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_contents layoutIfNeeded];
    _Scroll_contents.contentSize = CGSizeMake(_Scroll_contents.frame.size.width,scrollheight);
    
    
}
-(void)viewmore_selcted
{
    if([_BTN_view_more.titleLabel.text isEqualToString:@"View more"])
    {
    _LBL_movie_description.numberOfLines = 0;
    [_LBL_movie_description sizeToFit];
    CGRect frameset = _BTN_view_more.frame;
    frameset.origin.y = _LBL_movie_description.frame.origin.y + _LBL_movie_description.frame.size.height;
    _BTN_view_more.frame = frameset;
        
    frameset = _VW_about_movie.frame;
    frameset.size.height = _BTN_view_more.frame.origin.y + _BTN_view_more.frame.size.height;
    _VW_about_movie.frame = frameset;
     
    frameset = _VW_timings.frame;
    frameset.origin.y = _VW_about_movie.frame.origin.y + _VW_about_movie.frame.size.height ;
    frameset.size.height = _tbl_timings.frame.origin.y + _tbl_timings.frame.size.height;

    _VW_timings.frame = frameset;
    scrollheight = _VW_timings.frame.origin.y + _VW_timings.frame.size.height;
    [self viewDidLayoutSubviews];

    [_BTN_view_more setTitle:@"Show less" forState:UIControlStateNormal];
    }
    else
    {
        
        CGRect frameset =_LBL_movie_description.frame;
        frameset = oldframe;
        _LBL_movie_description.frame = frameset;
        
         frameset = _BTN_view_more.frame;
        frameset.origin.y = _LBL_movie_description.frame.origin.y + _LBL_movie_description.frame.size.height +3;
        _BTN_view_more.frame = frameset;
        
        frameset = _VW_about_movie.frame;
        frameset.size.height = _BTN_view_more.frame.origin.y + _BTN_view_more.frame.size.height +5;
        _VW_about_movie.frame = frameset;
        
        frameset = _VW_timings.frame;
        frameset.origin.y = _VW_about_movie.frame.origin.y + _VW_about_movie.frame.size.height +5;
        frameset.size.height = _tbl_timings.frame.origin.y + _tbl_timings.frame.size.height;
        _VW_timings.frame = frameset;
        scrollheight = _VW_timings.frame.origin.y + _VW_timings.frame.size.height;

         [self viewDidLayoutSubviews];
        
        
        [_BTN_view_more setTitle:@"View more" forState:UIControlStateNormal];

        
    }

    
    
}
#pragma Tbale view delagets
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{  // NSLog(@"%lu %@",(unsigned long)[collection_count count],collection_count);
    return collection_count.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell_title_theatre *cell = (cell_title_theatre *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    @try
    {

        cell.TXT_name.text = [NSString stringWithFormat:@"%@ %@",[[collection_count objectAtIndex:indexPath.row]valueForKey:@"english"],[[collection_count objectAtIndex:indexPath.row]valueForKey:@"arabic"]];
        [cell.collection_timings setTag:indexPath.row];
        [cell.collection_timings reloadData];

    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
   
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"***********"); // you can see selected row number in your console;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        if([[[ARR_temp objectAtIndex:indexPath.row] valueForKey:@"shows"] isKindOfClass:[NSDictionary class]] || [[[ARR_temp objectAtIndex:indexPath.row]valueForKey:@"shows"] count]<=4)
        {
            return 80;
        }
        
        else if ([[[ARR_temp objectAtIndex:indexPath.row] valueForKey:@"shows"]count]>4 && [[[ARR_temp objectAtIndex:indexPath.row] valueForKey:@"shows"]count]<=8 ){
            return 180;
        }
        
        else{
            return 77*[[[ARR_temp objectAtIndex:indexPath.row]valueForKey:@"shows"] count]/4;
        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
}

#pragma DatePicker
- (NSString *)dayPicker:(MZDayPicker *)dayPicker titleForCellDayNameLabelInDay:(MZDay *)day
{
           return [self.dateFormatter stringFromDate:day.date];
}


- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
{
    dateString = [dateFormat stringFromDate:day.date];
    [[NSUserDefaults standardUserDefaults] setValue:dateString forKey:@"movie_date"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self getResponse_detail];
    [self set_UP_VIEW];
     NSLog(@"Did select day %@",dateString);


}
- (void)dayPicker:(MZDayPicker *)dayPicker willSelectDay:(MZDay *)day
{
   NSLog(@"Did select day %@",day.date);
   
}

#pragma collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    NSInteger count=0;
    
 /*   for(int i = 0; i<ARR_temp.count;i++)
            {
                if(([[ARR_temp objectAtIndex:i] isKindOfClass:[NSDictionary class]]))
                {
                    count =[[ARR_temp objectAtIndex:i]count];
        
                 }
                else
                {
                    for(int j=0;j<[[ARR_temp objectAtIndex:i] count];j++)
                    {
                        [table_count addObject:[[ARR_temp objectAtIndex:i]objectAtIndex:j]];
                    }
                    count = table_count.count;
        
            }
            }

    */
    
    
    for (int i = 0; i < [ARR_temp count]; i++) {
        if (collectionView.tag == i) {
            if(([[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"shows"] isKindOfClass:[NSDictionary class]]))
            {
                count = 1;
                
            }
            else
            {
//                for(int j=0;j<[[ARR_temp objectAtIndex:i] count];j++)
//                {
//                    [table_count addObject:[[ARR_temp objectAtIndex:section]objectAtIndex:j]];
//                }
                count = [[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"shows"] count];//table_count.count;
                
            }

        }
    }
    //NSLog(@"ARR_temp %@******",ARR_temp);
    return count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell_timings *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    

    @try {
        if (ARR_temp.count==0) {
            cell.BTN_time.text = @"No shows Available";
            cell.BTN_time.textColor = [UIColor redColor];
            cell.BTN_time.backgroundColor = [UIColor clearColor];
        }

        
       else if(([[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"shows"] isKindOfClass:[NSDictionary class]]))
        {
            
            cell.BTN_time.text =[[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"shows"]valueForKey:@"_time"] ;
           // [cell.BTN_time setTitle:[[ARR_temp objectAtIndex:collectionView.tag]valueForKey:@"_time"] forState:UIControlStateNormal];
            
            if ([[[[ARR_temp objectAtIndex:collectionView.tag]valueForKey:@"shows" ] valueForKey:@"_type"] isEqualToString:@"available"]) {
                [cell.BTN_time setBackgroundColor:[UIColor colorWithRed:67.0f/255.0f green:83.0f/255.0f blue:91.0f/255.0f alpha:1.0f]];
                
            }
            else{
                [cell.BTN_time setBackgroundColor:[UIColor redColor]];
            }
            
           
            
        }
        
        else{
            
            cell.BTN_time.text =[[[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"shows"]objectAtIndex:indexPath.row]valueForKey:@"_time"];

            //[cell.BTN_time setTitle:[[[ARR_temp objectAtIndex:collectionView.tag] objectAtIndex:indexPath.row]valueForKey:@"_time"] forState:UIControlStateNormal];
            
            if ([[[[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"shows"]valueForKey:@"_type"]objectAtIndex:indexPath.row] isEqualToString:@"available"]) {
                
                [cell.BTN_time setBackgroundColor:[UIColor colorWithRed:67.0f/255.0f green:83.0f/255.0f blue:91.0f/255.0f alpha:1.0f]];
            }
            else{
                [cell.BTN_time setBackgroundColor:[UIColor redColor]];
            }
        }
        
        
    } @catch (NSException *exception) {
        
        NSLog(@"%@",exception);
    }
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if(result.height <= 480)
    {
        // iPhone Classic
        cell.BTN_time.font = [UIFont fontWithName:@"Poppins" size:12];
        cell.BTN_time.textAlignment = NSTextAlignmentJustified;
        
        
    }
    else if(result.height <= 568)
    {
        // iPhone 5
        cell.BTN_time.font = [UIFont fontWithName:@"Poppins" size:12];
        cell.BTN_time.textAlignment = NSTextAlignmentJustified;
        
        
        
    }
    else
    {
        cell.BTN_time.font = [UIFont fontWithName:@"Poppins" size:13];
        cell.BTN_time.textAlignment = NSTextAlignmentCenter;

        
    }


      return cell;
}


    
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    @try {
        
        
        if(([[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"shows"] isKindOfClass:[NSDictionary class]]))
        {
            if([[[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"shows"] valueForKey:@"_type"] isEqualToString:@"available"])
            {
            [[NSUserDefaults standardUserDefaults] setValue:[[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"shows"] valueForKey:@"_id"] forKey:@"movie_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"movie_date"];
//            [[NSUserDefaults standardUserDefaults] synchronize];

            [[NSUserDefaults standardUserDefaults] setValue:dateString forKey:@"movie_date"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSegueWithIdentifier:@"booking_seat" sender:self];
            [[NSUserDefaults standardUserDefaults] setValue:[[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"shows"] valueForKey:@"_time"] forKey:@"movie_time"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults] setValue:[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"theatre"] forKey:@"theatre"];
            [[NSUserDefaults standardUserDefaults] synchronize];


            NSLog(@"Selected Time Detail %@",[ARR_temp objectAtIndex:collectionView.tag]);
                NSString *str_censor = [_LBL_censor.text stringByReplacingOccurrencesOfString:@"PG -" withString:@""];
                
                NSString *text_str =[NSString stringWithFormat:@"You Are trying to book a %@ Rated movie.\nEntrance is not allowed for person below %@ years old.\nSupervisor Reserves the Right to Reject Without Refund \n\n  أنت تحاول حجز فيلم تصنيفه %@\n يمنع الدخول لمن تقل أعمارهم عن %@\nويحتفظ مشرف السينما بالحق في رفض دخول الفيلم دون إرجاع سعر التذكرة في حال مخالفة القوانين ",str_censor,str_censor,str_censor,str_censor];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Caution" message:text_str delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                alert.tag = 0;
                [alert show];
               
              //  [self performSegueWithIdentifier:@"booking_seat" sender:self];

            }
            
        }
        else{
            if([[[[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"shows"]objectAtIndex:indexPath.row] valueForKey:@"_type"] isEqualToString:@"available"])
            {
            NSLog(@"Selected Time Detail %@",[[[ARR_temp objectAtIndex:collectionView.tag]  valueForKey:@"shows"]objectAtIndex:indexPath.row]);
            [[NSUserDefaults standardUserDefaults] setValue:[[[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"shows"]objectAtIndex:indexPath.row] valueForKey:@"_id"] forKey:@"movie_id"];
             [[NSUserDefaults standardUserDefaults] synchronize];

            [[NSUserDefaults standardUserDefaults] setValue:dateString forKey:@"movie_date"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setValue:[[[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"shows"] objectAtIndex:indexPath.row] valueForKey:@"_time"] forKey:@"movie_time"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setValue:[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"theatre"] forKey:@"theatre"];
            [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSString *str_censor = [_LBL_censor.text stringByReplacingOccurrencesOfString:@"PG -" withString:@""];
                
                NSString *text_str =[NSString stringWithFormat:@"You Are trying to book a %@ Rated movie.\nEntrance is not allowed for person below %@ years old.\nSupervisor Reserves the Right to Reject Without Refund. \n\n  أنت تحاول حجز فيلم تصنيفه %@\n يمنع الدخول لمن تقل أعمارهم عن %@\nويحتفظ مشرف السينما بالحق في رفض دخول الفيلم دون إرجاع سعر التذكرة في حال مخالفة القوانين ",str_censor,str_censor,str_censor,str_censor];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Caution" message:text_str delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                alert.tag = 1;

                [alert show];
               
                

            }
          

          
        }
        
  
        
    } @catch (NSException *exception) {
        
        NSLog(@"%@",exception);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(([[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"shows"] isKindOfClass:[NSDictionary class]]))
        {
            if(result.height <= 480)
            {
              return CGSizeMake(collectionView.frame.size.width/3.5, 40);
            }
            else{
                return CGSizeMake(collectionView.frame.size.width/4.37, 40);
            }


            
        }
        else
        {
            if(result.height <= 480)
        {
             return CGSizeMake(collectionView.frame.size.width/3.5, 40);
        }
        else{
            return CGSizeMake(collectionView.frame.size.width/4.39, 40);
        }
            
        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}

#pragma Button_Actions

-(void)ok_action
{
    [HttpClient stop_activity_animation];
    _VW_alert.hidden = YES;
}
- (IBAction)back_action:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Theater filter 
- (IBAction)share_action:(id)sender
{
    if([[detail_dict valueForKey:@"_TrailerURL"] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No video available to share" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
        
    }
    else
    {
    NSString *trailer_URL= [detail_dict valueForKey:@"_TrailerURL"];
    NSArray* sharedObjects=[NSArray arrayWithObjects:trailer_URL,  nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]                                                                initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:nil];
    }
}
-(void)movie_detil_api
{
    @try {
        
        NSString *str_url = [NSString stringWithFormat:@"https://api.q-tickets.com/V4.0/getshowstheatersbymovieid?movieid=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"id"]];
        
        
        NSURL *URL = [[NSURL alloc] initWithString:str_url];
        NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
        //NSLog(@"string: %@", xmlString);
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Movie_detail"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        [[NSUserDefaults standardUserDefaults] setObject:[[xmlDoc valueForKey:@"Movies"] valueForKey:@"movie"] forKey:@"Movie_detail"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
        
        detail_dict = [[xmlDoc valueForKey:@"Movies"] valueForKey:@"movie"] ;//
        [[NSUserDefaults standardUserDefaults]setObject:detail_dict forKey:@"Movie_detail"] ;
        [[NSUserDefaults standardUserDefaults] synchronize];

        
        [self filtering_date];
        [self getResponse_detail];
    }
    @catch(NSException *exception)
    {
        NSLog(@"exception");
        
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            NSLog(@"cancel:");
            [alertView dismissWithClickedButtonIndex:0 animated:nil];
            
        }
        
        else{
            
            
            [self performSegueWithIdentifier:@"booking_seat" sender:self];
        }
    }
    if(alertView.tag == 0)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            NSLog(@"cancel:");
            [alertView dismissWithClickedButtonIndex:0 animated:nil];
            
        }
        
        else{
            
            
            [self performSegueWithIdentifier:@"booking_seat" sender:self];
        }
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
