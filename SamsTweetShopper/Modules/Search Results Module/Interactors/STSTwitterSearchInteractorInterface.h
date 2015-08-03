//
//  STSTwitterSearchInteractorInterface.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STSTwitterSearchInteractorInterface <NSObject>

/**
 *  Performs a Twitter search
 *
 *  @param searchTerm The term to search
 *  @param completion Block to run on completion
 */
- (void)performSearchForSearchTerm:(NSString *)searchTerm
                        completion:(void (^)(NSArray *results, NSError *error))completion;


@end
