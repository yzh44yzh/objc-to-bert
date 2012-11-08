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

- (void)testEncLong {
    uchar b256[] = {98, 0, 0, 1, 0};
    STAssertEqualObjects(otb_enc_long(256), nsdata(b256, 5), @"enc long 256");

    uchar b500[] = {98, 0, 0, 1, 244};
    STAssertEqualObjects(otb_enc_long(500), nsdata(b500, 5), @"enc long 500");

    uchar b1023[] = {98, 0, 0, 3, 255};
    STAssertEqualObjects(otb_enc_long(1023), nsdata(b1023, 5), @"enc long 2^8-1");

    uchar b1024[] = {98, 0, 0, 4, 0};
    STAssertEqualObjects(otb_enc_long(1024), nsdata(b1024, 5), @"enc long 2^8");

    uchar b1025[] = {98, 0, 0, 4, 1};
    STAssertEqualObjects(otb_enc_long(1025), nsdata(b1025, 5), @"enc long 2^8+1");

    uchar b65535[] = {98, 0, 0, 255, 255};
    STAssertEqualObjects(otb_enc_long(65535), nsdata(b65535, 5), @"enc long 2^16-1");

    uchar b65536[] = {98, 0, 1, 0, 0};
    STAssertEqualObjects(otb_enc_long(65536), nsdata(b65536, 5), @"enc long 2^16");

    uchar b2147483647[] = {98, 127, 255, 255, 255};
    STAssertEqualObjects(otb_enc_long(2147483647), nsdata(b2147483647, 5), @"enc long 2^31-1");

    uchar bm1[] = {98, 255, 255, 255, 255};
    STAssertEqualObjects(otb_enc_long(-1), nsdata(bm1, 5), @"enc long -1");

    uchar bm100[] = {98, 255, 255, 255, 156};
    STAssertEqualObjects(otb_enc_long(-100), nsdata(bm100, 5), @"enc long -100");

    uchar bm1024[] = {98, 255, 255, 252, 0};
    STAssertEqualObjects(otb_enc_long(-1024), nsdata(bm1024, 5), @"enc long -1024");

    uchar bm2147483648[] = {98, 128, 0, 0, 0};
    STAssertEqualObjects(otb_enc_long(-2147483648), nsdata(bm2147483648, 5), @"enc long -2^31");
}

- (void)testDecLong {
    uchar b256[] = {98, 0, 0, 1, 0};
    STAssertTrue(256 == otb_dec_long(nsdata(b256, 5)), @"dec long 256");

    uchar b1024[] = {98, 0, 0, 4, 0};
    STAssertTrue(1024 == otb_dec_long(nsdata(b1024, 5)), @"dec long 1024");

    uchar b2147483647[] = {98, 127, 255, 255, 255};
    STAssertTrue(2147483647 == otb_dec_long(nsdata(b2147483647, 5)), @"dec long 2^31 - 1");

    uchar bm1024[] = {98, 255, 255, 252, 0};
    STAssertTrue(-1024 == otb_dec_long(nsdata(bm1024, 5)), @"dec long -1024");

    uchar bm2147483648[] = {98, 128, 0, 0, 0};
    STAssertTrue(-2147483648 == otb_dec_long(nsdata(bm2147483648, 5)), @"dec long -2^31");

    uchar invalidBuf[] = {97, 0, 0, 1, 0};
    NSData *invalidData = nsdata(invalidBuf, 5);
    STAssertThrows(otb_dec_long(invalidData), @"should be invalid header exception");

    NSData *invalidData2 = nsdata(b256, 2);
    STAssertThrows(otb_dec_long(invalidData2), @"should be invalid size exception");
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
    STAssertThrows(otb_dec_long(invalidData), @"should be invalid size exception");
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

    uchar b3[] = {106};
    STAssertEqualObjects(otb_enc_string(@""), nsdata(b3, 1), @"enc empty string");
}

- (void)testDecString {
    uchar b1[] = {107, 0, 5, 104, 101, 108, 108, 111};
    NSString *res = otb_dec_string(nsdata(b1, 8));
    STAssertEqualObjects(res, @"hello", @"dec string 'hello'");

    uchar b2[] = {107, 0, 6, 69, 114, 108, 97, 110, 103};
    NSString *res2 = otb_dec_string(nsdata(b2, 9));
    STAssertEqualObjects(res2, @"Erlang", @"dec string 'Erlang'");

    uchar b3[] = {106};
    NSString *res3 = otb_dec_string(nsdata(b3, 1));
    STAssertEqualObjects(res3, @"", @"dec empty string");

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

- (void)testEncBinaryString {
    uchar b1[] = {109, 0, 0, 0, 5, 104, 101, 108, 108, 111};
    STAssertEqualObjects(otb_enc_bstr(@"hello"), nsdata(b1, 10), @"enc bstr <<\"hello\">>");

    uchar b2[] = {109, 0, 0, 0, 6, 69, 114, 108, 97, 110, 103};
    STAssertEqualObjects(otb_enc_bstr(@"Erlang"), nsdata(b2, 11), @"enc bstr <<\"Erlang\">>");
}

- (void)testDecBinaryString {
    uchar b1[] = {109, 0, 0, 0, 5, 104, 101, 108, 108, 111};
    NSString *res = otb_dec_bstr(nsdata(b1, 10));
    STAssertEqualObjects(res, @"hello", @"dec bstr <<\"hello\">>");

    uchar b2[] = {109, 0, 0, 0, 6, 69, 114, 108, 97, 110, 103};
    NSString *res2 = otb_dec_bstr(nsdata(b2, 11));
    STAssertEqualObjects(res2, @"Erlang", @"dec bstr <<\"Erlang\">>");
}

- (void)testEncTuple {
    uchar b1[] = {104, 2, 97, 5, 97, 6};
    NSArray *data1 = [NSArray arrayWithObjects:otb_enc_char(5), otb_enc_char(6), nil];
    STAssertEqualObjects(otb_enc_tuple(data1), nsdata(b1, 6), @"enc tuple {5, 6}");

    uchar b2[] = {104, 3, 100, 0, 4, 117, 115, 101, 114, 97, 3, 98, 0, 0, 1, 244};
    NSArray *data2 = [NSArray arrayWithObjects:otb_enc_atom(@"user"), otb_enc_char(3),
                                               otb_enc_long(500), nil];
    STAssertEqualObjects(otb_enc_tuple(data2), nsdata(b2, 16), @"enc tuple {user, 3, 500}");
}

- (void)testDecTuple {
    uchar b1[] = {104, 3, 97, 5, 97, 6, 98, 0, 0, 1, 244};
    NSData *data1 = nsdata(b1, 11);
    NSArray *waitFor1 = [NSArray arrayWithObjects:
            [NSNumber numberWithChar:5],
            [NSNumber numberWithChar:6],
            [NSNumber numberWithLong:500],
            nil];
    DecodedData *res1 = otb_dec_tuple(data1);
    STAssertTrue(res1.binLength == 9, @"res1 binLength");
    STAssertEqualObjects(res1.data, waitFor1, @"dec tuple {5, 6, 500}");

    uchar b2[] = {104, 2, 99, 53, 46, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48,
            48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 101, 45, 48, 49, 0, 0, 0, 0, 0, 97, 10};
    NSData *data2 = nsdata(b2, 36);
    NSArray *waitFor2 = [NSArray arrayWithObjects:
            [NSNumber numberWithDouble:0.5],
            [NSNumber numberWithChar:10],
            nil];
    DecodedData *res2 = otb_dec_tuple(data2);
    STAssertTrue(res2.binLength == 34, @"res2 binLength");
    STAssertEqualObjects(res2.data, waitFor2, @"dec tuple {0.5, 10}");

    uchar b3[] = {104, 4,
            100, 0, 4, 97, 116, 111, 109, // atom 'atom'
            107, 0, 5, 104, 101, 108, 108, 111, // string "hello"
            109, 0, 0, 0, 3, 1, 2, 3, // binary <<1,2,3>>
            97, 10}; // char 10
    uchar bin[] = {1, 2, 3};
    NSData *data3 = nsdata(b3, 27);
    NSArray *waitFor3 = [NSArray arrayWithObjects:
            @"atom", @"hello", nsdata(bin, 3),
            [NSNumber numberWithChar:10],
            nil];
    DecodedData *res3 = otb_dec_tuple(data3);
    STAssertTrue(res3.binLength == 25, @"res3 binLength");
    STAssertEqualObjects(res3.data, waitFor3, @"dec tuple {atom, 'hello', <<1,2,3>>, 10}");

    uchar b4[] = {104, 3, 97, 5, 104, 3, 97, 5, 97, 6, 98, 0, 0, 1, 244, 97, 10};
    NSData *data4 = nsdata(b4, 17);
    NSArray *waitFor4 = [NSArray arrayWithObjects:
            [NSNumber numberWithChar:5],
            res1,
            [NSNumber numberWithChar:10],
            nil];
    DecodedData *res4 = otb_dec_tuple(data4);
    STAssertTrue(res4.binLength == 15, @"res4 binLength");
    STAssertEqualObjects(res4.data, waitFor4, @"dec tuple with inner tuple");

    uchar b5[] = {104, 4, 97, 5, 108, 0, 0, 0, 3, 97, 1, 97, 2, 98, 0, 0, 1, 244, 106,
            97, 10, 97, 20};
    NSData *data5 = nsdata(b5, 23);
    uchar barr[] = {108, 0, 0, 0, 3, 97, 1, 97, 2, 98, 0, 0, 1, 244, 106};
    NSData *dataArr = nsdata(barr, 15);
    NSArray *waitFor5 = [NSArray arrayWithObjects:
            [NSNumber numberWithChar:5],
            otb_dec_list(dataArr),
            [NSNumber numberWithChar:10],
            [NSNumber numberWithChar:20],
            nil];
    DecodedData *res5 = otb_dec_tuple(data5);
    STAssertTrue(res5.binLength == 21, @"res5 binLength");
    STAssertEqualObjects(res5.data, waitFor5, @"dec tuple with inner array");
}

- (void)testEncList {
    uchar b1[] = {108, 0, 0, 0, 3, 97, 1, 97, 2, 98, 0, 0, 1, 244, 106};
    NSArray *data1 = [NSArray arrayWithObjects:otb_enc_char(1), otb_enc_char(2),
                                               otb_enc_long(500), nil];
    STAssertEqualObjects(otb_enc_list(data1), nsdata(b1, 15), @"enc list [1, 2, 500]");

    uchar b2[] = {108, 0, 0, 0, 4, 97, 1, 97, 2, 108, 0, 0, 0, 2, 98, 0, 0, 1, 44,
            98, 0, 0, 1, 244, 106, 97, 3, 106};
    NSArray *inner = [NSArray arrayWithObjects:otb_enc_long(300), otb_enc_long(500), nil];
    NSArray *data2 = [NSArray arrayWithObjects:otb_enc_char(1), otb_enc_char(2),
                                               otb_enc_list(inner), otb_enc_char(3), nil];
    STAssertEqualObjects(otb_enc_list(data2), nsdata(b2, 28), @"enc list [1, 2, [300, 500], 3]");
}

- (void)testDecList {
    uchar b1[] = {108, 0, 0, 0, 4, 97, 5, 106, 97, 6, 98, 0, 0, 1, 244};
    NSData *data1 = nsdata(b1, 15);
    NSArray *waitFor1 = [NSArray arrayWithObjects:
            [NSNumber numberWithChar:5],
            @"",
            [NSNumber numberWithChar:6],
            [NSNumber numberWithLong:500],
            nil];
    DecodedData *res1 = otb_dec_list(data1);
    STAssertTrue(res1.binLength == 10, @"res1 binLength");
    STAssertEqualObjects(res1.data, waitFor1, @"dec list [5, \"\", 6, 500]");

    uchar b2[] = {108, 0, 0, 0, 6,
            100, 0, 4, 97, 116, 111, 109, // atom 'atom'
            107, 0, 5, 104, 101, 108, 108, 111, // string "hello"
            109, 0, 0, 0, 3, 1, 2, 3, // binary <<1,2,3>>
            104, 3, 97, 2, 104, 3, 97, 5, 97, 6, 98, 0, 0, 1, 244, 97, 10, // {2, {5, 6, 500}, 10}
            108, 0, 0, 0, 3, 97, 1, 97, 2, 98, 0, 0, 1, 244, 106, // [1, 2, 500]
            97, 10, // char 10
            106};
    uchar bin[] = {1, 2, 3};
    NSData *data2 = nsdata(b2, 62);

    uchar bTup[] = {104, 3, 97, 2, 104, 3, 97, 5, 97, 6, 98, 0, 0, 1, 244, 97, 10};
    NSData *dataTup = nsdata(bTup, 17);

    uchar barr[] = {108, 0, 0, 0, 3, 97, 1, 97, 2, 98, 0, 0, 1, 244, 106};
    NSData *dataArr = nsdata(barr, 15);

    NSArray *waitFor2 = [NSArray arrayWithObjects:
            @"atom",
            @"hello",
            nsdata(bin, 3),
            otb_dec_tuple(dataTup),
            otb_dec_list(dataArr),
            [NSNumber numberWithChar:10],
            nil];
    DecodedData *res2 = otb_dec_list(data2);
    STAssertTrue(res2.binLength == 57, @"res2 binLength");
    STAssertEqualObjects(res2.data, waitFor2, @"dec complex list");
}

- (void)testSampleObj {
    Sample *item1 = [Sample createWithId:2222 andName:@"Bob" andAge:25];
    NSData *data = [item1 encode];
    Sample *item2 = [Sample createWithData:data];
    STAssertEqualObjects(item1, item2, @"items 1 and 2 should be equal");

    Sample *item3 = [[Sample alloc] init];
    [item3 decode:data];
    STAssertEqualObjects(item1, item3, @"items 1 and 3 should be equal");
    STAssertEqualObjects(item2, item3, @"items 2 and 3 should be equal");
}

- (void)testSampleList {
    Sample *item1 = [Sample createWithId:1 andName:@"Bob" andAge:25];
    Sample *item2 = [Sample createWithId:2 andName:@"Bill" andAge:24];
    Sample *item3 = [Sample createWithId:3 andName:@"Helen" andAge:23];
    Sample *item4 = [Sample createWithId:4 andName:@"" andAge:25];

    SampleList *list1 = [[SampleList alloc] init];
    [list1 addItem:item1];
    [list1 addItem:item2];
    [list1 addItem:item3];
    [list1 addItem:item4];
    NSData *data = [list1 encode];

    SampleList *list2 = [[SampleList alloc] init];
    [list2 decode:data];
    STAssertEqualObjects(list1, list2, @"lists should be equal");
}

- (void)testStrWithZeroBytes {
    // [97, 0, 0] string with 'a' and 2 zero bytes
    // Erlang encodes list [97, 0, 0] this way:
    uchar b1[] = {107, 0, 3, 97, 0, 0};
    NSData *data1 = nsdata(b1, 6);
    NSString *res = otb_dec_string(data1);
    STAssertEqualObjects(res, @"a", @"dec string [97, 0, 0]");

    // {[97, 0, 0], "", "aaa"}
    uchar b2[] = {104, 3, 107, 0, 3, 97, 0, 0, 106, 107, 0, 3, 97, 97, 97};
    NSData *data2 = nsdata(b2, 15);
    NSArray *waitFor = [NSArray arrayWithObjects:@"a", @"", @"aaa", nil];
    DecodedData *res2 = otb_dec_tuple(data2);
    STAssertTrue(res2.binLength == 13, @"res2 binLength");
    STAssertEqualObjects(res2.data, waitFor, @"dec tuple {[97, 0, 0], \"\", \"aaa\"}");
}

@end

