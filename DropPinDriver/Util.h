//
//  Util.h
//  Qmash
//
//  Created by apple on 30/09/16.
//  Copyright © 2016 cqlsys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

#pragma mark
#pragma mark -emailValidation

+(BOOL)ValidateEmailString:(NSString *)str;

#pragma mark
#pragma mark - showAlertview

+ (void)showalert:(NSString *)_msg onView:(UIViewController *)controlr;

#pragma mark
#pragma mark removeNullFromDictionary

+(NSMutableDictionary*)removeNull:(NSMutableDictionary*)dictionary;

#pragma mark
#pragma mark  -encode decode Image BAse64

+ (NSString *)encodeToBase64String:(UIImage *)image;
+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;

#pragma mark

+ (BOOL) checkIfSuccessResponse : (NSDictionary *) responseDict;

#pragma mark
#pragma mark - Image Resize
+(UIImage *)resizeImage :(UIImage *)theImage :(CGSize)theNewSize;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;
@end
