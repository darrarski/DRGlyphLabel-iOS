//
//  DRGlyphFont.h
//  DRGlyphLabel
//
//  Created by Dariusz Rybicki on 23.04.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const DRGlyphFontCharacterFile;
extern NSString * const DRGlyphFontCharacterPositionX;
extern NSString * const DRGlyphFontCharacterPositionY;
extern NSString * const DRGlyphFontCharacterWidth;
extern NSString * const DRGlyphFontCharacterHeight;
extern NSString * const DRGlyphFontCharacterOffsetX;
extern NSString * const DRGlyphFontCharacterOffsetY;
extern NSString * const DRGlyphFontCharacterAdvanceX;

@interface DRGlyphFont : NSObject

@property (nonatomic, readonly) NSInteger lineHeight;
@property (nonatomic, readonly) NSDictionary *characters;

- (id)initWithName:(NSString *)name;
- (UIImage *)imageForCharacterWithId:(NSString *)charId;

@end
