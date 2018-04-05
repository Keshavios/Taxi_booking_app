//
//  TabBar.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/26/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "TabBar.h"

@interface TabBar ()

@end

@implementation TabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.selectedIndex = 2;
    //[self.tabBar.barTintColor:UIColorFromRGBAlpha(4, 94, 114, 1)];
    
    self.tabBar.barTintColor = [UIColor blackColor];
    
     [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor darkGrayColor],
                                                  }forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithRed:25/255.f green:188/255.f blue:255/255.f alpha:1.0],
            }forState:UIControlStateSelected];
    
    
//    for(UITabBarItem * tabBarItem in self.tabBar.items){
//        tabBarItem.title = @"";
//        tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//    }
    
    
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [self.tabBar.items objectAtIndex:3];
  
    
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"HOME_SELECTED"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem1.image = [[UIImage imageNamed:@"HOME_UNSELECTED"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    tabBarItem2.selectedImage = [[UIImage imageNamed:@"EARNING_SELECTED"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem2.image = [[UIImage imageNamed:@"EARNING_UNSELECTED"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    tabBarItem3.selectedImage = [[UIImage imageNamed:@"RATING_SELECTED"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem3.image = [[UIImage imageNamed:@"RATING_UNSELECTED"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    tabBarItem4.selectedImage = [[UIImage imageNamed:@"ACCOUNT_SELECTED"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem4.image = [[UIImage imageNamed:@"ACCOUNT_UNSELECTED"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
