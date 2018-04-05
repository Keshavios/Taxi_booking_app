//
//  SignUpVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/17/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "SignUpVC.h"
#import "OtpVC.h"
@interface SignUpVC ()
{
    
    IBOutlet textfield *blomfonteinTF;
    IBOutlet textfield *lastnameTF;
}
@end

@implementation SignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *color  = [UIColor whiteColor];
    
    fullNameTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{ NSForegroundColorAttributeName : color }];
    passwordTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName : color }];
    phoneNoTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Please fill number" attributes:@{ NSForegroundColorAttributeName : color }];
    emailTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName : color }];
    cityTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Address" attributes:@{ NSForegroundColorAttributeName : color }];
    inviteCodeTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"(Optional)Invite Code" attributes:@{NSForegroundColorAttributeName : color }];
    blomfonteinTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"City" attributes:@{ NSForegroundColorAttributeName : color }];
    lastnameTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Lastname" attributes:@{NSForegroundColorAttributeName : color }];
    makeTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Make" attributes:@{NSForegroundColorAttributeName : color }];
    modelTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Model" attributes:@{ NSForegroundColorAttributeName : color }];
    yearTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Year" attributes:@{NSForegroundColorAttributeName : color }];
    vehicleNumberTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Vehicle number" attributes:@{NSForegroundColorAttributeName : color }];
    
    
       
    UIPickerView * cityPicker = [[UIPickerView alloc] init];
    [cityPicker setDataSource: self];
    [cityPicker setDelegate: self];
    cityPicker.backgroundColor = UIColorFromRGBAlpha(240, 240, 240, 1);
    cityPicker.showsSelectionIndicator = YES;
    cityPicker.tag = 1;
    blomfonteinTF.inputView = cityPicker;
    
    cityArr = [[NSArray alloc] initWithObjects:@"Blomfontein",@"cape-town",@"Durban",@"East London",@"Johannesburg",@"Port Elizabeth",@"Queenstown",@"Worcester", nil];
  //  containerConstraint.constant = 230;
    
    conditionBtnAction.layer.cornerRadius = 25;
    conditionBtnAction.clipsToBounds = YES;
}

-(void)viewDidLayoutSubviews
{
    viewHeight.constant = signInBtn.frame.origin.y+ signInBtn.frame.size.height +20;
   // popUpHeight.constant = sendBtn.frame.origin.y+ sendBtn.frame.size.height +20;
}

-(void)viewDidAppear:(BOOL)animated
{
    [fullNameTF bottomWhiteLine];
    [emailTF bottomWhiteLine];
    [lastnameTF bottomWhiteLine];
    [blomfonteinTF bottomWhiteLine];
    [phoneNoTF bottomWhiteLine];
    [passwordTF bottomWhiteLine];
    [cityTF bottomWhiteLine];
    [inviteCodeTF bottomWhiteLine];
    [makeTF bottomWhiteLine];
    [modelTF bottomWhiteLine];
    [yearTF bottomWhiteLine];
    [vehicleNumberTF bottomWhiteLine];
}
-(void)viewWillAppear:(BOOL)animated{
    lat = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]];
    lng = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]];
    if (lat == nil) {
        lat = @"0.00";
        
    }
    if (lng == nil) {
        lng = @"0.00";
    }

}
#pragma mark
#pragma mark button action
- (IBAction)continueBtnAction:(id)sender {
   if (termBtn.selected == NO) {
        ALERTVIEW(@"Please accept term and service", self);
        return;
    }
    if ([fullNameTF.text  isEqualToString:@""]){
        ALERTVIEW(@"Please Enter Fullname", self);
        return;
    }else if ([emailTF.text  isEqualToString:@""]){
        ALERTVIEW(@"Please Enter Email", self);
        return;
    }else if ([phoneNoTF.text  isEqualToString:@""]){
        ALERTVIEW(@"Please Enter Mobile Number", self);
        return;
    }else if ([passwordTF.text  isEqualToString:@""]){
        ALERTVIEW(@"Please Enter Password", self);
        return;
    }else if ([cityTF.text  isEqualToString:@""]){
        ALERTVIEW(@"Please Enter Your City", self);
        return;
    }
    else if(![Util ValidateEmailString:emailTF.text]){
        ALERTVIEW(@"Please enter Valid email", self);
        return;
        
    }
    else if ([modelTF.text  isEqualToString:@""]){
        ALERTVIEW(@"Please Enter Vehicle model", self);
        return;
    }else if ([makeTF.text  isEqualToString:@""]){
        ALERTVIEW(@"Please Enter Make", self);
        return;
    }
    else if([yearTF.text isEqualToString:@""]){
        ALERTVIEW(@"Please Enter year", self);
        return;
        
    }
    else if([vehicleNumberTF.text isEqualToString:@""]){
        ALERTVIEW(@"Please Enter Vehicle number", self);
        return;
        
    }else
    {
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
                 NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
                 if (token == nil || [token isEqualToString:@""])
                 {
                     token = @"123456789";
                 }
                 
                 NSDictionary * params = @{
                                           @"username"     : fullNameTF.text,
                                           @"emp_mobile"   : phoneNoTF.text,
                                           @"mobile_code"  : countryCode.text,
                                           @"emp_email"    :emailTF.text,
                                           @"emp_password" :passwordTF.text,
                                           @"name"         :fullNameTF.text,
                                           @"surename"         :lastnameTF.text,
                                           @"physical_address"         :cityTF.text,
                                           @"description"  :@"",
                                           @"latitude":lat,
                                           @"longitude":lng,
                                           @"device_token":token,
                                           @"device_type":@"2",
                                           @"invite_code":inviteCodeTF.text,
                                           @"reference_code":@"",
                                           @"emp_location": blomfonteinTF.text,
                                           @"model_year":yearTF.text,
                                           @"model_no":makeTF.text,
                                           @"model_name": modelTF.text,
                                           @"vehicle_number": vehicleNumberTF.text
                                           };
                 
                 NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"driver_signup.php"];
                 
                 [[ApiManager  sharedInstance] apiCall:urlString postDictionary:params CompletionBlock:^(BOOL success, NSString*  message, NSDictionary*  dictionary)
                  {
                      HIDE_PROGRESS;
                      if (success == false)
                      {
                          ALERTVIEW(message, self);
                      }
                      else
                      {
                          if ([Util checkIfSuccessResponse:dictionary])
                          {
                              SET_USER_ID([[dictionary  objectForKey:@"body"] objectForKey:@"emp_id"]);
                              OtpVC*view =[self.storyboard instantiateViewControllerWithIdentifier:@"OtpVC"];
                             
                              [self.navigationController pushViewController:view animated:YES];
                              
                          }
                          else
                          {
//                              ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
                              if ([[[dictionary objectForKey:@"status"] objectForKey:@"message"] isEqualToString:@"auth_token does not match"]) {
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
                                                                 UIViewController *view  = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
                                                                 self.view.window.rootViewController = view;

                                                                 
                                                             }];
                                  
                                  [alertController addAction:okAction];
                                  
                                  [self presentViewController:alertController animated:YES completion:nil];
                              }
                              else
                              {
                                  
                                  ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
                              }
                          }
                          
                      }
                      
                  }];
             }
             
         }];
        
    }

    
}

- (IBAction)signInBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)tearmBtnAction:(UIButton*)sender {
    
    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"LegalContastVC"];
    [self.navigationController pushViewController:view animated:YES];
}
- (IBAction)selectTermBtn:(UIButton*)sender {
    if (sender.selected ==NO) {
        sender.selected =YES;
    }
    else{
        sender.selected = NO;
    }
    
}



#pragma mark
#pragma mark picker view delegates

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
return [cityArr count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    blomfonteinTF.text  = [cityArr objectAtIndex:row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [cityArr objectAtIndex:row];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    
    UIView  * PickerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 30)];
    UILabel * PickerLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, pickerView.frame.size.width, 20)];
    PickerLbl.textAlignment = NSTextAlignmentCenter;
    PickerLbl.text = [cityArr objectAtIndex:row];
    [PickerView addSubview:PickerLbl];
     return PickerView;
}



#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
