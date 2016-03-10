//
//  MenuViewController.h
//  Vidal
//
//  Created by Anton Scherbakov on 10/03/16.
//  Copyright © 2016 StyleRU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface MenuViewController : UIViewController <SWRevealViewControllerDelegate, UIGestureRecognizerDelegate>

- (IBAction)toNews:(UIButton *)sender;
- (IBAction)toDrugs:(UIButton *)sender;
- (IBAction)toActive:(UIButton *)sender;
- (IBAction)toInteractions:(UIButton *)sender;
- (IBAction)toPharma:(UIButton *)sender;
- (IBAction)toProducers:(UIButton *)sender;
- (IBAction)toAbout:(UIButton *)sender;
- (IBAction)toProfile:(UIButton *)sender;
- (IBAction)toFavourite:(UIButton *)sender;
- (IBAction)toReference:(UIButton *)sender;

@end
