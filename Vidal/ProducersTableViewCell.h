//
//  ProducersTableViewCell.h
//  Vidal
//
//  Created by Anton Scherbakov on 18/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProducersTableViewCell;
@protocol ProducersTableViewCellDelegate <NSObject>

- (void) perfSeg: (ProducersTableViewCell *) sender;

@end

@interface ProducersTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameUnhid;
@property (strong, nonatomic) IBOutlet UILabel *countryUnhid;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *nameHid;
@property (strong, nonatomic) IBOutlet UILabel *countryHid;
@property (strong, nonatomic) IBOutlet UILabel *addressHid;
@property (strong, nonatomic) IBOutlet UILabel *emailHid;
@property (strong, nonatomic) IBOutlet UILabel *phoneHid;
@property (strong, nonatomic) IBOutlet UIButton *listBtn;

@property (nonatomic, weak) id <ProducersTableViewCellDelegate> delegate;

- (IBAction)toListDrugs:(UIButton *)sender;


@end
