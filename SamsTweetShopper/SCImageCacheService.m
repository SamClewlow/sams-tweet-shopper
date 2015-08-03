//
//  SCImageCacheService.m
//
//  Created by Sam Clewlow on 03/09/2014.
//

#import "SCImageCacheService.h"

#import <CommonCrypto/CommonDigest.h>

#import "SCNetworkService.h"

#define DEFAULT_CACHE_MAP_PATH @"SCImageCache.plist"

@interface SCImageCacheService()
{
    dispatch_queue_t cacheDictionaryQueue;
}

@property (nonatomic, strong) NSMutableDictionary *cacheDictionary;
@property (nonatomic, strong) NSMutableDictionary *imageRequestCompletionBlocks;
@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *cacheFileUrl;

@end


@implementation SCImageCacheService

#pragma mark - Singleton

+ (instancetype)sharedInstance
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    
    return sharedInstance;
}


#pragma mark - Initialiser

- (id)init
{
    if (self = [super init])
    {
        cacheDictionaryQueue = dispatch_queue_create("com.sc.cachequeue", DISPATCH_QUEUE_CONCURRENT);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		self.documentsDirectory = [paths objectAtIndex:0];
		
		// the path to the cache map
		self.cacheFileUrl = [self.documentsDirectory stringByAppendingPathComponent:DEFAULT_CACHE_MAP_PATH];
        
		self.cacheDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:self.cacheFileUrl];
		
		if (self.cacheDictionary == nil )
		{
			self.cacheDictionary = [[NSMutableDictionary alloc] init];
		}
        
        self.imageRequestCompletionBlocks = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Threadsafe Raed/Write Ops

- (id)cachedImageFilenameForURL:(NSString *)URL
{
    __block NSString *filename = nil;
    __weak typeof(self) weakSelf = self;
    
    dispatch_sync(cacheDictionaryQueue, ^{
        
        filename = [weakSelf.cacheDictionary objectForKey:URL];
        //NSLog(@"Filename %@", filename);
        
    });
    
    return filename;
}

- (void)setImageFilename:(NSString *)imageFilename
                  forURL:(NSString *)URL
{
    __weak typeof(self) weakSelf = self;
    
    dispatch_barrier_async(cacheDictionaryQueue, ^{
        
        [weakSelf.cacheDictionary setObject:imageFilename forKey:URL];
    });
}

- (void)removeImageFilenameForURL:(NSString *)URL
{
    __weak typeof(self) weakSelf = self;
    
    dispatch_barrier_async(cacheDictionaryQueue, ^{
        
        [weakSelf.cacheDictionary removeObjectForKey:URL];
    });
}

- (void)removeCachedItemsForKeys:(NSArray *)keys
{
    __weak typeof(self) weakSelf = self;
    
    dispatch_barrier_async(cacheDictionaryQueue, ^{
        
        [weakSelf.cacheDictionary removeObjectsForKeys:keys];
    });
}

- (void)saveCacheDictionaryToDisk
{
    __weak typeof(self) weakSelf = self;
    
    dispatch_barrier_async(cacheDictionaryQueue, ^{
        
        [weakSelf.cacheDictionary writeToFile:weakSelf.cacheFileUrl atomically:YES];
    });
    
}

#pragma mark - Cache Queries

- (BOOL)isImageCached:(NSString *)imageURL
{
    BOOL isCached = NO;
    
    // Check if the image is cached in our dictionary
	NSString *imageFilename = [self cachedImageFilenameForURL:imageURL];
	
	if (imageFilename != nil)
    {
        isCached = YES;
    }
    
    return isCached;
}


- (void)getImageForURL:(NSString *)imageURL
     requestIdentifier:(NSString *)requestIdentifier
     completionHandler:(SCImageCacheCompletionHandler)completionHandler
{
    NSError *imageLoadError = nil;
    
    if (imageURL != nil)
    {
        if ([self isImageCached:imageURL])
        {
            //NSLog(@"Image is cached");
            
            UIImage *imageFromCache = [self getCachedImageForURL:imageURL
                                                           error:&imageLoadError];
            
            if (imageLoadError != nil || imageFromCache == nil)
            {
                //NSLog(@"Image was cached but did not return");
                
                if (imageLoadError != nil)
                {
                    //NSLog(@"Image load error = %@", [imageLoadError description]);
                    
                    // Issue loading the image from cache, trash the image as this is unlikely to change
                    [self deleteImageForURL:imageURL];
                }
                
                //NSLog(@"Downloading Image");
                
                [self downloadImageForURL:imageURL];
                //completionHandler:completionHandler];
                
            }
            else
            {
                if (completionHandler != nil)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        //NSLog(@"Returning image from cache");
                        completionHandler(imageFromCache, imageURL, nil);
                    });
                }
            }
        }
        else
        {
            // We don't have the image cached, first check if a request is in progress
            if (completionHandler != nil && requestIdentifier != nil)
            {
                if (![self isMatchingRequestInProgress:imageURL requestIdentifier:requestIdentifier])
                {
                    // Check if we have any completion block already stored for this image URL
                    NSMutableDictionary *completionBlocks = [self.imageRequestCompletionBlocks objectForKey:imageURL];
                    
                    if (completionBlocks == nil)
                    {
                        // Create a dictionary to hold the completion blocks for this image URL
                        completionBlocks = [[NSMutableDictionary alloc] init];
                        
                        [self.imageRequestCompletionBlocks setObject:completionBlocks forKey:imageURL];
                        
                        [self downloadImageForURL:imageURL];
                    }
                    
                    // Save the current completion block
                    [completionBlocks setObject:[completionHandler copy]
                                         forKey:requestIdentifier];
                    
                }
                else
                {
                    // We have a matching request in progress, replace the stored completion handler
                    // with the one relating to the newest request
                    NSMutableDictionary *completionBlocks = [self.imageRequestCompletionBlocks objectForKey:imageURL];
                    
                    [completionBlocks setObject:[completionHandler copy]
                                         forKey:requestIdentifier];
                    
                }
                
            }
            else
            {
                // We have no completion handler or no request ID, kick off the image download regardless
                [self downloadImageForURL:imageURL];
            }
        }
    }
}

- (BOOL)isMatchingRequestInProgress:(NSString *)imageURL
                  requestIdentifier:(NSString *)requestIdentifier
{
    BOOL matchingRequestInProgress = NO;
    
    // Check if we have any completion block already stored for this image URL
    NSMutableDictionary *completionBlocks = [self.imageRequestCompletionBlocks objectForKey:imageURL];
    
    if (completionBlocks != nil)
    {
        // We have some stored, at least one request in is progress, we want to tie the new request to the old one
        // If the identiefers match, we can ignore the the current request
        SCImageCacheCompletionHandler completionBlock = [completionBlocks objectForKey:requestIdentifier];
        
        if (completionBlock != nil)
        {
            // Request is already in progress
            matchingRequestInProgress = YES;
        }
    }
    
    
    return matchingRequestInProgress;
}

#pragma mark - Network Communication

- (void)downloadImageForURL:(NSString *)imageUrl
{
    __weak typeof(self) weakSelf = self;
    
    // Image downlading
    
    [[SCNetworkService sharedInstance] downloadImageForURL:imageUrl completion:^(id responseObject, NSError *error) {
        
        if (error == nil) {
        
        if ([responseObject isKindOfClass:[UIImage class]])
        {
            [weakSelf addImageToCache:(UIImage *)responseObject
                        withRemoteURL:imageUrl];
        }
        
        NSMutableDictionary *completionHandlers = weakSelf.imageRequestCompletionBlocks[imageUrl];
        
        if (completionHandlers != nil)
        {
            for (id key in completionHandlers.allKeys)
            {
                SCImageCacheCompletionHandler completionHandler = completionHandlers[key];
                completionHandler(responseObject, imageUrl, nil);
            }
            
        }
        
        [weakSelf.imageRequestCompletionBlocks removeObjectForKey:imageUrl];
        
        } else {
            
            NSError *localError = nil;
            if (error != nil)
            {
                // TODO: Convert to local error
                localError = [NSError errorWithDomain:@"TODO" code:0 userInfo:nil];
                
                NSMutableDictionary *completionHandlers = weakSelf.imageRequestCompletionBlocks[imageUrl];
                
                if (completionHandlers != nil)
                {
                    for (id key in completionHandlers.allKeys)
                    {
                        SCImageCacheCompletionHandler completionHandler = completionHandlers[key];
                        completionHandler(nil, imageUrl, localError);
                    }
                }
                
                [weakSelf.imageRequestCompletionBlocks removeObjectForKey:imageUrl];
            }
        }
    }];
}

#pragma mark - Cache Access

- (UIImage *)getCachedImageForURL:(NSString *)url
                            error:(NSError **)error
{
	//NSString *imageFilename = [self cachedImageFilenameForURL:url];
    NSString *imageFilename = [self.documentsDirectory stringByAppendingPathComponent:[self cachedImageFilenameForURL:url]];
	NSData *data = nil;
	
    NSError *loadError = nil;
    
	if (imageFilename != nil)
	{
		data = [NSData dataWithContentsOfFile:imageFilename
                                      options:0
                                        error:&loadError];
	}
	
    //NSLog(@"LOAD ERROR: @%", loadError);
    
    if (data != nil)
    {
        
        //NSLog(@"Image is OK!");
        UIImage *image = [UIImage imageWithData:data scale:[[UIScreen mainScreen] scale]];
        return image;
    }
    else
    {
        //NSLog(@"Image load failed!");
        if (error != NULL)
        {
            *error = [NSError errorWithDomain:@"TODO image cach domain"
                                         code:0
                                     userInfo:nil];
        }
        return nil;
    }
}

- (void)addImageToCache:(UIImage *)image
          withRemoteURL:(NSString *)url;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Delete the old image, if it exists
        if ([self isImageCached:url])
        {
            [self deleteImageForURL:url];
        }
        
        BOOL result = NO;
        
        NSString *imageFileName = [self sha1String:url];
        
        if (imageFileName != nil)
        {
            // the path to the cached image file
            NSString *cachedImageFilePath = [self.documentsDirectory stringByAppendingPathComponent:imageFileName];
            
            result = [UIImagePNGRepresentation(image) writeToFile:cachedImageFilePath atomically:YES];
            
            if (result == YES)
            {
                // add the cached file to the dictionary
                [self setImageFilename:imageFileName forURL:url];
                [self saveCacheDictionaryToDisk];
                
            }
            else
            {
                //NSLog(@"Failed to save image!");
            }
        }
    });
}

- (void)deleteImageForURL:(NSString *)url
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //double startTime = [[NSDate date] timeIntervalSince1970] * 1000;
        
        BOOL success = NO;
        
        // Check the image is actually cached
        if ([self isImageCached:url])
        {
            NSString *imageFileName = [self sha1String:url];
            
            if (imageFileName != nil)
            {
                // Delete the image from the cache
                NSString *cachedImageFilePath = [self.documentsDirectory stringByAppendingPathComponent:imageFileName];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                /*
                 if ([fileManager fileExistsAtPath:cachedImageFilePath isDirectory:NO])
                 {
                 NSLog(@"file exists at path %@", cachedImageFilePath);
                 }
                 else
                 {
                 NSLog(@"file does not exist!");
                 }
                 */
                
                NSError *error;
                success = [fileManager removeItemAtPath:cachedImageFilePath error:&error];
                if (success)
                {
                    // If we have successfully deleted the image, remove the reference from the dictionary
                    [self removeImageFilenameForURL:url];
                    [self saveCacheDictionaryToDisk];
                    //NSLog(@"Deleted image");
                    
                }
                else
                {
                    //NSLog(@"Could not delete file -:%@ ", [error localizedDescription]);
                }
            }
        }
        
    });
}

#pragma mark - Housekeeping

// TODO: CHECK THIS ISN'T BROKEN!

// Accepts an array of URLs
- (void)pruneCacheKeepImagesWithURLs:(NSArray *)urlArray
{
    NSMutableDictionary *tempDictionary = [NSMutableDictionary dictionaryWithDictionary:self.cacheDictionary];
    
    for (NSString *key in tempDictionary)
    {
        if (![urlArray containsObject:key])
        {
            [self deleteImageForURL:key];
        }
    }
    
    [self justifyCacheDictionary];
}

// Checks the validity of all the images listed in the dictionary on a background thread
- (void)justifyCacheDictionary
{
    // Copy the dictonary for thread safety
    NSDictionary *cacheDictonaryCopy = [NSDictionary dictionaryWithDictionary:self.cacheDictionary];
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
        
        NSMutableArray *missingImageArray = [[NSMutableArray alloc] init];
        
        for (NSString *key in cacheDictonaryCopy)
        {
            @autoreleasepool {
                
                NSError *error = nil;
                UIImage *image  = [self getCachedImageForURL:key
                                                       error:&error];
                
                if (image == nil)
                {
                    [missingImageArray addObject:key];
                }
                
                image = nil;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Remove all key that no longer contain images
            [weakSelf removeCachedItemsForKeys:missingImageArray];
        });
    });
}

- (NSString *)sha1String:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end
