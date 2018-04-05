//
//  SignUpVC.h
//  DropPinDriver
//
//  Created by Ajay kumar on 5/17/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpVC : UIViewController
{
    NSArray * cityArr;
    IBOutlet UIButton *signInBtn;
    IBOutlet NSLayoutConstraint *viewHeight;
    IBOutlet textfield *yearTF;
    IBOutlet textfield *modelTF;
    IBOutlet UIButton *termBtn;
    IBOutlet textfield *makeTF;
    IBOutlet textfield *vehicleNumberTF;
    IBOutlet NSLayoutConstraint *containerConstraint;
    IBOutlet CustomTextFeild *phoneNoTF;
    IBOutlet textfield *inviteCodeTF;
    IBOutlet textfield *cityTF;
    IBOutlet textfield *passwordTF;
    IBOutlet textfield *emailTF;
    IBOutlet textfield *fullNameTF;
    IBOutlet UILabel *countryCode;
    NSString *lat;
    NSString *lng;
    IBOutlet UIButton *conditionBtnAction;
}

@end
