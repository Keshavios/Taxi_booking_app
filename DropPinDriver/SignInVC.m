 //
//  SignInVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/17/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "SignInVC.h"

@interface SignInVC ()

@end

@implementation SignInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *color  = [UIColor whiteColor];
    
    usernameTf.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Enter your Email" attributes:@{ NSForegroundColorAttributeName : color }];
    passwordTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Please enter Password" attributes:@{NSForegroundColorAttributeName : color }];
  
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0,00, 0.0);
    loginSV.contentInset = contentInsets;
    loginSV.scrollIndicatorInsets = contentInsets;

    sendBtn.clipsToBounds = YES;
    sendBtn.layer.cornerRadius = 20;
    
}

//-(void)viewDidLayoutSubviews
//{
//    viewHeight.constant = lastView.frame.origin.y+ lastView.frame.size.height +20;
//    popUpHeight.constant = sendBtn.frame.origin.y+ sendBtn.frame.size.height +20;
//}

-(void)viewWillAppear:(BOOL)animated
{
    sendBtn.clipsToBounds = YES;
    sendBtn.layer.cornerRadius = 20;
    sendBtn.layer.borderWidth = 1;
    sendBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
}

#pragma mark
#pragma mark button action

- (IBAction)signUpBtnAction:(id)sender
{
    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"SignUpVC"];
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)signInBtnACtion:(id)sender
{
    if ([usernameTf.text  isEqualToString:@""]){
        ALERTVIEW(@"Please Enter email", self);
        return;
    }else if ([passwordTF.text  isEqualToString:@""]){
        ALERTVIEW(@"Please Enter Password", self);
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
                 NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
                 if (token == nil || [token isEqualToString:@""])
                 {
                     token = @"123456789";
                 }
                 
                 NSDictionary * params = @{
                                           @"emp_email"    :usernameTf.text,
                                           @"emp_password" :passwordTF.text,
                                           @"device_token" :token,
                                           @"device_type"  :@"2"
                                           };
                 
                 NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"emp_login.php"];
                 
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
                              
                              SET_USER_ID([[dictionary  objectForKey:@"body"] objectForKey:@"emp_id"]);
                              
                             [[NSUserDefaults standardUserDefaults] setObject:[dictionary objectForKey:@"body"] forKey:@"userInfo"];
                              
                             [[NSUserDefaults standardUserDefaults] setObject:[[dictionary objectForKey:@"body"]objectForKey:@"auth_token"] forKey:@"auth_token"];
                              [[NSUserDefaults standardUserDefaults] setObject:[[dictionary objectForKey:@"body"]objectForKey:@"on_duty"] forKey:@"on_duty"];
                              [[NSUserDefaults standardUserDefaults] setObject:passwordTF.text forKey:@"userpaswd"];
                              
                              if ([[[dictionary objectForKey:@"body"] objectForKey:@"is_verify"] integerValue]== 1 &&[[[dictionary objectForKey:@"body"] objectForKey:@"is_approved"] integerValue]== 1) {
                                  UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
                                  [self.navigationController pushViewController:view animated:YES];
                                  
                              }
                              else if ([[[dictionary objectForKey:@"body"] objectForKey:@"is_verify"] integerValue]== 1)  {
                                  if ([[[dictionary objectForKey:@"body"] objectForKey:@"emp_image"] isEqualToString:@""]||[[[dictionary objectForKey:@"body"] objectForKey:@"emp_license_back_img"] isEqualToString:@""]||[[[dictionary objectForKey:@"body"] objectForKey:@"emp_license_front_img"] isEqualToString:@""]) {
                                      UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"DocumentVC"];
                                      [self.navigationController pushViewController:view animated:YES];
                                  }
                                  else if([[[dictionary objectForKey:@"body"] objectForKey:@"is_approved"] integerValue]== 0){
                                      ALERTVIEW(@"Please wait for admin approve", self);
                                      
                                  }
                                 
                             }
                              else if ([[[dictionary objectForKey:@"body"] objectForKey:@"is_verify"] integerValue]== 0 &&[[[dictionary objectForKey:@"body"] objectForKey:@"is_approved"] integerValue]== 0) {
                                  UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"OtpVC"];
                                  [self.navigationController pushViewController:view animated:YES];
                                  
                              }
                              
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
}
- (IBAction)sendBtnaction:(id)sender {
   
    
    if ([forgotEMailTF.text  isEqualToString:@""]){
        ALERTVIEW(@"Please Enter email", self);
        return;
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
                                           
                                           @"emp_email"    :forgotEMailTF.text,
                                           
                                           };
                 
                 NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"forget_password_emp.php"];
                 
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
                              
                              ALERTVIEW(@"Your new password  has been send successfullly on your email. please check", self);
                              popV.hidden = YES;
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
- (IBAction)forgotPaswdBtnaction:(id)sender {
     forgotEMailTF.text = @"";
     popV.hidden = NO;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    NSLog(@"touches began");
    UITouch *touch = [touches anyObject];
    if(touch.view == popV)
    {
        popV.hidden = YES;
    }
}

#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
