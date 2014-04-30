//
//  ASMListViewController.h
//  ASMCameraMinus
//
//  Created by SoReT on 29/04/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASMListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *model;
@property (weak, nonatomic) IBOutlet UITableView *photoTV;

- (id)initWithModel:(NSArray*)model;

@end
