//
//  STSTwitterAccessInteractorInterface.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, STSTwitterAccessResponse) {
    STSTwitterAccessResponseNotAsked,
    STSTwitterAccessResponseGranted,
    STSTwitterAccessResponseNoAccounts,
    STSTwitterAccessResponseDenied
};

@protocol STSTwitterAccessInteractorInterface <NSObject>

/**
 *  Get the current status of the users Twitter account auth status
 *
 *  @return An STSTwitterAccessResponse indicating the current status.
 */
- (STSTwitterAccessResponse)twitterAccessCurrentStatus;

/**
 *  Request access to the users Twitter account. The result of the request is returned in the completion block
 *
 *  @param completion A block to run once the reques is complete. The 'response' parameter indicates the 
 *                    result of the request.
 */
- (void)requestAccessToTwitterWithCompletion:(void (^)(STSTwitterAccessResponse response))completion;

@end
