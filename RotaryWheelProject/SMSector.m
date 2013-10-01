//
//  SMSector.m
//  RotaryWheelProject
//
//  Created by Maijid Moujaled on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SMSector.h"

@implementation SMSector

@synthesize minValue, maxValue, midValue, sector;

- (NSString *)description
{
    return [NSString stringWithFormat:@"%i | %f, %f, %f", self.sector, self.minValue, self.midValue, self.maxValue];
}

@end
