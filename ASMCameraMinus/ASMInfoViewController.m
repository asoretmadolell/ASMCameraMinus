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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }
    
    [self faceDetector];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.locationManager stopUpdatingLocation];
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

#pragma mark - location manager methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *lastLocation = [locations lastObject];
    self.imageLatitude.text = [NSString stringWithFormat:@"Latitude: %.4f", lastLocation.coordinate.latitude];
    self.imageLongitude.text = [NSString stringWithFormat:@"Longitude: %.4f", lastLocation.coordinate.longitude];
    self.imageHeight.text = [NSString stringWithFormat:@"Altitude: %.4f", lastLocation.altitude];
}

#pragma mark - instance methods

-(void)faceDetector
{
    // Load the picture for face detection
    UIImageView *image = [[UIImageView alloc] initWithImage:self.photo];
    
    // Draw the face detection image
    [self.infoImage addSubview:image];
    
    // Execute the method used to markFaces in background
    [self performSelectorInBackground:@selector(markFaces:) withObject:image];
    
    // flip image on y-axis to match coordinate system used by core image
    [image setTransform:CGAffineTransformMakeScale(1, -1)];
    
    // flip the entire window to make everything right side up
    [self.infoImage setTransform:CGAffineTransformMakeScale(1, -1)];
}

-(void)markFaces:(UIImageView *)facePicture
{
    // draw a CI image with the previously loaded face detection picture
    CIImage *image = [CIImage imageWithCGImage:facePicture.image.CGImage];
    
    // create a face detector - since speed is not an issue we'll use a high accuracy detector
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    // create an array containing all the detected faces from the detector
    NSArray *features = [detector featuresInImage:image];
    
    // we'll iterate through every detected face.  CIFaceFeature provides us
    // with the width for the entire face, and the coordinates of each eye
    // and the mouth if detected.  Also provided are BOOL's for the eye's and
    // mouth so we can check if they already exist.
    for (CIFaceFeature *faceFeature in features)
    {
        // get the width of the face
        CGFloat faceWidth = faceFeature.bounds.size.width;
        
        // create a UIView using the bounds of the face
        UIView *faceView = [[UIView alloc] initWithFrame:faceFeature.bounds];
        
        // add a border around the newly created UIView
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        
        // add the new view to create a box around the face
        [self.infoImage addSubview:faceView];
        
        if (faceFeature.hasLeftEyePosition)
        {
            // create a UIView with a size based on the width of the face
            UIView *leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.15, faceFeature.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            // change the background color of the eye view
            [leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            // set the position of the leftEyeView based on the face
            [leftEyeView setCenter:faceFeature.leftEyePosition];
            // round the corners
            leftEyeView.layer.cornerRadius = faceWidth*0.15;
            // add the view to the window
            [self.infoImage addSubview:leftEyeView];
        }
        
        if(faceFeature.hasRightEyePosition)
        {
            UIView *leftEye = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.15, faceFeature.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            [leftEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            [leftEye setCenter:faceFeature.rightEyePosition];
            leftEye.layer.cornerRadius = faceWidth*0.15;
            [self.infoImage addSubview:leftEye];
        }
        
        if(faceFeature.hasMouthPosition)
        {
            UIView *mouth = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.mouthPosition.x-faceWidth*0.2, faceFeature.mouthPosition.y-faceWidth*0.2, faceWidth*0.4, faceWidth*0.4)];
            [mouth setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.3]];
            [mouth setCenter:faceFeature.mouthPosition];
            mouth.layer.cornerRadius = faceWidth*0.2;
            [self.infoImage addSubview:mouth];
        }
        
        // these are just logs of mine
        NSLog(@"gepeto: %f x alto: %f", faceFeature.bounds.size.width, faceFeature.bounds.size.height);
        NSLog(@"ojo izquierdo: %f, %f", faceFeature.leftEyePosition.x, faceFeature.leftEyePosition.y);
        NSLog(@"ojo derecho: %f, %f", faceFeature.rightEyePosition.x, faceFeature.rightEyePosition.y);
        NSLog(@"boca: %f, %f", faceFeature.mouthPosition.x, faceFeature.mouthPosition.y);
    }
}

@end
