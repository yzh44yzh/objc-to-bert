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
    NSArray *props = otb_dec_tuple(data);
    if([@"sample" isEqualToString:[props objectAtIndex:0]]) {
        self.id = [[props objectAtIndex:1] longValue];
        self.name = [props objectAtIndex:2];
        self.age = [[props objectAtIndex:3] charValue];
    }
    else [NSException raise:@"SampleDecodeException"
                     format:@"Can't decode Sample from %@, invalid data", data];
}



@end
