#import "DecodedData.h"

@implementation DecodedData {
    NSMutableArray *_data;
}

@synthesize data = _data;

- (id)init {
    self = [super init];
    if (self) {
        _data = [NSMutableArray array];
        self.binLength = 0;
    }
    return self;
}

- (void)addChar:(unsigned char)val {
    [_data addObject:[NSNumber numberWithUnsignedChar:val]];
}

- (unsigned char)getChar:(NSUInteger)index {
    return (unsigned char) [[_data objectAtIndex:index] charValue];
}

- (void)addLong:(long)val {
    [_data addObject:[NSNumber numberWithLong:val]];
}

- (long)getLong:(NSUInteger)index {
    return [[_data objectAtIndex:index] longValue];
}

- (void)addDouble:(double)val {
    [_data addObject:[NSNumber numberWithDouble:val]];
}

- (double)getDouble:(NSUInteger)index {
    return [[_data objectAtIndex:index] doubleValue];
}

- (void)addString:(NSString *)val {
    [_data addObject:val];
}

- (NSString *)getString:(NSUInteger)index {
    return [_data objectAtIndex:index];
}

- (void)addBinary:(NSData *)val {
    [_data addObject:val];
}

- (NSData *)getBinary:(NSUInteger)index {
    return [_data objectAtIndex:index];
}

- (void)addDecodedData:(DecodedData *)val {
    [_data addObject:val];
}

- (DecodedData *)getDecodedData:(NSUInteger)index {
    return [_data objectAtIndex:index];
}

- (BOOL)isEqual:(id)object {
    if(object == nil) return false;
    if(object == self) return true;
    if([object isKindOfClass:[self class]]) {
        DecodedData *other = (DecodedData *) object;
        if(other.binLength != self.binLength) return false;
        return [other.data isEqual:self.data];
    }
    return false;
}

- (id)copyWithZone:(NSZone *)zone {
    DecodedData *newItem = [[[self class] allocWithZone:zone] init];
    newItem.binLength = self.binLength;
    newItem.data = self.data;
    return newItem;
}


@end
