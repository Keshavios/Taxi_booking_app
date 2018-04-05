//
//  NewWithdrawVC.m
//  DropPinDriver
//
//  Created by Apple on 05/02/18.
//  Copyright © 2018 Ajay kumar. All rights reserved.
//

#import "NewWithdrawVC.h"

@interface NewWithdrawVC ()
{
    IBOutlet UIView *totalAmountView;
    IBOutlet UIView *yourAmountView;
    IBOutlet UILabel *totalAmountLBL;
    IBOutlet UITextField *amountTF;
    
    IBOutlet UIButton *sendBtn;
}
@end

@implementation NewWithdrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    totalAmountView.layer.cornerRadius = 3;
    totalAmountView.clipsToBounds = YES;
    yourAmountView.layer.cornerRadius = 3;
    yourAmountView.clipsToBounds = YES;
    sendBtn.layer.cornerRadius = 20;
    sendBtn.clipsToBounds = YES;
    [self requestApiCalling];
    
    // Do any additional setup after loading the view.
}
- (IBAction)bckBtnAction:(id)sender {
}
- (IBAction)sendReqBtn:(id)sender {
    int value = [totalAmt intValue];
    if ([amountTF.text isEqualToString:@""])
    {
        ALERTVIEW(@"Please enter amount for withdraw request", self);
    }
    else if (value < [amountTF.text intValue])
    {
        amountTF.text = @"";
        ALERTVIEW(@"Please enter Valid Amount", self);
    }
    else
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
                                           @"amount":amountTF.text,
                                           @"emp_id" : GET_USER_ID
                                           };
                 
                 NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"withdrawal_request.php"];
                 
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
                              amountTF.text = @"";
                              ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
                          }
                          else
                          {
                              amountTF.text = @"";
                              ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
                              
                          }
                      }
                      
                  }];
             }
             
         }];
    }
    
}
-(void)requestApiCalling{
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
                                       @"emp_id" : GET_USER_ID,
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"driver_amount.php"];
             
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
                          totalAmt = [[dictionary objectForKey:@"body"] objectForKey:@"total"];
                          totalAmountLBL.text = [NSString stringWithFormat:@"Your Total Amount is: $%@",totalAmt];
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
