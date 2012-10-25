#import "objc_to_bert.h"

NSData * otb_enc_char(unsigned char val) {
    char buf[] = {97, val};
    return [NSData dataWithBytes:buf length:2];
}

NSData * otb_enc_int(int val) {
    char buf[] = {98, val >> 24, val >> 16, val >> 8, val};
    return [NSData dataWithBytes:buf length:5];
}

NSData * otb_enc_NSInteger(NSInteger val) {
    return [NSData data];
}
