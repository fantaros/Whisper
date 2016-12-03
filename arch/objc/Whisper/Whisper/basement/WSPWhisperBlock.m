//
//  WhisperBlock.m
//  Whisper
//
//  Created by fantaros on 2016/11/18.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "WSPWhisperBlock.h"
#import "WSPLogix.h"


@interface WSPWhisperBlock()

@property (nonatomic, copy) NSMutableArray *bytes;
@property (nonatomic, assign) NSUInteger blockSize;
@property (nonatomic, strong) WSPLogix *logix;

@end

@implementation WSPWhisperBlock

+ (instancetype) whisperBlock:(NSUInteger) blockSize {
    return [[WSPWhisperBlock alloc] initWithBlockSize:blockSize];
}

+ (instancetype) whisperBlockWithByteArray:(NSArray *) array offset:(NSUInteger) offset blockSize:(NSUInteger)blockSize {
    return [[WSPWhisperBlock alloc] initWithByteArray:array offset:offset blockSize:blockSize];
}

- (NSMutableArray *) bytes {
    if (_bytes == nil) {
        _bytes = [[NSMutableArray alloc] initWithCapacity:self.blockSize];
    }
    return _bytes;
}

- (WSPLogix *) logix {
    if (_logix == nil) {
        _logix = [[WSPLogix alloc] init];
    }
    return _logix;
}

- (instancetype) initWithBlockSize:(NSUInteger) blockSize {
    self = [super init];
    if (self) {
        self.blockSize = blockSize;
    }
    return self;
}

- (instancetype) initWithByteArray:(NSArray *) array offset:(NSUInteger) offset blockSize:(NSUInteger)blockSize {
    self = [super init];
    if (self) {
        self.blockSize = blockSize;
        [self refreshDataWithBigByteArray:array offset:offset];
    }
    return self;
}

- (void) refreshDataWithByteArray:(NSArray *) array {
    [self.bytes removeAllObjects];
    for (NSInteger i = 0; i < self.blockSize; ++i) {
        if (i < array.count) {
            NSNumber *tmp = [array[i] copy];
            [self.bytes addObject: tmp];
        }
    }
}

//添加新的分组
- (void) refreshDataWithBigByteArray:(NSArray *) array offset:(NSUInteger) offset{
    [self.bytes removeAllObjects];
    for (NSInteger i = 0; i < self.blockSize; ++i) {
        if ((offset + i) < array.count) {
            NSNumber *tmp = [array[(offset + i)] copy];
            [self.bytes addObject: tmp];
        } else {
            [self.bytes addObject:[NSNumber numberWithUnsignedChar:0]];
        }
    }
}

//分组交换-正向
- (void) blockSwapWithKey:(WSPWhisperKey *)key salt:(NSUInteger) salt {
    NSArray *swapArray = [key buildSwapArray:self.blockSize salt:salt];
    unsigned char tmp;
    NSUInteger location = 0;
    for (NSInteger o = 0; o < swapArray.count; ++o) {
        NSUInteger offset = [swapArray[o] unsignedIntegerValue];
        tmp = [self.bytes[location] unsignedCharValue];
        self.bytes[location] = [self.bytes[offset] copy];
        self.bytes[offset] = [NSNumber numberWithUnsignedChar:tmp];
        ++location;
    }
}

//数组反转
- (NSArray *) reverseSwapArray:(NSArray *) swapArray {
    if (swapArray == nil) {
        return nil;
    }
    NSMutableArray *anti = [[NSMutableArray alloc] initWithArray:swapArray];
    NSInteger start = 0, end = swapArray.count - 1;
    while (start < end) {
        NSNumber *tmp = anti[start];
        anti[start] = anti[end];
        anti[end] = tmp;
        
        ++start;
        --end;
    }
    return anti;
}

//分组交换-反向
- (void) deBlockSwapWithKey:(WSPWhisperKey *)key salt:(NSUInteger) salt {
    NSArray *swapArray = [key buildSwapArray:self.blockSize salt:salt];
    swapArray = [self reverseSwapArray:swapArray];
    unsigned char tmp;
    NSUInteger location = swapArray.count - 1;
    for (NSInteger o = 0; (o < swapArray.count && location >= 0); ++o) {
        NSUInteger offset = [swapArray[o] unsignedIntegerValue];
        tmp = [self.bytes[location] unsignedCharValue];
        self.bytes[location] = [self.bytes[offset] copy];
        self.bytes[offset] = [NSNumber numberWithUnsignedChar:tmp];
        --location;
    }
}

//whisping映射方法
- (void) whispingOnOffset:(NSInteger) offset keys:(unsigned char) keys function:(unsigned char) function  {
    unsigned char opt1 = [[self.bytes objectAtIndex:offset] unsignedCharValue];
    unsigned char result = [self.logix logixWithOperatorByte1:opt1 operatorByte2:keys methodType: function];
    self.bytes[offset] = [NSNumber numberWithUnsignedChar:result];
}

@end
