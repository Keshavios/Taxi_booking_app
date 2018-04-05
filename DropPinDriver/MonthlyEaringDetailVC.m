//
//  MonthlyEaringDetailVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 6/20/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "MonthlyEaringDetailVC.h"

@interface MonthlyEaringDetailVC ()

@end

@implementation MonthlyEaringDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _earningDetailTV.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    monthnameLB.text = _month;

}
-(void) viewWillAppear:(BOOL)animated{
    [self earningHistoryApiCalling];
}
-(void) earningHistoryApiCalling{
    [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
     {
         SHOW_PROGRESS(@"Please Wait..");
         if (responseObject == false)
         {
             HIDE_PROGRESS;
             ALERTVIEW( @"Internet Connection not Available!", self);
         }
         else
         {
            NSDictionary * params = @{
                                       @"emp_id": GET_USER_ID,
                                       @"month":_month,
                                       @"year":@"2017"
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"week_data_history.php"];
             
             [[ApiManager  sharedInstance] apiCall:urlString postDictionary:params CompletionBlock:^(BOOL success, NSString*  message, NSDictionary*  dictionary)
              {
                  HIDE_PROGRESS;
                  if (success == false)
                  {
                      ALERTVIEW( message, self);
                  }
                  else
                  {
                      if ([Util checkIfSuccessResponse:dictionary])
                      {
                          weekhistoryarray = [[NSMutableArray alloc] initWithArray:[[dictionary objectForKey:@"body"]objectForKey:@"weak" ]];
                          [_earningDetailTV reloadData];
                      }
                      else
                      {
                   ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
                      }
                  }
                  
              }];
         }
    }];
}


#pragma mark
#pragma mark tableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [weekhistoryarray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"EarningDetailTV"];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"EarningDetailTV"];
    }
    
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    UILabel*amountLB      = [cell.contentView viewWithTag:1];
    UILabel*dateLB        = [cell.contentView viewWithTag:2];
    
    amountLB.text = [NSString stringWithFormat:@"Total Amount: $%@",[[weekhistoryarray objectAtIndex:indexPath.row]objectForKey:@"total_amt"]];
    dateLB.text = [[weekhistoryarray objectAtIndex:indexPath.row]objectForKey:@"weak_name"];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

#pragma mark
#pragma mark button action

- (IBAction)backBtnaction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
