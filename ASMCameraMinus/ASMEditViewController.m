//
//  ASMEditViewController.m
//  ASMCameraMinus
//
//  Created by Alejandro Soret Madolell on 08/05/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import "ASMEditViewController.h"

@interface ASMEditViewController ()

@end

@implementation ASMEditViewController

- (id)initWithPhoto:(UIImage*)photo
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = @"Edit Image";
        self.photo = photo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myOriginalImage.image = self.photo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
