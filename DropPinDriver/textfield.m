//
//  textfield.m
//  Bolt Rewards
//
//  Created by Ajay Kumar on 2/22/16.
//  Copyright © 2016 Ajay Kumar. All rights reserved.
//

#import "textfield.h"

@implementation textfield

- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
    }
    
    return self;
}

- (void) rightViewRectForBounds :(NSString *)ImageName{
    
    UIImageView *  arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ImageName]];
  // arrow.frame = CGRectMake(0.0, 0.0, 40, 40);
    arrow.contentMode = UIViewContentModeRight;
    
    self.leftView = arrow;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:bottomBorder];
    
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
   
    
    if (self.textFieldDelagate && [self.textFieldDelagate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.textFieldDelagate textFieldDidBeginEditing:textField];
    }
}


- (void) buttomLine{
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.frame.size.width, 1.0f);
    bottomBorder.backgroundColor =[[UIColor blackColor] CGColor];
    [self.layer addSublayer:bottomBorder];
    
}

- (void) bottomGrayLine{
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.frame.size.width, 1.0f);
    bottomBorder.backgroundColor =[[UIColor grayColor] CGColor];
    [self.layer addSublayer:bottomBorder];
    
}

- (void) bottomWhiteLine{
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.frame.size.width, 1.0f);
    bottomBorder.backgroundColor =[[UIColor whiteColor] CGColor];
    [self.layer addSublayer:bottomBorder];
    
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 5, bounds.size.width - 20, bounds.size.height - 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y + 5, bounds.size.width - 20, bounds.size.height - 10);
}

@end
