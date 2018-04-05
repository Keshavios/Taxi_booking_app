//
//  AccountVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/29/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "AccountVC.h"

@interface AccountVC ()

@end

@implementation AccountVC

- (void)viewDidLoad {
    [super viewDidLoad];


    

}
-(void)viewWillAppear:(BOOL)animated{
    accountTV.tableFooterView   = [[UIView alloc]initWithFrame:CGRectZero];
    accountListArray = [[NSMutableArray alloc] initWithObjects:@"Help",@"Payment" ,@"Setting", @"About",nil];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"on_duty"] isEqualToString:@"0"]) {
        [switchBtn setOn:YES animated:YES];
        onOfflineLB.text = @"Online";
        
    }
    else{
        [switchBtn setOn:NO animated:YES];
        onOfflineLB.text = @"Offline";
        
    }
    
    profileImgV.layer.cornerRadius = profileImgV.frame.size.width/2;
    profileImgV.clipsToBounds = YES;
    
    NSDictionary * userInfo =[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    nameLB.text =[userInfo objectForKey:@"username"];
    emailLbl.text = [userInfo objectForKey:@"emp_email"];
    
    [profileImgV setImageWithURL:[NSURL URLWithString:[userInfo objectForKey:@"emp_image"]] placeholderImage:[UIImage imageNamed:@"PROFILE_IMG"]];
}
#pragma mark
#pragma mark tableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [accountListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"AccountCell"];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AccountCell"];
    }
    
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    UILabel*listLB        = [cell.contentView viewWithTag:1];
    listLB.text           = [accountListArray objectAtIndex:indexPath.row];
    
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"HelpVC"];
        [self.navigationController pushViewController:view animated:YES];
    }
   else if (indexPath.row == 1) {
//        UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"PaymentHistoryVC"];
//       [self.navigationController pushViewController:view animated:YES];
    }
   else if (indexPath.row == 2) {
       UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"SettingVC"];
       [self.navigationController pushViewController:view animated:YES];
   }
   else if (indexPath.row == 3) {
       UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"AboutUsVC"];
       [self.navigationController pushViewController:view animated:YES];
   }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark
#pragma mark button action

- (IBAction)menuBtnaction:(id)sender {
    UIViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuVC"];
    [self addChildViewController:vc2];
    [self.view addSubview:vc2.view];
    [vc2 didMoveToParentViewController:self];
    vc2.view.frame = CGRectMake(-vc2.view.frame.size.width, 0, vc2.view.frame.size.width,vc2.view.frame.size.height);
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        vc2.view.frame = CGRectMake(vc2.view.frame.size.width*0/100, 0, vc2.view.frame.size.width,vc2.view.frame.size.height);
        
    }   completion:^(BOOL finished) {
        
    }];
}
- (IBAction)switchBtnAction:(UISwitch*)sender {
    NSString * duty;
    if(sender.isOn){
        duty = @"0";
        onOfflineLB.text = @"Online";
    }else{
        duty = @"1";
         onOfflineLB.text = @"Offline";
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
                                       
                                       @"auth_token"       : [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"],
                                       @"emp_id": GET_USER_ID,
                                       @"on_duty": duty
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"emp_duty.php"];
             
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
                          [[NSUserDefaults standardUserDefaults] setObject:[[dictionary objectForKey:@"body"]objectForKey:@"on_duty"] forKey:@"on_duty"];
                          
                      }
                      else
                      {
//                          ALERTVIEW([[dictionary objectForKey:@"status"] objectForKey:@"message"], self);
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
- (IBAction)editprofilrBtn:(id)sender {
    
    UIViewController*view =[self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    [self.navigationController pushViewController:view animated:YES];
}


#pragma mark
#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
