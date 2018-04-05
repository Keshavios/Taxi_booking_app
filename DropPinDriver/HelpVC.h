//
//  HelpVC.h
//  DropPinDriver
//
//  Created by Ajay Kumar on 6/19/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpVC : UIViewController
{
    IBOutlet textfield *subjectTF;
    
    IBOutlet UIButton *sendBtn;
    IBOutlet UITextView *msgTV;
    IBOutlet textfield *emailTf;
    IBOutlet textfield *nameTF;
    NSString *currentDate;
      NSString *phNo;
}
@end
