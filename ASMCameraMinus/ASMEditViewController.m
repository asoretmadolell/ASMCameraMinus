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
    
    BOOL bFilter1;
    BOOL bFilter2;
    BOOL bFilter3;
    BOOL bFilter4;
    BOOL bFilter5;
}

@end

@implementation ASMEditViewController

- (id)initWithPhoto:(ASMPhoto*)photo
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = @"Edit Image";
        self.photo = photo;
        
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[ASMFilter entityName]];
        request.predicate = [NSPredicate predicateWithFormat:@"photo == %@", self.photo];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:ASMFilterAttributes.filterName ascending:YES]];
        self.filtersResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                          managedObjectContext:photo.managedObjectContext
                                                                            sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullFilePath = [NSString stringWithFormat:@"%@/%@.jpg", documentsDirectory, self.photo.name];
    self.myOriginalImage.image = [UIImage imageWithContentsOfFile:fullFilePath];
    
    [self.filtersResultsController performFetch:nil];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - instance methods

-(void)applyFilters:(NSMutableArray*)selectedFilters
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
    bFilter1 = bFilter2 = bFilter3 = bFilter4 = bFilter5 = NO;
    self.myFilteredImage.image = nil;
    NSIndexSet* selectedItems = filtersControl.selectedSegmentIndice;
    
    [selectedItems enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
     {
         if ( idx == 0 ) bFilter1 = YES;
         if ( idx == 1 ) bFilter2 = YES;
         if ( idx == 2 ) bFilter3 = YES;
         if ( idx == 3 ) bFilter4 = YES;
         if ( idx == 4 ) bFilter5 = YES;
         
         if ( idx == selectedItems.lastIndex )
         {
             filtersControl.enabled = NO;
             spinner.hidden = NO;
             [spinner startAnimating];
             
             NSMutableArray* selectedFilters = [[NSMutableArray alloc] init];
             
             if ( bFilter1 ) [selectedFilters addObject:@"CISepiaTone"];
             if ( bFilter2 ) [selectedFilters addObject:@"CIGaussianBlur"];
             if ( bFilter3 ) [selectedFilters addObject:@"CIColorInvert"];
             if ( bFilter4 ) [selectedFilters addObject:@"CIDotScreen"];
             if ( bFilter5 ) [selectedFilters addObject:@"CIHoleDistortion"];
             
             [self applyFilters:selectedFilters];
         }
    }];
}

-(void)saveClicked:(id)sender
{
    [self.photo.managedObjectContext save:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
