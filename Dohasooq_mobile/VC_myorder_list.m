//
//  VC_myorder_list.m
//  Dohasooq_mobile
//
//  Created by Test User on 04/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_myorder_list.h"
#import "orders_list_cell.h"

@interface VC_myorder_list ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation VC_myorder_list

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)back_ACTIon:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    orders_list_cell *order_cell = (orders_list_cell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (order_cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"orders_list_cell" owner:self options:nil];
        order_cell = [nib objectAtIndex:0];
    }
    NSString *str = @"789457534";
    NSString *text = [NSString stringWithFormat:@"ORDER ID : %@",str];
    
    
    if ([order_cell.BTN_order_ID.titleLabel respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:order_cell.BTN_order_ID.titleLabel.textColor,
                                  NSFontAttributeName: order_cell.BTN_order_ID.titleLabel.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
        
        
        NSRange ename = [text rangeOfString:str];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0],NSForegroundColorAttributeName :[UIColor blueColor]}
                                    range:ename];
        }
        [order_cell.BTN_order_ID setAttributedTitle:attributedText forState:UIControlStateNormal];
    }
    else
    {
        [order_cell.BTN_order_ID setTitle:text forState:UIControlStateNormal];
    }
    NSString *date = @"sun,jun 4th,2017";
    NSString *date_text = [NSString stringWithFormat:@"Order on: %@",date];
    
    
    if ([order_cell.LBL_order_date respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:order_cell.LBL_order_date.textColor,
                                  NSFontAttributeName: order_cell.LBL_order_date.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:date_text attributes:attribs];
        
        
        
        NSRange ename = [date_text rangeOfString:date];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0],NSForegroundColorAttributeName :[UIColor blackColor]}
                                    range:ename];
        }
        order_cell.LBL_order_date.attributedText = attributedText;
    }
    else
    {
        order_cell.LBL_order_date.text = text;
    }
    NSString *qr = @"285";
    NSString *price = [NSString stringWithFormat:@"QR %@",qr];
    
    if ([order_cell.LBL_price respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:order_cell.LBL_price.textColor,
                                  NSFontAttributeName:order_cell.LBL_price .font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:price attributes:attribs];
        
        NSRange qrs = [price rangeOfString:qr];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                    range:qrs];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.96 green:0.69 blue:0.24 alpha:1.0]}
                                    range:qrs];
        }
        order_cell.LBL_price.attributedText = attributedText;
    }
    else
    {
        order_cell.LBL_price.text = price;
    }
    order_cell.VW_content.layer.borderWidth = 1.5f;
    order_cell.VW_content.layer.borderColor = [UIColor grayColor].CGColor;

    return order_cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"order_list_detail" sender:self];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
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
