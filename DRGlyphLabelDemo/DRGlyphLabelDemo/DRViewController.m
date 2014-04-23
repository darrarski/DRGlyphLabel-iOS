//
//  DRViewController.m
//  DRGlyphLabelDemo
//
//  Created by Dariusz Rybicki on 23.04.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "DRViewController.h"
#import "DRGlyphFont.h"
#import "DRGlyphLabel.h"
#import "CALayer+MBAnimationPersistence.h"

@interface DRViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger counter;
@property (nonatomic, strong) DRGlyphLabel *label;

@end

@implementation DRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.label = [[DRGlyphLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	self.label.font = [[DRGlyphFont alloc] initWithName:@"font1"];
	self.label.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.000 alpha:0.300];
	[self.view addSubview:self.label];
	[self updateCounterLabel];
    [self addSpinAnimationToView:self.label duration:.5f rotations:1.f repeat:HUGE_VALF];
	
	self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                  target:self
                                                selector:@selector(timerTick)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)timerTick
{
	self.counter++;
	[self updateCounterLabel];
}

- (void)updateCounterLabel
{
	self.label.text = [NSString stringWithFormat:@"%d", self.counter];
	[self.label sizeToFit];
	self.label.center = self.view.center;
}

#pragma mark - Animations

NSString * const DRSpinAnimationKey = @"DRSpinAnimationKey";

- (void)addSpinAnimationToView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:DRSpinAnimationKey];
    view.layer.MB_persistentAnimationKeys = @[ DRSpinAnimationKey ];
}

- (void)removeSpinAnimationFromView:(UIView *)view
{
    view.layer.MB_persistentAnimationKeys = nil;
    [view.layer removeAnimationForKey:DRSpinAnimationKey];
}

@end
