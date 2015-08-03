//
//  STSTwitterSearchInteractor.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSTwitterSearchInteractor.h"

@import Accounts;
@import Social;

// Models
#import "STSSearchResultTweet.h"

// Internal Constants
NSString * const kTwitterSearchBaseURL = @"https://api.twitter.com/1.1/search/tweets.json";
NSString * const kCountKey = @"count";
NSString * const kQueryKey = @"q";
NSString * const kCountNumber = @"50";

#pragma mark - Interface

@interface STSTwitterSearchInteractor()

@property (nonatomic, strong) ACAccountStore *accountStore;

@end


#pragma mark - Implementation

@implementation STSTwitterSearchInteractor

// This method is generally happy path only due to time constraints!
- (void)performSearchForSearchTerm:(NSString *)searchTerm
                        completion:(void (^)(NSArray *results, NSError *error))completion {
    
    ACAccountType *acType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    __weak typeof(self) weakSelf = self;
    
    // Double check we have access to the Twitter accounts
    [self.accountStore requestAccessToAccountsWithType:acType
                                               options:nil
                                            completion:^(BOOL granted, NSError *error) {
        
        if (granted && [self.accountStore accountsWithAccountType:acType].count > 0) {
            
            // Build the SLRequest
            NSURL *url = [NSURL URLWithString:kTwitterSearchBaseURL];
            NSDictionary *parameters = @{kCountKey : kCountNumber,
                                         kQueryKey : [[self createSearchQueryString:searchTerm] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
            
            SLRequest *slRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                      requestMethod:SLRequestMethodGET
                                                                URL:url
                                                         parameters:parameters];
            
            NSArray *accounts = [weakSelf.accountStore accountsWithAccountType:acType];
            slRequest.account = [accounts lastObject];
            
            // Perform the search
            [slRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                
                NSArray *results = nil;
                
                if (responseData != nil && error == nil) {
                    
                    // Parse results
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseData
                                                                           options:NSJSONReadingAllowFragments error:nil];
                    
                    results = [weakSelf parseJSONResult:result];

                }
                
                // Call the completion block on the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (completion != nil) {
                        completion(results, error);
                    }
                });
            }];
            
        } else {
            
            // TODO: More comprehensive error handling.......
            NSError *error = [NSError errorWithDomain:@"STSSearchResultDomain"
                                                 code:0
                                             userInfo:nil];
            
            if (completion != nil) {
                completion(nil, error);
            }
        }
    }];
}


#pragma mark - Processing

- (NSString *)createSearchQueryString:(NSString *)rawQuery {
 
    // Add for sale onto search term to make results relevant to shopping
    return [@"#forsale " stringByAppendingString:rawQuery];
    
}

- (NSArray *)parseJSONResult:(NSDictionary *)JSONResult {
    
    NSMutableArray *parsedTweets = [NSMutableArray new];
    
    // Loop through and parse out basic data
    for (NSDictionary *tweetDictionary in JSONResult[@"statuses"]) {
        
        // TODO: This parsing code is rudimentry, and is only allowing for happy path.
        // in a real world situation I would implement type checking and take other
        // precautions. I was very tight for time! 
        
        NSString *statusBody = tweetDictionary[@"text"];
        NSString *imageURL = [tweetDictionary valueForKeyPath:@"user.profile_image_url"];
        NSString *tweetID = tweetDictionary[@"id_str"];
        NSDate *tweetTime = [self convertTwitterDateToNSDate:tweetDictionary[@"created_at"]];
        NSString *screenName = [tweetDictionary valueForKeyPath:@"user.screen_name"];
        
        STSSearchResultTweet *tweet = [[STSSearchResultTweet alloc] initWithStatus:statusBody
                                                                  profileAvatarURL:imageURL
                                                                           tweetID:tweetID
                                                                        screenName:screenName
                                                                         createdAt:tweetTime];
        
        [parsedTweets addObject:tweet];
    }
    
    // Return a non mutable variant
    return [NSArray arrayWithArray:parsedTweets];
}

- (NSDate *)convertTwitterDateToNSDate:(NSString *)dateString
{
    static NSDateFormatter* df = nil;
    
    // Only make this once!
    if (df == nil) {
        
        df = [[NSDateFormatter alloc] init];
        [df setTimeStyle:NSDateFormatterFullStyle];
        [df setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    }
    
    NSDate *convertedDate = [df dateFromString:dateString];
    
    return convertedDate;
}


#pragma mark - Lazy Properties

- (ACAccountStore *)accountStore {
    
    if (!_accountStore) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return _accountStore;
}

@end
