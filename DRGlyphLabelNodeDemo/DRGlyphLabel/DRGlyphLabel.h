//
//  DRGlyphLabel.h
//  DRGlyphLabel
//
//  Created by Dariusz Rybicki on 23.04.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRGlyphFont;

/**
 *  DRGlyphLabel - text label with bitmap font
 */
@interface DRGlyphLabel : UIView

/**
 *  Font used to render text
 */
@property (nonatomic, strong) DRGlyphFont *font;

/**
 *  Displayed text
 */
@property (nonatomic, strong) NSString *text;

/**
 *  Set size
 */
@property (nonatomic) CGFloat fontSize;

@end
