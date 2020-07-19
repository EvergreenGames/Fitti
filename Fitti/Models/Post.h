//
//  Post.h
//  Fitti
//
//  Created by Ruben Green on 7/14/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString* postID;
@property (nonatomic) PFGeoPoint* location;

@property (nonatomic, strong) PFUser* author;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* textContent;
@property (nonatomic, strong, nullable) PFFileObject* image;
@property (nonatomic, strong) NSString* postType; //"text" or "image"

@end

NS_ASSUME_NONNULL_END
