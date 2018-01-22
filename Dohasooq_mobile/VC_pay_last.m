//
//  VC_pay_last.m
//  Dohasooq_mobile
//
//  Created by Test User on 06/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_pay_last.h"

@interface VC_pay_last ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *country_arr;
    NSMutableDictionary *response_countries_dic;
    NSString *str_URL;
}

@end

@implementation VC_pay_last

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _TXT_countries.inputView = [[UIView alloc]init];
    country_arr = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.hidden = YES;

   
    [self picker_set_UP];
    [_BTN_pay addTarget:self action:@selector(pay_action) forControlEvents:UIControlEventTouchUpInside];

    [_BTN_cancel addTarget:self action:@selector(cancel_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_american_express addTarget:self action:@selector(BTN_american_express_action) forControlEvents:UIControlEventTouchUpInside];
    
    [_BTN_visa addTarget:self action:@selector(BTN_visa_action) forControlEvents:UIControlEventTouchUpInside];
    
    [_BTN_dohabank addTarget:self action:@selector(BTN_dohabank_action) forControlEvents:UIControlEventTouchUpInside];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
    
    
}

-(void)picker_set_UP
{
//    @try
//    {
//        NSArray *country_arr_temp =[[NSUserDefaults standardUserDefaults] valueForKey:@"country_arr"];
//        for(int i=0;i<country_arr_temp.count;i++)
//        {
//            [country_arr addObject:[[country_arr_temp objectAtIndex:i] valueForKey:@"name"]];
//        }
//        
//        [country_arr sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//    }
//    @catch(NSException *exception)
//    {
//        
//    }
//    [country_arr sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    [self CountryAPICall];
    _country_picker_view = [[UIPickerView alloc] init];
    _country_picker_view.delegate = self;
    _country_picker_view.dataSource = self;
    
    
    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(tappedToSelectRow:)];
    tapToSelect.delegate = self;
    [_country_picker_view addGestureRecognizer:tapToSelect];
    
    
  //  NSLog(@"%@",country_arr);
    
    UIToolbar* phone_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    phone_close.barStyle = UIBarStyleBlackTranslucent;
    [phone_close sizeToFit];
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(phone_close.frame.size.width - 100, 0, 100, phone_close.frame.size.height);
    [close setTitle:@"Done" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(countrybuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [phone_close addSubview:close];
    
    _TXT_countries.layer.borderWidth = 0.5f;
    _TXT_countries.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _TXT_countries.inputAccessoryView=phone_close;
    _TXT_countries.inputView = _country_picker_view;
    

}
-(void)CountryAPICall{
    
    @try {
        response_countries_dic = [NSMutableDictionary dictionary];
        NSString *country_ID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/countriesapi/%@.json",SERVER_URL,country_ID];
        @try
        {
            NSError *error;
            // NSError *err;
            NSHTTPURLResponse *response = nil;
            
            
            // NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/login/1.json",SERVER_URL];
            // urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:urlProducts];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            //[request setHTTPBody:postData];
            //[request setAllHTTPHeaderFields:headers];
            [request setHTTPShouldHandleCookies:NO];
            NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if (error) {
                
                
              
                
            }
            
            if(aData)
            {
                
                NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"The response Api post sighn up API %@",json_DATA);
                
                
                
                [response_countries_dic addEntriesFromDictionary:json_DATA];
                [country_arr removeAllObjects];
                //[response_picker_arr addObjectsFromArray:[response_countries_dic allKeys]]
                for (int x=0; x<[[response_countries_dic allKeys] count]; x++) {
                    NSDictionary *dic = @{@"cntry_id":[[response_countries_dic allKeys] objectAtIndex:x],@"cntry_name":[response_countries_dic valueForKey:[[response_countries_dic allKeys] objectAtIndex:x]]};
                    
                    [country_arr addObject:dic];
                    
                }
                NSSortDescriptor *sortDescriptor;
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cntry_name"
                                                             ascending:YES];
                NSArray *sortedArr = [country_arr sortedArrayUsingDescriptors:@[sortDescriptor]];
                
                
                NSMutableArray  *required_format = [NSMutableArray array];
                for (int l =0; l<sortedArr.count; l++) {
                    
                    if ([[[sortedArr objectAtIndex:l] valueForKey:@"cntry_name"] isEqualToString:@"Qatar"] ) {
                        
                        [required_format addObject:[sortedArr objectAtIndex:l]];
                        
                    }
                    
                }
                for (int l =0; l<sortedArr.count; l++) {
                    
                    if ([[[sortedArr objectAtIndex:l] valueForKey:@"cntry_name"] isEqualToString:@"India"]) {
                        
                        [required_format addObject:[sortedArr objectAtIndex:l]];
                        
                    }
                    
                }
                
                for (int m =0; m<sortedArr.count; m++) {
                    
                    if (![[[sortedArr objectAtIndex:m] valueForKey:@"cntry_name"] isEqualToString:@"Qatar"] && ![[[sortedArr objectAtIndex:m] valueForKey:@"cntry_name"] isEqualToString:@"India"]) {
                        
                        [required_format addObject:[sortedArr objectAtIndex:m]];
                        
                    }
                    
                }
                
                
                
                NSLog(@"sortedArr %@",sortedArr);
                
                [country_arr removeAllObjects];
                [country_arr addObjectsFromArray:required_format];
                [_country_picker_view reloadAllComponents];
            }
            else
            {
              
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
            }
            
        }
        
        @catch(NSException *exception)
        {
            NSLog(@"The error is:%@",exception);
        }
        
    }
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
    }
}

-(void)countrybuttonClick
{
    [self.TXT_countries resignFirstResponder];
}

#pragma collection view delegates
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}
#pragma Tableview delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  country_arr.count;
}

#pragma Button action
-(void)cancel_action
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)BTN_american_express_action
{
    self.BTN_american_express.layer.cornerRadius = 2.0f;
    _BTN_american_express.layer.borderWidth = 2.0f;
    _BTN_american_express.layer.borderColor = self.BTN_pay.backgroundColor.CGColor;
    
    _BTN_visa.layer.borderColor = [UIColor whiteColor].CGColor;
    _BTN_dohabank.layer.borderColor = [UIColor whiteColor].CGColor;
    str_URL = @"6";
    
    
}
-(void)BTN_visa_action
{
    self.BTN_visa.layer.cornerRadius = 2.0f;
    _BTN_visa.layer.borderWidth = 2.0f;
    _BTN_visa.layer.borderColor = self.BTN_pay.backgroundColor.CGColor;
    
    _BTN_american_express.layer.borderColor = [UIColor whiteColor].CGColor;
    _BTN_dohabank.layer.borderColor = [UIColor whiteColor].CGColor;
    str_URL = @"4";
}
-(void)BTN_dohabank_action
{
    self.BTN_dohabank.layer.cornerRadius = 2.0f;
    _BTN_dohabank.layer.borderWidth = 2.0f;
    _BTN_dohabank.layer.borderColor = self.BTN_pay.backgroundColor.CGColor;
    
    _BTN_visa.layer.borderColor = [UIColor whiteColor].CGColor;
    _BTN_american_express.layer.borderColor = [UIColor whiteColor].CGColor;
    str_URL = @"1";
    
}

-(void)pay_action
{
    @try
    {
        if(str_URL.length < 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select Card" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
            
        }
        else
        {

    NSDictionary *order_dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"order_details"];
    
    
    NSString *str_url = [NSString stringWithFormat:@"https://api.q-tickets.com/Qpayment-registration.aspx?Currency=QAR&Amount=%@&OrderName=online&OrderID=%@&nationality=Qatar&paymenttype=%@",[order_dict valueForKey:@"_balanceamount"],[order_dict  valueForKey:@"_orderid"],str_URL];
            str_url = [str_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    [[NSUserDefaults standardUserDefaults] setValue:str_url forKey:@"payment_url"];
    [[NSUserDefaults standardUserDefaults]  synchronize];
    
    [self performSegueWithIdentifier:@"pay_web_identifier" sender:self];
        }
    }
    @catch(NSException *exception)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"connection error"delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"THe Exception in events Pay LAst:%@",exception);

    }
       
}

- (IBAction)back_action:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [_country_picker_view rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(_country_picker_view.bounds, 0.0, (CGRectGetHeight(_country_picker_view.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_country_picker_view]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [_country_picker_view selectedRowInComponent:0];
            [self pickerView:_country_picker_view didSelectRow:selectedRow inComponent:0];
        }
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}

#pragma picker view delgates
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [country_arr count];
    
}
#pragma mark - UIPickerViewDelegate


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return country_arr[row];
    
}

// #6
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.TXT_countries.text = country_arr[row];
    NSLog(@"the text is:%@",_TXT_countries.text);
    
    
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
