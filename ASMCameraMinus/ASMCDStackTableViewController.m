//
//  ASMCDStackTableViewController.m
//  ASMCameraMinus
//
//  Created by Jorge Marcos Fernandez on 20/05/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import "ASMCDStackTableViewController.h"
#import "ASMPhoto.h"
#import "Flickr.h"
#import "FlickrPhoto.h"

@interface ASMCDStackTableViewController () {
    Flickr* flickr;
}

@end

@implementation ASMCDStackTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    flickr = [[Flickr alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(reloadModel:)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    ASMPhoto* photo = (ASMPhoto*)[[self.fetchedResultsController fetchedObjects]objectAtIndex:indexPath.row];
    cell.textLabel.text = photo.name;
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullFilePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, photo.name];
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:fullFilePath];
    
    return cell;
}

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 */

#pragma mark - picker view delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = (UIImage*) [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self saveImageToDiskAndCoreData:image];
    [self.fetchedResultsController.managedObjectContext save:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - instance methods

- (void)onAddPhoto:(id) sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *pc_shoot = [[UIImagePickerController alloc] init];
        pc_shoot.delegate = self;
        pc_shoot.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pc_shoot animated:YES completion:nil];
    }
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
                    [self.tableView reloadData];
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
