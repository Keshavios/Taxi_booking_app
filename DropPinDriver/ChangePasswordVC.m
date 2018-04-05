//
//  ChangePasswordVC.m
//  DropPinDriver
//
//  Created by Ajay Kumar on 6/19/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "ChangePasswordVC.h"

@interface ChangePasswordVC ()

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    sendBt.layer.cornerRadius = 20;
    sendBt.clipsToBounds = YES;
}
-(void) viewDidAppear:(BOOL)animated{
    [oldTF buttomLine];
    [newTF buttomLine];
    [confirmTf buttomLine];
}

#pragma mark
#pragma mark button action
- (IBAction)backbtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveBtnaction:(id)sender {
    if ([oldTF.text isEqualToString:@""]) {
         ALERTVIEW(@"please enter old Password", self);
        return;
    }
    else if  (![oldTF.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userpaswd"]]) {
        ALERTVIEW(@"Old Password  Not Match", self);
        return;
    }
    else if ([newTF.text isEqualToString:@""]) {
        ALERTVIEW( @"Enter New Password", self);
        return;
    }
    else if ([confirmTf.text isEqualToString:@""]) {
        ALERTVIEW( @"Please ConfirmPassword", self);
        return;
    }
    else if (![newTF.text isEqualToString:confirmTf.text]) {
        ALERTVIEW(@"New Password  and Confirm Password are not equal", self);
        return;
    }
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
                                       @"auth_token": [[NSUserDefaults standardUserDefaults]  objectForKey:@"auth_token"],
                                       @"emp_id": GET_USER_ID,
                                       @"emp_password": oldTF.text,
                                       @"new_password": newTF.text,
                                       @"conform_password": confirmTf.text
                                       
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"change_password_emp.php"];
             
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
                          
                          UIAlertController *alertController = [UIAlertController
                                                                alertControllerWithTitle:@""
                                                                message:@"Password update successfully"
                                                                preferredStyle:UIAlertControllerStyleAlert];
                          
                          UIAlertAction *okAction = [UIAlertAction
                                                     actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                                                     {
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                         
                                                     }];
                          
                          [alertController addAction:okAction];
                          
                          [self presentViewController:alertController animated:YES completion:nil];
                      }
                      else
                      {
//                          ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
                          if ([[[dictionary objectForKey:@"status"] objectForKey:@"message"] isEqualToString:@"Authentication Token does not match"]) {
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

                      }
                  }
                  
              }];
         }
         
     }];

}

#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
