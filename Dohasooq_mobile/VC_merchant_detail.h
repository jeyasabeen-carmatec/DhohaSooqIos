//
//  VC_merchant_detail.h
//  Dohasooq_mobile
//
//  Created by Test User on 21/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VC_merchant_detail : UIViewController
@property(nonatomic,weak) IBOutlet UIScrollView *scroll_contets;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_first;
@property(nonatomic,weak) IBOutlet UIView *VW_first;
@property(nonatomic,weak) IBOutlet UILabel *LBL_name;
@property(nonatomic,weak) IBOutlet UILabel *LBL_address;
@property(nonatomic,weak) IBOutlet UILabel *LBL_phone_mail;
@property(nonatomic,weak) IBOutlet UIView *VW_second;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_items;




@end
