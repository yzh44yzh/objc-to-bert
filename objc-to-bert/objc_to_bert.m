#import "objc_to_bert.h"

NSData * otb_enc_char(unsigned char val) {
    unsigned char buf[] = {97, val};
    return [NSData dataWithBytes:buf length:2];
}

NSData * otb_enc_int(int val) {
    unsigned char buf[] = {98, val >> 24, val >> 16, val >> 8, val};
    return [NSData dataWithBytes:buf length:5];
}

NSData * otb_enc_double(double val) {
    unsigned char buf[32];
    buf[0] = 99;
    for(char i = 1; i < 32; i++) buf[i] = 0;
    sprintf(buf + 1, "%.20e", val);
    return [NSData dataWithBytes:buf length:32];
}

NSData * otb_enc_atom(NSString *name) {
    NSUInteger size = [name length];
    unsigned char buf[] = {100, size >> 8, size};
    NSMutableData *data = [NSMutableData dataWithBytes:buf length:3];
    [data appendData:[name dataUsingEncoding:NSUTF8StringEncoding]];
    return data;
}

NSData * otb_enc_tuple(NSArray *items) {
    NSUInteger size = [items count];
    unsigned char buf[] = {104, size};
    NSMutableData *data = [NSMutableData dataWithBytes:buf length:2];
    for (NSData *item in items) [data appendData:item];
    return data;
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

NSData * otb_enc_string(NSString *val) {
    NSUInteger size = [val length];
    unsigned char buf[] = {107, size >> 8, size};
    NSMutableData *data = [NSMutableData dataWithBytes:buf length:3];
    [data appendData:[val dataUsingEncoding:NSISOLatin1StringEncoding]];
    return data;
}

NSData * otb_enc_binary(NSData *val) {
    NSUInteger size = [val length];
    unsigned char buf[] = {109, size >> 24, size >> 16, size >> 8, size};
    NSMutableData *data = [NSMutableData dataWithBytes:buf length:5];
    [data appendData:val];
    return data;
}
