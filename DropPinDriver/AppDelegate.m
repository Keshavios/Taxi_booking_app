//
//  AppDelegate.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/17/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "AppDelegate.h"
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [GMSServices provideAPIKey:@"AIzaSyBtlggMQqMuBRmBsWALvi7v3T-3XIlZo3g"];
    [LocationManager sharedInstance];
    
    
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    NSDictionary *remoteNotification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (remoteNotification)
    {
        
        NSInteger notificationCode = [[remoteNotification objectForKey:@"notification_code"] integerValue];
        if (notificationCode == 112) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appNAME
                                                            message:@"Confirm your ride"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"confirm", nil];
            [alert show];
        }else if(notificationCode == 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BOOKING"  object:nil];
        }
        else if (notificationCode == 111) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CANCELRIDE"  object:nil];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BOOKING"  object:nil];
        }
        
        
        
        
    }
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"deviceToken: %@", deviceToken);
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"DeviceToken"];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSDictionary *userInformation = notification.request.content.userInfo;
    NSInteger notificationCode = [[userInformation objectForKey:@"notification_code"]integerValue];
    if (notificationCode == 112) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appNAME
                                                        message:@"confirm your ride"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"confirm", nil];
        [alert show];
        
    }
    else if(notificationCode == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BOOKING"  object:nil];
    }
    else if (notificationCode == 111) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CANCELRIDE"  object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BOOKING"  object:nil];
    }
    
    
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    completionHandler(UNNotificationPresentationOptionAlert);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
   
    if (buttonIndex == 0) {
        // do something here...
    }
    else{
        [self confirmApicalling];
    }
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void) confirmApicalling{
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
                                       
                                       @"user_id"          : @"",
                                       @"emp_id"           : GET_USER_ID,
                                       @"request_id"   :  [[NSUserDefaults standardUserDefaults]objectForKey:@"request_id"],
                                       @"confirm_id"   :@"",
                                       @"status"    :@"1"
                                       
                                       
                                       
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

@end
