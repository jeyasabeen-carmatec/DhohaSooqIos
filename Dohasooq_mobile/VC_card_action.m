//
//  VC_card_action.m
//  Dohasooq_mobile
//
//  Created by Test User on 13/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_card_action.h"
#import "Helper_activity.h"

@interface VC_card_action ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *country_arr;
    NSTimer *timer;
    int currMinute;
    int currSeconds;
    NSString *str_URL;
}


@end

@implementation VC_card_action

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    country_arr = [[NSMutableArray alloc]init];
    _TXT_countries.inputView = [[UIView alloc]init];
    self.navigationController.navigationBar.hidden = YES;

    [_LBL_timer setText:@"Time :10:00"];
    currMinute=10;
    currSeconds=00;
    [self picker_set_UP];
    [self start];
    [_BTN_pay addTarget:self action:@selector(pay_action) forControlEvents:UIControlEventTouchUpInside];
    
    [_BTN_cancel addTarget:self action:@selector(cancel_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_american_express addTarget:self action:@selector(BTN_american_express_action) forControlEvents:UIControlEventTouchUpInside];

    [_BTN_visa addTarget:self action:@selector(BTN_visa_action) forControlEvents:UIControlEventTouchUpInside];

    [_BTN_dohabank addTarget:self action:@selector(BTN_dohabank_action) forControlEvents:UIControlEventTouchUpInside];
    // Country API Calling
    [self CountryAPICall];

}
-(void)start
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
}
-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1)
            [_LBL_timer setText:[NSString stringWithFormat:@"%@%d%@%02d",@"Time : ",currMinute,@":",currSeconds]];
    }
    else
    {
        [timer invalidate];
    }
}
-(void)picker_set_UP
{

    _country_picker_view = [[UIPickerView alloc] init];
    _country_picker_view.delegate = self;
    _country_picker_view.dataSource = self;
    
    
    NSLog(@"%@",country_arr);
    
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
   // [self.navigationController popToRootViewControllerAnimated:NO];
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
    if(str_URL.length < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select Card" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
 
    }
    else
    {
    
    NSDictionary *order_dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"order_details"];
    
      NSString *str_url = [NSString stringWithFormat:@"https://api.q-tickets.com/Qpayment-registration.aspx?Currency=QAR&Amount=%@&OrderName=online&OrderID=%@&nationality=%@&paymenttype=%@",[[order_dict valueForKey:@"result"] valueForKey:@"_balance"],[[order_dict valueForKey:@"result"] valueForKey:@"_OrderInfo"],_TXT_countries.text,str_URL];
    [[NSUserDefaults standardUserDefaults] setValue:str_url forKey:@"payment_url"];
    [[NSUserDefaults standardUserDefaults]  synchronize];
    
    [self performSegueWithIdentifier:@"Movie_pay_web" sender:self];
    }
}

- (IBAction)back_action:(id)sender {
    
    
    [self dismissViewControllerAnimated:NO completion:nil];
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
    return [[country_arr objectAtIndex:row] valueForKey:@"cntry_name"];
    
}

// #6
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.TXT_countries.text =  [[country_arr objectAtIndex:row] valueForKey:@"cntry_name"];
  //  NSLog(@"the text is:%@",_TXT_countries.text);
    
    
}

#pragma mark CountryAPI Call
//http://192.168.0.171/dohasooq/'apis/countriesapi.json
-(void)CountryAPICall{
    @try {
        
        [Helper_activity animating_images:self];
       NSMutableDictionary *response_countries_dic = [NSMutableDictionary dictionary];
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
                
                
                [Helper_activity stop_activity_animation:self];
                
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
                
                 [Helper_activity stop_activity_animation:self];
                
                NSLog(@"sortedArr %@",sortedArr);
                
                [country_arr removeAllObjects];
                [country_arr addObjectsFromArray:required_format];
                [_country_picker_view reloadAllComponents];
            }
            else
            {
                [Helper_activity stop_activity_animation:self];
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
            }
            
        }
        
        @catch(NSException *exception)
        {
            NSLog(@"The error is:%@",exception);
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
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
