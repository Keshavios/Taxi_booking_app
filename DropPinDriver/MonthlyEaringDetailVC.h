//
//  MonthlyEaringDetailVC.h
//  DropPinDriver
//
//  Created by Ajay kumar on 6/20/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthlyEaringDetailVC : UIViewController{
    NSMutableArray *weekhistoryarray;
    
    IBOutlet UILabel *monthnameLB;
}
@property (strong, nonatomic) IBOutlet UITableView *earningDetailTV;
@property(strong,nonatomic) NSString * month;
@end
