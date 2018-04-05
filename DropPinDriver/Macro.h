//
//  Macro.h
//  Omorni
//
//  Created by apple on 13/02/17.
//  Copyright © 2017 CQLsys. All rights reserved.
//

#ifndef Macro_h
#define Macro_h


#endif /* Macro_h */

#define SCREEN_SIZE             [[UIScreen mainScreen]bounds].size
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define USERID     [[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"]


//>>    APIs
//#define appURL          @"http://veloxitech.com/taxi/api/"
#define appURL          @"https://taxi-live.co.za/taxi/api/"
#define appNAME         @"Texi Live Driver"
#define GOOGLEAPIKEY    @"AIzaSyBtlggMQqMuBRmBsWALvi7v3T-3XIlZo3g"



// >>>>>>>> Color Macros --- DefaultColorForAPP

#define RED     214.0f
#define GREEN   4.0f
#define BLUE    17.0f

#define UIColorFromRGBAlpha(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// >>>>> Screen width and OS

#define _is_IPHONE4             ([[UIScreen mainScreen] bounds].size.height == 480.0)
#define _is_IPHONE5             ([[UIScreen mainScreen] bounds].size.height == 568.0)
#define _is_IPHONE6             ([[UIScreen mainScreen] bounds].size.height == 667.0)
#define _is_IPHONE6_Plus        ([[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_OS_8_OR_LATER        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//------ Progress Bar

#define SHOW_PROGRESS(v)    [MRProgressOverlayView showOverlayAddedTo:[[UIApplication sharedApplication] keyWindow] title:v mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES]

#define SHOW_PROGRESS_WITH_STATUS(v) [MRProgressOverlayView showOverlayAddedTo:[[UIApplication sharedApplication] keyWindow] title:v mode:MRProgressOverlayViewModeDeterminateHorizontalBar animated:YES];

#define HIDE_PROGRESS       [MRProgressOverlayView dismissAllOverlaysForView:[[UIApplication sharedApplication] keyWindow] animated:YES]

#define SHOW_ACTIVITE_INDICATOR [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
#define HIDE_ACTIVITE_INDICATOR [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

// --->>>>>>>> ShowAlert

#define ALERTVIEW(MSG,VC)   [Util showalert:MSG onView:VC];

#define GET_USER_ID [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]
#define SET_USER_ID(userId) [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"user_id"];

#define INTERNET_ERROR @"Unable to Connect to Internet!"

#define FONT_Bold(v)        [UIFont fontWithName:@"AxureHandwriting-Bold"       size:v]
#define FONT_Medium(v)      [UIFont fontWithName:@"AxureHandwriting-Italic"     size:v]
#define FONT_Regular(v)       [UIFont fontWithName:@"AxureHandwriting"    size:v]
#define FONT_Semibold(v)    [UIFont fontWithName:@"AxureHandwriting-BoldItalic"   size:v]

