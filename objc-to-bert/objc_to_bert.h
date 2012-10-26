#import <Foundation/Foundation.h>

#define OTB_DEC_EXC @"otb_decode_exception"

NSData * otb_enc_char(unsigned char val);

unsigned char otb_dec_char(NSData *val);

NSData * otb_enc_long(long val);

long otb_dec_long(NSData *val);

NSData * otb_enc_double(double val);

double otb_dec_double(NSData *val);

NSData * otb_enc_atom(NSString *name);

NSString * otb_dec_atom(NSData *val);

NSData * otb_enc_string(NSString *val);

NSString * otb_dec_string(NSData *val);

NSData * otb_enc_binary(NSData *val);

NSData * otb_dec_binary(NSData *val);

NSData * otb_enc_tuple(NSArray *items);

NSArray * otb_dec_tuple(NSData *val);

NSData * otb_enc_list(NSArray *items);

NSArray * otb_dec_list(NSData *val);
