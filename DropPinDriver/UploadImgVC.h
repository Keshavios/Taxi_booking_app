//
//  UploadImgVC.h
//  DropPinDriver
//
//  Created by Ajay kumar on 5/31/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadImgVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIButton *takeBtn;
    IBOutlet UIImageView *backImgV;
    IBOutlet UIImageView *frontImgV;
    IBOutlet UIView *licenseV;
    IBOutlet UILabel *titileLB;
    IBOutlet UIImageView *docImageV;
    IBOutlet UILabel *topLB;
    NSData *imgData;
    NSData *imgData1;
    NSString * imgBtn;
}
@property(strong,nonatomic) NSString* itemName;
@end
