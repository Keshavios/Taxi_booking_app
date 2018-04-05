//
//  EarningVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/29/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "EarningVC.h"
#import "DSBarChart.h"

@interface EarningVC ()

@end

@implementation EarningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Earningarray =[[NSMutableArray alloc] init];
    
    for (int i= 0; i< 7; i++) {
        
        [Earningarray addObject:@"0"];
    }

    
}

-(void) viewWillAppear:(BOOL)animated{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"on_duty"] isEqualToString:@"0"]) {
        [switchBtn setOn:YES animated:YES];
        onOfflineLB.text = @"Online";
        
    }
    else{
        [switchBtn setOn:NO animated:YES];
        onOfflineLB.text = @"Offline";
        
    }
    
     [self earningApiCalling];
}

-(void) earningApiCalling{
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
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"emp_earning_details.php"];
             
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
                          NSMutableDictionary * earningdetailDict= [[NSMutableDictionary alloc] initWithDictionary:[dictionary objectForKey:@"body"]];
                          
                              [Earningarray replaceObjectAtIndex:0 withObject:[earningdetailDict  objectForKey:@"Monday"]];
                             [Earningarray replaceObjectAtIndex:1 withObject:[earningdetailDict  objectForKey:@"Tuesday"]];
                             [Earningarray replaceObjectAtIndex:2 withObject:[earningdetailDict  objectForKey:@"Wednesday"]];[Earningarray replaceObjectAtIndex:3 withObject:[earningdetailDict  objectForKey:@"Thrusday"]];
                             [Earningarray replaceObjectAtIndex:4 withObject:[earningdetailDict  objectForKey:@"Friday"]];[Earningarray replaceObjectAtIndex:5 withObject:[earningdetailDict  objectForKey:@"Saturday"]];
                            [Earningarray replaceObjectAtIndex:6 withObject:[earningdetailDict  objectForKey:@"Sunday"]];
                          
                        
                          
                          NSArray *refs = [NSArray arrayWithObjects:@"M", @"Tu", @"W", @"Th", @"F", @"Sa", @"Su", nil];
                          NSArray *diff = [NSArray arrayWithObjects:@"350", @"300",@"250", @"200", @"150", @"100", @"50",  nil];
                          DSBarChart *chrt= [[DSBarChart alloc] initWithFrame:graphV.bounds
                                                                        color:[UIColor whiteColor]
                                                                   references:refs
                                                                   difference:diff
                                                                    andValues:Earningarray];
                          
                          chrt.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                          chrt.bounds = graphV.bounds;
                          [graphV addSubview:chrt];
                          
                          thisWeekLB.text=[NSString stringWithFormat:@"$%@",[[dictionary objectForKey:@"body"] objectForKey:@"weekly_amount"]];
                          thismonthLB.text =[NSString stringWithFormat:@"$%@",[[dictionary objectForKey:@"body"] objectForKey:@"monthly_amount"]];
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
- (IBAction)menuBtn:(id)sender {
    UIViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuVC"];
    [self addChildViewController:vc2];
    [self.view addSubview:vc2.view];
    [vc2 didMoveToParentViewController:self];
    vc2.view.frame = CGRectMake(-vc2.view.frame.size.width, 0, vc2.view.frame.size.width,vc2.view.frame.size.height);
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        vc2.view.frame = CGRectMake(vc2.view.frame.size.width*0/100, 0, vc2.view.frame.size.width,vc2.view.frame.size.height);
        
    }   completion:^(BOOL finished) {
        
    }];
}
- (IBAction)switchBtnAction:(UISwitch*)sender {
    NSString * duty;
    if(sender.isOn){
        duty = @"0";
        onOfflineLB.text = @"Online";
    }else{
        duty = @"1";
        onOfflineLB.text = @"Offline";
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
                                       
                                       @"auth_token"       : [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"],
                                       @"emp_id": GET_USER_ID,
                                       @"on_duty": duty
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"emp_duty.php"];
             
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
                          [[NSUserDefaults standardUserDefaults] setObject:[[dictionary objectForKey:@"body"]objectForKey:@"on_duty"] forKey:@"on_duty"];
                          
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
- (IBAction)previousTripBtnAction:(id)sender {
    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"PreviousTripVC"];
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
