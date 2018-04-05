//
//  LoginCheckVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 6/27/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "LoginCheckVC.h"

@interface LoginCheckVC ()

@end

@implementation LoginCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(goToView) withObject:nil afterDelay:1];
}

- (void) goToView {
    
    if (GET_USER_ID == nil) {
        
        UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyVC"];
        self.view.window.rootViewController = view;
        
    }
    else
    {
        UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
        self.view.window.rootViewController = view;
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
