//
//  SMRotaryWheel.h
//  RotaryWheelProject
//
//  Created by Maijid Moujaled on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRotaryProtocol.h"
#import "SMSector.h"

@interface SMRotaryWheel : UIControl

@property (weak) id <SMRotaryProtocol> delegate;
@property (nonatomic, strong) UIView *container;
@property int numberOfSections;
@property CGAffineTransform startTransform; //to save transform when user taps
@property (nonatomic, strong) NSMutableArray *sectors;
@property int currentSector;


//Custom init of our intrface element. 
- (id)initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionNumber;
- (void)rotate;

@end
