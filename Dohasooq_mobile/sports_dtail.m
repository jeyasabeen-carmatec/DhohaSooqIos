//
//  sports_dtail.m
//  Dohasooq_mobile
//
//  Created by Test User on 30/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "sports_dtail.h"

@interface sports_dtail ()<UIWebViewDelegate>
{
    UIView *loadingView;
}



@end

@implementation sports_dtail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;

    loadingView = [[UIView alloc]init];
    CGRect loadframe = loadingView.frame;
    loadframe.size.width = 100;
    loadframe.size.height = 100;
    loadingView.frame = loadframe;
    loadingView.center = self.view.center;
    
    loadingView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.6];
    loadingView.layer.cornerRadius = 5;
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(loadingView.frame.size.width / 2.0, 35);
    [activityView startAnimating];
    activityView.tag = 100;
    [loadingView addSubview:activityView];
    
    UILabel* lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, 80, 30)];
    lblLoading.text = @"Loading...";
    lblLoading.textColor = [UIColor whiteColor];
    lblLoading.font = [UIFont fontWithName:lblLoading.font.fontName size:15];
    lblLoading.textAlignment = NSTextAlignmentCenter;
    [loadingView addSubview:lblLoading];
    
    [self.view addSubview:loadingView];
    NSMutableDictionary *event_dict = [[NSMutableDictionary alloc]init];
    event_dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"event_detail"];
    
    NSString *urlStr = [event_dict valueForKey:@"_EventQTurlPath"];
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.Event_detail_web loadRequest:request];
    self.Event_detail_web.delegate = self;
    

}
- (IBAction)back_action:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [loadingView setHidden:NO];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [loadingView setHidden:YES];
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
