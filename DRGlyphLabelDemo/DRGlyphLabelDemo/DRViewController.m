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

@property (nonatomic, strong) DRGlyphLabel *label;

@end

@implementation DRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.label = [[DRGlyphLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	self.label.font = [[DRGlyphFont alloc] initWithName:@"font1"];
	self.label.text = @"1234";
	self.label.backgroundColor = [UIColor colorWithRed:0.683 green:0.902 blue:0.722 alpha:1.000];
	
	[self.view addSubview:self.label];
}

@end
