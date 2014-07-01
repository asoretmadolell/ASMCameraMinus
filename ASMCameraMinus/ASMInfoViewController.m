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
        
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[ASMFace entityName]];
        request.predicate = [NSPredicate predicateWithFormat:@"photo == %@", self.photo];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:ASMFaceAttributes.faceRect ascending:YES]];
        self.facesResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                         managedObjectContext:photo.managedObjectContext
                                                                           sectionNameKeyPath:nil
                                                                                    cacheName:nil];
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
    
    self.infoTV.delegate = self;
    self.infoTV.dataSource = self;
    
    [self.facesResultsController performFetch:nil];
    
    for (ASMFace* face in [self.facesResultsController fetchedObjects])
    {
        CGRect faceRect = CGRectFromString(face.faceRect);
        CGPoint leftEyePoint = CGPointFromString(face.leftEye);
        CGPoint rightEyePoint = CGPointFromString(face.rightEye);
        CGPoint mouthPoint = CGPointFromString(face.mouth);
        [self drawFace:faceRect andLeftEye:leftEyePoint andRightEye:rightEyePoint andMouth:mouthPoint];
    }
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
    
    // Execute the method used to markFaces in background
    [self performSelectorInBackground:@selector(markFaces:) withObject:image];
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
        ASMFace* face = [ASMFace faceWithPhoto:self.photo inContext:self.photo.managedObjectContext];
        face.faceRect = NSStringFromCGRect(faceFeature.bounds);
        if (faceFeature.hasLeftEyePosition) face.leftEye = NSStringFromCGPoint(faceFeature.leftEyePosition);
        if (faceFeature.hasRightEyePosition) face.rightEye = NSStringFromCGPoint(faceFeature.rightEyePosition);
        if (faceFeature.hasMouthPosition) face.mouth = NSStringFromCGPoint(faceFeature.mouthPosition);
        [self drawFace:faceFeature.bounds andLeftEye:faceFeature.leftEyePosition andRightEye:faceFeature.rightEyePosition andMouth:faceFeature.mouthPosition];
    }
    
    [self.photo.managedObjectContext save:nil];
}

- (void)drawFace:(CGRect)bounds andLeftEye:(CGPoint)leftEye andRightEye:(CGPoint)rightEye andMouth:(CGPoint)mouth
{
	// For convert CoreImage coordinates to UIKit coordinates
	CGAffineTransform transform = CGAffineTransformMakeScale( 1, -1 );
	transform = CGAffineTransformTranslate( transform, 0, - self.infoImage.bounds.size.height );
    
    // Draw Face Rect
    const CGRect faceRect = CGRectApplyAffineTransform( [self.infoImage convertRectFromImage:bounds], transform );
    UIView* faceView = [[UIView alloc] initWithFrame:faceRect];
    faceView.layer.borderWidth = 1.5f;
    faceView.layer.borderColor = [[UIColor greenColor] CGColor];
    [self.infoImage addSubview:faceView];
    CGFloat faceWidth = faceRect.size.width;
    
    NSLog(@"%@", NSStringFromCGRect(faceRect));
    
    //Draw Left Eye
    if( leftEye.x && leftEye.y )
    {
        const CGPoint leftEyePos = CGPointApplyAffineTransform( [self.infoImage convertPointFromImage:leftEye], transform );
        UIView* leftEyeView = [[UIView alloc] initWithFrame:CGRectMake( leftEyePos.x - faceWidth * 0.3f * 0.5f, leftEyePos.y - faceWidth * 0.3f * 0.5f,
                                                                        faceWidth * 0.3f, faceWidth * 0.3f )];
        leftEyeView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2f];
        leftEyeView.layer.cornerRadius = faceWidth * 0.3f * 0.5f;
        [self.infoImage addSubview:leftEyeView];
    }
    
    //Draw Right Eye
    if( rightEye.x && rightEye.y )
    {
        const CGPoint rightEyePos = CGPointApplyAffineTransform( [self.infoImage convertPointFromImage:rightEye], transform );
        UIView* rightEyeView = [[UIView alloc] initWithFrame:CGRectMake( rightEyePos.x - faceWidth * 0.3f * 0.5f, rightEyePos.y - faceWidth * 0.3f * 0.5f,
                                                                         faceWidth * 0.3f, faceWidth * 0.3f )];
        rightEyeView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        rightEyeView.layer.cornerRadius = faceWidth * 0.3f * 0.5;
        [self.infoImage addSubview:rightEyeView];
    }
    
    //Draw Mouth
    if( mouth.x && mouth.y )
    {
        const CGPoint mouthPos = CGPointApplyAffineTransform( [self.infoImage convertPointFromImage:mouth], transform );
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
    return (self.facesResultsController.fetchedObjects.count) ? 3 : 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Metadata";
            break;
        case 1:
            return @"Geocoding";
            break;
        case 2:
            return @"Faces";
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 3;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return [self.facesResultsController fetchedObjects].count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Sección %ld, fila %ld", (long)indexPath.section + 1, (long)indexPath.row + 1];
    
    switch (indexPath.section)
    {
        case 0:
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"Width: %@px", self.photo.width];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"Height: %@px", self.photo.height];
                    break;
                case 2:
                    cell.textLabel.text = [NSString stringWithFormat:@"Weight: %.2f MB", [self.photo.weight floatValue]];
                    break;
                default:
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"Latitude: %@", self.photo.latitude];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"Longitude: %@", self.photo.longitude];
                    break;
                case 2:
                    cell.textLabel.text = [NSString stringWithFormat:@"Altitude: %@", self.photo.altitude];
                    break;
                case 3:
                    cell.textLabel.text = [NSString stringWithFormat:@"Dirección: %@", self.photo.address];
                default:
                    break;
            }
            break;
            
        case 2:
        {
            ASMFace* face = [[self.facesResultsController fetchedObjects] objectAtIndex:indexPath.row];
            cell.textLabel.text = face.faceRect;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

@end
