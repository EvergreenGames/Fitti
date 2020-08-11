//
//  HomeViewController.m
//  Fitti
//
//  Created by Ruben Green on 7/15/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailsViewController.h"
#import "SortingManager.h"
#import "SceneDelegate.h"
#import "ErrorMessageView.h"
#import "TextPostCell.h"
#import <Parse/Parse.h>
#import "Post.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<Post*>* posts;
@property (nonatomic, strong) CLPlacemark* viewPlacemark;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
        
    UIRefreshControl* refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    
    if(self.viewLocation){
        CLGeocoder* geocoder = [CLGeocoder new];
        [geocoder reverseGeocodeLocation:self.viewLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if(error){
                NSLog(@"Error finding placemark: %@", error.localizedDescription);
            }
            else{
                self.viewPlacemark = placemarks.firstObject;
                if(self.viewPlacemark.areasOfInterest.count > 0){
                    self.navigationItem.title = self.viewPlacemark.areasOfInterest.firstObject;
                }
                else{
                    self.navigationItem.title = self.viewPlacemark.name;
                }
            }
        }];
        [self loadPostsWithCompletion:nil];
    }
    else {
        [LocationManager startUpdatingLocation];
        [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            self.navigationItem.title = [LocationManager sharedManager].currentPlacemark.name;
            self.viewLocation = [LocationManager sharedManager].currentLocation;
            if(self.viewLocation){
                //[timer invalidate];
                [self loadPostsWithCompletion:nil];
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
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
    //[query whereKey:@"location" nearGeoPoint:[PFGeoPoint geoPointWithLocation:self.viewLocation]];
    [query whereKey:@"location" nearGeoPoint:[PFGeoPoint geoPointWithLocation:self.viewLocation] withinMiles:5.0];
    [query includeKey:@"author"];
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error fetching posts: %@", error.localizedDescription);
        }
        else{
            self.posts = objects;
            
            NSMutableArray<NSString*>* objectIds = [NSMutableArray new];
            for (Post* p in self.posts) {
                [objectIds addObject:p.objectId];
            }
            
            PFQuery* likeQuery = [[[PFUser currentUser] relationForKey:@"likes"] query];
            [likeQuery whereKey:@"objectId" containedIn:objectIds];
            [likeQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if(error){
                    NSLog(@"Error fetching likes: %@", error.localizedDescription);
                }
                else{
                    for(Post* p in self.posts){
                        for(Post* lp in objects){
                            if([p.objectId isEqualToString:lp.objectId]){
                                p.userLiked = true;
                                break;
                            }
                        }
                    }
                    
                    self.posts = [SortingManager sortPostsHot:self.posts withLocation:self.viewLocation];
                    
                    [self.tableView reloadData];
                    if(completion) completion();
                }
            }];
            
        }
    }];
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

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* post = [tableView cellForRowAtIndexPath:indexPath];
    [tableView endUpdates];
    //[UIView animateWithDuration:2.0 animations:^{
        post.frame = CGRectMake(post.frame.origin.x, post.frame.origin.y-15, post.frame.size.width, post.frame.size.height+30);
    //}];
}*/


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
