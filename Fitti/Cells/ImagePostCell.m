//
//  ImagePostCell.m
//  Fitti
//
//  Created by Ruben Green on 7/21/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "ImagePostCell.h"
#import "DateTools.h"

@import Parse;

@interface ImagePostCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet PFImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageAspectConstraint;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *likeCounter;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;


@property (weak, nonatomic) IBOutlet UIView *clippingView;

@end

@implementation ImagePostCell

- (void)setPost:(Post *)post {
    _post = post;
    
    self.titleLabel.text = post.title;
    self.contentImageView.image = [UIImage imageNamed:@"photo"];
    [self.imageAspectConstraint setConstant:self.post.aspectRatio];
    self.contentImageView.file = post.image;
    self.usernameLabel.text = post.author.username;
    self.locationLabel.text = post.locationName;
    self.timeAgoLabel.text = post.createdAt.shortTimeAgoSinceNow;
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
    self.likeCounter.text = [NSString stringWithFormat:@"%i", self.post.likeCount];
    
    self.contentView.backgroundColor = UIColor.clearColor;
    self.contentView.layer.shadowOpacity = 0.3;
    self.contentView.layer.shadowRadius = 4;
    self.contentView.layer.shadowColor = UIColor.grayColor.CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(3, 3);
    
    self.clippingView.layer.cornerRadius = 10;
    self.clippingView.backgroundColor = UIColor.whiteColor;
    self.clippingView.layer.masksToBounds = true;
    
    self.contentImageView.layer.cornerRadius = 10;
    self.contentImageView.clipsToBounds = true;
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
