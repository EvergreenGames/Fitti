//
//  SortingManager.h
//  Fitti
//
//  Created by Ruben Green on 7/30/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface SortingManager : NSObject

+ (NSArray*) sortPostsHot:(NSArray*)posts withLocation:(CLLocation*)point;

+ (float) scoreForPost:(Post*)post withLocation:(CLLocation*)point;

@end

NS_ASSUME_NONNULL_END
