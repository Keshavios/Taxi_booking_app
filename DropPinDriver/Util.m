//
//  Util.m
//  Aglow
//
//  Created by CqlSys iOS Team on 01/02/16.
//  Copyright © 2016 cqlsys. All rights reserved.
//

#import "Util.h"

@implementation Util


#pragma mark
#pragma mark -emailValidation

+(BOOL)ValidateEmailString:(NSString *)str
{
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:str];
    
    
}

#pragma mark
#pragma mark - showAlertview

+ (void)showalert:(NSString *)_msg onView:(UIViewController *)controlr
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:_msg
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   
                               }];
    
    [alertController addAction:okAction];
    
    [controlr presentViewController:alertController animated:YES completion:nil];
}

#pragma mark
#pragma mark removeNullFromDictionary

+(NSMutableDictionary*)removeNull:(NSMutableDictionary*)dictionary{
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:[dictionary mutableCopy]];
   //tempDict = [[NSMutableDictionary alloc] init];
    
    
    //tempDict = [dictionary mutableCopy];
    
    //--remove null values from dictioanry
    for(NSString* key in [[dictionary allKeys] mutableCopy]) {
        
        if([dictionary[key] isKindOfClass:[NSNull class]] || dictionary[key] ==(id)[NSNull null])
        {
            
            [tempDict setValue:@"" forKey:key];
            
        }
    }
    
    return tempDict;
}

#pragma mark
#pragma mark  -encode decode Image BAse64

+ (NSString *)encodeToBase64String:(UIImage *)image
{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

#pragma mark

+ (BOOL) checkIfSuccessResponse : (NSDictionary *) responseDict {
    
    if ([[[responseDict objectForKey:@"status"] objectForKey:@"code"] isEqualToString:@"1"]) {
        
        return true;
    }
    else{
        return false;
    }
}

#pragma mark
#pragma mark - Image Resize

+(UIImage *)resizeImage :(UIImage *)theImage :(CGSize)theNewSize {
    UIGraphicsBeginImageContextWithOptions(theNewSize, NO, 1.0);
    [theImage drawInRect:CGRectMake(0, 0, theNewSize.width, theNewSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    //indent in case of width or height difference
    float offset = (width - height) / 2;
    if (offset > 0) {
        rect.origin.y = offset;
    }
    else {
        rect.origin.x = -offset;
    }
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}

@end
