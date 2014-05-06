//
//  ASMListViewController.m
//  ASMCameraMinus
//
//  Created by SoReT on 29/04/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import "ASMListViewController.h"
#import "ASMInfoViewController.h"

@interface ASMListViewController ()

@end

@implementation ASMListViewController

- (id)initWithModel:(NSArray*)model
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.model = model;
        self.title = @"List";
    }
    return self;
}

- (IBAction)gridButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    self.photoTV.delegate = self;
    self.photoTV.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.model.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    // Removed the "forIndexPath:indexPath". Still don't know exactly why it crashed with it.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    cell.imageView.image = [self.model objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    ASMInfoViewController *infoVC = [[ASMInfoViewController alloc] initWithPhoto:[self.model objectAtIndex:indexPath.item]];
    [self.navigationController pushViewController:infoVC animated:YES];
}

@end
