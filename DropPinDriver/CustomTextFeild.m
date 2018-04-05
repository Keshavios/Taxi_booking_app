//
//  CustomTextFeild.m
//  Droppin
//
//  Created by Ajay kumar on 5/12/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "CustomTextFeild.h"

@implementation CustomTextFeild

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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

- (void) buttomLine{
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.frame.size.width, 1.0f);
    bottomBorder.backgroundColor =[[UIColor blackColor] CGColor];
    [self.layer addSublayer:bottomBorder];
    
}
- (void) bottomWhiteLine{
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.frame.size.width, 1.0f);
    bottomBorder.backgroundColor =[[UIColor whiteColor] CGColor];
    [self.layer addSublayer:bottomBorder];
    
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 80, bounds.origin.y + 5, bounds.size.width - 20, bounds.size.height - 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 80, bounds.origin.y + 5, bounds.size.width - 20, bounds.size.height - 10);
}

@end
