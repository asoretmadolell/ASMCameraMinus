//
//  ASMInfoViewController.h
//  ASMCameraMinus
//
//  Created by SoReT on 06/05/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@import CoreImage;
@import QuartzCore;

@class ViewController;

@interface ASMInfoViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) UIImage *photo;
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet UILabel *imageSize;
@property (weak, nonatomic) IBOutlet UILabel *imageWeight;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *imageLongitude;
@property (weak, nonatomic) IBOutlet UILabel *imageLatitude;
@property (weak, nonatomic) IBOutlet UILabel *imageHeight;
@property (weak, nonatomic) IBOutlet UILabel *imageMouth;
@property (weak, nonatomic) IBOutlet UILabel *imageLeftEye;
@property (weak, nonatomic) IBOutlet UILabel *imageRightEye;

- (id)initWithPhoto:(UIImage*)photo;

@end
