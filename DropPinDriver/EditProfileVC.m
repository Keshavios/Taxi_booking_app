//
//  EditProfileVC.m
//  DropPinDriver
//
//  Created by Ajay Kumar on 6/19/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "EditProfileVC.h"

@interface EditProfileVC ()

@end

@implementation EditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userImgV.layer.cornerRadius = userImgV.frame.size.width/2;
    userImgV.clipsToBounds = YES;
    
    NSDictionary * userInfo =[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    nameTf.text    =[userInfo objectForKey:@"username"];
    phoneTF.text   =[userInfo objectForKey:@"emp_mobile"];
    emailTF.text   =[userInfo objectForKey:@"emp_email"];
    
    [userImgV setImageWithURL:[NSURL URLWithString:[userInfo objectForKey:@"emp_image"]] placeholderImage:[UIImage imageNamed:@"PROFILE_IMG"]];
    
    saveBtn.layer.cornerRadius = 20;
    saveBtn.clipsToBounds = YES;

}
-(void)viewDidAppear:(BOOL)animated{
    [nameTf buttomLine];
    [countryTF buttomLine];
    [emailTF buttomLine];
    [phoneTF buttomLine];

}

#pragma mark
#pragma mark button action
- (IBAction)backBtnaction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveBtnaction:(id)sender {
    NSDictionary * params = @{
                              @"auth_token": [[NSUserDefaults standardUserDefaults]  objectForKey:@"auth_token"],
                              @"emp_id"   : GET_USER_ID,
                              @"username":nameTf.text,
                              @"emp_email":emailTF.text,
                              @"emp_mobile" :phoneTF.text
                              };
    NSMutableDictionary *imgDict = [[NSMutableDictionary alloc] init];
    if (imgData != nil) {
        [imgDict setObject:imgData forKey:@"emp_image"];
        
    }
    
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"emp_update_profile.php"];
    
    [[ApiManager  sharedInstance] apiCallWithImage1:urlString parameterDict:params imageDataDictionary:imgDict CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        HIDE_PROGRESS;
        if (success == false)
        {
            ALERTVIEW( @"Edit Profile Unsucessful", self);
        }
        else
        {
            if ([Util checkIfSuccessResponse:dictionary])
            {
                [[NSUserDefaults standardUserDefaults] setObject:[dictionary objectForKey:@"body"] forKey:@"userInfo"];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }
            else
            {
//                ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
                if ([[[dictionary objectForKey:@"status"] objectForKey:@"message"] isEqualToString:@"Authentication Token does not match"]) {
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:@""
                                                          message:[[dictionary objectForKey:@"status"] objectForKey:@"message"]
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action)
                                               {
                                                   SET_USER_ID(nil);
                                                   UIViewController *view  = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyVC"];
                                                   self.view.window.rootViewController    = view;
                                                   
                                               }];
                    
                    [alertController addAction:okAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }

            }
        }
        
    }];

}
#pragma mark
#pragma markbutton action

- (IBAction)editImgBtnAction:(id)sender {
    
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    userImgV.image = chosenImage;
    imgData = UIImageJPEGRepresentation(chosenImage, 0.5);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
