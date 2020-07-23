//
//  ImagePostCell.m
//  Fitti
//
//  Created by Ruben Green on 7/21/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "ImagePostCell.h"

@import Parse;

@interface ImagePostCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet PFImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageAspectConstraint;

@end

@implementation ImagePostCell

- (void)setPost:(Post *)post {
    _post = post;
    
    self.titleLabel.text = post.title;
    self.contentImageView.image = [UIImage imageNamed:@"photo"];
    [self.imageAspectConstraint setConstant:self.post.aspectRatio];
    self.contentImageView.file = post.image;
    self.usernameLabel.text = post.author.username;
    [self.contentImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error fetching image: %@", error.localizedDescription);
        }
        else
        {
            self.contentImageView.image = image;
            [self.contentImageView invalidateIntrinsicContentSize];
        }
    }];
}

@end
