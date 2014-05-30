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

@interface ASMListViewController () {
    NSMutableArray *myPhotosArray;
    UIActionSheet *socialActionSheet;
    UIActionSheet *deleteActionSheet;
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector( infoClicked: )];
    
    self.photoTV.delegate = self;
    self.photoTV.dataSource = self;
    
    self.photoTV.allowsMultipleSelection = YES;
    
    [self.photoTV registerNib:[UINib nibWithNibName:@"ASMTableViewCell" bundle:nil] forCellReuseIdentifier:@"MYCELL"];

    // MANUAL SPINNER
//    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenWidth = screenRect.size.width;
//    CGFloat screenHeight = screenRect.size.height;
//    [spinner setCenter:CGPointMake(screenWidth/2.0, screenHeight/2.0)];
//    [self.view addSubview:spinner];
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
    NSString *actionSheetTitle = [[NSString alloc] init];
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
    ASMTableViewCell *myCell = (ASMTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MYCELL" forIndexPath:indexPath];
    
    myCell.myLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    myCell.myImageView.image = [myPhotosArray objectAtIndex:indexPath.row];
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
    [myPhotosArray removeObjectAtIndex:indexPath.row];
    [tableView reloadData];
    
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
}

#pragma mark - class instance methods

- (void)infoClicked:(id)sender
{
    NSArray *selectedItems = [self.photoTV indexPathsForSelectedRows];
    ASMTableViewCell *myCell = (ASMTableViewCell*)[self.photoTV cellForRowAtIndexPath:[selectedItems objectAtIndex:0]];
    ASMInfoViewController *infoVC = [[ASMInfoViewController alloc] initWithPhoto:myCell.myImageView.image];
    [self.navigationController pushViewController:infoVC animated:YES];
}


@end
