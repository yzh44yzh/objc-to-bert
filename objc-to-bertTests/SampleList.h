#import <Foundation/Foundation.h>
#import "Sample.h"


@interface SampleList : NSObject {
    NSMutableArray *items;
}

@property(nonatomic, copy) NSMutableArray *items;

- (void)addItem:(Sample *)item;

- (NSData *)encode;

- (void)decode:(NSData *)data;


@end
