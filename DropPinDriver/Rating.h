//
//  Rating.h
//  DropPinDriver
//
//  Created by Ajay kumar on 5/29/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Rating : UIViewController
{
    IBOutlet UIButton *ratingBtn;
    
    IBOutlet UILabel *tripCancelLB;
    IBOutlet UILabel *requestLB;
    IBOutlet UILabel *CurrentRatingLB;
    IBOutlet UILabel *onofflineLB;
    IBOutlet UITableView *ratingTV;
    NSMutableArray *MainTitleArray;
    NSMutableArray *reviewArray;
    IBOutlet UISwitch *switchBtn;
}
@end
