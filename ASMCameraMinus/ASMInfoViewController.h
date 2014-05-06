//
//  ASMInfoViewController.h
//  ASMCameraMinus
//
//  Created by SoReT on 06/05/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASMInfoViewController : UIViewController

@property (strong, nonatomic) UIImage *photo;
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;

- (id)initWithPhoto:(UIImage*)photo;

@end
