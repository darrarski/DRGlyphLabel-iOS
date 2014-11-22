//
//  DRGlyphFontChar.m
//  DRGlyphLabel
//
//  Created by Dariusz Rybicki on 23.04.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "DRGlyphFontChar.h"

@interface DRGlyphFontChar ()

@property (nonatomic, readonly) CGRect rect;

@end

@implementation DRGlyphFontChar

- (UIImage *)image
{
	UIImage *pageImage = [UIImage imageNamed:self.filename];
    CGImageRef pageImageRef = CGImageCreateWithImageInRect([pageImage CGImage], self.rect);
    UIImage *characterImage = [UIImage imageWithCGImage:pageImageRef
												  scale:pageImage.scale
											orientation:pageImage.imageOrientation];
    CGImageRelease(pageImageRef);
    return characterImage;
}

- (SKTexture *)texture
{
    UIImage *pageImage = [UIImage imageNamed:self.filename];
    CGImageRef pageImageRef = CGImageCreateWithImageInRect([pageImage CGImage], self.rect);
    UIImage *characterImage = [UIImage imageWithCGImage:pageImageRef
                                                  scale:pageImage.scale
                                            orientation:pageImage.imageOrientation];
    CGImageRelease(pageImageRef);
    SKTexture *characterTexture = [SKTexture textureWithImage:characterImage];
    
    return characterTexture;
}

- (CGRect)rect
{
	return CGRectMake(self.posX,
					  self.posY,
					  self.width,
					  self.height);
}

@end
