//
//  DRViewController.m
//  DRGlyphLabelDemo
//
//  Created by Dariusz Rybicki on 23.04.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "DRViewController.h"
#import "DRGlyphFont.h"

@interface DRViewController ()

@property (nonatomic, strong) DRGlyphFont *font;

@end

@implementation DRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.font = [[DRGlyphFont alloc] initWithName:@"font1"];
}

@end
