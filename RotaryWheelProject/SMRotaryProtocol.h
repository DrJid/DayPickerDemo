//
//  SMRotaryProtocol.h
//  RotaryWheelProject
//
//  Created by Maijid Moujaled on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMRotaryProtocol <NSObject>

- (void)wheelDidChangeValue:(NSString *)newValue;

@end
