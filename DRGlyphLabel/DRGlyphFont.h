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

@property (nonatomic, readonly) CGFloat lineHeight;

- (id)initWithName:(NSString *)name;
- (DRGlyphFontChar *)character:(unichar)charId;

@end
