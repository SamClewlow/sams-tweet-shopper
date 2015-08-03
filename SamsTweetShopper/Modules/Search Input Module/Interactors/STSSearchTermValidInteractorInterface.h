//
//  STSSearchTermValidInteractorInterface.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Perfomrs local validation checks on the search term pre-flight.
 *  Currently applies to Twiter API guidelines
 *  1. No empty strings
 *  2. No search terms containing more than 9 separate words
 *
 *  Could easily be extented to with more rules if needed.
 */
@protocol STSSearchTermValidInteractorInterface <NSObject>



/**
 *  Call this to validate the search term before we send it to Twitter
 *
 *  @param searchTerm The search term to check.
 *
 *  @return YES if the string is a valid search term
 */
- (BOOL)isSearchTermValid:(NSString *)searchTerm;

@end
