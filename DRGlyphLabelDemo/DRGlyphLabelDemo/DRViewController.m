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
	[self.view addSubview:self.label];
	[self updateCounterLabel];
	
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

@end
