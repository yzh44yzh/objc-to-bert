#import <Foundation/Foundation.h>

NSData * otb_enc_char(unsigned char val);

unsigned char otb_dec_char(NSData * val);

NSData * otb_enc_int(int val);

NSData * otb_enc_double(double val);

NSData * otb_enc_atom(NSString *name);

NSData * otb_enc_tuple(NSArray *items);

NSData * otb_enc_list(NSArray *items);

NSData * otb_enc_string(NSString *val);

NSData * otb_enc_binary(NSData *val);
