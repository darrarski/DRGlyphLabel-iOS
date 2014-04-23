//
//  DRGlyphLabel.m
//  DRGlyphLabel
//
//  Created by Dariusz Rybicki on 23.04.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "DRGlyphLabel.h"

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
    CGFloat scaleFactor = [UIScreen mainScreen].scale;
	
//    [self removeAllChildren];
    
    if (self.text.length > 0) {
        size.height += self.font.lineHeight / scaleFactor;
	}
    
    for (NSUInteger i = 0; i < self.text.length; i++) {
        unichar c = [self.text characterAtIndex:i];
        if (c == '\n') {
            pos.y -= self.font.lineHeight / scaleFactor;
            size.height += self.font.lineHeight / scaleFactor;
            pos.x = 0;
        } else {
			NSString *charId = [NSString stringWithFormat:@"%i", (int)c];
			NSDictionary *character = self.font.characters[charId];
			UIImageView *letterImageView = [[UIImageView alloc] init];
			letterImageView.image = [self.font imageForCharacterWithId:charId];
			letterImageView.frame = CGRectMake(pos.x,
											   pos.y,
											   letterImageView.image.size.width,
											   letterImageView.image.size.height);
			[self addSubview:letterImageView];
			
			NSLog(@"LETTER: %c FRAME: %@ IMAGE: %@", c, NSStringFromCGRect(letterImageView.frame), letterImageView.image);
			
            pos.x += [character[DRGlyphFontCharacterAdvanceX] integerValue] / scaleFactor;
            
            if (size.width < pos.x) {
                size.width = pos.x;
			}
        }
        lastCharId = c;
    }
	
//    self.totalSize = size;
}

@end
