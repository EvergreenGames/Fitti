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

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
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
- (IBAction)likeAction:(id)sender {
    self.likeButton.userInteractionEnabled = false;
    if(self.post.userLiked){
        [self removeLike];
    }
    else{
        [self addLike];
    }
}

- (void)addLike {
    PFUser* user = [PFUser currentUser];
    PFRelation* likeRelation = [user relationForKey:@"likes"];
    [likeRelation addObject:self.post];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error liking post: %@", error.localizedDescription);
        }
        else{
            [self.post incrementKey:@"likeCount"];
            [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(error){
                    NSLog(@"Error incrementing post likes: %@", error.localizedDescription);
                }
                else{
                    [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
                    self.post.userLiked = true;
                }
                self.likeButton.userInteractionEnabled = true;
            }];
        }
        self.likeButton.userInteractionEnabled = true;
    }];
}

- (void)removeLike {
    PFUser* user = [PFUser currentUser];
    PFRelation* likeRelation = [user relationForKey:@"likes"];
    [likeRelation removeObject:self.post];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error unliking post: %@", error.localizedDescription);
        }
        else{
            [self.post incrementKey:@"likeCount" byAmount:@(-1)];
            [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(error){
                    NSLog(@"Error decrementing post likes: %@", error.localizedDescription);
                }
                else{
                    [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
                    self.post.userLiked = false;
                }
                self.likeButton.userInteractionEnabled = true;
            }];
        }
        self.likeButton.userInteractionEnabled = true;
    }];
}

@end
