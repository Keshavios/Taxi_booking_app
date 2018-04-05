//
//  EditProfileVC.h
//  DropPinDriver
//
//  Created by Ajay Kumar on 6/19/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileVC : UIViewController
{
    IBOutlet UIButton *saveBtn;
    IBOutlet textfield *nameTf;
    IBOutlet textfield *countryTF;
    IBOutlet textfield *phoneTF;
    IBOutlet textfield *emailTF;
    NSData *imgData;
    IBOutlet UIImageView *userImgV;
}
@end
