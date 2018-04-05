//
//  VerifyVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/17/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "VerifyVC.h"

@interface VerifyVC ()

@end

@implementation VerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VERIFYIDENTITY_BTN.layer.cornerRadius = 20;
    VERIFYIDENTITY_BTN.clipsToBounds = YES;
    // Do any additional setup after loading the view.
}
- (IBAction)learn_btmnaction:(id)sender {
    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"StartVC"];
    [self.navigationController pushViewController:view animated:YES];
}
- (IBAction)verifyBtnAction:(id)sender {
    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"SignInVC"];
    [self.navigationController pushViewController:view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
