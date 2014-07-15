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
#import "ASMPhoto.h"
#import "Flickr.h"
#import "FlickrPhoto.h"
#import "ASMAppDelegate.h"

@interface ASMHomeViewController () {
    UIActionSheet *socialActionSheet;
    UIActionSheet *deleteActionSheet;
    Flickr* flickr;
    UIActivityIndicatorView *spinner;
    ASMAppDelegate* appDelegate;
}

@end

@implementation ASMHomeViewController

- (id)initWithFetchedResultsController:(NSFetchedResultsController *)aFetchedResultsController model:(AGTCoreDataStack *)model
{
    if (self = [super init]) {
        self.fetchedResultsController = aFetchedResultsController;
        self.model = model;
        self.title = @"Camera Minus";
        flickr = [[Flickr alloc] init];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (ASMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self performFetch];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector( infoClicked: )];
    
    self.photosCV.delegate = self;
    self.photosCV.dataSource = self;
    
    self.photosCV.allowsMultipleSelection = YES;
    
    [self.photosCV registerNib:[UINib nibWithNibName:@"ASMPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCell"];
    
//    if (self.model.count == 0) self.listButton.enabled = NO;
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    [spinner setCenter:CGPointMake(screenWidth/2.0, screenHeight/2.0)];
    [self.view addSubview:spinner];
    [spinner stopAnimating];
    spinner.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([CLLocationManager locationServicesEnabled]) {
        [appDelegate.locationManager startUpdatingLocation];
    }
    
    [self.photosCV reloadData];
    
    // THE WAY OF THE GEORGE
    self.shootButton.enabled = ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] );
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.editButton.enabled = NO;
    self.deleteButton.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [appDelegate.locationManager stopUpdatingLocation];
}

#pragma mark - Fetching

- (void)performFetch
{
    if (self.fetchedResultsController) {
        if (self.fetchedResultsController.fetchRequest.predicate) {
            NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName, self.fetchedResultsController.fetchRequest.predicate);
        } else {
            NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName);
        }
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    } else {
        NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    [self.photosCV reloadData];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = newfrc.fetchRequest.entity.name;
        }
        if (newfrc) {
            NSLog(@"[%@ %@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), oldfrc ? @"updated" : @"set");
            [self performFetch];
        } else {
            NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            [self.photosCV reloadData];
        }
    }
}

#pragma mark - toolbar buttons

- (IBAction)list:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)edit:(id)sender
{
    NSArray *selectedItems = [self.photosCV indexPathsForSelectedItems];
    NSIndexPath* selectedItem = [selectedItems objectAtIndex:0];
    ASMPhoto* photo = [[self.fetchedResultsController fetchedObjects] objectAtIndex:selectedItem.item];
    ASMEditViewController *editVC = [[ASMEditViewController alloc] initWithPhoto:photo];
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
    [self saveImageToDiskAndCoreData:image thumbnail:[self thumbnailFromImage:image]];
    self.listButton.enabled = YES;
    [self.fetchedResultsController.managedObjectContext save:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - collection view flow layout delegate methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 70);
}

#pragma mark - collection view data source delegate methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.fetchedResultsController sections] count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//	return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//	return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
//}
//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return [self.fetchedResultsController sectionIndexTitles];
//}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ASMPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    ASMPhoto* photo = [[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.item];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullFilePath = [NSString stringWithFormat:@"%@/%@.thb", documentsDirectory, photo.name];
    cell.image.image = [UIImage imageWithContentsOfFile:fullFilePath];
    
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

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

#pragma mark - action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( actionSheet == socialActionSheet ) {
        if (buttonIndex == 0)
        {
            NSLog(@"Flickr button clicked");
            spinner.hidden = NO;
            [spinner startAnimating];
            [self reloadModel:actionSheet];
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
                ASMPhoto* photo = [[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
                [self.fetchedResultsController.managedObjectContext deleteObject:photo];
                [self.fetchedResultsController.managedObjectContext save:nil];
            }
            
            self.deleteButton.enabled = NO;
            
            if ([self.fetchedResultsController fetchedObjects].count == 0) self.listButton.enabled = NO;
        }
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.photosCV insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.photosCV deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                break;
        }
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
//    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
//    {
//        switch(type)
//        {
//            case NSFetchedResultsChangeInsert:
//                [self.photosCV insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
//                break;
//                
//            case NSFetchedResultsChangeDelete:
//                [self.photosCV deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
//                break;
//                
//            case NSFetchedResultsChangeUpdate:
//                [self.photosCV reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
//                break;
//                
//            case NSFetchedResultsChangeMove:
//                [self.photosCV deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
//                [self.photosCV insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
//                break;
//        }
//    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
}

- (void)endSuspensionOfUpdatesDueToContextChanges
{
    _suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspend
{
    if (suspend) {
        _suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    } else {
        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
}

#pragma mark - class instance methods

- (void)infoClicked:(id)sender
{
    NSArray *selectedItems = [self.photosCV indexPathsForSelectedItems];
    NSIndexPath* selectedItem = [selectedItems objectAtIndex:0];
    ASMPhoto* photo = [[self.fetchedResultsController fetchedObjects] objectAtIndex:selectedItem.item];
    ASMInfoViewController *infoVC = [[ASMInfoViewController alloc] initWithPhoto:photo];
    [self.navigationController pushViewController:infoVC animated:YES];
}

-(void)reloadModel:(id) sender {
    [flickr searchFlickrForTerm:@"family" completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        if (error) {
            // debemos mostrar mensaje de error
        } else {
            if (results.count > 0)
            {
                for( FlickrPhoto* photo in results )
                {
                    [self saveImageToDiskAndCoreData:photo.largeImage thumbnail:photo.thumbnail];
                }
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   [self.fetchedResultsController.managedObjectContext save:nil];
                                   [self.photosCV reloadData];
                                   [spinner stopAnimating];
                                   spinner.hidden = YES;
                                   self.listButton.enabled = YES;
                               });
            }
        }
    }];
}

-(void)saveImageToDiskAndCoreData:(UIImage*)image thumbnail:(UIImage*)thumbnail
{
    if( !image || !thumbnail ) return;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int value = [[userDefaults objectForKey:FILE_NUM] intValue] + 1;
    
    // Save image
    NSString *photoName = [NSString stringWithFormat:@"ASMIMG%04d", value];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", photoName];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    [UIImageJPEGRepresentation(image, 1) writeToFile:fullFilePath atomically:YES];
    
    // Save thumbnail
    fileName = [NSString stringWithFormat:@"%@.thb", photoName];
    fullFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    [UIImageJPEGRepresentation(thumbnail, 1) writeToFile:fullFilePath atomically:YES];
    
    ASMPhoto *photo = [ASMPhoto photoWithName:photoName inContext:self.fetchedResultsController.managedObjectContext];
    photo.altitude = [NSNumber numberWithFloat:appDelegate.lastLocation.altitude];
    photo.longitude = [NSNumber numberWithDouble:appDelegate.lastLocation.coordinate.longitude];
    photo.latitude = [NSNumber numberWithDouble:appDelegate.lastLocation.coordinate.latitude];
    photo.address = appDelegate.reverseGeocoding;
    photo.weight = [NSNumber numberWithFloat:UIImageJPEGRepresentation(image, 1).length / 1024.0f / 1024.0f];
    photo.height = [NSNumber numberWithInt:image.size.height];
    photo.width = [NSNumber numberWithInt:image.size.width];
    
    [userDefaults setObject:[NSNumber numberWithInt:value] forKey:FILE_NUM];
    [userDefaults synchronize];
}

-(UIImage*)thumbnailFromImage:(UIImage*)image
{
    if( !image) return nil;
   
    UIImage* thumbnail = nil;
    
    CGSize destinationSize = CGSizeMake( image.size.width / 4, image.size.height / 4 );
    UIGraphicsBeginImageContext( destinationSize );
    [image drawInRect:CGRectMake( 0, 0, destinationSize.width, destinationSize.height ) ];
    thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbnail;
}

@end
