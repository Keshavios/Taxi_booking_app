//
//  PreviousTripVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/29/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "PreviousTripVC.h"
#import "GoPassangerVC.h"
@interface PreviousTripVC ()

@end

@implementation PreviousTripVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [self tripHistoryBtnAction:tripHistoryBtn];
}

-(void) tripHistoryApiCalling{
    
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
                                       @"emp_id"    :GET_USER_ID,
                                    
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"Trip_history.php"];
             
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
                          tripHistoryArray =[[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          if (tripHistoryArray.count == 0) {
//                              UIAlertController *alertController = [UIAlertController
//                                                                    alertControllerWithTitle:@""
//                                                                    message:@"YOU'VE NO TRIPS"
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//
//                              UIAlertAction *okAction = [UIAlertAction
//                                                         actionWithTitle:@"OK"
//                                                         style:UIAlertActionStyleDefault
//                                                         handler:^(UIAlertAction *action)
//                                                         {
//
//                                                         }];
//
//                              [alertController addAction:okAction];
//
//                              [self presentViewController:alertController animated:YES completion:nil];
                          }
                        [tripTV reloadData];
                          
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
-(void) scheduleTripApiCalling{
    
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
                                       @"user_id"    :GET_USER_ID,
                                       @"type":@"2"
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"get_schedules.php"];
             
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
                          scheduleTripArray =[[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          if (scheduleTripArray.count == 0) {
//                              UIAlertController *alertController = [UIAlertController
//                                                                    alertControllerWithTitle:@""
//                                                                    message:@"YOU'VE NO SCHEDULE TRIPS"
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//
//                              UIAlertAction *okAction = [UIAlertAction
//                                                         actionWithTitle:@"OK"
//                                                         style:UIAlertActionStyleDefault
//                                                         handler:^(UIAlertAction *action)
//                                                         {
//
//                                                         }];
//
//                              [alertController addAction:okAction];
//
//                              [self presentViewController:alertController animated:YES completion:nil];
                          }
                        
                              [tripTV reloadData];
                         
                         
                          
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tripHistoryBtn.selected == YES) {
        NSInteger numOfSections = 0;
        if ([tripHistoryArray count]!=0)
        {
            
            numOfSections                = 1;
            tripTV.backgroundView = nil;
        }
        else
        {
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tripTV.bounds.size.width, tripTV.bounds.size.height)];
            noDataLabel.text             = @"YOU'VE NO SCHEDULE TRIPS";
            noDataLabel.textColor        = [UIColor blackColor];
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            tripTV.backgroundView         = noDataLabel;
            tripTV.separatorStyle         = UITableViewCellSeparatorStyleNone;
        }
        
        return numOfSections;
    }else{
        NSInteger numOfSections = 0;
        if ([scheduleTripArray count]!=0)
        {
            
            numOfSections                = 1;
            tripTV.backgroundView = nil;
        }
        else
        {
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tripTV.bounds.size.width, tripTV.bounds.size.height)];
            noDataLabel.text             = @"YOU'VE NO SCHEDULE TRIPS";
            noDataLabel.textColor        = [UIColor blackColor];
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            tripTV.backgroundView         = noDataLabel;
            tripTV.separatorStyle         = UITableViewCellSeparatorStyleNone;
        }
        
        return numOfSections;
    }
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
      if (tripHistoryBtn.selected == YES) {
    return [tripHistoryArray count];
      }else{
          return [scheduleTripArray count];
      }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tripHistoryBtn.selected == YES) {
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"YourTripCell"];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"YourTripCell"];
    }
    
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    
    UIImageView*mapImgv   = [cell.contentView viewWithTag:1];
    UIImageView *UserImg  = [cell.contentView viewWithTag:2];
    UILabel*timeLB        = [cell.contentView viewWithTag:3];
    UILabel*carNameLB     = [cell.contentView viewWithTag:4];
    UILabel*rsLB          = [cell.contentView viewWithTag:5];
    UIView * outerview    = [cell.contentView viewWithTag:6];
    
    outerview.clipsToBounds     = YES;
    outerview.layer.borderWidth = 1;
    outerview.layer.borderColor = [[UIColor lightGrayColor] CGColor];

    UserImg.clipsToBounds       = YES;
    UserImg.layer.cornerRadius  = UserImg.frame.size.width/2;
    
    mapImgv.image   = [UIImage imageNamed:@"MAP_IMG"];
    [UserImg setImageWithURL:[NSURL URLWithString:[[tripHistoryArray objectAtIndex:indexPath.row] objectForKey:@"user_image"]] placeholderImage:[UIImage imageNamed:@"PROFILE_IMG"]];
    
    double unixTimeStamp = [[[tripHistoryArray objectAtIndex:indexPath.row] objectForKey:@"created_date"] doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString* trip_date = [formatter stringFromDate:date];
    
    double unixTimeStamp1 = [[[tripHistoryArray objectAtIndex:indexPath.row] objectForKey:@"checkin_time"] doubleValue];
    NSTimeInterval _interval1=unixTimeStamp1;
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:_interval1];
    NSDateFormatter *formatter1= [[NSDateFormatter alloc] init];
    [formatter1 setLocale:[NSLocale currentLocale]];
    [formatter1 setDateFormat:@"hh:mm a"];
    NSString* trip_time = [formatter1 stringFromDate:date1];

    timeLB.text     = [NSString stringWithFormat:@"%@ at %@",trip_date,trip_time];
    carNameLB.text  = [[tripHistoryArray objectAtIndex:indexPath.row] objectForKey:@"username"];
    rsLB.text       = [NSString stringWithFormat:@"$%@",[[tripHistoryArray objectAtIndex:indexPath.row] objectForKey:@"total_amt"]];
    
    
            return cell;
    }
    else{
        UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ScheduleRideCell"];
        
        if (cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ScheduleRideCell"];
        }
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        UILabel*dateLB           = [cell.contentView viewWithTag:1];
        UILabel*sourceLocLB      = [cell.contentView viewWithTag:2];
        UILabel*destinationLocLB = [cell.contentView viewWithTag:3];
        UIButton*cancelBtn       = [cell.contentView viewWithTag:4];
        UIButton*acceptBtn       = [cell.contentView viewWithTag:5];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [formatter setLocale:[NSLocale systemLocale]];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        NSDate * date = [formatter dateFromString:[[scheduleTripArray objectAtIndex:indexPath.row]objectForKey:@"start_date"]];
        
        
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"EEE dd,MMM"];
        NSString *scheduledate = [df stringFromDate:date];
        
        NSLog(@"hours  %@ ", [df stringFromDate:date]);
        
        
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
        NSDate *date1 = [dateFormatter dateFromString:[[scheduleTripArray objectAtIndex:indexPath.row]objectForKey:@"start_time_from"]];
        
         NSDate * date2 = [dateFormatter dateFromString:[[scheduleTripArray objectAtIndex:indexPath.row]objectForKey:@"start_time_to"]];
        
        dateFormatter.dateFormat = @"hh:mm a";
        NSString *time1 = [dateFormatter stringFromDate:date1];
        NSString *time2 = [dateFormatter stringFromDate:date2];
        
    
        dateLB.text =[NSString stringWithFormat:@"%@ at %@-%@",scheduledate,time1,time2];
        sourceLocLB.text =[NSString stringWithFormat:@"Pickup From: %@",[[scheduleTripArray objectAtIndex:indexPath.row]objectForKey:@"req_location_from"]];
        
        destinationLocLB.text =[NSString stringWithFormat:@"Destination: %@",[[scheduleTripArray objectAtIndex:indexPath.row]objectForKey:@"req_location_to"]];
        
        cancelBtn.tag = indexPath.row;
        acceptBtn.tag = indexPath.row;
        
        if ([[NSString stringWithFormat:@"%@",[[scheduleTripArray objectAtIndex:indexPath.row]objectForKey:@"confirmation_status"]] isEqualToString:@"0"]) {
            acceptBtn.userInteractionEnabled= NO;
            acceptBtn.alpha=0.8;
        }
        else{
            acceptBtn.userInteractionEnabled= YES;
            acceptBtn.alpha=1;
        }
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (tripHistoryBtn.selected == YES) {
    return 220;
     }
     else{
         return 171;
     }
}


#pragma mark 
#pragma mark Button action

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)tripHistoryBtnAction:(UIButton*)sender {
    if (sender.selected ==NO) {
        sender.selected = YES;
        upcomingTriipBtn.selected=NO;
        upcomingV.hidden = YES;
        historyV.hidden = NO;
        [self tripHistoryApiCalling];
        
    }
    
    
}

- (IBAction)upcomingBtnAction:(UIButton*)sender {
    if (sender.selected ==NO) {
        sender.selected = YES;
        tripHistoryBtn.selected=NO;
        upcomingV.hidden = NO;
        historyV.hidden = YES;
        [self scheduleTripApiCalling];
    }
}
- (IBAction)CancelRideaction:(UIButton*)sender {
 
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
                                           
                                           @"user_id"          :[[scheduleTripArray objectAtIndex:sender.tag]objectForKey:@"user_id" ],
                                           @"emp_id"           : GET_USER_ID,
                                           @"request_id"   :  [[scheduleTripArray objectAtIndex:sender.tag]objectForKey:@"request_id" ],
                                           @"confirm_id"   :@"",
                                           @"status"    :@"2"
                                           
                                           
                                           
                                           };
                 
                 NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"confirm_ride.php"];
                 
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
                              
                              [scheduleTripArray removeObjectAtIndex:sender.tag];
                              [tripTV reloadData];
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
- (IBAction)acceptRideAction:(UIButton*)sender {
    GoPassangerVC * view = [self.storyboard instantiateViewControllerWithIdentifier:@"GoPassangerVC"];
    view.acptRideDetailDict = [[NSMutableDictionary alloc] initWithDictionary:[scheduleTripArray objectAtIndex:sender.tag]];
    
    [self.navigationController pushViewController:view animated:YES];

}

#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
