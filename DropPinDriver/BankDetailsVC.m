//
//  BankDetailsVC.m
//  DropPinDriver
//
//  Created by Ajay Kumar on 6/19/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "BankDetailsVC.h"

@interface BankDetailsVC ()

@end

@implementation BankDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([self.title isEqualToString:@"document"])
    {
        urlStringStr = @"bank.php";
    }
    else
    {
       urlStringStr =@"withdrawl.php";
    }
    
    UIColor *color  = [UIColor whiteColor];
    
    nameTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Holder Name" attributes:@{ NSForegroundColorAttributeName : color }];
    palpalIDTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"PayPal Id" attributes:@{NSForegroundColorAttributeName : color }];
    amountTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Amount" attributes:@{ NSForegroundColorAttributeName : color }];
    accountNoTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Account Number" attributes:@{NSForegroundColorAttributeName : color }];
    phoneNoTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Enter your Phone" attributes:@{ NSForegroundColorAttributeName : color }];
    ifscCodeTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Please enter IFSC" attributes:@{NSForegroundColorAttributeName : color }];
    bankNameTF.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:@"Bank Name" attributes:@{ NSForegroundColorAttributeName : color }];
   
    
    
    submitBtn.layer.cornerRadius = 20;
    submitBtn.clipsToBounds =YES;

}

-(void) viewDidLayoutSubviews{
    [nameTF bottomWhiteLine];
    [palpalIDTF bottomWhiteLine];
    [amountTF bottomWhiteLine];
    [accountNoTF bottomWhiteLine];
    [phoneNoTF bottomWhiteLine];
    [ifscCodeTF bottomWhiteLine];
    [bankNameTF bottomWhiteLine];
    
    
    if ([_PaymentType isEqualToString:@"1"]) {
        palpalIDTF.hidden   = YES;
        bankNameTF.hidden  = YES;
        submitBtn.frame   = CGRectMake(20, ifscCodeTF.frame.origin.y+ifscCodeTF.frame.size.height+ 20, submitBtn.frame.size.width, submitBtn.frame.size.height);
        
        
    }
    else if ([_PaymentType isEqualToString:@"2"]){
        bankDetailLBL.text = @"Paypal Details";
        palpalIDTF.hidden   = NO;
        accountNoTF.hidden  = YES;
        ifscCodeTF.hidden   = YES;
        bankNameTF.hidden  = YES;
        palpalIDTF.frame   = CGRectMake(20, amountTF.frame.origin.y+amountTF.frame.size.height+ 20, palpalIDTF.frame.size.width, palpalIDTF.frame.size.height);
        
        submitBtn.frame   = CGRectMake(20, palpalIDTF.frame.origin.y+palpalIDTF.frame.size.height+ 20, submitBtn.frame.size.width, submitBtn.frame.size.height);
    }
    else{
        palpalIDTF.hidden   = YES;
        accountNoTF.hidden  = YES;
        ifscCodeTF.hidden   = YES;
        bankNameTF.hidden  = YES;
        submitBtn.frame   = CGRectMake(20, amountTF.frame.origin.y+amountTF.frame.size.height+ 20, submitBtn.frame.size.width, submitBtn.frame.size.height);
    }
    
    
 
}
-(void)viewDidAppear:(BOOL)animated{
    
    
}

#pragma mark
#pragma mark button action

- (IBAction)backbtnaction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitbtnAction:(id)sender {
    if ([nameTF.text isEqualToString:@""]) {
        ALERTVIEW(@"please enter name", self);
        return;
    }
    else if ([phoneNoTF.text isEqualToString:@""]) {
        ALERTVIEW(@"please enter phone number", self);
        return;
    }
    else if ([amountTF.text isEqualToString:@""]) {
        ALERTVIEW( @"Please Enter amount", self);
        return;
    }
    
    if ([_PaymentType isEqualToString:@"1"]) {
         if ([accountNoTF.text isEqualToString:@""]) {
            ALERTVIEW( @"Enter your account number", self);
            return;
         }
        else if ([ifscCodeTF.text isEqualToString:@""]) {
                ALERTVIEW(@"please enter IFSC Code", self);
                return;
        }

    }
    else if ([_PaymentType isEqualToString:@"2"]){
         if ([palpalIDTF.text isEqualToString:@""]) {
            ALERTVIEW(@"please enter your paypal ID", self);
            return;
        }

    }
    
        
    [self currentime];
    
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
                                       @"name": nameTF.text,
                                       @"emp_id": GET_USER_ID,
                                       @"mobile": phoneNoTF.text,
                                       @"amount": amountTF.text,
                                       @"payment_method": _PaymentType,
                                       @"account_no":accountNoTF.text,
                                       @"date":currentDate,
                                       @"ifsc_code":ifscCodeTF.text,
                                       @"paypal_id":palpalIDTF.text
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"withdrawl.php"];
             
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
                        UIAlertController *alertController = [UIAlertController
                                                                alertControllerWithTitle:@""
                                                                message:@"withdraw request send  successfully"
                                                                preferredStyle:UIAlertControllerStyleAlert];
                          
                          UIAlertAction *okAction = [UIAlertAction
                                                     actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                                                     {
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                         
                                                     }];
                          
                          [alertController addAction:okAction];
                          
                          [self presentViewController:alertController animated:YES completion:nil];
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

-(void) currentime{
    
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-mm-yyyy hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *time36 =[dateFormatter stringFromDate:now];
    NSLog(@"The Current Time is %@",time36);
    
    // NSString * timestamp = [NSString stringWithFormat:@"%0.0f",[now timeIntervalSince1970]];
    
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:time36];
    NSTimeInterval time = [dateFromString timeIntervalSince1970];
    // NSLog(@"The Current Time is %@",timestamp);
    double result = time;
    currentDate =[NSString stringWithFormat:@"%0.0f",result];
    
}




#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
