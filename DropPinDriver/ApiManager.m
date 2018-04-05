//
//  ApiManager.m
//  Qmash
//
//  Created by apple on 30/09/16.
//  Copyright © 2016 CQLsys. All rights reserved.
//

#import "ApiManager.h"


@implementation ApiManager

#pragma mark
#pragma mark create instance of file

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark
#pragma mark Check Internet Connection

- (void)CheckReachibilty :(CompletionBlock)completionBlock
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([AFStringFromNetworkReachabilityStatus(status) isEqualToString:@"Not Reachable"]) {
            completionBlock (false);
        }
        else {
            completionBlock (true);
            
        }
        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

#pragma mark
#pragma mark append string with url


+ (NSString *)addQueryStringToUrlString:(NSString *)urlString withDictionary:(NSDictionary *)dictionary  {
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:urlString];
    
    for (id key in dictionary) {
        NSString *keyString = [key description];
        NSString *valueString = [[dictionary objectForKey:key] description];
        
        if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
            
            [urlWithQuerystring appendFormat:@"?%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        }
        else {
            [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        }
    }
    return urlWithQuerystring;
}

#pragma mark
#pragma mark Replace % from string

+ (NSString *)urlEscapeString:(NSString *)unencodedString {
    
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    NSString *ss=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapes(NULL, originalStringRef, NULL);
    CFRelease(originalStringRef);
    return ss;
    
}


#pragma mark
#pragma mark Api call

-(void)apiCall:(NSString *)urlString postDictionary:(NSDictionary *)postDictionary CompletionBlock:(DictionaryResponse) completionBlock {
    
    SHOW_ACTIVITE_INDICATOR;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *newstring = [ApiManager addQueryStringToUrlString:urlString withDictionary:postDictionary];
    
    //  NSString *string = [newstring stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *string = [newstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        HIDE_ACTIVITE_INDICATOR;
        if (error) {
            
            NSLog(@"Error: %@", error.localizedDescription);
            completionBlock(false, error.localizedDescription,nil);
            
        } else {
            
            completionBlock(true, @"Api Response",responseObject);
        }
    }];
    [dataTask resume];
    
}



-(void)POST:(NSString *)_urlString parameterDict:(NSDictionary *)_parameterDict  Headers: (NSDictionary *)headerDict CompletionBlock :(DictionaryResponse) completionBlock
{
    
    SHOW_ACTIVITE_INDICATOR;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:_urlString parameters:_parameterDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        manager.responseSerializer  = [AFJSONResponseSerializer serializer];
        manager.requestSerializer   = [AFJSONRequestSerializer serializer];
        
        for (NSString *key in [headerDict allKeys])
        {
            [manager.requestSerializer setValue:[headerDict objectForKey:key] forHTTPHeaderField:key];
        }
    }
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              HIDE_ACTIVITE_INDICATOR;
              completionBlock(true, @"Api Response",responseObject);
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              HIDE_ACTIVITE_INDICATOR;
              completionBlock(false, error.localizedDescription,nil);
              
          }];
    
}
#pragma mark
#pragma mark Multipart Request


-(void)apiCallWithImage11:(NSString *)_urlString parameterDict:(NSDictionary *)_parameterDict imageDataDictionary:(NSDictionary *)_imageDatadictionary CompletionBlock :(DictionaryResponse) completionBlock
{
    
    SHOW_ACTIVITE_INDICATOR;
    MRProgressOverlayView *hud;
    
    hud         = [MRProgressOverlayView showOverlayAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.mode    = MRProgressOverlayViewModeDeterminateHorizontalBar;
    hud.titleLabelText = @"Registering..";
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:_urlString parameters:_parameterDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //audio/mp4
        NSDate *date = [NSDate date];
        NSTimeInterval timeinterval = [date timeIntervalSince1970];
        NSString *fileName1 = [NSString stringWithFormat:@"file1%f.jpg", timeinterval];
        NSString *fileName2 = [NSString stringWithFormat:@"file1%f.mp4", timeinterval];
        for (NSString* key in _imageDatadictionary){
            
            if ([key isEqualToString:@"image"] ) {
                [formData appendPartWithFileData:[_imageDatadictionary objectForKey:key] name:key fileName:fileName1 mimeType:@"image/jpeg"];
            }else if ([key isEqualToString:@"audio_url"] ) {
                [formData appendPartWithFileData:[_imageDatadictionary objectForKey:key] name:key fileName:fileName2 mimeType:@"image/jpeg"];
            }
            
            
        }
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          [hud setProgress:uploadProgress.fractionCompleted animated:YES];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      
                      HIDE_ACTIVITE_INDICATOR;
                      [MRProgressOverlayView dismissOverlayForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                      
                      if (error) {
                          
                          NSLog(@"Error: %@", error.localizedDescription);
                          completionBlock(false, error.localizedDescription,nil);
                          
                      } else {
                          
                          completionBlock(true, @"Api Response",responseObject);
                      }
                  }];
    
    [uploadTask resume];
}



#pragma mark
#pragma mark Multipart Request


-(void)apiCallWithImage:(NSString *)_urlString parameterDict:(NSDictionary *)_parameterDict imageDataDictionary:(NSDictionary *)_imageDatadictionary CompletionBlock :(DictionaryResponse) completionBlock
{
    
    SHOW_ACTIVITE_INDICATOR;
    MRProgressOverlayView *hud;
    
    hud         = [MRProgressOverlayView showOverlayAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.mode    = MRProgressOverlayViewModeDeterminateHorizontalBar;
    hud.titleLabelText = @"Registering..";
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:_urlString parameters:_parameterDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSDate *date = [NSDate date];
        NSTimeInterval timeinterval = [date timeIntervalSince1970];
        NSString *fileName1 = [NSString stringWithFormat:@"file1%f.jpg", timeinterval];
        
        for (NSString* key in _imageDatadictionary){
            
            [formData appendPartWithFileData:[_imageDatadictionary objectForKey:key] name:key fileName:fileName1 mimeType:@"image/jpeg"];
            
        }
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          [hud setProgress:uploadProgress.fractionCompleted animated:YES];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      
                      HIDE_ACTIVITE_INDICATOR;
                      [MRProgressOverlayView dismissOverlayForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                      
                      if (error) {
                          
                          NSLog(@"Error: %@", error.localizedDescription);
                          completionBlock(false, error.localizedDescription,nil);
                          
                      } else {
                          
                          completionBlock(true, @"Api Response",responseObject);
                      }
                  }];
    
    [uploadTask resume];
}

#pragma mark
#pragma mark Upload File

-(void)apiCallWithFile:(NSString *)_urlString parameterDict:(NSDictionary *)_parameterDict imageDataDictionary:(NSDictionary *)_imageDatadictionary   FILEExTension : (NSString *) ExTension MIMETYPE: (NSString *)Mimetype CompletionBlock :(DictionaryResponse) completionBlock
{
    
    SHOW_ACTIVITE_INDICATOR;
    MRProgressOverlayView *hud;
    
    hud         = [MRProgressOverlayView showOverlayAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.mode    = MRProgressOverlayViewModeDeterminateHorizontalBar;
    hud.titleLabelText = @"Uploading..";
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:_urlString parameters:_parameterDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSDate *date = [NSDate date];
        NSTimeInterval timeinterval = [date timeIntervalSince1970];
        NSString *fileName1 = [NSString stringWithFormat:@"file1%f.%@", timeinterval,ExTension];
        
        for (NSString* key in _imageDatadictionary){
            
            [formData appendPartWithFileData:[_imageDatadictionary objectForKey:key] name:key fileName:fileName1 mimeType:Mimetype];
            
        }
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          [hud setProgress:uploadProgress.fractionCompleted animated:YES];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      
                      HIDE_ACTIVITE_INDICATOR;
                      [MRProgressOverlayView dismissOverlayForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                      
                      if (error) {
                          
                          NSLog(@"Error: %@", error.localizedDescription);
                          completionBlock(false, error.localizedDescription,nil);
                          
                      } else {
                          
                          completionBlock(true, @"Api Response",responseObject);
                      }
                  }];
    
    [uploadTask resume];
}

-(void)apiCallWithImage1:(NSString *)_urlString parameterDict:(NSDictionary *)_parameterDict imageDataDictionary:(NSDictionary *)_imageDatadictionary CompletionBlock :(DictionaryResponse) completionBlock
{
    
    SHOW_ACTIVITE_INDICATOR;
    MRProgressOverlayView *hud;
    
    hud         = [MRProgressOverlayView showOverlayAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.mode    = MRProgressOverlayViewModeDeterminateHorizontalBar;
    hud.titleLabelText = @"Uploading..";
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:_urlString parameters:_parameterDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSDate *date = [NSDate date];
        NSTimeInterval timeinterval = [date timeIntervalSince1970];
        NSString *fileName1 = [NSString stringWithFormat:@"file1%f.jpg", timeinterval];
        
        for (NSString* key in _imageDatadictionary){
            
            [formData appendPartWithFileData:[_imageDatadictionary objectForKey:key] name:key fileName:fileName1 mimeType:@"image/jpeg"];
            
        }
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          [hud setProgress:uploadProgress.fractionCompleted animated:YES];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      
                      HIDE_ACTIVITE_INDICATOR;
                      [MRProgressOverlayView dismissOverlayForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                      
                      if (error) {
                          
                          NSLog(@"Error: %@", error.localizedDescription);
                          completionBlock(false, error.localizedDescription,nil);
                          
                      } else {
                          
                          completionBlock(true, @"Api Response",responseObject);
                      }
                  }];
    
    [uploadTask resume];
}

-(void)apiCallWithAudio:(NSString *)_urlString parameterDict:(NSDictionary *)_parameterDict imageDataDictionary:(NSDictionary *)_imageDatadictionary CompletionBlock :(DictionaryResponse) completionBlock
{
    
    SHOW_ACTIVITE_INDICATOR;
    MRProgressOverlayView *hud;
    
    hud         = [MRProgressOverlayView showOverlayAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.mode    = MRProgressOverlayViewModeDeterminateHorizontalBar;
    hud.titleLabelText = @"Uploading..";
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:_urlString parameters:_parameterDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSDate *date = [NSDate date];
        NSTimeInterval timeinterval = [date timeIntervalSince1970];
        NSString *fileName1 = [NSString stringWithFormat:@"file1%f.mp3", timeinterval];
        
        for (NSString* key in _imageDatadictionary){
            
            [formData appendPartWithFileData:[_imageDatadictionary objectForKey:key] name:key fileName:fileName1 mimeType:@"audio/mp3"];
            
        }
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          [hud setProgress:uploadProgress.fractionCompleted animated:YES];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      
                      HIDE_ACTIVITE_INDICATOR;
                      [MRProgressOverlayView dismissOverlayForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                      
                      if (error) {
                          
                          NSLog(@"Error: %@", error.localizedDescription);
                          completionBlock(false, error.localizedDescription,nil);
                          
                      } else {
                          
                          completionBlock(true, @"Api Response",responseObject);
                      }
                  }];
    
    [uploadTask resume];
}



#pragma mark
#pragma mark Multipart Request


-(void)apiCallWithVideo:(NSString *)_urlString parameterDict:(NSDictionary *)_parameterDict imageDataDictionary:(NSDictionary *)_imageDatadictionary CompletionBlock :(DictionaryResponse) completionBlock
{
    
    SHOW_ACTIVITE_INDICATOR;
    MRProgressOverlayView *hud;
    
    hud         = [MRProgressOverlayView showOverlayAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.mode    = MRProgressOverlayViewModeDeterminateHorizontalBar;
    hud.titleLabelText = @"Uploading..";
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:_urlString parameters:_parameterDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSDate *date = [NSDate date];
        NSTimeInterval timeinterval = [date timeIntervalSince1970];
        NSString *fileName1 = [NSString stringWithFormat:@"file1%f.mp4", timeinterval];
        
        for (NSString* key in _imageDatadictionary){
            
            [formData appendPartWithFileData:[_imageDatadictionary objectForKey:key] name:key fileName:fileName1 mimeType:@"image/jpeg"];
            
        }
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          [hud setProgress:uploadProgress.fractionCompleted animated:YES];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      
                      HIDE_ACTIVITE_INDICATOR;
                      [MRProgressOverlayView dismissOverlayForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                      
                      if (error) {
                          
                          NSLog(@"Error: %@", error.localizedDescription);
                          completionBlock(false, error.localizedDescription,nil);
                          
                      } else {
                          
                          completionBlock(true, @"Api Response",responseObject);
                      }
                  }];
    
    [uploadTask resume];
}

-(void)backgroundApiCall:(NSString *)urlString postDictionary:(NSDictionary *)postDictionary CompletionBlock:(DictionaryResponse) completionBlock {
    
    SHOW_ACTIVITE_INDICATOR;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *newstring = [ApiManager addQueryStringToUrlString:urlString withDictionary:postDictionary];
    
    //  NSString *string = [newstring stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *string = [newstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        HIDE_ACTIVITE_INDICATOR;
        if (error) {
            
            NSLog(@"Error: %@", error.localizedDescription);
            completionBlock(false, error.localizedDescription,nil);
            
        } else {
            
            completionBlock(true, @"Api Response",responseObject);
        }
    }];
    [dataTask resume];
    
}

-(void)OneMinApiCall:(NSString *)urlString postDictionary:(NSDictionary *)postDictionary CompletionBlock:(DictionaryResponse) completionBlock {
    
    SHOW_ACTIVITE_INDICATOR;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *newstring = [ApiManager addQueryStringToUrlString:urlString withDictionary:postDictionary];
    
    //  NSString *string = [newstring stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSString *string = [newstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *URL = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        HIDE_ACTIVITE_INDICATOR;
        if (error) {
            
            NSLog(@"Error: %@", error.localizedDescription);
            completionBlock(false, error.localizedDescription,nil);
            
        } else {
            
            completionBlock(true, @"Api Response",responseObject);
        }
    }];
    [dataTask resume];
    
}


#pragma mark
#pragma mark
#pragma mark
#pragma mark ApiCallingWays

/*
 
 ------ Check Internet
 
 [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject) {
 NSLog(@"%hhd",responseObject);
 
 if (responseObject == false) {
 
 ALERTVIEW(@"Check Internet Connection", self);
 return ;
 }
 
 }];
 
 
 ------ ApiCall
 
 //    NSString *_url = [NSString stringWithFormat:@"%@%@",appURL,@"login.php"];
 //
 //
 //    [[ApiManager sharedInstance] apiCall:_url postDictionary:_dict1 CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
 //
 //        if (success == false) {
 //
 //            ALERTVIEW(message, self);
 //        }
 //        else{
 //
 //            ALERTVIEW(message, self);
 //        }
 //
 //    }];
 
 
 */


@end
