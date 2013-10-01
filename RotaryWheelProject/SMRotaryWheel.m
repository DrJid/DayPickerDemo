//
//  SMRotaryWheel.m
//  RotaryWheelProject
//
//  Created by Maijid Moujaled on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SMRotaryWheel.h"
#import <QuartzCore/QuartzCore.h>

@interface SMRotaryWheel()  
- (void)drawWheel;
- (float) calculateDistanceFromCenter:(CGPoint)point;
- (void)buildSectorsEven;
- (void)buildSectorsOdd;
- (UIImageView *) getSectorByValue:(int)value;
@end

static float deltaAngle;
static float minAlphavalue = 0.6;
static float maxAlphavalue = 1.0;

@implementation SMRotaryWheel

@synthesize delegate, container, numberOfSections;
@synthesize startTransform, sectors;
@synthesize currentSector;


- (id)initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionNumber
{
    if ((self = [super initWithFrame:frame])) {
        self.numberOfSections = sectionNumber;
        self.delegate = del;
        [self drawWheel];
    }
    return self;
}


- (void)drawWheel
{
    

    
    container = [[UIView alloc] initWithFrame:self.frame];
    
    CGFloat angleSize = 2 * M_PI / numberOfSections;
    self.currentSector = 0;

    
    
    // 3 - Create the sectors
	for (int i = 0; i < numberOfSections; i++) {
        // 4 - Create image view
        UIImageView *im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segment.png"]];
        im.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        im.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x, 
                                        container.bounds.size.height/2.0-container.frame.origin.y); 
        im.transform = CGAffineTransformMakeRotation(angleSize*i);
        im.alpha = minAlphavalue;
        im.tag = i;
        if (i == 0) {
            im.alpha = maxAlphavalue;
        }
		// 5 - Set sector image        
        UIImageView *sectorImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 40, 40)];
        sectorImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%i.png", i]];
        [im addSubview:sectorImage];
        // 6 - Add image view to container
        [container addSubview:im];
	}
    
    

    
    container.userInteractionEnabled = NO;
    [self addSubview:container];
    
    sectors = [NSMutableArray arrayWithCapacity:numberOfSections];
    if (numberOfSections % 2 == 0 )
    {
        [self buildSectorsEven];
    }else {
        [self buildSectorsOdd];
    }
    
    // 7.1 - Add background image
	UIImageView *bg = [[UIImageView alloc] initWithFrame:self.frame];
	bg.image = [UIImage imageNamed:@"bg.png"];
	[self addSubview:bg];
    UIImageView *mask = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 58, 58)];
    mask.image =[UIImage imageNamed:@"centerButton.png"] ;
    mask.center = self.center;
    mask.center = CGPointMake(mask.center.x, mask.center.y+3);
    [self addSubview:mask];
    
    [self.delegate wheelDidChangeValue: [self getSectorName:currentSector]]; //[NSString stringWithFormat:@"Value is %i", self.currentSector]];
}

- (void)rotate
{
    CGAffineTransform t = CGAffineTransformRotate(container.transform, (2 * M_PI) / numberOfSections);
    container.transform = t;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    
    float dist = [self calculateDistanceFromCenter:touchPoint];
    if (dist < 40 || dist > 100)
    {
        //forcing tap to be on the ferrule
        NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
        return NO;
    }
    
    float dx = touchPoint.x - container.center.x;
    float dy = touchPoint.y - container.center.y;
    
    deltaAngle = atan2(dy, dx);
    NSLog(@"deltaangle = %f", deltaAngle);
    
    // 5 - Set current sector's alpha value to the minimum value
	UIImageView *im = [self getSectorByValue:currentSector];
	im.alpha = minAlphavalue;
    
    startTransform = container.transform;
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    NSLog(@"radian is %f", radians);
    CGPoint pt = [touch locationInView:self];
    float dx = pt.x - container.center.x;
    float dy = pt.y - container.center.y;
    float ang = atan2(dy,dx);
    float angleDifference = deltaAngle - ang;
    container.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    return YES;
}

- (float)calculateDistanceFromCenter:(CGPoint)point
{
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float dx = point.x - center.x;
    float dy = point.y - center.y;
    return sqrtf(dx*dx + dy*dy);
}

- (void)buildSectorsOdd
{
    CGFloat fanWidth = M_PI * 2 / numberOfSections;
    
    CGFloat mid = 0;
    
    for (int i = 0; i < numberOfSections; i++)
    {
        SMSector *sector = [SMSector new];
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sector = i;
        mid -= fanWidth;
        if (sector.minValue < -M_PI) {
            mid = -mid;
            mid -= fanWidth;
        }
        [sectors addObject:sector];
        NSLog(@"cl is %@", sector);
    }
}

- (void)buildSectorsEven
{
    CGFloat fanWidth = M_PI * 2 / numberOfSections;
    
    CGFloat mid = 0;
    
    for (int i = 0; i < numberOfSections; i++)
    {
        SMSector *sector = [SMSector new];
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sector = i;
        if (sector.maxValue-fanWidth < -M_PI) {
            mid = M_PI;
            sector.midValue = mid;
            sector.minValue = abs(sector.maxValue);
        }
        mid -= fanWidth;
        [sectors addObject:sector];
    }
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    // 1 - Get current container rotation in radians
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    // 2 - Initialize new value
    CGFloat newVal = 0.0;
    // 3 - Iterate through all the sectors
    for (SMSector *s in sectors) {
            
        // 4 - Check for anomaly (occurs with even number of sectors)
        if (s.minValue > 0 && s.maxValue < 0) {
            if (s.maxValue > radians || s.minValue < radians) {
                // 5 - Find the quadrant (positive or negative)
                if (radians > 0) {
                    newVal = radians - M_PI;
                } else {
                    newVal = M_PI + radians;                    
                }
                currentSector = s.sector;
            }
        }
        // 6 - All non-anomalous cases
        else if (radians > s.minValue && radians < s.maxValue) {
            newVal = radians - s.midValue;
            currentSector = s.sector;
        }
    }
    
    // 7 - Set up animation for final rotation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform t = CGAffineTransformRotate(container.transform, -newVal);
    container.transform = t;
    [UIView commitAnimations];
    
    UIImageView *im = [self getSectorByValue:currentSector];
	im.alpha = maxAlphavalue;
    
    [self.delegate wheelDidChangeValue:[self getSectorName:currentSector]];//  [NSString stringWithFormat:@"Value is %i", self.currentSector]];

}

- (UIImageView *) getSectorByValue:(int)value {
    UIImageView *res;
    NSArray *views = [container subviews];
    for (UIImageView *im in views) {
        if (im.tag == value)
            res = im;
    }
    return res;
}

- (NSString *) getSectorName:(int)position {
    NSString *res = @"";
    switch (position) {
        case 0:
            res = @"Circles";
            break;
            
        case 1:
            res = @"Flower";
            break;
            
        case 2:
            res = @"Monster";
            break;
            
        case 3:
            res = @"Person";
            break;
            
        case 4:
            res = @"Smile";
            break;
            
        case 5:
            res = @"Sun";
            break;
            
        case 6:
            res = @"Swirl";
            break;
            
        case 7:
            res = @"3 circles";
            break;
            
        case 8:
            res = @"Triangle";
            break;
            
        default:
            break;
    }
    return res;
}
@end
