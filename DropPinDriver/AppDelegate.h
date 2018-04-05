//
//  AppDelegate.h
//  DropPinDriver
//
//  Created by Ajay kumar on 5/17/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSData* driverLicenseData;
@property (strong, nonatomic) NSData* verificationCerData;
@property (strong, nonatomic) NSData* vehiclePermitData;
@property (strong, nonatomic) NSData* vehicleInsuranceData;
@property (strong, nonatomic) NSData* vehicleRegData;
@property (strong, nonatomic) NSData* driverPhotoData;
@property (strong, nonatomic) NSData* driverLicenseBackData;
@property (strong, nonatomic) NSData* IdCardData;
@end

