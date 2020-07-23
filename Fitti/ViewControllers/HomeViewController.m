//
//  HomeViewController.m
//  Fitti
//
//  Created by Ruben Green on 7/15/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailsViewController.h"
#import "SceneDelegate.h"
#import "ErrorMessageView.h"
#import "LocationManager.h"
#import "TextPostCell.h"
#import <Parse/Parse.h>
#import "Post.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<Post*>* posts;
@property (nonatomic, strong) CLLocation* viewLocation;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIRefreshControl* refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    [LocationManager startUpdatingLocation]; // move somewhere else for generic view
    [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self.navigationItem.title = [LocationManager sharedManager].currentPlacemark.name;
        self.viewLocation = [LocationManager sharedManager].currentLocation;
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
    }
}

- (IBAction)logoutAction:(id)sender {
    [self logoutUser];
}

- (void)refreshAction:(UIRefreshControl*)refreshControl{
    [self loadPostsWithCompletion:^{
        [refreshControl endRefreshing];
    }];
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

- (void)loadPostsWithCompletion:(void (^)(void))completion{
    PFQuery* query = [Post query];
    [query whereKey:@"location" nearGeoPoint:[PFGeoPoint geoPointWithLocation:self.viewLocation]];
    //[query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error fetching posts: %@", error.localizedDescription);
        }
        else{
            self.posts = objects;
            [self.tableView reloadData];
        }
    }];
    if(completion) completion();
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post* post = self.posts[indexPath.row];
    
    if([post.postType isEqualToString:@"text"]){
        TextPostCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TextPostCell"];
        cell.post = post;
        return cell;
    }
    else if([post.postType isEqualToString:@"image"]){
        TextPostCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ImagePostCell"];
        cell.post = post;
        return cell;
    }
    return nil;
};


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"DetailSegue"]){
        UITableViewCell* sourceCell = sender;
        NSIndexPath* sourceIndex = [self.tableView indexPathForCell:sourceCell];
        
        DetailsViewController* detailsController = [segue destinationViewController];
        detailsController.post = self.posts[sourceIndex.row];
    }
}


@end
