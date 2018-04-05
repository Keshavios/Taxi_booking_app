//
//  LeftMenuVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/30/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "LeftMenuVC.h"

@interface LeftMenuVC ()

@end

@implementation LeftMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    menuTV.tableFooterView   = [[UIView alloc]initWithFrame:CGRectZero];
   // menuArray = [NSArray arrayWithObjects:@"Your Trip",@"Payment",@"Help",@"Setting",@"Sign Out", nil];
    
   menuArray = [NSArray arrayWithObjects:@"Home",@"Trip History",@"Payment",@"Help",@"Setting",@"Withdraw",@"Panic",@"Sign Out", nil];

    
    
    
    LeftMenuVC *middleVC =nil;
   
    userImgV.layer.cornerRadius = userImgV.frame.size.width/2;
    userImgV.clipsToBounds = YES;
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSDictionary * userInfo =[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    nameLB.text =[userInfo objectForKey:@"username"];
    [userImgV setImageWithURL:[NSURL URLWithString:[userInfo objectForKey:@"emp_image"]] placeholderImage:[UIImage imageNamed:@"PROFILE_IMG"]];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentrating"] == nil) {
        ratingLB.text =@"0";
    }
    else{
        ratingLB.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"currentrating"];
    }
    
}

#pragma mark
#pragma mark tableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MenuCell"];
    }
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    UILabel*menuLB        = [cell.contentView viewWithTag:1];
    menuLB.text           = [menuArray objectAtIndex:indexPath.row];
    
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedIndex   = (int)indexPath.row;
    [[NSUserDefaults standardUserDefaults] setObject:@"FALSE" forKey:@"MENUVALUE"];
    
    
    if (indexPath.row == 0) {
        
        UIStoryboard *story  = self.storyboard;
        UIViewController *views        = [story instantiateViewControllerWithIdentifier:@"TabBar"];
        //[self.view addSubview:views.view];
        self.view.window.rootViewController = views;
    }
    if (indexPath.row == 1) {
        
        UIStoryboard *story  = self.storyboard;
                UIViewController *views        = [story instantiateViewControllerWithIdentifier:@"PreviousTripVC"];
                [self.view addSubview:views.view];
                [self.navigationController pushViewController:views animated:YES];
             [views didMoveToParentViewController:self];
      }
    
    if (indexPath.row == 2) {
        
                UIStoryboard *story  = self.storyboard;
                UIViewController *views        = [story instantiateViewControllerWithIdentifier:@"PaymentHistoryVC"];
                [self.view addSubview:views.view];
                [self.navigationController pushViewController:views animated:YES];
                [views didMoveToParentViewController:self];
        
        
    }
    if (indexPath.row == 3)
    {
        UIStoryboard *story  = self.storyboard;
        UIViewController *views        = [story instantiateViewControllerWithIdentifier:@"HelpVC"];
        [self.view addSubview:views.view];
        //views.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:views animated:YES];
        [views didMoveToParentViewController:self];
}
    else if (indexPath.row == 4){
        
        
        UIStoryboard *story  = self.storyboard;
        UIViewController *views        = [story instantiateViewControllerWithIdentifier:@"SettingVC"];
        [self.view addSubview:views.view];
        [self.navigationController pushViewController:views animated:YES];
        [views didMoveToParentViewController:self];
     }
    else if (indexPath.row == 5)
    {
        UIStoryboard *story  = self.storyboard;
        UIViewController *views        = [story instantiateViewControllerWithIdentifier:@"WithdrawVC"];
        [self.view addSubview:views.view];
        [self.navigationController pushViewController:views animated:YES];
        [views didMoveToParentViewController:self];
    }
    else if (indexPath.row == 6){
        
        
        UIStoryboard *story  = self.storyboard;
        UIViewController *views        = [story instantiateViewControllerWithIdentifier:@"PanicVC"];
        [self.view addSubview:views.view];
        [self.navigationController pushViewController:views animated:YES];
        [views didMoveToParentViewController:self];
    }
    //PanicVC
    else if (indexPath.row == 7)
    {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:appNAME
                                              message:@"Are you sure you want to logout?"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self LogoutApiCalling];
                                       
                                   }];
        
        UIAlertAction *cnclAction = [UIAlertAction
                                     actionWithTitle:@"No"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action)
                                     {
                                         
                                     }];
        
        [alertController addAction:okAction];
        [alertController addAction:cnclAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    [tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (IBAction)crossBtnAction:(id)sender {
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.view.frame = CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width,self.view.frame.size.height);
        
        [self.view layoutIfNeeded];
        
        
    }   completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
    }];
}

#pragma mark
#pragma mark Api calling
-(void)LogoutApiCalling{
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
                                       @"auth_token"    :[[NSUserDefaults standardUserDefaults]  objectForKey:@"auth_token"],
                                       @"emp_id"       : GET_USER_ID
                                      
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"emp_logout.php"];
             
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
                          SET_USER_ID(nil);
                          UIViewController *view  = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyVC"];
                          self.view.window.rootViewController    = view;
                          
                          
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

#pragma mark
#pragma mark


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
