//
//  StartVC.m
//  DropPinDriver
//
//  Created by Ajay kumar on 5/19/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "StartVC.h"

@interface StartVC ()

@end

@implementation StartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arrPageTitles = @[@"Keep Your Account Secure",@"Clearly Show your face",@"Get Verified in seconds"];
    _arrdetail = @[@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu,",@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu,",@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu,"];
    _arrPageImages = @[@"LOGO1",@"LOGO2",@"LOGO3"];
    
    _arrPageMoveImages = @[@"SCROLL1",@"SCROLL2",@"SCROLL3"];
    
    self.SecureSlideVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.SecureSlideVC.dataSource = self;
    
    SecureSlideVC *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    
    [self.SecureSlideVC setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
self.SecureSlideVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+40);
 [self addChildViewController:_SecureSlideVC];
[self.view addSubview:_SecureSlideVC.view];
   [self.SecureSlideVC didMoveToParentViewController:self];
    
    
    
    
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((SecureSlideVC*) viewController).pageIndex;
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((SecureSlideVC*) viewController).pageIndex;
    if (index == NSNotFound)
    {
        return nil;
    }
    index++;
    if (index == [self.arrPageTitles count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}
- (SecureSlideVC *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.arrPageTitles count] == 0) || (index >= [self.arrPageTitles count])) {
        return nil;
    }
 
        SecureSlideVC *SecureSlideVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SecureSlideVC"];
        SecureSlideVC.imgFile       = self.arrPageImages[index];
        SecureSlideVC.txtTitle      = self.arrPageTitles[index];
        SecureSlideVC.detailTitle   = self.arrdetail[index];
        SecureSlideVC.slideImgFile  = self.arrPageMoveImages[index];
        SecureSlideVC.pageIndex     = index;
        return SecureSlideVC;
   
 }
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.arrPageTitles count];
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
