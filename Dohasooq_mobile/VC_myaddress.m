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

@interface VC_myaddress ()<UITableViewDataSource,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    
    NSMutableDictionary *jsonresponse_dic_address;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    int j ,i;
    BOOL is_add_new,isCountrySelected;
    NSInteger edit_tag,cntry_ID;
    NSMutableArray *stat_arr;
     NSString *country,*str_fname,*str_city,*str_lname,*str_addr1,*str_addr2,*str_zip_code,*str_phone,*str_country,*str_state,*ship_id,*new_address_input,*state_id;
    UIToolbar *accessoryView;
    NSMutableDictionary *response_countries_dic;
    NSMutableArray *response_picker_arr,*arr_states;
    NSString *cntry_selection,*state_selection;//*selection_str,


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
    
    
    //Picker View
    _staes_country_pickr = [[UIPickerView alloc]init];
    _staes_country_pickr.delegate = self;
    _staes_country_pickr.dataSource = self;
    
    accessoryView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    accessoryView.barStyle = UIBarStyleBlackTranslucent;
    [accessoryView sizeToFit];
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(accessoryView.frame.size.width - 100, 0, 100, accessoryView.frame.size.height);
    [close setTitle:@"DONE" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(picker_done_btn_action:) forControlEvents:UIControlEventTouchUpInside];
    [accessoryView addSubview:close];

    
    
    

}
-(void)viewWillAppear:(BOOL)animated
{
    
    response_picker_arr = [NSMutableArray array];
    self.navigationItem.hidesBackButton = YES;

    self.navigationController.navigationBar.hidden = NO;
    is_add_new = NO;
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
        @try {
             ct = [[[jsonresponse_dic_address valueForKey:@"shipaddress"]allKeys]count] ;
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
       

    }
    else if(section == 2)
    {
        ct = i ;
        
    }
    
        return ct;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *address_identifier,*billing_identifier;
    NSInteger index;
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        
        address_identifier = @"Qaddress_cell";
        billing_identifier = @"Qbilling_address";
        index = 1;
        
    }
    else{
        address_identifier = @"address_cell";
        billing_identifier = @"billing_address";
        index = 0;
        
        
    }
    
    if(indexPath.section == 0)
    {
       
        address_cell *cell = (address_cell *)[tableView dequeueReusableCellWithIdentifier:address_identifier];
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"address_cell" owner:self options:nil];
            cell = [nib objectAtIndex:index];
        }

        
        
        
       // cell.VW_layer.layer.shadowColor = [UIColor lightGrayColor].CGColor;
       // cell.layer.shadowOffset = CGSizeMake(0.5, 0);
       // cell.layer.shadowOpacity = 1.0;
        //cell.layer.shadowRadius = 2.0;
        cell.VW_layer.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.VW_layer.layer.borderWidth = 0.5f;
       
        cell.BTN_edit_addres.hidden = YES;
        if ([[jsonresponse_dic_address valueForKey:@"billaddress"] isKindOfClass:[NSDictionary class]]) {
       
         NSMutableDictionary *dict = [jsonresponse_dic_address valueForKey:@"billaddress"];
        
        
        NSString *name_str =[NSString stringWithFormat:@"%@ %@",[[dict  valueForKey:@"billingaddress"] valueForKey:@"firstname"],[[dict valueForKey:@"billingaddress"] valueForKey:@"lastname"]];
        name_str = [name_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        cell.LBL_name.text = name_str;
        cell.LBL_address_type.text = @"BILLING ADDRESS";
        NSString *state = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"] valueForKey:@"state"]];
        country = [NSString stringWithFormat:@"%@",[[dict valueForKey:@"billingaddress"] valueForKey:@"country"]];
        
        state = [state stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        
        NSString *address_str = [NSString stringWithFormat:@"%@,\n%@ \n %@,%@,%@",[[dict valueForKey:@"billingaddress"] valueForKey:@"address1"],[[dict valueForKey:@"billingaddress"] valueForKey:@"city"],state,country,[[dict valueForKey:@"billingaddress"] valueForKey:@"zip_code"]];
        
        address_str = [address_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
            
        cell.LBL_address.text = address_str;
        }
        
       [cell.BTN_edit addTarget:self action:@selector(BTN_edit_clickd:) forControlEvents:UIControlEventTouchUpInside];
        cell.BTN_edit.tag =  999;
        
        return cell;

    }
    if(indexPath.section == 1)
    {
        
        
        address_cell *cell = (address_cell *)[tableView dequeueReusableCellWithIdentifier:address_identifier];
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"address_cell" owner:self options:nil];
            cell = [nib objectAtIndex:index];
        }

        cell.BTN_edit_addres.hidden = YES;
        cell.VW_layer.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.VW_layer.layer.borderWidth = 0.5f;

       // cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
       // cell.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        //cell.layer.shadowOpacity = 1.0;
        //cell.layer.shadowRadius = 4.0;
        NSMutableDictionary *dict = [jsonresponse_dic_address valueForKey:@"shipaddress"];
        NSArray *keys_arr = [dict allKeys];
        
        
        if (keys_arr.count<=3 && indexPath.row == keys_arr.count - 1) {
              cell.BTN_edit_addres.hidden = NO;
        }
//        if(indexPath.row == keys_arr.count - 1 )
//        {
//            cell.BTN_edit_addres.hidden = NO;
//        }
        
        
        
        NSString *name_str =[NSString stringWithFormat:@"%@ %@",[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"firstname"],[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"lastname"]];
        name_str = [name_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        cell.LBL_name.text = name_str;
        
        if (indexPath.row == 0) {
            cell.LBL_address_type.text = @"SHIPPING ADDRESS";

        }
        cell.LBL_address_type.text = @"";
        
        NSString *state = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"state"]];
        NSString *country1 = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"country"]];
        state = [state stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        country1 = [country1 stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        

        
        
        NSString *address_str = [NSString stringWithFormat:@"%@,\n%@ \n%@,%@,%@",[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"address1"],[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"city"],state,country,[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"zip_code"]];
        
        address_str = [address_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        cell.LBL_address.text = address_str;
        
        
        [cell.BTN_edit_addres addTarget:self action:@selector(add_new_address:) forControlEvents:UIControlEventTouchUpInside];
        [cell.BTN_edit addTarget:self action:@selector(BTN_edit_clickd:) forControlEvents:UIControlEventTouchUpInside];
        cell.BTN_edit.tag = indexPath.row;
        return cell;
        
    }
    else{
        
            billing_address *cell = (billing_address *)[tableView dequeueReusableCellWithIdentifier:billing_identifier];
            if (cell == nil)
            {
                NSArray *nib;
                nib = [[NSBundle mainBundle] loadNibNamed:@"billing_address" owner:self options:nil];
                cell = [nib objectAtIndex:index];
            }
        cell.LBL_Blng_title.text = @"ADD NEW ADDRESS";
        
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
        
        
        @try {
            if ([[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] isKindOfClass:[NSDictionary class]]) {
                
                if (edit_tag == 999) {
                    
                country = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"country"]];
            str_fname = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"firstname"]];
            str_city = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"city"]];
              
              str_lname = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"lastname"]];
              str_addr1 = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"address1"]];
              str_addr2 = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"address2"]];
              
              str_zip_code = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"zip_code"]];
             str_phone = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"phone"]];
              str_country = country;

              str_state = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"state"]];
        state_id = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"state_id"]];
            }
            }

        
        if ([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]]) {
            
            NSMutableDictionary *dict = [jsonresponse_dic_address valueForKey:@"shipaddress"];
            
            NSArray *keys_arr = [dict allKeys];
        if (edit_tag != 999) {
            
                country = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"country"]];
              
              //country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
              
              str_fname = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"firstname"]];
              
              str_lname =[NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"lastname"]];
              str_addr1 = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"address1"]];
              str_addr2 = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"address2"]];
              str_city = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"city"]];
              str_zip_code = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"zip_code"]];
              str_phone = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"phone"]];
              str_country = country;
              str_state =[NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"state"]];
            ship_id = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"id"]];
            //state_id = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"state_id"]];
            new_address_input = @"0";
        }
            
        }
          [str_country stringByReplacingOccurrencesOfString:@"<null>" withString:@"select Country"];
          [str_state stringByReplacingOccurrencesOfString:@"<null>" withString:@"select Country"];

        
            cell.TXT_first_name.text = str_fname;
            cell.TXT_last_name.text = str_lname;
            cell.TXT_address1.text = str_addr1;
            cell.TXT_address2.text = str_addr2;
            cell.TXT_city.text = str_city;
            cell.TXT_state.text = str_state;
            cell.TXT_country.text = str_country;
            cell.TXT_zip.text = str_zip_code;
            cell.TXT_phone.text = str_phone;
        
        if (is_add_new) {
            cell.TXT_first_name.text = @"";
            cell.TXT_last_name.text = @"";
            cell.TXT_address1.text = @"";
            cell.TXT_address2.text = @"";
            cell.TXT_city.text = @"";
            cell.TXT_state.text = @"";
            cell.TXT_country.text = @"";
            cell.TXT_zip.text = @"";
            cell.TXT_phone.text = @"";
            new_address_input = @"1";
        }
       
        cell.TXT_email.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"email"];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
   
           [cell.BTN_check removeFromSuperview];
           [cell.LBL_stat removeFromSuperview];
           [cell.LBL_shipping removeFromSuperview];
        
        UIButton *save_Btn = [UIButton buttonWithType:UIButtonTypeSystem];
        save_Btn.frame = CGRectMake(cell.TXT_phone.frame.origin.x, 522, cell.TXT_phone.frame.size.width, 44);
        
        
        [save_Btn addTarget:self action:@selector(save_btn_action:) forControlEvents:UIControlEventTouchUpInside];
        [save_Btn setTitle:@"SAVE" forState:UIControlStateNormal];
        [save_Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        save_Btn.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:185.0/255.0 blue:71.0/255 alpha:1];
        [cell.contentView addSubview:save_Btn];
        
            return cell;
        
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
    {
        return @"BILLING ADDRESS";
    }
    if (section == 1)
     {
       return @"SHIPPING ADDRESS";
     }
     else{
         return @"";
     }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    if (section == 0)
    {
    label.text=@"BILLING ADDRESS";

    label.backgroundColor=[UIColor whiteColor];
    label.textColor = [UIColor lightGrayColor];
    [label setFont:[UIFont fontWithName:@"Poppins-Regular" size:15]];

    label.textAlignment = NSTextAlignmentLeft;
    return label;
    }
    else if (section == 1)
    {
        label.text= @"SHIPPING ADDRESS";
        label.backgroundColor=[UIColor whiteColor];
        label.textColor = [UIColor lightGrayColor];
        [label setFont:[UIFont fontWithName:@"Poppins-Regular" size:15]];
        
        label.textAlignment = NSTextAlignmentLeft;

         return label;
    }

    else
    {
         return nil;
    }
}
//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
//    [headerView setBackgroundColor:[UIColor whiteColor]];
//    return headerView;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0 || section == 1)
    {
    return 50;
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        if(indexPath.section == 2)
        {
            return 679.0;
            
            
        }
//    return UITableViewAutomaticDimension;
        else{
            return 147;
        }
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}

#pragma mark Shipp_address_API
-(void)Shipp_address_API
{
    
    
    @try {
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    
    NSString *country_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/shipaddressessapi/%@/%@/%@.json",SERVER_URL,user_id,country_id,languge];
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
                    @try {
                        jsonresponse_dic_address = data;
                        [_TBL_address reloadData];
                        NSLog(@"*******%@*********",data);
                    } @catch (NSException *exception) {
                        
                    }
                   
                }
                
            });
            
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        
    }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
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

-(void)BTN_edit_clickd:(UIButton *)sender
{
    edit_tag = sender.tag ;
    is_add_new = NO;
    i = 1;
    [self.TBL_address reloadData];
}
-(void)add_new_address:(UIButton *)sender{
    is_add_new = YES;
    i = 1;
    [self.TBL_address reloadData];
}
-(void)save_btn_action:(UIButton *)sender{
    
    billing_address *cell = [self.TBL_address cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
   str_fname = cell.TXT_first_name.text ;
     str_lname=cell.TXT_last_name.text ;
   str_addr1 =   cell.TXT_address1.text;
    str_addr2 =cell.TXT_address2.text  ;
     str_city = cell.TXT_city.text ;
    str_state = cell.TXT_state.text  ;
    str_country = cell.TXT_country.text ;
    str_zip_code = cell.TXT_zip.text ;
    str_phone =  cell.TXT_phone.text ;
    
    if (edit_tag == 999) {
        [self edit_Billing_address_API];
    }
    else if (is_add_new){
        [self add_new_shipping_address_API];
    }
    else{
    [self edit_Shipping_Address];
    }
    
}

- (IBAction)back_ACTIon:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark edit_Shipping_Address
/*http://192.168.0.171/dohasooq/apis/shipaddressadd.json*/

-(void)edit_Shipping_Address{
    @try {
        
         NSDictionary *params = @{@"FirstName":str_fname,@"LastName":str_lname,@"country":country,@"state":str_state,@"city":str_city,@"address1":str_addr1,@"address2":str_addr2,@"zipcode":str_zip_code,@"newaddressinput":@"0",@"customerId":[[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"],@"shipaddressId":ship_id};
        NSLog(@"%@",params);
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/shipaddressadd.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient api_with_post_params:urlGetuser andParams:params completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                  
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
                     ];
                }
                if (data) {
                    NSLog(@"edit_Shipping_Address Response%@",data);
                   
                }
                
            });
        }];
        
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        
    }
}

#pragma mark edit_Billing_address_API
/*Edit billing api
 http://192.168.0.171/dohasooq/customers/my-account/3/userid.json */

-(void)edit_Billing_address_API{
    @try {
        
        
         NSDictionary *params = @{@"first_name":str_fname,@"last_name":str_lname,@"country_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"],@"state_id":state_id,@"city":str_city,@"address1":str_addr1,@"address2":str_addr2,@"zip_code":str_zip_code};
        
        NSLog(@"Billing params %@",params);
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/my-account/3/%@.json ",SERVER_URL,[[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"]];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient api_with_post_params:urlGetuser andParams:params completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
                     ];
                }
                if (data) {
                    NSLog(@"edit_Shipping_Address Response%@",data);
                    
                }
                
            });
        }];
        
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        
    }

}
#pragma mark add_new_shipping_address_API
/*Add shipping api
 http://192.168.0.171/dohasooq/apis/shipaddressadd.json*/

-(void)add_new_shipping_address_API{
    @try {
        
        
        NSDictionary *params = @{@"FirstName":str_fname,@"LastName":str_lname,@"country":country,@"state":str_state,@"city":str_city,@"address1":str_addr1,@"address2":str_addr2,@"zipcode":str_zip_code,@"newaddressinput":new_address_input,@"customerId":[[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"]};
        
        NSLog(@"add_new_shipping_address params %@",params);
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/shipaddressadd.json ",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient api_with_post_params:urlGetuser andParams:params completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
                     ];
                }
                if (data) {
                    NSLog(@"add_new_Shipping_Address Response%@",data);
                    
                }
                
            });
        }];
        
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        
    }
  
}

#pragma text field delgates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 8) {
        
        isCountrySelected = YES;
        textField.inputView = _staes_country_pickr;
        textField.inputAccessoryView = accessoryView;
        
        [self CountryAPICall];
    }
    if (textField.tag == 6) {
        
        isCountrySelected = NO;
        textField.inputView = _staes_country_pickr;
        textField.inputAccessoryView = accessoryView;
        [self stateApiCall];
    }
    

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 6) {
        textField.text = state_selection;
    }
    
if (textField.tag == 8) {
    
    billing_address *textFieldRowCell;
    textFieldRowCell = (billing_address *) textField.superview.superview.superview;
    NSIndexPath *indexPath = [self.TBL_address indexPathForCell:textFieldRowCell];
    
    NSLog(@"The index path is %@",indexPath);
    
    textFieldRowCell = (billing_address *)[self.TBL_address cellForRowAtIndexPath:indexPath];
    textField.text = cntry_selection;
    
    if ([textField.text isEqualToString:@""]) {
        [HttpClient createaAlertWithMsg:@"Please Select Country " andTitle:@""];
    }else{
        
    }
    textFieldRowCell.TXT_state.text = @" Select State";

}
}
#pragma mark CountryAPI Call
//http://192.168.0.171/dohasooq/'apis/countriesapi.json
-(void)CountryAPICall{
    @try {
        response_countries_dic = [NSMutableDictionary dictionary];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/countriesapi.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        @try {
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                [response_countries_dic addEntriesFromDictionary:data];
                                [response_picker_arr removeAllObjects];
                                //[response_picker_arr addObjectsFromArray:[response_countries_dic allKeys]]
                                for (int x=0; x<[[response_countries_dic allKeys] count]; x++) {
                                    NSDictionary *dic = @{@"cntry_id":[[response_countries_dic allKeys] objectAtIndex:x],@"cntry_name":[response_countries_dic valueForKey:[[response_countries_dic allKeys] objectAtIndex:x]]};
                                    
                                    [response_picker_arr addObject:dic];
                                }
                                [self.staes_country_pickr reloadAllComponents];
                                NSLog(@"%@",response_picker_arr);
                            }
                            else{
                                [HttpClient createaAlertWithMsg:@"The Data could not be read" andTitle:@""];
                            }
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        
                    }
                    
                });
                
            }];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
}



#pragma mark StateAPI Call

//http://192.168.0.171/dohasooq/'apis/getstatebyconapi/countryid.json
-(void)stateApiCall{
    
    @try {
        arr_states = [NSMutableArray array];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/getstatebyconapi/%@.json",SERVER_URL,[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        @try {
                            if ([data isKindOfClass:[NSArray class]]) {
                                [arr_states addObjectsFromArray:data];
                                [response_picker_arr removeAllObjects];
                                
                                [response_picker_arr addObjectsFromArray:arr_states];
                                [_staes_country_pickr reloadAllComponents];
                                
                            }
                            else{
                                [HttpClient createaAlertWithMsg:@"The Data could not be read" andTitle:@""];
                            }
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        
                    }
                    
                });
                
            }];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
}

#pragma mark UIPickerViewDelegate and UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
   
        return response_picker_arr.count;
    
    
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
        if (isCountrySelected) {
            return [[response_picker_arr objectAtIndex:row] valueForKey:@"cntry_name"];
        }
        else{
            
            return [[response_picker_arr objectAtIndex:row] valueForKey:@"value"];
        }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
   
    
        if (isCountrySelected) {
            @try {
                
                cntry_selection = [[response_picker_arr objectAtIndex:row] valueForKey:@"cntry_name"];
                cntry_ID = [[[response_picker_arr objectAtIndex:row] valueForKey:@"cntry_id"] integerValue];
                state_selection = @"";
                
                //  NSLog(@"country::%@",cntry_selection);
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
        else{
            @try {
                state_selection = [[response_picker_arr objectAtIndex:row] valueForKey:@"value"];
                //NSLog(@"State::%@",state_selection);
            } @catch (NSException *exception) {
                state_selection = @"";
            }
            
        }
       
}
#pragma mark picker_done_btn_action
-(void)picker_done_btn_action:(id)sender{
    
    [self.view endEditing:YES];
    //[textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    
    
    //    [_TXT_Date resignFirstResponder];
    //    [_TXT_Time resignFirstResponder];
    //    [_blng_cell.TXT_country resignFirstResponder];
    //    [_blng_cell.TXT_state resignFirstResponder];
    
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
