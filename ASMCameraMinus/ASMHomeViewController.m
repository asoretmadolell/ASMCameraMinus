//
//  ASMHomeViewController.m
//  ASMCameraMinus
//
//  Created by SoReT on 10/04/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import "ASMHomeViewController.h"
#import "ASMPhotoCell.h"
#import "ASMListViewController.h"
#import "ASMInfoViewController.h"
#import "ASMEditViewController.h"

@interface ASMHomeViewController () {
    UIActionSheet *socialActionSheet;
    UIActionSheet *deleteActionSheet;
}

@end

@implementation ASMHomeViewController

- (id)initWithModel:(NSMutableArray*)model
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.model = model;
        self.title = @"Camera Minus";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector( infoClicked: )];
    
    self.photosCV.delegate = self;
    self.photosCV.dataSource = self;
    
    self.photosCV.allowsMultipleSelection = YES;
    
    [self.photosCV registerNib:[UINib nibWithNibName:@"ASMPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCell"];
    
    if (self.model.count == 0) self.listButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.photosCV reloadData];
    
    // THE WAY OF THE GEORGE
    self.shootButton.enabled = ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] );
    
    self.editButton.enabled = NO;
    self.deleteButton.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)list:(id)sender
{
//    ASMListViewController *listVC = [[ASMListViewController alloc] initWithModel:self.model];
//    [self.navigationController pushViewController:listVC animated:NO];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)edit:(id)sender
{
    NSArray *selectedItems = [self.photosCV indexPathsForSelectedItems];
    ASMPhotoCell *cell = (ASMPhotoCell*)[self.photosCV cellForItemAtIndexPath:[selectedItems objectAtIndex:0]];
    ASMEditViewController *editVC = [[ASMEditViewController alloc] initWithPhoto:cell.image.image];
    [self.navigationController pushViewController:editVC animated:YES];
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
}

- (IBAction)social:(id)sender
{
    socialActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Flickr to download some images, or select Facebook or Twitter to publish the selected image."
                                                    delegate:self
                                           cancelButtonTitle:@"Back"
                                      destructiveButtonTitle:@"Flickr"
                                           otherButtonTitles:@"Facebook",@"Twitter",nil];
    [socialActionSheet showFromBarButtonItem:sender animated:YES];
}

- (IBAction)delete:(id)sender
{
    NSArray *selectedItems = [self.photosCV indexPathsForSelectedItems];
    NSString *actionSheetTitle = nil;
    if (selectedItems.count == 1)
    {
        actionSheetTitle = [NSString stringWithFormat:@"Are you sure you want to delete this image?"];
    }
    else
    {
        actionSheetTitle = [NSString stringWithFormat:@"Are you sure you want to delete these %lu images?", (unsigned long)selectedItems.count];
    }
    deleteActionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle
                                                    delegate:self
                                           cancelButtonTitle:@"Yup"
                                      destructiveButtonTitle:@"Nope"
                                           otherButtonTitles:nil];
    [deleteActionSheet showFromBarButtonItem:sender animated:YES];
    
    self.editButton.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - picker view delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = (UIImage*) [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.model addObject:image];
    if (self.model.count == 1) self.listButton.enabled = YES;
    [self.photosCV reloadData];
}

#pragma mark - collection view flow layout delegate methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}

#pragma mark - collection view data source delegate methods

// This code isn't necessary if we're using only 1 section
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ASMPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    cell.image.image = [self.model objectAtIndex:indexPath.item];
    
    // THE WAY OF THE GEORGE
    cell.backgroundColor = ( cell.selected ) ? [UIColor blueColor] : [UIColor blackColor];
    
    return cell;
}

#pragma mark - collection view delegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // THE WAY OF THE GEORGE
    self.editButton.enabled = ( [self.photosCV indexPathsForSelectedItems].count == 1 );
    self.navigationItem.rightBarButtonItem.enabled = ( [self.photosCV indexPathsForSelectedItems].count == 1 );
    
    self.deleteButton.enabled = YES;
    
    UICollectionViewCell* cell = [self.photosCV cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // THE WAY OF THE GEORGE
    self.editButton.enabled = ( [self.photosCV indexPathsForSelectedItems].count == 1 );
    self.navigationItem.rightBarButtonItem.enabled = ( [self.photosCV indexPathsForSelectedItems].count == 1 );
    
    self.deleteButton.enabled = YES;
    
    if( [self.photosCV indexPathsForSelectedItems].count == 0 ) self.deleteButton.enabled = NO;

    UICollectionViewCell *cell = [self.photosCV cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
}

#pragma mark - action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( actionSheet == socialActionSheet ) {
        if (buttonIndex == 0)
        {
            NSLog(@"First button clicked");
        }
        else if (buttonIndex == 1)
        {
            NSLog(@"Second button clicked");
        }
        else if (buttonIndex == 2)
        {
            NSLog(@"Third button clicked");
        }
        else
        {
            NSLog(@"Nothing was clicked, man");
        }
    }
    else if ( actionSheet == deleteActionSheet ) {
        if (buttonIndex == 1)
        {
            NSArray *selectedItems = [self.photosCV indexPathsForSelectedItems];
            NSArray *sortSelectedItems = [selectedItems sortedArrayWithOptions:0 usingComparator:^NSComparisonResult( id obj1, id obj2 )
                                          {
                                              if( ((NSIndexPath*)obj1).item > ( (NSIndexPath*)obj2).item) return (NSComparisonResult)NSOrderedAscending;
                                              if( ((NSIndexPath*)obj1).item < ( (NSIndexPath*)obj2).item) return (NSComparisonResult)NSOrderedDescending;
                                              return (NSComparisonResult)NSOrderedSame;
                                          }];
            
            for (NSIndexPath *indexPath in sortSelectedItems)
            {
                [self.model removeObjectAtIndex:indexPath.item];
            }
            
            [self.photosCV reloadData];
            
            self.deleteButton.enabled = NO;
            
            if (self.model.count == 0) self.listButton.enabled = NO;
        }
    }
}

#pragma mark - class instance methods

- (void)infoClicked:(id)sender
{
    NSArray *selectedItems = [self.photosCV indexPathsForSelectedItems];
    ASMPhotoCell *cell = (ASMPhotoCell*)[self.photosCV cellForItemAtIndexPath:[selectedItems objectAtIndex:0]];
    ASMInfoViewController *infoVC = [[ASMInfoViewController alloc] initWithPhoto:cell.image.image];
    [self.navigationController pushViewController:infoVC animated:YES];
}

@end
