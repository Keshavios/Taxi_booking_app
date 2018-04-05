//
//  OtpVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/30/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "OtpVC.h"

@interface OtpVC ()

@end

@implementation OtpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *color  = [UIColor whiteColor];
    
    otpTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Enter OTP" attributes:@{ NSForegroundColorAttributeName : color }];
    
    continueBtn.layer.cornerRadius = 25;
    continueBtn.clipsToBounds = YES;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [otpTF bottomWhiteLine];
}
#pragma mark
#pragma mark button action
- (IBAction)continueBtnaction:(id)sender {
    
    if ([otpTF.text  isEqualToString:@""]){
        ALERTVIEW(@"Please Enter OTP", self);
        return;
    }else
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
                                           @"emp_id": GET_USER_ID,
                                           @"otp"   : otpTF.text,
                                           
                                           };
                 
                 NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"verification_otp.php"];
                 
                 [[ApiManager  sharedInstance] apiCall:urlString postDictionary:params CompletionBlock:^(BOOL success, NSString*  message, NSDictionary*  dictionary)
                  {
                      HIDE_PROGRESS;
                      if (success == false)
                      {
                          ALERTVIEW(message, self);
                      }
                      else
                      {
                          if ([Util checkIfSuccessResponse:dictionary])
                          {
                               [[NSUserDefaults standardUserDefaults] setObject:[[dictionary objectForKey:@"body"]objectForKey:@"auth_token"] forKey:@"auth_token"];
                              UIViewController*view =[self.storyboard instantiateViewControllerWithIdentifier:@"WelComeVC"];
                              [self.navigationController pushViewController:view animated:YES];
                              
                          }
                          else
                          {
//                              ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
                              if ([[[dictionary objectForKey:@"status"] objectForKey:@"message"] isEqualToString:@"auth_token does not match"]) {
                                  UIAlertController *alertController = [UIAlertController
                                                                        alertControllerWithTitle:@""
                                                                        message:[[dictionary objectForKey:@"status"] objectForKey:@"message"]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                                  
                                  UIAlertAction *okAction = [UIAlertAction
                                                             actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                                             {
                                                                 SET_USER_ID(nil);
                                                                 UIViewController *view  = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyVC"];
                                                                 self.view.window.rootViewController    = view;
                                                                 
                                                             }];
                                  
                                  [alertController addAction:okAction];
                                  
                                  [self presentViewController:alertController animated:YES completion:nil];
                              }
                              else
                              {
                                  ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
                              }
                          }
                      }
                      
                  }];
             }
             
         }];
        
    }

}
- (IBAction)resendBtnAction:(id)sender {
    
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
                                           @"emp_id":GET_USER_ID
                                          
                                           };
                 
                 NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"resend_emp_otp"];
                 
                 [[ApiManager  sharedInstance] apiCall:urlString postDictionary:params CompletionBlock:^(BOOL success, NSString*  message, NSDictionary*  dictionary)
                  {
                      HIDE_PROGRESS;
                      if (success == false)
                      {
                          ALERTVIEW(message, self);
                      }
                      else
                      {
                          if ([Util checkIfSuccessResponse:dictionary])
                          {
                              
                              
                          }
                          else
                          {
//                              ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
                              if ([[[dictionary objectForKey:@"status"] objectForKey:@"message"] isEqualToString:@"auth_token does not match"]) {
                                  UIAlertController *alertController = [UIAlertController
                                                                        alertControllerWithTitle:@""
                                                                        message:[[dictionary objectForKey:@"status"] objectForKey:@"message"]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                                  
                                  UIAlertAction *okAction = [UIAlertAction
                                                             actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                                             {
                                                                 SET_USER_ID(nil);
                                                                 UIViewController *view  = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyVC"];
                                                                 self.view.window.rootViewController    = view;
                                                                 
                                                             }];
                                  
                                  [alertController addAction:okAction];
                                  
                                  [self presentViewController:alertController animated:YES completion:nil];
                              }
                              else
                              {
                                  ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
                              }                          }
                      }
                      
                  }];
             }
             
         }];
        
    }
    


- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
