//
//  Event_detail.h
//  Dohasooq_mobile
//
//  Created by Test User on 20/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Event_detail : UIViewController
@property(nonatomic,weak) IBOutlet UIScrollView *Scroll_contents;

//Event VIew
@property(nonatomic,weak) IBOutlet UIView *VW_event_dtl;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_back_ground;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_banner;


@property(nonatomic,weak) IBOutlet UIView *VW_event;
@property(nonatomic,weak) IBOutlet UILabel *LBL_event_name;
@property(nonatomic,weak) IBOutlet UILabel *LBL_event_address;
@property(nonatomic,weak) IBOutlet UILabel *LBL_event_date;
@property(nonatomic,weak) IBOutlet UILabel *LBL_event_time;

// Author View
@property(nonatomic,weak) IBOutlet UIView *VW_author;
@property(nonatomic,weak) IBOutlet UITextView *LBL_data;
@property(nonatomic,weak) IBOutlet UILabel *LBL_author;
@property(nonatomic,weak) IBOutlet UITextField *BTN_calneder;
@property (nonatomic, strong) UIPickerView *date_picker_view;




// Quantity VIEW
@property(nonatomic,weak) IBOutlet UIView *VW_Quantity;
@property(nonatomic,weak) IBOutlet UITableView *TBL_quantity;
@property(nonatomic,weak) IBOutlet UIButton *BTN_book;






@end
