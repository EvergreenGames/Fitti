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
    if(self.post.userLiked){
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
    }
    else
    {
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    }
}

- (IBAction)likeAction:(id)sender {
    self.likeButton.userInteractionEnabled = false;
    if(self.post.userLiked){
        __weak ImagePostCell* weakSelf = self;
        [self.post removeLikeWithCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(!error){
                [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
            }
            weakSelf.likeButton.userInteractionEnabled = true;
        }];
    }
    else{
        __weak ImagePostCell* weakSelf = self;
        [self.post addLikeWithCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(!error){
                [weakSelf.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
            }
            weakSelf.likeButton.userInteractionEnabled = true;
        }];
    }
}





@end
