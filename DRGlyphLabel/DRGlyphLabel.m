//
//  DRGlyphLabel.m
//  DRGlyphLabel
//
//  Created by Dariusz Rybicki on 23.04.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "DRGlyphLabel.h"
#import "DRGlyphFont.h"
#import "DRGlyphFontChar.h"

@interface DRGlyphLabel ()

@property (nonatomic, assign) CGSize textSize;

@end

@implementation DRGlyphLabel

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
	
	[self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
		[subview removeFromSuperview];
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
			
			UIImageView *letterImageView = [[UIImageView alloc] initWithImage:character.image];
			letterImageView.frame = CGRectMake((pos.x + character.offsetX) / scaleFactor,
											   (pos.y + character.offsetY) / scaleFactor,
											   character.width / scaleFactor,
											   character.height / scaleFactor);
			[self addSubview:letterImageView];
            
            pos.x += character.advanceX + [self.font kerningBetween:lastCharId and:charId];
            
            if (size.width < pos.x) {
                size.width = pos.x / scaleFactor;
			}
        }
        lastCharId = charId;
    }
	
	self.textSize = size;
}

- (void)sizeToFit
{
	CGRect frame = self.frame;
	frame.size = self.textSize;
	self.frame = frame;
}

+ (BOOL)isNewLineChar:(unichar)charId
{
	return [[[NSString stringWithFormat:@"%c", charId] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]] isEqualToString:@""];
}

@end
