//
//  LocationManager.h
//  Zippy
//
//  Created by Ajay CQL on 22/04/16.
//  Copyright © 2016 cqlsys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) CLLocation *currentLocation;

+ (instancetype)sharedInstance;
-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr;
@end
