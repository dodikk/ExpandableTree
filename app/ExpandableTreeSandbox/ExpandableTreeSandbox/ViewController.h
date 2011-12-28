//
//  ViewController.h
//  ExpandableTreeSandbox
//
//  Created by Aleksey Sayenko on 12/27/11.
//  Copyright (c) 2011 EPAM Systems. All rights reserved.
//

#import <ETExpandableTreeViewDelegate.h>
#import <ETExpandableTreeViewDataSource.h>

#import <UIKit/UIKit.h>

@class ETExpandableTreeView;

@interface ViewController : UIViewController < ETExpandableTreeViewDataSource, ETExpandableTreeViewDelegate >

@property ( nonatomic, weak ) IBOutlet ETExpandableTreeView* treeView;

@end
