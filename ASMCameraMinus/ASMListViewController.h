//
//  ASMListViewController.h
//  ASMCameraMinus
//
//  Created by SoReT on 29/04/14.
//  Copyright (c) 2014 SoReT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASMListViewController : UITableViewController
// UITableViewController ya implementa estos dos protocolos :D
// <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *model;

- (id)initWithStyle:(UITableViewStyle)style andModel:(NSArray*)model;

@end
