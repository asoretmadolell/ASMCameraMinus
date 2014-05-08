//
//  ASMInfoViewController.m
//  ASMCameraMinus
//
//  Created by Jorge Marcos Fernandez on 06/05/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import "ASMInfoViewController.h"
#import "ASMShowViewController.h"

@interface ASMInfoViewController ()

@end

@implementation ASMInfoViewController

- (id)initWithPhoto:(UIImage*)photo
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = @"Image Info";
        self.photo = photo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.infoImage.image = self.photo;
    self.imageSize.text = [NSString stringWithFormat:@"Size: %.0f x %.0f", self.infoImage.image.size.width, self.infoImage.image.size.height];
    
    NSData* imgData = UIImageJPEGRepresentation(self.infoImage.image, 0);
    self.imageWeight.text = [NSString stringWithFormat:@"Weight: %.2f", (float)imgData.length / 1024.0f / 1024.0f ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    
    if( touch.view == self.infoImage )
    {
        ASMShowViewController *showVC = [[ASMShowViewController alloc] initWithPhoto:self.infoImage.image];
        [self.navigationController pushViewController:showVC animated:YES];
    }

}
@end
