//
//  WithdrawVC.m
//  DropPinDriver
//
//  Created by CqlSys iOS Team on 15/11/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "WithdrawVC.h"

@interface WithdrawVC ()

@end

@implementation WithdrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    withdrawAmtBt.layer.cornerRadius = 20;
    withdrawAmtBt.clipsToBounds = YES;
   
    UIColor *color = [UIColor whiteColor];
    amtTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:amtTF.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    
    [self requestApiCalling];
    // Do any additional setup after loading the view.
}
- (IBAction)withdrawAmtBtn:(id)sender
{
    int value = [totalAmt intValue];
    if ([amtTF.text isEqualToString:@""])
    {
        ALERTVIEW(@"Please enter amount for withdraw request", self);
    }
    else if (value < [amtTF.text intValue])
    {
        amtTF.text = @"";
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
                                       @"amount":amtTF.text,
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
                          amtTF.text = @"";
                         ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
                      }
                      else
                      {
                          amtTF.text = @"";
                          ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
                          
                      }
                  }
                  
              }];
         }
         
     }];
    }
    
}
- (IBAction)menuBtnAction:(id)sender {
    UIViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuVC"];
    [self addChildViewController:vc2];
    [self.view addSubview:vc2.view];
    [vc2 didMoveToParentViewController:self];
    vc2.view.frame = CGRectMake(-vc2.view.frame.size.width, 0, vc2.view.frame.size.width,vc2.view.frame.size.height);
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        vc2.view.frame = CGRectMake(vc2.view.frame.size.width*0/100, 0, vc2.view.frame.size.width,vc2.view.frame.size.height);
        
    }   completion:^(BOOL finished)
     {
         
     }];
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
                          totalBalLBL.text = [NSString stringWithFormat:@"Total Balance: $%@",totalAmt];
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


@end
