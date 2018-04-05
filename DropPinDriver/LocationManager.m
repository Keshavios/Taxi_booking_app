//
//  LocationManager.m
//  Zippy
//
//  Created by Ajay CQL on 22/04/16.
//  Copyright © 2016 cqlsys. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

- (id) init
{
    self = [super init];
    
    if (self != nil)
    {
        [self locationManager];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static LocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LocationManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void) locationManager
{
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
    }
    else{
        
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be showing past informations. To enable, Settings->Location->location services->on" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"Continue",nil];
        [servicesDisabledAlert show];
        [servicesDisabledAlert setDelegate:self];
    }
}

- (void)requestWhenInUseAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertViews = [[UIAlertView alloc] initWithTitle:title
                                                             message:message
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"Settings", nil];
        [alertViews show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestWhenInUseAuthorization];
    }
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//       [errorAlert show];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            // do some error handling
        }
            break;
        default:{
            [locationManager startUpdatingLocation];
        }
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        [geocoder reverseGeocodeLocation:newLocation
                       completionHandler:^(NSArray * placemarks, NSError * error) {
                           
                           if (error) {
                               
                               NSLog(@"Geocode failed with error: %@", error);
                               return;
                           }
                           if (placemarks && placemarks.count > 0)
                           {
                               
                               CLPlacemark *placemark = placemarks[0];
                               double lat = placemark.location.coordinate.latitude;
                               double lng = placemark.location.coordinate.longitude;
                               
                            NSDictionary *addressDictionary = placemark.addressDictionary;
                               
                               NSLog(@"%@", addressDictionary);
                               
                               [[NSUserDefaults standardUserDefaults] setObject:[[addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "] forKey:@"location"];
                             
                               
                               //[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",lat] forKey:@"CurrentCity"];
                               [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",lat] forKey:@"latitude"];
                               [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%f",lng] forKey:@"longitude"];
                               
                               [[NSUserDefaults standardUserDefaults]synchronize];
                               
                           }
                       }];
        if(GET_USER_ID != nil){
            dispatch_group_t group = dispatch_group_create();
            
            
            NSMutableArray *URLArray = [[NSMutableArray alloc] init];
            [URLArray addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@emp_id=%@&auth_token=%@&latitude=%@&longitude=%@",appURL,@"emp_update_loc.php?",GET_USER_ID,[[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"],[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]]]];
            
            //[URLArray addObject:[NSURL URLWithString:@"http://202.164.42.226/staging/bb-event-app/stripperBars/listing"]];
            for (NSURL *URL in URLArray) {
                dispatch_group_enter(group);
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
                
                // configure the request here
                
                // now issue the request
                
                NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
                    // check error and/or handle response here
                    
                    // when all done, leave group
                    
                    dispatch_group_leave(group);
                }];
                [task resume];
            }
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                // do whatever you want when all of the requests are done
            });
             //[self performSelectorInBackground:@selector(UpdateLocation)withObject:nil];
        }
       
      //  locationManager = nil;
     //   [locationManager stopUpdatingLocation];
        
    }
}

-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
    
}
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    
//    CLLocation *location;
//    location =  [manager location];
//    CLLocationCoordinate2D coordinate = [location coordinate];
//    _currentLocation = [[CLLocation alloc] init];
//    _currentLocation = newLocation;
//    _longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
//    _latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
//    
//    
//    //    globalObjects.longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
//    //    globalObjects.latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
//}


@end
