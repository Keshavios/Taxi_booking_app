//
//  AccountVC.h
//  DropPinDriver
//
//  Created by Ajay kumar on 5/29/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountVC : UIViewController
{
    
    IBOutlet UILabel *onOfflineLB;
    IBOutlet UIImageView *profileImgV;
    
    IBOutlet UILabel *nameLB;
    
    IBOutlet UILabel *countryLB;
    
    IBOutlet UILabel *ageGroupLB;
    
    IBOutlet UILabel *bioInfoLB;
    IBOutlet UILabel *emailLbl;
    IBOutlet UITableView *accountTV;
    NSMutableArray* accountListArray;
    IBOutlet UISwitch *switchBtn;
    
}
@end
