//
//  SignInVC.h
//  DropPinDriver
//
//  Created by Ajay kumar on 5/17/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInVC : UIViewController
{
    
    IBOutlet UIScrollView *loginSV;
    IBOutlet UIView *innerPV;
    
    IBOutlet UIView *lastView;
    IBOutlet UIButton *sendBtnAction;
    //IBOutlet NSLayoutConstraint *viewHeight;
    IBOutlet NSLayoutConstraint *popUpHeight;
    IBOutlet NSLayoutConstraint *viewHeight;
    IBOutlet UIView *popV;
    IBOutlet textfield *forgotEMailTF;
    IBOutlet UIButton *sendBtn;
    IBOutlet CustomTextFeild *emailTF;
    IBOutlet UIButton *signUpBtn;
IBOutlet CustomTextFeild *passwordTF;
IBOutlet CustomTextFeild *usernameTf;
}
@end
