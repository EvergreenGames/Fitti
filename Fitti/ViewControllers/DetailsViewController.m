//
//  DetailsViewController.m
//  Fitti
//
//  Created by Ruben Green on 7/20/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.post){
        self.titleLabel.text = self.post.title;
        self.contentLabel.text = self.post.textContent;
        self.usernameLabel.text = self.post.author.username;
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
