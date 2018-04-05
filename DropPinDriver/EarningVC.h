//
//  EarningVC.h
//  DropPinDriver
//
//  Created by Ajay kumar on 5/29/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EarningVC : UIViewController
{
    IBOutlet UIView *graphV;
    
    IBOutlet UILabel *onOfflineLB;
    IBOutlet UISwitch *switchBtn;
    NSMutableArray * Earningarray;
    IBOutlet UILabel *thisWeekLB;
    IBOutlet UILabel *thismonthLB;
}
@end
