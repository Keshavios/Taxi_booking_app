//
//  StartTripVC.h
//  DropPinDriver
//
//  Created by Ajay kumar on 6/6/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
@interface StartTripVC : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,MKAnnotation,GMSMapViewDelegate>
    {
        
        IBOutlet MKMapView *mapView;
        NSString *lat;
        NSString *lng;
        IBOutlet UIView *mapV;
        CLLocation *newlocation;
        NSString *toAddressString;
        NSDictionary *dictRouteInfo;
        NSString *userdestination;
        double newLong ;
        double newlatt ;
        MKCoordinateSpan span;
    }
    @property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
    @property(strong,nonatomic) NSDictionary * RideDetailDict;
    @property (nonatomic, retain) NSArray *wayPoints;
    @property (nonatomic, retain) NSString *startPoint;
    @property (nonatomic, retain) NSString *endPoint;

@end
