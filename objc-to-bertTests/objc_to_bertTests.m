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
    STAssertEqualObjects(nsdata(bm1, 5), otb_enc_int(-1), @"enc int -1");

    uchar bm100[] = {98, 255, 255, 255, 156};
    STAssertEqualObjects(nsdata(bm100, 5), otb_enc_int(-100), @"enc int -100");

    uchar bm1024[] = {98, 255, 255, 252, 0};
    STAssertEqualObjects(nsdata(bm1024, 5), otb_enc_int(-1024), @"enc int -1024");

    uchar bm2147483648[] = {98, 128, 0, 0, 0};
    STAssertEqualObjects(nsdata(bm2147483648, 5), otb_enc_int(-2147483648), @"enc int -2^31");
}

- (void)testEncDouble {
    uchar b0_5[] = {99, 53, 46, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48,
            48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 101, 45, 48, 49, 0, 0, 0, 0, 0};
    STAssertEqualObjects(nsdata(b0_5, 32), otb_enc_double(0.5), @"enc double 0.5");

    uchar b5_55[] = {99, 53, 46, 53, 52, 57, 57, 57, 57, 57, 57, 57, 57,
            57, 57, 57, 57, 57, 56, 50, 50, 51, 54, 101, 43, 48, 48, 0, 0, 0, 0, 0};
    STAssertEqualObjects(nsdata(b5_55, 32), otb_enc_double(5.55), @"enc double 5.55");

    uchar bm10_35[] = {99, 45, 49, 46, 48, 51, 52, 57, 57, 57, 57, 57, 57,
            57, 57, 57, 57, 57, 57, 57, 54, 52, 52, 55, 101, 43, 48, 49, 0, 0, 0, 0};
    STAssertEqualObjects(nsdata(bm10_35, 32), otb_enc_double(-10.35), @"enc double -10.35");
}

- (void)testEncAtom {
    uchar b1[] = {100, 0, 4, 97, 116, 111, 109};
    STAssertEqualObjects(nsdata(b1, 7), otb_enc_atom(@"atom"), @"enc atom 'atom'");

    uchar b2[] = {100, 0, 8, 117, 115, 101, 114, 110, 97, 109, 101};
    STAssertEqualObjects(nsdata(b2, 11), otb_enc_atom(@"username"), @"enc atom 'username'");
}

- (void)testEncTuple {
    uchar b1[] = {104, 2, 97, 5, 97, 6};
    NSArray *data1 = [NSArray arrayWithObjects:otb_enc_char(5), otb_enc_char(6), nil];
    STAssertEqualObjects(nsdata(b1, 6), otb_enc_tuple(data1), @"enc tuple {5, 6}");

    uchar b2[] = {104, 3, 100, 0, 4, 117, 115, 101, 114, 97, 3, 98, 0, 0, 1, 244};
    NSArray *data2 = [NSArray arrayWithObjects:otb_enc_atom(@"user"), otb_enc_char(3),
                                               otb_enc_int(500), nil];
    STAssertEqualObjects(nsdata(b2, 16), otb_enc_tuple(data2), @"enc tuple {user, 3, 500}");
}

- (void)testEncList {
    uchar b1[] = {108, 0, 0, 0, 3, 97, 1, 97, 2, 98, 0, 0, 1, 244, 106};
    NSArray *data1 = [NSArray arrayWithObjects:otb_enc_char(1), otb_enc_char(2),
                                               otb_enc_int(500), nil];
    STAssertEqualObjects(nsdata(b1, 15), otb_enc_list(data1), @"enc list [1, 2, 500]");

    uchar b2[] = {108, 0, 0, 0, 4, 97, 1, 97, 2, 108, 0, 0, 0, 2, 98, 0, 0, 1, 44,
            98, 0, 0, 1, 244, 106, 97, 3, 106};
    NSArray *inner = [NSArray arrayWithObjects:otb_enc_int(300), otb_enc_int(500), nil];
    NSArray *data2 = [NSArray arrayWithObjects:otb_enc_char(1), otb_enc_char(2),
                                               otb_enc_list(inner), otb_enc_char(3), nil];
    STAssertEqualObjects(nsdata(b2, 28), otb_enc_list(data2), @"enc list [1, 2, [300, 500], 3]");
}

- (void)testEncString {
    uchar b1[] = {107, 0, 5, 104, 101, 108, 108, 111};
    STAssertEqualObjects(nsdata(b1, 8), otb_enc_string(@"hello"), @"enc string 'hello'");

    uchar b2[] = {107, 0, 6, 69, 114, 108, 97, 110, 103};
    STAssertEqualObjects(nsdata(b2, 9), otb_enc_string(@"Erlang"), @"enc string 'Erlang'");
}

- (void)testEncBinary {
    uchar b[] = {109, 0, 0, 0, 3, 1, 2, 3};
    uchar myBin [] = {1, 2, 3};
    NSData *data = nsdata(myBin, 3);
    STAssertEqualObjects(nsdata(b, 8), otb_enc_binary(data), @"enc binary <<1,2,3>>");
}

@end
