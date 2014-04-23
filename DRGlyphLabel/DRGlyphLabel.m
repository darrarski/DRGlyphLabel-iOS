//
//  DRGlyphLabel.m
//  DRGlyphLabel
//
//  Created by Dariusz Rybicki on 23.04.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "DRGlyphLabel.h"

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
	CGSize size = CGSizeZero;
    CGPoint pos = CGPointZero;
    CGFloat scaleFactor = [UIScreen mainScreen].scale;
	
	[self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
		[subview removeFromSuperview];
	}];
    
    if (self.text.length > 0) {
        size.height += self.font.lineHeight / scaleFactor;
	}
    
    for (NSUInteger i = 0; i < self.text.length; i++) {
        unichar c = [self.text characterAtIndex:i];
        if (c == '\n') {
            pos.y += self.font.lineHeight;
            size.height += self.font.lineHeight / scaleFactor;
            pos.x = 0;
        } else {
			NSString *charId = [NSString stringWithFormat:@"%i", (int)c];
			NSDictionary *character = self.font.characters[charId];
			UIImageView *letterImageView = [[UIImageView alloc] init];
			letterImageView.image = [self.font imageForCharacterWithId:charId];
			letterImageView.frame = CGRectMake(pos.x / scaleFactor,
											   pos.y / scaleFactor,
											   letterImageView.image.size.width / scaleFactor,
											   letterImageView.image.size.height / scaleFactor);
			[self addSubview:letterImageView];
			
            pos.x += [character[DRGlyphFontCharacterAdvanceX] integerValue];
            
            if (size.width < pos.x) {
                size.width = pos.x / scaleFactor;
			}
        }
    }
	
	self.textSize = size;
}

- (void)sizeToFit
{
	CGRect frame = self.frame;
	frame.size = self.textSize;
	self.frame = frame;
}

@end
