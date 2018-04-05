//
//  WelComeVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/17/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "WelComeVC.h"

@interface WelComeVC ()

@end

@implementation WelComeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)continueBtnAction:(id)sender {
    
    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"DocumentVC"];
    [self.navigationController pushViewController:view animated:YES];
}
- (IBAction)signoutBtnAction:(id)sender {
    
    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"SignInVC"];
    [self.navigationController pushViewController:view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
