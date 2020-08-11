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
#import "ErrorMessageView.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.usernameField.layer.cornerRadius=8;
    self.usernameField.layer.borderWidth=1;
    self.usernameField.layer.borderColor=UIColor.lightGrayColor.CGColor;
    self.usernameField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0);
    self.passwordField.layer.cornerRadius=8;
    self.passwordField.layer.borderWidth=1;
    self.passwordField.layer.borderColor=UIColor.lightGrayColor.CGColor;
    self.passwordField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0);
    
    self.loginButton.layer.cornerRadius=8;
    self.loginButton.clipsToBounds=true;

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

- (IBAction)usernameSelectedAction:(id)sender {
    ((UITextField*)sender).layer.borderColor=[UIColor colorWithRed:0.933 green:0.316 blue:0.335 alpha:1].CGColor;
}
- (IBAction)usernameDeselectedAction:(id)sender {
    ((UITextField*)sender).layer.borderColor=UIColor.lightGrayColor.CGColor;
}
- (IBAction)passwordSelectedAction:(id)sender {
    ((UITextField*)sender).layer.borderColor=[UIColor colorWithRed:0.933 green:0.316 blue:0.335 alpha:1].CGColor;
}
- (IBAction)passwordDeselectedAction:(id)sender {
    ((UITextField*)sender).layer.borderColor=UIColor.lightGrayColor.CGColor;
}


- (void)registerUser {
    PFUser* newUser = [PFUser new];
    
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        //TODO: check username is taken
        if(error){
            NSLog(@"Error registering: %@", error.localizedDescription);
            [ErrorMessageView errorMessageWithString:@"There was an issue creating your account. Please try again."];
        }
        else{
            [self loginUserWithUsername:newUser.username password:newUser.password];
        }
    }];
}

- (void)loginUserWithUsername:(NSString*)username password:(NSString*)password {
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if(username.length==0 || password.length==0){
            [ErrorMessageView errorMessageWithString:@"Please enter a username and password"];
        }
        if(error)
        {
            NSLog(@"Error logging in: %@", error.localizedDescription);
            [ErrorMessageView errorMessageWithString:@"Unable to log in. Please try again."];
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
