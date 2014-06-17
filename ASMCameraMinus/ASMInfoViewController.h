//
//  ASMInfoViewController.h
//  ASMCameraMinus
//
//  Created by SoReT on 06/05/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreImage;
@import QuartzCore;
#import "ASMPhoto.h"

@class ViewController;

@interface ASMInfoViewController : UIViewController

@property (strong, nonatomic) ASMPhoto *photo;
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet UILabel *imageSize;
@property (weak, nonatomic) IBOutlet UILabel *imageWeight;
@property (weak, nonatomic) IBOutlet UILabel *imageLongitude;
@property (weak, nonatomic) IBOutlet UILabel *imageLatitude;
@property (weak, nonatomic) IBOutlet UILabel *imageHeight;
@property (weak, nonatomic) IBOutlet UILabel *imageMouth;
@property (weak, nonatomic) IBOutlet UILabel *imageLeftEye;
@property (weak, nonatomic) IBOutlet UILabel *imageRightEye;
@property (weak, nonatomic) IBOutlet UILabel *imageAltitude;
@property (weak, nonatomic) IBOutlet UILabel *reverseGeocoding;

- (id)initWithPhoto:(ASMPhoto*)photo;
- (IBAction)detectButton:(id)sender;
- (IBAction)saveButton:(id)sender;
- (IBAction)deleteButton:(id)sender;
- (IBAction)cancelButton:(id)sender;

@end
