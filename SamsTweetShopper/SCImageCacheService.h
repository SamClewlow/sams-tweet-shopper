//
//  SCImageCacheService.h
//
//  Created by Sam Clewlow on 03/09/2014.
//  Copyright (c) 2014 Sam Clewlow. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef void (^SCImageCacheCompletionHandler)(UIImage *image, NSString *imageURL, NSError *error);

@interface SCImageCacheService : NSObject

/**
 *  Get the singleton instance
 *
 *  @return THe singleton instance of the image cache
 */
+ (instancetype)sharedInstance;

/**
 *  Checks's if the image for a particular URL is cached
 *
 *  @param imageURL The URL of the image
 *
 *  @return YES if the image is cached locally
 */
- (BOOL)isImageCached:(NSString *)imageURL;

/**
 *  Get the image for teh corresponding URL, will be returned locally in-line if the image is already chached
 *
 *  @param imageURL          The URL of the image requested
 *  @param requestIdentifier An identifier that uniquely identifies where the request is coming from, this is to
                             avoid the same image being downloaded multiple times, whilst still ensuring  An example might be
                             a view controller requesting the image for several table view cells. The request identifier
                             might be composed of the view controller name and the cell index.
 *  @param completionHandler A completion handler to run once the request has finished processing.
 */
- (void)getImageForURL:(NSString *)imageURL
     requestIdentifier:(NSString *)requestIdentifier
     completionHandler:(SCImageCacheCompletionHandler)completionHandler;

/**
 *  Deletes all images from the cache, keeping the URLs that are whitelisted in the array
 *
 *  @param urlArray An array of image URL that should not be pruned from the cache
 */
- (void)pruneCacheKeepImagesWithURLs:(NSArray *)urlArray;


@end
