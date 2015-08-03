//
//  STSSearchResultTweet.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSSearchResultTweet.h"

#pragma mark - Implementation

@implementation STSSearchResultTweet

- (instancetype)initWithStatus:(NSString *)statusBody
              profileAvatarURL:(NSString *)avatarURL
                       tweetID:(NSString *)tweetID
                    screenName:(NSString *)screenName
                     createdAt:(NSDate *)createdAtDate {
    
    if (self = [super init]) {
        
        _statusBody = statusBody;
        _avatarURL = avatarURL;
        _tweetID = tweetID;
        _screenName = screenName;
        _createdAtDate = createdAtDate;
    }
    
    return self;
}

@end
