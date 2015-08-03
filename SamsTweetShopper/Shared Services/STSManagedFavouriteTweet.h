//
//  STSManagedFavouriteTweet.h
//  
//
//  Created by Sam Clewlow on 03/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface STSManagedFavouriteTweet : NSManagedObject

@property (nonatomic, retain) NSString * statusBody;
@property (nonatomic, retain) NSString * avatarURL;
@property (nonatomic, retain) NSString * screenName;
@property (nonatomic, retain) NSString * tweetId;
@property (nonatomic, retain) NSDate * createdAt;

@end
