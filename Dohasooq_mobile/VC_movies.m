//
//  VC_movies.m
//  Dohasooq_mobile
//
//  Created by Test User on 02/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_movies.h"
#import "Movies_cell.h"
#import "qtickets_cell.h"
#import "XMLDictionary/XMLDictionary.h"


#import <SDWebImage/UIImageView+WebCache.h>


@interface VC_movies ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *Movies_arr;
    UIView *VW_overlay;
    NSDictionary *temp_dict;
    UIActivityIndicatorView *activityIndicatorView;
}
@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;
@end

@implementation VC_movies

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Movies_arr = [[NSMutableArray alloc]init];
    
    [self.Collection_movies registerNib:[UINib nibWithNibName:@"Movies_cell" bundle:nil]  forCellWithReuseIdentifier:@"movie_cell"];

    [self.Collection_movies registerNib:[UINib nibWithNibName:@"Image_qtickets" bundle:nil]  forCellWithReuseIdentifier:@"Image_qtickets"];
   // [self set_UP_VIEW];
    

}
-(void)viewWillAppear:(BOOL)animated
{
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    //    VW_overlay.layer.cornerRadius = 10.0;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    [self.view addSubview:VW_overlay];
   // VW_overlay.hidden = YES;
    [self ATTRIBUTE_TEXT];
    
    [self addSEgmentedControl];
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(movie_API_CALL) withObject:activityIndicatorView afterDelay:0.01];

  
    
}
-(void)ATTRIBUTE_TEXT
{
    NSString *str = @"";
    NSString *text = [NSString stringWithFormat:@"VENUES %@",str];
    
    
        NSString *lang = @"";
    NSString *lang_text = [NSString stringWithFormat:@"ALL LANGUAGES %@",lang];
    
    
    if ([_BTN_all_lang.titleLabel respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_BTN_all_lang.titleLabel.textColor,
                                  NSFontAttributeName: _BTN_all_lang.titleLabel.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:lang_text attributes:attribs];
        
        
        
        NSRange ename = [lang_text rangeOfString:lang];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:15.0],NSForegroundColorAttributeName :[UIColor grayColor]}
                                    range:ename];
        }
        [_BTN_all_lang setAttributedTitle:attributedText forState:UIControlStateNormal];
    }
    else
    {
        [_BTN_all_lang setTitle:text forState:UIControlStateNormal];
    }
    NSString *cinema = @"";
    NSString *cinema_text = [NSString stringWithFormat:@"ALL CINEMA HALLS %@",cinema];
    
    
    if ([_BTN_all_halls.titleLabel respondsToSelector:@selector(setAttributedText:)]) {
        
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_BTN_all_lang.titleLabel.textColor,
                                  NSFontAttributeName: _BTN_all_lang.titleLabel.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:cinema_text attributes:attribs];
        
        
        
        NSRange ename = [cinema_text rangeOfString:cinema];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0],NSForegroundColorAttributeName :[UIColor grayColor]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:15.0],NSForegroundColorAttributeName :[UIColor grayColor]}
                                    range:ename];
        }
        [_BTN_all_halls setAttributedTitle:attributedText forState:UIControlStateNormal];
    }
    else
    {
        [_BTN_all_halls setTitle:text forState:UIControlStateNormal];
    }
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // float  i = Movies_arr.count / 5;
    // int j  =  roundf(i);
    
    return Movies_arr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"movie_cell";
    
    int i = (int)indexPath.row;
    i = i +1;
    Movies_cell *cell = (Movies_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellidentifier forIndexPath:indexPath];
    NSDictionary *dict = [Movies_arr objectAtIndex:indexPath.row];
    
    
    if(self.segmentedControl4.selectedSegmentIndex == 0)
    {
        
        
        if(indexPath.row % 5 == 0 && indexPath.row==0)
        {
            cell.LBL_movie_name.text =  [dict valueForKey:@"_name"];
            cell.LBL_rating.text = [NSString stringWithFormat:@"%@/10",[dict valueForKey:@"_IMDB_rating"]];
            cell.LBL_censor.text = [dict valueForKey:@"_Censor"];
            NSString *img_url = [dict valueForKey:@"_thumbnail"];
            img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
            
            [cell.IMG_banner sd_setImageWithURL:[NSURL URLWithString:img_url]
                               placeholderImage:[UIImage imageNamed:@"logo.png"]
                                        options:SDWebImageRefreshCached];
            
            NSString *str = [dict valueForKey:@"_Languageid"];
            NSString *sub_str = [dict valueForKey:@"_MovieType"];
            int time = [[dict valueForKey:@"_Duration"] intValue];
            int hours = time / 60;
            int minutes = time % 60;
            cell.LBL_duration.text = [NSString stringWithFormat:@"%d hr %d min",hours,minutes];
            
            NSString *text = [NSString stringWithFormat:@"%@      %@",str,sub_str];
            
            
            if ([cell.LBL_language respondsToSelector:@selector(setAttributedText:)]) {
                
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName:cell.LBL_language.textColor,
                                          NSFontAttributeName:cell.LBL_language.font
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
                cell.LBL_language.attributedText = attributedText;
            }
            else
            {
                cell.LBL_language.text = text;
            }
            [cell.BTN_book_now setTag:indexPath.row];
            [cell.BTN_book_now addTarget:self action:@selector(Book_now_action:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        
        
        else if(i % 5 == 0 && i!=0)
        {
            [self.Collection_movies registerNib:[UINib nibWithNibName:@"qtickets_cell" bundle:nil] forCellWithReuseIdentifier:@"qtickets_image"];
            qtickets_cell *cell1 = (qtickets_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"qtickets_image" forIndexPath:indexPath];
            return cell1;
        }
        else
        {
            
            cell.LBL_movie_name.text =  [dict valueForKey:@"_name"];
            cell.LBL_rating.text = [NSString stringWithFormat:@"%@/10",[dict valueForKey:@"_IMDB_rating"]];
            cell.LBL_censor.text = [dict valueForKey:@"_Censor"];
            NSString *img_url = [dict valueForKey:@"_thumbnail"];
            img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
            
            [cell.IMG_banner sd_setImageWithURL:[NSURL URLWithString:img_url]
                               placeholderImage:[UIImage imageNamed:@"logo.png"]
                                        options:SDWebImageRefreshCached];
            int time = [[dict valueForKey:@"_Duration"] intValue];
            int hours = time / 60;
            int minutes = time % 60;
            cell.LBL_duration.text = [NSString stringWithFormat:@"%d hr %d min",hours,minutes];
            
            NSString *str = [dict valueForKey:@"_Languageid"];
            NSString *sub_str = [dict valueForKey:@"_MovieType"];
            NSString *text = [NSString stringWithFormat:@"%@      %@",str,sub_str];
            
            
            if ([cell.LBL_language respondsToSelector:@selector(setAttributedText:)]) {
                
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName:cell.LBL_language.textColor,
                                          NSFontAttributeName:cell.LBL_language.font
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
                cell.LBL_language.attributedText = attributedText;
            }
            else
            {
                cell.LBL_language.text = text;
            }
            [cell.BTN_book_now setTag:indexPath.row];
            [cell.BTN_book_now addTarget:self action:@selector(Book_now_action:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        
        return cell;
    }
    else
    {
        NSDictionary *dict = [Movies_arr objectAtIndex:indexPath.row];
        
        
        if(indexPath.row % 5 == 0 && indexPath.row==0)
        {
            cell.LBL_movie_name.text =  [dict valueForKey:@"_name"];
            cell.LBL_rating.text = [NSString stringWithFormat:@"%@/10",[dict valueForKey:@"_IMDB_rating"]];
            cell.LBL_censor.text = [dict valueForKey:@"_Censor"];
            NSString *img_url = [dict valueForKey:@"_thumbURL"];
            img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
            
            [cell.IMG_banner sd_setImageWithURL:[NSURL URLWithString:img_url]
                               placeholderImage:[UIImage imageNamed:@"logo.png"]
                                        options:SDWebImageRefreshCached];
            
            NSString *str = [dict valueForKey:@"_language"];
            int time = [[dict valueForKey:@"_Duration"] intValue];
            int hours = time / 60;
            int minutes = time % 60;
            cell.LBL_duration.text = [NSString stringWithFormat:@"%d hr %d min",hours,minutes];
            
            NSString *sub_str = [dict valueForKey:@"_MovieType"];
            NSString *text = [NSString stringWithFormat:@"%@      %@",str,sub_str];
            
            
            if ([cell.LBL_language respondsToSelector:@selector(setAttributedText:)]) {
                
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName:cell.LBL_language.textColor,
                                          NSFontAttributeName:cell.LBL_language.font
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
                cell.LBL_language.attributedText = attributedText;
            }
            else
            {
                cell.LBL_language.text = text;
            }
            [cell.BTN_book_now setTag:indexPath.row];
            [cell.BTN_book_now addTarget:self action:@selector(Book_now_action:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        
        
        else if(i % 5 == 0 && i!=0)
        {
            [self.Collection_movies registerNib:[UINib nibWithNibName:@"qtickets_cell" bundle:nil] forCellWithReuseIdentifier:@"qtickets_image"];
            qtickets_cell *cell1 = (qtickets_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"qtickets_image" forIndexPath:indexPath];
            return cell1;
        }
        else
        {
            
            cell.LBL_movie_name.text =  [dict valueForKey:@"_name"];
            cell.LBL_rating.text = [NSString stringWithFormat:@"%@/10",[dict valueForKey:@"_IMDB_rating"]];
            cell.LBL_censor.text = [dict valueForKey:@"_Censor"];
            NSString *img_url = [dict valueForKey:@"_thumbURL"];
            img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
            
            [cell.IMG_banner sd_setImageWithURL:[NSURL URLWithString:img_url]
                               placeholderImage:[UIImage imageNamed:@"logo.png"]
                                        options:SDWebImageRefreshCached];
            
            NSString *str = [dict valueForKey:@"_language"];
            int time = [[dict valueForKey:@"_Duration"] intValue];
            int hours = time / 60;
            int minutes = time % 60;
            cell.LBL_duration.text = [NSString stringWithFormat:@"%d hr %d min",hours,minutes];
            
            NSString *sub_str = [dict valueForKey:@"_MovieType"];
            NSString *text = [NSString stringWithFormat:@"%@      %@",str,sub_str];
            
            
            if ([cell.LBL_language respondsToSelector:@selector(setAttributedText:)]) {
                
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName:cell.LBL_language.textColor,
                                          NSFontAttributeName:cell.LBL_language.font
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
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.39 green:0.78 blue:0.05 alpha:1.0]}
                                            range:ename];
                }
                cell.LBL_language.attributedText = attributedText;
            }
            else
            {
                cell.LBL_language.text = text;
            }
            
        }
        
        return cell;
        
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int i = (int)indexPath.row;
    i = i +1;
    if(indexPath.row % 5 == 0 && indexPath.row==0)
    {
        return CGSizeMake(_Collection_movies.frame.size.width /2.02,284);
        
    }
    if(i % 5 == 0 && i!=0)
    {
        return CGSizeMake(_Collection_movies.frame.size.width,40);
        
    }
    
    else
    {
        return CGSizeMake(_Collection_movies.frame.size.width /2.02,284);
    }
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int i = (int)indexPath.row;
    i = i +1;
    if(i % 5 == 0 && i!=0)
    {
        NSLog(@"mydata");
    }
}

#pragma segment craetion
#pragma segment methods
-(void) addSEgmentedControl
{
    self.segmentedControl4 = [[HMSegmentedControl alloc] initWithFrame:_VW_segment.frame];
    CGRect frame = self.segmentedControl4.frame;
    frame.size.width = self.navigationController.navigationBar.frame.size.width;
    self.segmentedControl4.frame = frame;
    
    self.segmentedControl4.sectionTitles = @[@"Now Showing", @"    Coming Soon  ",];
    
    self.segmentedControl4.backgroundColor = [UIColor redColor];
    self.segmentedControl4.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:16]};
    self.segmentedControl4.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0],NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:16]};
    self.segmentedControl4.selectionIndicatorColor = [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];
    //    self.segmentedControl4.selectionIndicatorColor
    self.segmentedControl4.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl4.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl4.selectionIndicatorHeight = 0.0f;
    
    
    [self.segmentedControl4 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.VW_Movies addSubview:self.segmentedControl4];
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl4
{
    if(self.segmentedControl4.selectedSegmentIndex == 0)
    {
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(movie_API_CALL) withObject:activityIndicatorView afterDelay:0.01];
        
        
        
    }
    else
    {
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(up_coming_API) withObject:activityIndicatorView afterDelay:0.01];
        
        
    }
}

#pragma Button_Actions

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)Book_now_action:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[Movies_arr objectAtIndex:sender.tag] forKey:@"Movie_detail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"Movies_Booking" sender:self];
    
    
}
#pragma API call
-(void)movie_API_CALL
{
    @try
    {
        NSURL *URL = [[NSURL alloc] initWithString:@"https://api.q-tickets.com/V2.0/GetMoviesbyLangAndTheatreid"];
        NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
        //NSLog(@"Response dictionary: %@", xmlDoc);
        
        temp_dict = [xmlDoc valueForKey:@"Movies"];
        NSMutableArray *tmp_arr = [temp_dict valueForKey:@"movie"];
        //NSLog(@"Response dictionary: %@", tmp_arr);
        NSArray *old_arr = tmp_arr;//[json_RESULT mutableCopy];
        
        NSMutableArray *new_arr = [[NSMutableArray alloc]init];
        
        int count = (int)[old_arr count];
        int index = 0;
        
        int tag = 0;
        
        for (int i = 0; i < count; )
        {
            i= i+1;
            if ((i % 5) == 0 && i != 0)
            {
                NSDictionary *tmp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Qtickets",@"Movies", nil];
                [new_arr addObject:tmp_dictin];
                count = count + 1;
                tag = tag + 1;
            }
            else
            {
                index = i - tag - 1;
                [new_arr addObject:[old_arr objectAtIndex:index]];
            }
        }
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        [Movies_arr removeAllObjects];
        Movies_arr = [new_arr mutableCopy];
        [_Collection_movies reloadData];
        
        NSLog(@"%lu",(unsigned long)Movies_arr.count);
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception%@",exception);
    }
    
    
}
-(void)up_coming_API
{
    @try {
        NSURL *URL = [[NSURL alloc] initWithString:@"https://api.q-tickets.com/V2.0/getupcomingmovies"];
        NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
        //NSLog(@"Response dictionary: %@", xmlDoc);
        
        temp_dict = [xmlDoc valueForKey:@"Movies"];
        NSMutableArray *tmp_arr = [temp_dict valueForKey:@"movie"];
        NSArray *old_arr = tmp_arr;//[json_RESULT mutableCopy];
        
        NSMutableArray *new_arr = [[NSMutableArray alloc]init];
        
        int count = (int)[old_arr count];
        int index = 0;
        
        int tag = 0;
        
        for (int i = 0; i < count; )
        {
            i= i+1;
            if ((i % 5) == 0 && i != 0)
            {
                NSDictionary *tmp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Qtickets",@"Movies", nil];
                [new_arr addObject:tmp_dictin];
                count = count + 1;
                tag = tag + 1;
            }
            else
            {
                index = i - tag - 1;
                [new_arr addObject:[old_arr objectAtIndex:index]];
            }
        }
        
        
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        [Movies_arr removeAllObjects];
        Movies_arr = [new_arr mutableCopy];
        [_Collection_movies reloadData];
        
        NSLog(@"%lu",(unsigned long)Movies_arr.count);
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception%@",exception);
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
