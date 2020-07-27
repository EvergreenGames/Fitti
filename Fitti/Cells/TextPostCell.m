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

@end

@implementation TextPostCell

- (void)setPost:(Post *)post {
    _post = post;
    
    self.titleLabel.text = post.title;
    self.contentLabel.text = post.textContent;
    self.usernameLabel.text = post.author.username;
}

- (IBAction)likeAction:(id)sender {
    
}

@end
