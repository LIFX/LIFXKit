//
//  NSAttributedString+LFXExtensions.h
//  LIFX
//
//  Created by Nick Forge on 13/10/2013.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (LFXExtensions)

+ (instancetype)lfx_attributedStringWithString:(NSString *)string attributes:(NSDictionary *)attributes;

@end

@interface NSMutableAttributedString (LFXExtensions)

- (void)lfx_appendString:(NSString *)string attributes:(NSDictionary *)attributes;
- (void)lfx_appendString:(NSString *)string;

@end
