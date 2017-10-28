//
//  VC_contact_us.m
//  Dohasooq_mobile
//
//  Created by Test User on 07/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_contact_us.h"
#import "UIView+Shadow.h"

@interface VC_contact_us ()<UITextFieldDelegate>
{
    float scroll_ht;
}
@end

@implementation VC_contact_us

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self set_up_VIEW];
}
-(void)set_up_VIEW
{
    _LBL_address.text = @"Doha Bank\n13th Floor,Doha Bank Tower,Near Sheraton\nCorniche Street,West Bay\nPO BOX 3818\nDoha,Qatar";
    [_LBL_address sizeToFit];
    
    _VW_address.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _VW_address.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    _VW_address.layer.shadowOpacity = 1.0;
    _VW_address.layer.shadowRadius = 4.0;
    CGRect frameset = _VW_address.frame;
    //frameset.size.width = _Scroll_contents.frame.size.width;
    frameset.size.height = _LBL_address.frame.origin.y + _LBL_address.frame.size.height;
    _VW_address.frame = frameset;
    
//    _VW_address.layer.borderWidth = 0.2f;
//    _VW_address.layer.borderColor = [UIColor blackColor].CGColor;
//     [_VW_address makeInsetShadowWithRadius:2.0 Color:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4] Directions:[NSArray arrayWithObjects: @"bottom", nil]];
   
    
    frameset = _VW_contact_us.frame;
    frameset.origin.y = _VW_address.frame.origin.y + _VW_address.frame.size.height + 10;
    frameset.size.width = _Scroll_contents.frame.size.width;
    _VW_contact_us.frame = frameset;
    
    frameset = _BTN_submit.frame;
    frameset.origin.y = _VW_contact_us.frame.origin.y + _VW_contact_us.frame.size.height + 10;
    _BTN_submit.frame = frameset;
    
    frameset = _VW_contents.frame;
    frameset.size.height = _BTN_submit.frame.origin.y + _BTN_submit.frame.size.height + 10;
    frameset.size.width = _Scroll_contents.frame.size.width;
    _VW_contents.frame = frameset;
    [self.Scroll_contents addSubview:_VW_contents];
    scroll_ht = _BTN_submit.frame.origin.y + _BTN_submit.frame.size.height;
    
  
    
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_contents layoutIfNeeded];
    _Scroll_contents.contentSize = CGSizeMake(_Scroll_contents.frame.size.width,scroll_ht);
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
        scroll_ht = scroll_ht + 100;
        [self viewDidLayoutSubviews];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField)
    {
        scroll_ht = scroll_ht - 100;
        [self viewDidLayoutSubviews];
    }
    
    
}
- (IBAction)back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)contact_SUBMIT
{
    NSString *text_to_compare_email = _TXT_email.text;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    NSString *msg;
    if ([_TXT_F_name.text isEqualToString:@""])
    {
        [_TXT_F_name becomeFirstResponder];
        msg = @"Please enter First Name field";
        
    }
    else if(_TXT_F_name.text.length < 3)
    {
        [_TXT_F_name becomeFirstResponder];
        msg = @"First name should not be less than 3 characters";
        
    }
    else if([_TXT_F_name.text isEqualToString:@" "])
    {
        [_TXT_F_name becomeFirstResponder];
        msg = @"Blank space are not allowed";
        
    }
    else if([_TXT_email.text isEqualToString:@""])
    {
        [_TXT_email becomeFirstResponder];
        msg = @"Please enter Email";
        
    }
    
    else if([emailTest evaluateWithObject:text_to_compare_email] == NO)
    {
        [_TXT_email becomeFirstResponder];
        msg = @"Please enter valid email address";
        
        
        
    }
       else if (_TXT_phone.text.length < 2)
    {
        [_TXT_phone becomeFirstResponder];
        msg = @"Phone Number cannot be less than 5 digits";
        
    }
    else if(_TXT_phone.text.length>15)
    {
        [_TXT_phone becomeFirstResponder];
        msg = @"Phone Number should not be more than 15 characters";
        
        
    }
    else if([_TXT_organisation.text isEqualToString:@""])
    {
        [_TXT_organisation becomeFirstResponder];
        msg = @"Please enter Message";
        
    }
       if(msg)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
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
