//
//  ASMHomeViewController.h
//  ASMCameraMinus
//
//  Created by SoReT on 10/04/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASMHomeViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *photosCV;

- (IBAction)list:(id)sender;
- (IBAction)edit:(id)sender;
- (IBAction)shoot:(id)sender;
- (IBAction)social:(id)sender;
- (IBAction)delete:(id)sender;

@end
