//
//  DetailsViewController.h
//  Fitti
//
//  Created by Ruben Green on 7/20/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) Post* post;

@end

NS_ASSUME_NONNULL_END
