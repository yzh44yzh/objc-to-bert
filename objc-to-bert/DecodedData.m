#import "DecodedData.h"

@implementation DecodedData

- (id)init {
    self = [super init];
    if (self) {
        _data = [NSMutableArray array];
		_types = [NSMutableArray array];
        self.binLength = 0;
    }
    return self;
}

- (NSUInteger)numItems {
	return _data.count;
}

- (bool)checkType:(NSString *)type atIndex:(NSUInteger)index {
	if(index >= _data.count) {
		NSLog(@"DecodedData: ask for item at index %d, but there are only %d items",
				   index, _data.count);
		return false;
	}
	NSString *t = _types[index];
	if([t isEqualToString:type]) return true;
	else {
        NSLog(@"DecodedData: ask for %@ at index %d, but here is:%@",
				   type, index, [self showItem:index withPadding:@""]);
		return false;
	}
}

- (void)addChar:(unsigned char)val {
	[_types addObject:OTB_CHAR];
    [_data addObject:@(val)];
}

- (unsigned char)getChar:(NSUInteger)index {
	if([self checkType:OTB_CHAR atIndex:index])
		return (unsigned char) [_data[index] charValue];
	return 0;
}

- (void)addLong:(long)val {
	[_types addObject:OTB_LONG];
    [_data addObject:@(val)];
}

- (long)getLong:(NSUInteger)index {
	if(index >= _data.count) {
        NSLog(@"DecodedData: ask for item at index %d, but there are only %d items",
				   index, _data.count);
		return 0;
	}
	NSString *type = _types[index];
	if([type isEqualToString:OTB_CHAR] || [type isEqualToString:OTB_LONG]) {
		return [_data[index] longValue];
	}
	else {
        NSLog(@"DecodedData: ask for %@ at index %d, but here is:%@",
				   type, index, [self showItem:index withPadding:@""]);
		return 0;
	}
}

- (void)addDouble:(double)val {
	[_types addObject:OTB_DOUBLE];
    [_data addObject:@(val)];
}

- (double)getDouble:(NSUInteger)index {
	if([self checkType:OTB_DOUBLE atIndex:index])
        return [_data[index] doubleValue];
	return 0.0;
}

- (void)addString:(NSString *)val {
	[_types addObject:OTB_STRING];
    [_data addObject:val];
}

- (NSString *)getString:(NSUInteger)index {
	if([self checkType:OTB_STRING atIndex:index])
        return _data[index];
	return nil;
}

- (void)addBinary:(NSData *)val {
	[_types addObject:OTB_BINARY];
    [_data addObject:val];
}

- (NSData *)getBinary:(NSUInteger)index {
	if([self checkType:OTB_BINARY atIndex:index])
	    return _data[index];
	return nil;
}

- (void)addDecodedData:(DecodedData *)val {
	[_types addObject:OTB_DECODED_DATA];

	if(val == nil) [_data addObject:[NSNull null]];
    else [_data addObject:val];
}

- (DecodedData *)getDecodedData:(NSUInteger)index {
    if([_data[index] isEqual:@""]) return nil;
	if([self checkType:OTB_DECODED_DATA atIndex:index])
	    return _data[index];
	return nil;
}

- (NSString *)showItem:(NSUInteger)index withPadding:padding {
	NSString *t = _types[index];
	if([t isEqualToString:OTB_DECODED_DATA]) {
		DecodedData *item = _data[index];
		if(item == nil || [[NSNull null] isEqual:item])
			return [NSString stringWithFormat:@"%@%ld %@ : nil", padding, (unsigned long)index, t];
		return [item showWithPadding:[NSString stringWithFormat:@"%@%ld ", padding, (unsigned long)index]];
	}
	if([t isEqualToString:OTB_STRING]) {
		NSData *item = _data[index];
		return [NSString stringWithFormat:@"%@%d %@ : \"%@\"",
				padding, index, t, item];
	}
	if([t isEqualToString:OTB_BINARY]) {
		NSData *item = _data[index];
		return [NSString stringWithFormat:@"%@%d %@ : %@",
				padding, index, t, [self showBinary:item]];
	}
    return [NSString stringWithFormat:@"%@%d %@ : %@", padding, index, t, _data[index]];
}

- (NSString *)description {
	return [self showWithPadding:@""];
}

- (NSString *)showWithPadding:padding {
	NSString *res = [NSString stringWithFormat:@"%@DecodedData:\n", padding];
	NSString *itemsPadding = [NSString stringWithFormat:@"%@    ", padding];
	for(NSUInteger i = 0; i < _data.count; i++) {
		NSString *item = [self showItem:i withPadding:itemsPadding];
		res = [NSString stringWithFormat:@"%@%@\n", res, item];
	}
	return res;
}

- (NSString *)showBinary:(NSData *)dt {
    if(dt && [dt length]) {
        size_t length = [dt length];
        char buf[length + 1];
        [dt getBytes:buf length:length];
        buf[length] = 0;
        return [NSString stringWithFormat:@"\"%@\"", @(buf)];
    }
    return @"<empty binary>";
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
	newItem.types = self.types;
    return newItem;
}


@end
