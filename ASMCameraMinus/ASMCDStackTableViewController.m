//
//  ASMCDStackTableViewController.m
//  ASMCameraMinus
//
//  Created by Jorge Marcos Fernandez on 20/05/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import "ASMCDStackTableViewController.h"
#import "ASMPhoto.h"

@interface ASMCDStackTableViewController ()

@end

@implementation ASMCDStackTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddPhoto:)];
    
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

#pragma mark - instance methods

- (void)onAddPhoto:(id) sender
{
    static int i = 0;
    NSString* name = [NSString stringWithFormat:@"photo # %d", ++i];
    ASMPhoto *photo = [ASMPhoto photoWithName:name inContext:self.fetchedResultsController.managedObjectContext];
    [self.fetchedResultsController.managedObjectContext save:nil];
}

@end
