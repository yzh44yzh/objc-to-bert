#import "objc_to_bertTests.h"

bool compareDouble(double val1, double val2) {
    return fabs(val1 - val2) < 0.0000001;
}

@implementation objc_to_bertTests

- (void)testEncChar {
    uchar b0[] = {97, 0};
    STAssertEqualObjects(otb_enc_char(0), nsdata(b0, 2), @"enc char 0");

    uchar b10[] = {97, 10};
    STAssertEqualObjects(otb_enc_char(10), nsdata(b10, 2), @"enc char 10");

    uchar b120[] = {97, 120};
    STAssertEqualObjects(otb_enc_char(120), nsdata(b120, 2), @"enc char 120");

    uchar b255[] = {97, 255};
    STAssertEqualObjects(otb_enc_char(255), nsdata(b255, 2), @"enc char 255");
}

- (void)testDecChar {
    uchar b0[] = {97, 0};
    STAssertTrue(0 == otb_dec_char(nsdata(b0, 2)), @"dec char 0");

    uchar b2[] = {97, 2};
    STAssertTrue(2 == otb_dec_char(nsdata(b2, 2)), @"dec char 2");

    uchar b99[] = {97, 99};
    STAssertTrue(99 == otb_dec_char(nsdata(b99, 2)), @"dec char 99");

    uchar b255[] = {97, 255};
    STAssertTrue(255 == otb_dec_char(nsdata(b255, 2)), @"dec char 255");

    uchar invalidBuf[] = {98, 255};
    NSData *invalidData = nsdata(invalidBuf, 2);
    STAssertThrows(otb_dec_char(invalidData), @"should be invalid header exception");

    NSData *invalidData2 = nsdata(b255, 1);
    STAssertThrows(otb_dec_char(invalidData2), @"should be invalid size exception");
}

- (void)testEncInt {
    uchar b256[] = {98, 0, 0, 1, 0};
    STAssertEqualObjects(otb_enc_int(256), nsdata(b256, 5), @"enc int 256");

    uchar b500[] = {98, 0, 0, 1, 244};
    STAssertEqualObjects(otb_enc_int(500), nsdata(b500, 5), @"enc int 500");

    uchar b1023[] = {98, 0, 0, 3, 255};
    STAssertEqualObjects(otb_enc_int(1023), nsdata(b1023, 5), @"enc int 2^8-1");

    uchar b1024[] = {98, 0, 0, 4, 0};
    STAssertEqualObjects(otb_enc_int(1024), nsdata(b1024, 5), @"enc int 2^8");

    uchar b1025[] = {98, 0, 0, 4, 1};
    STAssertEqualObjects(otb_enc_int(1025), nsdata(b1025, 5), @"enc int 2^8+1");

    uchar b65535[] = {98, 0, 0, 255, 255};
    STAssertEqualObjects(otb_enc_int(65535), nsdata(b65535, 5), @"enc int 2^16-1");

    uchar b65536[] = {98, 0, 1, 0, 0};
    STAssertEqualObjects(otb_enc_int(65536), nsdata(b65536, 5), @"enc int 2^16");

    uchar b2147483647[] = {98, 127, 255, 255, 255};
    STAssertEqualObjects(otb_enc_int(2147483647), nsdata(b2147483647, 5), @"enc int 2^31-1");

    uchar bm1[] = {98, 255, 255, 255, 255};
    STAssertEqualObjects(otb_enc_int(-1), nsdata(bm1, 5), @"enc int -1");

    uchar bm100[] = {98, 255, 255, 255, 156};
    STAssertEqualObjects(otb_enc_int(-100), nsdata(bm100, 5), @"enc int -100");

    uchar bm1024[] = {98, 255, 255, 252, 0};
    STAssertEqualObjects(otb_enc_int(-1024), nsdata(bm1024, 5), @"enc int -1024");

    uchar bm2147483648[] = {98, 128, 0, 0, 0};
    STAssertEqualObjects(otb_enc_int(-2147483648), nsdata(bm2147483648, 5), @"enc int -2^31");
}

- (void)testDecInt {
    uchar b256[] = {98, 0, 0, 1, 0};
    STAssertTrue(256 == otb_dec_int(nsdata(b256, 5)), @"dec int 256");

    uchar b1024[] = {98, 0, 0, 4, 0};
    STAssertTrue(1024 == otb_dec_int(nsdata(b1024, 5)), @"dec int 1024");

    uchar b2147483647[] = {98, 127, 255, 255, 255};
    STAssertTrue(2147483647 == otb_dec_int(nsdata(b2147483647, 5)), @"dec int 2^31 - 1");

    uchar bm1024[] = {98, 255, 255, 252, 0};
    STAssertTrue(-1024 == otb_dec_int(nsdata(bm1024, 5)), @"dec int -1024");

    uchar bm2147483648[] = {98, 128, 0, 0, 0};
    STAssertTrue(-2147483648 == otb_dec_int(nsdata(bm2147483648, 5)), @"dec int -2^31");

    uchar invalidBuf[] = {97, 0, 0, 1, 0};
    NSData *invalidData = nsdata(invalidBuf, 5);
    STAssertThrows(otb_dec_int(invalidData), @"should be invalid header exception");

    NSData *invalidData2 = nsdata(b256, 2);
    STAssertThrows(otb_dec_int(invalidData2), @"should be invalid size exception");
}

- (void)testEncDouble {
    uchar b0_5[] = {99, 53, 46, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48,
            48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 101, 45, 48, 49, 0, 0, 0, 0, 0};
    STAssertEqualObjects(otb_enc_double(0.5), nsdata(b0_5, 32), @"enc double 0.5");

    uchar b5_55[] = {99, 53, 46, 53, 52, 57, 57, 57, 57, 57, 57, 57, 57,
            57, 57, 57, 57, 57, 56, 50, 50, 51, 54, 101, 43, 48, 48, 0, 0, 0, 0, 0};
    STAssertEqualObjects(otb_enc_double(5.55), nsdata(b5_55, 32), @"enc double 5.55");

    uchar bm10_35[] = {99, 45, 49, 46, 48, 51, 52, 57, 57, 57, 57, 57, 57,
            57, 57, 57, 57, 57, 57, 57, 54, 52, 52, 55, 101, 43, 48, 49, 0, 0, 0, 0};
    STAssertEqualObjects(otb_enc_double(-10.35), nsdata(bm10_35, 32), @"enc double -10.35");
}

- (void)testDecDouble {
    uchar b0_5[] = {99, 53, 46, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48,
            48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 101, 45, 48, 49, 0, 0, 0, 0, 0};
    double res = otb_dec_double(nsdata(b0_5, 32));
    STAssertTrue(compareDouble(0.5, res), @"dec double 0.5");

    uchar bm10_35[] = {99, 45, 49, 46, 48, 51, 52, 57, 57, 57, 57, 57, 57,
            57, 57, 57, 57, 57, 57, 57, 54, 52, 52, 55, 101, 43, 48, 49, 0, 0, 0, 0};
    res = otb_dec_double(nsdata(bm10_35, 32));
    STAssertTrue(compareDouble(-10.35, res), @"dec double -10.35");

    NSData *invalidData = nsdata(bm10_35, 10);
    STAssertThrows(otb_dec_int(invalidData), @"should be invalid size exception");
}

- (void)testEncAtom {
    uchar b1[] = {100, 0, 4, 97, 116, 111, 109};
    STAssertEqualObjects(otb_enc_atom(@"atom"), nsdata(b1, 7), @"enc atom 'atom'");

    uchar b2[] = {100, 0, 8, 117, 115, 101, 114, 110, 97, 109, 101};
    STAssertEqualObjects(otb_enc_atom(@"username"), nsdata(b2, 11), @"enc atom 'username'");
}

- (void)testDecAtom {
    uchar b1[] = {100, 0, 4, 97, 116, 111, 109};
    NSString *res = otb_dec_atom(nsdata(b1, 7));
    STAssertEqualObjects(res, @"atom", @"dec atom 'atom'");

    uchar b2[] = {100, 0, 8, 117, 115, 101, 114, 110, 97, 109, 101};
    NSString *res2 = otb_dec_atom(nsdata(b2, 11));
    STAssertEqualObjects(res2, @"username", @"dec atom 'username'");

    NSData *invalidData = nsdata(b2, 10);
    STAssertThrows(otb_dec_atom(invalidData), @"should be invalid size exception");
}

- (void)testEncString {
    uchar b1[] = {107, 0, 5, 104, 101, 108, 108, 111};
    STAssertEqualObjects(otb_enc_string(@"hello"), nsdata(b1, 8), @"enc string 'hello'");

    uchar b2[] = {107, 0, 6, 69, 114, 108, 97, 110, 103};
    STAssertEqualObjects(otb_enc_string(@"Erlang"), nsdata(b2, 9), @"enc string 'Erlang'");
}

- (void)testDecString {
    uchar b1[] = {107, 0, 5, 104, 101, 108, 108, 111};
    NSString *res = otb_dec_string(nsdata(b1, 8));
    STAssertEqualObjects(res, @"hello", @"dec string 'hello'");

    uchar b2[] = {107, 0, 6, 69, 114, 108, 97, 110, 103};
    NSString *res2 = otb_dec_string(nsdata(b2, 9));
    STAssertEqualObjects(res2, @"Erlang", @"dec string 'Erlang'");

    NSData *invalidData = nsdata(b2, 5);
    STAssertThrows(otb_dec_string(invalidData), @"should be invalid size exception");
}

- (void)testEncBinary {
    uchar b[] = {109, 0, 0, 0, 3, 1, 2, 3};
    uchar myBin [] = {1, 2, 3};
    NSData *data = nsdata(myBin, 3);
    STAssertEqualObjects(otb_enc_binary(data), nsdata(b, 8), @"enc binary <<1,2,3>>");
}

- (void)testDecBinary {
    uchar b[] = {109, 0, 0, 0, 4, 1, 2, 3, 4};
    uchar r [] = {1, 2, 3, 4};
    NSData *data = nsdata(b, 9);
    NSData *res = nsdata(r, 4);
    STAssertEqualObjects(otb_dec_binary(data), res, @"dec binary <<1,2,3,4>>");

    NSData *invalidData = nsdata(b, 6);
    STAssertThrows(otb_dec_binary(invalidData), @"should be invalid size exception");
}

- (void)testEncTuple {
    uchar b1[] = {104, 2, 97, 5, 97, 6};
    NSArray *data1 = [NSArray arrayWithObjects:otb_enc_char(5), otb_enc_char(6), nil];
    STAssertEqualObjects(otb_enc_tuple(data1), nsdata(b1, 6), @"enc tuple {5, 6}");

    uchar b2[] = {104, 3, 100, 0, 4, 117, 115, 101, 114, 97, 3, 98, 0, 0, 1, 244};
    NSArray *data2 = [NSArray arrayWithObjects:otb_enc_atom(@"user"), otb_enc_char(3),
                                               otb_enc_int(500), nil];
    STAssertEqualObjects(otb_enc_tuple(data2), nsdata(b2, 16), @"enc tuple {user, 3, 500}");
}

- (void)testDecTuple {
    uchar b1[] = {104, 3, 97, 5, 97, 6, 98, 0, 0, 1, 244};
    NSData *data1 = nsdata(b1, 11);
    NSArray *res1 = [NSArray arrayWithObjects:
            [NSNumber numberWithChar:5],
            [NSNumber numberWithChar:6],
            [NSNumber numberWithInt:500],
            nil];
    STAssertEqualObjects(otb_dec_tuple(data1), res1, @"dec tuple {5, 6, 500}");
}

- (void)testEncList {
    uchar b1[] = {108, 0, 0, 0, 3, 97, 1, 97, 2, 98, 0, 0, 1, 244, 106};
    NSArray *data1 = [NSArray arrayWithObjects:otb_enc_char(1), otb_enc_char(2),
                                               otb_enc_int(500), nil];
    STAssertEqualObjects(otb_enc_list(data1), nsdata(b1, 15), @"enc list [1, 2, 500]");

    uchar b2[] = {108, 0, 0, 0, 4, 97, 1, 97, 2, 108, 0, 0, 0, 2, 98, 0, 0, 1, 44,
            98, 0, 0, 1, 244, 106, 97, 3, 106};
    NSArray *inner = [NSArray arrayWithObjects:otb_enc_int(300), otb_enc_int(500), nil];
    NSArray *data2 = [NSArray arrayWithObjects:otb_enc_char(1), otb_enc_char(2),
                                               otb_enc_list(inner), otb_enc_char(3), nil];
    STAssertEqualObjects(otb_enc_list(data2), nsdata(b2, 28), @"enc list [1, 2, [300, 500], 3]");
}

@end

