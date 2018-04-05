//
//  textfield.h
//  Bolt Rewards
//
//  Created by Ajay Kumar on 2/22/16.
//  Copyright © 2016 Ajay Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface textfield : UITextField
@property (nonatomic, assign) id<UITextFieldDelegate> textFieldDelagate;
- (void) rightViewRectForBounds :(NSString *)ImageName;
- (void) buttomLine;
- (void) bottomGrayLine;
-(void)bottomWhiteLine;

@end
