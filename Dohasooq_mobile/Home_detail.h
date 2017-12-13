//
//  Home_detail.h
//  Dohasooq_mobile
//
//  Created by Test User on 20/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "XMLDictionary.h"


@interface Home_detail : UIViewController
@property(nonatomic,weak)IBOutlet UIButton *Header_name;

@property(nonatomic,weak)IBOutlet UITabBar *Tab_MENU;
@property(nonatomic,weak) IBOutlet UIView *VW_filter;

//events tab
@property(nonatomic,weak) IBOutlet UITableView *TBL_event_list;
@property(nonatomic,weak) IBOutlet UIView *VW_event;
@property(nonatomic,weak) IBOutlet UITextField *BTN_venues;
@property (nonatomic, strong) UIPickerView *venue_picker;


//sports tab

@property(nonatomic,weak) IBOutlet UITableView *TBL_sports_list;
@property(nonatomic,weak) IBOutlet UIView *VW_sports;
@property(nonatomic,weak) IBOutlet UIView *VW_sports_filter;

@property(nonatomic,weak) IBOutlet UITextField *BTN_sports_venues;
@property (nonatomic, strong) UIPickerView *sports_venue_picker;


//Movies Tab
@property(nonatomic,weak) IBOutlet UICollectionView *Collection_movies;
@property(nonatomic,weak) IBOutlet UIView *VW_line;
@property(nonatomic,weak) IBOutlet UIView *VW_segment;
@property(nonatomic,weak) IBOutlet UIView *VW_Movies;
@property(nonatomic,weak) IBOutlet UITextField *BTN_all_lang;
@property(nonatomic,weak) IBOutlet UITextField *BTN_all_halls;
@property (nonatomic, strong) UIPickerView *lang_picker;
@property (nonatomic, strong) UIPickerView *halls_picker;


// Leisure Tab
@property(nonatomic,weak) IBOutlet UITableView *TBL_lisure_list;
@property(nonatomic,weak) IBOutlet UIView *VW_Leisure;
@property(nonatomic,weak) IBOutlet UITextField *BTN_leisure_venues;
@property (nonatomic, strong) UIPickerView *leisure_venues;
@property(nonatomic,weak) IBOutlet UIView *VW_leisure_filter;


@end
