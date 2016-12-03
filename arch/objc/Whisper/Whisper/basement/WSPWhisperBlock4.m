//
//  WhisperBlock.m
//  Whisper
//
//  Created by fantaros on 2016/11/18.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "WSPWhisperBlock4.h"
#import "WSPLogix.h"


@interface WSPWhisperBlock4()

@property (nonatomic, copy) NSMutableArray *bytes;
@property (nonatomic, strong) WSPLogix *logix;

@end

@implementation WSPWhisperBlock4

+ (instancetype) whisperBlock4 {
    return [[WSPWhisperBlock4 alloc] init];
}

+ (instancetype) whisperBlock4WithByte0:(unsigned char) byte0 byte1:(unsigned char) byte1 byte2:(unsigned char) byte2 byte3:(unsigned char) byte3 {
    return [[WSPWhisperBlock4 alloc] initWithByte0:byte0 byte1:byte1 byte2:byte2 byte3:byte3];
}

+ (instancetype) whisperBlock4WithByteArray:(NSArray *) byteArray {
    return [[WSPWhisperBlock4 alloc] initWithByteArray:byteArray];
}

+ (instancetype) whisperBlock4WithBigByteArray:(NSArray *) bigArray offset:(NSUInteger) offset {
    return [[WSPWhisperBlock4 alloc] initWithBigByteArray:bigArray offset:offset];
}

- (NSMutableArray *) bytes {
    if (_bytes == nil) {
        _bytes = [[NSMutableArray alloc] initWithCapacity: WHISPER_BLOCKSIZE];
    }
    return _bytes;
}

- (WSPLogix *) logix {
    if (_logix == nil) {
        _logix = [[WSPLogix alloc] init];
    }
    return _logix;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        [self refreshDataWithByteArray:@[@0,@0,@0,@0]];
    }
    return self;
}

- (instancetype) initWithByte0:(unsigned char) byte0 byte1:(unsigned char) byte1 byte2:(unsigned char) byte2 byte3:(unsigned char) byte3 {
    self = [super init];
    if (self) {
        [self refreshDataWithByteArray: [NSArray arrayWithObjects:[NSNumber numberWithUnsignedChar:byte0], [NSNumber numberWithUnsignedChar:byte1], [NSNumber numberWithUnsignedChar:byte2], [NSNumber numberWithUnsignedChar:byte3], nil]];
    }
    return self;
}

- (instancetype) initWithByteArray:(NSArray *)byteArray {
    self = [super init];
    if (self) {
        [self refreshDataWithByteArray:byteArray];
    }
    return self;
}

- (instancetype) initWithBigByteArray:(NSArray *)bigArray offset:(NSUInteger)offset {
    self = [super init];
    if (self) {
        [self refreshDataWithBigByteArray:bigArray offset:offset];
    }
    return self;
}

- (void) refreshDataWithByteArray:(NSArray *) array {
    [self.bytes removeAllObjects];
    for (NSInteger i = 0; i < WHISPER_BLOCKSIZE; ++i) {
        if (i < array.count) {
            NSNumber *tmp = [array[i] copy];
            [self.bytes addObject: tmp];
        }
    }
}

- (void) refreshDataWithBigByteArray:(NSArray *) bigArray offset:(NSUInteger) offset{
    [self.bytes removeAllObjects];
    for (NSInteger i = 0; i < WHISPER_BLOCKSIZE; ++i) {
        if (i < 4) {
            if ((offset + i) < bigArray.count) {
                NSNumber *tmp = [bigArray[(offset + i)] copy];
                [self.bytes addObject: tmp];
            } else {
                [self.bytes addObject:[NSNumber numberWithUnsignedChar:0]];
            }
        }
    }
}

- (void) blockSwap:(unsigned char) swaper {
    NSMutableArray *newarray = [[NSMutableArray alloc] initWithCapacity: WHISPER_BLOCKSIZE];
    [newarray addObject: [self.bytes[(unsigned char)((swaper & 0xc0) >> 6)] copy]];
    [newarray addObject: [self.bytes[(unsigned char)((swaper & 0x30) >> 4)] copy]];
    [newarray addObject: [self.bytes[(unsigned char)((swaper & 0x0c) >> 2)] copy]];
    [newarray addObject: [self.bytes[swaper & 0x03] copy]];
    [self.bytes removeAllObjects];
    for (NSInteger i = 0; i < newarray.count; ++i) {
        [self.bytes addObject: [newarray[i] copy]];
    }
}

- (void) deBlockSwap:(unsigned char) swaper {
    NSMutableArray *newarray = [[NSMutableArray alloc] initWithCapacity: WHISPER_BLOCKSIZE];
    for (NSInteger i = 0; i < WHISPER_BLOCKSIZE; ++i) {
        [newarray addObject:[NSNumber numberWithInteger: i]];
    }
    newarray[(unsigned char)((swaper & 0xc0) >> 6)] = [self.bytes[0] copy];
    newarray[(unsigned char)((swaper & 0x30) >> 4)] = [self.bytes[1] copy];
    newarray[(unsigned char)((swaper & 0x0c) >> 2)] = [self.bytes[2] copy];
    newarray[(unsigned char)(swaper & 0x03)] = [self.bytes[3] copy];
    [self.bytes removeAllObjects];
    for (NSInteger i = 0; i < newarray.count; ++i) {
        [self.bytes addObject: [newarray[i] copy]];
    }
}

- (void) swapFrom:(NSInteger) from to:(NSInteger) to {
    self.bytes[from] = [NSNumber numberWithUnsignedChar: (unsigned char)([self.bytes[from] unsignedCharValue] ^ [self.bytes[to] unsignedCharValue])];
    self.bytes[to] = [NSNumber numberWithUnsignedChar: (unsigned char)([self.bytes[from] unsignedCharValue] ^ [self.bytes[to] unsignedCharValue])];
    self.bytes[from] = [NSNumber numberWithUnsignedChar: (unsigned char)([self.bytes[from] unsignedCharValue] ^ [self.bytes[to] unsignedCharValue])];
}

- (NSArray *) acceptByteArray:(NSArray *) output offset:(NSInteger) offset {
    NSMutableArray *newOutput = [output mutableCopy];
    for (int i = 0; i < WHISPER_BLOCKSIZE; i++) {
        if (offset + i < output.count) {
            [newOutput insertObject:self.bytes[i] atIndex:offset + i];
        }
    }
    return [newOutput copy];
}

- (void) whispingWithOffset:(NSInteger) offset keys:(unsigned char) keys function:(unsigned char) function  {
    unsigned char opt1 = [[self.bytes objectAtIndex:offset] unsignedCharValue];
    unsigned char result = [self.logix logixWithOperatorByte1:opt1 operatorByte2:keys methodType: function];
    self.bytes[offset] = [NSNumber numberWithUnsignedChar:result];
}

@end
