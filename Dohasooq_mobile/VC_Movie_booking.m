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


@interface VC_Movie_booking ()<UITableViewDelegate,UITableViewDataSource,MZDayPickerDelegate, MZDayPickerDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *collection_count,*table_count;
    NSMutableDictionary *detail_dict;
    CGRect oldframe;
    float scrollheight;
    UIView *VW_overlay;
     UIActivityIndicatorView *activityIndicatorView;
    NSMutableArray *ARR_temp;
    NSString *dateString;
    NSDateFormatter *dateFormat;

}
@property (nonatomic,strong) NSDateFormatter *dateFormatter;


@end

@implementation VC_Movie_booking

- (void)viewDidLoad {
    [super viewDidLoad];
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    dateString = [dateFormat stringFromDate:[NSDate date]];


   // [self set_UP_VIEW];
    [self dateVIEW];

    
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
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(getResponse_detail) withObject:activityIndicatorView afterDelay:0.01];
}
-(void)getResponse_detail
{
    collection_count = [[NSMutableArray alloc]init];
    table_count = [[NSMutableArray alloc]init];
    detail_dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"Movie_detail"];
    NSMutableArray *att = [[NSMutableArray alloc]init];
    NSMutableArray *dict_time = [[NSMutableArray alloc]init];
    
    NSLog(@"THE REPONSE DETAIL IS:%@",detail_dict);
     ARR_temp = [[NSMutableArray alloc]init];
    NSMutableArray *temp_arr = [[NSMutableArray alloc]init];;
    
    @try
    {
        NSArray *temp_ar = [detail_dict valueForKey:@"Theatre"];
        for(int i = 0;i<temp_ar.count;i++)
        {
            
            att = [[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i] valueForKey:@"ShowDates"]valueForKey:@"showDate"] ;
            
            if([att isKindOfClass:[NSDictionary class]])
            {
                if([[[[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i] valueForKey:@"ShowDates"]valueForKey:@"showDate"]  valueForKey:@"_Date"] isEqualToString:dateString])
                {
                [dict_time addObject:[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i] valueForKey:@"_name"]];
                   [temp_arr addObject:[[[[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i]valueForKey:@"ShowDates"]valueForKey:@"showDate"]valueForKey:@"ShowTimes"] valueForKey:@"showTime"]];
                   
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
                    [collection_count addObject:[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i] valueForKey:@"_name"]];

                    [ARR_temp addObject:[[[[[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:i]valueForKey:@"ShowDates"]valueForKey:@"showDate"]objectAtIndex:j] valueForKey:@"ShowTimes"] valueForKey:@"showTime"]];
                   
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
            if([[[[[detail_dict valueForKey:@"Theatre"]  valueForKey:@"ShowDates"]valueForKey:@"showDate"]  valueForKey:@"_Date"] isEqualToString:dateString])
            {
                [dict_time addObject:[[detail_dict valueForKey:@"Theatre"]  valueForKey:@"_name"]];
                [temp_arr addObject:[[[[[detail_dict valueForKey:@"Theatre"] valueForKey:@"ShowDates"]valueForKey:@"showDate"]valueForKey:@"ShowTimes"] valueForKey:@"showTime"]];
                
            }
        }
            
       
        else{

        for(int j =0; j< att.count;j++)
        {
            @try
            {
            if([[[[[[detail_dict valueForKey:@"Theatre"]  valueForKey:@"ShowDates"]valueForKey:@"showDate"]objectAtIndex:j]  valueForKey:@"_Date"] isEqualToString:dateString])
            {
            [dict_time addObject:[[detail_dict valueForKey:@"Theatre"] valueForKey:@"_name"]];
                
               [ARR_temp addObject:[[[[[[detail_dict valueForKey:@"Theatre"] valueForKey:@"ShowDates"]valueForKey:@"showDate"]objectAtIndex:j] valueForKey:@"ShowTimes"] valueForKey:@"showTime"]];
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
    
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
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
    
    frameset = self.VW_timings.frame;
    frameset.origin.y = _VW_about_movie.frame.origin.y + _VW_about_movie.frame.size.height;
     frameset.size.width = self.Scroll_contents.frame.size.width;
    _VW_timings.frame = frameset;
    [self.Scroll_contents addSubview:_VW_timings];
    
    scrollheight = _VW_timings.frame.origin.y + _VW_timings.frame.size.height;
    @try
    {
       self.LBL_movie_name.text =  [detail_dict valueForKey:@"_name"];
        self.LBL_rating.text = [NSString stringWithFormat:@"%@/10",[detail_dict valueForKey:@"_IMDB_rating"]];
      _LBL_censor.text = [detail_dict valueForKey:@"_Censor"];
        NSString *img_url = [detail_dict valueForKey:@"_thumbnail"];
        img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
        [self.IMG_movie sd_setImageWithURL:[NSURL URLWithString:img_url]
                           placeholderImage:[UIImage imageNamed:@"logo.png"]
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
    
    
    
    
    
    NSDate *currentDate = [NSDate date];
    //NSDate *sevenDays = [[NSDate date] dateByAddingTimeInterval:60*60*24*7];

    
    [self.dayPicker setStartDate:currentDate endDate:sevenDays];
    [self.dayPicker setCurrentDate:currentDate animated:NO];
    
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

        cell.TXT_name.text = [collection_count objectAtIndex:indexPath.row];
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
        if([[ARR_temp objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]] )
        {
            return 80;
        }
        
      else if ([[ARR_temp objectAtIndex:indexPath.row] count]>8){
            return 180;
        }
        else{
            return 160;
        }
        //else{
        //return 80*[[ARR_temp objectAtIndex:indexPath.row] count]/4;
        //}

        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
//    if([[ARR_temp valueForKey:@"Theatre_name"] count] < 3)
//    {
//        return 75;
//    }
//    else
//    {
//        return 160;
    //    }
    
}

#pragma DatePicker
- (NSString *)dayPicker:(MZDayPicker *)dayPicker titleForCellDayNameLabelInDay:(MZDay *)day
{
    return [self.dateFormatter stringFromDate:day.date];
}


- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
{
    dateString = [dateFormat stringFromDate:day.date];
    [self getResponse_detail];
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
            if(([[ARR_temp objectAtIndex:collectionView.tag] isKindOfClass:[NSDictionary class]]))
            {
                count = 1;
                
            }
            else
            {
//                for(int j=0;j<[[ARR_temp objectAtIndex:i] count];j++)
//                {
//                    [table_count addObject:[[ARR_temp objectAtIndex:section]objectAtIndex:j]];
//                }
                count = [[ARR_temp objectAtIndex:collectionView.tag] count];//table_count.count;
                
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
        
        if(([[ARR_temp objectAtIndex:collectionView.tag] isKindOfClass:[NSDictionary class]]))
        {
            
            cell.BTN_time.text =[[ARR_temp objectAtIndex:collectionView.tag]valueForKey:@"_time"] ;
           // [cell.BTN_time setTitle:[[ARR_temp objectAtIndex:collectionView.tag]valueForKey:@"_time"] forState:UIControlStateNormal];
            
            if ([[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"_type"] isEqualToString:@"available"]) {
                [cell.BTN_time setBackgroundColor:[UIColor colorWithRed:67.0f/255.0f green:83.0f/255.0f blue:91.0f/255.0f alpha:1.0f]];
            }
            else{
                [cell.BTN_time setBackgroundColor:[UIColor redColor]];
            }
            
        }
        
        else{
            
            cell.BTN_time.text =[[[ARR_temp objectAtIndex:collectionView.tag] objectAtIndex:indexPath.row]valueForKey:@"_time"];

            //[cell.BTN_time setTitle:[[[ARR_temp objectAtIndex:collectionView.tag] objectAtIndex:indexPath.row]valueForKey:@"_time"] forState:UIControlStateNormal];
            
            if ([[[[ARR_temp objectAtIndex:collectionView.tag] objectAtIndex:indexPath.row]valueForKey:@"_type"] isEqualToString:@"available"]) {
                
                [cell.BTN_time setBackgroundColor:[UIColor colorWithRed:67.0f/255.0f green:83.0f/255.0f blue:91.0f/255.0f alpha:1.0f]];
            }
            else{
                [cell.BTN_time setBackgroundColor:[UIColor redColor]];
            }
        }
        
        
    } @catch (NSException *exception) {
        
        NSLog(@"%@",exception);
    }
   // [cell.BTN_time addTarget:self action:@selector(select_timing:) forControlEvents:UIControlEventTouchUpInside];
//    NSLog(@"%ld",(long)collectionView.tag);
//    for (int i = 0; i < [ARR_temp count]; i++) {
//    if (collectionView.tag == i)
//    if([[ARR_temp objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]])
//    {
//        [cell.BTN_time setTitle:[ARR_temp valueForKey:@"_time" ] forState:UIControlStateNormal];
//    }
//    else
//    {
//        
//        for(int j=0;j<[[ARR_temp objectAtIndex:indexPath.row] count];j++)
//        {
//     
//          [cell.BTN_time setTitle:[[[ARR_temp objectAtIndex:indexPath.row] objectAtIndex:j] valueForKey:@"_time"] forState:UIControlStateNormal];
//        }
//    }
    
//    for (int i = 0; i < [ARR_temp count]; i++) {
//        if (collectionView.tag == i) {
//            if(([[ARR_temp objectAtIndex:i] isKindOfClass:[NSDictionary class]]))
//            {
//                  [cell.BTN_time setTitle:[ARR_temp valueForKey:@"_time" ] forState:UIControlStateNormal];
//                
//            }
//            else
//            {
//                for(int j=0;j<[[ARR_temp objectAtIndex:i] count];j++)
//                {
//            
//                [cell.BTN_time setTitle:[[[ARR_temp objectAtIndex:i] objectAtIndex:j] valueForKey:@"_time"] forState:UIControlStateNormal];
//                
//                 }
//            }
//        
//        }
   // }

    
    
    
   /* @try
    {
        if (collectionView.tag == indexPath.row)
        {
        if([[ARR_temp objectAtIndex:collectionView.tag] isKindOfClass:[NSDictionary class]])
        {
         
            
            [cell.BTN_time setTitle:[ARR_temp valueForKey:@"_time" ] forState:UIControlStateNormal];

           
        }
        else
        {
             [cell.BTN_time setTitle:[[ARR_temp objectAtIndex:collectionView.tag] valueForKey:@"_time"] forState:UIControlStateNormal];
        }
        }

     }
    
     @catch(NSException *exception)
     {
         
     }*/
      return cell;
}


    
//     if([[[[[[[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:indexPath.row] valueForKey:@"ShowDates"] valueForKey:@"showDate"] objectAtIndex:indexPath.row] valueForKey:@"ShowTimes"] valueForKey:@"showTime"]valueForKey:@"_type"] isEqualToString:@"available"])
//     {
//          [cell.BTN_time setTitle:[[[[[[[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:indexPath.row] valueForKey:@"ShowDates"] valueForKey:@"showDate"] objectAtIndex:indexPath.row] valueForKey:@"ShowTimes"] valueForKey:@"showTime"] objectAtIndex:indexPath.row] valueForKey:@"_time"] forState:UIControlStateNormal];
//     }
//        
//     else{
//         NSLog(@"");
//     }
   // }

        
//    [cell.BTN_time setTitle:[[[[[[[[[detail_dict valueForKey:@"Theatre"] objectAtIndex:indexPath.row] valueForKey:@"ShowDates"] valueForKey:@"showDate"] objectAtIndex:indexPath.row] valueForKey:@"ShowTimes"] valueForKey:@"showTime"] objectAtIndex:indexPath.row] valueForKey:@"_time"] forState:UIControlStateNormal];
//    }
//    
//    

     
     //[[[[[[[[[collection_count objectAtIndex:0] objectAtIndex:0] valueForKey:@"ShowTimes"] valueForKey:@"showTime" ] objectAtIndex:indexPath.row] valueForKey:@"ShowTimes"] valueForKey:@"showTime"] objectAtIndex:indexPath.row] valueForKey:@"_time"]forState:UIControlStateNormal];
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    @try {
        if(([[ARR_temp objectAtIndex:collectionView.tag] isKindOfClass:[NSDictionary class]]))
        {

            NSLog(@"Selected Time Detail %@",[ARR_temp objectAtIndex:collectionView.tag]);
        }
        else{

            NSLog(@"Selected Time Detail %@",[[ARR_temp objectAtIndex:collectionView.tag] objectAtIndex:indexPath.row]);
           
        }
        
    } @catch (NSException *exception) {
        
        NSLog(@"%@",exception);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
