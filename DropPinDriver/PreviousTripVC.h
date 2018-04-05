//
//  PreviousTripVC.h
//  DropPinDriver
//
//  Created by Ajay kumar on 5/29/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviousTripVC : UIViewController
{
    IBOutlet UIButton *tripHistoryBtn;
    
    IBOutlet UIView *upcomingV;
    IBOutlet UIButton *upcomingTriipBtn;
    IBOutlet UIView *historyV;
    
    IBOutlet UITableView *tripTV;
    NSMutableArray * tripHistoryArray;
    NSMutableArray *scheduleTripArray;
   
}
@end
