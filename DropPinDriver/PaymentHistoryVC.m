//
//  PaymentHistoryVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 6/20/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "PaymentHistoryVC.h"
#import "MonthlyEaringDetailVC.h"
#import "BankDetailsVC.h"
@interface PaymentHistoryVC ()

@end

@implementation PaymentHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    historyTV.tableFooterView   = [[UIView alloc]initWithFrame:CGRectZero];
    sectionArr = [NSArray arrayWithObjects:@"Transtion History",@"Earning History",@"Withdraw", nil];
   // withdrawArray =[NSArray arrayWithObjects:@"Cash",@"Paypal",@"Credit Card", nil];
    withdrawArray =[NSArray arrayWithObjects:@"Withdraw",nil];
    selectedIndex  = -1;
   
}
-(void) viewWillAppear:(BOOL)animated
{
     [self paymentApiCalling];
}

-(void) paymentApiCalling
{
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
                                       @"emp_id": GET_USER_ID
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"widrol_history.php"];
             
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
                          transtionArray =[[NSMutableArray alloc] initWithArray:[[dictionary objectForKey:@"body"] objectForKey:@"withdral_History"]];
                          
                          Earingarray= [[NSMutableArray alloc] initWithArray:[[dictionary objectForKey:@"body"] objectForKey:@"Month"]];
                          
                          [historyTV reloadData];
                          
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
#pragma mark - Back Action
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark - Table View Delegate & Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        if (selectedIndex == 0) {
            return [transtionArray count];
        }
        else {
            
            return 0;
        }
    }
    
    if (section == 1) {
        
        if (selectedIndex == 1) {
            return [Earingarray count];
        }
        else {
            
            return 0;
        }
    }
    if (section == 2) {
        
        if (selectedIndex == 2) {
            return [withdrawArray count];
        }
        else {
            
            return 0;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"HistoryTVCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.selectionStyle    = UITableViewCellSelectionStyleNone;
    
    UIImageView *arrowImg  = [cell.contentView viewWithTag:3];
    UILabel*dateLB         = [cell.contentView viewWithTag:2];
    UILabel*amountLB      = [cell.contentView viewWithTag:1];
    UILabel*withdrawtypeLB      = [cell.contentView viewWithTag:4];
    
    if (indexPath.section ==0) {
        withdrawtypeLB.hidden = YES;
        dateLB.hidden   = NO;
        amountLB.hidden = NO;
        dateLB.text =[[transtionArray objectAtIndex:indexPath.row] objectForKey:@"date"];
        
        amountLB.text =[NSString stringWithFormat:@"Total Amount: $%@",[[transtionArray objectAtIndex:indexPath.row] objectForKey:@"amount"]];
        
        
    }
    else if (indexPath.section ==1) {
        withdrawtypeLB.hidden = YES;
        dateLB.hidden         = NO;
        amountLB.hidden       = NO;
        dateLB.text =[[Earingarray objectAtIndex:indexPath.row] objectForKey:@"month_name"];
        amountLB.text =[NSString stringWithFormat:@"Total Amount: $%@",[[Earingarray objectAtIndex:indexPath.row] objectForKey:@"total_amt"]];
        
    }
    else if (indexPath.section ==2) {
        dateLB.hidden   = YES;
        amountLB.hidden = YES;
        withdrawtypeLB.hidden = NO;
        withdrawtypeLB.text =[withdrawArray objectAtIndex:indexPath.row];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *localView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    localView.backgroundColor =UIColorFromRGBAlpha(230, 230, 230, 1);
    UILabel *artistlbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, localView.frame.size.width, 30)];
    //[artistlbl setFont:[UIFont fontWithName:@"" size:16.0]];
    NSString *artistStr = [sectionArr objectAtIndex:section];
    
    if (SCREEN_WIDTH == 320) {
        artistlbl.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
    }else {
        artistlbl.font = [UIFont fontWithName:@"OpenSans-Bold" size:15.0];
    }
    
    [artistlbl setText:artistStr];
    [localView addSubview:artistlbl];
    
    UIButton *HeaderBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, localView.frame.size.width, 50 )];
    HeaderBtn.tag = section;
    
    [HeaderBtn addTarget:self action:@selector(HeaderBtnAction:)
        forControlEvents:UIControlEventTouchUpInside];
    [localView addSubview:HeaderBtn];
    
    UIView *LineV = [[UIView alloc] initWithFrame:CGRectMake(0,localView.frame.size.height-1, localView.frame.size.width, 1)];
    
    LineV.backgroundColor = [UIColor whiteColor];
    [localView addSubview:LineV];
    
    return localView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        MonthlyEaringDetailVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"MonthlyEaringDetailVC"];
        view.month= [[Earingarray objectAtIndex:indexPath.row]objectForKey:@"month_name"];
        
        [self.navigationController pushViewController:view animated:YES];
        
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row ==0) {
            NewWithdrawVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"NewWithdrawVC"];
            [self.navigationController pushViewController:view animated:YES];
        }
//        else if (indexPath.row ==1) {
//            BankDetailsVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"BankDetailsVC"];
//            view.PaymentType =@"2";
//            [self.navigationController pushViewController:view animated:YES];
//        }
//        else if (indexPath.row ==2) {
//            BankDetailsVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"BankDetailsVC"];
//            view.PaymentType =@"1";
//            [self.navigationController pushViewController:view animated:YES];
//        }
        
        
    }
}

#pragma mark
#pragma mark - Section button
- (IBAction)HeaderBtnAction:(UIButton *)sender{
    selectedIndex   = (int)sender.tag;
    
    [historyTV reloadData];
}



#pragma mark
#pragma mark button action
- (IBAction)backbtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
