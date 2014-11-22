//
//  DRGlyphLabelNode.m
//  foggyhorse
//
//  Created by Alfred Liu on 14/11/23.
//  Copyright (c) 2014年 Mogo HackSpace. All rights reserved.
//

#import "DRGlyphLabelNode.h"
#import "DRGlyphFont.h"
#import "DRGlyphFontChar.h"

@interface DRGlyphLabelNode ()

@property (nonatomic, assign) CGSize textSize;

@end

@implementation DRGlyphLabelNode

- (void)setFont:(DRGlyphFont *)font
{
    if ([_font isEqual:font]) {
        return;
    }
    
    _font = font;
    
    [self renderText];
}

- (void)setText:(NSString *)text
{
    if ([_text isEqualToString:text]) {
        return;
    }
    
    _text = text;
    
    [self renderText];
}

- (void)renderText
{
    unichar lastCharId = 0;
    CGSize size = CGSizeZero;
    CGPoint pos = CGPointZero;
    
    if (!_fontSize) {
        _fontSize = 2.5;
    }
    
    CGFloat scaleFactor = _fontSize;
    
    [self.children enumerateObjectsUsingBlock:^(SKSpriteNode *subnode, NSUInteger idx, BOOL *stop) {
        [subnode removeFromParent];
    }];
    
    if (self.text.length > 0) {
        size.height += self.font.lineHeight / scaleFactor;
    }
    
    for (NSUInteger i = 0; i < self.text.length; i++) {
        unichar charId = [self.text characterAtIndex:i];
        if ([[self class] isNewLineChar:charId]) {
            pos.y += self.font.lineHeight;
            size.height += self.font.lineHeight / scaleFactor;
            pos.x = 0;
        } else {
            DRGlyphFontChar *character = [self.font character:charId];
            
            SKSpriteNode *letterImageNode = [[SKSpriteNode alloc]initWithTexture:character.texture];
            letterImageNode.position = CGPointMake((pos.x + character.offsetX) / scaleFactor,
                                               (pos.y + character.offsetY) / scaleFactor);
            letterImageNode.size = CGSizeMake(character.width / scaleFactor,
                                              character.height / scaleFactor);
            [self addChild:letterImageNode];
            
            pos.x += character.advanceX + [self.font kerningBetween:lastCharId and:charId];
            
            if (size.width < pos.x) {
                size.width = pos.x / scaleFactor;
            }
        }
        lastCharId = charId;
    }
    
    self.textSize = size;
}

+ (BOOL)isNewLineChar:(unichar)charId
{
    return [[[NSString stringWithFormat:@"%c", charId] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]] isEqualToString:@""];
}

@end

