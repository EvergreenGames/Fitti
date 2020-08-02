//
//  SortingManager.m
//  Fitti
//
//  Created by Ruben Green on 7/30/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "SortingManager.h"

const float SORT_GRAVITY=1;
const float SORT_DIST=1;
const float SORT_DIST_RAMP=2;

@implementation SortingManager

+ (NSArray*) sortPostsHot:(NSArray*)posts withLocation:(CLLocation*)point{
    CFTypeRef pointRef = CFBridgingRetain(point);
    NSArray<Post*>* ret = [posts sortedArrayUsingFunction:comparePosts context:pointRef];
    CFRelease(pointRef);
    return ret;
}

NSInteger comparePosts(id p1, id p2, void *context){
    int v1 = [SortingManager scoreForPost:p1 withLocation:(__bridge CLLocation * _Nonnull)(context)]*1000;
    int v2 = [SortingManager scoreForPost:p2 withLocation:(__bridge CLLocation * _Nonnull)(context)]*1000;
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

+ (float) scoreForPost:(Post*)post withLocation:(CLLocation*)point{
    double dist = [post.location distanceInMilesTo:[PFGeoPoint geoPointWithLocation:point]]*SORT_DIST;
    return (post.likeCount-1)/pow(([post.createdAt timeIntervalSinceNow]/3600)+2,SORT_GRAVITY)+pow(dist,SORT_DIST_RAMP);
}

@end
