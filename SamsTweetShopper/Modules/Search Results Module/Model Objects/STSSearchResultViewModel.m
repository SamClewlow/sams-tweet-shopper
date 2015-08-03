//
//  STSSearchResultViewModel.m
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import "STSSearchResultViewModel.h"

@implementation STSSearchResultViewModel

- (instancetype)initWithResultContent:(NSString *)resultContent
                             imageURL:(NSString *)imageURL
                           screenName:(NSString *)screenName
                           isFavorite:(BOOL)isFavorite {
    
    if (self = [super init]) {
        
        _resultContent = resultContent;
        _imageURL = imageURL;
        _isFavorite = isFavorite;
        _screenName = screenName;
    }
    
    return self;
}

@end
