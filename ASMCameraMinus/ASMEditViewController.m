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

- (IBAction)filter1Butonn:(id)sender
{
    [self applyFilter:[CIFilter filterWithName:@"CISepiaTone"]];
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

#pragma mark - instance methods

-(void)applyFilter:(CIFilter*)filter
{
    __block UIImage* filteredImage = nil;
    
    dispatch_queue_t filterQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(filterQueue, ^{
        CIContext* context = [CIContext contextWithOptions:nil];
        
        CIImage* originalImage = [CIImage imageWithCGImage:self.myOriginalImage.image.CGImage];
        [filter setDefaults];
        [filter setValue:originalImage forKey:kCIInputImageKey];
        CIImage* filteredCGIImage = [filter valueForKey:kCIOutputImageKey];
        
        CGImageRef cgImage = [context createCGImage:filteredCGIImage fromRect:[filteredCGIImage extent]];
        filteredImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            self.myFilteredImage.image = filteredImage;
        });
    });
}

@end
