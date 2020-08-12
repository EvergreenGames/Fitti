//
//  Post.m
//  Fitti
//
//  Created by Ruben Green on 7/14/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "Post.h"
#import <Parse/Parse.h>
#import "LocationManager.h"

@implementation Post

@dynamic postID;
@dynamic location;

@dynamic locationName;
@dynamic author;
@dynamic title;
@dynamic textContent;
@dynamic image;
@dynamic aspectRatio;
@dynamic postType;

@dynamic likeCount;

@synthesize userLiked = _userLiked;

+ (NSString *)parseClassName{
    return @"Post";
}

+ (PFFileObject*)getPFFileFromImage:(UIImage* _Nullable)image{
    if(!image){
        return nil;
    }
    
    NSData* imageData = UIImagePNGRepresentation(image);
    
    if(!imageData){
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

- (void)addLikeWithCompletion:(PFBooleanResultBlock)completion {
    PFUser* user = [PFUser currentUser];
    PFRelation* likeRelation = [user relationForKey:@"likes"];
    [likeRelation addObject:self];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error liking post: %@", error.localizedDescription);
            completion(false, error);
        }
        else{
            [self incrementKey:@"likeCount"];
            [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(error){
                    NSLog(@"Error incrementing post likes: %@", error.localizedDescription);
                    completion(false, error);
                }
                else{
                    completion(true, nil);
                    self.userLiked = true;
                }
            }];
        }
    }];
}

- (void)removeLikeWithCompletion:(PFBooleanResultBlock)completion {
    PFUser* user = [PFUser currentUser];
    PFRelation* likeRelation = [user relationForKey:@"likes"];
    [likeRelation removeObject:self];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error unliking post: %@", error.localizedDescription);
            completion(false, error);
        }
        else{
            [self incrementKey:@"likeCount" byAmount:@(-1)];
            [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(error){
                    NSLog(@"Error decrementing post likes: %@", error.localizedDescription);
                    completion(false, error);
                }
                else{
                    completion(true, nil);
                    self.userLiked = false;
                }
            }];
        }
    }];
}

@end
