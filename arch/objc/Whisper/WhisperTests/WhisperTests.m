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

- (void)testWhisperAlgorithm {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    WSPWhisperAlgorithm *algorithm = [WSPWhisperAlgorithm whisperAlgorithm];
    NSString *dataString = @"这是一段要被加密的测试代码呢。";
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    WSPWhisperData *inputData = nil;
    if (data != nil) {
        inputData = [WSPWhisperData whisperDataWithData:data];
    }
    if (inputData != nil) {        
        WSPWhisperKey *key = [WSPWhisperKey whisperKeyWithPassword:@"fantasy88" keyLength:128];
        WSPWhisperData *outputData = [algorithm encrypto:inputData key:key];
        NSLog(@"outputData = %@", outputData.byteArray);
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
