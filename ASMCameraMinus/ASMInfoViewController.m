//
//  ASMInfoViewController.m
//  ASMCameraMinus
//
//  Created by Jorge Marcos Fernandez on 06/05/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import "ASMInfoViewController.h"
#import "ASMShowViewController.h"
#import "UIImageView+GeometryConversion.h"

@interface ASMInfoViewController () {
    UIImage* photoImage;
}

@end

@implementation ASMInfoViewController

- (id)initWithPhoto:(ASMPhoto*)photo
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = photo.name;
        self.photo = photo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullFilePath = [NSString stringWithFormat:@"%@/%@.jpg", documentsDirectory, self.photo.name];
    photoImage = self.infoImage.image = [UIImage imageWithContentsOfFile:fullFilePath];
    
//    self.imageLatitude.text = [NSString stringWithFormat:@"%@", self.photo.latitude];
//    self.imageLongitude.text = [NSString stringWithFormat:@"%@", self.photo.longitude];
//    self.reverseGeocoding.text = self.photo.address;
//    self.imageAltitude.text = [NSString stringWithFormat:@"%@", self.photo.altitude];
//    
//    self.imageSize.text = [NSString stringWithFormat:@"Size: %.0f x %.0f", self.infoImage.image.size.width, self.infoImage.image.size.height];
//    
//    NSData* imgData = UIImageJPEGRepresentation(self.infoImage.image, 0);
//    self.imageWeight.text = [NSString stringWithFormat:@"Weight: %.2f MB", (float)imgData.length / 1024.0f / 1024.0f ];
    
    self.infoTV.delegate = self;
    self.infoTV.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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

- (IBAction)detectButton:(id)sender
{
    [self faceDetector];
}

- (IBAction)saveButton:(id)sender {
}

- (IBAction)deleteButton:(id)sender
{
    NSArray* subViewArray = [self.infoImage subviews];
    for( UIView* view in subViewArray )
    {
        [view removeFromSuperview];
    }
}

- (IBAction)cancelButton:(id)sender {
}

#pragma mark - instance methods

-(void)faceDetector
{
    // Load the picture for face detection
    UIImageView *image = [[UIImageView alloc] initWithImage:photoImage];
    
//    // Draw the face detection image
//    [self.infoImage addSubview:image];
    
    // Execute the method used to markFaces in background
    [self performSelectorInBackground:@selector(markFaces:) withObject:image];
    
//    // flip image on y-axis to match coordinate system used by core image
//    [image setTransform:CGAffineTransformMakeScale(1, -1)];
//    
//    // flip the entire window to make everything right side up
//    [self.infoImage setTransform:CGAffineTransformMakeScale(1, -1)];
}

-(void)markFaces:(UIImageView *)facePicture
{
    // draw a CI image with the previously loaded face detection picture
    CIImage *image = [CIImage imageWithCGImage:facePicture.image.CGImage];
    
    // create a face detector - since speed is not an issue we'll use a high accuracy detector
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    

    // For convert CoreImage coordinates to UIKit coordinates
	CGAffineTransform transform = CGAffineTransformMakeScale( 1, -1 );
	transform = CGAffineTransformTranslate( transform, 0, - self.infoImage.bounds.size.height );
    
    
    // create an array containing all the detected faces from the detector
    NSArray *features = [detector featuresInImage:image];
    
    // we'll iterate through every detected face.  CIFaceFeature provides us
    // with the width for the entire face, and the coordinates of each eye
    // and the mouth if detected.  Also provided are BOOL's for the eye's and
    // mouth so we can check if they already exist.
    for (CIFaceFeature *faceFeature in features)
    {
        [self drawFace:faceFeature];
        
//        // get the width of the face
//        CGFloat faceWidth = faceFeature.bounds.size.width;
//        
//
//        const CGRect faceRect = CGRectApplyAffineTransform( [self.infoImage convertRectFromImage:faceFeature.bounds], transform );
//        CGFloat faceRectWidth = faceRect.size.width;
//        
//        // create a UIView using the bounds of the face
//        UIView *faceView = [[UIView alloc] initWithFrame:faceRect];
//        
//        // add a border around the newly created UIView
//        faceView.layer.borderWidth = 1;
//        faceView.layer.borderColor = [[UIColor redColor] CGColor];
//        
//        // add the new view to create a box around the face
//        [self.infoImage addSubview:faceView];
//        
//        if (faceFeature.hasLeftEyePosition)
//        {
//            CGPoint sourceLeftEyePoint = CGPointMake(faceFeature.leftEyePosition.x-faceWidth*0.15, faceFeature.leftEyePosition.y-faceWidth*0.15);
//            CGPoint targetLeftEyePoint = CGPointApplyAffineTransform( [self.infoImage convertPointFromImage:sourceLeftEyePoint], transform );
//            
//            // create a UIView with a size based on the width of the face
//            UIView *leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(targetLeftEyePoint.x, targetLeftEyePoint.y, faceRectWidth*0.3, faceRectWidth*0.3)];
//            // change the background color of the eye view
//            [leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
//            // set the position of the leftEyeView based on the face
////            [leftEyeView setCenter:faceFeature.leftEyePosition];
//            // round the corners
//            leftEyeView.layer.cornerRadius = faceRectWidth*0.15;
//            // add the view to the window
//            [self.infoImage addSubview:leftEyeView];
//        }
//        
//        if(faceFeature.hasRightEyePosition)
//        {
//            UIView *leftEye = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.15, faceFeature.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
//            [leftEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
//            [leftEye setCenter:faceFeature.rightEyePosition];
//            leftEye.layer.cornerRadius = faceWidth*0.15;
//            [self.infoImage addSubview:leftEye];
//        }
//        
//        if(faceFeature.hasMouthPosition)
//        {
//            UIView *mouth = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.mouthPosition.x-faceWidth*0.2, faceFeature.mouthPosition.y-faceWidth*0.2, faceWidth*0.4, faceWidth*0.4)];
//            [mouth setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.3]];
//            [mouth setCenter:faceFeature.mouthPosition];
//            mouth.layer.cornerRadius = faceWidth*0.2;
//            [self.infoImage addSubview:mouth];
//        }
//        
//        // these are just logs of mine
//        NSLog(@"gepeto: %f x alto: %f", faceFeature.bounds.size.width, faceFeature.bounds.size.height);
//        NSLog(@"ojo izquierdo: %f, %f", faceFeature.leftEyePosition.x, faceFeature.leftEyePosition.y);
//        NSLog(@"ojo derecho: %f, %f", faceFeature.rightEyePosition.x, faceFeature.rightEyePosition.y);
//        NSLog(@"boca: %f, %f", faceFeature.mouthPosition.x, faceFeature.mouthPosition.y);
    }
}

- (void)drawFace:(CIFaceFeature*)face
{
	// For convert CoreImage coordinates to UIKit coordinates
	CGAffineTransform transform = CGAffineTransformMakeScale( 1, -1 );
	transform = CGAffineTransformTranslate( transform, 0, - self.infoImage.bounds.size.height );
    
    // Draw Face Rect
    const CGRect faceRect = CGRectApplyAffineTransform( [self.infoImage convertRectFromImage:face.bounds], transform );
    UIView* faceView = [[UIView alloc] initWithFrame:faceRect];
    faceView.layer.borderWidth = 1.5f;
    faceView.layer.borderColor = [[UIColor greenColor] CGColor];
    [self.infoImage addSubview:faceView];
    CGFloat faceWidth = faceRect.size.width;
    
    //Draw Left Eye
    if( face.hasLeftEyePosition )
    {
        const CGPoint leftEyePos = CGPointApplyAffineTransform( [self.infoImage convertPointFromImage:face.leftEyePosition], transform );
        UIView* leftEyeView = [[UIView alloc] initWithFrame:CGRectMake( leftEyePos.x - faceWidth * 0.3f * 0.5f, leftEyePos.y - faceWidth * 0.3f * 0.5f,
                                                                        faceWidth * 0.3f, faceWidth * 0.3f )];
        leftEyeView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2f];
        leftEyeView.layer.cornerRadius = faceWidth * 0.3f * 0.5f;
        [self.infoImage addSubview:leftEyeView];
    }
    
    //Draw Right Eye
    if( face.hasRightEyePosition )
    {
        const CGPoint rightEyePos = CGPointApplyAffineTransform( [self.infoImage convertPointFromImage:face.rightEyePosition], transform );
        UIView* rightEyeView = [[UIView alloc] initWithFrame:CGRectMake( rightEyePos.x - faceWidth * 0.3f * 0.5f, rightEyePos.y - faceWidth * 0.3f * 0.5f,
                                                                         faceWidth * 0.3f, faceWidth * 0.3f )];
        rightEyeView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        rightEyeView.layer.cornerRadius = faceWidth * 0.3f * 0.5;
        [self.infoImage addSubview:rightEyeView];
    }
    
    //Draw Mouth
    if( face.hasMouthPosition )
    {
        const CGPoint mouthPos = CGPointApplyAffineTransform( [self.infoImage convertPointFromImage:face.mouthPosition], transform );
        UIView* mouthView = [[UIView alloc] initWithFrame:CGRectMake( mouthPos.x - faceWidth * 0.4f * 0.5f, mouthPos.y - faceWidth * 0.4f * 0.5f,
                                                                      faceWidth * 0.4f, faceWidth * 0.4f)];
        mouthView.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.3f];
        mouthView.layer.cornerRadius = faceWidth * 0.4f * 0.5f;
        [self.infoImage addSubview:mouthView];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return @"Metadata";
    else if (section == 1) return @"Geocoding";
    else if (section == 2) return @"Faces";
    else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 3;
    else if (section == 1) return 3;
    else if (section == 2) return 4;
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Sección %ld, fila %ld", (long)indexPath.section + 1, (long)indexPath.row + 1];
    
    if( indexPath.section == 0 )
    {
        if( indexPath.row == 0)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"Width: %@px", self.photo.width];
        }
        if( indexPath.row == 1)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"Height: %@px", self.photo.height];
        }
        if( indexPath.row == 2)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"Weight: %@", self.photo.weight];
        }
    }
    
    return cell;
}

@end
