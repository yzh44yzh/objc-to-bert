#import <Foundation/Foundation.h>

#define OTB_CHAR @"Char"
#define OTB_LONG @"Long"
#define OTB_DOUBLE @"Double"
#define OTB_STRING @"String"
#define OTB_BINARY @"Binary"
#define OTB_DECODED_DATA @"DecodedData"


@interface DecodedData : NSObject <NSCopying>


@property(nonatomic, copy) NSMutableArray *data;

@property(nonatomic, copy) NSMutableArray *types;

@property(nonatomic, assign) NSUInteger binLength;

- (NSUInteger)numItems;

- (void)addChar:(unsigned char)val;

- (unsigned char)getChar:(NSUInteger)index;

- (void)addLong:(long)val;

- (long)getLong:(NSUInteger)index;

- (void)addDouble:(double)val;

- (double)getDouble:(NSUInteger)index;

- (void)addString:(NSString *)val;

- (NSString *)getString:(NSUInteger)index;

- (void)addBinary:(NSData *)val;

- (NSData *)getBinary:(NSUInteger)index;

- (void)addDecodedData:(DecodedData *)val;

- (DecodedData *)getDecodedData:(NSUInteger)index;

@end
