//
//  WhisperDataSequence.m
//  Whisper
//
//  Created by fantaros on 2016/11/27.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "WSPWhisperData.h"
#import "GTMBase64.h"

@interface WSPWhisperData ()

@property (strong, nonatomic) NSMutableArray *byteArray;

@end

@implementation WSPWhisperData

+ (NSCharacterSet *) chiperAllowedCharsets {
    return [NSCharacterSet characterSetWithCharactersInString:
            @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"];
}

@synthesize byteArray = _byteArray;

+ (instancetype) whisperData {
    return [[WSPWhisperData alloc] init];
}

+ (instancetype) whisperDataWithData:(NSData *)data {
    return [[WSPWhisperData alloc] initWithData:data];
}

+ (instancetype) whisperDataWithNoneHeaderData:(NSData *)data {
    return [[WSPWhisperData alloc] initWithNoneHeaderData:data];
}

+ (instancetype) whisperDataWithCapacity:(NSUInteger) capacity {
    return [[WSPWhisperData alloc] initWithCapacity:capacity];
}

+ (instancetype) whisperDataWithUnsignedCharArray:(NSArray *)array {
    return [[WSPWhisperData alloc] initWithArray:array];
}

- (NSMutableArray *) byteArray {
    if (_byteArray == nil) {
        _byteArray = [[NSMutableArray alloc] init];
    }
    return _byteArray;
}

- (void) setByteArray:(NSMutableArray *)byteArray {
    if (byteArray != nil) {
        _byteArray = byteArray;
    }
}

//清除明文中的盐分
- (void) lightDataWithSalt:(unsigned char) salt {
    if (_byteArray.count > 0) {
        for (NSInteger i = 0; i < _byteArray.count; ++i) {
            unsigned char byteData = [_byteArray[i] unsignedCharValue];
            _byteArray[i] = [NSNumber numberWithUnsignedChar:(byteData ^ salt)];
        }
    }
}

- (instancetype) init {
    self = [super init];
    if (self){
        _byteArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype) initWithData:(NSData *)data {
    self = [super init];
    if (self){
        _byteArray = [[NSMutableArray alloc] init];
        if (data != nil) {
            unsigned char tmpData[data.length];
            [data getBytes:tmpData length:data.length];
            for (NSInteger i = 0; i < data.length; ++i) {
                [_byteArray addObject:[NSNumber numberWithUnsignedChar:tmpData[i]]];
            }
        }
    }
    return self;
}

- (instancetype) initWithNoneHeaderData:(NSData *)data {
    self = [super init];
    if (self){
        _byteArray = [[NSMutableArray alloc] init];
        if (data != nil) {
            NSUInteger length = data.length;
            unsigned char tmpData[length];
            [data getBytes:tmpData length:length];
            unsigned char byte0 = (unsigned char)((unsigned char)(((length & 0xff000000)>>24) & 0xff) ^ ((unsigned char)'w'));
            unsigned char byte1 = (unsigned char)((unsigned char)(((length & 0x00ff0000)>>16) & 0xff) ^ ((unsigned char)'s'));
            unsigned char byte2 = (unsigned char)((unsigned char)(((length & 0x0000ff00)>>8) & 0xff) ^ ((unsigned char)'p'));
            unsigned char byte3 = (unsigned char)((unsigned char)((length & 0x000000ff) & 0xff) ^ ((unsigned char)'f'));
            [_byteArray addObject:[NSNumber numberWithUnsignedChar:byte1]];
            [_byteArray addObject:[NSNumber numberWithUnsignedChar:byte3]];
            [_byteArray addObject:[NSNumber numberWithUnsignedChar:byte0]];
            [_byteArray addObject:[NSNumber numberWithUnsignedChar:byte2]];
            for (NSInteger i = 0; i < length; ++i) {
                [_byteArray addObject:[NSNumber numberWithUnsignedChar:tmpData[i]]];
            }
        }
    }
    return self;
}

- (instancetype) initWithCapacity:(NSUInteger) capacity {
    self = [super init];
    if (self) {
        _byteArray = [[NSMutableArray alloc] initWithCapacity:capacity];
        for (NSInteger i = 0; i < capacity; ++i) {
            _byteArray[i] = [NSNumber numberWithInt:0];
        }
    }
    return self;
}

- (instancetype) initWithArray:(NSArray *)array {
    self = [super init];
    if (self){
        _byteArray = [array mutableCopy];
    }
    return self;
}

- (void) setUnsignedCharValue:(unsigned char) value offset:(NSUInteger) offset {
    if (offset < [self dataLength]) {
        self.byteArray[offset] = [NSNumber numberWithUnsignedChar:offset];
    }
}

- (void) addUnsignedCharValue:(unsigned char) value {
    [self.byteArray addObject:[NSNumber numberWithUnsignedChar:value]];
}

- (void) setNumber:(NSNumber *) number offset:(NSUInteger) offset {
    if (offset < [self dataLength]) {
        self.byteArray[offset] = [number copy];
    }
}

- (void) setNumber:(NSNumber *) number atIndexedSubscript:(NSUInteger) index {
    if (number != nil) {
        [self.byteArray setObject:[number copy] atIndexedSubscript:index];
    }
}

- (void) addNumber:(NSNumber *) number {
    if (number != nil) {
        [self.byteArray addObject:[NSNumber numberWithUnsignedChar: [number unsignedCharValue]]];
    }
}

//分组加密完成后回写输出字符流
- (void) acceptByteArray:(NSArray *)byteArray startOffset:(NSUInteger) offset blockSize:(NSUInteger) blockSize {
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndexesInRange:NSMakeRange(offset, blockSize)];
    [self insertResultData:byteArray atIndexes:set];
}

//分组解密完成后回写输出字符流
- (void) deAcceptByteArray:(NSArray *)byteArray startOffset:(NSUInteger) offset  blockSize:(NSUInteger) blockSize {
    for (NSInteger i = 0; i < blockSize; ++i) {
        [self setNumber:byteArray[i] atIndexedSubscript:(offset + i)];
    }
}

- (void) insertResultData:(NSArray *)array atIndexes:(NSIndexSet *)indexes {
    if (array != nil && indexes != nil) {
        [self.byteArray insertObjects:array atIndexes:indexes];
    }
}

- (NSInteger) dataLength {
    return self.byteArray.count != NSNotFound ? self.byteArray.count : -1;
}

- (NSInteger) dataLengthWithoutHeader {
    return self.byteArray.count != NSNotFound ? (self.byteArray.count - 4) : -1;
}

- (unsigned char) unsignedCharValueAtIndex:(NSUInteger) offset {
    if (offset < [self dataLength]) {
        return [[self.byteArray objectAtIndex:offset] unsignedCharValue];
    }
    return 0;
}

- (void) resumeFromBlockArray:(NSArray *)blockArray {
    if (blockArray.count > 0) {
        NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:_byteArray.count];
        for (NSInteger i = 0; i < _byteArray.count; ++i) {
            newArray [i] = [NSNumber numberWithInt:0];
        }
        NSUInteger offset = 0;
        for (NSInteger i = 0; i < blockArray.count; ++i) {
            NSUInteger location = [blockArray[i] unsignedIntegerValue] * 4;
            newArray[location] = [_byteArray[offset] copy];
            newArray[location + 1] = [_byteArray[offset + 1] copy];
            newArray[location + 2] = [_byteArray[offset + 2] copy];
            newArray[location + 3] = [_byteArray[offset + 3] copy];
            offset = offset + 4;
        }
        _byteArray = newArray;
    }
}

//获得NSData数据对象
- (NSData *) data {
    if (self.byteArray.count > 0) {
        NSMutableData *data = [[NSMutableData alloc] initWithCapacity:self.byteArray.count];
        unsigned char datatmp[self.byteArray.count];
        for (NSInteger i = 0; i < self.byteArray.count; ++i) {
            unsigned char value = [self.byteArray[i] unsignedCharValue];
            datatmp[i] = value;
        }
        [data appendBytes:datatmp length:self.byteArray.count];
        return [data copy];
    }
    return nil;
}

//解码加密头部数据
- (NSUInteger) decodeHeader {
    NSUInteger i0 = ([self.byteArray[2] unsignedCharValue] ^ ((unsigned char)'w')) << 24;
    NSUInteger i1 = ([self.byteArray[0] unsignedCharValue] ^ ((unsigned char)'s')) << 16;
    NSUInteger i2 = ([self.byteArray[3] unsignedCharValue] ^ ((unsigned char)'p')) << 8;
    NSUInteger i3 = ([self.byteArray[1] unsignedCharValue] ^ ((unsigned char)'f'));
    NSUInteger length = (i0 | i1 | i2 | i3);
    if (length > _byteArray.count) {
        return _byteArray.count;
    }
    return length;
}

//获得去除加密头部信息的NSData数据对象
- (NSData *) dataWithoutHeader {
    if (self.byteArray.count > 0) {
        NSUInteger orgLength = [self decodeHeader];
        if (orgLength > self.byteArray.count - 4 || orgLength < 1) {
            orgLength = self.byteArray.count - 4;
        }
        NSMutableData *data = [[NSMutableData alloc] initWithCapacity:orgLength];
        unsigned char datatmp[orgLength];
        for (NSInteger i = 0; i < orgLength; ++i) {
            unsigned char value = [self.byteArray[(i + 4)] unsignedCharValue];
            datatmp[i] = value;
        }
        [data appendBytes:datatmp length:orgLength];
        return [data copy];
    }
    return nil;
}

//数据以base64编码表示的结果
- (NSString *) base64String {
    if (self.byteArray.count > 0) {
        NSData *data = [self data];
        if (data != nil) {
            NSString *base64 = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
            return [base64 stringByAddingPercentEncodingWithAllowedCharacters:WSPWhisperData.chiperAllowedCharsets];
        }
    }
    return nil;
}

//将数据转换成字符串（仅在数据对象保持的是明文且NSData对象对应UTF8字符串时才能成功转换）
- (NSString *) decodeToUTF8String {
    return [[NSString alloc] initWithData:[self dataWithoutHeader] encoding:NSUTF8StringEncoding];
}

//将数据转换成字符串（仅在数据对象保持的是明文且NSData对象对应字符串时才能成功转换）
- (NSString *) decodeToString:(NSStringEncoding *)encoding {
    if (encoding == nil) {
        encoding = NSUTF8StringEncoding;
    }
    return [[NSString alloc] initWithData:[self dataWithoutHeader] encoding:encoding];
}

@end
