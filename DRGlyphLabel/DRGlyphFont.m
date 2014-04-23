//
//  DRGlyphFont.m
//  DRGlyphLabel
//
//  Created by Dariusz Rybicki on 23.04.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "DRGlyphFont.h"
#import "DRGlyphFontChar.h"

@interface DRGlyphFont ()

@property (nonatomic, strong) NSString *fontFilename;
@property (nonatomic, readonly) NSString *fontFilePath;
@property (nonatomic, strong) NSString *face;
@property (nonatomic, assign) CGFloat size;
@property (nonatomic, assign) BOOL bold;
@property (nonatomic, assign) BOOL italic;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, strong) NSDictionary *pages;
@property (nonatomic, strong) NSDictionary *characters;
@property (nonatomic, strong) NSDictionary *kernings;

@end

@implementation DRGlyphFont

- (id)initWithName:(NSString *)name
{
	if (self = [super init]) {
		_fontFilename = name;
        [self loadDataFromFontFile];
	}
	return self;
}

- (DRGlyphFontChar *)character:(unichar)charId
{
	return self.characters[[NSString stringWithFormat:@"%i", (int)charId]];
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

#pragma mark - Parser methods

- (void)loadDataFromFontFile
{
    self.face = nil;
    self.size = 0.f;
    self.bold = NO;
    self.italic = NO;
    self.lineHeight = 0.f;
    self.pages = @{};
    self.characters = @{};
    self.kernings = @{};
    
    NSError *error = nil;
    NSString *fontDescription = [NSString stringWithContentsOfFile:self.fontFilePath
                                                          encoding:NSUTF8StringEncoding
                                                             error:&error];
    if (error) {
        NSLog(@"ERROR LOADING FONT %@: %@", self.fontFilename, error.localizedDescription);
        return;
    }
    
    NSArray *lines = [fontDescription componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    [lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
        // font info
        if ([line hasPrefix:@"info "]) {
            self.face = [self valueOfProperty:@"face" fromLine:line];
            self.size = [[self valueOfProperty:@"size" fromLine:line] floatValue];
            self.bold = [[self valueOfProperty:@"bold" fromLine:line] boolValue];
            self.italic = [[self valueOfProperty:@"italic" fromLine:line] boolValue];
        }
        // font commons
        else if ([line hasPrefix:@"common "]) {
            self.lineHeight = [[self valueOfProperty:@"lineHeight" fromLine:line] floatValue];
        }
        // page description
        else if ([line hasPrefix:@"page "]) {
            NSString *pageId = [self valueOfProperty:@"id" fromLine:line];
            NSString *pageFile = [self valueOfProperty:@"file" fromLine:line];
            if (pageId && pageFile) {
                NSMutableDictionary *pages = [self.pages mutableCopy];
                pages[pageId] = pageFile;
                self.pages = [NSDictionary dictionaryWithDictionary:pages];
            }
        }
        // character description
        else if ([line hasPrefix:@"char "]) {
            DRGlyphFontChar *character = [self characterFromString:line];
            if (character) {
                NSMutableDictionary *characters = [self.characters mutableCopy];
                characters[character.charIdString] = character;
                self.characters = [NSDictionary dictionaryWithDictionary:characters];
            }
        }
        // character kernings
        else if ([line hasPrefix:@"kerning "]) {
            NSString *firstCharIdString = [self valueOfProperty:@"first" fromLine:line];
            NSString *secondCharIdString = [self valueOfProperty:@"second" fromLine:line];
            CGFloat value = [[self valueOfProperty:@"amount" fromLine:line] floatValue];
            if ([firstCharIdString isKindOfClass:[NSString class]]
                && ![firstCharIdString isEqualToString:@""]
                && secondCharIdString
                && ![secondCharIdString isEqualToString:@""]
                && value) {
                NSMutableDictionary *kernings = [self.kernings mutableCopy];
                kernings[[NSString stringWithFormat:@"%@/%@", firstCharIdString, secondCharIdString]] = @(value);
                self.kernings = [NSDictionary dictionaryWithDictionary:kernings];
            }
        }
    }];
}

- (DRGlyphFontChar *)characterFromString:(NSString *)string
{
    DRGlyphFontChar *character = nil;
    
    if ([string hasPrefix:@"char "]) {
        NSString *charIdString = [self valueOfProperty:@"id" fromLine:string];
        if (charIdString) {
            NSString *page = [self valueOfProperty:@"page" fromLine:string];
            NSString *filename = self.pages[page];
            if (filename) {
                character = [[DRGlyphFontChar alloc] init];
                character.charIdString = charIdString;
                character.filename = filename;
                character.width = [[self valueOfProperty:@"width" fromLine:string] floatValue];
                character.height = [[self valueOfProperty:@"height" fromLine:string] floatValue];
                character.posX = [[self valueOfProperty:@"x" fromLine:string] floatValue];
                character.posY = [[self valueOfProperty:@"y" fromLine:string] floatValue];
                character.offsetX = [[self valueOfProperty:@"xoffset" fromLine:string] floatValue];
                character.offsetY = [[self valueOfProperty:@"yoffset" fromLine:string] floatValue];
                character.advanceX = [[self valueOfProperty:@"xadvance" fromLine:string] floatValue];
            }
        }
    }
    
    return character;
}

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
