//
//  VC_order_detail.m
//  Dohasooq_mobile
//
//  Created by Test User on 28/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//


#import "VC_order_detail.h"
#import "UIBarButtonItem+Badge.h"
#import "order_cell.h"
#import "shipping_cell.h"
#import "billing_address.h"
#import "pay_cell.h"

@interface VC_order_detail ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDataSource, UICollectionViewDelegate>


{
    NSMutableArray *arr_product,*arr_address;
    NSString *TXT_count;
    int i,j;
    NSMutableArray  *temp_arr;
    BOOL isfirstTimeTransform;
    float scroll_height;
    UIView *VW_overlay;

}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation VC_order_detail
#define TRANSFORM_CELL_VALUE CGAffineTransformMakeScale(0.8, 0.8)
#define ANIMATION_SPEED 0.2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isfirstTimeTransform = YES;
    [self set_UP_VIEW];
    
}
-(void)set_UP_VIEW
{
    isfirstTimeTransform = YES;
   
    _LBL_stat.tag = 0;
    
   
    temp_arr = [[NSMutableArray alloc]init];
    temp_arr = [NSMutableArray arrayWithObjects:@"debit_card.png",@"credit_card.png",@"net_banking.png",@"cod.png",nil];
    i = 1,j = 0;;
   
    
     CGRect frame_set = _TXT_first.frame;
    frame_set.origin.x = _LBL_order_detail.frame.origin.x + _LBL_order_detail.frame.size.width - 1;
     frame_set.size.width = _LBL_shipping.frame.origin.x - ( _LBL_order_detail.frame.origin.x + _LBL_order_detail.frame.size.width)  + 2 ;
    _TXT_first.frame = frame_set;
    
    frame_set = _TXT_second.frame;
    frame_set.origin.x = _LBL_shipping.frame.origin.x + _LBL_shipping.frame.size.width - 1;
       frame_set.size.width = _LBL_Payment.frame.origin.x - ( _LBL_shipping.frame.origin.x + _LBL_shipping.frame.size.width) + 2 ;
    _TXT_second.frame = frame_set;
    
    frame_set = _TXT_second.frame;
    frame_set.origin.x = _LBL_shipping.frame.origin.x + _LBL_shipping.frame.size.width - 1;
    frame_set.size.width = _LBL_Payment.frame.origin.x - ( _LBL_shipping.frame.origin.x + _LBL_shipping.frame.size.width) + 2 ;
    _TXT_second.frame = frame_set;
    
    frame_set = _VW_card.frame;
    frame_set.origin.y = _collectionView.frame.origin.y + _collectionView.frame.size.height;
    frame_set.size.width = _Scroll_card.frame.size.width;
    frame_set.size.height = _BTN_pay.frame.origin.y + _BTN_pay.frame.size.height;
    _VW_card.frame = frame_set;
    [self.Scroll_card addSubview:_VW_card];
    scroll_height = _VW_card.frame.origin.y + _VW_card.frame.size.height;
    
    VW_overlay = [[UIView alloc]init];
    CGRect vwframe;
    vwframe = VW_overlay.frame;
    vwframe.origin.y = self.navigationController.navigationBar.frame.origin.y;
    vwframe.size.height = self.view.frame.size.height - _VW_next.frame.size.height - self.navigationController.navigationBar.frame.size.height;
    vwframe.size.width = self.view.frame.size.width;
    VW_overlay.frame = vwframe;
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]; //[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
   // VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    
    VW_overlay.hidden = YES;

    
    frame_set = _VW_summary.frame;
    frame_set.origin.y = _VW_next.frame.origin.y - _VW_summary.frame.size.height - 20;
    frame_set.size.width = _TBL_orders.frame.size.width;
    //  frame_set.size.height = _VW_next.frame.origin.y - _TBL_orders.frame.origin.y;
    _VW_summary.frame = frame_set;
    [VW_overlay addSubview:_VW_summary];
    
    _VW_summary.hidden = YES;
    
    _BTN_apply_promo.layer.cornerRadius = 2.0f;
    _BTN_apply_promo.layer.masksToBounds = YES;
    
    arr_product = [[NSMutableArray alloc]init];
    NSDictionary *temp_dictin;
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [arr_product addObject:temp_dictin];
    
    
    arr_address = [[NSMutableArray alloc]init];
    NSDictionary *addr_dict;
    addr_dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Azan Choudary",@"key1",@"Avendia porugal147 bajo,\ncabab islas carrias,salamanca\nQatar 656753",@"key2", nil];
     [arr_address addObject:addr_dict];
    addr_dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Azan Choudary",@"key1",@"Avendia porugal147 bajo,\ncabab islas carrias,salamanca\nQatar 656753",@"key2", nil];
    [arr_address addObject:addr_dict];
    addr_dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Azan Choudary",@"key1",@"Avendia porugal147 bajo,\ncabab islas carrias,salamanca\nQatar 656753",@"key2", nil];
    [arr_address addObject:addr_dict];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:17.0f]
       } forState:UIControlStateNormal];
    
    
    
    _BTN_fav  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain  target:self action:
                 @selector(btnfav_action)];
    _BTN_cart = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain   target:self action:@selector(btn_cart_action)];
    NSString *badge_value = @"25";
    
    
    if(badge_value.length > 2)
    {
        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
        
    }
    else{
        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
        
    }
    

    
    
    _LBL_order_detail.layer.cornerRadius = _LBL_order_detail.frame.size.width / 2;
    _LBL_order_detail.layer.borderWidth = 2.5f;
    _LBL_order_detail.layer.borderColor = [UIColor whiteColor].CGColor;
    _LBL_order_detail.backgroundColor = [UIColor colorWithRed:0.20 green:0.76 blue:0.33 alpha:1.0];
    _LBL_order_detail.layer.masksToBounds = YES;
    
    
    _LBL_shipping.layer.cornerRadius = _LBL_order_detail.frame.size.width / 2;
    _LBL_shipping.layer.borderWidth = 2.5f;
    _LBL_shipping.layer.borderColor = [UIColor whiteColor].CGColor;
    _LBL_shipping.layer.masksToBounds = YES;
    
    _LBL_Payment.layer.cornerRadius = _LBL_order_detail.frame.size.width / 2;
    _LBL_Payment.layer.borderWidth = 2.5f;
    _LBL_Payment.layer.borderColor = [UIColor whiteColor].CGColor;
    _LBL_Payment.layer.masksToBounds = YES;
    
    _TXT_first.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_first.layer.borderWidth = 1.7f;
    
    _TXT_second.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_second.layer.borderWidth = 1.7f;
    
    NSString *qr = @"QR";
    NSString *price = @"4565";
    
    NSString *text = [NSString stringWithFormat:@"%@ %@",qr,price];
    if ([_LBL_product_summary respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_product_summary.textColor,
                                  NSFontAttributeName:_LBL_product_summary.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
        
        
        NSRange ename = [text rangeOfString:qr];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0]}
                                    range:ename];
        }
        NSRange cmp = [text rangeOfString:price];
        //        [attributedText addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [prec_price length])];
        //
        
        
        //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:21.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:cmp ];
        }
        
        
        _LBL_product_summary.attributedText = attributedText;
    }
    else
    {
        _LBL_product_summary.text = text;
    }
    _LBL_product_summary.numberOfLines = 0;
    [_LBL_product_summary sizeToFit];
    
//        frame_set = _LBL_arrow.frame;
//        frame_set.origin.x = _LBL_total.frame.origin.x+_LBL_total.frame.size.width + 2;
//        frame_set.origin.y = _LBL_total.frame.origin.y;
//        _LBL_arrow.frame = frame_set;
//        [self.VW_next addSubview:_LBL_arrow];

    NSString *next = @"";
    NSString *next_text = [NSString stringWithFormat:@"NEXT %@",next];
    if ([_LBL_next respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_next.textColor,
                                  NSFontAttributeName:_LBL_next.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:next_text attributes:attribs];
        
        
        
        NSRange ename = [next_text rangeOfString:next];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:ename];
        }
        
        _LBL_next.attributedText = attributedText;
    }
    else
    {
        _LBL_next.text = text;
    }
    
    NSString *terms = @"terms & conditions";
    NSString *conditions = [NSString stringWithFormat:@"i agree that i have read and accepted our %@ for your purchase",terms];
    if ([_LBL_terms respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_terms.textColor,
                                  NSFontAttributeName:_LBL_terms.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:conditions attributes:attribs];
        
        
        
        NSRange ename = [conditions rangeOfString:terms];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:12.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:ename];
        }
        
        _LBL_terms.attributedText = attributedText;
    }
    else
    {
        _LBL_terms.text = conditions;
    }
    
    
    NSString *current_price = [NSString stringWithFormat:@"QR"];
    NSString *prec_price = [NSString stringWithFormat:@"6800"];
    NSString *summary_text = [NSString stringWithFormat:@"%@ %@",current_price,prec_price];
    
    if ([_LBL_total respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_total.textColor,
                                  NSFontAttributeName:_LBL_total.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:summary_text attributes:attribs];
        
        
        
        NSRange ename = [summary_text rangeOfString:current_price];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0]}
                                    range:ename];
        }
        NSRange cmp = [summary_text rangeOfString:prec_price];
        //        [attributedText addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [prec_price length])];
        //
        
        
        //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:21.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:17.0],NSForegroundColorAttributeName:[UIColor redColor],}
                                    range:cmp ];
        }
        _LBL_total.attributedText = attributedText;
    }
    else
    {
       _LBL_total.text = summary_text;
    }


    [_BTN_next addTarget:self action:@selector(next_page) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_Product_summary addTarget:self action:@selector(product_clicked) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_done addTarget:self action:@selector(deliveryslot_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_check addTarget:self action:@selector(BTN_chek_action) forControlEvents:UIControlEventTouchUpInside];

    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_card layoutIfNeeded];
    _Scroll_card.contentSize = CGSizeMake(_Scroll_card.frame.size.width,scroll_height);
}
#pragma tableview delagates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
if(tableView == _TBL_address)
{
    return i;
    
}
else
{
    return 1;
}

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _TBL_orders)
    {
    return arr_product.count;
        
    }
    else
    {
        if(section == 0)
        {
        return arr_address.count;
        }
        else
        {
            return 1;
        }
    }

    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == _TBL_orders)
    {
    order_cell *cell = (order_cell *)[tableView dequeueReusableCellWithIdentifier:@"order_cell"];
    NSDictionary *temp_dict=[arr_product objectAtIndex:indexPath.row];
    
    
    if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"order_cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    temp_dict = [arr_product objectAtIndex:indexPath.row];
    
    cell.IMG_item.image = [UIImage imageNamed:[temp_dict valueForKey:@"key5"]];
    
    
    NSString *item_name =[temp_dict valueForKey:@"key1"];
    NSString *item_seller = @"Seller : Dohasooq";
    NSString *name_text = [NSString stringWithFormat:@"%@\n%@",item_name,item_seller];
    cell.LBL_item_name.numberOfLines = 0;
   
    
    if ([cell.LBL_item_name respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:cell.LBL_item_name.textColor,
                                  NSFontAttributeName:cell.LBL_item_name.font
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
        cell.LBL_item_name.attributedText = attributedText;
    }
    else
    {
        cell.LBL_item_name.text = name_text;
    }

    
    
    NSString *qr = @"QR";
    NSString *price = @"499";
    NSString *prev_price = @"QR 799";
    NSString *doha_miles = @"6758";
    NSString *mils  = @"Doha Miles";
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@ / %@ %@",qr,price,prev_price,doha_miles,mils];
    
    if ([cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:cell.LBL_current_price.textColor,
                                  NSFontAttributeName:cell.LBL_current_price .font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
        NSRange qrs = [text rangeOfString:qr];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:25.0]}
                                    range:qrs];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                    range:qrs];
        }
        

        
        NSRange ename = [text rangeOfString:price];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:25.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:ename];
        }
        
        
        
        
        NSRange cmp = [text rangeOfString:prev_price];
        //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:21.0]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:13.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                    range:cmp];
        }
        
        NSRange miles_price = [text rangeOfString:doha_miles];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:21.0]}
                                    range:miles_price];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:miles_price];
        }
        NSRange miles = [text rangeOfString:mils];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:21.0]}
                                    range:miles];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:13.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                    range:miles];
        }
        
        
        
        cell.LBL_current_price .attributedText = attributedText;
    }
    else
    {
        cell.LBL_current_price .text = text;
    }
    
    
    
    //pro_cell.LBL_prev_price.text =  [temp_dict valueForKey:@"key3"];
    cell.LBL_discount.text = [temp_dict valueForKey:@"key4"];

    
    TXT_count = cell._TXT_count.text;
    cell._TXT_count.text = TXT_count;
    
    [cell.BTN_plus addTarget:self action:@selector(plus_action) forControlEvents:UIControlEventTouchUpInside];
    [cell.BTN_minus addTarget:self action:@selector(minus_action) forControlEvents:UIControlEventTouchUpInside];
    cell._TXT_count.layer.borderWidth = 0.4f;
    cell._TXT_count.layer.borderColor = [UIColor grayColor].CGColor;
    
    cell.BTN_plus.layer.borderWidth = 0.4f;
    cell.BTN_plus.layer.borderColor = [UIColor grayColor].CGColor;
    cell.BTN_minus.layer.borderWidth = 0.4f;
    cell.BTN_minus.layer.borderColor = [UIColor grayColor].CGColor;
    NSArray *arr = [NSArray arrayWithObjects:@"Aug 15th ,2017",@"Aug 15th ,2017",@"Aug 15th ,2017",@"Aug 15th ,2017",@"Aug 15th ,2017",@"Aug 15th ,2017",@"Aug 15th ,2017",@"Aug 15th ,2017",@"Aug 15th ,2017",@"Aug 15th ,2017",@"Aug 15th ,2017",@"Aug 15th ,2017",@"Aug 15th ,2017",@"Aug 15th ,2017",@"Aug 15th ,2017",@"Aug 15th ,2017",nil];
    NSString *date  = [arr objectAtIndex:indexPath.row];
    NSString *text1 = [NSString stringWithFormat:@"Delivery on %@",date];
    
    if ([cell.LBL_date respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:cell.LBL_date.textColor,
                                  NSFontAttributeName:cell.LBL_date .font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text1 attributes:attribs];
        
        NSRange ename = [text1 rangeOfString:date];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:ename];
        }
        
        cell.LBL_date .attributedText = attributedText;
    }
    else
    {
        cell.LBL_date .text = text1;
    }
    
    NSString *qrcode = @"QR";
    NSString *CHRGE = @"5";
    NSString *text2 = [NSString stringWithFormat:@"Shipping Charge %@ %@",qr,CHRGE];
    
    if ([cell.LBL_charge respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:cell.LBL_date.textColor,
                                  NSFontAttributeName:cell.LBL_date .font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text2 attributes:attribs];
        
        NSRange ename = [text2 rangeOfString:qrcode];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0]}
                                    range:ename];
        }
        NSRange chrge = [text2 rangeOfString:CHRGE];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:25.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:chrge];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                    range:chrge];
        }

        
        cell.LBL_charge .attributedText = attributedText;
    }
    else
    {
        cell.LBL_charge .text = text1;
    }
    cell.LBL_stat.tag =j;

    [cell.BTN_stat addTarget:self action:@selector(stat_chenged) forControlEvents:UIControlEventTouchUpInside];
        [cell.BTN_calendar addTarget:self action:@selector(calendar_action) forControlEvents:UIControlEventTouchUpInside];
        
       
        if(cell.LBL_stat == 0)
        {
            cell.LBL_stat.image = [UIImage imageNamed:@"uncheked_order"];
            [cell.LBL_stat setTag:1];
        }
        else if(cell.LBL_stat.tag == 1)
        {
            cell.LBL_stat.image = [UIImage imageNamed:@"checked_order"];
            [cell.LBL_stat setTag:0];
        }
             return cell;
        
    }
    else
    {
        
        if(indexPath.section == 0)
        {
        shipping_cell *cell = (shipping_cell *)[tableView dequeueReusableCellWithIdentifier:@"shipping_cell"];
        
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"shipping_cell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.BTN_edit_addres.hidden = YES;
            
            cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            cell.layer.shadowOffset = CGSizeMake(0.0, 0.0);
            cell.layer.shadowOpacity = 1.0;
            cell.layer.shadowRadius = 4.0;
        if(indexPath.row == arr_address.count - 1 )
        {
            cell.BTN_edit_addres.hidden = NO;
        }
        NSMutableDictionary *dict = [arr_address objectAtIndex:indexPath.row];
        cell.LBL_name.text = [dict valueForKey:@"key1"];
        cell.LBL_address.text = [dict valueForKey:@"key2"];
        
        
            
        [cell.BTN_edit addTarget:self action:@selector(BTN_edit_clickd) forControlEvents:UIControlEventTouchUpInside];
        return cell;
       
        }
        else
        {
            billing_address *cell = (billing_address *)[tableView dequeueReusableCellWithIdentifier:@"billing_address"];
            if (cell == nil)
            {
                NSArray *nib;
                nib = [[NSBundle mainBundle] loadNibNamed:@"billing_address" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
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
            
           
            [cell.BTN_check addTarget:self action:@selector(BTN_check_clickd) forControlEvents:UIControlEventTouchUpInside];
            cell.LBL_stat.tag = j;

            if(cell.LBL_stat.tag == 0)
            {
                cell.LBL_stat.image = [UIImage imageNamed:@"uncheked_order"];
                [cell.LBL_stat setTag:1];
            }
            else if(cell.LBL_stat.tag == 1)
            {
                cell.LBL_stat.image = [UIImage imageNamed:@"checked_order"];
                [cell.LBL_stat setTag:0];
            }

            return cell;
        }
        
        
    }

    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _TBL_orders)
    {
         return 198.0;
    }
    else
    {
        
        if(indexPath.section == 1)
        {
            return 679.0;

            
        }
        else
        {
            return 170;
        }
        
    }
    
   
}
#pragma mark - CollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return temp_arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    pay_cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0 && isfirstTimeTransform) { // make a bool and set YES initially, this check will prevent fist load transform
        isfirstTimeTransform = NO;
    }else{
        cell.transform = TRANSFORM_CELL_VALUE; // the new cell will always be transform and without animation
    }
    cell.IMG_card.image = [UIImage imageNamed:[temp_arr objectAtIndex:indexPath.row]];
    return cell;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    float pageWidth = 200 + 30; // width + space
    
    float currentOffset = scrollView.contentOffset.x;
    float targetOffset = targetContentOffset->x;
    float newTargetOffset = 0;
    
    if (targetOffset > currentOffset)
        newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
    else
        newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
    
    if (newTargetOffset < 0)
        newTargetOffset = 0;
    else if (newTargetOffset > scrollView.contentSize.width)
        newTargetOffset = scrollView.contentSize.width;
    
    targetContentOffset->x = currentOffset;
    [scrollView setContentOffset:CGPointMake(newTargetOffset, 0) animated:YES];
    
    int index = newTargetOffset / pageWidth;
    
    if (index == 0) { // If first index
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index  inSection:0]];
        
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{
            cell.transform = CGAffineTransformIdentity;
        }];
        cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index + 1  inSection:0]];
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{
            cell.transform = TRANSFORM_CELL_VALUE;
        }];
    }else{
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{
            cell.transform = CGAffineTransformIdentity;
        }];
        
        index --; // left
        cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{
            cell.transform = TRANSFORM_CELL_VALUE;
        }];
        if(index == temp_arr.count)
        {
            
            
            [UIView animateWithDuration:ANIMATION_SPEED animations:^{
                cell.transform = CGAffineTransformIdentity;
            }];
            cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index - 1  inSection:0]];
            [UIView animateWithDuration:ANIMATION_SPEED animations:^{
                cell.transform = TRANSFORM_CELL_VALUE;
            }];
            
        }

        
        index ++;
        index ++; // right
        cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        if(index == temp_arr.count)
        {
           
            
            [UIView animateWithDuration:ANIMATION_SPEED animations:^{
                cell.transform = CGAffineTransformIdentity;
            }];
            cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0  inSection:0]];
            [UIView animateWithDuration:ANIMATION_SPEED animations:^{
                cell.transform = TRANSFORM_CELL_VALUE;
            }];

        }
        [UIView animateWithDuration:ANIMATION_SPEED animations:^{
            cell.transform = TRANSFORM_CELL_VALUE;
        }];
    }
}



#pragma button_actions
-(void)stat_chenged

{
    if(j == 1)
    {
        j =0;
        [self.TBL_orders reloadData];
    }
    else if(j == 0)
    {
        j = 1;
        [self.TBL_orders reloadData];
    }

    
   
}
-(void)BTN_edit_clickd
{
    i = 2;
    [self.TBL_address reloadData];
}
-(void)BTN_check_clickd
{
    if(j == 1)
    {
        j =0;
         [self.TBL_address reloadData];
    }
    else if(j == 0)
    {
        j = 1;
    [self.TBL_address reloadData];
    }
}
-(void)calendar_action
{
    VW_overlay.hidden = NO;
    _BTN_done.layer.cornerRadius = 2.0f;
    _BTN_done.layer.masksToBounds = YES;
    _VW_delivery_slot.center = self.view.center;
    _VW_delivery_slot.layer.cornerRadius = 2.0f;
    _VW_delivery_slot.layer.masksToBounds = YES;
    [self.view addSubview:_VW_delivery_slot];
    
}
-(void)deliveryslot_action
{
    VW_overlay.hidden = YES;
    _VW_delivery_slot.hidden = YES;
}
-(void)next_page
{
    
   
    
    if([_LBL_navigation.title isEqualToString:@"ORDER DETAILS"])
    {
        
        if(_VW_summary.hidden == NO)
        {
            VW_overlay.hidden = NO;
            _VW_summary.hidden = NO;
        }
        else
        {
            
            _TBL_orders.hidden = YES;
            _LBL_navigation.title = @"SHIPPING";
            _TBL_address.estimatedRowHeight = 4.0;
            _TBL_address.rowHeight = UITableViewAutomaticDimension;
            
            
            [self.TBL_address reloadData];
            _TBL_address.hidden = NO;
            
            //[_TBL_orders removeFromSuperview];
            CGRect frame_set = _VW_shipping.frame;
            frame_set.origin.y = _VW_top.frame.origin.y + _VW_top.frame.size.height;
            frame_set.size.width = _TBL_orders.frame.size.width;
            frame_set.size.height = _VW_next.frame.origin.y - _TBL_orders.frame.origin.y;
            _VW_shipping.frame = frame_set;
            [self.view addSubview:_VW_shipping];
            _TXT_first.backgroundColor = _LBL_order_detail.backgroundColor;

        
        
        }

    }
    else  if([_LBL_navigation.title isEqualToString:@"SHIPPING"])
    {
        
        if(_VW_summary.hidden == NO)
        {
            VW_overlay.hidden = NO;
            _VW_summary.hidden = NO;
            
        }
        else
        {
          _TBL_address.hidden = YES;
        _LBL_navigation.title = @"PAYMENT";
       
       
        
      
      //  [_Collection_cards reloadData];
        //[_TBL_orders removeFromSuperview];
        CGRect frame_set = _VW_payment.frame;
        frame_set.origin.y = _VW_top.frame.origin.y + _VW_top.frame.size.height;
        frame_set.size.width = _TBL_orders.frame.size.width;
        frame_set.size.height = _VW_next.frame.origin.y - _TBL_orders.frame.origin.y;
        _VW_payment.frame = frame_set;
        [self.view addSubview:_VW_payment];
        _LBL_shipping.backgroundColor = _LBL_order_detail.backgroundColor;
         _TXT_second.backgroundColor = _LBL_order_detail.backgroundColor;
        }
    }
   
    
   
}
-(void)product_clicked
{
   if([_LBL_navigation.title isEqualToString:@"ORDER DETAILS"])
   {
       [self.view addSubview:VW_overlay];
        [self sumary_VIEW];
   }
    
   else if([_LBL_navigation.title isEqualToString:@"SHIPPING"])
    {
        [self.view addSubview:VW_overlay];
        [self sumary_VIEW];
        
    }
    else if([_LBL_navigation.title isEqualToString:@"PAYMENT"])
    {
        [self.view addSubview:VW_overlay];
        [self sumary_VIEW];
        
    }

    
    
    
}
-(void)sumary_VIEW
{
    if([_LBL_arrow.text isEqualToString:@""])
    {
        _LBL_arrow.text = @"";
        VW_overlay.hidden = NO;
        _VW_summary.hidden = NO;
        
        //_LBL_arrow.text = @"";
    }
    else
    {
        _LBL_arrow.text =@"";
        VW_overlay.hidden = YES;
        _VW_summary.hidden =  YES;
        
    }

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
-(void)btnfav_action
{
    NSLog(@"fav_clicked");
}
-(void)btn_cart_action
{
    NSLog(@"cart_clicked");
}
-(void)tapGesture_close
{
    // [self dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"the cancel clicked");
}
-(void)minus_action
{
    int s = [TXT_count intValue];
    s = s - 1;
    TXT_count = [NSString stringWithFormat:@"%d",s];
}
-(void)plus_action
{
    int s = [TXT_count intValue];
    s = s + 1;
    TXT_count = [NSString stringWithFormat:@"%d",s];
}
- (IBAction)back_action_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
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

- (IBAction)order_to_cartPage:(id)sender {
    [self performSegueWithIdentifier:@"order_to_cart" sender:self];
}

- (IBAction)order_to_wishListPage:(id)sender {
    [self performSegueWithIdentifier:@"order_to_wish" sender:self];
}
@end
