//
//  StartVC.h
//  DropPinDriver
//
//  Created by Ajay kumar on 5/19/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecureSlideVC.h"
@interface StartVC : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) UIPageViewController *SecureSlideVC;
@property (nonatomic,strong) NSArray *arrPageTitles;
@property (nonatomic,strong) NSArray *arrPageImages;
@property (nonatomic,strong) NSArray *arrdetail;
@property (nonatomic,strong) NSArray *arrPageMoveImages;
- (SecureSlideVC *)viewControllerAtIndex:(NSUInteger)index;

@end
