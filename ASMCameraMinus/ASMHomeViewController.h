//
//  ASMHomeViewController.h
//  ASMCameraMinus
//
//  Created by SoReT on 10/04/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASMHomeViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *photosCV;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *listButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shootButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *socialButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;

- (IBAction)list:(id)sender;
- (IBAction)edit:(id)sender;
- (IBAction)shoot:(id)sender;
- (IBAction)social:(id)sender;
- (IBAction)delete:(id)sender;

- (void)infoClicked:(id)sender;

@end
