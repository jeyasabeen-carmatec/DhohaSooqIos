//
//  VC_seat_book.m
//  Dohasooq_mobile
//
//  Created by Test User on 10/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_seat_book.h"
#import "XMLDictionary/XMLDictionary.h"

@interface VC_seat_book ()
{
    ZSeatSelector *seat,*seat2;
    int layout_height;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSMutableArray *title_arr,*plain_arr;
    NSDictionary *xmlDoc;

}

@end

@implementation VC_seat_book

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    VW_overlay.hidden = NO;
//    [activityIndicatorView startAnimating];
//    [self performSelector:@selector(API_call_movie_detail) withObject:activityIndicatorView afterDelay:0.01];
    [self API_call_movie_detail];
   
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
    
   
   }
//-(void)viewDidAppear:(BOOL)animated
//{
//    [self API_call_movie_detail]; 
//}

    
    
    -(void)API_call_movie_detail
    {
        
        title_arr = [[NSMutableArray alloc]init];
        plain_arr = [[NSMutableArray alloc]init];
    @try {
            
    NSURL *URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://api.q-tickets.com/V2.0/GetSeatLayout?showtimeid=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"movie_id"]]];
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    NSLog(@"%@",xmlDoc);
    if([[xmlDoc valueForKey:@"_status"] isEqualToString:@"false"])
    {
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Not Available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];

        
    }
    else{
        
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    
       NSMutableArray *arrfinal = [[NSMutableArray alloc]init];
    NSMutableArray *title_row = [[NSMutableArray alloc]init];
    NSMutableArray *family_arr = [[NSMutableArray alloc]init];
    
    
    NSMutableArray *final_title_arr =[[NSMutableArray alloc]init] ;
    
    @try
    {
        
        for(int j = 0;j<[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"] valueForKey:@"Row"]count];j++)
        {
            NSMutableArray *arrr1 = [[NSMutableArray alloc]init] ;
            NSMutableArray *temp_arr = [[NSMutableArray alloc]init];
            
            
            
            
            NSString *str = [[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"] valueForKey:@"Row"]objectAtIndex:j] valueForKey:@"_AllSeats"];
            NSArray *all_seat_arr=[str componentsSeparatedByString:@","];
            [title_arr addObject:[[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"] valueForKey:@"Row"]objectAtIndex:j] valueForKey:@"_letter"]];
            
            NSString *str1 = [[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"] valueForKey:@"Row"]objectAtIndex:j] valueForKey:@"_Availableseats"];
            
            
            NSArray *avaialable_seat_arr=[str1 componentsSeparatedByString:@","];
            
            
            STRING_seat *seats = [[STRING_seat alloc]init];
            
            NSString *gangway = [[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"] valueForKey:@"Row"]objectAtIndex:j] valueForKey:@"_gangwaySeats"];
            NSArray *gang_arr = [gangway componentsSeparatedByString:@","];
            NSString *gangway_count = [[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"] valueForKey:@"Row"]objectAtIndex:j] valueForKey:@"_gangwayCounts"];
            NSArray *gang_arr_count = [gangway_count componentsSeparatedByString:@","];
            NSString *intial_gangway;
            if([[[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"] valueForKey:@"Row"]objectAtIndex:j] valueForKey:@"_isInitialGangway"] isEqualToString:@"True"])
            {
                intial_gangway = [[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"] valueForKey:@"Row"]objectAtIndex:j] valueForKey:@"_isInitialGangwayCount"];
                
            }
            [family_arr addObject: [[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"] valueForKey:@"Row"]objectAtIndex:j] valueForKey:@"_isFamily"]];
            
            
            
            for(int i = 0;i<all_seat_arr.count;i++)
            {
                
                [arrr1 addObject:[[all_seat_arr objectAtIndex:i] substringFromIndex:1]];
                [title_row addObject:[[all_seat_arr objectAtIndex:i] substringToIndex:1]];
                
                
            }
           
            [final_title_arr addObjectsFromArray:[ seats set_title:arrr1:intial_gangway :gang_arr :gang_arr_count]];
            [temp_arr addObjectsFromArray: [seats GET_allSEAT:all_seat_arr:avaialable_seat_arr:intial_gangway:gang_arr :gang_arr_count]];
            
            
            
            NSString *str2 = [temp_arr componentsJoinedByString:@""];
            [arrfinal addObject:str2];
            
            //        titles = final_title_arr;
        }
        
        NSString *maps = [NSString stringWithFormat:@"%@",arrfinal];
        maps = [arrfinal componentsJoinedByString:@""];
        
        
        NSString *str = [[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"] valueForKey:@"_name"];
        
        seat = [[ZSeatSelector alloc]initWithFrame:_VW_seat.frame];
        
        [seat setSeatSize:CGSizeMake(32, 32)];
        [seat setSeat_price:[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"] valueForKey:@"_cost"] intValue]+[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"_bookingFees"] intValue]];
        [seat setMap:maps :final_title_arr :title_arr:family_arr:str];
        seat.seat_delegate = self;
        [self.view addSubview:seat];
    }
    
    @catch(NSException *exception)
    
    {
        
        //    NSString *map2 =@"_DDDDDD_DDDDDD_DDDDDDDD_/_AAAAAA_AAAAAA_DUUUAAAA_/________________________/_AAAAAUUAAAUAAAAUAAAAAAA/_UAAUUUUUUUUUUUUUUUAAAAA/_AAAAAAAAAAAUUUUUUUAAAAA/_AAAAAAAAUAAAAUUUUAAAAAA/_AAAAAUUUAUAUAUAUUUAAAAA/";
        NSMutableArray *ARR_merge = [[NSMutableArray alloc]init];
        NSString *maps;
        
        
        for(int m = 0;m<[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"]count];m++)
        {
            
            NSMutableArray *arrfinalS = [[NSMutableArray alloc]init];
            NSMutableArray *ARR_STor_titl = [[NSMutableArray alloc] init];
            NSMutableArray *ARR_STRfamily = [[NSMutableArray alloc] init];
            NSMutableArray *ARR_STRtitle =[[NSMutableArray alloc] init];
            
            
            
            for(int j = 0;j<[[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"] objectAtIndex:m]valueForKey:@"Row"]count];j++)
            {
                
                NSMutableArray *arrr1 = [[NSMutableArray alloc]init] ;
                NSMutableArray *temp_arr = [[NSMutableArray alloc]init];
                
                
                NSString *str = [[[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"]objectAtIndex:m] valueForKey:@"Row"]objectAtIndex:j] valueForKey:@"_AllSeats"];
                NSArray *all_seat_arr=[str componentsSeparatedByString:@","];
                [ARR_STor_titl addObject:[[all_seat_arr objectAtIndex:0] substringToIndex:1]];
                
               
              
                
                NSString *str1 = [[[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"]objectAtIndex:m] valueForKey:@"Row"]objectAtIndex:j] valueForKey:@"_Availableseats"];
                
                NSArray *avaialable_seat_arr=[str1 componentsSeparatedByString:@","];
                
                
                STRING_seat *seats = [[STRING_seat alloc]init];
                
                NSString *gangway = [[[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"]objectAtIndex:m] valueForKey:@"Row"]objectAtIndex:j] valueForKey:@"_gangwaySeats"];
                NSArray *gang_arr = [gangway componentsSeparatedByString:@","];
                NSString *gangway_count = [[[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"]objectAtIndex:m] valueForKey:@"Row"]objectAtIndex:j] valueForKey:@"_gangwayCounts"];
                NSArray *gang_arr_count = [gangway_count componentsSeparatedByString:@","];
                NSString *intial_gangway;
                if([[[[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"]objectAtIndex:m] valueForKey:@"Row"]objectAtIndex:j] valueForKey:@"_isInitialGangway"] isEqualToString:@"True"])
                {
                    intial_gangway = [[[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"]objectAtIndex:m] valueForKey:@"Row"]objectAtIndex:j] valueForKey:@"_isInitialGangwayCount"];
                    
                }
                [ARR_STRfamily addObject: [[[[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"]objectAtIndex:m] valueForKey:@"Row"]objectAtIndex:j] valueForKey:@"_isFamily"]];
                
                
                
                for(int i = 0;i<all_seat_arr.count;i++)
                {
                    
                    [arrr1 addObject:[[all_seat_arr objectAtIndex:i] substringFromIndex:1]];
                    [title_row addObject:[[all_seat_arr objectAtIndex:i] substringToIndex:1]];
                    
                    
                }
                
                [ARR_STRtitle addObjectsFromArray:[ seats set_title:arrr1:intial_gangway :gang_arr :gang_arr_count]];
                [temp_arr addObjectsFromArray: [seats GET_allSEAT:all_seat_arr:avaialable_seat_arr:intial_gangway:gang_arr :gang_arr_count]];
                
                
                NSString *str2 = [temp_arr componentsJoinedByString:@""];
                [arrfinalS addObject:str2];
                
                //        titles = final_title_arr;
            }
            
            
            [title_arr addObjectsFromArray:ARR_STor_titl];
            [title_arr addObject:@" "];
            [title_arr addObject:@" "];
            //   [title_arr addObject:@" "];
            
            [family_arr addObjectsFromArray:ARR_STRfamily];
            [family_arr addObject:@" "];
            [family_arr addObject:@" "];
            //  [family_arr addObject:@" "];
            
            
            [final_title_arr addObjectsFromArray:ARR_STRtitle];
            [final_title_arr addObject:@" "];
            [final_title_arr addObject:@" "];
            // [final_title_arr addObject:@" "];
            
            maps = [NSString stringWithFormat:@"%@",arrfinalS];
            maps = [arrfinalS componentsJoinedByString:@""];
            [ARR_merge addObject:maps];
        }
        
        
        
        NSString *STR_fianlMAP = [NSString stringWithFormat:@"%@",ARR_merge];
        
        char double_qode = '"';
        char comma = ',';
        
        NSString *STR_doublecode = [NSString stringWithFormat:@"%c",double_qode];
        NSString *STR_comma = [NSString stringWithFormat:@"%c",comma];
        NSString *STR_insetVAL = [NSString stringWithFormat:@"%@%@%@",STR_doublecode,STR_comma,STR_doublecode];
        
        STR_fianlMAP = [STR_fianlMAP stringByReplacingOccurrencesOfString:@"(" withString:@""];
        STR_fianlMAP = [STR_fianlMAP stringByReplacingOccurrencesOfString:@")" withString:@""];
        STR_fianlMAP = [STR_fianlMAP stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        STR_fianlMAP = [STR_fianlMAP stringByReplacingOccurrencesOfString:@" " withString:@""];
        STR_fianlMAP = [STR_fianlMAP stringByReplacingOccurrencesOfString:STR_insetVAL withString:@"//"];
        STR_fianlMAP = [STR_fianlMAP stringByReplacingOccurrencesOfString:STR_doublecode withString:@" "];
        
    
        NSString *str = [[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"Class"] objectAtIndex:0] valueForKey:@"_name"];
        seat = [[ZSeatSelector alloc]initWithFrame:_VW_seat.frame];
        
        [seat setSeatSize:CGSizeMake(32, 32)];
        
        
        [seat setMap:STR_fianlMAP :final_title_arr :title_arr:family_arr:str];
        seat.seat_delegate = self;
        [self.view addSubview:seat];
        layout_height = 1;
         }
        
    }
    }
        @catch(NSException *exception)
        {
            
        }
   

}

#pragma Button_Actions
- (IBAction)back_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
  }


- (void)seatSelected:(ZSeat *)seats
{
    NSLog(@"Seat at Row:%ld and Column:%ld text:%@", (long)seats.row,(long)seats.column,seats.titleLabel.text);
    int  i = seats.row;
   if(plain_arr.count > [[[xmlDoc valueForKey:@"Classes"] valueForKey:@"_maxBooking"] intValue])
    {
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Maximum %d for Booking",[[[xmlDoc valueForKey:@"Classes"] valueForKey:@"_maxBooking"] intValue]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];

    }
    else
    {
    @try
    {
    if([[title_arr objectAtIndex:i] isEqualToString:@""])
    {
        NSLog(@"the title is:%@",[title_arr objectAtIndex:i]);
        [plain_arr addObject:[NSString stringWithFormat:@"%@%@",[title_arr objectAtIndex:i],seats.titleLabel.text]];

    }
    else
    {
        NSLog(@"the title is:%@",[title_arr objectAtIndex:i -1]);
        [plain_arr addObject:[NSString stringWithFormat:@"%@%@",[title_arr objectAtIndex:i -1],seats.titleLabel.text]];

    }
    }
    @catch(NSException *exception)
    {
        if([[title_arr objectAtIndex:i -1] isEqualToString:@""])
        {
            NSLog(@"the title is:%@",[title_arr objectAtIndex:i]);
            [plain_arr addObject:[NSString stringWithFormat:@"%@%@",[title_arr objectAtIndex:i],seats.titleLabel.text]];

            
        }
        else
        {
            NSLog(@"the title is:%@",[title_arr objectAtIndex:i -1]);
            [plain_arr addObject:[NSString stringWithFormat:@"%@%@",[title_arr objectAtIndex:i-1],seats.titleLabel.text]];

        }

    }
    }
    }

-(void)getSelectedSeats:(NSMutableArray *)seats
{
    float total=0;
    for (int i=0; i<[seats count]; i++)
    {
        ZSeat *seatng = [seats objectAtIndex:i];
        printf("Seat[%ld,%ld]\n",(long)seatng.row,(long)seatng.column);
        total += seatng.price;
    }
    printf("--------- Total: %f\n",total);
    NSLog(@"the seats count is:%lu",(unsigned long)seats.count);
    _LBL_no_ofseats.text = [NSString stringWithFormat:@"No of Seats:%lu",(unsigned long)seats.count];
}
- (IBAction)block_seat_action:(id)sender
{
    
    VW_overlay.hidden = YES;
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(Book_action) withObject:activityIndicatorView afterDelay:0.01];

    
}
-(void)Book_action
{
    
    
    NSString *str = [plain_arr componentsJoinedByString:@","];
    
    NSLog(@"%@",str);
    
    NSURL *URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://api.q-tickets.com/V2.0/block_seats_qtickets?showid=%@&seats=%@&AppSource=3",[[NSUserDefaults standardUserDefaults] valueForKey:@"movie_id"],str]];
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *jsonrespnse = [NSDictionary dictionaryWithXMLString:xmlString];
    NSLog(@"%@",jsonrespnse);
    if([[[jsonrespnse valueForKey:@"result"] valueForKey:@"_status"] isEqualToString:@"False"])
    {
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[[jsonrespnse valueForKey:@"result"] valueForKey:@"_errormsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
 
    }
    else{
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        [[NSUserDefaults standardUserDefaults] setObject:jsonrespnse  forKey:@"Amount_dict"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:str  forKey:@"seats"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)plain_arr.count];
        [[NSUserDefaults standardUserDefaults] setObject:count  forKey:@"seat_count"];
        [[NSUserDefaults standardUserDefaults] synchronize];


        [self performSegueWithIdentifier:@"Movie_user_identifier" sender:self];
    }
    
    
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
