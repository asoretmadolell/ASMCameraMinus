//
//  ASMShowViewController.m
//  ASMCameraMinus
//
//  Created by Jorge Marcos Fernandez on 30/04/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import "ASMShowViewController.h"

@interface ASMShowViewController ()

@end

@implementation ASMShowViewController

- (id)initWithPhoto:(UIImage*)photo
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = @"Show Image";
        self.photo = photo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.photoView.image = self.photo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
