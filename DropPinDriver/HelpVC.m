//
//  HelpVC.m
//  DropPinDriver
//
//  Created by Ajay Kumar on 6/19/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "HelpVC.h"

@interface HelpVC ()

@end

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    sendBtn.layer.cornerRadius = 20;
    sendBtn.clipsToBounds = YES;
}

#pragma mark
#pragma mark button action
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sendBtnAction:(id)sender {
    if ([nameTF.text isEqualToString:@""]) {
        ALERTVIEW(@"please enter name", self);
        return;
    }
   
    else if ([subjectTF.text isEqualToString:@""]) {
        ALERTVIEW( @"please enter subject", self);
        return;
    }
    else if ([msgTV.text isEqualToString:@""]) {
        ALERTVIEW( @"Please enter message", self);
        return;
    }
   
    [self currentime];
    
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
                                       @"name": nameTF.text,
                                       @"email": emailTf.text,
                                       @"subject": subjectTF.text,
                                       @"message": msgTV.text,
                                       @"created":currentDate
                                       
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"help.php"];
             
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
                                                                message:@"Email send successfully"
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
-(void) currentime{
    
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-mm-yyyy hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *time36 =[dateFormatter stringFromDate:now];
    NSLog(@"The Current Time is %@",time36);
    
    // NSString * timestamp = [NSString stringWithFormat:@"%0.0f",[now timeIntervalSince1970]];
    
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:time36];
    NSTimeInterval time = [dateFromString timeIntervalSince1970];
    // NSLog(@"The Current Time is %@",timestamp);
    double result = time;
    currentDate =[NSString stringWithFormat:@"%f",result];
    
}

- (IBAction)customerCareBtnaction:(id)sender {
    phNo = @"123-145-526-00";
    phNo = [phNo stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    phNo = [phNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        //        alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        //        [alert show];
    }

}
#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
