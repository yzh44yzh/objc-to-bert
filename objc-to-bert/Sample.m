#import "Sample.h"


@implementation Sample

@synthesize id;
@synthesize name;
@synthesize age;

+ (Sample *)createWithData:(NSData *)data {
    Sample *item = [[Sample alloc] init];
    if(item) [item decode:data];
    return item;
}

+ (Sample *)createWithDecodedData:(DecodedData *)data {
    Sample *item = [[Sample alloc] init];
    if(item) [item initWithDecodedData:data];
    return item;
}

+ (Sample *)createWithId:(long)id andName:(NSString *)name andAge:(char)age {
    Sample *item = [[Sample alloc] init];
    if(item) {
        item.id = id;
        item.name = name;
        item.age = age;
    }
    return item;
}

- (NSData *)encode {
    return otb_enc_tuple([NSArray arrayWithObjects:
            otb_enc_atom(@"sample"),
            otb_enc_long(id),
            otb_enc_string(name),
            otb_enc_char(age),
            nil]);
}

- (void)decode:(NSData *)data {
    [self initWithDecodedData:otb_dec_tuple(data)];
}

- (void)initWithDecodedData:(DecodedData *)data {
    if([@"sample" isEqualToString:[data objectAtIndex:0]]) {
        self.id = [[data objectAtIndex:1] longValue];
        self.name = [data objectAtIndex:2];
        self.age = [[data objectAtIndex:3] charValue];
    }
    else [NSException raise:@"SampleDecodeException"
                     format:@"Can't decode Sample from %@, invalid data", data];
}

- (BOOL)isEqual:(id)object {
    if(object == nil) return false;
    if(object == self) return true;
    if([object isKindOfClass:[self class]]) {
        Sample *other = (Sample *) object;
        if(other.id != self.id) return false;
        if(![other.name isEqualToString:self.name]) return false;
        if(other.age != self.age) return false;
        return true;
    }
    return false;
}

@end
