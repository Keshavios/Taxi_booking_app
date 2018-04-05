//
//  SettingVC.m
//  DropPinDriver
//
//  Created by Ajay Kumar on 6/19/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "SettingVC.h"


@interface SettingVC ()

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark
#pragma mark button action

- (IBAction)backbtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addPaypalBtnaction:(id)sender {
    
}
- (IBAction)addBankaccount:(id)sender {
    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"BankDetailsVC"];
    [self.navigationController pushViewController:view animated:YES];
 
}
- (IBAction)changePswdBtnaction:(id)sender {
    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordVC"];
    [self.navigationController pushViewController:view animated:YES];
}



#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
