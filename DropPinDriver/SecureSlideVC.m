//
//  SecureSlideVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/19/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "SecureSlideVC.h"

@interface SecureSlideVC ()

@end

@implementation SecureSlideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.LogoimageV.image   = [UIImage imageNamed:self.imgFile];
    self.titleLB.text       = self.txtTitle;
    self.detailLB.text      = self.detailTitle;
    self.sliderImgV.image   = [UIImage imageNamed:self.slideImgFile
                               ];
}
- (IBAction)next_btnAction:(id)sender {
    
    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"SignInVC"];
   [self.navigationController pushViewController:view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
