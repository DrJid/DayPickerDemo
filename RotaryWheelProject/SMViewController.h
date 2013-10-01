//
//  SMViewController.h
//  RotaryWheelProject
//
//  Created by Maijid Moujaled on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRotaryProtocol.h"

@interface SMViewController : UIViewController <SMRotaryProtocol>

@property (nonatomic, strong) UILabel *sectorLabel;

@end
