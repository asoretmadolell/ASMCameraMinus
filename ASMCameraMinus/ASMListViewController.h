//
//  ASMListViewController.h
//  ASMCameraMinus
//
//  Created by SoReT on 29/04/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASMListViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *model;
@property (weak, nonatomic) IBOutlet UITableView *photoTV;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *gridButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shootButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *socialButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;

- (IBAction)grid:(id)sender;
- (IBAction)edit:(id)sender;
- (IBAction)shoot:(id)sender;
- (IBAction)social:(id)sender;
- (IBAction)delete:(id)sender;

- (id)initWithModel:(NSMutableArray*)model;

@end
