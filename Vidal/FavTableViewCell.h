//
//  FavTableViewCell.h
//  Vidal
//
//  Created by Anton Scherbakov on 18/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FavTableViewCell;
@protocol FavTableViewCellDelegate <NSObject>

- (void) del: (FavTableViewCell *) sender;

@end

@interface FavTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *information;
@property (nonatomic, weak) id <FavTableViewCellDelegate> delegate;
- (IBAction)delete:(UIButton *)sender;

@end
