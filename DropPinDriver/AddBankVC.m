//
//  AddBankVC.m
//  DropPinDriver
//
//  Created by CqlSys iOS Team on 10/11/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "AddBankVC.h"

@interface AddBankVC ()
{
    NSArray*bankArr;
}
@end

@implementation AddBankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIColor *color  = [UIColor whiteColor];
    
    nameTf.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Holder Name" attributes:@{ NSForegroundColorAttributeName : color }];
    accNoTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Account Number" attributes:@{NSForegroundColorAttributeName : color }];
    c_AccNoTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Confirm Account Number" attributes:@{ NSForegroundColorAttributeName : color }];
    ifscCodeTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"IFSC Code" attributes:@{NSForegroundColorAttributeName : color }];
    bankNameTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Bank Name" attributes:@{ NSForegroundColorAttributeName : color }];
    NoTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Mobile Number" attributes:@{NSForegroundColorAttributeName : color }];
   
    UIPickerView * banksPicker = [[UIPickerView alloc] init];
    [banksPicker setDataSource: self];
    [banksPicker setDelegate: self];
    banksPicker.backgroundColor = UIColorFromRGBAlpha(240, 240, 240, 1);
    banksPicker.showsSelectionIndicator = YES;
    banksPicker.tag = 1;
    bankNameTF.inputView = banksPicker;
    
    bankArr = [[NSArray alloc] initWithObjects:@"ABSA Bank",@"Bank of Athens",@"Bidvest Bank",@"Capitec bank",@"FNB",@"Investec Private Bank",@"Nedbank",@"SA Post Bank",@"Standard Bank", nil];
    sendBtn.layer.cornerRadius = 20;
    sendBtn.clipsToBounds =YES;
    
}

-(void) viewDidLayoutSubviews{
    [nameTf bottomWhiteLine];
    [accNoTF bottomWhiteLine];
    [c_AccNoTF bottomWhiteLine];
    [ifscCodeTF bottomWhiteLine];
    [bankNameTF bottomWhiteLine];
    [NoTF bottomWhiteLine];
    
}

- (IBAction)bckBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sendBtn:(id)sender {
    if ([nameTf.text isEqualToString:@""]) {
        ALERTVIEW(@"please enter name", self);
        return;
    }
    else if ([NoTF.text isEqualToString:@""]) {
        ALERTVIEW(@"please enter phone number", self);
        return;
    }
    else if ([accNoTF.text isEqualToString:@""]) {
        ALERTVIEW(@"please enter Account number", self);
        return;
    }
    else if ([c_AccNoTF.text isEqualToString:@""]) {
        ALERTVIEW(@"please enter Account number", self);
        return;
    }
    else if ([ifscCodeTF.text isEqualToString:@""]) {
        ALERTVIEW(@"please enter IFSC", self);
        return;
    }
    else if ([bankNameTF.text isEqualToString:@""]) {
        ALERTVIEW(@"please enter Bank Name", self);
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
                                       @"holder_name": nameTf.text,
                                       @"emp_id": GET_USER_ID,
                                       @"account_no": accNoTF.text,
                                       @"ifsc_code": ifscCodeTF.text,
                                       @"mobile": NoTF.text,
                                       @"bank_name":bankNameTF.text,
                                      };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"bank.php"];
             
             [[ApiManager  sharedInstance] apiCall:urlString postDictionary:params CompletionBlock:^(BOOL success, NSString*  message, NSDictionary*  dictionary)
              {
                  HIDE_PROGRESS;
                  if (success == false)
                  {
                      ALERTVIEW( message, self);
                  }
                  else
                  {
                      if ([Util checkIfSuccessResponse:dictionary])
                      {
                            UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"ThankVC"];
                              [self.navigationController pushViewController:view animated:NO];
                          
                    }
                      else
                      {
                          ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
                          
                      }
                  }
                  
              }];
         }
         
     }];
}

#pragma mark
#pragma mark picker view delegates

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [bankArr count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    bankNameTF.text  = [bankArr objectAtIndex:row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [bankArr objectAtIndex:row];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    
    UIView  * PickerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 30)];
    UILabel * PickerLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, pickerView.frame.size.width, 20)];
    PickerLbl.textAlignment = NSTextAlignmentCenter;
    PickerLbl.text = [bankArr objectAtIndex:row];
    [PickerView addSubview:PickerLbl];
    return PickerView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
