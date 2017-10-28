//
//  VC_home.m
//  Dohasooq_mobile
//
//  Created by Test User on 23/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_home.h"
#import "collection_img_cell.h"
#import "hot_deals_cell.h"
#import "Best_deals_cell.h"
#import "Fashion_categorie_cell.h"
#import "UIBarButtonItem+Badge.h"
#import "cell_features.h"
#import "cell_brands.h"
#import "categorie_cell.h"
#import "dynamic_categirie_cell.h"

@interface VC_home ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *temp_arr,*temp_hot_deals,*fashion_categirie_arr,*brands_arr,*ARR_category,*lang_arr;
    NSIndexPath *INDX_selected;
    NSInteger i,lang_count;
    int tag;
    
}
//@property(nonatomic, readonly) NSArray<__kindof UICollectionViewCell *> *visibleCells;
@property(nonatomic,strong) UIView *overlayView;

@end

@implementation VC_home

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _Scroll_contents.delegate =self;
    [self set_up_VIEW];
    
   
        [self.collection_images registerNib:[UINib nibWithNibName:@"cell_image" bundle:nil]  forCellWithReuseIdentifier:@"collection_image"];
        [self.collection_features registerNib:[UINib nibWithNibName:@"cell_features" bundle:nil]  forCellWithReuseIdentifier:@"features_cell"];
//         [self.collection_brands registerNib:[UINib nibWithNibName:@"cell_brands" bundle:nil]  forCellWithReuseIdentifier:@"brands_cell"];
        [self.collection_hot_deals registerNib:[UINib nibWithNibName:@"hot_deals_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_hot_deals"];
         [self.collection_best_deals registerNib:[UINib nibWithNibName:@"Best_deals_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_best"];
      [self.collection_fashion_categirie registerNib:[UINib nibWithNibName:@"Fashion_categorie_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_fashion"];

        
    
    [self menu_set_UP];

}

-(void)menu_set_UP
{
    [self.TBL_menu reloadData];
   
 
    int statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
    statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
    _menuDraw_width = [UIApplication sharedApplication].statusBarFrame.size.width * 0.80;
    _menyDraw_X = self.navigationController.view.frame.size.width; //- menuDraw_width;
    _VW_swipe.frame = CGRectMake(0, self.view.frame.origin.y, _menuDraw_width, self.navigationController.view.frame.size.height - self.navigationController.navigationBar.frame.size.height);
    
    _overlayView = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
    _overlayView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [self.navigationController.view addSubview:_overlayView];
    [_overlayView addSubview:_VW_swipe];
    
    _IMG_profile.layer.cornerRadius = _IMG_profile.frame.size.width / 2;
    _IMG_profile.layer.masksToBounds = YES;
    _IMG_profile.layer.borderWidth = 2.0f;
    _IMG_profile.layer.borderColor = [UIColor blackColor].CGColor;
    
    [_LBL_profile sizeToFit];
    CGRect frameset = _BTN_myorder.frame;
    frameset.size.width = (_VW_swipe.frame.size.width/3) - 2;
    _BTN_myorder.frame = frameset;
    
    frameset = _BTN_wishlist.frame;
    frameset.origin.x = _BTN_myorder.frame.origin.x + _BTN_myorder.frame.size.width + 1;
    frameset.size.width = (_VW_swipe.frame.size.width/3);
    _BTN_wishlist.frame = frameset;
    
    frameset = _BTN_address.frame;
    frameset.origin.x = _BTN_wishlist.frame.origin.x + _BTN_wishlist.frame.size.width + 1;
    frameset.size.width = (_VW_swipe.frame.size.width/3) - 1;
    _BTN_address.frame = frameset;
    
    
    frameset=_LBL_order_icon.frame;
    frameset.origin.y = _BTN_myorder.frame.origin.y + _LBL_order_icon.frame.size.height;
    frameset.size.width = _BTN_myorder.frame.size.width;
    _LBL_order_icon.frame = frameset;
    
    frameset = _LBL_order.frame;
    frameset.origin.y = _LBL_order_icon.frame.origin.y + _LBL_order_icon.frame.size.height;
     frameset.size.width = _BTN_myorder.frame.size.width;
    _LBL_order.frame = frameset;
    
    
    frameset=_LBL_wish_list_icon.frame;
    frameset.origin.x = _BTN_wishlist.frame.origin.x;
    frameset.origin.y = _BTN_wishlist.frame.origin.y + _LBL_wish_list_icon.frame.size.height;
    frameset.size.width = _BTN_wishlist.frame.size.width;
    _LBL_wish_list_icon.frame = frameset;
    
    frameset = _LBL_wish_list.frame;
    frameset.origin.x = _BTN_wishlist.frame.origin.x;
    frameset.origin.y = _LBL_wish_list_icon.frame.origin.y + _LBL_wish_list_icon.frame.size.height;
    frameset.size.width = _BTN_wishlist.frame.size.width;
    _LBL_wish_list.frame = frameset;
    
    
    frameset=_LBL_address_icon.frame;
    frameset.origin.x = _BTN_address.frame.origin.x;
    frameset.origin.y = _BTN_address.frame.origin.y + _LBL_address_icon.frame.size.height;
    frameset.size.width = _BTN_address.frame.size.width;
    _LBL_address_icon.frame = frameset;
    
    frameset = _LBL_address.frame;
    frameset.origin.x = _BTN_address.frame.origin.x;
    frameset.origin.y = _LBL_address_icon.frame.origin.y + _LBL_address_icon.frame.size.height;
    frameset.size.width = _BTN_address.frame.size.width;
    _LBL_address.frame = frameset;
    
//    frameset = _VW_swipe.frame;
//    frameset.size.height =  self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height;
//    _VW_swipe.frame = frameset;

    _overlayView.hidden = YES;
    NSMutableArray *arr_tmp = [[NSMutableArray alloc] init];
    [arr_tmp addObject:@{@"Name":@"Item 0",@"level":@"0"}];
    NSMutableArray *arr_MUT = [[NSMutableArray alloc]init];
    NSMutableArray *test_ARR =  [[NSMutableArray alloc]init];
    [test_ARR addObject:@{@"Name":@"SubItem 1",@"level":@"2"}];
    [arr_MUT addObject:@{@"Name":@"SubItem 0",@"SubItems":test_ARR,@"level":@"1"}];
    [arr_MUT addObject:@{@"Name":@"SubItem 1",@"level":@"1"}];
    [arr_tmp addObject:@{@"Name":@"Item 1",@"SubItems":arr_MUT,@"level":@"0"}];
    
    arr_MUT = [[NSMutableArray alloc]init];
    [arr_MUT addObject:@{@"Name":@"SubItem 1",@"level":@"1"}];
    [arr_MUT addObject:@{@"Name":@"SubItem 2",@"level":@"1"}];
    [arr_tmp addObject:@{@"Name":@"Item 2",@"SubItems":arr_MUT,@"level":@"0"}];
    
    [arr_tmp addObject:@{@"Name":@"Item 3",@"level":@"0"}];
    [arr_tmp addObject:@{@"Name":@"Item 4",@"level":@"0"}];
    [arr_tmp addObject:@{@"Name":@"Item 5",@"level":@"0"}];
    [arr_tmp addObject:@{@"Name":@"Item 6",@"level":@"0"}];
    [arr_tmp addObject:@{@"Name":@"Item 7",@"level":@"0"}];
    [arr_tmp addObject:@{@"Name":@"Item 8",@"level":@"0"}];
    
    
    NSDictionary *temp = @{@"Items":arr_tmp};
   
    self.items=[temp valueForKey:@"Items"];
    ARR_category = [[NSMutableArray alloc]init];
     [ARR_category addObjectsFromArray:self.items];


      i = ARR_category.count;
   
    lang_arr = [[NSMutableArray alloc]init];
    lang_arr = [NSMutableArray arrayWithObjects:@"ENGLISH", nil];
     lang_count = lang_arr.count;
    UISwipeGestureRecognizer *SwipeLEFT = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeLeft:)];
    SwipeLEFT.direction = UISwipeGestureRecognizerDirectionLeft;
        [_overlayView addGestureRecognizer:SwipeLEFT];
    
    UISwipeGestureRecognizer *SwipeRIGHT = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRight:)];
    SwipeRIGHT.direction = UISwipeGestureRecognizerDirectionRight;
    //    [self.view addGestureRecognizer:SwipeRIGHT];
    [_overlayView addGestureRecognizer:SwipeRIGHT];

}

-(void)set_up_VIEW
{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
       } forState:UIControlStateNormal];
    
//        _BTN_fav  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain  target:self action:
//                    @selector(btnfav_action)];

    _LBL_best_selling.text = @"BEST SELLING\nPRODUCTS";
    _LBL_fashio.text = @"FASHION\nACCSESORIES";

    
    NSString *badge_value = @"25";
    _BTN_cart.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
    if(badge_value.length > 2)
    {
        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
        
    }
    else{
        self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
        
    }
    brands_arr = [[NSMutableArray alloc]init];
    brands_arr = [NSMutableArray arrayWithObjects:@"brand.png",@"brand.png",@"brand.png",@"brand.png",@"brand.png",@"brand.png",@"brand.png",@"brand.png",nil];

    temp_arr = [[NSMutableArray alloc]init];
    temp_arr = [NSMutableArray arrayWithObjects:@"featured_banner.jpg",@"banner.jpg",@"featured_banner.jpg",@"banner.jpg",nil];
    
    temp_hot_deals = [[NSMutableArray alloc]init];
    fashion_categirie_arr = [[NSMutableArray alloc]init];
    NSDictionary *fashion_dict;
    fashion_dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"70% off",@"key2",@"shop now",@"key3",@"upload-2.png",@"key5",nil];
    [fashion_categirie_arr addObject:fashion_dict];
    fashion_dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"70% off",@"key2",@"shop now",@"key3",@"upload-2.png",@"key5",nil];
    [fashion_categirie_arr addObject:fashion_dict];
    fashion_dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"70% off",@"key2",@"shop now",@"key3",@"upload-2.png",@"key5",nil];
    [fashion_categirie_arr addObject:fashion_dict];
    fashion_dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"70% off",@"key2",@"shop now",@"key3",@"upload-2.png",@"key5",nil];
    [fashion_categirie_arr addObject:fashion_dict];
    
    NSDictionary *temp_dictin;
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR 799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [temp_hot_deals addObject:temp_dictin];
   temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR 799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [temp_hot_deals addObject:temp_dictin];
   temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR 799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
    [temp_hot_deals addObject:temp_dictin];
    temp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Shining Diva Fashion",@"key1",@"QR 499",@"key2",@"QR 799",@"key3",@"35% off",@"key4",@"upload-2.png",@"key5",nil];
     [temp_hot_deals addObject:temp_dictin];
    
    
    CGRect setupframe = _VW_First.frame;
    //setupframe.origin.y =  _VW_nav.frame.size.height;
    setupframe.size.width = _Scroll_contents.frame.size.width;
    _VW_First.frame = setupframe;
    [self.Scroll_contents addSubview:_VW_First];
    
    setupframe = _VW_second.frame;
    setupframe.origin.y = _VW_First.frame.origin.y + _VW_First.frame.size.height;
    setupframe.size.height = _collection_hot_deals.frame.origin.y + _collection_hot_deals.frame.size.height + 10;
    setupframe.size.width = _Scroll_contents.frame.size.width;
    _VW_second.frame = setupframe;
    [self.Scroll_contents addSubview:_VW_second];
    
    setupframe = _VW_third.frame;
    setupframe.origin.y = _VW_second.frame.origin.y + _VW_second.frame.size.height;
    setupframe.size.height = _collection_best_deals.frame.origin.y + _collection_best_deals.frame.size.height +10;
    setupframe.size.width = _Scroll_contents.frame.size.width;
    _VW_third.frame = setupframe;
    [self.Scroll_contents addSubview:_VW_third];
    
    setupframe = _VW_Fourth.frame;
    setupframe.origin.y = _VW_third.frame.origin.y + _VW_third.frame.size.height;
    setupframe.size.height = _collection_fashion_categirie.frame.origin.y + _collection_fashion_categirie.frame.size.height + 10;
    setupframe.size.width = _Scroll_contents.frame.size.width;
    _VW_Fourth.frame = setupframe;
    [self.Scroll_contents addSubview:_VW_Fourth];

    self.search_bar.layer.borderWidth = 0.3f;
    self.search_bar.layer.masksToBounds = [UIColor blackColor];
    self.custom_story_page_controller.numberOfPages=[temp_arr count];
    _BTN_left.layer.cornerRadius = _BTN_left.frame.size.width/2;
    _BTN_left.layer.masksToBounds = YES;
    _BTN_right.layer.cornerRadius = _BTN_right.frame.size.width/2;
    _BTN_right.layer.masksToBounds = YES;
    
    [_BTN_right addTarget:self action:@selector(BTN_right_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_left addTarget:self action:@selector(BTN_left_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_menu addTarget:self action:@selector(MENU_action) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_contents layoutIfNeeded];
    _Scroll_contents.contentSize = CGSizeMake(_Scroll_contents.frame.size.width,_VW_Fourth.frame.origin.y+ _VW_Fourth.frame.size.height );
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == _collection_images)
    {
    return temp_arr.count;
    }
    else if(collectionView == _collection_features)
    {
    return temp_arr.count;

    }
    else if(collectionView == _collection_hot_deals )
    {
        return temp_hot_deals.count;

    }
    else if( collectionView == _collection_best_deals)
    {
         return temp_hot_deals.count;
    }
    else if( collectionView == _collection_brands)
    {
        return brands_arr.count;
    }

    else if(collectionView == _collection_fashion_categirie)
    {
         return fashion_categirie_arr.count;
    }

    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(collectionView == _collection_images)
    {
    collection_img_cell *img_cell = (collection_img_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_image" forIndexPath:indexPath];
    img_cell.img.image = [UIImage imageNamed:[temp_arr objectAtIndex:indexPath.row]];
    return img_cell;
    }
    
    else if(collectionView == _collection_hot_deals)
    {
        hot_deals_cell *hotdeals_cell = (hot_deals_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_hot_deals" forIndexPath:indexPath];

        NSMutableDictionary *temp_dict = [[NSMutableDictionary alloc]init];
        temp_dict = [temp_hot_deals objectAtIndex:indexPath.row];
        hotdeals_cell.IMG_item.image = [UIImage imageNamed:[temp_dict valueForKey:@"key5"]];
        hotdeals_cell.LBL_item_name.text = [temp_dict valueForKey:@"key1"];
       
        
        NSString *current_price = [NSString stringWithFormat:@"%@", [temp_dict valueForKey:@"key2"]];
        NSString *prec_price = [NSString stringWithFormat:@"%@", [temp_dict valueForKey:@"key3"]];
        NSString *text = [NSString stringWithFormat:@"%@ %@",current_price,prec_price];
        
        if ([hotdeals_cell.LBL_price respondsToSelector:@selector(setAttributedText:)]) {
            
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:hotdeals_cell.LBL_price.textColor,
                                      NSFontAttributeName:hotdeals_cell.LBL_price.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
            
            
            
            NSRange ename = [text rangeOfString:current_price];
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                        range:ename];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:16.0]}
                                        range:ename];
            }
            NSRange cmp = [text rangeOfString:prec_price];
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:21.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                        range:cmp];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:13.0],NSForegroundColorAttributeName:[UIColor grayColor],}
                                        range:cmp ];
            }
            hotdeals_cell.LBL_price.attributedText = attributedText;
        }
        else
        {
            hotdeals_cell.LBL_price.text = text;
        }

        hotdeals_cell.LBL_discount.text = [temp_dict valueForKey:@"key4"];
        return hotdeals_cell;
    }
    else if(collectionView == _collection_best_deals)
    {
        Best_deals_cell *bestdeals_cell = (Best_deals_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_best" forIndexPath:indexPath];
        
        NSMutableDictionary *temp_dict = [[NSMutableDictionary alloc]init];
        temp_dict = [temp_hot_deals objectAtIndex:indexPath.row];
        bestdeals_cell.IMG_item.image = [UIImage imageNamed:[temp_dict valueForKey:@"key5"]];
        bestdeals_cell.LBL_best_item_name.text = [temp_dict valueForKey:@"key1"];
        NSString *current_price = [NSString stringWithFormat:@"%@", [temp_dict valueForKey:@"key2"]];
        NSString *prec_price = [NSString stringWithFormat:@"%@", [temp_dict valueForKey:@"key3"]];
        NSString *text = [NSString stringWithFormat:@"%@ %@",current_price,prec_price];
        
        if ([bestdeals_cell.LBL_best_price respondsToSelector:@selector(setAttributedText:)]) {
            
            // Define general attributes for the entire text
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:bestdeals_cell.LBL_best_price.textColor,
                                      NSFontAttributeName:bestdeals_cell.LBL_best_price.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
            
            
            
            NSRange ename = [text rangeOfString:current_price];
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                        range:ename];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:16.0]}
                                        range:ename];
            }
            NSRange cmp = [text rangeOfString:prec_price];
            
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:21.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                        range:cmp];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:13.0],NSForegroundColorAttributeName:[UIColor grayColor],}
                                        range:cmp ];
            }
            bestdeals_cell.LBL_best_price.attributedText = attributedText;
        }
        else
        {
            bestdeals_cell.LBL_best_price.text = text;
        }

        
        bestdeals_cell.LBL_best_discount.text = [temp_dict valueForKey:@"key4"];
        return bestdeals_cell;

    }
    
    else if(collectionView == _collection_features)
    {
        cell_features *cell = (cell_features *)[collectionView dequeueReusableCellWithReuseIdentifier:@"features_cell" forIndexPath:indexPath];
        cell.img.image = [UIImage imageNamed:[temp_arr objectAtIndex:indexPath.row]];
        return cell;

        
    }
    else if(collectionView == _collection_brands)
    {
        cell_brands *cell = (cell_brands *)[collectionView dequeueReusableCellWithReuseIdentifier:@"brands_cell" forIndexPath:indexPath];
       
        cell.img.image = [UIImage imageNamed:[brands_arr objectAtIndex:indexPath.row]];
        cell.img.layer.cornerRadius = 2.0f;
        cell.img.layer.masksToBounds = YES;
        return cell;
        
        
    }
    else if(collectionView == _collection_fashion_categirie)
    {
        Fashion_categorie_cell *fashion_cell = (Fashion_categorie_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_fashion" forIndexPath:indexPath];
        
        NSMutableDictionary *temp_dict = [[NSMutableDictionary alloc]init];
        temp_dict = [fashion_categirie_arr objectAtIndex:indexPath.row];
        fashion_cell.IMG_item.image = [UIImage imageNamed:[temp_dict valueForKey:@"key5"]];
        fashion_cell.LBL_best_item_name.text = [temp_dict valueForKey:@"key1"];
        
        
        NSString *str = @"Flat";
        NSString  *discount = [temp_dict valueForKey:@"key2"];
        NSString *text = [NSString stringWithFormat:@"%@ %@",str,discount];

        
        if ([fashion_cell.LBL_best_price respondsToSelector:@selector(setAttributedText:)]) {
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:fashion_cell.LBL_best_price.textColor,
                                      NSFontAttributeName: fashion_cell.LBL_best_price.font
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
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0]}
                                        range:ename];
            }
            
            
            
            
            NSRange cmp = [text rangeOfString:discount];
            //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:21.0]}
                                        range:cmp];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:18.0]}
                                        range:cmp];
            }
             fashion_cell.LBL_best_price.attributedText = attributedText;
        }
        else
        {
             fashion_cell.LBL_best_price.text = text;
        }
          fashion_cell.LBL_best_discount.text = [temp_dict valueForKey:@"key3"];

        
              return fashion_cell;

        
    }
    return 0;

    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _collection_images)
    {
    
    return CGSizeMake(_collection_images.frame.size.width ,_collection_images.frame.size.height);
    }
    else if( collectionView == _collection_features)
    {
        return CGSizeMake(_collection_features.frame.size.width ,_collection_features.frame.size.height);

    }
    else if(collectionView == _collection_best_deals)
    {
        return CGSizeMake(_collection_best_deals.frame.size.width/2.02, 240);

    }
    else if(collectionView == _collection_hot_deals)
    {
        return CGSizeMake(self.collection_hot_deals.frame.size.width/2.02, 240);
        
    }
    else if( collectionView == _collection_brands)
    {
        return CGSizeMake(_collection_features.frame.size.width/3 ,_collection_features.frame.size.height);
        
    }
   else
    {
       return CGSizeMake(self.collection_hot_deals.frame.size.width/2.02, 240);
        
    }


}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    int ht = 0;
    if(collectionView == _collection_hot_deals)
    {
        ht = 2;
    }
    
    if(collectionView == _collection_best_deals)
    {
       ht = 2;
    }
   
    return ht;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    int ht = 0;
    if(collectionView == _collection_hot_deals)
    {
        ht = 3.5;
    }
    
    if(collectionView == _collection_best_deals)
    {
        ht = 3.5;
    }
    if(collectionView == _collection_fashion_categirie)
    {
        ht = 3.5;
    }
    return ht;

}

//- (UIEdgeInsets)collectionView:
//(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    // return UIEdgeInsetsMake(0,8,0,8);
//    // top, left, bottom, right
//    if(collectionView == _collection_best_deals)
//    {
//          return UIEdgeInsetsMake(0,0,0,0);
//    }
//   else if(collectionView == _collection_hot_deals)
//    {
//        return UIEdgeInsetsMake(0,0,0,0);
//    }
//    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
//}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _collection_hot_deals)
    {
    [self performSegueWithIdentifier:@"homw_product_list" sender:self];
    }
}
#pragma Tableview delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger ceel_count = 0;
    if(section == 0)
    {
        ceel_count = ARR_category.count;
    }
    if(section == 1)
    {
        ceel_count = 2;
    }
    if(section == 2)
    {
        ceel_count = 1;
    }
    if(section == 3)
   {
       ceel_count = lang_arr.count;
   }
    if(section == 4)
   {
       ceel_count = 5;
   }
   
  return ceel_count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    categorie_cell *cell = (categorie_cell *)[tableView dequeueReusableCellWithIdentifier:@"cate_cell"];
    
   
    if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"categorie_cell" owner:self options:nil];
        cell = [nib objectAtIndex:1];
    }
    cell.LBL_arrow.hidden = YES;
  
    if(indexPath.section == 0)
    {
//        cell.LBL_name.text = [ARR_category objectAtIndex:indexPath.row];
//        if([cell.LBL_name.text isEqualToString:@"MORE"])
//        {
//            cell.LBL_arrow.hidden = NO;
//            tag = 0;
//            if(i < ARR_category.count)
//            {
//                cell.LBL_arrow.text = @"";
//                tag = 1;
//            }
//            
//        }
        NSString *Title= [[ARR_category objectAtIndex:indexPath.row] valueForKey:@"Name"];
        
        return [self createCellWithTitle:Title image:[[ARR_category objectAtIndex:indexPath.row] valueForKey:@"Image name"] indexPath:indexPath];

        
    }
    if(indexPath.section == 1)
    {
        NSArray *ARR_info = [NSArray arrayWithObjects:@"MY PROFILE",@"CHANGE PASSWORD", nil];
        cell.LBL_name.text = [ARR_info objectAtIndex:indexPath.row];
    }
    if(indexPath.section == 2)
    {
        cell.LBL_name.text = @"MERCHANT LIST";
    }
    if(indexPath.section == 3)
    {
        cell.LBL_name.text = [lang_arr objectAtIndex:indexPath.row];

        if(indexPath.row == 0)
        {
            cell.LBL_arrow.hidden = NO;
            tag = 0;
            if(lang_count < lang_arr.count)
            {
                cell.LBL_arrow.text = @"";
                tag = 1;
            }
        }
    
    }
    if(indexPath.section == 4)
    {
        
    NSArray *ARR_info = [NSArray arrayWithObjects:@"ABOUT US",@"CONTACT US",@"TERMS AND CONDITIONS",@"PRIVACY POLACY",@"HELP DESK", nil];
        cell.LBL_name.text = [ARR_info objectAtIndex:indexPath.row];
    }
    
    

    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str;
    if(section == 0)
    {
        str =@"ALL CATEGORIES";
    }
    if(section == 1)
    {
        str = @"ACCOUNT INFO";
    }
    if(section == 2)
    {
        str = @"MERCHANT LIST";
    }
    if(section == 3)
    {
        str = @"LANGUAGE";
    }
    if(section == 4)
    {
        str = @"QUICK LINKS";
    }
    
    return  str;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
////    UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
////    [header setBackgroundColor:[UIColor whiteColor]];
////    UILabel  *LBL_title = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 320, 40)];
////    LBL_title.font = [UIFont fontWithName:@"Poppins-Medium" size:17];
////    LBL_title.textColor = [UIColor darkGrayColor];
//    NSString *str;
//    if(section == 0)
//    {
//        str =@"ALL CATEGORIES";
//    }
//    if(section == 1)
//    {
//        str = @"ACCOUNT INFO";
//    }
//    if(section == 2)
//    {
//        str = @"MERCHANT LIST";
//    }
//    if(section == 3)
//    {
//        str = @"LANGUAGE";
//    }
//    if(section == 4)
//    {
//        str = @"QUICK LINKS";
//    }
//    
//   str;
//   // [header addSubview:LBL_title];
//    return header;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch (indexPath.section)
    {
        case 0:
            if(indexPath.row)
            {
            NSMutableDictionary *dic=[ARR_category objectAtIndex:indexPath.row];
            
            NSLog(@"Selected dict = %@",dic);
            
            if([dic valueForKey:@"SubItems"])
            {
                NSArray *arr=[dic valueForKey:@"SubItems"];
                BOOL isTableExpanded=NO;
                
                for(NSDictionary *subitems in arr )
                {
                    NSInteger index=[ARR_category indexOfObjectIdenticalTo:subitems];
                    isTableExpanded=(index>0 && index!=NSIntegerMax);
                    if(isTableExpanded) break;
                }
                
                if(isTableExpanded)
                {
                    [self CollapseRows:arr];
                }
                else
                {
                    NSUInteger count=indexPath.row+1;
                    NSMutableArray *arrCells=[NSMutableArray array];
                    for(NSDictionary *dInner in arr )
                    {
                        [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                        [ARR_category insertObject:dInner atIndex:count++];
                        
                        NSLog(@"Inserted dictin %@",dInner);
                    }
                    [self.TBL_menu insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationLeft];
                }
            }
            }
            
//            if(indexPath.row == i - 1)
//            {
//                
//                NSMutableArray *s = [NSMutableArray arrayWithObjects:@"hsdf",@"dfghhy",@"hsdf",@"dfghhy",nil];
//                if(tag == 0)
//                {
//                    
//                    [ARR_category addObjectsFromArray:s];
//                    
//                    int sectionIndex = 0;
//                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:sectionIndex];
//                    [self tableView:_TBL_menu commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:iPath];
//                    [_TBL_menu reloadData];
//                }
//                else if(tag == 1)
//                {
//                    
//                    NSMutableArray *cellIndicesToBeDeleted = [[NSMutableArray alloc] init];
//                    long minVAL = indexPath.row;
//                    long maxVal = indexPath.row + [s count];
//                    
//                    [ARR_category removeObjectsInRange:NSMakeRange(minVAL+1, s.count)];
//                    for (long j =  minVAL; j < maxVal; j++) {
//                        NSIndexPath *p = [NSIndexPath indexPathForRow:j inSection:indexPath.section];
//                        if ([tableView cellForRowAtIndexPath:p])
//                        {
//                            [cellIndicesToBeDeleted addObject:p];
//                            
//                        }
//                    }
//                    [_TBL_menu reloadData];
//                    
//                }
            
           

            break;
          case 1:
            [self swipe_left];
            if(indexPath.row == 1)
            {
                [self performSegueWithIdentifier:@"login_forgot_pwd" sender:self];
            }
             break;
            case 2:
                [self swipe_left];
                [self performSegueWithIdentifier:@"merchant_segue" sender:self];
             break;
            case 3:
            if(indexPath.section == 3)
            {
                NSMutableArray *s = [NSMutableArray arrayWithObjects:@"HINDI",@"ARABIC",@"TELUGU",@"MALAYALA",nil];
                if(tag == 0)
                {
                    
                    [lang_arr addObjectsFromArray:s];
                    
                    int sectionIndex = 0;
                    NSIndexPath *iPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:sectionIndex];
                    [self tableView:_TBL_menu commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:iPath];
                    [_TBL_menu reloadData];
                }
                else if(tag == 1)
                {
                    
                    NSMutableArray *cellIndicesToBeDeleted = [[NSMutableArray alloc] init];
                    long minVAL = indexPath.row;
                    long maxVal = indexPath.row + [s count];
                    
                    [lang_arr removeObjectsInRange:NSMakeRange(minVAL+1, s.count)];
                    for (long j =  minVAL; j < maxVal; j++) {
                        NSIndexPath *p = [NSIndexPath indexPathForRow:j inSection:indexPath.section];
                        if ([tableView cellForRowAtIndexPath:p])
                        {
                            [cellIndicesToBeDeleted addObject:p];
                            
                        }
                    }
                    [_TBL_menu reloadData];
                    
                }
                
                
                
            }
             break;

            case 4:
            [self swipe_left];
            if(indexPath.row == 0)
            {
                NSLog(@"selected");
            }
            if(indexPath.row == 1)
            {
                [self performSegueWithIdentifier:@"contact_us_segue" sender:self];
            }
            if(indexPath.row == 2)
            {
                NSLog(@"selected");
            }
            if(indexPath.row == 3)
            {
                NSLog(@"selected");
            }
            if(indexPath.row == 4)
            {
                NSLog(@"selected");
            }
             break;
        default:
            break;
    }

    
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing == NO || !indexPath)
        return UITableViewCellEditingStyleNone;
    
    if (self.editing && indexPath.row == ([ARR_category count]))
        return UITableViewCellEditingStyleInsert;
    else
        if (self.editing && indexPath.row == ([ARR_category count]))
            return UITableViewCellEditingStyleDelete;
      
     return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
    }
    else if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    @try {
        
    
    NSString *cellIdentifier;
    for (UICollectionViewCell *cell in [scrollView subviews])
    {
        cellIdentifier = [cell reuseIdentifier];
    }
        if ([cellIdentifier isEqualToString:@"collection_image"]) {
            float pageWidth = _collection_images.frame.size.width; // width + space
            
            float currentOffset = _collection_images.contentOffset.x;
            float targetOffset = targetContentOffset->x;
            float newTargetOffset = 1;
            
            if (targetOffset > currentOffset)
                newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
            else
                newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
            
            if (newTargetOffset < 0)
                newTargetOffset = 0;
            else if (newTargetOffset > _collection_images.contentSize.width)
                newTargetOffset = _collection_images.contentSize.width;
            
            targetContentOffset->x = currentOffset;
            [_collection_images setContentOffset:CGPointMake(newTargetOffset  , _collection_images.contentOffset.y) animated:YES];
            //        CGRect visibleRect = (CGRect){.origin = self.collection_IMG.contentOffset, .size = self.collection_IMG.bounds.size};
            CGPoint visiblePoint = CGPointMake(newTargetOffset, _collection_images.contentOffset.y);
            NSIndexPath *visibleIndexPath = [self.collection_images indexPathForItemAtPoint:visiblePoint];
            
            self.custom_story_page_controller.currentPage = visibleIndexPath.row;
            
        }
            else if([cellIdentifier isEqualToString:@"features_cell"])
            {
            float pageWidth = _collection_features.frame.size.width; // width + space
            
            float currentOffset = _collection_features.contentOffset.x;
            float targetOffset = targetContentOffset->x;
            float newTargetOffset = 1;
            
            if (targetOffset > currentOffset)
                newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
            else
                newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
            
            if (newTargetOffset < 0)
                newTargetOffset = 0;
            else if (newTargetOffset > _collection_features.contentSize.width)
                newTargetOffset = _collection_features.contentSize.width;
            
            targetContentOffset->x = currentOffset;
            [_collection_features setContentOffset:CGPointMake(newTargetOffset  , _collection_features.contentOffset.y) animated:YES];
                
            CGPoint visiblePoint = CGPointMake(newTargetOffset, _collection_features.contentOffset.y);
            NSIndexPath *visibleIndexPath = [_collection_features indexPathForItemAtPoint:visiblePoint];
            
                INDX_selected = visibleIndexPath;
            //self.custom_story_page_controller.currentPage = visibleIndexPath.row;
            
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception:%@",exception);
      
    }
}
#pragma Buton action

- (IBAction)cart_action:(id)sender
{
    [self performSegueWithIdentifier:@"home_to_cart" sender:self];
}
- (IBAction)wish_list_Action:(id)sender
{
[self performSegueWithIdentifier:@"wishlist_segue" sender:self];

}

-(void)BTN_right_action
{
    
    NSIndexPath *newIndexPath;
    if (!INDX_selected)
    {
        newIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        INDX_selected = newIndexPath;
    }
    else if ([temp_arr count]  > INDX_selected.row)
    {
        if ([temp_arr count] == INDX_selected.row + 1) {
            newIndexPath = [NSIndexPath indexPathForRow:[temp_arr count] - 1 inSection:0];
            INDX_selected = newIndexPath;
        }
        else
        {
            newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row + 1 inSection:0];
            INDX_selected = newIndexPath;
        }
    }
    

    if (!newIndexPath) {
        newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        INDX_selected = newIndexPath;
    }
   
    
    [_collection_features scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:INDX_selected.row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
-(void)BTN_left_action
{
    @try
    {
    NSIndexPath *newIndexPath;
    if (INDX_selected)
    {
        newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row -1 inSection:0];
        INDX_selected = newIndexPath;
    }
    
    else if ([temp_arr count]  < INDX_selected.row)
    {
        if ([temp_arr count] == INDX_selected.row - 1)
        {
            newIndexPath = [NSIndexPath indexPathForRow:[temp_arr count] + 1 inSection:0];
            INDX_selected = newIndexPath;
        }
        else
        {
            newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row - 1 inSection:0];
            INDX_selected = newIndexPath;
        }
    }
    if (newIndexPath.row == 1)
    {
        newIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        INDX_selected = newIndexPath;
    }
    
     [_collection_features scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:INDX_selected.row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    

@catch (NSException *exception)
{
    NSLog(@"exception:%@",exception);
}

}
-(void)CollapseRows:(NSArray*)ar
{
    for(NSDictionary *dInner in ar )
    {
        NSUInteger indexToRemove=[ARR_category indexOfObjectIdenticalTo:dInner];
        NSArray *arInner=[dInner valueForKey:@"SubItems"];
        if(arInner && [arInner count]>0)
        {
            [self CollapseRows:arInner];
        }
        
        if([ARR_category indexOfObjectIdenticalTo:dInner]!=NSNotFound)
        {
            [ARR_category removeObjectIdenticalTo:dInner];
            [self.TBL_menu deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                        [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                        ]
                                      withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

- (UITableViewCell*)createCellWithTitle:(NSString *)title image:(UIImage *)image  indexPath:(NSIndexPath*)indexPath
{
    NSString *CellIdentifier = @"Cell";
    dynamic_categirie_cell* cell = [self.TBL_menu dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"categorie_cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = bgView;
    cell.LBL_name.text = title;
    cell.LBL_name.textColor = [UIColor blackColor];
    
    [cell setIndentationLevel:[[[ARR_category objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
    cell.indentationWidth = 25;
    
    float indentPoints = cell.indentationLevel * cell.indentationWidth;
    
    cell.contentView.frame = CGRectMake(indentPoints,cell.contentView.frame.origin.y,cell.contentView.frame.size.width - indentPoints,cell.contentView.frame.size.height);
    
    NSDictionary *d1=[ARR_category objectAtIndex:indexPath.row] ;
    
    if([d1 valueForKey:@"SubItems"])
    {
        cell.btnExpand.alpha = 1.0;
        [cell.btnExpand addTarget:self action:@selector(showSubItems:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        cell.btnExpand.alpha = 0.0;
    }
    return cell;
}

-(void)showSubItems :(id) sender
{
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.TBL_menu];
    NSIndexPath *indexPath = [self.TBL_menu  indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    
        if ([btn.titleLabel.text  isEqualToString:@""])
        {
          //  btn.titleLabel.text = @"";
            [btn setTitle:@"" forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitle:@"" forState:UIControlStateNormal];
            [btn.titleLabel setText:@""];
        }
        
    
    
    NSDictionary *d=[ARR_category objectAtIndex:indexPath.row] ;
    NSArray *arr=[d valueForKey:@"SubItems"];
    if([d valueForKey:@"SubItems"])
    {
        BOOL isTableExpanded=NO;
        for(NSDictionary *subitems in arr )
        {
            NSInteger index=[ARR_category indexOfObjectIdenticalTo:subitems];
            isTableExpanded=(index>0 && index!=NSIntegerMax);
            if(isTableExpanded) break;
        }
        
        if(isTableExpanded)
        {
            [self CollapseRows:arr];
        }
        else
        {
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arrCells=[NSMutableArray array];
            for(NSDictionary *dInner in arr )
            {
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [ARR_category insertObject:dInner atIndex:count++];
            }
            [self.TBL_menu insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
    
    
}


-(void)MENU_action
{
  
_overlayView.hidden = NO;
[UIView beginAnimations:nil context:nil];
[UIView setAnimationDelegate:self];
[UIView setAnimationDuration:-5];

CGFloat new_X = 0;
if (_VW_swipe.frame.origin.x == self.view.frame.origin.x)
{
    new_X = _VW_swipe.frame.origin.x;
}
else
{
    new_X = _VW_swipe.frame.origin.x - _menuDraw_width;
   
}
 _VW_swipe.frame = CGRectMake(0, self.navigationController.view.frame.origin.y, _menuDraw_width, self.navigationController.view.frame.size.height);
    [UIView commitAnimations];
}
- (void) SwipeLeft:(UISwipeGestureRecognizer *)sender
{
    
    [self swipe_left];
    
}
-(void)swipe_left
{
    
    if ( UISwipeGestureRecognizerDirectionLeft )
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:-5];
        
        int statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
        statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
        _VW_swipe.frame = CGRectMake(0, self.navigationController.view.frame.origin.y, _menuDraw_width, self.navigationController.view.frame.size.height);
        [UIView commitAnimations];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:-5];
        _overlayView.hidden = YES;
        [UIView commitAnimations];
        
    }

}
-(void)SwipeRight:(UISwipeGestureRecognizer *)sender
{
    if ( sender.direction | UISwipeGestureRecognizerDirectionRight )
    {
        _overlayView.hidden = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:-5];
        
        CGFloat new_X = 0;
        if (_VW_swipe.frame.origin.x == self.view.frame.origin.x)
        {
            new_X = _VW_swipe.frame.origin.x;
        }
        else
        {
            new_X = _VW_swipe.frame.origin.x - _menuDraw_width;
            
        }
        _VW_swipe.frame = CGRectMake(0, self.navigationController.view.frame.origin.y, _menuDraw_width, self.navigationController.view.frame.size.height);
        [UIView commitAnimations];
        
    }

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
