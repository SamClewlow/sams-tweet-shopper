//
//  STSTwitterAccessInteractor.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSTwitterAccessInteractor.h"

@import Accounts;

// Internal Constants
NSString * const kUserHasBeenAskedForAuthKey = @"kUserHasBeenAskedForAuthKey";


#pragma mark - Interface

@interface STSTwitterAccessInteractor()

@property (nonatomic, strong) ACAccountStore *accountStore;

@end


#pragma mark - Implementation

@implementation STSTwitterAccessInteractor


#pragma mark - Init

- (instancetype)init {
    
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshAccounts:)
                                                     name:ACAccountStoreDidChangeNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - STSTwitterAccessInteractorInterface

- (STSTwitterAccessResponse)twitterAccessCurrentStatus {
    
    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Has the user been asked before?
    if (![self userHasBeenAskedBefore]) {
        
        return STSTwitterAccessResponseNotAsked;
        
    } else if ([accountType accessGranted]) {
        
        if ([self.accountStore accountsWithAccountType:accountType].count == 0) {
            
            // We have access, but no accounts
            return STSTwitterAccessResponseNoAccounts;
            
        } else {
            
            // We have access and accounts!
            return STSTwitterAccessResponseGranted;
        }
    } else {
        
        // No access :(
        return STSTwitterAccessResponseDenied;
    }
}

- (void)requestAccessToTwitterWithCompletion:(void (^)(STSTwitterAccessResponse response))completion {
    
    STSTwitterAccessResponse currentStatus = [self twitterAccessCurrentStatus];
    
    // Check the current status
    if (currentStatus == STSTwitterAccessResponseNoAccounts
        || currentStatus == STSTwitterAccessResponseDenied
        || currentStatus == STSTwitterAccessResponseGranted) {
        
        // No point in requesting again in these scenarios
        if (completion != nil) {
        
            completion(currentStatus);
        }
        return;
        
    } else {
    
        //  User has not yet been asked, lets do it...
        
        ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        __weak typeof(self) weakSelf = self;
        
        // Request access
        [self.accountStore requestAccessToAccountsWithType:accountType
                                                   options:nil
                                                completion:^(BOOL granted, NSError *error) {
                                                    
                                                    // Run the completion block on the main thread.
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        [weakSelf setUserHasBeenAsked];
                                                        
                                                        if (completion != nil) {
                                                            
                                                            if (granted) {
                                                                completion([weakSelf twitterAccessCurrentStatus]);
                                                            } else {
                                                                completion(STSTwitterAccessResponseDenied);
                                                            }
                                                        }
                                                    });
                                                    
                                                }];
    }
}


#pragma mark - Internal Helpers

- (BOOL)userHasBeenAskedBefore {
    
    // Will return NO if key does not exist
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasBeenAskedForAuthKey];
}

- (void)setUserHasBeenAsked {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:kUserHasBeenAskedForAuthKey];
}


#pragma mark - Listeners

- (void)refreshAccounts:(NSNotification *)notification {
    
    // Release the current accout store so it will be recreated and refreshed.
    _accountStore = nil;
    
    // Let the presenter know the state may have changed
    [self.presenter twitterAuthStatusUpdated:[self twitterAccessCurrentStatus]];
}


#pragma mark - Lazy Loaded Properties

- (ACAccountStore *)accountStore {
    
    if (_accountStore == nil) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    
    return _accountStore;
}

@end
