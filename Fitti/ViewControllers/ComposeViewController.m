//
//  ComposeViewController.m
//  Fitti
//
//  Created by Ruben Green on 7/18/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "ComposeViewController.h"
#import "LocationManager.h"
#import "Post.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *contentField;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)cancelAction:(id)sender {
    //TODO: modality
}

- (IBAction)postAction:(id)sender {
    [self createPostWithCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error creating post: %@", error.localizedDescription);
        }
        else {
            self.titleField.text = @"";
            self.contentField.text = @"";
            [self.view endEditing:YES];
        }
    }];
}

- (void)createPostWithCompletion:(PFBooleanResultBlock)completion {
    Post* post = [Post new];
    post.location = [PFGeoPoint geoPointWithLocation:LocationManager.sharedManager.currentLocation];
    post.author = PFUser.currentUser;
    
    post.title = self.titleField.text;
    post.textContent = self.contentField.text;
    post.image = nil;
    post.postType = @"text";
    
    [post saveInBackgroundWithBlock:completion];
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
