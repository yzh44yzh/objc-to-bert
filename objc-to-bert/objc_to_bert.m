#import "objc_to_bert.h"

DecodedData * otb_get_items(NSData *val, NSUInteger length);

NSData * otb_enc_char(unsigned char val) {
    unsigned char buf[] = {97, val};
    return [NSData dataWithBytes:buf length:2];
}

unsigned char otb_dec_char(NSData * val) {
    if([val length] < 2)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode char from %@, not enought length", val];
    unsigned char buf[2];
    [val getBytes:buf length:2];
    if(buf[0] != 97)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode char from %@, invalid header %d", val, buf[0]];
    return buf[1];
}

NSData * otb_enc_long(long val) {
    unsigned char buf[] = {98, val >> 24, val >> 16, val >> 8, val};
    return [NSData dataWithBytes:buf length:5];
}

long otb_dec_long(NSData *val) {
    if([val length] < 5)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode long from %@, not enought length", val];
    unsigned char buf[5];
    [val getBytes:buf length:5];
    if(buf[0] != 98)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode long from %@, invalid header %d", val, buf[0]];
    return (buf[1] << 24) + (buf[2] << 16) + (buf[3] << 8) + buf[4];
}

NSData * otb_enc_double(double val) {
    char buf[32];
    buf[0] = 99;
    for(char i = 1; i < 32; i++) buf[i] = 0;
    sprintf(buf + 1, "%.20e", val);
    return [NSData dataWithBytes:buf length:32];
}

double otb_dec_double(NSData *val) {
    if([val length] < 32)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode double from %@, not enought length", val];
    char buf[32];
    [val getBytes:buf length:32];
    if(buf[0] != 99)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode double from %@, invalid header %d", val, buf[0]];
    double res;
    int num = sscanf(buf, "c%lf", &res);
    if(num != 1)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode double from %@, invalid data", val];
    return res;
}

NSData * otb_enc_atom(NSString *name) {
    NSUInteger size = [name length];
    unsigned char buf[] = {100, size >> 8, size};
    NSMutableData *data = [NSMutableData dataWithBytes:buf length:3];
    [data appendData:[name dataUsingEncoding:NSUTF8StringEncoding]];
    return data;
}

NSString * otb_dec_atom(NSData *val){
    if([val length] < 3)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode atom from %@, not enought length", val];
    unsigned char buf[3];
    [val getBytes:buf length:3];
    if(buf[0] != 100)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode atom from %@, invalid header %d", val, buf[0]];
    NSUInteger length = (buf[1] << 8) + buf[2];
    char str[length];
    if([val length] < (3 + length))
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode atom from %@, not enought length", val];
    [val getBytes:str range:NSMakeRange(3, length)];
    str[length] = 0;
    return [NSString stringWithUTF8String:str];
}

NSData * otb_enc_string(NSString *val) {
    NSUInteger size = [val length];
    unsigned char buf[] = {107, size >> 8, size};
    NSMutableData *data = [NSMutableData dataWithBytes:buf length:3];
    [data appendData:[val dataUsingEncoding:NSISOLatin1StringEncoding]];
    return data;
}

NSString * otb_dec_string(NSData *val) {
    if([val length] < 3)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode string from %@, not enought length", val];
    char buf[3];
    [val getBytes:buf length:3];
    if(buf[0] != 107)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode string from %@, invalid header %d", val, buf[0]];

    NSUInteger length = (NSUInteger) ((buf[1] << 8) + buf[2]);
    char str[length];
    if([val length] < (3 + length))
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode string from %@, not enought length", val];
    [val getBytes:str range:NSMakeRange(3, length)];
    str[length] = 0;
    return [NSString stringWithUTF8String:str];
}

NSData * otb_enc_binary(NSData *val) {
    NSUInteger size = [val length];
    unsigned char buf[] = {109, size >> 24, size >> 16, size >> 8, size};
    NSMutableData *data = [NSMutableData dataWithBytes:buf length:5];
    [data appendData:val];
    return data;
}

NSData * otb_dec_binary(NSData *val){
    if([val length] < 5)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode binary from %@, not enought length", val];
    char buf[5];
    [val getBytes:buf length:5];
    if(buf[0] != 109)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode binary from %@, invalid header %d", val, buf[0]];

    int length = (buf[1] << 24) + (buf[2] << 16) + (buf[3] << 8) + buf[4];
    if([val length] < (5 + length))
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode binary from %@, not enought length", val];
    NSRange range = NSMakeRange(5, (NSUInteger) length);
    return [val subdataWithRange:range];
}

NSData * otb_enc_bstr(NSString * val) {
    return otb_enc_binary([val dataUsingEncoding:NSUTF8StringEncoding]);
}

NSString * otb_dec_bstr(NSData * val) {
    NSData *dt = otb_dec_binary(val);
    NSUInteger length = [dt length];
    char buf[length + 1];
    [dt getBytes:buf length:length];
    buf[length] = 0;
    return [NSString stringWithUTF8String:buf];
}

NSData * otb_enc_tuple(NSArray *items) {
    NSUInteger size = [items count];
    unsigned char buf[] = {104, size};
    NSMutableData *data = [NSMutableData dataWithBytes:buf length:2];
    for (NSData *item in items) [data appendData:item];
    return data;
}

DecodedData * otb_dec_tuple(NSData *val) {
    if([val length] < 2)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode tuple from %@, not enought length", val];
    char buf[2];
    [val getBytes:buf length:2];
    if(buf[0] != 104)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode tuple from %@, invalid header %d", val, buf[0]];

    NSUInteger length = (NSUInteger) buf[1];
    NSRange range = NSMakeRange(2, [val length] - 2);
    return otb_get_items([val subdataWithRange:range], length);
}

NSData * otb_enc_list(NSArray *items) {
    NSUInteger size = [items count];
    unsigned char buf[] = {108, size >> 24, size >> 16, size >> 8, size};
    NSMutableData *data = [NSMutableData dataWithBytes:buf length:5];
    for (NSData *item in items) [data appendData:item];
    unsigned char end[] = {106};
    [data appendData:[NSData dataWithBytes:end length:1]];
    return data;
}

DecodedData * otb_dec_list(NSData *val) {
    if([val length] < 5)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode list from %@, not enought length", val];
    char buf[5];
    [val getBytes:buf length:5];
    if(buf[0] != 108)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode list from %@, invalid header %d", val, buf[0]];

    long length = (buf[1] << 24) + (buf[2] << 16) + (buf[3] << 8) + buf[4];
    if([val length] < (5 + length))
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode list from %@, not enought length", val];
    NSRange range = NSMakeRange(5, [val length] - 5);
    return otb_get_items([val subdataWithRange:range], (NSUInteger) length);
}

DecodedData * otb_get_items(NSData *val, NSUInteger length) {
    NSUInteger position = 0;
    DecodedData *res = [[DecodedData alloc] init];

    for (int i = 0; i < length; i++) {
        char header[1];
        NSData *subData;
        [val getBytes:header range:NSMakeRange(position, 1)];

        switch(header[0]) {
            case 97: {
                subData = [val subdataWithRange:NSMakeRange(position, 2)];
                [res addChar:otb_dec_char(subData)];
                position += 2;
            } break;
            case 98: {
                subData = [val subdataWithRange:NSMakeRange(position, 5)];
                [res addLong:otb_dec_long(subData)];
                position += 5;
            } break;
            case 99: {
                subData = [val subdataWithRange:NSMakeRange(position, 32)];
                [res addDouble:otb_dec_double(subData)];
                position += 32;
            } break;
            case 100: {
                subData = [val subdataWithRange:NSMakeRange(position, [val length] - position)];
                NSString *atom = otb_dec_atom(subData);
                [res addString:atom];
                position += 3 + atom.length;
            } break;
            case 107: {
                subData = [val subdataWithRange:NSMakeRange(position, [val length] - position)];
                NSString *str = otb_dec_string(subData);
                [res addString:str];
                position += 3 + str.length;
            } break;
            case 109: {
                subData = [val subdataWithRange:NSMakeRange(position, [val length] - position)];
                NSData *bin = otb_dec_binary(subData);
                [res addBinary:bin];
                position += 5 + bin.length;
            } break;
            case 104: {
                subData = [val subdataWithRange:NSMakeRange(position, [val length] - position)];
                DecodedData *tuple = otb_dec_tuple(subData);
                [res addDecodedData:tuple];
                position += 2 + tuple.binLength;
            } break;
            case 108: {
                subData = [val subdataWithRange:NSMakeRange(position, [val length] - position)];
                DecodedData *list = otb_dec_list(subData);
                [res addDecodedData:list];
                position += 5 + list.binLength + 1; // plus byte 106 (empty list)
            } break;
            default: {
                [NSException raise:OTB_DEC_EXC
                            format:@"unknown item %d in data %@", header[0], val];
            }
        }
    }
    res.binLength = position;
    return res;
}

