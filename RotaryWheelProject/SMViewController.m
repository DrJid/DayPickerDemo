//
//  SMViewController.m
//  RotaryWheelProject
//
//  Created by Maijid Moujaled on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SMViewController.h"
#import "SMRotaryWheel.h"
#import <QuartzCore/QuartzCore.h>

@interface SMViewController ()

@end

@implementation SMViewController
@synthesize sectorLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sectorLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 350, 120, 30)];
	sectorLabel.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:sectorLabel];
    
	// Do any additional setup after loading the view, typically from a nib.
    SMRotaryWheel *wheel = [[SMRotaryWheel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)  
                                                    andDelegate:self 
                                                   withSections:8];
    wheel.center = CGPointMake(160, 240);
    // 4 - Add wheel to view
    [self.view addSubview:wheel];
    
//    
//    UILabel *im = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
//    im.text = @"Queenster is sexy!";
//    im.layer.position = CGPointMake(100, 350);
//    im.layer.anchorPoint = CGPointMake(1, 1);
////    im.transform = CGAffineTransformMakeRotation(1);
//    [im sizeToFit];
//    
//    
//    [UIView animateWithDuration:1 animations:^{
//        im.transform = CGAffineTransformMakeRotation(M_PI);
//    }completion:^(BOOL finished) {
//        [UIView animateWithDuration:1 animations:^{
//            im.transform = CGAffineTransformMakeRotation(30);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:1 animations:^{
//                [UIView animateWithDuration:1 animations:^{
//                    im.transform = CGAffineTransformMakeRotation(10);
//                }];
//            } completion:nil];
//        }];
//    }];
//    
//    [self.view addSubview:im];

    
    [self.view addSubview:wheel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)wheelDidChangeValue:(NSString *)newValue
{
    self.sectorLabel.text = newValue;
}

@end
