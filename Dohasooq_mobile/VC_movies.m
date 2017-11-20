//
//  VC_movies.m
//  Dohasooq_mobile
//
//  Created by Test User on 02/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_movies.h"


@interface VC_movies ()
@end

@implementation VC_movies

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str_url = [[NSUserDefaults standardUserDefaults] valueForKey:@"str_url"];
    [self.playerView loadWithVideoId:str_url];

}
-(void)viewWillAppear:(BOOL)animated
{
    
    
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
