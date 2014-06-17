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

@interface ASMInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ASMPhoto *photo;
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet UITableView *infoTV;

- (id)initWithPhoto:(ASMPhoto*)photo;
- (IBAction)detectButton:(id)sender;
- (IBAction)saveButton:(id)sender;
- (IBAction)deleteButton:(id)sender;
- (IBAction)cancelButton:(id)sender;

@end
