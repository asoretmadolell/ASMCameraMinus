//
//  ASMListViewController.m
//  ASMCameraMinus
//
//  Created by SoReT on 29/04/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import "ASMListViewController.h"
#import "ASMInfoViewController.h"
#import "ASMTableViewCell.h"
#import "ASMEditViewController.h"
#import "ASMPhoto.h"
#import "Flickr.h"
#import "FlickrPhoto.h"

@interface ASMListViewController () {
    UIActionSheet *socialActionSheet;
    UIActionSheet *deleteActionSheet;
    Flickr* flickr;
    UIActivityIndicatorView *spinner;
}

@property (nonatomic) BOOL beganUpdates;

@end

@implementation ASMListViewController

-(id) initWithFetchedResultsController: (NSFetchedResultsController *) aFetchedResultsController
{
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.fetchedResultsController = aFetchedResultsController;
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
    [self performFetch];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector( infoClicked: )];
    
    self.photoTV.delegate = self;
    self.photoTV.dataSource = self;
    
    self.photoTV.allowsMultipleSelection = YES;
    
    [self.photoTV registerNib:[UINib nibWithNibName:@"ASMTableViewCell" bundle:nil] forCellReuseIdentifier:@"MYCELL"];

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
    
    [self.photoTV reloadData];
    
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
    [self.photoTV reloadData];
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
            [self.photoTV reloadData];
        }
    }
}

#pragma mark - toolbar buttons

- (IBAction)grid:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)edit:(id)sender
{
    NSArray *selectedItems = [self.photoTV indexPathsForSelectedRows];
    ASMTableViewCell *cell = (ASMTableViewCell*)[self.photoTV cellForRowAtIndexPath:[selectedItems objectAtIndex:0]];
    ASMEditViewController *editVC = [[ASMEditViewController alloc] initWithPhoto:cell.myImageView.image];
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
    NSArray *selectedItems = [self.photoTV indexPathsForSelectedRows];
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
    UIImage* image = (UIImage*) [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self saveImageToDiskAndCoreData:image];
    if ([self.fetchedResultsController fetchedObjects].count == 1) self.gridButton.enabled = YES;
    [self.fetchedResultsController.managedObjectContext save:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASMTableViewCell *myCell = (ASMTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MYCELL" forIndexPath:indexPath];
    
    ASMPhoto* photo = [[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
    myCell.myLabel.text = [NSString stringWithFormat:@"%ld - %@", (long)indexPath.row + 1, photo.name];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, photo.name];
    myCell.myImageView.image = [UIImage imageWithContentsOfFile:fullFilePath];
    
    myCell.mySizeLabel.text = [NSString stringWithFormat:@"Size: %.0f x %.0f", myCell.myImageView.image.size.width, myCell.myImageView.image.size.height];
    
    if ( myCell.weight == 0 )
    {
        NSData* imgData = UIImageJPEGRepresentation(myCell.myImageView.image, 1);
        myCell.weight = imgData.length / 1024.0f / 1024.0f;
    }
    
    myCell.myWeightLabel.text = [NSString stringWithFormat:@"Weight: %.2f MB", myCell.weight ];
    
    if ( myCell.isSelected ) myCell.contentView.backgroundColor = [UIColor blueColor];
    
    return myCell;
}

#pragma mark - table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // THE WAY OF THE GEORGE
    self.editButton.enabled = ( [self.photoTV indexPathsForSelectedRows].count == 1 );
    self.navigationItem.rightBarButtonItem.enabled = ( [self.photoTV indexPathsForSelectedRows].count == 1 );
    
    self.deleteButton.enabled = YES;
    
    UITableViewCell* cell = [self.photoTV cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor blueColor];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // THE WAY OF THE GEORGE
    self.editButton.enabled = ( [self.photoTV indexPathsForSelectedRows].count == 1 );
    self.navigationItem.rightBarButtonItem.enabled = ( [self.photoTV indexPathsForSelectedRows].count == 1 );
    
    self.deleteButton.enabled = YES;
    if( [self.photoTV indexPathsForSelectedRows].count == 0 ) self.deleteButton.enabled = NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASMPhoto* photo = [[self.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
    [self.fetchedResultsController.managedObjectContext deleteObject:photo];
    [self.fetchedResultsController.managedObjectContext save:nil];
    
    self.editButton.enabled = NO;
    self.deleteButton.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

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
            NSArray *selectedItems = [self.photoTV indexPathsForSelectedRows];
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
            
            if ([self.fetchedResultsController fetchedObjects].count == 0) self.gridButton.enabled = NO;
        }
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        [self.photoTV beginUpdates];
        self.beganUpdates = YES;
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
                [self.photoTV insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.photoTV deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
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
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.photoTV insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.photoTV deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.photoTV reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.photoTV deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.photoTV insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.beganUpdates) [self.photoTV endUpdates];
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
    NSArray *selectedItems = [self.photoTV indexPathsForSelectedRows];
    ASMTableViewCell *myCell = (ASMTableViewCell*)[self.photoTV cellForRowAtIndexPath:[selectedItems objectAtIndex:0]];
    ASMInfoViewController *infoVC = [[ASMInfoViewController alloc] initWithPhoto:myCell.myImageView.image];
    [self.navigationController pushViewController:infoVC animated:YES];
}

-(void)reloadModel:(id) sender {
    [flickr searchFlickrForTerm:@"Spain" completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        if (error) {
            // debemos mostrar mensaje de error
        } else {
            if (results.count > 0)
            {
                for( FlickrPhoto* photo in results )
                {
                    [self saveImageToDiskAndCoreData:photo.thumbnail];
                }
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   [self.fetchedResultsController.managedObjectContext save:nil];
                                   [self.photoTV reloadData];
                                   [spinner stopAnimating];
                                   spinner.hidden = YES;
                               });
                
            }
        }
    }];
}

-(void)saveImageToDiskAndCoreData:(UIImage*)image
{
    if( !image ) return;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int value = [[userDefaults objectForKey:FILE_NUM] intValue] + 1;
    NSString *fileName = [NSString stringWithFormat:@"ASMIMG%04d.jpg", value];
    
    //    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [directories objectAtIndex:0];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *fullFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    
    [UIImageJPEGRepresentation(image, 1) writeToFile:fullFilePath atomically:YES];
    
    ASMPhoto *photo = [ASMPhoto photoWithName:fileName inContext:self.fetchedResultsController.managedObjectContext];
    
    [userDefaults setObject:[NSNumber numberWithInt:value] forKey:FILE_NUM];
    [userDefaults synchronize];
}


@end
