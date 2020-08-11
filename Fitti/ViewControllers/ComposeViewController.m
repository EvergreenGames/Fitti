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

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *contentField;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)cancelAction:(id)sender {
    self.titleField.text = @"";
    self.contentField.text = @"";
    self.contentImageView.image = nil;
    [self.view endEditing:YES];
    [self.navigationController.tabBarController setSelectedIndex:0];
}

- (IBAction)postAction:(id)sender {
    [self createPostWithCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(error) {
            NSLog(@"Error creating post: %@", error.localizedDescription);
        }
        else {
            self.titleField.text = @"";
            self.contentField.text = @"";
            self.contentImageView.image = nil;
            [self.view endEditing:YES];
            [self.navigationController.tabBarController setSelectedIndex:0];
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
    if(self.contentImageView.image != nil){
        post.image = [Post getPFFileFromImage:self.contentImageView.image];
        post.aspectRatio = self.contentImageView.image.size.width/self.contentImageView.image.size.height;
        post.postType = @"image";
    }
    
    [post saveInBackgroundWithBlock:completion];
}

- (void)showPicker:(UIImagePickerControllerSourceType) type {
    UIImagePickerController* imagePickerController = [UIImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = type;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage* editedImage = info[UIImagePickerControllerEditedImage];
    UIImage* resizedImage = [self resizeImage:editedImage withSize:CGSizeMake(512, 512)];
    
    [self.contentImageView setImage:resizedImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)chooseImageAction:(id)sender {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* camAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPicker:UIImagePickerControllerSourceTypeCamera];
    }];
    [alertController addAction:camAction];
    
    UIAlertAction* libraryAction = [UIAlertAction actionWithTitle:@"Choose Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alertController addAction:libraryAction];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
