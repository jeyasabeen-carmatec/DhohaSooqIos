//
//  HttpClient.m
//  POSTWebserviceDemo
//
//  Created by cbonline on 27/07/17.
//  Copyright © 2017 CBOnline. All rights reserved.
//

#import "HttpClient.h"



@implementation HttpClient

UIImageView *actiIndicatorView;
UIView *VW_overlay;

+ (void)postServiceCall:(NSString*_Nullable)urlStr andParams:(NSDictionary*_Nullable)params completionHandler:(void (^_Nullable)(id  _Nullable data, NSError * _Nullable error))completionHandler{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30];
    //[request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.allowsCellularAccess = YES;
    configuration.HTTPMaximumConnectionsPerHost = 10;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(id  _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [self stop_activity_animation];
            completionHandler(error,nil);

            NSLog(@"eror 1:%@",[error localizedDescription]);
        }else{
            NSError *err = nil;
            id resposeJSon = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            if (err) {
                 [self stop_activity_animation];
                completionHandler(err,nil);
                //NSLog(@"eror 2:%@",[err localizedDescription]);
            }else{
                @try {
                    if (resposeJSon) {
                        completionHandler(resposeJSon,nil);

                    }
//                    if ([resposeJSon objectForKey:@"response"]) {
//                        NSError *er = [NSError errorWithDomain:[resposeJSon objectForKey:@"msg"] code:200 userInfo:nil];
//                        completionHandler(nil,er);
//                    }else{
                    //}

                } @catch (NSException *exception) {
                     [self stop_activity_animation];
                    NSLog(@" 3 %@",exception);
                }
                            }
        }
    }];
    [dataTask resume];
}

+(void)cart_count:(NSString *)userId completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler{
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/cartcountapi/%@.json",SERVER_URL,userId];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:30];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.allowsCellularAccess = YES;
    configuration.HTTPMaximumConnectionsPerHost = 10;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(id  _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"eror :%@",[error localizedDescription]);
        }else{
            NSError *err = nil;
            id resposeJSon = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            if (err) {
                NSLog(@"eror :%@",[err localizedDescription]);
            }else{
                @try {
                    if (resposeJSon) {
                        completionHandler(resposeJSon,nil);
                        
                    }
                    //                    if ([resposeJSon objectForKey:@"response"]) {
                    //                        NSError *er = [NSError errorWithDomain:[resposeJSon objectForKey:@"msg"] code:200 userInfo:nil];
                    //                        completionHandler(nil,er);
                    //                    }else{
                    //}
                    
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                }
            }
        }
    }];
    [dataTask resume];
}

+(UIAlertView *)createaAlertWithMsg:(NSString *)msg andTitle:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    return  alert;
}
+(void)api_with_post_params:(NSString *)urlStr andParams:(NSDictionary *)params completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler{
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30];
    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.allowsCellularAccess = YES;
    configuration.HTTPMaximumConnectionsPerHost = 10;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(id  _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"eror :%@",[error localizedDescription]);
        }else{
            NSError *err = nil;
            id resposeJSon = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            if (err) {
                NSLog(@"eror :%@",[err localizedDescription]);
            }else{
                @try {
                    if (resposeJSon) {
                        completionHandler(resposeJSon,nil);
                        
                    }
                    //                    if ([resposeJSon objectForKey:@"response"]) {
                    //                        NSError *er = [NSError errorWithDomain:[resposeJSon objectForKey:@"msg"] code:200 userInfo:nil];
                    //                        completionHandler(nil,er);
                    //                    }else{
                    //}
                    
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                }
            }
        }
    }];
    [dataTask resume];
}

+(void)animating_images:(UIViewController *)my_controller{
    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    VW_overlay.clipsToBounds = YES;
    

    VW_overlay.hidden = NO;
    actiIndicatorView = [[UIImageView alloc] initWithImage:[UIImage new]];
    actiIndicatorView.frame = CGRectMake(0, 0, 60, 60);
    actiIndicatorView.center = my_controller.view.center;
    
    actiIndicatorView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"loader1.png"],[UIImage imageNamed:@"loader2.png"],[UIImage imageNamed:@"loader3.png"],[UIImage imageNamed:@"loader4.png"],[UIImage imageNamed:@"loader5.png"],[UIImage imageNamed:@"loader6.png"],[UIImage imageNamed:@"loader7.png"],[UIImage imageNamed:@"loader8.png"],[UIImage imageNamed:@"loader9.png"],[UIImage imageNamed:@"loader10.png"],[UIImage imageNamed:@"loader11.png"],[UIImage imageNamed:@"loader12.png"],[UIImage imageNamed:@"loader13.png"],[UIImage imageNamed:@"loader14.png"],[UIImage imageNamed:@"loader15.png"],[UIImage imageNamed:@"loader16.png"],[UIImage imageNamed:@"loader17.png"],[UIImage imageNamed:@"loader18.png"],nil];
    
    actiIndicatorView.animationDuration = 3.0;
    [actiIndicatorView startAnimating];
    actiIndicatorView.center = VW_overlay.center;
    
    [VW_overlay addSubview:actiIndicatorView];

    [my_controller.navigationController.view addSubview:VW_overlay];
  }
+(void)stop_activity_animation{
    
    [actiIndicatorView stopAnimating];
    VW_overlay.hidden = YES;
    
    
}







@end
