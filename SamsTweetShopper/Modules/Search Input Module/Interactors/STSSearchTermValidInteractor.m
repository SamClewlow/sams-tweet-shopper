//
//  STSSearchTermValidInteractor.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSSearchTermValidInteractor.h"


#pragma mark - Implementation

@implementation STSSearchTermValidInteractor


#pragma mark - STSSearchTermValidInteractorInterface

- (BOOL)isSearchTermValid:(NSString *)searchTerm {
    
    // Check if empty
    if ([self isSearchTermEmpty:searchTerm]) {
        return NO;
    }
    
    // Check if too large
    if ([self containsMoreThanNineWords:searchTerm]) {
        return NO;
    }
    
    return YES;
}


#pragma mark - Rules

- (BOOL)isSearchTermEmpty:(NSString *)searchTerm {
    
    // See if there are any chars left in string after trimming whitespace
    if ([searchTerm stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)containsMoreThanNineWords:(NSString *)searchTerm {
    
    // Check if the search term contains more than 9 words
    if ([searchTerm componentsSeparatedByString:@" "].count > 9) {
        return YES;
    } else {
        return NO;
    }
}

@end
