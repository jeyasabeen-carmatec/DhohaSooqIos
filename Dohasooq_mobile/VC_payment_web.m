//
//  VC_payment_web.m
//  Dohasooq_mobile
//
//  Created by Test User on 06/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_payment_web.h"
#import "Helper_activity.h"

@interface VC_payment_web ()<UIWebViewDelegate>
{
    UIView *loadingView;
}


@end

@implementation VC_payment_web

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Payment Screen";

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
   @try
    {
     
    NSString *urlStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"payment_url"];
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.web_pay loadRequest:request];
     
    }
    @catch(NSException *exception)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    self.web_pay.delegate = self;
    

}
-(void)viewWillAppear:(BOOL)animated
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor = [UIColor colorWithRed:0.98 green:0.69 blue:0.19 alpha:1.0];
    [self.navigationController.view addSubview:view];

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
- (IBAction)back_action:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
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
