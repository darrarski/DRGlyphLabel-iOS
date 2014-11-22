//
//  DRGlyphFont.h
//  DRGlyphLabel
//
//  Created by Dariusz Rybicki on 23.04.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@class DRGlyphFontChar;

/**
 *  DRGlyphFont - bitmap font representation
 */
@interface DRGlyphFont : NSObject

/**
 *  Font face name
 */
@property (nonatomic, readonly) NSString *face;

/**
 *  Font size (from font description file)
 */
@property (nonatomic, readonly) CGFloat size;

/**
 *  Bold property (from font description file)
 */
@property (nonatomic, readonly, getter = isBold) BOOL bold;

/**
 *  Italic property (from font description file)
 */
@property (nonatomic, readonly, getter = isItalic) BOOL italic;

/**
 *  Line height (from font description file)
 */
@property (nonatomic, readonly) CGFloat lineHeight;

/**
 *  Init font with given name
 *
 *  @param name font name (should be same as font description filename, without @2x suffix and extension)
 *
 *  @return font object
 */
- (id)initWithName:(NSString *)name;

/**
 *  Returns font character object
 *
 *  @param charId character unichar value
 *
 *  @return font character object
 */
- (DRGlyphFontChar *)character:(unichar)charId;

/**
 *  Value for character kerning (from font description file)
 *
 *  @param firstCharId  first character unichar value
 *  @param secondCharId second character unichar value
 *
 *  @return kerning value
 */
- (CGFloat)kerningBetween:(unichar)firstCharId and:(unichar)secondCharId;

@end
