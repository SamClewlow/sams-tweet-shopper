//
//  SCNetworkService.m
//  World Weather
//
//  Created by Sam Clewlow on 02/12/2014.
//  Copyright (c) 2014 Sam Clewlow. All rights reserved.
//

#import "SCNetworkService.h"


#pragma mark - Interface

@interface SCNetworkService()

@property (nonatomic, strong) NSURLSession *dataSession;
@property (nonatomic, strong) NSURLSession *imageSession;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end


#pragma mark - Implementation

@implementation SCNetworkService


#pragma mark - Initiaisers

+ (instancetype)sharedInstance
{
    static id networkService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkService = [[self alloc] init];
        
    });
    return networkService;
}

#pragma mark - Networking

- (NSURLSessionDataTask *)getRequestWithURLString:(NSString *)URLString
                                       completion:(SCNetworkServiceCompletion)completion
{
    if (URLString != nil)
    {
        // Getting the URL together
        NSURL *URL = [NSURL URLWithString:URLString];
        
        // Create request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        request.HTTPMethod = @"GET";
        
        // Trigger request
        NSURLSessionDataTask *requestDataTask = [self.dataSession dataTaskWithRequest:request
                                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                 {
                                                     __block NSError *errorToReturn = nil;
                                                     
                                                     
                                                     // Check we have response data
                                                     if (data != nil)
                                                     {
                                                         // Parse the JSON file on a background thread
                                                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                             
                                                             NSError *parsingError = nil;
                                                             id responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                 options:0
                                                                                                                   error:&parsingError];
                                                             
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 
                                                                 if (parsingError != nil)
                                                                 {
                                                                     errorToReturn = parsingError;
                                                                 }
                                                                 else
                                                                 {
                                                                     errorToReturn = nil;
                                                                 }
                                                                 
                                                                 if (completion != nil)
                                                                 {
                                                                     completion(responseObject, errorToReturn);
                                                                 }
                                                                 
                                                             });
                                                         });
                                                     }
                                                     else
                                                     {
                                                         // Check the error
                                                         if (error != nil)
                                                         {
                                                             errorToReturn = error;
                                                         }
                                                         else
                                                         {
                                                             // TODO: Generate an error
                                                             // errorToReturn = ....
                                                         }
                                                         
                                                         if (completion != nil)
                                                         {
                                                             completion(nil, errorToReturn);
                                                         }
                                                     }
                                                     
                                                 }];
        
        [requestDataTask resume];
        return requestDataTask;
    }
    else
    {
        NSError *localError = nil;
        // No URL was specifed
        // TODO: Generate an error
        // errorToReturn = ....
        
        if (completion != nil)
        {
            completion(nil, localError);
        }
    }
    return nil;
}

- (NSURLSessionDataTask *)downloadImageForURL:(NSString *)imageURL
                                   completion:(SCNetworkServiceCompletion)completion {
    if (imageURL != nil)
    {
        
        // Getting the URL together
        NSURL *url = [NSURL URLWithString:imageURL];
        
        // Create request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"GET";
        
        // Trigger request
        NSURLSessionDataTask *requestDataTask = [self.imageSession dataTaskWithRequest:request
                                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                 {
                                                     
                                                     NSError *errorToReturn = nil;
                                                     UIImage *image = nil;
                                                     
                                                     if (data != nil)
                                                     {
                                                         // Parse the image
                                                         image = [UIImage imageWithData:data
                                                                                  scale:[UIScreen mainScreen].scale];
                                                     }
                                                     else
                                                     {
                                                         // Check the error
                                                         if (error != nil)
                                                         {
                                                             errorToReturn = error;
                                                         }
                                                         else
                                                         {
                                                             // TODO: Generate an error
                                                             // errorToReturn = ....
                                                         }
                                                     }
                                                     
                                                     if (completion != nil)
                                                     {
                                                         completion(image, errorToReturn);
                                                     }
                                                     
                                                 }];
        NSBlockOperation *op = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakOp = op;
        
        [op addExecutionBlock:^{
            if (!weakOp.isCancelled) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [requestDataTask resume];
                });
            }
        }];
        
        [self.operationQueue addOperation:op];
        
        //[requestDataTask resume];
        return requestDataTask;
    }
    else
    {
        NSError *localError = nil;
        // No URL was specifed
        // TODO: Generate an error
        // errorToReturn = ....
        
        if (completion != nil)
        {
            completion(nil, localError);
        }
    }
    
    return nil;
}


#pragma mark - Properties

- (NSURLSession *)dataSession
{
    if (_dataSession == nil)
    {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.HTTPAdditionalHeaders = @{@"Accept" : @"application/json",
                                         @"content-type" : @"application/json"};
        
        _dataSession = [NSURLSession sessionWithConfiguration:config
                                                     delegate:nil
                                                delegateQueue:[NSOperationQueue mainQueue]];
    }
    
    return _dataSession;
}

- (NSURLSession *)imageSession
{
    if (_imageSession == nil)
    {
        NSURLSessionConfiguration *imageConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _imageSession = [NSURLSession sessionWithConfiguration:imageConfig
                                                      delegate:nil
                                                 delegateQueue:[NSOperationQueue mainQueue]];
    }
    
    return _imageSession;
}

- (NSOperationQueue *)operationQueue {
    
    if (_operationQueue == nil) {
    
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 5;
    }
    return _operationQueue;
}

#pragma mark - Teardown

- (void)dealloc
{
    // Cancel any ongoing requests
    [self.dataSession invalidateAndCancel];
    [self.imageSession invalidateAndCancel];
}


@end
