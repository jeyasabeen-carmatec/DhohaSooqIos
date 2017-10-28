//
//  VC_Movie_booking.m
//  Dohasooq_mobile
//
//  Created by Test User on 23/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_Movie_booking.h"
#import "cell_timings.h"

@interface VC_Movie_booking ()<UITableViewDelegate,UITableViewDataSource,MZDayPickerDelegate, MZDayPickerDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *collection_count;
    CGRect oldframe;
    float scrollheight;
}
@property (nonatomic,strong) NSDateFormatter *dateFormatter;


@end

@implementation VC_Movie_booking

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self set_UP_VIEW];
    
}
-(void)set_UP_VIEW
{
    collection_count = [[NSMutableArray alloc]init];
    collection_count = [NSMutableArray arrayWithObjects:@"03.30",@"07.30", nil];
    
    _LBL_movie_description.numberOfLines = 3;
    
    CGRect frameset = _VW_dtl_movie.frame;
    frameset.size.width = self.Scroll_contents.frame.size.width;
    _VW_dtl_movie.frame = frameset;
    
    [self.Scroll_contents addSubview:_VW_dtl_movie];
    _LBL_movie_description.text = @"Private European Union based bodyguard Michael Bryce is hired to protect Takashi Kurosawa, a Japanese arms dealer. All apparently goes well, until Kurosawa is shot in the head through the airplane window. Two years later, Bryce has fallen into disgrace and ekes out a living protecting drug-addicted corporate executives in London";
    
    frameset = _VW_about_movie.frame;
    frameset.origin.y = _VW_dtl_movie.frame.origin.y + _VW_dtl_movie.frame.size.height;
    frameset.size.height = _BTN_view_more.frame.origin.y + _BTN_view_more.frame.size.height;
    frameset.size.width = self.Scroll_contents.frame.size.width;
    _VW_about_movie.frame = frameset;
    oldframe = _LBL_movie_description.frame;
    
    [self.Scroll_contents addSubview:_VW_about_movie];
    
    frameset = self.VW_timings.frame;
    frameset.origin.y = _VW_about_movie.frame.origin.y + _VW_about_movie.frame.size.height;
     frameset.size.width = self.Scroll_contents.frame.size.width;
    _VW_timings.frame = frameset;
    [self.Scroll_contents addSubview:_VW_timings];
    
    scrollheight = _VW_timings.frame.origin.y + _VW_timings.frame.size.height;
    
    NSString *str = @"HINDI";
    NSString *sub_str = @"2D";
    NSString *text = [NSString stringWithFormat:@"%@      %@",str,sub_str];
    
    
    if ([_LBL_language respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_language.textColor,
                                  NSFontAttributeName:_LBL_language.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
        
        
        NSRange ename = [text rangeOfString:sub_str];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.39 green:0.78 blue:0.05 alpha:1.0]}
                                    range:ename];
        }
       _LBL_language.attributedText = attributedText;
    }
    else
    {
        _LBL_language.text = text;
    }

    
    _BTN_trailer_watch.layer.cornerRadius = 1.0f;
    _BTN_trailer_watch.layer.masksToBounds = YES;
    [_BTN_view_more addTarget:self action:@selector(viewmore_selcted) forControlEvents:UIControlEventTouchUpInside];
    [self dateVIEW];
    
}
-(void)dateVIEW
{
    self.dayPicker.delegate = self;
    self.dayPicker.dataSource = self;
    
    self.dayPicker.dayNameLabelFontSize = 12.0f;
    self.dayPicker.dayLabelFontSize = 18.0f;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"EE"];
    
    
    [self.dayPicker setStartDate:[NSDate dateFromDay:28 month:9 year:2013] endDate:[NSDate dateFromDay:5 month:10 year:2013]];
    
    [self.dayPicker setCurrentDate:[NSDate dateFromDay:3 month:10 year:2013] animated:NO];

}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_contents layoutIfNeeded];
    _Scroll_contents.contentSize = CGSizeMake(_Scroll_contents.frame.size.width,scrollheight);
    
}
-(void)viewmore_selcted
{
    if([_BTN_view_more.titleLabel.text isEqualToString:@"View more"])
    {
    _LBL_movie_description.numberOfLines = 0;
    [_LBL_movie_description sizeToFit];
    CGRect frameset = _BTN_view_more.frame;
    frameset.origin.y = _LBL_movie_description.frame.origin.y + _LBL_movie_description.frame.size.height;
    _BTN_view_more.frame = frameset;
        
    frameset = _VW_about_movie.frame;
    frameset.size.height = _BTN_view_more.frame.origin.y + _BTN_view_more.frame.size.height;
    _VW_about_movie.frame = frameset;
     
    frameset = _VW_timings.frame;
    frameset.origin.y = _VW_about_movie.frame.origin.y + _VW_about_movie.frame.size.height ;
    _VW_timings.frame = frameset;
    scrollheight = _VW_timings.frame.origin.y + _VW_timings.frame.size.height;
    [self viewDidLayoutSubviews];

    [_BTN_view_more setTitle:@"Show less" forState:UIControlStateNormal];
    }
    else
    {
        
        CGRect frameset =_LBL_movie_description.frame;
        frameset = oldframe;
        _LBL_movie_description.frame = frameset;
        
         frameset = _BTN_view_more.frame;
        frameset.origin.y = _LBL_movie_description.frame.origin.y + _LBL_movie_description.frame.size.height +3;
        _BTN_view_more.frame = frameset;
        
        frameset = _VW_about_movie.frame;
        frameset.size.height = _BTN_view_more.frame.origin.y + _BTN_view_more.frame.size.height +5;
        _VW_about_movie.frame = frameset;
        
        frameset = _VW_timings.frame;
        frameset.origin.y = _VW_about_movie.frame.origin.y + _VW_about_movie.frame.size.height +5;
        _VW_timings.frame = frameset;
        scrollheight = _VW_timings.frame.origin.y + _VW_timings.frame.size.height;

         [self viewDidLayoutSubviews];
        
        
        [_BTN_view_more setTitle:@"View more" forState:UIControlStateNormal];

        
    }

    
    
}
#pragma Tbale view delagets
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(collection_count.count < 3)
    {
        return 75;
    }
    else
    {
        return 115;
    }
}

#pragma DatePicker
- (NSString *)dayPicker:(MZDayPicker *)dayPicker titleForCellDayNameLabelInDay:(MZDay *)day
{
    return [self.dateFormatter stringFromDate:day.date];
}


- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
{
    NSLog(@"Did select day %@",day.day);
    
   
}

- (void)dayPicker:(MZDayPicker *)dayPicker willSelectDay:(MZDay *)day
{
    NSLog(@"Will select day %@",day.day);
}

#pragma collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

{
    return collection_count.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell_timings *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
   
    [cell.BTN_time setTitle:[collection_count objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    return cell;
}

#pragma Button_Actions
- (IBAction)back_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
