//
//  HomeViewController.m
//  Fitti
//
//  Created by Ruben Green on 7/15/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "HomeViewController.h"
#import "SceneDelegate.h"
#import "ErrorMessageView.h"
#import "LocationManager.h"
#import <Parse/Parse.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LocationManager startUpdatingLocation];
    [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.navigationItem.title = [LocationManager sharedManager].currentPlacemark.name;
    }];
}
- (IBAction)logoutAction:(id)sender {
    [self logoutUser];
}

- (void)logoutUser {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error){
            NSLog(@"Error logging out: %@", error.localizedDescription);
            [ErrorMessageView errorMessageWithString:@"Failed to log out"];
        }
        else{
            SceneDelegate* sceneDelegate = (SceneDelegate*)self.view.window.windowScene.delegate;
            
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController* homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            sceneDelegate.window.rootViewController = homeViewController;
        }
    }];
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
