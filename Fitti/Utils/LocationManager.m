//
//  LocationManager.m
//  Fitti
//
//  Created by Ruben Green on 7/16/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager

+ (LocationManager*)sharedManager {
    static LocationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

+ (void)startUpdatingLocation {
    [self.sharedManager.locManager startUpdatingLocation];
}

+ (void)stopUpdatingLocation {
    [self.sharedManager.locManager stopUpdatingLocation];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locManager = [CLLocationManager new];
        self.locManager.activityType = CLActivityTypeOther;
        self.locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locManager.distanceFilter = 10;
        self.locManager.allowsBackgroundLocationUpdates = NO;
        self.locManager.pausesLocationUpdatesAutomatically = YES;
        self.locManager.delegate = self;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"Getting location: %lu", locations.count);
    if(locations.count == 0) return;
    
    CLLocation* newLocation = locations.lastObject;
    
    if(!self.currentLocation){
        self.currentLocation = newLocation;
        [self getPlacemarkFromCoords:newLocation];
        return;
    }

    
    //throw out any update older than 15 seconds
    NSTimeInterval timeSinceLastUpdate = [newLocation.timestamp timeIntervalSinceNow];
    if(fabs(timeSinceLastUpdate) > 15.0) return;
    
    if([self.currentLocation distanceFromLocation:newLocation] > 20){
        [self getPlacemarkFromCoords:newLocation];
    }
    self.currentLocation = newLocation;
}

- (void) getPlacemarkFromCoords:(CLLocation*) location {
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error finding placemark: %@", error.localizedDescription);
        }
        else{
            self.currentPlacemark = placemarks.firstObject;
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location Error: %@", error.localizedDescription);
}

//TODO: handle location service error

@end
