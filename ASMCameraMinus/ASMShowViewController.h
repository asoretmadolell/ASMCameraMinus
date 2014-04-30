//
//  ASMShowViewController.h
//  ASMCameraMinus
//
//  Created by SoReT on 30/04/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASMShowViewController : UIViewController

@property (strong, nonatomic) UIImage *photo;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

- (id)initWithPhoto:(UIImage*)photo;

@end
