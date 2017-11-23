//
//  VC_myaddress.m
//  Dohasooq_mobile
//
//  Created by Test User on 18/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_myaddress.h"
#import "HttpClient.h"
#import "address_cell.h"
#import "billing_address.h"

@interface VC_myaddress ()<UITableViewDataSource,UITableViewDataSource,UITextFieldDelegate>
{
    
     NSMutableDictionary *jsonresponse_dic_address;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    int j ,i;
    NSMutableArray *stat_arr;
}

@end

@implementation VC_myaddress

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    j=0;i = 0;
    jsonresponse_dic_address = [[NSMutableDictionary alloc]init];
    stat_arr = [[NSMutableArray alloc]init];
    stat_arr = [NSMutableArray arrayWithObjects:@"0", nil];

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
    [self performSelector:@selector(Shipp_address_API) withObject:activityIndicatorView afterDelay:0.01];

    
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSArray *keys_arr = [[jsonresponse_dic_address valueForKey:@"billaddress"] allKeys];
//    return keys_arr.count;
//
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        NSInteger ct = 0;
      if(section == 0)
      {
        ct = [[[jsonresponse_dic_address valueForKey:@"billaddress"]allKeys]count] ;
        
      }
    else if(section == 1)
    {
        ct = [[[jsonresponse_dic_address valueForKey:@"shipaddress"]allKeys]count] ;

    }
    else if(section == 2)
    {
        ct = i ;
        
    }
    
        return ct;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    address_cell *cell = (address_cell *)[tableView dequeueReusableCellWithIdentifier:@"address_cell"];

    if(indexPath.section == 0)
    {
        address_cell *cell = (address_cell *)[tableView dequeueReusableCellWithIdentifier:@"address_cell"];

        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"address_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.BTN_edit_addres.hidden = YES;
        
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        cell.layer.shadowOpacity = 1.0;
        cell.layer.shadowRadius = 4.0;
        NSMutableDictionary *dict = [jsonresponse_dic_address valueForKey:@"billaddress"];
        cell.BTN_edit_addres.hidden = YES;
        
        
        
        NSString *name_str =[NSString stringWithFormat:@"%@ %@",[[dict  valueForKey:@"billingaddress"] valueForKey:@"firstname"],[[dict valueForKey:@"billingaddress"] valueForKey:@"lastname"]];
        name_str = [name_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        cell.LBL_name.text = name_str;
        cell.LBL_address_type.text = @"BILLING ADDRESS";
        NSString *state = [[dict valueForKey:@"billingaddress"] valueForKey:@"state"];
       NSString *country = [[dict valueForKey:@"billingaddress"] valueForKey:@"country"];
        
        state = [state stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        
        

        
//        
//        NSString *str = [[dict valueForKey:@"billingaddress"] valueForKey:@"country"];
//        NSArray *country_arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"country_arr"];
//        
//        for(int code= 0;code<country_arr.count;code++)
//        {
//            NSString *c_id = [NSString stringWithFormat:@"%@",[[country_arr objectAtIndex:code]valueForKey:@"id"]];
//            if([c_id intValue] == [str intValue])
//            {
//                country = [NSString stringWithFormat:@"%@",[[country_arr objectAtIndex:code] valueForKey:@"name"]];
//            }
//        }
//        
        
        
        
        NSString *address_str = [NSString stringWithFormat:@"%@,%@\n%@ %@\n%@\n%@\nph:%@",[[dict valueForKey:@"billingaddress"] valueForKey:@"address1"],[[dict valueForKey:@"billingaddress"] valueForKey:@"address2"],[[dict valueForKey:@"billingaddress"] valueForKey:@"city"],[[dict valueForKey:@"billingaddress"] valueForKey:@"zip_code"],state,country,[[dict valueForKey:@"billingaddress"] valueForKey:@"phone"]];
        
        address_str = [address_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        cell.LBL_address.text = address_str;
        
        
        
        [cell.BTN_edit addTarget:self action:@selector(BTN_edit_clickd) forControlEvents:UIControlEventTouchUpInside];
        return cell;

    }
    if(indexPath.section == 1)
    {
        address_cell *cell = (address_cell *)[tableView dequeueReusableCellWithIdentifier:@"address_cell"];
        
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"address_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.BTN_edit_addres.hidden = YES;
        
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        cell.layer.shadowOpacity = 1.0;
        cell.layer.shadowRadius = 4.0;
        NSMutableDictionary *dict = [jsonresponse_dic_address valueForKey:@"shipaddress"];
        NSArray *keys_arr = [dict allKeys];
        if(indexPath.row == keys_arr.count - 1 )
        {
            cell.BTN_edit_addres.hidden = NO;
        }
        
        
        
        NSString *name_str =[NSString stringWithFormat:@"%@ %@",[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"firstname"],[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"lastname"]];
        name_str = [name_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        cell.LBL_name.text = name_str;
        cell.LBL_address_type.text = @"SHIPPING ADDRESS";
       /// NSString *country;
        
//        
//        NSString *str = [[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"country"];
//        NSArray *country_arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"country_arr"];
//        
//        for(int code= 0;code<country_arr.count;code++)
//        {
//            NSString *c_id = [NSString stringWithFormat:@"%@",[[country_arr objectAtIndex:code]valueForKey:@"id"]];
//            if([c_id intValue] == [str intValue])
//            {
//                country = [NSString stringWithFormat:@"%@",[[country_arr objectAtIndex:code] valueForKey:@"name"]];
//            }
//        }
//        
        NSString *state = [[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"state"];
        NSString *country = [[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"country"];
        state = [state stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        

        
        
        NSString *address_str = [NSString stringWithFormat:@"%@,%@\n%@ %@\n%@\n%@\nph:%@",[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"address1"],[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"address2"],[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"city"],[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"zip_code"],state,country,[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"phone"]];
        
        address_str = [address_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        cell.LBL_address.text = address_str;
        
        
        
        [cell.BTN_edit addTarget:self action:@selector(BTN_edit_clickd) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }
    else{
        
            billing_address *cell = (billing_address *)[tableView dequeueReusableCellWithIdentifier:@"billing_address"];
            if (cell == nil)
            {
                NSArray *nib;
                nib = [[NSBundle mainBundle] loadNibNamed:@"billing_address" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            NSMutableDictionary *dict = [jsonresponse_dic_address valueForKey:@"billaddress"];
            
            cell.BTN_check.tag = 0;
            cell.TXT_first_name.delegate = self;
            cell.TXT_last_name.delegate = self;
            cell.TXT_address1.delegate = self;
            cell.TXT_address2.delegate = self;
            cell.TXT_city.delegate = self;
            cell.TXT_state.delegate = self;
            cell.TXT_country.delegate = self;
            cell.TXT_zip.delegate = self;
            cell.TXT_email.delegate = self;
            cell.TXT_phone.delegate = self;
            
            NSString *country;
            
            NSArray *country_arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"country_arr"];
            NSString *str = [[dict valueForKey:@"billingaddress"]  valueForKey:@"country"];
            
            for(int code= 0;code<country_arr.count;code++)
            {
                NSString *c_id = [NSString stringWithFormat:@"%@",[[country_arr objectAtIndex:code]valueForKey:@"id"]];
                if([c_id intValue] == [str intValue])
                {
                    country = [NSString stringWithFormat:@"%@",[[country_arr objectAtIndex:code] valueForKey:@"name"]];
                }
            }
            
            
            country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            
            NSString *str_fname = [[dict valueForKey:@"billingaddress"]  valueForKey:@"firstname"];
            NSString *str_lname = [[dict valueForKey:@"billingaddress"]  valueForKey:@"lastname"];
            NSString *str_addr1 = [[dict valueForKey:@"billingaddress"]  valueForKey:@"address1"];
            NSString *str_addr2 = [[dict valueForKey:@"billingaddress"]  valueForKey:@"address2"];
            NSString *str_city = [[dict valueForKey:@"billingaddress"]  valueForKey:@"city"];
            NSString *str_zip_code = [[dict valueForKey:@"billingaddress"]  valueForKey:@"zip_code"];
            NSString *str_phone = [[dict valueForKey:@"billingaddress"]  valueForKey:@"phone"];
            NSString *str_country = country;
            NSString *str_state =[NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"]  valueForKey:@"state"]];
            
            str_fname = [str_fname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            
            str_lname = [str_lname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            str_addr1 = [str_addr1 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            str_addr2 = [str_addr2 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            str_city = [str_city stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            str_zip_code = [str_zip_code stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            str_phone = [str_phone stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            str_country = [str_country stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            str_state = [str_state stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            
            
            cell.TXT_first_name.text = str_fname;
            cell.TXT_last_name.text = str_lname;
            cell.TXT_address1.text = str_addr1;
            cell.TXT_address2.text = str_addr2;
            cell.TXT_city.text = str_city;
            cell.TXT_state.text = str_state;
            cell.TXT_country.text = str_country;
            cell.TXT_zip.text = str_zip_code;
            cell.TXT_phone.text = str_phone;
            
            
            [cell.BTN_check addTarget:self action:@selector(BTN_check_clickd) forControlEvents:UIControlEventTouchUpInside];
            cell.LBL_stat.tag = [[stat_arr objectAtIndex:0] intValue];
            
            if(cell.LBL_stat.tag == 0)
            {
                cell.LBL_stat.image = [UIImage imageNamed:@"uncheked_order"];
                [cell.LBL_stat setTag:1];
            }
            else if(cell.LBL_stat.tag == 1)
            {
                cell.LBL_stat.image = [UIImage imageNamed:@"checked_order"];
                [cell.LBL_stat setTag:0];
            }
            
            return cell;
        
    }
    

    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        if(indexPath.section == 2)
        {
            return 679.0;
            
            
        }
    return UITableViewAutomaticDimension;
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}


-(void)Shipp_address_API
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/shipaddressessapi/%@/%@/%@.json",SERVER_URL,user_id,country,languge];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    @try {
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    
                    VW_overlay.hidden = YES;
                    [activityIndicatorView stopAnimating];
                    
                    jsonresponse_dic_address = data;
                    [_TBL_address reloadData];
                    NSLog(@"*******%@*********",data);
                }
                
            });
            
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        
    }
    
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    [activityIndicatorView stopAnimating];
}


-(void)BTN_check_clickd
{
    if([[stat_arr objectAtIndex:0] isEqualToString:@"1"])
    {
    [stat_arr replaceObjectAtIndex:0 withObject:@"0"];
    }
    else
    {
        [stat_arr replaceObjectAtIndex:0 withObject:@"1"];

    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithObjects:indexPath, nil];
    [self.TBL_address beginUpdates];
    [self.TBL_address reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.TBL_address endUpdates];
    

    
//    if(j == 1)
//    {
//        j =0;
//       // [self.TBL_address reloadData];
//    }
//    else if(j == 0)
//    {
//        j = 1;
//       // [self.TBL_address reloadData];
//    }
}

-(void)BTN_edit_clickd
{
    i = 1;
    [self.TBL_address reloadData];
}
- (IBAction)back_ACTIon:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
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
