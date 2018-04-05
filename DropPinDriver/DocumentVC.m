//
//  DocumentVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/31/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "DocumentVC.h"
#import "UploadImgVC.h"

@interface DocumentVC ()

@end

@implementation DocumentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    documentTV.tableFooterView   = [[UIView alloc]initWithFrame:CGRectZero];
    sectionArray = [[NSArray alloc] initWithObjects:@"Please upload your personal documents",@"Please upload your vehicle documents",nil];
    personalInfoArray = [[NSArray alloc] initWithObjects:@"Passport/Voter ID/Aadhar Card",@"Driver Photo",nil];
    
    DocumentListarry = [[NSArray alloc] initWithObjects:@"Driver License Front Photo",@"Driver License Back Photo",@"Police Verification Certificate" ,@"Vehicle Permit", @"Vehicle Insurance",@"Registration Certificate",nil];
}
-(void) viewWillAppear:(BOOL)animated{
    [documentTV reloadData];
}

#pragma mark
#pragma mark tableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return [personalInfoArray count];
        
    }
    
    if (section == 1) {
        return [DocumentListarry count];
    }
    
    return 0;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"DocumentCell"];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DocumentCell"];
    }
    
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    UILabel*listLB        = [cell.contentView viewWithTag:1];
    UIImageView *clickImgV= [cell.contentView viewWithTag:2];
    
    
    AppDelegate * delegate =(AppDelegate*) [UIApplication sharedApplication].delegate;
    DriverLicense     = delegate.driverLicenseData;
    verifiCer         = delegate.verificationCerData;
    vehiclePermit     = delegate.vehiclePermitData;
    vehicleInsurance  = delegate.vehicleInsuranceData;
    vehicleReg        = delegate.vehicleRegData;
    DriverPhoto       = delegate.driverPhotoData;
    DriverLicenseBack = delegate.driverLicenseBackData;
    DriverIdCard      = delegate.IdCardData;
    
    clickImgV.image = [UIImage imageNamed:@"ICN_RIGHT_ARROW"];
    listLB.textColor = [UIColor darkGrayColor];

    
    if (indexPath.section ==0) {
        listLB.text           = [personalInfoArray objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            if (DriverIdCard!=nil) {
                clickImgV.image =[UIImage imageNamed:@"RIGHT_CLICK_BTN"];
                listLB.textColor = UIColorFromRGBAlpha(240, 240, 240, 1);
            }
            
        }
        else if (indexPath.row == 1) {
            if (DriverPhoto!=nil){
                clickImgV.image =[UIImage imageNamed:@"RIGHT_CLICK_BTN"];
                listLB.textColor = UIColorFromRGBAlpha(240, 240, 240, 1);
            }
        }
    }
    else{
        listLB.text           = [DocumentListarry objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            if (DriverLicense!=nil) {
                clickImgV.image =[UIImage imageNamed:@"RIGHT_CLICK_BTN"];
                listLB.textColor = UIColorFromRGBAlpha(240, 240, 240, 1);
            }
        }
        else if (indexPath.row == 1) {
            if (DriverLicenseBack!=nil){
                clickImgV.image =[UIImage imageNamed:@"RIGHT_CLICK_BTN"];
                listLB.textColor = UIColorFromRGBAlpha(240, 240, 240, 1);
            }
        }
        else if (indexPath.row == 2) {
            if (verifiCer!=nil){
                clickImgV.image =[UIImage imageNamed:@"RIGHT_CLICK_BTN"];
                listLB.textColor = UIColorFromRGBAlpha(240, 240, 240, 1);
            }
        }
        else if (indexPath.row == 3) {
            if (vehiclePermit!=nil) {
                clickImgV.image =[UIImage imageNamed:@"RIGHT_CLICK_BTN"];
                listLB.textColor = UIColorFromRGBAlpha(240, 240, 240, 1);
            }
        }
        else if (indexPath.row == 4) {
            if (vehicleInsurance!=nil){
                clickImgV.image =[UIImage imageNamed:@"RIGHT_CLICK_BTN"];
                listLB.textColor = UIColorFromRGBAlpha(240, 240, 240, 1);
            }
        }
       else if (indexPath.row == 5) {
            if (vehicleReg!=nil) {
                clickImgV.image =[UIImage imageNamed:@"RIGHT_CLICK_BTN"];
                listLB.textColor = UIColorFromRGBAlpha(240, 240, 240, 1);
            }
            
        }
    
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UploadImgVC *view =[self.storyboard instantiateViewControllerWithIdentifier:@"UploadImgVC"];
    
    if (indexPath.section == 0) {
        
        view.itemName = [personalInfoArray objectAtIndex:indexPath.row];
        
    }
    else{
        
        view.itemName = [DocumentListarry objectAtIndex:indexPath.row];
        
    }
    [self.navigationController pushViewController:view animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *localView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    localView.backgroundColor =UIColorFromRGBAlpha(230, 230, 230, 1);
    UILabel *artistlbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, localView.frame.size.width, 30)];
    //[artistlbl setFont:[UIFont fontWithName:@"" size:16.0]];
    NSString *artistStr = [sectionArray objectAtIndex:section];
    
    if (SCREEN_WIDTH == 320) {
        artistlbl.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
    }else {
        artistlbl.font = [UIFont fontWithName:@"OpenSans-Bold" size:15.0];
    }
    
    [artistlbl setText:artistStr];
    [localView addSubview:artistlbl];
    
    
    UIView *LineV = [[UIView alloc] initWithFrame:CGRectMake(0,localView.frame.size.height-1, localView.frame.size.width, 1)];
    
    LineV.backgroundColor = [UIColor whiteColor];
    [localView addSubview:LineV];
    
    return localView;
}

#pragma mark
#pragma mark button action
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)continueBtnaction:(id)sender {
    AppDelegate * delegate =(AppDelegate*) [UIApplication sharedApplication].delegate;
    DriverLicense     = delegate.driverLicenseData;
    verifiCer         = delegate.verificationCerData;
    vehiclePermit     = delegate.vehiclePermitData;
    vehicleInsurance  = delegate.vehicleInsuranceData;
    vehicleReg        = delegate.vehicleRegData;
    DriverPhoto       = delegate.driverPhotoData;
    DriverLicenseBack = delegate.driverLicenseBackData;
    DriverIdCard      = delegate.IdCardData;
    
    if (DriverPhoto == nil) {
        ALERTVIEW(@"please add Driver Photo", self);
        return;
    }
    else if (DriverLicense == nil) {
        ALERTVIEW(@"please add Front Photo of License", self);
        return;
    }
    else if (DriverLicenseBack == nil) {
        ALERTVIEW(@"please add back Photo of License", self);
        return;
    }///
    else if (vehicleReg == nil) {
        ALERTVIEW(@"please add photo of Registration Certificate", self);
        return;
    }
    else if (vehicleInsurance == nil) {
        ALERTVIEW(@"please add Photo of License", self);
        return;
    }
    else if (verifiCer == nil) {
        ALERTVIEW(@"please add Photo of Vehicle Insurance", self);
        return;
    }
    else if (vehiclePermit == nil) {
        ALERTVIEW(@"please add Photo of Vehicle Permit", self);
        return;
    }
    else if (DriverIdCard == nil) {
        ALERTVIEW(@"please add Photo of Passport/Voter ID/Aadhar Card", self);
        return;
    }
    
    
    [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
     {
         SHOW_PROGRESS(@"Please Wait..");
         if (responseObject == false)
         {
             HIDE_PROGRESS;
             
             ALERTVIEW( @"Internet Connection not Available!", self);
         }
         else
         {
             
             NSDictionary * params = @{
                                       @"emp_id" :GET_USER_ID
                                       
                                       };
             NSMutableDictionary * imgDict= [[NSMutableDictionary alloc]init];
             
             [imgDict setObject:DriverPhoto forKey:@"emp_image"];
             [imgDict setObject:DriverLicense forKey:@"emp_license_front_img"];
             [imgDict setObject:DriverLicenseBack forKey:@"emp_license_back_img"];
             [imgDict setObject:verifiCer forKey:@"police_varification"];
             [imgDict setObject:vehicleReg forKey:@"vehicle_registration"];
             [imgDict setObject:vehicleInsurance forKey:@"vehicle_insurance"];
             [imgDict setObject:vehiclePermit forKey:@"vehicle_permit"];
             [imgDict setObject:vehiclePermit forKey:@"vehicle_permit"];
             [imgDict setObject:DriverIdCard forKey:@"driver_identity_image"];
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"document_emp.php"];
             
             [[ApiManager  sharedInstance] apiCallWithImage:urlString parameterDict:params imageDataDictionary:imgDict CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
                 
                 HIDE_PROGRESS;
                 if (success == false)
                 {
                     ALERTVIEW(message, self);
                 }
                 else
                 {
                     if ([Util checkIfSuccessResponse:dictionary])
                     {
                         
                         UIAlertController *alertController = [UIAlertController
                                                               alertControllerWithTitle:@""
                                                               message:@"Document update successfully,Please wait for admin approve."
                                                               preferredStyle:UIAlertControllerStyleAlert];
                         
                         UIAlertAction *okAction = [UIAlertAction
                                                    actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action)
                                                    {
                                                        UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"AddBankVC"];
                                                     
                                                        [self.navigationController pushViewController:view animated:NO];
                                                        
                                                    }];
                         
                         [alertController addAction:okAction];
                         
                         [self presentViewController:alertController animated:YES completion:nil];
                         
                         
                         
                         
                     }
                     else
                     {
//                         ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
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
         
     }];
    
}



#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
