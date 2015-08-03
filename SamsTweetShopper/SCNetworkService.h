//
//  SCNetworkService.h
//  World Weather
//
//  Created by Sam Clewlow on 02/12/2014.
//  Copyright (c) 2014 Sam Clewlow. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef void (^SCNetworkServiceCompletion)(id responseObject, NSError *error);
typedef void (^SCNetworkServiceImageCompletion)(UIImage *image, NSError *error);

@interface SCNetworkService : NSObject

/**
 *  Retrieve a reference to the singleton instance
 *
 *  @return A reference to the singleton instance
 */
+ (instancetype)sharedInstance;

/**
 *  Makes a HTTP GET request, calling the completion block on the main thread when the request finishes
 *
 *  @param path The url path
 *  @param completion A block to run on completion
 *
 *  @return NSURLSessionDataTask a reference to the data task, can be used to cancel requests
 */
- (NSURLSessionDataTask *)getRequestWithURLString:(NSString *)URLString
                                       completion:(SCNetworkServiceCompletion)completion;

/**
 *  Downloads an image from the URL passed in
 *
 *  @param URLString The image URL
 *  @param completion A block to run on completion
 *
 *  @return NSURLSessionDataTask a reference to the data task, can be used to cancel requests.
 */
- (NSURLSessionDataTask *)downloadImageForURL:(NSString *)imageURL
                                      completion:(SCNetworkServiceCompletion)completion;

@end
