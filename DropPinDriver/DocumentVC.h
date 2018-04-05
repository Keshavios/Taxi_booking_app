//
//  DocumentVC.h
//  DropPinDriver
//
//  Created by Ajay kumar on 5/31/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentVC : UIViewController
{
    
    IBOutlet UITableView *documentTV;
    NSArray *DocumentListarry;
    NSData* DriverLicense;
    NSData* verifiCer;
    NSData* vehiclePermit;
    NSData* vehicleInsurance;
    NSData* vehicleReg;
    NSData* DriverPhoto;
    NSData* DriverLicenseBack;
     NSData* DriverIdCard;
    NSArray * sectionArray;
    NSArray * personalInfoArray;
}
@end
