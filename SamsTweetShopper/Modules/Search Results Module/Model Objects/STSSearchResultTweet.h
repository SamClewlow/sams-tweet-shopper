//
//  STSSearchResultTweet.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSSearchResultTweet : NSObject

@property (nonatomic, strong, readonly) NSString *statusBody;
@property (nonatomic, strong, readonly) NSString *avatarURL;
@property (nonatomic, strong, readonly) NSString *tweetID;
@property (nonatomic, strong, readonly) NSString *screenName;
@property (nonatomic, strong, readonly) NSDate *createdAtDate;

- (instancetype)initWithStatus:(NSString *)statusBody
              profileAvatarURL:(NSString *)avatarURL
                       tweetID:(NSString *)tweetID
                    screenName:(NSString *)screenName
                     createdAt:(NSDate *)createdAtDate;

@end
