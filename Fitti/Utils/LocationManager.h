//
//  LocationManager.h
//  Fitti
//
//  Created by Ruben Green on 7/16/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locManager;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, strong) CLPlacemark* currentPlacemark;

+ (LocationManager*)sharedManager;

+ (void)startUpdatingLocation;
+ (void)stopUpdatingLocation;

@end

NS_ASSUME_NONNULL_END
