//
//  LoginViewController.m
//  Fitti
//
//  Created by Ruben Green on 7/14/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "LoginViewController.h"
#import "SceneDelegate.h"
#import <Parse/Parse.h>
#import "LocationManager.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //TESTING
    //TODO: Present this in a better way
    [LocationManager.sharedManager.locManager requestWhenInUseAuthorization];
}

- (IBAction)loginAction:(id)sender {
    [self loginUserWithUsername:self.usernameField.text password:self.passwordField.text];
}

- (IBAction)registerAction:(id)sender {
    [self registerUser];
}
- (IBAction)dismissKeyboardAction:(id)sender {
    [self.view endEditing:YES];
}

- (void)registerUser {
    PFUser* newUser = [PFUser new];
    
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        //TODO: check username is taken
        if(error){
            NSLog(@"Error registering: %@", error.localizedDescription);
        }
        else{
            [self loginUserWithUsername:newUser.username password:newUser.password];
        }
    }];
}

- (void)loginUserWithUsername:(NSString*)username password:(NSString*)password {
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        //TODO: check username/pass is blank
        if(error)
        {
            NSLog(@"Error logging in: %@", error.localizedDescription);
        }
        else {
            [self switchToMainView];
        }
    }];
}

- (void)switchToMainView {
    SceneDelegate* sceneDelegate = (SceneDelegate*)self.view.window.windowScene.delegate;
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController* homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeTabBarController"];
    sceneDelegate.window.rootViewController = homeViewController;
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
