//
//  VC_merchant_detail.m
//  Dohasooq_mobile
//
//  Created by Test User on 21/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_merchant_detail.h"
#import "merchnat_detail_cell.h"


@interface VC_merchant_detail ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation VC_merchant_detail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collection_items registerNib:[UINib nibWithNibName:@"merchnat_detail_cell" bundle:nil]  forCellWithReuseIdentifier:@"cell"];
    [self set_UP_VIEW];

}
-(void)set_UP_VIEW
{
    _LBL_name.numberOfLines = 0;
    [_LBL_name sizeToFit ];
    CGRect  frameset = _VW_first.frame;
        _VW_second.frame = frameset;

    
    _LBL_address.numberOfLines = 0;
    [_LBL_address sizeToFit];
    
    _LBL_phone_mail.numberOfLines = 0;
    [_LBL_phone_mail sizeToFit];
    
    _LBL_phone_mail.text = @"+ 974 2744\n+ 9742 2585\nansar@maill.com\nhttp:www.carmatec.com";
    
    frameset = _LBL_phone_mail.frame;
    frameset.origin.y = _LBL_address.frame.origin.y + _LBL_address.frame.size.height + 10;
    _LBL_phone_mail.frame = frameset;
    
  
    frameset = _VW_first.frame;
    frameset.origin.y = _IMG_first.frame.origin.y + _IMG_first.frame.size.height + 5;
    frameset.size.width = self.scroll_contets.frame.size.width;

    frameset.size.height = _LBL_phone_mail.frame.origin.y + _LBL_phone_mail.frame.size.height;
    _VW_first.frame = frameset;
    [self.scroll_contets addSubview:_VW_first];
    
    frameset = _VW_second.frame;
    frameset.origin.y = _VW_first.frame.origin.y + _VW_first.frame.size.height;
    frameset.size.height = _collection_items.frame.origin.y + _collection_items.frame.size.height;
    frameset.size.width = self.scroll_contets.frame.size.width;
    _VW_second.frame = frameset;
    [self.scroll_contets addSubview:_VW_second];
    
    
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_contets layoutIfNeeded];
    _scroll_contets.contentSize = CGSizeMake(_scroll_contets.frame.size.width,_VW_second.frame.origin.y + _VW_second.frame.size.height);
    
    
}
-(NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    merchnat_detail_cell *cell = (merchnat_detail_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    cell.LBL_item_name.text = @"GlAMROCK - 56805";
    NSString *current_price = @"QR 4879";
    NSString *prev_price = @"QR 5879";
    NSString *text = [NSString stringWithFormat:@"%@\n%@",current_price,prev_price];
    if ([cell.TXT_cost respondsToSelector:@selector(setAttributedText:)])
    {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    
    
    
    NSRange ename = [text rangeOfString:current_price];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                range:ename];
    }
    else
    {
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                range:ename];
    }
    NSRange cmp = [text rangeOfString:prev_price];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:15.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                range:cmp];
    }
    else
    {
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:13.0],NSForegroundColorAttributeName:[UIColor grayColor],}
                                range:cmp ];
    }
    @try {
        [attributedText addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(0, [prev_price length])];
    }
        @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
      cell.TXT_cost.attributedText = attributedText;
    }
    else{
        cell.TXT_cost.text = text;
    }

    
    
    cell.BTN_rate.layer.cornerRadius = 2.0f;
    cell.BTN_rate.layer.masksToBounds = YES;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.bounds.size.width/2.25, 290);
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
