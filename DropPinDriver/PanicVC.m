//
//  PanicVC.m
//  DropPinDriver
//
//  Created by CqlSys iOS Team on 31/10/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "PanicVC.h"

@interface PanicVC ()

@end

@implementation PanicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults ] objectForKey:@"request_id"]);
    if ([[NSUserDefaults standardUserDefaults ] objectForKey:@"request_id"]==nil ||[[[NSUserDefaults standardUserDefaults ] objectForKey:@"request_id"] isEqual:NULL] )
    {
        passengerID = @"";
    }
    else
    {
        passengerID =[[NSUserDefaults standardUserDefaults ] objectForKey:@"request_id"];
    }
    // Do any additional setup after loading the view.
}
- (IBAction)panicBtnAction:(id)sender
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
                                       @"type": @"2",
                                       @"user_id": passengerID,
                                       @"driver_id":GET_USER_ID
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"panic.php"];
             
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
                         ALERTVIEW(@"Please don't panic we will contact you soon", self);
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


- (IBAction)menuBtn:(id)sender {
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
