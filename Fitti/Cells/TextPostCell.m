//
//  TextPostCell.m
//  Fitti
//
//  Created by Ruben Green on 7/18/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "TextPostCell.h"

@interface TextPostCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation TextPostCell

- (void)setPost:(Post *)post {
    _post = post;
    
    self.titleLabel.text = post.title;
    self.contentLabel.text = post.textContent;
    self.usernameLabel.text = post.author.username;
    if(self.post.userLiked){
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
    }
    else
    {
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    }
}

//errors if you press too quickly
- (IBAction)likeAction:(id)sender {
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
            }];
        }
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
            }];
        }
    }];
}

@end
