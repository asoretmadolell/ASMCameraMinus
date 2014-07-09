//
//  ASMEditViewController.h
//  ASMCameraMinus
//
//  Created by Alejandro Soret Madolell on 08/05/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASMEditViewController : UIViewController

@property (strong, nonatomic) UIImage *photo;
@property (weak, nonatomic) IBOutlet UIImageView *myOriginalImage;
@property (weak, nonatomic) IBOutlet UIImageView *myFilteredImage;

- (id)initWithPhoto:(UIImage *)photo;

- (IBAction)filter1button:(id)sender;
- (IBAction)filter2button:(id)sender;
- (IBAction)filter3button:(id)sender;
- (IBAction)filter4button:(id)sender;
- (IBAction)filter5button:(id)sender;

@end