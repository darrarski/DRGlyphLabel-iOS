//
//  DRGlyphFontChar.h
//  DRGlyphLabel
//
//  Created by Dariusz Rybicki on 23.04.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  DRGlyphFontChar - bitmap font character representation
 */
@interface DRGlyphFontChar : NSObject

/**
 *  String representation of character's unichar value
 */
@property (nonatomic, strong) NSString *charIdString;

/**
 *  Name of file that contains character bitmap
 */
@property (nonatomic, strong) NSString *filename;

/**
 *  Character width
 */
@property (nonatomic, assign) CGFloat width;

/**
 *  Character height
 */
@property (nonatomic, assign) CGFloat height;

/**
 *  Character x-position in bitmap file
 */
@property (nonatomic, assign) CGFloat posX;

/**
 *  Character y-position in bitmap file
 */
@property (nonatomic, assign) CGFloat posY;

/**
 *  Character x-offset
 */
@property (nonatomic, assign) CGFloat offsetX;

/**
 *  Character y-offset
 */
@property (nonatomic, assign) CGFloat offsetY;

/**
 *  Character x-advance value
 */
@property (nonatomic, assign) CGFloat advanceX;

/**
 *  Image representation of character
 */
@property (nonatomic, readonly) UIImage *image;

@end
