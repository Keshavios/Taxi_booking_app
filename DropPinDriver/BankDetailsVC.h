//
//  BankDetailsVC.h
//  DropPinDriver
//
//  Created by Ajay Kumar on 6/19/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankDetailsVC : UIViewController
{
    IBOutlet textfield *ifscCodeTF;
    IBOutlet textfield *accountNoTF;
    IBOutlet textfield *nameTF;
    IBOutlet textfield *phoneNoTF;
    IBOutlet textfield *palpalIDTF;
    IBOutlet textfield *amountTF;
    NSString * urlStringStr;
    IBOutlet UIButton *submitBtn;
   
    __weak IBOutlet UILabel *bankDetailLBL;
    IBOutlet textfield *bankNameTF;
  //  IBOutlet UIButton *submitBtn;
    NSString *currentDate;
    }

@property(strong,nonatomic) NSString * PaymentType;
@end
