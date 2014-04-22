//
//  ASMHomeViewController.m
//  ASMCameraMinus
//
//  Created by SoReT on 10/04/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import "ASMHomeViewController.h"
#import "ASMPhotoCell.h"

@interface ASMHomeViewController ()

@property (strong, nonatomic) NSMutableArray *myPhotosArray;

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
    
    self.photosCV.delegate = self;
    self.photosCV.dataSource = self;
    
    self.myPhotosArray = [[NSMutableArray alloc]init];
    [self.myPhotosArray addObject:[UIImage imageNamed:@"c3po.jpg"]];
    [self.myPhotosArray addObject:[UIImage imageNamed:@"candemor.jpg"]];
    [self.myPhotosArray addObject:[UIImage imageNamed:@"chewbacca.jpg"]];
    [self.myPhotosArray addObject:[UIImage imageNamed:@"darthVader.jpg"]];
    
    [self.photosCV registerNib:[UINib nibWithNibName:@"ASMPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCell"];
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
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        UIImagePickerController *pc_shoot = [[UIImagePickerController alloc] init];
        pc_shoot.delegate = self;
        pc_shoot.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pc_shoot animated:YES completion:nil];
    }
    
    // okay, we really don't need any of this code right here...
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
    if (self.imageView.image != nil) {
        self.imageView.image = nil;
    }
    else {
        UIAlertView *av_delete = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                            message:@"Dude, there is no image to delete!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Oh, yeah!"
                                                  otherButtonTitles:nil, nil];
        [av_delete show];
    }
}

#pragma mark - picker view delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = (UIImage*) [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imageView.image = image;
    [self.myPhotosArray addObject:image];
    [self.photosCV reloadData];
}

#pragma mark - collection view flow layout delegate methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(61, 62);
}

#pragma mark - collection view data source delegate methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.myPhotosArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ASMPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    cell.image.image = [self.myPhotosArray objectAtIndex:indexPath.item];
    
//    if( cell.selected )
//    {
//        cell.backgroundColor = [UIColor orangeColor];
//    }
//    else
//    {
//        cell.backgroundColor = [UIColor blackColor];
//    }
    cell.backgroundColor = ( cell.selected ) ? [UIColor orangeColor] : [UIColor blackColor];
    
    return cell;
}

#pragma mark - collection view delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    long sectionID = indexPath.section;
    long itemID = indexPath.item;
    
    UIImage *selectedImage = [self.myPhotosArray objectAtIndex:indexPath.item];
    self.imageView.image = selectedImage;
    
    UICollectionViewCell* cell = [self.photosCV cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.photosCV cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
}

@end
