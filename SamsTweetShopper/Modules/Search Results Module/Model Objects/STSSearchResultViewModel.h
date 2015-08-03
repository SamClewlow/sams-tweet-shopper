//
//  STSSearchResultViewModel.h
//  SamsTweetShopper
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSSearchResultViewModel : NSObject

@property (nonatomic, readonly) BOOL isFavorite;
@property (nonatomic, readonly) NSString *resultContent;
@property (nonatomic, readonly) NSString *imageURL;
@property (nonatomic, readonly) NSString *screenName;

- (instancetype)initWithResultContent:(NSString *)resultContent
                             imageURL:(NSString *)imageURL
                           screenName:(NSString *)screenName
                           isFavorite:(BOOL)isFavorite;

@end
