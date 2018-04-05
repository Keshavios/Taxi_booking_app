//
//  HomeVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/29/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "HomeVC.h"
#import "GoPassangerVC.h"
#import "StartNavigationVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    footerV.clipsToBounds       = YES;
    footerV.layer.cornerRadius  = 3;
    
    innerV.clipsToBounds        = YES;
    innerV.layer.cornerRadius   = 3;
    innerV.layer.borderColor    = [[UIColor grayColor] CGColor];
    innerV.layer.borderWidth    = 1;
  
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(BookingRequestdetails:)
                                                 name:@"BOOKING"
                                               object:nil];
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(cancelRide:)
                                                            name:@"CANCELRIDE"
                                                          object:nil];

    [self.view layoutIfNeeded];
    
}

-(void) BookingRequestdetails :(NSNotification *)notification {
    ridedetail =[[NSMutableDictionary alloc] initWithDictionary: notification.userInfo];
    [self requestApiCalling];
}

-(void) cancelRide:(NSNotification *)notification {
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appNAME
                                                message:@"Ride has been cancelled by client"
                                               delegate:self
                                      cancelButtonTitle:@"ok"
                                      otherButtonTitles:nil];
[alert show];

}
-(void)viewDidAppear:(BOOL)animated{
    arrowBtn.selected = true;
    bottomConstrains.constant = bottomConstrains.constant-discTV.frame.size.height;
    [self showPinOnMapviewWithArray];
}
-(void)viewWillAppear:(BOOL)animated{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"on_duty"] isEqualToString:@"0"]) {
        [switchBtn setOn:YES animated:YES];
        onOfflineLB.text = @"Online";
        
    }
    else{
        [switchBtn setOn:NO animated:YES];
        onOfflineLB.text = @"Offline";
        
    }
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"finish"] isEqualToString:@"finish"])
    {
        finishPV.hidden = NO;
        costLB.text = [NSString stringWithFormat:@"Cost: ¢%@",[[NSUserDefaults standardUserDefaults]  objectForKey:@"estimation_cost"]];
    }
    lat = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]];
    lng = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]];
    if (lat == nil) {
        lat = @"0.00";
        
    }
    if (lng == nil) {
        lng = @"0.00";
    }
      [self requestApiCalling];
    
    
}
-(void)showPinOnMapviewWithArray
{
    GMSCameraPosition *camera = nil;
    
    camera = [GMSCameraPosition cameraWithLatitude: [lat doubleValue]                                             longitude:[lng doubleValue] zoom:14.0];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, mapV.frame.size.width, mapV.frame.size.height) camera:camera];
    
    
    [mapView_ setCamera:camera];
    mapView_.myLocationEnabled  = YES;
    mapView_.delegate           = self;
    
    [mapV addSubview:mapView_];
    
}

#pragma mark
#pragma mark tableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [requestArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"RequestCell"];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RequestCell"];
    }
    
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    
    UILabel*reqMsgLB        = [cell.contentView viewWithTag:1];
    UILabel*timeLB          = [cell.contentView viewWithTag:2];
    UILabel*priceLB         = [cell.contentView viewWithTag:4];
    UILabel*estimateNetLB   = [cell.contentView viewWithTag:3];
    UIButton*acceptBtn      = [cell.contentView viewWithTag:5];
    UIButton*declineBtn     = [cell.contentView viewWithTag:6];
    UIButton*arrowBtn       = [cell.contentView viewWithTag:7];
    UIView * outerview      = [cell.contentView viewWithTag:8];
    
    outerview.clipsToBounds = YES;
    outerview.layer.cornerRadius = 3;
    
    
    acceptBtn.tag  = indexPath.row;
    declineBtn.tag = indexPath.row;
    
    timeLB.text = [[requestArray  objectAtIndex:indexPath.row] objectForKey:@"start_time_from"];
     priceLB.text = [NSString stringWithFormat:@"¢ %@",[[requestArray objectAtIndex:indexPath.row] objectForKey:@"estimation_cost"]];
    
   
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
}
#pragma mark
#pragma mark button action
- (IBAction)menuBtnAction:(id)sender {
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
                          
                          [self requestApiCalling];
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
- (IBAction)arrowBtn:(UIButton*)sender {
    if (sender.selected == true) {
        sender.selected = false;
        bottomConstrains.constant = 0;
    }
    else{
        sender.selected = true;
        bottomConstrains.constant = bottomConstrains.constant-discTV.frame.size.height;
    }
    
}

- (IBAction)footerArrowBtnAction:(id)sender {
}

- (IBAction)declineBtnAction:(UIButton*)sender {
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
                                       @"auth_token":[[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"],
                                       @"request_id"       : [[requestArray objectAtIndex:sender.tag] objectForKey:@"request_id"],
                                       @"req_status" :@"2"
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"accept_ride.php"];
             
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
                           [self requestApiCalling];
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

- (IBAction)acceptBtnAction:(UIButton *)sender {
    
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
                                       @"auth_token":[[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"],
                                       @"request_id"       : [[requestArray objectAtIndex:sender.tag] objectForKey:@"request_id"],
                                       @"req_status" :@"1"
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"accept_ride.php"];
             
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
                          ridedetail =[[NSMutableDictionary alloc] initWithDictionary:[dictionary objectForKey:@"body"]];
                          
                          [[NSUserDefaults standardUserDefaults]setObject:[requestArray objectAtIndex:sender.tag] forKey:@"request_id"];
                          if ([[NSString stringWithFormat:@"%ld",[[ridedetail objectForKey:@"is_scheduled"] integerValue]] isEqualToString:@"1"]) {
                             
                              UIViewController * view = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviousTripVC"];
                              [self.navigationController pushViewController:view animated:YES];
                          }

                          else{
                              
                            GoPassangerVC * view = [self.storyboard instantiateViewControllerWithIdentifier:@"GoPassangerVC"];
                             view.acptRideDetailDict = [[NSMutableDictionary alloc] initWithDictionary:ridedetail];
                              [self.navigationController pushViewController:view animated:YES];
                         }
                      }
                      else
                      {
                          
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

- (IBAction)arrowBtnAction:(id)sender {
}

- (IBAction)okBtnAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"finish"];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"request_id"];
    finishPV.hidden = YES;

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
                                       @"emp_id"           : GET_USER_ID,
                                       @"user_id"           : GET_USER_ID
                                       
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"pending_request.php"];
             
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
                          requestArray = [[NSMutableArray alloc] initWithArray:[[dictionary objectForKey:@"body"] objectForKey:@"main_data"]];
                          totalAmountLB.text =[NSString stringWithFormat:@"ZAR(0)%@",[[dictionary objectForKey:@"body"] objectForKey:@"total_income"]];
                          tripLB.text = [NSString stringWithFormat:@"%@ trips",[[dictionary objectForKey:@"body"] objectForKey:@"total_trips"]];
                          hoursLB.text =[NSString stringWithFormat:@"%@ hours online",[[dictionary objectForKey:@"body"] objectForKey:@"total_duration"]];
                          
                          [self performSelector:@selector(cancelOldRequests) withObject:nil afterDelay:1.0];
                          [requestTV reloadData];
                          [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"finish"];
                          
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

-(void) cancelOldRequests {
    
    NSMutableArray * requestIDarray=[[NSMutableArray alloc]init];
    
    for(int i=0;i<requestArray.count;i++){
        
        NSString*currenttimestamp=  [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
        
        NSString *oldTimeStamp = [[requestArray objectAtIndex:i]objectForKey:@"created_date"];
        
        int timpstamp =[oldTimeStamp integerValue]+60;
        
        if ([currenttimestamp integerValue] == timpstamp) {
            [requestIDarray addObject:[[requestArray objectAtIndex:i]objectForKey:@"request_id"]];
        }
        else{
            
        }
        
    }
    
    requestId   = [requestIDarray componentsJoinedByString:@","];
    if ([requestId isEqualToString:@""]) {
        
    }
    else{
        
        [self performSelector:@selector(OneminApiCalling) withObject:nil afterDelay:60];
        
    }
    
}

-(void) OneminApiCalling{
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
                                       @"request_id"       : requestId
                                       
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"one_min_expire.php"];
             
             [[ApiManager  sharedInstance] OneMinApiCall:urlString postDictionary:params CompletionBlock:^(BOOL success, NSString*  message, NSDictionary*  dictionary)
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
                          
                          [self requestApiCalling];
                          
                          
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
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        // do something here...
    }
    else{
        
    }
}

#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
