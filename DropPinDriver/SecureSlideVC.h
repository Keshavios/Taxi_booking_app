//
//  SecureSlideVC.h
//  DropPinDriver
//
//  Created by Ajay kumar on 5/19/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecureSlideVC : UIViewController
@property NSUInteger pageIndex;
@property NSString *imgFile;
@property NSString *txtTitle;
@property NSString *detailTitle;
@property NSString *slideImgFile;
@property (strong, nonatomic) IBOutlet UIImageView *sliderImgV;

@property (strong, nonatomic) IBOutlet UILabel *detailLB;

@property (strong, nonatomic) IBOutlet UILabel *titleLB;
@property (strong, nonatomic) IBOutlet UIImageView *LogoimageV;
@end
