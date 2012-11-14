#import <Foundation/Foundation.h>
#import "objc_to_bert.h"


@interface Sample : NSObject {
    long id;
    NSString *name;
    unsigned char age;
}

@property(nonatomic, assign) long id;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) unsigned char age;

+ (Sample *)createWithData:(NSData *)data;

+ (Sample *)createWithDecodedData:(DecodedData *)data;

+ (Sample *)createWithId:(long)id andName:(NSString *)name andAge:(unsigned char)age;

- (NSData *)encode;

- (void)decode:(NSData *)data;

- (void)initWithDecodedData:(DecodedData *)data;

@end
