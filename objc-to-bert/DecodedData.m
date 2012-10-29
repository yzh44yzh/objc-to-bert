#import "DecodedData.h"

@implementation DecodedData

@synthesize data;
@synthesize binLength;

- (id)init {
    self = [super init];
    if (self) {
        data = [NSMutableArray array];
    }
    return self;
}

- (void)addChar:(unsigned char)val {
    [data addObject:[NSNumber numberWithChar:val]];
}

- (unsigned char)getChar:(NSUInteger)index {
    return (unsigned char) [[data objectAtIndex:index] charValue];
}

- (void)addLong:(long)val {
    [data addObject:[NSNumber numberWithLong:val]];
}

- (long)getLong:(NSUInteger)index {
    return [[data objectAtIndex:index] longValue];
}

- (void)addDouble:(double)val {
    [data addObject:[NSNumber numberWithDouble:val]];
}

- (double)getDouble:(NSUInteger)index {
    return [[data objectAtIndex:index] doubleValue];
}

- (void)addString:(NSString *)val {
    [data addObject:val];
}

- (NSString *)getString:(NSUInteger)index {
    return [data objectAtIndex:index];
}

- (void)addBinary:(NSData *)val {
    [data addObject:val];
}

- (NSData *)getBinary:(NSUInteger)index {
    return [data objectAtIndex:index];
}

- (void)addDecodedData:(DecodedData *)val {
    [data addObject:val];
}

- (DecodedData *)getDecodedData:(NSUInteger)index {
    return [data objectAtIndex:index];
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

@end
