//
//  LeftMenuVC.h
//  DropPinDriver
//
//  Created by Ajay kumar on 5/30/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuVC : UIViewController<UIGestureRecognizerDelegate>
{
    IBOutlet UIImageView *userImgV;
    IBOutlet UILabel *nameLB;
    IBOutlet UITableView *menuTV;
    NSArray *menuArray;
    int selectedIndex;
    LeftMenuVC *middleVC ;
    IBOutlet UILabel *ratingLB;
}
@end
