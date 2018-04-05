//
//  AboutUsVC.m
//  DropPinDriver
//
//  Created by Ajay Kumar on 6/19/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()

@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self aboutusApiCalling];
}
-(void)aboutusApiCalling{
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
                                       
                                                                              };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"about_us.php"];
             
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
                          contantTV.text =[dictionary objectForKey:@"body"];
                          
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
