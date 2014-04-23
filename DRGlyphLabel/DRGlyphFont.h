//
//  DRGlyphFont.h
//  DRGlyphLabel
//
//  Created by Dariusz Rybicki on 23.04.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRGlyphFontChar;

@interface DRGlyphFont : NSObject

@property (nonatomic, readonly) NSString *face;
@property (nonatomic, readonly) CGFloat size;
@property (nonatomic, readonly, getter = isBold) BOOL bold;
@property (nonatomic, readonly, getter = isItalic) BOOL italic;
@property (nonatomic, readonly) CGFloat lineHeight;


- (id)initWithName:(NSString *)name;
- (DRGlyphFontChar *)character:(unichar)charId;
- (CGFloat)kerningBetween:(unichar)firstCharId and:(unichar)secondCharId;

@end
