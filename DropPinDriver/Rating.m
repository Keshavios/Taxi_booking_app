//
//  Rating.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/29/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "Rating.h"

@interface Rating ()

@end

@implementation Rating

- (void)viewDidLoad {
    [super viewDidLoad];

   ratingTV.tableFooterView   = [[UIView alloc]initWithFrame:CGRectZero];
   MainTitleArray = [[NSMutableArray alloc] initWithObjects:@"Passenger feedback",nil];
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"on_duty"] isEqualToString:@"0"]) {
        [switchBtn setOn:YES animated:YES];
        onofflineLB.text = @"Online";
        
    }
    else{
        [switchBtn setOn:NO animated:YES];
        onofflineLB.text = @"Offline";
        
    }
    [self reatingApiCalling];
}
-(void)reatingApiCalling{
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
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"get_rating_data.php"];
             
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
                          CurrentRatingLB.text = [[dictionary objectForKey:@"body"] objectForKey:@"avgrating"];
                          
                          requestLB.text= [[dictionary objectForKey:@"body"] objectForKey:@"request_accepted"];
                          tripCancelLB.text=[[dictionary objectForKey:@"body"] objectForKey:@"trip_canceled"];
                          [ratingBtn setTitle:[[dictionary objectForKey:@"body"] objectForKey:@"avgrating"] forState:UIControlStateNormal];
                          
                          [[NSUserDefaults standardUserDefaults] setObject:[[dictionary objectForKey:@"body"] objectForKey:@"avgrating"] forKey:@"currentrating"];
                          
                          [self getReviewApiCalling];
                          
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
-(void)getReviewApiCalling{
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
                                       
                                       @"user_id": GET_USER_ID,
                                       @"type":@"2"
                                       
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"get_review_data.php"];
             
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
                          reviewArray=[[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          
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
#pragma mark tableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return MainTitleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  2;//reviewArray.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"RatingCell"];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RatingCell"];
    }
    
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    
    UILabel*titleLB             = [cell.contentView viewWithTag:1];
    UILabel*subtitleLB          = [cell.contentView viewWithTag:2];
    titleLB.text                = @"UserName";
    subtitleLB.text             = @"comment";
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
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
    NSString *artistStr = [MainTitleArray objectAtIndex:section];
    
    
    [artistlbl setText:artistStr];
    [localView addSubview:artistlbl];
    
    
    
    UIView *LineV = [[UIView alloc] initWithFrame:CGRectMake(0,localView.frame.size.height-1, localView.frame.size.width, 1)];
    
    LineV.backgroundColor = [UIColor whiteColor];
    [localView addSubview:LineV];
    
    return localView;
}

#pragma mark
#pragma mark button action

- (IBAction)ratingBtnAction:(id)sender {
}
- (IBAction)switchBtnAction:(UISwitch*)sender {
    NSString * duty;
    if(sender.isOn){
        duty = @"0";
        onofflineLB.text = @"Online";
    }else{
        duty = @"1";
        onofflineLB.text = @"Offline";
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
- (IBAction)menuBtnaction:(id)sender {
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

#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
