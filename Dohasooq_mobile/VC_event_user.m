//
//  VC_event_user.m
//  Dohasooq_mobile
//
//  Created by Test User on 28/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_event_user.h"

@interface VC_event_user ()
{
    float scroll_height;
}

@end

@implementation VC_event_user

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect frameset = _VW_contents.frame;
    frameset.size.height = _BTN_pay.frame.origin.y + _BTN_pay.frame.size.height;
    frameset.size.width = _scroll_contents.frame.size.width;
    _VW_contents.frame = frameset;
    [self.scroll_contents addSubview:_VW_contents];
    
    @try
    {
        NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"Amount_dict"];
        _LBL_amount.text = [NSString stringWithFormat:@"%@ QR",[arr objectAtIndex:1]];
        _LBL_service_charges.text = [NSString stringWithFormat:@"%@ QR",[arr objectAtIndex:2]];

    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    
    _BTN_apply.layer.cornerRadius = 2.0f;
    _BTN_apply.layer.masksToBounds = YES;
    scroll_height  = _VW_contents.frame.origin.y + _VW_contents.frame.size.height;
    [_BTN_pay addTarget:self action:@selector(Pay_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_check addTarget:self action:@selector(BTN_chek_action) forControlEvents:UIControlEventTouchUpInside];

}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_contents layoutIfNeeded];
    _scroll_contents.contentSize = CGSizeMake(_scroll_contents.frame.size.width,scroll_height);
    
}
#pragma text field delgates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField)
    {
        scroll_height = scroll_height + 100;
        [self viewDidLayoutSubviews];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField)
    {
        scroll_height = scroll_height - 100;
        [self viewDidLayoutSubviews];
    }
    
    
}
#pragma Button Actions
- (IBAction)back_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)Pay_action
{
    [self performSegueWithIdentifier:@"user_detail_pay" sender:self];
}

-(void)BTN_chek_action
{
    if(_LBL_stat.tag == 0)
    {
        _LBL_stat.image = [UIImage imageNamed:@"uncheked_order"];
        [_LBL_stat setTag:1];
    }
    else if(_LBL_stat.tag == 1)
    {
        _LBL_stat.image = [UIImage imageNamed:@"checked_order"];
        [_LBL_stat setTag:0];
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
