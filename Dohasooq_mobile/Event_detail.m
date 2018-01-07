//
//  Event_detail.m
//  Dohasooq_mobile
//
//  Created by Test User on 20/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "Event_detail.h"
#import "Gender_cell.h"
#import "cost_count_cell.h"
#import "XMLDictionary/XMLDictionary.h"
#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface Event_detail ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    NSMutableDictionary *event_dtl_dict;
    NSMutableArray *event_cost_arr,*values_arr,*cost_arr,*dates_arr;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
}

@end

@implementation Event_detail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self set_UP_VIEW];
}
-(void)set_UP_VIEW
{
    self.navigationController.navigationBar.hidden = NO;

    cost_arr = [[NSMutableArray alloc]init];
    dates_arr = [[NSMutableArray alloc]init];
    cost_arr = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];
    NSLog(@"%@",values_arr);
    
    @try
    {
    _LBL_event_name.text = [NSString stringWithFormat:@"%@",[event_dtl_dict valueForKey:@"_eventname"]];
    [_LBL_event_name sizeToFit];
    
    _LBL_event_address.text = [NSString stringWithFormat:@"%@",[event_dtl_dict valueForKey:@"_Venue"]];
    [_LBL_event_address sizeToFit];
    
    NSString *img_url = [event_dtl_dict valueForKey:@"_thumbURL"];
        img_url = [img_url stringByReplacingOccurrencesOfString:@"App" withString:@"movie"];
        
    [_IMG_banner sd_setImageWithURL:[NSURL URLWithString:img_url]
                           placeholderImage:[UIImage imageNamed:@"upload-8.png"]
                                    options:SDWebImageRefreshCached];

    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    CGRect frameset =_LBL_event_name.frame;
    frameset.size.width = _VW_event_dtl.frame.size.width;
    _LBL_event_name.frame = frameset;

    frameset =_LBL_event_address.frame;
    frameset.origin.y = _LBL_event_name.frame.origin.y + _LBL_event_name.frame.size.height;
    frameset.size.width = _VW_event_dtl.frame.size.width;
    _LBL_event_address.frame = frameset;
    
    @try
    {
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
        
        [df1 setDateFormat:@"yyyy-MM-dd"];
        [df setDateFormat:@"dd MMM yyyy"];
        NSString *temp_str = [NSString stringWithFormat:@"%@",[event_dtl_dict valueForKey:@"_startDate"]];
        NSString *end_str =[NSString stringWithFormat:@"%@",[event_dtl_dict valueForKey:@"_endDate"]];
        NSDate *str_date = [df1 dateFromString:temp_str];
        NSDate *en_date =[df1 dateFromString:end_str];
        NSString *start_date = [df stringFromDate:str_date];
        NSString *end_date = [df stringFromDate:en_date];

        _LBL_event_date.text = [NSString stringWithFormat:@"%@ - %@",start_date,end_date];
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    

    frameset = _LBL_event_date.frame;
    frameset.origin.y = _LBL_event_address.frame.origin.y + _LBL_event_address.frame.size.height + 7;
    _LBL_event_date.frame = frameset;
    
    
    
    @try
    {
        _LBL_event_time.text =[NSString stringWithFormat:@"%@ - %@",[event_dtl_dict valueForKey:@"_StartTime"],[event_dtl_dict valueForKey:@"_endTime"]];
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    
    
    frameset = _LBL_event_time.frame;
    frameset.origin.y = _LBL_event_date.frame.origin.y + _LBL_event_date.frame.size.height ;
    _LBL_event_time.frame = frameset;
    
    frameset = _IMG_back_ground.frame;
    frameset.size.height = _LBL_event_time.frame.origin.y + _LBL_event_time.frame.size.height;
    frameset.size.width = _Scroll_contents.frame.size.width;
    _IMG_back_ground.frame = frameset;


    frameset = _VW_event.frame;
    frameset.size.height = _LBL_event_time.frame.origin.y + _LBL_event_time.frame.size.height;
    frameset.size.width = _Scroll_contents.frame.size.width;
    _VW_event.frame = frameset;
    
    
    
    frameset = _VW_event_dtl.frame;
    frameset.size.height = _VW_event.frame.origin.y + _VW_event.frame.size.height;
    frameset.size.width = _Scroll_contents.frame.size.width;
    _VW_event_dtl.frame = frameset;
    
    @try
    {
        
        
        
        NSString *description =[NSString stringWithFormat:@"%@",[event_dtl_dict valueForKey:@"_EDescription"]];
        description = [description stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: 'Poppins-Regular'; font-size:%dpx;}</style>",17]];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[description dataUsingEncoding:NSUTF8StringEncoding]options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}documentAttributes:nil error:nil];
        _LBL_data.attributedText = attributedString;
       NSString *str = _LBL_data.text;
        str = [str stringByReplacingOccurrencesOfString:@"/" withString:@"\n"];
        _LBL_data.text = str;
   // str = [str stringByReplacingOccurrencesOfString:@"\" withString:@"\n"];
        
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
      [_LBL_data sizeToFit];
    
        frameset = _LBL_data.frame;
        frameset.size.height = _LBL_data.frame.origin.y + _LBL_data.frame.size.height;
        _LBL_data.frame = frameset;
    
    //[_LBL_data layoutIfNeeded];
    
    

    
    

    @try
    {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSDate *date = [NSDate date];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = date; // your start date
    NSDate *endDate = [df dateFromString:[event_dtl_dict valueForKey:@"_endDate"]]; // your end date
    NSDateComponents *dayDifference = [[NSDateComponents alloc] init];
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    NSUInteger dayOffset = 1;
    NSDate *nextDate = startDate;
    do {
        [dates addObject:nextDate];
        
        [dayDifference setDay:dayOffset++];
        NSDate *d = [[NSCalendar currentCalendar] dateByAddingComponents:dayDifference toDate:startDate options:0];
        nextDate = d;
    } while([nextDate compare:endDate] == NSOrderedAscending);
    
           [df setDateFormat:@"yyyy-MM-dd"];
        NSMutableArray *dates_array = [[NSMutableArray alloc]init];
    for (NSDate *date in dates)
    {
       
    [dates_arr addObject:[NSString stringWithFormat:@"%@",[df stringFromDate:date]]];

        
    }
        NSString *ebd_date = [df stringFromDate:endDate];
        [dates_arr addObject:ebd_date];
        NSLog(@"The Dates are:%@", dates_array);
    }
    @catch(NSException *exception)
    {
        
        
    }
    

   
    if(dates_arr.count > 2)
    {
        _BTN_calneder.hidden = NO;
        
        frameset = _BTN_calneder.frame;
        frameset.origin.y = _LBL_data.frame.origin.y + _LBL_data.frame.size.height;
        _BTN_calneder.frame = frameset;
        
        
        frameset = _VW_author.frame;
        frameset.origin.y = _VW_event_dtl.frame.origin.y + _VW_event_dtl.frame.size.height;
        frameset.size.height = _BTN_calneder.frame.origin.y + _BTN_calneder.frame.size.height + 10;
        frameset.size.width = _Scroll_contents.frame.size.width;
        _VW_author.frame = frameset;
         [self picker_set_UP];
    }
 
    else
    {
    _BTN_calneder.hidden = YES;
    frameset = _VW_author.frame;
    frameset.origin.y = _VW_event_dtl.frame.origin.y + _VW_event_dtl.frame.size.height;
    frameset.size.height = _LBL_data.frame.origin.y + _LBL_data.frame.size.height;
    frameset.size.width = _Scroll_contents.frame.size.width;
    _VW_author.frame = frameset;
    }

   // [_TBL_quantity reloadData];
  //  [_TBL_quantity reloadData];

    
    
//    frameset = _BTN_book.frame;
//    frameset.origin.y = _TBL_quantity.frame.origin.y + _TBL_quantity.frame.size.height;
//    _BTN_book.frame = frameset;
    [_TBL_quantity reloadData];
    frameset = _TBL_quantity.frame;
    frameset.size.height = _TBL_quantity.frame.origin.y + _TBL_quantity.contentSize.height+50 ;
    _TBL_quantity.frame = frameset;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(_VW_Quantity.frame.origin.x, _VW_Quantity.frame.origin.y, [UIScreen mainScreen].bounds.size.width, _TBL_quantity.contentSize.height -50);
    gradient.colors = @[(id)[UIColor colorWithRed:0.24 green:0.19 blue:0.15 alpha:1.0].CGColor, (id)[UIColor colorWithRed:0.55 green:0.46 blue:0.41 alpha:1.0].CGColor];
    [_VW_Quantity.layer insertSublayer:gradient atIndex:0];

    
    frameset = _VW_Quantity.frame;
    frameset.origin.y = _VW_author.frame.origin.y + _VW_author.frame.size.height;
    frameset.size.width = _Scroll_contents.frame.size.width;
    frameset.size.height = _TBL_quantity.frame.origin.y + _TBL_quantity.frame.size.height;
    _VW_Quantity.frame = frameset;
    
    
   
    
    [self.Scroll_contents addSubview:_VW_event_dtl];
    [self.Scroll_contents addSubview:_VW_author];
    [self.Scroll_contents addSubview:_VW_Quantity];
    [_BTN_book addTarget:self action:@selector(BTN_book_action) forControlEvents:UIControlEventTouchUpInside];
     [self viewDidLayoutSubviews];
       // [self ATTRIBUTED_TEXT];
   
    
    
}
-(void)picker_set_UP
{
    _date_picker_view = [[NSUserDefaults standardUserDefaults] valueForKey:@"country_array"];
    
    
    _date_picker_view = [[UIPickerView alloc] init];
    _date_picker_view.delegate = self;
    _date_picker_view.dataSource = self;
    
    
    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(tappedToSelectRow:)];
    tapToSelect.delegate = self;
    [_date_picker_view addGestureRecognizer:tapToSelect];
    
    
    NSLog(@"%@",dates_arr);
    
    UIToolbar* phone_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    phone_close.barStyle = UIBarStyleBlackTranslucent;
    [phone_close sizeToFit];
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(phone_close.frame.size.width - 100, 0, 100, phone_close.frame.size.height);
    [close setTitle:@"Done" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(countrybuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [phone_close addSubview:close];
    
    _BTN_calneder.layer.borderWidth = 0.8f;
    _BTN_calneder.layer.borderColor = [UIColor grayColor].CGColor;
    
    _BTN_calneder.inputAccessoryView=phone_close;
    _BTN_calneder.inputView = _date_picker_view;
    
    
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
    
   
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(getData) withObject:activityIndicatorView afterDelay:0.01];
   
    [self picker_set_UP];
   
    

}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_contents layoutIfNeeded];
    [_LBL_data layoutIfNeeded];
//    if(event_cost_arr.count < 2)
//    {
        _Scroll_contents.contentSize = CGSizeMake(_Scroll_contents.frame.size.width,_VW_Quantity.frame.origin.y + _VW_Quantity.frame.size.height -50);

//    }
//    else{
//    _Scroll_contents.contentSize = CGSizeMake(_Scroll_contents.frame.size.width,_VW_Quantity.frame.origin.y + _VW_Quantity.frame.size.height);
//    }
}

#pragma Getdata
-(void)getData
{
    event_dtl_dict = [[NSMutableDictionary alloc]init];
    event_dtl_dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"event_detail"];
    [event_dtl_dict mutableCopy];
    event_cost_arr = [[NSMutableArray alloc]init];
    
    NSArray *temp_arr = [[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"];
    if([temp_arr isKindOfClass:[NSArray class]])
    {
    
    for (int i =0; i < [[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] count]; i ++)
    {
        @try
        {
        NSDictionary *tem_dictin = @{@"price":[[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] objectAtIndex:i]valueForKey:@"_TicketPrice"],@"quantity":@"0",@"serve_price":[[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] objectAtIndex:i]valueForKey:@"_ServiceCharge"],@"ticket_id":[[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] objectAtIndex:i]valueForKey:@"_tktpriceid"]};
        [event_cost_arr addObject:tem_dictin];
        }
        @catch(NSException *exception)
        {
          
        }
      
        
    }
    }
     else
     {
         
         NSDictionary *tem_dictin = @{@"price":[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] valueForKey:@"_TicketPrice"],@"quantity":@"0",@"serve_price":[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] valueForKey:@"_ServiceCharge"],@"ticket_id":[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] valueForKey:@"_tktpriceid"]};
         [event_cost_arr addObject:tem_dictin];
     }
    
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
      [self set_UP_VIEW];
    [_TBL_quantity reloadData];
    [self set_UP_VIEW];
    [self set_UP_VIEW];


    
   
    
}


#pragma Tableview delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        
   // return [[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] count];
    return event_cost_arr.count;
    }
    else if(section == 1)
    {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
   // NSString *Gender_identifier,*costCount_identifier;
    //NSInteger index_gndr,index_cost;
//    
//    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//    {
//        
//        Gender_identifier = @"QGemder_cell";
//        costCount_identifier = @"Qcost_count_cell";
////        index_gndr = 2;
////        index_cost = 3;
//        
//    }
//    else{
//        Gender_identifier = @"Gemder_cell";
//        costCount_identifier = @"cost_count_cell";
////        index_gndr = 0;
////        index_cost = 1;
//
//    }
    
//    static NSString *identifier = @"Gemder_cell";
       if(indexPath.section == 0)
    {
        Gender_cell *gcell = (Gender_cell *)[tableView dequeueReusableCellWithIdentifier:@"Gender_cell"];
        if(gcell == nil)
        
        {
            
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"Gender_cell" owner:self options:nil];
            gcell = [nib objectAtIndex:0];
       }
        gcell.BTN_plus.layer.cornerRadius = gcell.BTN_plus.frame.size.width/2;
        gcell.BTN_plus.layer.masksToBounds = YES;
        
        gcell.BTN_minus.layer.cornerRadius = gcell.BTN_minus.frame.size.width/2;
        gcell.BTN_minus.layer.masksToBounds = YES;
        [gcell.LBL_result setTag:indexPath.row];
        [gcell.BTN_plus setTag:indexPath.row];
        [gcell.BTN_minus setTag:indexPath.row];
        
        [gcell.BTN_plus addTarget:self action:@selector(BTN_plus_action:) forControlEvents:UIControlEventTouchUpInside];
        [gcell.BTN_minus addTarget:self action:@selector(BTN_minus_action:) forControlEvents:UIControlEventTouchUpInside];

        
    
        @try
        {
            
      
        gcell.LBL_gender_cat.text = [[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] objectAtIndex:indexPath.row]valueForKey:@"_TicketName"];
            
        gcell.LBL_price.text = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],[[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] objectAtIndex:indexPath.row] valueForKey:@"_TicketPrice"]];
            
//            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//            {
//                  gcell.LBL_price.text = [NSString stringWithFormat:@"%@ QAR ",[[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] objectAtIndex:indexPath.row] valueForKey:@"_TicketPrice"]];
//            }
            
        gcell.LBL_result.text = [[event_cost_arr objectAtIndex:indexPath.row] valueForKey:@"quantity"];
            
        
        }
        @catch(NSException *exception)
        {
            gcell.LBL_gender_cat.text = [[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] valueForKey:@"_TicketName"];
            gcell.LBL_price.text = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] valueForKey:@"_TicketPrice"]];
            gcell.LBL_result.text = [[event_cost_arr objectAtIndex:indexPath.row] valueForKey:@"quantity"];
        }
        

        return gcell;
    }
    else
    {
        if(indexPath.section == 1)
        {
    cost_count_cell *ccell = (cost_count_cell *)[tableView dequeueReusableCellWithIdentifier:@"cost_count_cell"];
    
    if(ccell == nil)
        
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"Gender_cell" owner:self options:nil];
        ccell = [nib objectAtIndex:1];
    }
        @try
        {
            
            NSString *str = [cost_arr objectAtIndex:0];//gcell.LBL_result.text;
            NSString *text = [NSString stringWithFormat:@"No of Tickets :%@",str];
//            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//            {
//                text = [NSString stringWithFormat:@"%@ :No of Tickets",str];
//            }
//            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//            {
//                text = [NSString stringWithFormat:@"%@ : عدد التذاكر",str];
//            }
//            

            
            if ([ccell.LBL_no_tickets respondsToSelector:@selector(setAttributedText:)]) {
                
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName:ccell.LBL_no_tickets.textColor,
                                          NSFontAttributeName: ccell.LBL_no_tickets.font
                                          };
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
                
                
                
                NSRange ename = [text rangeOfString:str];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                            range:ename];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0]}
                                            range:ename];
                }
                ccell.LBL_no_tickets.attributedText = attributedText;
            }
            else
            { ccell.LBL_no_tickets.text = text;
            }
            
         
            NSString *str1 = [cost_arr objectAtIndex:1];//gcell.LBL_price.text;
             NSString *text1 = [NSString stringWithFormat:@"Total Price:%@  %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],str1];
            
            
            if ([ccell.LBL_total_price respondsToSelector:@selector(setAttributedText:)]) {
                
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName:ccell.LBL_total_price.textColor,
                                          NSFontAttributeName:ccell.LBL_total_price.font
                                          };
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text1 attributes:attribs];
                
                
                
                NSRange ename = [text1 rangeOfString:str1];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                            range:ename];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0]}
                                            range:ename];
                }
                ccell.LBL_total_price.attributedText = attributedText;
            }
            else
            { ccell.LBL_total_price.text = text1;
            }
        }
        @catch(NSException *exception)
        {
            NSLog(@"%@",exception);
        }
            
             return ccell;
        }
    
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 100;
    }
    else
    {
        if(indexPath.section == 1)
        return 100;
    }
    return 30;
}

#pragma Button Actions
-(void)BTN_plus_action:(UIButton *)sender
{
    @try
    {
        
    NSLog(@"THE added array is:%@",event_cost_arr);
    int i = [[[event_cost_arr objectAtIndex:sender.tag] valueForKey:@"quantity"] intValue];
    int availability_price,number_of_tickets;
    @try
    {
    availability_price = [[[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] objectAtIndex:sender.tag]valueForKey:@"_Availability"] intValue];
        number_of_tickets = [[[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] objectAtIndex:sender.tag]valueForKey:@"_NoOfTicketsPerTransaction"] intValue];
        
    }
    @catch(NSException *exception)
    {
         availability_price = [[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] valueForKey:@"_Availability"] intValue];
        number_of_tickets = [[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"]valueForKey:@"_NoOfTicketsPerTransaction"] intValue];

    }
    
    if(i < availability_price)
    {
        if(i < number_of_tickets)
        {
            i = i + 1;
            NSString *add_val = [NSString stringWithFormat:@"%d",i];
            NSDictionary *dict;
            @try
            {
                dict = [NSDictionary dictionaryWithObjectsAndKeys:add_val,@"quantity",[[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] objectAtIndex:sender.tag] valueForKey:@"_TicketPrice" ],@"price" ,[[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] objectAtIndex:sender.tag] valueForKey:@"_tktpriceid" ],@"ticket_ID",[[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] objectAtIndex:sender.tag] valueForKey:@"_tktmasterid" ],@"ticket_master_ID",nil];
            }
            @catch(NSException *exception)
            {
            dict = [NSDictionary dictionaryWithObjectsAndKeys:add_val,@"quantity",[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] valueForKey:@"_TicketPrice" ],@"price" ,[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] valueForKey:@"_tktpriceid" ],@"ticket_ID",[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"]valueForKey:@"_tktmasterid" ],@"ticket_master_ID",nil];
            }
            
            [event_cost_arr removeObjectAtIndex:sender.tag];
            [event_cost_arr insertObject:dict atIndex:sender.tag];
    int count = 0;
            int ACT_price =0;float ACT_service = 0;
    for (int i = 0; i< event_cost_arr.count; i++)
    {
        count = count + [[[event_cost_arr objectAtIndex:i] valueForKey:@"quantity"] intValue];
        int price = 0;// [[[event_cost_arr objectAtIndex:i] valueForKey:@"price"] intValue];
        float serve_price = 0;
        if ([[[event_cost_arr objectAtIndex:i] valueForKey:@"quantity"] intValue] !=0)
        {
            for (int j = 0; j < [[[event_cost_arr objectAtIndex:i] valueForKey:@"quantity"] intValue]; j++)
            {
//                price = price + price;
                if([[[event_cost_arr objectAtIndex:i] valueForKey:@"quantity"] intValue]  == 0)
                {
                    price = 0;
                    serve_price = 0;
                }
                else
                {
                    price = price + [[[event_cost_arr objectAtIndex:i] valueForKey:@"price"] intValue];
                    serve_price = serve_price + [[[event_cost_arr objectAtIndex:i] valueForKey:@"serve_price"] floatValue];
                }
            }
        }
        NSLog(@"The final price = %d",price);
        ACT_price = ACT_price + price;
        ACT_service = ACT_service + serve_price;
        NSLog(@"the actual value is:%d",ACT_price);
    }
     NSLog(@"THE added array is:%@",event_cost_arr);

    [cost_arr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",count]];
    [cost_arr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d",ACT_price]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSIndexPath *indexPath_sec = [NSIndexPath indexPathForRow:0 inSection:1];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithObjects:indexPath, nil];
    NSMutableArray *indexPath_quantity = [[NSMutableArray alloc] initWithObjects:indexPath_sec, nil];
    NSLog(@"%@",cost_arr);
    NSLog(@"%@",event_cost_arr);
    
    [self.TBL_quantity beginUpdates];
    [self.TBL_quantity reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.TBL_quantity reloadRowsAtIndexPaths:indexPath_quantity withRowAnimation:UITableViewRowAnimationNone];
    [self.TBL_quantity endUpdates];
            
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"only %d Tickets per transaction",number_of_tickets] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    }
    @catch(NSException *exception)
    {
        
    }
    
    
  

}

-(void)BTN_minus_action:(UIButton *)sender
{
    @try
    {    int i = [[[event_cost_arr objectAtIndex:sender.tag] valueForKey:@"quantity"] intValue];
    
            if(i == 0)
            {
                i =0;
            }
            else
            {
                 i = i - 1;
            }
           
            NSString *add_val = [NSString stringWithFormat:@"%d",i];
    NSDictionary *dict;
    @try
    {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:add_val,@"quantity",[[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] objectAtIndex:sender.tag] valueForKey:@"_TicketPrice" ],@"price" ,[[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] objectAtIndex:sender.tag] valueForKey:@"_tktpriceid" ],@"ticket_ID",[[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] objectAtIndex:sender.tag] valueForKey:@"_tktmasterid" ],@"ticket_master_ID",nil];
    }
    @catch(NSException *exception)
    {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:add_val,@"quantity",[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] valueForKey:@"_TicketPrice" ],@"price",[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"] valueForKey:@"_tktpriceid" ],@"ticket_ID",[[[event_dtl_dict valueForKey:@"TicketDetails"] valueForKey:@"Ticket"]  valueForKey:@"_tktmasterid" ],@"ticket_master_ID",nil];
    }
    

            [event_cost_arr removeObjectAtIndex:sender.tag];
            [event_cost_arr insertObject:dict atIndex:sender.tag];
    int count = 0;
    
    float ACT_price =0;float ACT_service = 0;
    for (int i = 0; i< event_cost_arr.count; i++)
    {
        count = count + [[[event_cost_arr objectAtIndex:i] valueForKey:@"quantity"] intValue];
        float price = 0;// [[[event_cost_arr objectAtIndex:i] valueForKey:@"price"] intValue];
        float serve_price = 0;
        if ([[[event_cost_arr objectAtIndex:i] valueForKey:@"quantity"] intValue] !=0)
        {
            for (int j = 0; j < [[[event_cost_arr objectAtIndex:i] valueForKey:@"quantity"] intValue]; j++)
            {
                //                price = price + price;
                if([[[event_cost_arr objectAtIndex:i] valueForKey:@"quantity"] intValue]  == 0)
                {
                    price = 0;
                    serve_price = 0;
                }
                else
                {
                    price = price + [[[event_cost_arr objectAtIndex:i] valueForKey:@"price"] intValue];
                    serve_price = serve_price + [[[event_cost_arr objectAtIndex:i] valueForKey:@"serve_price"] floatValue];

                }
            }
        }
        
        NSLog(@"The final price = %f",price);
        ACT_price = ACT_price + price;
        ACT_service = ACT_service + serve_price;

        NSLog(@"the actual value is:%f",ACT_price);
    }
    
    
    [cost_arr replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d",count]];
    [cost_arr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%.2f",ACT_price]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSIndexPath *indexPath_sec = [NSIndexPath indexPathForRow:0 inSection:1];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithObjects:indexPath, nil];
    NSMutableArray *indexPath_quantity = [[NSMutableArray alloc] initWithObjects:indexPath_sec, nil];
    NSLog(@"%@",cost_arr);
    NSLog(@"%@",event_cost_arr);
    
    [self.TBL_quantity beginUpdates];
    [self.TBL_quantity reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.TBL_quantity reloadRowsAtIndexPaths:indexPath_quantity withRowAnimation:UITableViewRowAnimationNone];
    [self.TBL_quantity endUpdates];
    }
    @catch(NSException *exception)
    {
        
    }
   

}
-(void)BTN_book_action
{
    
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(Book_action) withObject:activityIndicatorView afterDelay:0.01];
    
}
-(void)Book_action

{  NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please Login First" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
        alert.tag = 1;
        [alert show];
        
    }
    else
    {
        
        @try{
    
    int  i = [[cost_arr objectAtIndex:0] intValue];

    if(_BTN_calneder.hidden == NO)
    {
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
    if([_BTN_calneder.text isEqualToString:@"Calendar"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please selct Date" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];

    }
    else if(i <= 0)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please selct Atleast one Ticket" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            VW_overlay.hidden = YES;
            [activityIndicatorView stopAnimating];
        }
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:event_cost_arr forKey:@"cost_arr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:event_dtl_dict forKey:@"event_dtl"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:cost_arr forKey:@"Amount_dict"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if([_BTN_calneder.text isEqualToString:@"Calendar"])
        {
            NSLog(@"NO date:");
        }
        else{
            [[NSUserDefaults standardUserDefaults] setObject:_BTN_calneder.text forKey:@"event_book_date"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        [self performSegueWithIdentifier:@"event_book_user" sender:self];
        
        
        
    }
    }
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:event_cost_arr forKey:@"cost_arr"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:event_dtl_dict forKey:@"event_dtl"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:cost_arr forKey:@"Amount_dict"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        [self performSegueWithIdentifier:@"event_book_user" sender:self];
        
        
        
    }
        }
        @catch(NSException *exception)
        {
            
        }

    
    }
    
}

- (IBAction)back_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma picker view delgates
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [dates_arr count];
    
}
#pragma mark - UIPickerViewDelegate


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return dates_arr[row];
    
}

// #6
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.BTN_calneder.text = dates_arr[row];
    NSLog(@"the text is:%@",_BTN_calneder.text);
    
    
}
-(void)countrybuttonClick
{
    [self.BTN_calneder resignFirstResponder];
}
- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [_date_picker_view rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(_date_picker_view.bounds, 0.0, (CGRectGetHeight(_date_picker_view.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_date_picker_view]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [_date_picker_view selectedRowInComponent:0];
            [self pickerView:_date_picker_view didSelectRow:selectedRow inComponent:0];
        }
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}
- (IBAction)share_action:(id)sender
{
    if([[event_dtl_dict valueForKey:@"_EventUrl"] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Event URL not available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
        
    }
    else
    {
        NSString *trailer_URL= [event_dtl_dict valueForKey:@"_EventUrl"];
        NSArray* sharedObjects=[NSArray arrayWithObjects:trailer_URL,  nil];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc]                                                                initWithActivityItems:sharedObjects applicationActivities:nil];
        activityViewController.popoverPresentationController.sourceView = self.view;
        [self presentViewController:activityViewController animated:YES completion:nil];
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
            
            
            ViewController *intial = [self.storyboard instantiateViewControllerWithIdentifier:@"login_VC"];
            [self presentViewController:intial animated:NO completion:nil];
            
            
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
