//
//  DrugsTableViewCell.h
//  Vidal
//
//  Created by Anton Scherbakov on 18/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SLExpandableTableView.h>


@interface DrugsTableViewCell : UITableViewCell <UIExpandingTableViewCell>

@property (nonatomic, assign, getter = isLoading) BOOL loading;

@property (nonatomic, readonly) UIExpansionStyle expansionStyle;
- (void)setExpansionStyle:(UIExpansionStyle)expansionStyle animated:(BOOL)animated;
@property (weak, nonatomic) IBOutlet UILabel *letter;
@property (weak, nonatomic) IBOutlet UILabel *name;


@end
