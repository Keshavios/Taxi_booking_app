//
//  DSBarChart.m
//  DSBarChart
//
//  Created by DhilipSiva Bijju on 31/10/12.
//  Copyright (c) 2012 Tataatsu IdeaLabs. All rights reserved.
//

#import "DSBarChart.h"

@implementation DSBarChart
@synthesize color, numberOfBars, maxLen, refs, vals,diff;

-(DSBarChart *)initWithFrame:(CGRect)frame
                       color:(UIColor *)theColor
                  references:(NSArray *)references
                   difference:(NSArray *)difference
                   andValues:(NSArray *)values
{
    self = [super initWithFrame:frame];
    if (self) {
        self.color = theColor;
        self.vals = values;
        self.refs = references;
         self.diff= difference;
    }
    return self;
}

-(void)calculate{
    self.numberOfBars = [self.refs count];
    for (NSNumber *val in vals) {
        float iLen = [val floatValue];
        if (iLen > self.maxLen) {
            self.maxLen = iLen;
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    /// Drawing code
    [self calculate];
    float rectWidth = (float)(rect.size.width-(self.numberOfBars)-40) / (float)self.numberOfBars;
    CGContextRef context = UIGraphicsGetCurrentContext();
    float LBL_HEIGHT = 20.0f, iLen, x, heightRatio, height, y;
    UIColor *iColor ;
    
    /// Draw Bars
    for (int barCount = 0; barCount < self.numberOfBars; barCount++) {
        
        /// Calculate dimensions
        iLen = [[vals objectAtIndex:barCount] floatValue];
        x = barCount * (rectWidth);
        heightRatio = iLen / self.maxLen;
        height = heightRatio * rect.size.height;
        if (height < 0.1f) height = 1.0f;
        y = rect.size.height - height - LBL_HEIGHT;
        
        UILabel *sidelblRef = [[UILabel alloc] initWithFrame:CGRectMake(0,barCount*50, rectWidth, LBL_HEIGHT)];
        sidelblRef.text = [diff objectAtIndex:barCount];
        sidelblRef.adjustsFontSizeToFitWidth = TRUE;
        sidelblRef.adjustsLetterSpacingToFitWidth = TRUE;
        sidelblRef.textColor = self.color;
        sidelblRef.font = [UIFont fontWithName:@"SystemFont" size:10];
        [sidelblRef setTextAlignment:NSTextAlignmentCenter];
        sidelblRef.backgroundColor = [UIColor clearColor];
        [self addSubview:sidelblRef];
        
        /// Reference Label.
        UILabel *lblRef = [[UILabel alloc] initWithFrame:CGRectMake(barCount + x+sidelblRef.frame.size.width, rect.size.height - LBL_HEIGHT, rectWidth, LBL_HEIGHT)];
        lblRef.text = [refs objectAtIndex:barCount];
        lblRef.adjustsFontSizeToFitWidth = TRUE;
        lblRef.adjustsLetterSpacingToFitWidth = TRUE;
        lblRef.textColor = self.color;
        [lblRef setTextAlignment:NSTextAlignmentCenter];
        lblRef.backgroundColor = [UIColor clearColor];
        [self addSubview:lblRef];
        
        /// Set color and draw the bar
        
        
        iColor = [UIColor greenColor];
        CGContextSetFillColorWithColor(context, iColor.CGColor);
        CGRect barRect = CGRectMake(barCount + x+sidelblRef.frame.size.width, y, rectWidth, height);
        CGContextFillRect(context, barRect);
    }
    
    /// pivot
    
}


@end
