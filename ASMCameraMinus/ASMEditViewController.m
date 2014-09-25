//
//  ASMEditViewController.m
//  ASMCameraMinus
//
//  Created by Alejandro Soret Madolell on 08/05/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import "ASMEditViewController.h"
#import "WLHorizontalSegmentedControl.h"

@interface ASMEditViewController () {
    UIActivityIndicatorView *spinner;
    WLHorizontalSegmentedControl* filtersControl;
    BOOL bFromUndoGrouping;
}

@end

@implementation ASMEditViewController

- (id)initWithPhoto:(ASMPhoto*)photo
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = @"Edit Image";
        self.photo = photo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self.photo.managedObjectContext undoManager] beginUndoGrouping];
    bFromUndoGrouping = YES;
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullFilePath = [NSString stringWithFormat:@"%@/%@.jpg", documentsDirectory, self.photo.name];
    self.myOriginalImage.image = [UIImage imageWithContentsOfFile:fullFilePath];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    [spinner setCenter:CGPointMake(screenWidth/2.0, screenHeight/2.0)];
    [self.view addSubview:spinner];
    [spinner stopAnimating];
    spinner.hidden = YES;
    
    // DECENT SEGMENTED CONTROL, UNLIKE UIKIT'S
    filtersControl = [[WLHorizontalSegmentedControl alloc] initWithItems:@[@"Filter1", @"Filter2", @"Filter3", @"Filter4", @"Filter5"]];
    filtersControl.frame = CGRectMake(5, screenRect.size.height -35, screenRect.size.width - 10, 30);
    filtersControl.allowsMultiSelection = YES;
    filtersControl.enabled = YES;
    [filtersControl addTarget:self action:@selector(filterClicked:) forControlEvents:UIControlEventValueChanged];
    filtersControl.layer.zPosition = 10;
    [self.view addSubview:filtersControl];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector( saveClicked: )];
    
    [filtersControl setSelectedSegmentIndice:[self getSelectedFiltersIndexSet]];
    
    if ([self getSelectedFiltersNames].count > 0)
    {
        filtersControl.enabled = NO;
        spinner.hidden = NO;
        [spinner startAnimating];
        [self applyFilters:[self getSelectedFiltersNames]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didMoveToParentViewController:(UIViewController *)parent
{
    if (!bFromUndoGrouping) {
        return;
    }
    
    // SOLUTION TO BACKBUTTON = NIL >:(
    if ( !(parent = self.parentViewController) )
    {
        [[self.photo.managedObjectContext undoManager] endUndoGrouping];
        [[self.photo.managedObjectContext undoManager] undo];
        [self.photo.managedObjectContext save:nil];
        bFromUndoGrouping = NO;
    }
}

#pragma mark - instance methods

-(void)applyFilters:(NSArray*)selectedFilters
{
    dispatch_queue_t filterQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(filterQueue, ^{
        CIContext* context = [CIContext contextWithOptions:nil];
        
        CIImage* image = [CIImage imageWithCGImage:self.myOriginalImage.image.CGImage];
        
        UIImage* filteredImage = nil;
        
        for ( NSString* filterName in selectedFilters )
        {
            CIFilter* filter = [CIFilter filterWithName:filterName];
            
            [filter setDefaults];
            [filter setValue:image forKey:kCIInputImageKey];
            CIImage* filteredCGIImage = [filter valueForKey:kCIOutputImageKey];
            
            CGImageRef cgImage = [context createCGImage:filteredCGIImage fromRect:[filteredCGIImage extent]];
            filteredImage = [UIImage imageWithCGImage:cgImage];
            CGImageRelease(cgImage);
            
            image = [CIImage imageWithCGImage:filteredImage.CGImage];
        }
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            self.myFilteredImage.image = filteredImage;
            [spinner stopAnimating];
            spinner.hidden = YES;
            filtersControl.enabled = YES;
        });
    });
}

-(void)filterClicked:(id)sender
{
    self.photo.filter1 = self.photo.filter2 = self.photo.filter3 = self.photo.filter4 = self.photo.filter5 = NO;
    self.myFilteredImage.image = nil;
    NSIndexSet* selectedItems = filtersControl.selectedSegmentIndice;
    
    [selectedItems enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
     {
         if ( idx == 0 ) self.photo.filter1 = @YES; // [NSNumber numberWithBool:YES];
         if ( idx == 1 ) self.photo.filter2 = @YES; // [NSNumber numberWithBool:YES];
         if ( idx == 2 ) self.photo.filter3 = @YES; // [NSNumber numberWithBool:YES];
         if ( idx == 3 ) self.photo.filter4 = @YES; // [NSNumber numberWithBool:YES];
         if ( idx == 4 ) self.photo.filter5 = @YES; // [NSNumber numberWithBool:YES];
         
         if ( idx == selectedItems.lastIndex )
         {
             filtersControl.enabled = NO;
             spinner.hidden = NO;
             [spinner startAnimating];
             
             [self applyFilters:[self getSelectedFiltersNames]];
         }
    }];
}

-(void)saveClicked:(id)sender
{
    [[self.photo.managedObjectContext undoManager] endUndoGrouping];
    bFromUndoGrouping = NO;
    [[self.photo.managedObjectContext undoManager] setActionName:@"Filters applied"];
    [self.photo.managedObjectContext save:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSArray*)getSelectedFiltersNames
{
    NSMutableArray* selectedFilters = [[NSMutableArray alloc] init];
    
    if ( self.photo.filter1 ) [selectedFilters addObject:@"CISepiaTone"];
    if ( self.photo.filter2 ) [selectedFilters addObject:@"CIGaussianBlur"];
    if ( self.photo.filter3 ) [selectedFilters addObject:@"CIColorInvert"];
    if ( self.photo.filter4 ) [selectedFilters addObject:@"CIDotScreen"];
    if ( self.photo.filter5 ) [selectedFilters addObject:@"CIHoleDistortion"];
    
    return selectedFilters;
}

-(NSIndexSet*)getSelectedFiltersIndexSet
{
    NSMutableIndexSet* selectedItems = [[NSMutableIndexSet alloc] init];
    
    if ( self.photo.filter1 ) [selectedItems addIndex:0];
    if ( self.photo.filter2 ) [selectedItems addIndex:1];
    if ( self.photo.filter3 ) [selectedItems addIndex:2];
    if ( self.photo.filter4 ) [selectedItems addIndex:3];
    if ( self.photo.filter5 ) [selectedItems addIndex:4];
    
    return selectedItems;
}

@end
