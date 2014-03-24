#import "Structle.h"


@implementation Structle

+ (instancetype)objectWithData:(NSData *)data
{
	return nil;
}

- (NSData *)dataValue
{
	return nil;
}

+ (NSUInteger)dataSize
{
	return 0;
}

- (NSArray *)propertyKeysToBeAddedToDescription
{
	return @[];
}

- (NSString *)description
{
	NSMutableString *string = [NSMutableString stringWithFormat:@"<%@ %p (", NSStringFromClass(self.class), self];
	for (NSString *aKey in self.propertyKeysToBeAddedToDescription)
	{
		id value = [self valueForKey:aKey];
		if (value)
		{
			[string appendFormat:@"%@ = %@", aKey, value];
			if (aKey != self.propertyKeysToBeAddedToDescription.lastObject) [string appendString:@", "];
		}
	}
	[string appendString:@")>"];
	return string;
}

- (NSString *)propertiesAsString
{
	NSMutableString *string = [NSMutableString new];
	for (NSString *aKey in self.propertyKeysToBeAddedToDescription)
	{
		id value = [self valueForKey:aKey];
		if (value)
		{
			[string appendFormat:@"%@ = %@", aKey, value];
			if (aKey != self.propertyKeysToBeAddedToDescription.lastObject) [string appendString:@", "];
		}
	}
	return string;
}

- (id)copyWithZone:(NSZone *)zone
{
	Structle *newObject = [[self class] new];
	for (NSString *aPropertyKey in self.propertyKeysToBeAddedToDescription)
	{
		NSObject *value = [self valueForKey:aPropertyKey];
		if (value)
		{
			[newObject setValue:value.copy forKey:aPropertyKey];
		}
	}
	return newObject;
}

@end
