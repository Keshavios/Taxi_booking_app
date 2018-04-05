//
//  ApiManager.h
//  Qmash
//
//  Created by apple on 30/09/16.
//  Copyright © 2016 CQLsys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface ApiManager : NSObject
typedef void (^DictionaryResponse) (BOOL success, NSString *message, NSDictionary *dictionary);
typedef void (^CompletionBlock) (BOOL responseObject);

#pragma mark
#pragma mark create instance of file

+ (instancetype)sharedInstance;

#pragma mark
#pragma mark CheckInternetConnection

- (void)CheckReachibilty :(CompletionBlock)completionBlock;

#pragma mark
#pragma mark append string with url


+ (NSString *)addQueryStringToUrlString:(NSString *)urlString withDictionary:(NSDictionary *)dictionary;
#pragma mark
#pragma mark Replace % from string

+ (NSString *)urlEscapeString:(NSString *)unencodedString;


#pragma mark

-(void)apiCall:(NSString *)urlString postDictionary:(NSDictionary *)postDictionary CompletionBlock:(DictionaryResponse) completionBlock;

-(void)apiCallWithImage:(NSString *)_urlString parameterDict:(NSDictionary *)_parameterDict imageDataDictionary:(NSDictionary *)_imageDatadictionary CompletionBlock :(DictionaryResponse) completionBlock;

-(void)apiCallWithImage1:(NSString *)_urlString parameterDict:(NSDictionary *)_parameterDict imageDataDictionary:(NSDictionary *)_imageDatadictionary CompletionBlock :(DictionaryResponse) completionBlock;
-(void)apiCallWithImage11:(NSString *)_urlString parameterDict:(NSDictionary *)_parameterDict imageDataDictionary:(NSDictionary *)_imageDatadictionary CompletionBlock :(DictionaryResponse) completionBlock;


-(void)apiCallWithVideo:(NSString *)_urlString parameterDict:(NSDictionary *)_parameterDict imageDataDictionary:(NSDictionary *)_imageDatadictionary CompletionBlock :(DictionaryResponse) completionBlock;

-(void)apiCallWithAudio:(NSString *)_urlString parameterDict:(NSDictionary *)_parameterDict imageDataDictionary:(NSDictionary *)_imageDatadictionary CompletionBlock :(DictionaryResponse) completionBlock;

-(void)apiCallWithFile:(NSString *)_urlString parameterDict:(NSDictionary *)_parameterDict imageDataDictionary:(NSDictionary *)_imageDatadictionary   FILEExTension : (NSString *) ExTension MIMETYPE: (NSString *)Mimetype CompletionBlock :(DictionaryResponse) completionBlock ;


-(void)POST:(NSString *)_urlString parameterDict:(NSDictionary *)_parameterDict  Headers: (NSDictionary *)headerDict CompletionBlock :(DictionaryResponse) completionBlock;
-(void)backgroundApiCall:(NSString *)urlString postDictionary:(NSDictionary *)postDictionary CompletionBlock:(DictionaryResponse) completionBlock ;

-(void)OneMinApiCall:(NSString *)urlString postDictionary:(NSDictionary *)postDictionary CompletionBlock:(DictionaryResponse) completionBlock ;
@end
