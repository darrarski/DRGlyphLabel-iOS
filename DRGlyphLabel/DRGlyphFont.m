//
//  DRGlyphFont.m
//  DRGlyphLabel
//
//  Created by Dariusz Rybicki on 23.04.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "DRGlyphFont.h"

NSString * const DRGlyphFontCharacterFile = @"DRGlyphFontCharacterFile";
NSString * const DRGlyphFontCharacterPositionX = @"DRGlyphFontCharacterPositionX";
NSString * const DRGlyphFontCharacterPositionY = @"DRGlyphFontCharacterPositionY";
NSString * const DRGlyphFontCharacterWidth = @"DRGlyphFontCharacterWidth";
NSString * const DRGlyphFontCharacterHeight = @"DRGlyphFontCharacterHeight";
NSString * const DRGlyphFontCharacterOffsetX = @"DRGlyphFontCharacterOffsetX";
NSString * const DRGlyphFontCharacterOffsetY = @"DRGlyphFontCharacterOffsetY";
NSString * const DRGlyphFontCharacterAdvanceX = @"DRGlyphFontCharacterAdvanceX";

@interface DRGlyphFont ()

@property (nonatomic, strong) NSString *fontFilename;
@property (nonatomic, readonly) NSString *fontFilePath;
@property (nonatomic, strong) NSString *fontDescription;
@property (nonatomic, strong) NSDictionary *pages;
@property (nonatomic, strong) NSDictionary *characters;
@property (nonatomic, assign) NSInteger lineHeight;

@end

@implementation DRGlyphFont

- (id)initWithName:(NSString *)name
{
	if (self = [super init]) {
		_fontFilename = name;
	}
	return self;
}

- (UIImage *)imageForCharacterWithId:(NSString *)charId
{
	NSDictionary *character = self.characters[charId];
	
	if (!character) {
		return nil;
	}
	
	UIImage *pageImage = [UIImage imageNamed:character[DRGlyphFontCharacterFile]];
	CGRect rect = CGRectMake([character[DRGlyphFontCharacterPositionX] integerValue],
							 [character[DRGlyphFontCharacterPositionY] integerValue],
							 [character[DRGlyphFontCharacterWidth] integerValue],
							 [character[DRGlyphFontCharacterHeight] integerValue]);
    CGImageRef pageImageRef = CGImageCreateWithImageInRect([pageImage CGImage], rect);
    UIImage *characterImage = [UIImage imageWithCGImage:pageImageRef
												  scale:pageImage.scale
											orientation:pageImage.imageOrientation];
    CGImageRelease(pageImageRef);
    return characterImage;
}

#pragma mark - Helper methods

+ (BOOL)isRunningOnRetinaDevice
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0));
}

#pragma mark - Getters and setters

- (NSString *)fontFilePath
{
	NSString *filename = self.fontFilename;
	if ([[self class] isRunningOnRetinaDevice]) {
		filename = [filename stringByAppendingString:@"@2x"];
	}
	return [[NSBundle mainBundle] pathForResource:filename ofType:@"fnt"];
}

- (NSString *)fontDescription
{
	if (!_fontDescription) {
		NSError *error = nil;
		_fontDescription = [NSString stringWithContentsOfFile:self.fontFilePath
													 encoding:NSUTF8StringEncoding
														error:&error];
		if (error) {
			NSLog(@"ERROR: %@", error);
		}
	}
	return _fontDescription;
}

- (NSDictionary *)pages
{
	if (!_pages) {
		NSMutableDictionary *pages = [NSMutableDictionary new];
		NSArray *lines = [self.fontDescription componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		[lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
			if ([line hasPrefix:@"page "]) {
				NSString *pageId = [self valueOfProperty:@"id" fromLine:line];
				NSString *pageFile = [self valueOfProperty:@"file" fromLine:line];
				if (pageId && pageFile) {
					pages[pageId] = pageFile;
				}
			}
		}];
		_pages = [NSDictionary dictionaryWithDictionary:pages];
	}
	return _pages;
}

- (NSDictionary *)characters
{
	if (!_characters) {
		NSMutableDictionary *characters = [NSMutableDictionary new];
		NSArray *lines = [self.fontDescription componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		[lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
			if ([line hasPrefix:@"char "]) {
				NSString *charId = [self valueOfProperty:@"id" fromLine:line];
				if (charId) {
					NSString *page = [self valueOfProperty:@"page" fromLine:line];
					NSString *file = self.pages[page];
					if (file) {
						characters[charId] = @{ DRGlyphFontCharacterFile: file,
												DRGlyphFontCharacterPositionX: [self valueOfProperty:@"x" fromLine:line] ?: [NSNull null],
												DRGlyphFontCharacterPositionY: [self valueOfProperty:@"y" fromLine:line] ?: [NSNull null],
												DRGlyphFontCharacterWidth: [self valueOfProperty:@"width" fromLine:line] ?: [NSNull null],
												DRGlyphFontCharacterHeight: [self valueOfProperty:@"height" fromLine:line] ?: [NSNull null],
												DRGlyphFontCharacterOffsetX: [self valueOfProperty:@"xoffset" fromLine:line] ?: [NSNull null],
												DRGlyphFontCharacterOffsetY: [self valueOfProperty:@"yoffset" fromLine:line] ?: [NSNull null],
												DRGlyphFontCharacterAdvanceX: [self valueOfProperty:@"xadvance" fromLine:line] ?: [NSNull null],
												};
					}
				}
			}
		}];
		_characters = [NSDictionary dictionaryWithDictionary:characters];
	}
	return _characters;
}

- (NSInteger)lineHeight
{
	if (!_lineHeight) {
		NSArray *lines = [self.fontDescription componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		[lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
			if ([line hasPrefix:@"common "]) {
				_lineHeight = [[self valueOfProperty:@"lineHeight" fromLine:line] integerValue];
				*stop = YES;
			}
		}];
	}
	return _lineHeight;
}

#pragma mark - Parser methods

- (NSString *)valueOfProperty:(NSString *)key fromLine:(NSString *)line
{
	NSRange propertyKeyRange = [line rangeOfString:[NSString stringWithFormat:@" %@=", key]
										   options:NSCaseInsensitiveSearch];

	if (propertyKeyRange.location == NSNotFound) {
		return nil;
	}
	
	BOOL valueEscaped = NO;
	if ([[line substringWithRange:NSMakeRange(propertyKeyRange.location + propertyKeyRange.length, 1)] isEqualToString:@"\""]) {
		propertyKeyRange.length += 1;
		valueEscaped = YES;
	}
	
	NSRange propertyDelimiterRange = [line rangeOfString:valueEscaped ? @"\" " : @" "
												 options:NSCaseInsensitiveSearch
												   range:NSMakeRange(propertyKeyRange.location + propertyKeyRange.length,
																	 line.length - (propertyKeyRange.location + propertyKeyRange.length))];
	NSUInteger propertyValueEndPosition;
	if (propertyDelimiterRange.location != NSNotFound) {
		propertyValueEndPosition = propertyDelimiterRange.location;
	}
	else {
		propertyValueEndPosition = valueEscaped ? line.length - 1 : line.length;
	}
	
	NSRange propertyValueRange = NSMakeRange(propertyKeyRange.location + propertyKeyRange.length,
											 propertyValueEndPosition - (propertyKeyRange.location + propertyKeyRange.length));
	NSString *value = [line substringWithRange:propertyValueRange];
	return value;
}

@end
