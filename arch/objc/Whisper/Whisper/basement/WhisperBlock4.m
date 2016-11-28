//
//  WhisperBlock.m
//  Whisper
//
//  Created by fantaros on 2016/11/18.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "WhisperBlock4.h"
#import "Logix.h"


@interface WhisperBlock4()

@property (nonatomic, copy) NSMutableArray *bytes;
@property (nonatomic, strong) Logix *logix;

@end

@implementation WhisperBlock4

+ (instancetype) whisperBlock4WithByte0:(unsigned char) byte0 byte1:(unsigned char) byte1 byte2:(unsigned char) byte2 byte3:(unsigned char) byte3 {
    return [[WhisperBlock4 alloc] initWithByte0:byte0 byte1:byte1 byte2:byte2 byte3:byte3];
}

+ (instancetype) whisperBlock4WithByteArray:(NSArray<NSNumber *> *) byteArray {
    return [[WhisperBlock4 alloc] initWithByteArray:byteArray];
}

+ (instancetype) whisperBlock4WithBigByteArray:(NSArray<NSNumber *> *) bigArray offset:(NSUInteger) offset {
    return [[WhisperBlock4 alloc] initWithBigByteArray:bigArray offset:offset];
}

- (NSMutableArray *) bytes {
    if (_bytes == nil) {
        _bytes = [[NSMutableArray alloc] initWithCapacity: WHISPER_BLOCKSIZE];
    }
    return _bytes;
}

- (Logix *) logix {
    if (_logix == nil) {
        _logix = [[Logix alloc] init];
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

- (instancetype) initWithByteArray:(NSArray<NSNumber *> *)byteArray {
    self = [super init];
    if (self) {
        [self refreshDataWithByteArray:byteArray];
    }
    return self;
}

- (instancetype) initWithBigByteArray:(NSArray<NSNumber *> *)bigArray offset:(NSUInteger)offset {
    self = [super init];
    if (self) {
        [self refreshDataWithBigByteArray:bigArray offset:offset];
    }
    return self;
}

- (void) refreshDataWithByteArray:(NSArray<NSNumber *> *) array {
    [self.bytes removeAllObjects];
    for (NSInteger i = 0; i < WHISPER_BLOCKSIZE; ++i) {
        if (i < array.count) {
            [self.bytes addObject:array[i]];
        }
    }
}

- (void) refreshDataWithBigByteArray:(NSArray<NSNumber *> *) bigArray offset:(NSUInteger) offset{
    [self.bytes removeAllObjects];
    for (NSInteger i = 0; i < WHISPER_BLOCKSIZE; ++i) {
        if (i < 4) {
            [self.bytes addObject:bigArray[offset + i]];
        }
    }
}

- (void) blockSwap:(unsigned char) swaper {
    NSMutableArray *newarray = [[NSMutableArray alloc] initWithCapacity: WHISPER_BLOCKSIZE];
    [newarray addObject: self.bytes[(unsigned char)((swaper & 0xc0) >> 6)]];
    [newarray addObject: self.bytes[(unsigned char)((swaper & 0x30) >> 4)]];
    [newarray addObject: self.bytes[(unsigned char)((swaper & 0x0c) >> 2)]];
    [newarray addObject: self.bytes[swaper & 0x03]];
    _bytes = [newarray copy];
}

- (void) deBlockSwap:(unsigned char) swaper {
    NSMutableArray *newarray = [[NSMutableArray alloc] initWithCapacity: WHISPER_BLOCKSIZE];
    for (NSInteger i = 0; i < WHISPER_BLOCKSIZE; ++i) {
        [newarray addObject:[NSNumber numberWithInteger: i]];
    }
    newarray[(unsigned char)((swaper & 0xc0) >> 6)] = self.bytes[0];
    newarray[(unsigned char)((swaper & 0x30) >> 4)] = self.bytes[1];
    newarray[(unsigned char)((swaper & 0x0c) >> 2)] = self.bytes[2];
    newarray[(unsigned char)(swaper & 0x03)] = self.bytes[3];
    self.bytes = [newarray copy];
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
            [newOutput insertObject:_bytes[i] atIndex:offset + i];
        }
    }
    return [newOutput copy];
}

- (void) whispingWithOffset:(NSInteger) offset function:(unsigned char) function keys:(unsigned char) keys{
    self.bytes[offset] = [NSNumber numberWithUnsignedChar: [self.logix logixWithOperatorByte1:[self.bytes[offset] unsignedCharValue] operatorByte2:keys methodType: function]];
}

@end
