#import "objc_to_bertTests.h"

@implementation objc_to_bertTests

- (void)testEncChar {
    uchar b0[] = {97, 0};
    STAssertEqualObjects(nsdata(b0, 2), otb_enc_char(0), @"enc char 0");

    uchar b10[] = {97, 10};
    STAssertEqualObjects(nsdata(b10, 2), otb_enc_char(10), @"enc char 10");

    uchar b120[] = {97, 120};
    STAssertEqualObjects(nsdata(b120, 2), otb_enc_char(120), @"enc char 120");

    uchar b255[] = {97, 255};
    STAssertEqualObjects(nsdata(b255, 2), otb_enc_char(255), @"enc char 255");
}

- (void)testEncInt {

    uchar b256[] = {98, 0, 0, 1, 0};
    STAssertEqualObjects(nsdata(b256, 5), otb_enc_int(256), @"enc int 256");

    uchar b500[] = {98, 0, 0, 1, 244};
    STAssertEqualObjects(nsdata(b500, 5), otb_enc_int(500), @"enc int 500");

    uchar b1023[] = {98, 0, 0, 3, 255};
    STAssertEqualObjects(nsdata(b1023, 5), otb_enc_int(1023), @"enc int 2^8-1");

    uchar b1024[] = {98, 0, 0, 4, 0};
    STAssertEqualObjects(nsdata(b1024, 5), otb_enc_int(1024), @"enc int 2^8");

    uchar b1025[] = {98, 0, 0, 4, 1};
    STAssertEqualObjects(nsdata(b1025, 5), otb_enc_int(1025), @"enc int 2^8+1");

    uchar b65535[] = {98, 0, 0, 255, 255};
    STAssertEqualObjects(nsdata(b65535, 5), otb_enc_int(65535), @"enc int 2^16-1");

    uchar b65536[] = {98, 0, 1, 0, 0};
    STAssertEqualObjects(nsdata(b65536, 5), otb_enc_int(65536), @"enc int 2^16");

    uchar b2147483647[] = {98, 127, 255, 255, 255};
    STAssertEqualObjects(nsdata(b2147483647, 5), otb_enc_int(2147483647), @"enc int 2^31-1");

    uchar bm1[] = {98, 255, 255, 255, 255};
    STAssertEqualObjects(nsdata(bm1, 5), otb_enc_int(-1), @"encording int -1");
}

@end
