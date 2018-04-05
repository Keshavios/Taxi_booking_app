//
//  PaymentHistoryVC.h
//  DropPinDriver
//
//  Created by Ajay kumar on 6/20/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewWithdrawVC.h"
@interface PaymentHistoryVC : UIViewController
{
    IBOutlet UITableView *historyTV;
    NSMutableArray * Earingarray;
    NSArray *sectionArr;
    NSMutableArray *transtionArray;
    NSMutableArray *selectedArray;
    int selectedIndex;
    NSArray *withdrawArray;
  
}
@end
