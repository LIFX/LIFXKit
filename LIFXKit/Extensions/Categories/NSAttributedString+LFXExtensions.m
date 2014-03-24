//
//  NSAttributedString+LFXExtensions.m
//  LIFX
//
//  Created by Nick Forge on 13/10/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "NSAttributedString+LFXExtensions.h"

@implementation NSAttributedString (LFXExtensions)

+ (instancetype)lfx_attributedStringWithString:(NSString *)string attributes:(NSDictionary *)attributes
{
	return [[self alloc] initWithString:string attributes:attributes];
}

@end

@implementation NSMutableAttributedString (LFXExtensions)

- (void)lfx_appendString:(NSString *)string attributes:(NSDictionary *)attributes
{
	[self appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:attributes]];
}

- (void)lfx_appendString:(NSString *)string
{
	[self appendAttributedString:[[NSAttributedString alloc] initWithString:string]];
}

@end
