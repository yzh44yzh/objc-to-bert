#import "objc_to_bert.h"

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

NSData * otb_enc_int(int val) {
    unsigned char buf[] = {98, val >> 24, val >> 16, val >> 8, val};
    return [NSData dataWithBytes:buf length:5];
}

int otb_dec_int(NSData *val) {
    if([val length] < 5)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode int from %@, not enought length", val];
    unsigned char buf[5];
    [val getBytes:buf length:5];
    if(buf[0] != 98)
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode int from %@, invalid header %d", val, buf[0]];
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
    int length = (buf[1] << 8) + buf[2];
    char str[length];
    if([val length] < (3 + length))
        [NSException raise:OTB_DEC_EXC
                    format:@"Can't decode atom from %@, not enought length", val];
    [val getBytes:str range:NSMakeRange(3, length)];
    str[length] = 0;
    return [NSString stringWithUTF8String:str];
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
