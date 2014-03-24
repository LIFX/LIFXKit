
@interface Structle : NSObject <NSCopying>

+ (instancetype)objectWithData:(NSData *)data;
- (NSData *)dataValue;
+ (NSUInteger)dataSize;
- (NSArray *)propertyKeysToBeAddedToDescription;
- (NSString *)propertiesAsString;

@end

