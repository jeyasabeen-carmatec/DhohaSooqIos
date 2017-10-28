//
//  VC_forgot_PWD.m
//  Dohasooq_mobile
//
//  Created by Test User on 27/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_forgot_PWD.h"

@interface VC_forgot_PWD ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@end

@implementation VC_forgot_PWD

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //_lbl_forgot_pwd.text = @"We just need your registered merchant\nemail address to send you password reset";
    //[_lbl_forgot_pwd sizeToFit];
    _vw_align.center = self.view.center;
    CGRect set_frame = _BTN_close.frame;
    set_frame.origin.x = self.view.frame.size.width / 2;
    _BTN_close.frame = set_frame;

    UIImage *newImage = [_BTN_close.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(_BTN_close.image.size, NO, newImage.scale);
    [[UIColor darkGrayColor] set];
    [newImage drawInRect:CGRectMake(0, 0, _BTN_close.image.size.width/2, newImage.size.height/2)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _BTN_close.image = newImage;
    
    _BTN_close .userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture_close)];
    
    tapGesture1.numberOfTapsRequired = 1;
    
    [tapGesture1 setDelegate:self];
    
    [_BTN_close addGestureRecognizer:tapGesture1];
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma button action
-(void)tapGesture_close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma textfield delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField)
    {
        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
        
    }
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    
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
