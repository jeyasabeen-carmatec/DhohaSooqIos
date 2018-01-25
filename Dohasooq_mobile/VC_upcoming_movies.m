//
//  VC_upcoming_movies.m
//  Dohasooq_mobile
//
//  Created by Test User on 14/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_upcoming_movies.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Helper_activity.h"

@interface VC_upcoming_movies ()
{
    NSMutableDictionary *detail_dict;
    CGRect oldframe;
    float scrollheight;
//    UIView *VW_overlay;
//    UIActivityIndicatorView *activityIndicatorView;
    NSMutableArray *ARR_temp;

}
@end

@implementation VC_upcoming_movies

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_BTN_trailer_watch addTarget:self action:@selector(BTN_trailer_watch) forControlEvents:UIControlEventTouchUpInside];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;

//    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    VW_overlay.clipsToBounds = YES;
//    //    VW_overlay.layer.cornerRadius = 10.0;
//    
//    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
//    activityIndicatorView.center = VW_overlay.center;
//    [VW_overlay addSubview:activityIndicatorView];
//    [self.view addSubview:VW_overlay];
//    
//    VW_overlay.hidden = YES;
//    VW_overlay.hidden = NO;
//    [activityIndicatorView startAnimating];
    [self performSelector:@selector(getResponse_detail) withObject:nil afterDelay:0.01];
}
-(void)getResponse_detail
{
    detail_dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"Movie_detail"];
    [self set_UP_VIEW];
    
    [Helper_activity stop_activity_animation:self];
    [self viewDidLayoutSubviews];
}

-(void)set_UP_VIEW
{
    
    
    CGRect frameset = _VW_dtl_movie.frame;
    frameset.size.width = self.Scroll_contents.frame.size.width;
    _VW_dtl_movie.frame = frameset;
    
    [self.Scroll_contents addSubview:_VW_dtl_movie];
    @try
    {
        _LBL_movie_description.text = [NSString stringWithFormat:@"%@",[detail_dict valueForKey:@"_synopsis"]];
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    _LBL_movie_description.numberOfLines = 0;
    [_LBL_movie_description sizeToFit];

    
    frameset = _VW_about_movie.frame;
    frameset.origin.y = _VW_dtl_movie.frame.origin.y + _VW_dtl_movie.frame.size.height;
    frameset.size.height = _LBL_movie_description.frame.origin.y + _LBL_movie_description.frame.size.height;
    frameset.size.width = self.Scroll_contents.frame.size.width;
    _VW_about_movie.frame = frameset;
    oldframe = _LBL_movie_description.frame;
    
    scrollheight = _VW_about_movie.frame.origin.y + _VW_about_movie.frame.size.height;
    
    [self.Scroll_contents addSubview:_VW_about_movie];
    
   
    @try
    {
        self.LBL_movie_name.text =  [detail_dict valueForKey:@"_name"];
        _LBL_year.text =[detail_dict valueForKey:@"_Censor"];
        self.LBL_rating.text = [NSString stringWithFormat:@"%@ votes",[detail_dict valueForKey:@"_willwatch"]];
        NSString *img_url = [detail_dict valueForKey:@"_thumbURL"];
        img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
        [self.IMG_movie sd_setImageWithURL:[NSURL URLWithString:img_url]
                          placeholderImage:[UIImage imageNamed:@"upload-8.png"]
                                   options:SDWebImageRefreshCached];
        int time = [[detail_dict valueForKey:@"_Duration"] intValue];
        int hours = time / 60;
        int minutes = time % 60;
        self.lbl_duration.text = [NSString stringWithFormat:@"%d hr %d min",hours,minutes];
        NSString *str_watch = [NSString stringWithFormat:@" Will watch  %@",[detail_dict valueForKey:@"_willwatch"]];
        
        NSString *str_not_watch = [NSString stringWithFormat:@" Won't watch  %@",[detail_dict valueForKey:@"_willnotwatch"]];

        
        
        [_BTN_will_watch setTitle:str_watch forState:UIControlStateNormal];
         [_BTN_will_not_watch setTitle:str_not_watch forState:UIControlStateNormal];
        
        
        NSString *str = [detail_dict valueForKey:@"_language"];
        NSString *sub_str = [detail_dict valueForKey:@"_MovieType"];
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
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    
    
    
    _BTN_trailer_watch.layer.cornerRadius = 1.0f;
    _BTN_trailer_watch.layer.masksToBounds = YES;
    [_BTN_view_more addTarget:self action:@selector(viewmore_selcted) forControlEvents:UIControlEventTouchUpInside];
    //    [self dateVIEW];
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_contents layoutIfNeeded];
    _Scroll_contents.contentSize = CGSizeMake(_Scroll_contents.frame.size.width,scrollheight);
    
    
}
-(void)BTN_trailer_watch
{
    if([[detail_dict valueForKey:@"_TrailerURL"] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Trailer video is not available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
        
    }
    else
    {
        NSArray *str_arr = [[detail_dict valueForKey:@"_TrailerURL"] componentsSeparatedByString:@"embed/"];
        
        [[NSUserDefaults standardUserDefaults] setValue:[str_arr objectAtIndex:1]  forKey:@"str_url"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"upcoming_movie" sender:self];
    }

    
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
        scrollheight = _VW_about_movie.frame.origin.y + _VW_about_movie.frame.size.height;

        [self viewDidLayoutSubviews];
        scrollheight = _VW_about_movie.frame.origin.y + _VW_about_movie.frame.size.height;

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
        
        scrollheight = _VW_about_movie.frame.origin.y + _VW_about_movie.frame.size.height;
        
        [self viewDidLayoutSubviews];
        
        
        [_BTN_view_more setTitle:@"View more" forState:UIControlStateNormal];
        
        
    }
    
    
    
}

#pragma Button_Actions
- (IBAction)back_action:(id)sender
{
    //[self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)share_action:(id)sender
{
    if([[detail_dict valueForKey:@"_TrailerURL"] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Event URL not available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        
        
    }
    else
    {
        NSString *trailer_URL= [detail_dict valueForKey:@"_TrailerURL"];
        NSArray* sharedObjects=[NSArray arrayWithObjects:trailer_URL,  nil];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc]                                                                initWithActivityItems:sharedObjects applicationActivities:nil];
        activityViewController.popoverPresentationController.sourceView = self.view;
        [self presentViewController:activityViewController animated:YES completion:nil];
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

@end
