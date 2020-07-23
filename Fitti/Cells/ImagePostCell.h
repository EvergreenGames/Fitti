//
//  ImagePostCell.h
//  Fitti
//
//  Created by Ruben Green on 7/21/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImagePostCell : UITableViewCell

@property (nonatomic, strong) Post* post;

@end

NS_ASSUME_NONNULL_END
