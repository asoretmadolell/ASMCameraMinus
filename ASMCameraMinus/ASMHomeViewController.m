//
//  ASMHomeViewController.m
//  ASMCameraMinus
//
//  Created by SoReT on 10/04/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import "ASMHomeViewController.h"

@interface ASMHomeViewController ()

@end

@implementation ASMHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Camera Minus";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)list:(id)sender {
}

- (IBAction)edit:(id)sender {
}

- (IBAction)shoot:(id)sender
{
    UIImagePickerController *pc_shoot = [[UIImagePickerController alloc] init];
    pc_shoot.delegate = self;
    pc_shoot.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pc_shoot animated:YES completion:nil];
    
//    // this checks if the device has a camera
//    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
//    // this checks if the device has front and rear camera
//    BOOL hasFrontCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
//    BOOL hasRearCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
//    // this specifies which camera to use
//    pc_shoot.cameraDevice = UIImagePickerControllerCameraDeviceFront;
}

- (IBAction)social:(id)sender {
}

- (IBAction)delete:(id)sender
{
    UIAlertView *av_delete = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                        message:@"You have pressed the delete button"
                                                       delegate:self
                                              cancelButtonTitle:@"Oh yeah"
                                              otherButtonTitles:nil, nil];
    [av_delete show];
}

#pragma mark - delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = (UIImage*) [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imageView.image = image;
}

@end
