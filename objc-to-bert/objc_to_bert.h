#import <Foundation/Foundation.h>

NSData * otb_enc_char(unsigned char val);

NSData * otb_enc_int(int val);

NSData * otb_enc_double(double val);

NSData * otb_enc_atom(NSString *name);

NSData * otb_enc_tuple(NSArray *items);

NSData * otb_enc_list(NSArray *items);

NSData * otb_enc_string(NSString *val);
