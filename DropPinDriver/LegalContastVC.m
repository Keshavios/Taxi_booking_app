//
//  LegalContastVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/19/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "LegalContastVC.h"

@interface LegalContastVC ()

@end

@implementation LegalContastVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)acceptBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)signoutBtnAction:(id)sender {
    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"SignInVC"];
    [self.navigationController pushViewController:view animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
