//
//  DetailsViewController.m
//  Fitti
//
//  Created by Ruben Green on 7/20/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "DetailsViewController.h"
@import Parse;

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageAspectConstraint;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.post){
        self.titleLabel.text = self.post.title;
        self.usernameLabel.text = self.post.author.username;
        if(self.post.userLiked){
            [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
        }
        else
        {
            [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
        }
        if([self.post.postType isEqualToString:@"text"]){
            self.contentLabel.text = self.post.textContent;
            self.textHeightConstraint.active = false;
            self.imageHeightConstraint.active = true;
        }
        else if([self.post.postType isEqualToString:@"image"]){
            self.textHeightConstraint.active=true;
            self.imageAspectConstraint.constant = self.post.aspectRatio;
            self.imageHeightConstraint.active=false;
            self.contentImageView.file = self.post.image;
            [self.contentImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
                if(error){
                    NSLog(@"Error loading image: %@", error.localizedDescription);
                }
            }];
        }
    }
}

- (IBAction)likeAction:(id)sender {
    self.likeButton.userInteractionEnabled = false;
    if(self.post.userLiked){
        __weak DetailsViewController* weakSelf = self;
        [self.post removeLikeWithCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(!error){
                [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
            }
            weakSelf.likeButton.userInteractionEnabled = true;
        }];
    }
    else{
        __weak DetailsViewController* weakSelf = self;
        [self.post addLikeWithCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(!error){
                [weakSelf.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
            }
            weakSelf.likeButton.userInteractionEnabled = true;
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
