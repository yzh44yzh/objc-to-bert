#import "SampleList.h"


@implementation SampleList

@synthesize items;

- (id)init {
    self = [super init];
    if (self) {
        items = [NSMutableArray array];
    }
    return self;
}

- (void)addItem:(Sample *)item {
    [items addObject:item];
}

- (NSData *)encode {
    NSMutableArray *encodedItems = [NSMutableArray array];
    for (Sample *item in items) {
        [encodedItems addObject:[item encode]];
    }
    return otb_enc_tuple([NSArray arrayWithObjects:
            otb_enc_atom(@"sample_list"),
            otb_enc_list(encodedItems),
            nil]);
}

- (void)decode:(NSData *)data {
    NSArray *props = otb_dec_tuple(data);
    if([@"sample_list" isEqualToString:[props objectAtIndex:0]]) {
        [items removeAllObjects];
        NSArray *tmp = [props objectAtIndex:1];
        for (int i = 0; i < tmp.count - 1; i++) { // skip last element
            [items addObject:[Sample createWithDecodedData:[tmp objectAtIndex:i]]];
        }
    }
    else [NSException raise:@"SampleListDecodeException"
                     format:@"Can't decode SampleList from %@, invalid data", data];
}

- (BOOL)isEqual:(id)object {
    if(object == nil) return false;
    if(object == self) return true;
    if([object isKindOfClass:[self class]]) {
        SampleList *other = (SampleList *) object;
        return [other.items isEqual:self.items];
    }
    return false;
}

@end
