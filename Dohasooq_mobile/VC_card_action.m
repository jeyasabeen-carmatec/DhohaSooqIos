//
//  VC_card_action.m
//  Dohasooq_mobile
//
//  Created by Test User on 13/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_card_action.h"

@interface VC_card_action ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *country_arr;
    NSTimer *timer;
    int currMinute;
    int currSeconds;
}


@end

@implementation VC_card_action

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _TXT_countries.inputView = [[UIView alloc]init];
    self.navigationController.navigationBar.hidden = NO;

    [_LBL_timer setText:@"Time :10:00"];
    currMinute=10;
    currSeconds=00;
    [self picker_set_UP];
    [self start];
    [_BTN_pay addTarget:self action:@selector(pay_action) forControlEvents:UIControlEventTouchUpInside];
    
    [_BTN_cancel addTarget:self action:@selector(cancel_action) forControlEvents:UIControlEventTouchUpInside];
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
    country_arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"country_array"];
    
    
    _country_picker_view = [[UIPickerView alloc] init];
    _country_picker_view.delegate = self;
    _country_picker_view.dataSource = self;
    
    
    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(tappedToSelectRow:)];
    tapToSelect.delegate = self;
    [_country_picker_view addGestureRecognizer:tapToSelect];
    
    
    NSLog(@"%@",country_arr);
    
    UIToolbar* phone_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    phone_close.barStyle = UIBarStyleBlackTranslucent;
    [phone_close sizeToFit];
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(phone_close.frame.size.width - 100, 0, 100, phone_close.frame.size.height);
    [close setTitle:@"close" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(countrybuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [phone_close addSubview:close];
    
    _TXT_countries.layer.borderWidth = 0.8f;
    _TXT_countries.layer.borderColor = [UIColor grayColor].CGColor;
    
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
-(void)pay_action
{
    
    NSDictionary *order_dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"order_details"];
    
      NSString *str_url = [NSString stringWithFormat:@"https://api.q-tickets.com/Qpayment-registration.aspx?Currency=QAR&Amount=%@&OrderName=online&OrderID=%@&nationality=Qatar&paymenttype=4",[[order_dict valueForKey:@"result"] valueForKey:@"_balance"],[[order_dict valueForKey:@"result"] valueForKey:@"_OrderInfo"]];
    [[NSUserDefaults standardUserDefaults] setValue:str_url forKey:@"payment_url"];
    [[NSUserDefaults standardUserDefaults]  synchronize];
    
    [self performSegueWithIdentifier:@"Movie_pay_web" sender:self];
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
  //  NSLog(@"the text is:%@",_TXT_countries.text);
    
    
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
