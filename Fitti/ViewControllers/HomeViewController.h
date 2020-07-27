//
//  HomeViewController.h
//  Fitti
//
//  Created by Ruben Green on 7/15/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CLLocation* viewLocation;

@end

NS_ASSUME_NONNULL_END
