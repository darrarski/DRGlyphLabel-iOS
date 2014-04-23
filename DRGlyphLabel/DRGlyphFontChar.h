//
//  DRGlyphFontChar.h
//  DRGlyphLabel
//
//  Created by Dariusz Rybicki on 23.04.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRGlyphFontChar : NSObject

@property (nonatomic, strong) NSString *charIdString;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat posX;
@property (nonatomic, assign) CGFloat posY;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) CGFloat advanceX;

@property (nonatomic, readonly) UIImage *image;

@end
