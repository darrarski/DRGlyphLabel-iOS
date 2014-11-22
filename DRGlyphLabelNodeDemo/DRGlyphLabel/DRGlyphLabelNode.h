//
//  DRGlyphLabelNode.h
//  foggyhorse
//
//  Created by Alfred on 14/11/23.
//  Copyright (c) 2014年 Mogo HackSpace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@class DRGlyphFont;

/**
 *  DRGlyphLabel - text label with bitmap font
 */
@interface DRGlyphLabelNode : SKSpriteNode

/**
 *  Font used to render text
 */
@property (nonatomic, strong) DRGlyphFont *font;

/**
 *  Displayed text
 */
@property (nonatomic, strong) NSString *text;

/**
 *  Set size
 */
@property (nonatomic) CGFloat fontSize;

@end

