//
//  DrugsViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import "ModelViewController.h"
#import <SLExpandableTableView.h>
#import "DrugsTableViewCell.h"
#import "DBManager.h"

@interface DrugsViewController : ModelViewController <SLExpandableTableViewDatasource, SLExpandableTableViewDelegate>
@property (strong, nonatomic) IBOutlet SLExpandableTableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *name;

@end
