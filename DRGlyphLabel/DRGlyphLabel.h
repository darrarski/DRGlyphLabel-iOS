//
//  DRGlyphLabel.h
//  DRGlyphLabel
//
//  Created by Dariusz Rybicki on 23.04.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRGlyphFont.h"

@interface DRGlyphLabel : UIView

@property (nonatomic, strong) DRGlyphFont *font;
@property (nonatomic, strong) NSString *text;

@end
