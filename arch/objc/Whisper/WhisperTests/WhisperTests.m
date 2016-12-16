//
//  WhisperTests.m
//  WhisperTests
//
//  Created by fantaros on 2016/11/28.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WSPWhisperAlgorithm.h"
#import "WSPWhisperData.h"

@interface WhisperTests : XCTestCase

@end

@implementation WhisperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testWhisperAlgorithm {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    WSPWhisperAlgorithm *algorithm = [WSPWhisperAlgorithm whisperAlgorithmWithBlockSize:3];
//    NSString *dataString = @"这是一段要被加密的测试代码呢。";
//    NSString *dataString = @"习近平祝贺古特雷斯出任下届联合国秘书长，强调中国将坚定支持古特雷斯履行好秘书长工作职责。习近平指出，作为最具普遍性、权威性、代表性的政府间国际组织，联合国在应对全球性挑战中作用不可代替。第二次世界大战结束70多年来，世界实现了总体和平、持续发展的态势，联合国对此功不可没。随着国际形势的发展变化，各国对联合国的期待上升，赞成联合国发挥更大作用。联合国应当旗帜鲜明地维护《联合国宪章》宗旨和原则，积极有为维护国际和平与安全，持之以恒推进共同发展，特别是要落实好2030年可持续发展议程和气候变化《巴黎协定》，照顾发展中国家利益，多为发展中国家发声、办事";
    NSString *dataString = @"qwertyuiopasdfghjklzxcvbnm";
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    WSPWhisperData *inputData = [WSPWhisperData whisperDataWithNoneHeaderData:data];
    if (data != nil) {
        WSPWhisperKey *enkey = [WSPWhisperKey whisperKeyWithPassword:@"fantasy88"];
        WSPWhisperData *outputData = [algorithm encrypt:inputData key:enkey];
        NSLog(@"outputData = %@", [outputData base64String]);
        WSPWhisperData *deinput = [WSPWhisperData whisperDataWithData: [outputData data]];
        WSPWhisperKey *dekey = [WSPWhisperKey whisperKeyWithPassword:@"fantasy88"];
        WSPWhisperData *deoutput = [algorithm decrypt:deinput key:dekey];
        NSString *outStr = [[NSString alloc] initWithData:[deoutput dataWithoutHeader] encoding:NSUTF8StringEncoding];
        NSLog(@"deoutputData = %@", outStr);
        NSLog(@"org = %@", dataString);
        XCTAssertTrue([dataString isEqualToString:outStr]);
    } else {
        XCTAssertTrue(1==2);
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
