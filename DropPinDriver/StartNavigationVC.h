//
//  StartNavigationVC.h
//  DropPinDriver
//
//  Created by Ajay kumar on 6/6/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
@interface StartNavigationVC : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,MKAnnotation,GMSMapViewDelegate>
{
    IBOutlet MKMapView *mapView;
//    NSString *lat;
//    NSString *lng;
    IBOutlet UIView *mapV;
    CLLocation *newlocation;
    NSString *toAddressString;
    NSDictionary *dictRouteInfo;
    NSString *userdestination;
    double destLati;
    double destLongi;
    double sourceLatt;
    double sourceLong;
    MKCoordinateSpan span;
//    NSString * destinationLat;
//    NSString*destinationLng;
    
    /// user detail ///
    
    IBOutlet UILabel *estimationcostLB;
    IBOutlet UILabel *userLocationLB;
    IBOutlet UIView *UserInfoV;
    IBOutlet UIImageView *userImgV;
    IBOutlet UILabel *userNameLB;
    NSString *phNo;
    NSString * contactno;
    
}
@property (strong, nonatomic) IBOutlet UIButton *stopRidebtn;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(strong,nonatomic) NSDictionary * DetailDict;
@property (nonatomic, retain) NSArray *wayPoints;
@property (nonatomic, retain) NSString *startPoint;
@property (nonatomic, retain) NSString *endPoint;


@end
