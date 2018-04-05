//
//  UploadImgVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/31/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "UploadImgVC.h"

@interface UploadImgVC ()

@end

@implementation UploadImgVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    topLB.text    = _itemName;
    titileLB.text = _itemName;
    
}

#pragma mark
#pragma mark Button action
- (IBAction)backBtnaction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)takePhotoBtnAction:(id)sender {
    imgBtn = @"photo";
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Update Profie"
                                              message:@"Select Source"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  //  UIAlertController will automatically dismiss the view
                              }];
    
    UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"Take photo"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  //  The user tapped on "Take a photo"
                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                  imagePickerController.delegate = self;
                                  imagePickerController.allowsEditing = YES;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"Choose Existing"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  //  The user tapped on "Choose existing"
                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                  imagePickerController.delegate = self;
                                  imagePickerController.allowsEditing = YES;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController* )picker didFinishPickingMediaWithInfo:(NSDictionary* )info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];

    if ([imgBtn isEqualToString:@"front"]) {
        frontImgV.image = chosenImage;
        imgData  = UIImageJPEGRepresentation(chosenImage, 0.5);

    }
    else if ([imgBtn isEqualToString:@"back"]) {
        backImgV.image = chosenImage;
        imgData1  = UIImageJPEGRepresentation(chosenImage, 0.5);
        
    }else{
        docImageV.image = chosenImage;
        imgData  = UIImageJPEGRepresentation(chosenImage, 0.5);
    }
    
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    AppDelegate * delegate =(AppDelegate*) [UIApplication sharedApplication].delegate;
    if ([_itemName isEqualToString:@"Driver License Front Photo"]) {
        delegate.driverLicenseData     = imgData;
     
    }
    else if ([_itemName isEqualToString:@"Driver License Back Photo"]) {
        
        delegate.driverLicenseBackData = imgData;
    }
    else if ([_itemName isEqualToString:@"Police Verification Certificate"]) {
        delegate.verificationCerData = imgData;
        
    }
    else if ([_itemName isEqualToString:@"Vehicle Permit"]) {
        delegate.vehiclePermitData = imgData;
        
    }
    else if ([_itemName isEqualToString:@"Vehicle Insurance"]) {
        delegate.vehicleInsuranceData = imgData;
        
    }
    else if ([_itemName isEqualToString:@"Registration Certificate"]) {
        delegate.vehicleRegData = imgData;
        
    }else if ([_itemName isEqualToString:@"Driver Photo"]) {
        delegate.driverPhotoData = imgData;
        
    }
    else if ([_itemName isEqualToString:@"Passport/Voter ID/Aadhar Card"]) {
        delegate.IdCardData = imgData;
        
    }

    [self.navigationController popViewControllerAnimated:YES];
   
}
- (IBAction)backimgBtnAction:(id)sender {
    imgBtn = @"back";
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Update Profie"
                                                                   message:@"Select Source"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  //  UIAlertController will automatically dismiss the view
                              }];
    
    UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"Take photo"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  //  The user tapped on "Take a photo"
                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                  imagePickerController.delegate = self;
                                  imagePickerController.allowsEditing = YES;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"Choose Existing"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  //  The user tapped on "Choose existing"
                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                  imagePickerController.delegate = self;
                                  imagePickerController.allowsEditing = YES;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)frontBtnaction:(id)sender {
    imgBtn = @"front";
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Update Profie"
                                                                   message:@"Select Source"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  //  UIAlertController will automatically dismiss the view
                              }];
    
    UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"Take photo"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  //  The user tapped on "Take a photo"
                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                  imagePickerController.delegate = self;
                                  imagePickerController.allowsEditing = YES;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"Choose Existing"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  //  The user tapped on "Choose existing"
                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                  imagePickerController.delegate = self;
                                  imagePickerController.allowsEditing = YES;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
