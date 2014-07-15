//
//  ASMEditViewController.h
//  ASMCameraMinus
//
//  Created by Alejandro Soret Madolell on 08/05/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASMPhoto.h"
#import "ASMFilter.h"

@interface ASMEditViewController : UIViewController

@property (strong, nonatomic) ASMPhoto *photo;
@property (weak, nonatomic) IBOutlet UIImageView *myOriginalImage;
@property (weak, nonatomic) IBOutlet UIImageView *myFilteredImage;

- (id)initWithPhoto:(ASMPhoto *)photo;

@property (nonatomic, strong) NSFetchedResultsController* filtersResultsController;

@end