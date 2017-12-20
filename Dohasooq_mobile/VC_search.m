//
//  VC_search.m
//  Dohasooq_mobile
//
//  Created by Test User on 31/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_search.h"
#import "Search_cell.h"
#import "XMLDictionary/XMLDictionary.h"
#import "HttpClient.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface VC_search ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *arr_events;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;

}
@end

@implementation VC_search

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arr_events = [[NSMutableArray alloc]init];
    _TXT_search.layer.borderWidth = 0.5f;
    _TXT_search.layer.borderColor = [UIColor lightGrayColor].CGColor;
   // [_TXT_search addTarget:self action:@selector(api_calling) forControlEvents:UIControlEventAllEvents];
    _TBL_results.hidden = YES;
    [_BN_close addTarget:self action:@selector(close_action) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)viewWillAppear:(BOOL)animated
{

    self.navigationController.navigationBar.hidden = YES;
    
    
    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    //    VW_overlay.layer.cornerRadius = 10.0;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    VW_overlay.hidden = YES;
}
#pragma Tbaleview delegate mathods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr_events.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Search_cell *cell = (Search_cell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"Search_cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.LBL_name.text = [NSString stringWithFormat:@"%@",[[arr_events objectAtIndex:indexPath.row]  valueForKey:@"name"]];
    
    NSString *description =[NSString stringWithFormat:@"%@",[[arr_events objectAtIndex:indexPath.row]  valueForKey:@"description"]];
    description = [description stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: 'Poppins-Regular'; font-size:%dpx;}</style>",17]];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[description dataUsingEncoding:NSUTF8StringEncoding]options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}documentAttributes:nil error:nil];
    cell.LBL_description.attributedText = attributedString;
    NSString *str = cell.LBL_description.text;
    str = [str stringByReplacingOccurrencesOfString:@"/" withString:@"\n"];
    cell.LBL_description.text = str;
   // [cell.LBL_description sizeToFit];

    cell.LBL_description.text = [NSString stringWithFormat:@"%@",[[arr_events objectAtIndex:indexPath.row]  valueForKey:@"description"]];
    cell.LBL_category.text = [NSString stringWithFormat:@"%@",[[arr_events objectAtIndex:indexPath.row]  valueForKey:@"gen_ven"]];
    
    NSString *img_url = [NSString stringWithFormat:@"https://www.q-tickets.com/%@",[[arr_events objectAtIndex:indexPath.row]  valueForKey:@"poster"]];
    img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
    [cell.IMG_banner sd_setImageWithURL:[NSURL URLWithString:img_url]
                      placeholderImage:[UIImage imageNamed:@"upload-8.png"]
                               options:SDWebImageRefreshCached];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
    NSArray *arr = [[[arr_events objectAtIndex:indexPath.row] valueForKey:@"url"] componentsSeparatedByString:@"/"];
    NSString *str = [arr objectAtIndex:0];
    if([[[arr_events objectAtIndex:indexPath.row] valueForKey:@"show_browser"] isEqualToString:@"1"])
    {
        [[NSUserDefaults standardUserDefaults]  setValue:[[arr_events objectAtIndex:indexPath.row] valueForKey:@"id"] forKey:@"event_id"];
        [[NSUserDefaults standardUserDefaults]  synchronize];
        [self event_detail_api];
        [self performSegueWithIdentifier:@"search_web" sender:self];
    }
    if([[[arr_events objectAtIndex:indexPath.row] valueForKey:@"url"] isEqualToString:@"movies"])
    {
        
        [[NSUserDefaults standardUserDefaults]  setValue:[[arr_events objectAtIndex:indexPath.row] valueForKey:@"id"] forKey:@"id"];
        [[NSUserDefaults standardUserDefaults]  synchronize];
     //   [self movie_detil_api];
        [self performSegueWithIdentifier:@"search_movie_detail" sender:self];

    }
    
    else if([str isEqualToString:@"events"])
    {
        [[NSUserDefaults standardUserDefaults]  setValue:[[arr_events objectAtIndex:indexPath.row] valueForKey:@"id"] forKey:@"event_id"];
        [[NSUserDefaults standardUserDefaults]  synchronize];
        [self event_detail_api];
        [self performSegueWithIdentifier:@"search_events_detail" sender:self];


    }
    }
    @catch(NSException *exception)
    {
        
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 10;
//}
-(void)close_action
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:NO];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    [self performSelector:@selector(api_calling) withObject:activityIndicatorView afterDelay:0.01];

    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _TBL_results.hidden = NO;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    // _TBL_results.hidden = YES;
}
-(void)api_calling
{
    NSString *str_url = [NSString stringWithFormat:@"https://api.q-tickets.com/V2.0/getsearchresult?search=%@",_TXT_search.text];
    str_url = [str_url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

       // NSURL *URL = [[NSURL alloc] initWithString:str_url];
       // NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    [HttpClient postServiceCall:str_url andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary *json = [[NSMutableDictionary alloc]init];

            if (error) {
                [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
            }
          
            if (data) {
                json = data;
                
                @try {
                    [arr_events removeAllObjects];
                    if([[json valueForKey:@"items"] count]<1)
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"NO data Found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];

                    }
                    else{
                    [arr_events addObjectsFromArray:[json valueForKey:@"items"]];
                        VW_overlay.hidden = YES;
                        [activityIndicatorView stopAnimating];
                    [_TBL_results reloadData];
                     NSLog(@"%@",json);
                    }
                    
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                    VW_overlay.hidden = YES;
                    [activityIndicatorView stopAnimating];

                }
                
            }
            
        });
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];

    }];
   

}
-(void)movie_detil_api
{
    @try {
        
        NSString *str_url = [NSString stringWithFormat:@"https://api.q-tickets.com/V4.0/getshowstheatersbymovieid?movieid=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"id"]];
    
    
    NSURL *URL = [[NSURL alloc] initWithString:str_url];
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    //NSLog(@"string: %@", xmlString);
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];

    [[NSUserDefaults standardUserDefaults] setObject:[[xmlDoc valueForKey:@"Movies"] valueForKey:@"movie"] forKey:@"Movie_detail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    }
    @catch(NSException *exception)
    {
        NSLog(@"exception");
        
    }


    
  }
-(void)event_detail_api
{
    
    @try {
    NSString *str_url = [NSString stringWithFormat:@"https://api.q-tickets.com/V2.0/getalleventsdetailsbyeventid?Event_id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"event_id"]];
    
    
    NSURL *URL = [[NSURL alloc] initWithString:str_url];
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    //NSLog(@"string: %@", xmlString);
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    [[NSUserDefaults standardUserDefaults] setObject:[[xmlDoc valueForKey:@"EventDetails"] valueForKey:@"eventdetail"] forKey:@"event_detail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    }
    @catch(NSException *exception)
    {
        
    }
    

    //  detail_dict = xmlDoc;
    

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
