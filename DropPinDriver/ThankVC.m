//
//  ThankVC.m
//  DropPinDriver
//
//  Created by CqlSys iOS Team on 10/11/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "ThankVC.h"

@interface ThankVC ()

@end

@implementation ThankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)proccedLoginBtn:(id)sender
{
    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"SignInVC"];
    [self.navigationController pushViewController:view animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
