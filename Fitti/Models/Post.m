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
@dynamic latitude;
@dynamic longitude;

@dynamic author;
@dynamic title;
@dynamic textContent;
@dynamic image;
@dynamic postType;

- (instancetype)init{
    self = [super init];
    if (self) {
        self.latitude = LocationManager.sharedManager.currentLocation.coordinate.latitude;
        self.longitude = LocationManager.sharedManager.currentLocation.coordinate.longitude;
        
        self.author = PFUser.currentUser;
        self.title = @"";
        self.textContent = @"";
        self.image = nil;
        self.postType = @"text"; //just to be safe
    }
    return self;
}

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



@end
