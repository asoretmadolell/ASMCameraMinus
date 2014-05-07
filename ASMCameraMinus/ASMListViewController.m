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

@interface ASMListViewController () {
    NSMutableArray *myPhotosArray;
}

@end

@implementation ASMListViewController

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
    myPhotosArray = self.model;
    
    self.navigationItem.hidesBackButton = YES;
    
    self.photoTV.delegate = self;
    self.photoTV.dataSource = self;
    
    self.photoTV.allowsMultipleSelection = YES;
    
    [self.photoTV registerNib:[UINib nibWithNibName:@"ASMTableViewCell" bundle:nil] forCellReuseIdentifier:@"MYCELL"];
//    [self.photoTV registerClass:[ASMPhotoTableCell class] forCellReuseIdentifier:@"MYCELL"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.photoTV reloadData];
    
    self.editButton.enabled = NO;
    self.deleteButton.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)grid:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)edit:(id)sender
{
    NSArray *selectedItems = [self.photoTV indexPathsForSelectedRows];
    UITableViewCell *cell = [self.photoTV cellForRowAtIndexPath:[selectedItems objectAtIndex:0]];
    ASMInfoViewController *infoVC = [[ASMInfoViewController alloc] initWithPhoto:cell.imageView.image];
    [self.navigationController pushViewController:infoVC animated:YES];
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

- (IBAction)social:(id)sender {
}

- (IBAction)delete:(id)sender
{
    NSArray *selectedItems = [self.photoTV indexPathsForSelectedRows];
    
    NSString *actionSheetTitle = [[NSString alloc] init];
    
    if (selectedItems.count == 1)
    {
        actionSheetTitle = [NSString stringWithFormat:@"Are you sure you want to delete this image?"];
    }
    else
    {
        actionSheetTitle = [NSString stringWithFormat:@"Are you sure you want to delete these %lu images?", (unsigned long)selectedItems.count];
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionSheetTitle
                                                             delegate:self
                                                    cancelButtonTitle:@"Yup"
                                               destructiveButtonTitle:@"Nope"
                                                    otherButtonTitles:nil];
    
    [actionSheet showFromBarButtonItem:sender animated:YES];
    
    self.editButton.enabled = NO;
}

#pragma mark - picker view delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = (UIImage*) [info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [myPhotosArray addObject:image];
    if (myPhotosArray.count == 1) self.gridButton.enabled = YES;
    [self.photoTV reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return myPhotosArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    // Removed the "forIndexPath:indexPath". Still don't know exactly why it crashed with it.
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
//    cell.imageView.image = [myPhotosArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"MYCELL" forIndexPath:indexPath];
    ASMTableViewCell *myCell = (ASMTableViewCell*)cell;
    
    myCell.myLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    myCell.myImageView.image = [myPhotosArray objectAtIndex:indexPath.row];
    
    return myCell;
}

#pragma mark - table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // THE WAY OF THE GEORGE
    self.editButton.enabled = ( [self.photoTV indexPathsForSelectedRows].count == 1 );
    
    self.deleteButton.enabled = YES;
    
    UITableViewCell* cell = [self.photoTV cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor blueColor];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // THE WAY OF THE GEORGE
    self.editButton.enabled = ( [self.photoTV indexPathsForSelectedRows].count == 1 );
    
    self.deleteButton.enabled = YES;
    if( [self.photoTV indexPathsForSelectedRows].count == 0 ) self.deleteButton.enabled = NO;
}

#pragma mark - action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
            [myPhotosArray removeObjectAtIndex:indexPath.item];
        }
        
        [self.photoTV reloadData];
        
        self.deleteButton.enabled = NO;
        
        if (myPhotosArray.count == 0) self.gridButton.enabled = NO;
    }
}

@end
