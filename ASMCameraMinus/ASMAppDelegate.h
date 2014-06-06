//
//  ASMAppDelegate.h
//  ASMCameraMinus
//
//  Created by SoReT on 10/04/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGTCoreDataStack.h"
@import CoreLocation;
@import AddressBook;

@interface ASMAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AGTCoreDataStack *model;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *reverseGeocoding;
@property (strong, nonatomic) CLLocation *lastLocation;

@end
