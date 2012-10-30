#import <Foundation/Foundation.h>


@interface DecodedData : NSObject <NSCopying> {
    NSMutableArray *data;
    NSUInteger binLength;
}

@property(nonatomic, copy) NSMutableArray *data;

@property(nonatomic, assign) NSUInteger binLength;

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
