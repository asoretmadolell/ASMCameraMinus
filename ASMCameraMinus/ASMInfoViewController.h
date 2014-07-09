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
#import "ASMFace.h"

@class ViewController;

@interface ASMInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ASMPhoto *photo;
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;
@property (weak, nonatomic) IBOutlet UITableView *infoTV;
@property (nonatomic, strong) NSFetchedResultsController* facesResultsController;

- (IBAction)detectButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *detectButton;
- (IBAction)saveButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
- (IBAction)deleteButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
- (IBAction)cancelButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

- (id)initWithPhoto:(ASMPhoto*)photo;

@end
