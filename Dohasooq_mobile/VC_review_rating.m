//
//  VC_review_rating.m
//  Dohasooq_mobile
//
//  Created by Test User on 05/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_review_rating.h"

@interface VC_review_rating ()<UITextFieldDelegate>
{
    HCSStarRatingView *lbl_review;
}

@end

@implementation VC_review_rating

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    CGRect frameset = _LBL_rating.frame;
//    frameset.origin.y = _LBL_item_name.frame.origin.y + _LBL_item_name.frame.size.height;
//    _LBL_rating.frame = frameset;
//    
//     frameset = _LBL_my_review.frame;
//    frameset.origin.y = _LBL_item_name.frame.origin.y + _LBL_item_name.frame.size.height;
//    _LBL_my_review.frame = frameset;
//    
//    frameset = _TXT_review_title.frame;
//    frameset.origin.y = _LBL_my_review.frame.origin.y + _LBL_my_review.frame.size.height;
//    _TXT_review_title.frame = frameset;
//    
//    frameset = _TXT_review_review.frame;
//    frameset.origin.y = _TXT_review_title.frame.origin.y + _TXT_review_title.frame.size.height;
//    _TXT_review_review.frame = frameset;
//    
//    frameset = _BTN_save.frame;
//    frameset.origin.y = _TXT_review_review.frame.origin.y + _TXT_review_review.frame.size.height;
//    _BTN_save.frame = frameset;
    
    lbl_review = [[HCSStarRatingView alloc] init];
    lbl_review.frame = CGRectMake(_LBL_my_review.frame.origin.x + _LBL_my_review.frame.size.width+3 ,_LBL_my_review.frame.origin.y-15  ,150.0f,_LBL_my_review.frame.size.height + 20);
    lbl_review.maximumValue = 5;
    lbl_review.minimumValue = 0;
    lbl_review.value = 0;
    
    lbl_review.tintColor = [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];
    //[starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    lbl_review.allowsHalfStars = YES;
    lbl_review.value = 2.5f;
    [self.view addSubview:lbl_review];
    
    NSString *item_name =[NSString stringWithFormat:@"Shining Diva Fashion"];
    
    item_name = [item_name stringByReplacingOccurrencesOfString:@"<null>" withString:@"not mentioned"];
    NSString *item_seller =[NSString stringWithFormat:@"Seller : Anar ahar"];
    item_name = [item_name stringByReplacingOccurrencesOfString:@"<null>" withString:@"not mentioned"];
    
    NSString *name_text = [NSString stringWithFormat:@"%@\n%@",item_name,item_seller];
    _LBL_item_name.numberOfLines = 0;
    
    
    if ([_LBL_item_name respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_item_name.textColor,
                                  NSFontAttributeName:_LBL_item_name.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:name_text attributes:attribs];
        
        
        
        NSRange ename = [name_text rangeOfString:item_name];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:17.0]}
                                    range:ename];
        }
        NSRange cmp = [name_text rangeOfString:item_seller];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:21.0]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:13.0]}
                                    range:cmp ];
        }
        _LBL_item_name.attributedText = attributedText;
    }
    else
    {
        _LBL_item_name.text = name_text;
    }
    


}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
     if(result.height <= 568)
     {
    
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
     }

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height <= 568)
    {
    [UIView beginAnimations:nil context:NULL];
    
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    }
    
}
- (IBAction)back_ACTIon:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)wish_list_action:(id)sender {
    [self performSegueWithIdentifier:@"rating_to_wish_lsit" sender:self];
}
- (IBAction)cart_action:(id)sender {
    [self performSegueWithIdentifier:@"rating_to_cart_lsit" sender:self];

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
