//
//  HomeVC.h
//  DropPinDriver
//
//  Created by Ajay kumar on 5/29/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
@interface HomeVC : UIViewController<GMSMapViewDelegate>
{
    IBOutlet UILabel *totalAmountLB;
    IBOutlet UILabel *tripLB;
    IBOutlet UILabel *hoursLB;
    IBOutlet UITableView *requestTV;
    IBOutlet UITextView *discTV;
    IBOutlet UILabel *popFirstLB;
    
    IBOutlet UILabel *popThirdLB;
    IBOutlet UILabel *popSecondLB;
    IBOutlet UIView *mapV;
    IBOutlet UILabel *onOfflineLB;
    IBOutlet UISwitch *switchBtn;
    IBOutlet UIView *popupV;
    IBOutlet NSLayoutConstraint *bottomConstrains;
    IBOutlet UIButton *arrowBtn;
      GMSMapView *mapView_;
    NSString *lat;
    NSString *lng;
    IBOutlet UIView *footerV;
    IBOutlet UIView *finishPV;
    IBOutlet UIView *innerV;
    NSMutableArray * requestArray;
    NSMutableDictionary * footerdict;
    NSString * requestId ;
    
    NSMutableDictionary *ridedetail;
    
    IBOutlet UILabel  *costLB;
    
    
}
@end
