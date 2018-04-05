//
//  WithdrawVC.h
//  DropPinDriver
//
//  Created by CqlSys iOS Team on 15/11/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawVC : UIViewController
{
    IBOutlet UILabel *totalBalLBL;
    IBOutlet UITextField *amtTF;
    IBOutlet UIButton *withdrawAmtBt;
    NSString * totalAmt;
}
@end
