//
//  VC_helpDesk.m
//  Dohasooq_mobile
//
//  Created by Test User on 08/01/18.
//  Copyright © 2018 Test User. All rights reserved.
//

#import "VC_helpDesk.h"
#import "HttpClient.h"

@interface VC_helpDesk ()<UIWebViewDelegate>
//{
//    UIView *loadingView;
//}


@end

@implementation VC_helpDesk

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    loadingView = [[UIView alloc]init];
//    CGRect loadframe = loadingView.frame;
//    loadframe.size.width = 100;
//    loadframe.size.height = 100;
//    loadingView.frame = loadframe;
//    loadingView.center = self.view.center;
//    
//    loadingView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.6];
//    loadingView.layer.cornerRadius = 5;
//    
//    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityView.center = CGPointMake(loadingView.frame.size.width / 2.0, 35);
//    [activityView startAnimating];
//    activityView.tag = 100;
//    [loadingView addSubview:activityView];
//    
//    UILabel* lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, 80, 30)];
//    lblLoading.text = @"Loading...";
//    lblLoading.textColor = [UIColor whiteColor];
//    lblLoading.font = [UIFont fontWithName:lblLoading.font.fontName size:15];
//    lblLoading.textAlignment = NSTextAlignmentCenter;
//    [loadingView addSubview:lblLoading];
//    
//    [self.view addSubview:loadingView];
    
    self.about_us_VW.delegate = self;
    
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@Pages/contentApi/help-desk/%@/%@",SERVER_URL,languge,country];
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.about_us_VW loadRequest:request];
    
    
}
- (IBAction)back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)home_action:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [HttpClient animating_images:self];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [HttpClient stop_activity_animation];
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
