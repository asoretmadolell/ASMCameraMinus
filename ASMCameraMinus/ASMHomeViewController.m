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
    
    // Thanks to our friends at U-Tad, we're unable to use their iPad devices at home... So we'll just init the array with some images.
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
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
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
    NSArray *selectedItems = [self.photosCV indexPathsForSelectedItems];
    
    if (selectedItems.count == 0) {
        UIAlertView *av_delete = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                            message:@"Dude, there's no image selected!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Oh, yeah!"
                                                  otherButtonTitles:nil, nil];
        [av_delete show];
    }
    else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to delete the image?"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Yup"
                                                   destructiveButtonTitle:@"Nope"
                                                        otherButtonTitles: nil];
        [actionSheet showFromBarButtonItem:sender animated:YES];
    }
}

#pragma mark - picker view delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = (UIImage*) [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.myPhotosArray addObject:image];
    [self.photosCV reloadData];
}

#pragma mark - collection view flow layout delegate methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}

#pragma mark - collection view data source delegate methods

// // This code isn't necessary if we're using only 1 section
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.myPhotosArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ASMPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    cell.image.image = [self.myPhotosArray objectAtIndex:indexPath.item];
    
    if( cell.selected )
    {
        cell.backgroundColor = [UIColor blueColor];
    }
    else
    {
        cell.backgroundColor = [UIColor blackColor];
    }
//    // By the way, this is another way of doing the same thing:
//    cell.backgroundColor = ( cell.selected ) ? [UIColor blueColor] : [UIColor blackColor];
    
    return cell;
}

#pragma mark - collection view delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    // These indicate which section and item has been selected
//    long sectionID = indexPath.section;
//    long itemID = indexPath.item;
    
    UICollectionViewCell* cell = [self.photosCV cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.photosCV cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
}

#pragma mark - action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        NSArray *selectedItems = [self.photosCV indexPathsForSelectedItems];
        
        for (NSIndexPath *indexPath in selectedItems)
        {
            [self.myPhotosArray removeObjectAtIndex:indexPath.item];
        }
        
        [self.photosCV reloadData];
        
    }
}

@end
