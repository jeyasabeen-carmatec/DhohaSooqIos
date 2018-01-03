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
    NSMutableArray *response_picker_arr,*phone_code_arr;
    NSString *cntry_selection,*state_selection,*shpid;//*selection_str,
    
    UITapGestureRecognizer *tapGesture1;
    NSString *flag;



}

@end

@implementation VC_myaddress

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
 [self set_UP_VIEW];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    
   
    
    
    
}
-(void)set_UP_VIEW
{
    j=0;i = 0;
    
    
    response_picker_arr = [NSMutableArray array];
    
    
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
    
    UIButton *done=[[UIButton alloc]init];
    done.frame=CGRectMake(accessoryView.frame.size.width - 100, 0, 100, accessoryView.frame.size.height);
    [done setTitle:@"Done" forState:UIControlStateNormal];
    [done addTarget:self action:@selector(picker_done_btn_action:) forControlEvents:UIControlEventTouchUpInside];
    [accessoryView addSubview:done];
    
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(accessoryView.frame.origin.x -20 , 0, 100, accessoryView.frame.size.height);
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(close_ACTION) forControlEvents:UIControlEventTouchUpInside];
    [accessoryView addSubview:close];
    
    
    [self phone_code_view];
    

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
          @try {
              ct = [[[jsonresponse_dic_address valueForKey:@"billaddress"]allKeys]count] ;
 
          } @catch (NSException *exception) {
              ct = 0;
          }
          
          
          
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
       
        cell.Btn_close.hidden = YES;
        
        if ([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]]) {
             cell.BTN_edit_addres.hidden = YES;
        }
        else{
             cell.BTN_edit_addres.hidden = NO;
        }
        
         [cell.BTN_edit_addres addTarget:self action:@selector(add_new_address:) forControlEvents:UIControlEventTouchUpInside];
        
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
        
        
        NSString *address_str = [NSString stringWithFormat:@"%@,\n%@ \n %@, %@, %@",[[dict valueForKey:@"billingaddress"] valueForKey:@"address1"],[[dict valueForKey:@"billingaddress"] valueForKey:@"city"],state,country,[[dict valueForKey:@"billingaddress"] valueForKey:@"zip_code"]];
        
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
        cell.Btn_close.hidden = NO;
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
        

        
        
        NSString *address_str = [NSString stringWithFormat:@"%@,\n%@ \n%@, %@, %@",[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"address1"],[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"city"],state,country,[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"zip_code"]];
        
        address_str = [address_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        cell.LBL_address.text = address_str;
        
        
        [cell.BTN_edit_addres addTarget:self action:@selector(add_new_address:) forControlEvents:UIControlEventTouchUpInside];
        [cell.BTN_edit addTarget:self action:@selector(BTN_edit_clickd:) forControlEvents:UIControlEventTouchUpInside];
        cell.BTN_edit.tag = indexPath.row;
        
        state_id =[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"state_id"];
        cntry_ID = [[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"country_id"] integerValue];
        
        
        
//        UIImage *newImage = [cell.Btn_close.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        UIGraphicsBeginImageContextWithOptions(cell.Btn_close.image.size, NO, newImage.scale);
//        [[UIColor darkGrayColor] set];
//        [newImage drawInRect:CGRectMake(0, 0, cell.Btn_close.image.size.width, newImage.size.height)];
//        newImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        cell.Btn_close.image = newImage;
        
        cell.Btn_close .userInteractionEnabled = YES;
        NSString *Id_ship = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"id"]];
        
        cell.Btn_close.tag = [Id_ship integerValue];
        
        tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture_close:)];
        
        tapGesture1.numberOfTapsRequired = 1;
        
        [tapGesture1 setDelegate:self];
        
        [cell.Btn_close addGestureRecognizer:tapGesture1];
        
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
        
        cell.TXT_cntry_code.hidden = NO;
        cell.TXT_phone.hidden = NO;
        cell.LBL_Blng_title.text = @"EDIT SHIPPING ADDRESS";
        
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
        cell.TXT_cntry_code.delegate = self;
        
        
        @try {
            if ([[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] isKindOfClass:[NSDictionary class]]) {
                
                if (edit_tag == 999) {
                    
                     cell.LBL_Blng_title.text = @"EDIT BILLING ADDRESS";
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
                    cell.TXT_cntry_code.hidden = YES;
                    cell.TXT_phone.hidden = YES;
                    
                  
                   
                    CGRect frame = cell.Btn_save.frame;
                    frame.origin.y= cell.TXT_phone.frame.origin.y+20;
                    
                    cell.Btn_save.frame= frame;
                    
                    
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
            
            
            if ([str_country isEqualToString:@""] || [str_country isEqualToString:@"<nil>"]  || [str_country isEqual:[NSNull class]]) {
                cell.TXT_country.placeholder = @"select countrt";
            }
            if ([str_city isEqualToString:@""] || [str_city isEqualToString:@"<nil>"]  || [str_city isEqual:[NSNull class]]) {
                cell.TXT_country.placeholder = @"select state";
            }
            
        
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
            
            cell.TXT_cntry_code.hidden = NO;
            cell.TXT_phone.hidden = NO;
            
            CGRect frame = cell.Btn_save.frame;
            frame.origin.y= cell.TXT_phone.frame.origin.y+90;
            
            cell.Btn_save.frame= frame;
            
            
             cell.LBL_Blng_title.text = @"ADD NEW ADDRESS";
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
   
        
        
        [cell.Btn_save addTarget:self action:@selector(save_btn_action:) forControlEvents:UIControlEventTouchUpInside];
        
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
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,170, 60)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(10,0, 170, 30)];
    label.backgroundColor = [UIColor whiteColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    
    [headerView addSubview:label];
    label.textColor = [UIColor lightGrayColor];
    [label setFont:[UIFont fontWithName:@"Poppins-Regular" size:15]];
    if (section == 0)
    {
        label.text=@"BILLING ADDRESS";
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            label.text = @"عنوان الفاتورة ";
            label.textAlignment = NSTextAlignmentRight;
        }
        
    }
    else
    {
        label.text= @"SHIPPING ADDRESS";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            label.text = @"عنوان الشحن";
            label.textAlignment = NSTextAlignmentRight;
        }
    }
    
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0 || section == 1)
    {
    return 30;
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        if(indexPath.section == 2)
        {
            return 530.0;
            
            
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


#pragma mark delete shipping address action
-(void)tapGesture_close:(UITapGestureRecognizer *)tapgstr{
    
//    CGPoint location = [tapGesture1 locationInView:_TBL_address];
//    NSIndexPath *indexPath = [_TBL_address indexPathForRowAtPoint:location];
    //
    //    //Cart_cell *cell = (Cart_cell *)[_TBL_cart_items cellForRowAtIndexPath:indexPath];
    //    product_id = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"productid"]];

    
     UIView *view = tapgstr.view;
    shpid = [NSString stringWithFormat:@"%ld",(long)[view tag]];
    
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to Delete" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    alert.tag = 1;
    [alert show];

    
    
   
    
    
    NSLog(@"the cancel clicked");
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
                        if ([data isKindOfClass:[NSDictionary class]]) {
                            jsonresponse_dic_address = data;
                           
                            [_TBL_address reloadData];
                            NSLog(@"*******%@*********",data);
                        }
                        else{
                            NSLog(@"The data is in unknown format");
                        }
                        
                       
                    } @catch (NSException *exception) {
                        VW_overlay.hidden = YES;
                        [activityIndicatorView stopAnimating];
                        
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
    NSString *msg;
    
    if ([str_fname isEqualToString:@""]) {
        
        [cell.TXT_first_name becomeFirstResponder];
       msg = @"fname should not be empty";
        
    }
    else if (str_fname.length<3 || str_fname.length>30)
    {
        [cell.TXT_first_name becomeFirstResponder];
         msg = @"fname should be 3 to 30  characters range";
    }
    
    else if ([str_lname isEqualToString:@""]) {
        
        [cell.TXT_last_name becomeFirstResponder];
        msg = @"lname should not be empty";
        
    }
    else if (str_lname.length<3 || str_lname.length>30)
    {
        [cell.TXT_last_name becomeFirstResponder];
        msg = @"lname should be 3 to 30  characters range";
    }
    else if ([str_addr1 isEqualToString:@""]) {
        
        [cell.TXT_address1 becomeFirstResponder];
        msg = @"address1 should not be empty";
        
    }
    else if (str_addr1.length<3 || str_addr1.length>30)
    {
        [cell.TXT_address1 becomeFirstResponder];
        msg = @"address1 should be 3 to 30  characters range";
    }
        else if ([str_addr2 isEqualToString:@""]) {
        
        [cell.TXT_address2 becomeFirstResponder];
        msg = @"Address2 should not be empty";
        
    }
    else if (str_addr2.length<3 || str_addr2.length>30)
    {
        [cell.TXT_address2 becomeFirstResponder];
        msg = @"Address2 should be 3 to 30  characters range";
    }
    else if ([str_city isEqualToString:@""]) {
        
        [cell.TXT_city becomeFirstResponder];
        msg = @"City should not be empty";
        
    }
    else if (str_city.length<3 || str_city.length>15)
    {
        [cell.TXT_city becomeFirstResponder];
        msg = @"city should be 3 to 15  characters range";
    }
    else if ([str_zip_code isEqualToString:@""]) {
        
        [cell.TXT_zip becomeFirstResponder];
        msg = @"zip code should not be empty";
        
    }
    else if (str_zip_code.length<5 || str_zip_code.length>8)
    {
        [cell.TXT_zip becomeFirstResponder];
        msg = @"zip code should be 5 to 8  characters range";
    }
    else if ([str_phone isEqualToString:@""]) {
        
        [cell.TXT_phone becomeFirstResponder];
        msg = @"Mobile Number  should not be empty";
        
    }
    else if (str_phone.length<5 || str_phone.length >15)
    {
        [cell.TXT_phone becomeFirstResponder];
        msg = @"Mobile Number should be 5 to 15  characters range";
    }
    else if ([str_state isEqualToString:@""])
    {
        [cell.TXT_state becomeFirstResponder];
        msg = @"please select state";
    }
    else if ([str_country isEqualToString:@""])
    {
        [cell.TXT_country becomeFirstResponder];
        msg = @"please select country";
    }
    
    
    if (msg) {
        [HttpClient createaAlertWithMsg:msg andTitle:@""];
    }
    else if (edit_tag == 999) {
        [self edit_Billing_address_API];
    }
    else if (is_add_new){
        
        [self add_new_ship_address];
    }
    else{
        
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(edit_Shipping_Address) withObject:activityIndicatorView afterDelay:0.01];
   
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
        
        NSString *cntr_id = [NSString stringWithFormat:@"%ld",(long)cntry_ID];
         NSDictionary *params = @{@"FirstName":str_fname,@"LastName":str_lname,@"country":cntr_id,@"state":state_id,@"city":str_city,@"address1":str_addr1,@"address2":str_addr2,@"zipcode":str_zip_code,@"newaddressinput":@"0",@"customerId":[[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"],@"shipaddressId":ship_id};
        NSLog(@"%@",params);
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/shipaddressadd.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient api_with_post_params:urlGetuser andParams:params completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    VW_overlay.hidden = YES;
                    [activityIndicatorView stopAnimating];
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
                     ];
                }
                if (data) {
                    VW_overlay.hidden = YES;
                    [activityIndicatorView stopAnimating];
                    

                    NSLog(@"edit_Shipping_Address Response%@",data);
                    if ([data isKindOfClass:[NSDictionary class]]) {
                        
                        
                        NSString *succes = [NSString stringWithFormat:@"%@",[data valueForKey:@"success"]];
                        if ([succes isEqualToString:@"success"]) {
                            i=i-1;
                            [self Shipp_address_API];
                        }
                    }
                   
                }
                
            });
        }];
        
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
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
                    
                    if ([data isKindOfClass:[NSDictionary class]]) {
                        
                        @try {
                             NSLog(@"edit_Shipping_Address Response%@",[data valueForKey:@"success"]);
                            NSString *succs = [NSString stringWithFormat:@"%@",[data valueForKey:@"success"]];
                            if ([succs isEqualToString:@"success"] || [succs isEqualToString:@"1"] ) {
                                i=i-1;
                                [HttpClient createaAlertWithMsg:@"New Address saved successfully" andTitle:@""];
                                 [self Shipp_address_API];
                               }
                            
                           

                            
                
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                    }
                    
                    //NSLog(@"edit_Shipping_Address Response%@",[data valueForKey:@"success"]);
                    
                }
                
            });
        }];
        
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        
    }

}


#pragma mark text field delgates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField.tag == 10) {
        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,-120,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];

    }
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
    if (textField.tag == 11) {
        textField.inputView = _phone_picker_view;
        textField.inputAccessoryView = accessoryView;

    }
    

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 6) {
        textField.text = state_selection;
    }
    
if (textField.tag == 8) {
    
//    billing_address *textFieldRowCell;
//    textFieldRowCell = (billing_address *) textField.superview.superview.superview;
//    NSIndexPath *indexPath = [self.TBL_address indexPathForCell:textFieldRowCell];
//    
//    NSLog(@"The index path is %@",indexPath);
//    
//    textFieldRowCell = (billing_address *)[self.TBL_address cellForRowAtIndexPath:indexPath];
    textField.text = cntry_selection;
    
    if ([textField.text isEqualToString:@""]) {
        [HttpClient createaAlertWithMsg:@"Please Select Country " andTitle:@""];
    }else{
        
    }
    //textFieldRowCell.TXT_state.placeholder = @" Select State";

}
    if (textField.tag == 11) {
        textField.text = flag;
    }
    
    
    
    if (textField.tag == 10 || textField.tag == 11) {
        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];

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
                                NSSortDescriptor *sortDescriptor;
                                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cntry_name"
                                                                             ascending:YES];
                                NSArray *sortedArr = [response_picker_arr sortedArrayUsingDescriptors:@[sortDescriptor]];
                                NSLog(@"sortedArr %@",sortedArr);
                                
                                [response_picker_arr removeAllObjects];
                                [response_picker_arr addObjectsFromArray:sortedArr];
                                [_staes_country_pickr reloadAllComponents];
                                
//                                for(int k = 0; k < response_picker_arr.count;k++)
//                                {
//                                    if([[[response_picker_arr objectAtIndex:k] valueForKey:@"cntry_name"] isEqualToString:@"Qatar"])
//                                    {
//                                        [self.staes_country_pickr selectRow:k inComponent:0 animated:NO];
//
//                                        [self pickerView:self.staes_country_pickr didSelectRow:k inComponent:0];
//
//                                    }
//                                }
//                                
//                                
                                
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
                                
                                //[arr_states addObjectsFromArray:data];
                                [response_picker_arr removeAllObjects];
                                
                                [response_picker_arr addObjectsFromArray:data];
                                
                                NSSortDescriptor *sortDescriptor;
                                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"value"
                                                                             ascending:YES];
                                NSArray *sortedArr = [response_picker_arr sortedArrayUsingDescriptors:@[sortDescriptor]];
                                
                                NSLog(@"sortedArr %@",sortedArr);
                                
                                [response_picker_arr removeAllObjects];
                                [response_picker_arr addObjectsFromArray:sortedArr];
                                [_staes_country_pickr reloadAllComponents];
//                                [self.staes_country_pickr selectRow:0 inComponent:0 animated:NO];
//                                [self pickerView:self.staes_country_pickr didSelectRow:0 inComponent:0];
                                
                                
                                
                                
                                
                                
                            }
                            else{
                                [HttpClient createaAlertWithMsg:@"The Data Could not be read" andTitle:@""];
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


/*-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
 {
 return [NSString stringWithFormat:@"%@   %@",[phone_code_arr[row] valueForKey:@"name"],[phone_code_arr[row] valueForKey:@"dial_code"]];
 
 }*/


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
   
    if (pickerView == self.phone_picker_view) {
        
        return phone_code_arr.count;
        
    }else{
        return response_picker_arr.count;
    }
    
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    

    if (pickerView == self.phone_picker_view) {
        
        return [NSString stringWithFormat:@"%@   %@",[phone_code_arr[row] valueForKey:@"name"],[phone_code_arr[row] valueForKey:@"dial_code"]];
    }
    else{
    
    @try {
        if (isCountrySelected) {
            return [[response_picker_arr objectAtIndex:row] valueForKey:@"cntry_name"];
        }
        else{
            
            return [[response_picker_arr objectAtIndex:row] valueForKey:@"value"];
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerView == self.phone_picker_view) {
        flag = [NSString stringWithFormat:@"%@",[phone_code_arr[row] valueForKey:@"dial_code"]];
      
    }
    else{
        
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
                
                state_id = [[response_picker_arr objectAtIndex:row] valueForKey:@"key"];
                //NSLog(@"State::%@",state_selection);
            } @catch (NSException *exception) {
                state_selection = @"";
            }
            
        }
    }
}
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    
    
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
-(void)close_ACTION{
    [self.view endEditing:YES];
}


/*
 Delete Shipping Address
 
 
 Function Name : Apis/shipaddressdelete.json
 Parameters :customerId,shipId
 Method : POST*/
#pragma mark DeleShippingAddress
-(void)deleteShipping_address:(NSString *)cust_id andShipID:(NSString *)shipid{
    
    @try {
        
        
        NSDictionary *params = @{@"customerId":cust_id,@"shipId":shipid};
        
        
    NSString *urlGetuser =[NSString stringWithFormat:@"%@Apis/shipaddressdelete.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            
            [HttpClient api_with_post_params:urlGetuser andParams:params completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        @try {
                            NSLog(@"%@",data);
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                if ([[data valueForKey:@"msg"] isEqualToString:@"success"]) {
                                    
                                    [self Shipp_address_API];
                                    
                                }
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

#pragma mark add_new_shipping_address_API
/*Add shipping api
 http://192.168.0.171/dohasooq/apis/shipaddressadd.json
 [10:38 AM] Bindal Gami: params.put("FirstName", user_firstname);
                 params.put("LastName", user_lastname);
                 params.put("country", user_countrys);
                 params.put("state", user_state);
                 params.put("city", user_city);
                 params.put("address1", user_address1);
                 params.put("address2", user_address2);
                 params.put("zipcode", user_zip_code);
                 params.put("newaddressinput", user_address_token);
                 params.put("customerId", customerid);*/

-(void)add_new_ship_address{
    @try
    {
        NSString *cntr_id = [NSString stringWithFormat:@"%ld",(long)cntry_ID];
        
       NSDictionary *params = @{@"FirstName":str_fname,@"LastName":str_lname,@"country":cntr_id,@"state":state_id,@"city":str_city,@"address1":str_addr1,@"address2":str_addr2,@"zipcode":str_zip_code,@"newaddressinput":new_address_input,@"customerId":[[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"],@"mobile":str_phone};
        NSLog(@"%@",params);
        
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/shipaddressadd.json",SERVER_URL];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlGetuser]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        //    [request setHTTPBody:body];
        
        
        
        
        
        // FirstName
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"FirstName\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
        [body appendData:[[NSString stringWithFormat:@"%@",str_fname]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        //LastName
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"LastName\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",str_lname]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        //address1
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"address1\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",str_addr1]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        //address2
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"address2\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",str_addr2]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        //city
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"city\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",str_city]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        
        
        //country
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"country\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",cntr_id]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        
        //customerId
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"customerId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSLog(@"%@  * %@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"],new_address_input);

        
        //newaddressinput
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"newaddressinput\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",new_address_input]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        //state
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"state\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",state_id]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        

        //zipcode
    
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"zipcode\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",str_zip_code]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        //mobile
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"mobile\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",str_phone]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        //
        NSError *er;
        //    NSHTTPURLResponse *response = nil;
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&er];
        if (er) {
            NSLog(@"%@",[er localizedDescription]);
        }
        
        if (returnData) {
            
            NSMutableDictionary *json_DATA = [[NSMutableDictionary alloc]init];
            json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:returnData options:NSASCIIStringEncoding error:&er];
            NSLog(@"%@", [NSString stringWithFormat:@"JSON DATA OF ORDER DETAIL: %@", json_DATA]);
            
            if ([[json_DATA valueForKey:@"success"] isEqualToString:@"success"]) {
               
                i= i-1;
                 [self Shipp_address_API];
            }
            
            [HttpClient createaAlertWithMsg:[json_DATA valueForKey:@"success"] andTitle:@""];
        }
        
    }
    @catch(NSException *exception)
    {
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        NSLog(@"THE EXception:%@",exception);
        
    }
    [activityIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
}


-(void)phone_code_view
{

   
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    phone_code_arr = (NSMutableArray *)parsedObject;
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                 ascending:YES];
    NSArray *sorted_arr = [phone_code_arr sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSLog(@"%@",sorted_arr);
    
           for(int k = 0; k < sorted_arr.count;k++)
            {
                if([[[sorted_arr objectAtIndex:k] valueForKey:@"name"] isEqualToString:@"Qatar"])
                        {
                          [self.phone_picker_view selectRow:k inComponent:0 animated:NO];
        
                            [self pickerView:self.phone_picker_view didSelectRow:k inComponent:0];
                            
        
                        }
                }
    
                                        

    
    //phone_code_arr = [NSMutableArray arrayWithArray:[codes allValues]];
    //   country_arr = [codes allKeys];
    //    [[NSUserDefaults standardUserDefaults] setObject:country_arr forKey:@"country_array"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _phone_picker_view = [[UIPickerView alloc] init];
    _phone_picker_view.delegate = self;
    _phone_picker_view.dataSource = self;
    
    
    
    
//    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
//                                                                                 action:@selector(tappedToSelectRow:)];
//    tapToSelect.delegate = self;
//    [_phone_picker_view addGestureRecognizer:tapToSelect];
    
    
    
}



- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            NSString *customer_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"];

            [self deleteShipping_address:customer_id andShipID:shpid ];
            
        }
        else{
            
            
            NSLog(@"cancel:");
            
            
        }
    }
}


- (IBAction)home_action:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];

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
