//
//  HttpClient.m
//  POSTWebserviceDemo
//
//  Created by cbonline on 27/07/17.
//  Copyright © 2017 CBOnline. All rights reserved.
//

#import "HttpClient.h"

@implementation HttpClient

+ (void)postServiceCall:(NSString*_Nullable)urlStr andParams:(NSDictionary*_Nullable)params completionHandler:(void (^_Nullable)(id  _Nullable data, NSError * _Nullable error))completionHandler{
    //NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
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
            NSLog(@"eror :%@",[error localizedDescription]);
        }else{
            NSError *err = nil;
            id resposeJSon = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            if (err) {
                NSLog(@"eror :%@",[err localizedDescription]);
            }else{
                if ([resposeJSon objectForKey:@"response"]) {
                    NSError *er = [NSError errorWithDomain:[resposeJSon objectForKey:@"msg"] code:200 userInfo:nil];
                    completionHandler(nil,er);
                }else{
                    completionHandler(resposeJSon,nil);
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

@end
