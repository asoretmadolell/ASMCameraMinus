//
//  ASMAppDelegate.m
//  ASMCameraMinus
//
//  Created by SoReT on 10/04/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import "ASMAppDelegate.h"
#import "ASMHomeViewController.h"
#import "ASMListViewController.h"
#import "ASMCDStackTableViewController.h"
#import "ASMPhoto.h"

@interface ASMAppDelegate () {
    NSMutableArray *myPhotosArray;
}

@end

@implementation ASMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
//    [self initModel];
    self.model = [AGTCoreDataStack coreDataStackWithModelName:@"ASMDataModel"];
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[ASMPhoto entityName]];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:ASMBaseEntityAttributes.creationDate ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:ASMBaseEntityAttributes.name ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    NSFetchedResultsController* fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.model.context sectionNameKeyPath:nil cacheName:nil];
    
    ASMCDStackTableViewController *vc = [[ASMCDStackTableViewController alloc] initWithFetchedResultsController:fetchResultsController style:UITableViewStylePlain];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

# pragma mark - instance methods

- (void)initModel
{
    myPhotosArray = [[NSMutableArray alloc]init];
    
    [myPhotosArray addObject:[UIImage imageNamed:@"facedetectionpic.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"dump.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"fruit_killer.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"people.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"walking_on_water.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"olympic_dive.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"funny_shirt.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"seal_singer.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"facedetectionpic.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"dump.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"fruit_killer.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"people.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"walking_on_water.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"olympic_dive.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"funny_shirt.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"seal_singer.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"facedetectionpic.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"dump.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"fruit_killer.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"people.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"walking_on_water.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"olympic_dive.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"funny_shirt.jpg"]];
    [myPhotosArray addObject:[UIImage imageNamed:@"seal_singer.jpg"]];
}

@end

