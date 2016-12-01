//
//  WhisperDataSequence.m
//  Whisper
//
//  Created by fantaros on 2016/11/27.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "WSPWhisperData.h"

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

+ (instancetype) whisperDataWithCapacity:(NSUInteger) capacity {
    return [[WSPWhisperData alloc] init];
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

- (instancetype) initWithCapacity:(NSUInteger) capacity {
    self = [super init];
    if (self) {
        _byteArray = [[NSMutableArray alloc] initWithCapacity:capacity];
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

- (void) acceptByteArray:(NSArray *)byteArray startOffset:(NSUInteger) offset {
//    for (NSInteger i = 0; i < 4; ++i) {
//        [self setNumber:byteArray[i] atIndexedSubscript:(offset + i)];
//    }
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndexesInRange:NSMakeRange(offset, 4)];
    [self insertResultData:byteArray atIndexes:set];
}

- (void) insertResultData:(NSArray *)array atIndexes:(NSIndexSet *)indexes {
    if (array != nil && indexes != nil) {
        [self.byteArray insertObjects:array atIndexes:indexes];
    }
}

- (NSInteger) dataLength {
    return self.byteArray.count != NSNotFound ? self.byteArray.count : -1;
}

- (unsigned char) unsignedCharValueAtIndex:(NSUInteger) offset {
    if (offset < [self dataLength]) {
        return [[self.byteArray objectAtIndex:offset] unsignedCharValue];
    }
    return 0;
}

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

- (NSString *) base64String {
    if (self.byteArray.count > 0) {
        NSData *data = [self data];
        if (data != nil) {
            return [[self base64EncodedStringWithData:data] stringByAddingPercentEncodingWithAllowedCharacters:WSPWhisperData.chiperAllowedCharsets];
        }
    }
    return nil;
}

- (NSString *) base64EncodedStringWithData:(NSData *)data {
    //ensure wrapWidth is a multiple of 4
    NSUInteger wrapWidth = (0 / 4) * 4;
    
    const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    long long inputLength = [data length];
    const unsigned char *inputBytes = [data bytes];
    
    long long maxOutputLength = (inputLength /3 + 1) * 4;
    maxOutputLength += wrapWidth? (maxOutputLength / wrapWidth) *2: 0;
    unsigned char *outputBytes = (unsigned char *)malloc(maxOutputLength);
    
    long long i;
    long long outputLength =0;
    for (i = 0; i < inputLength -2; i += 3) {
        outputBytes[outputLength++] = lookup[(inputBytes[i] &0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] &0x03) << 4) | ((inputBytes[i +1] & 0xF0) >>4)];
        outputBytes[outputLength++] = lookup[((inputBytes[i +1] & 0x0F) <<2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[i +2] & 0x3F];
        
        //add line break
        if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0) {
            outputBytes[outputLength++] ='\r';
            outputBytes[outputLength++] ='\n';
        }
    }
    
    //handle left-over data
    if (i == inputLength - 2) {
        // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] &0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] &0x03) << 4) | ((inputBytes[i +1] & 0xF0) >>4)];
        outputBytes[outputLength++] = lookup[(inputBytes[i +1] & 0x0F) <<2];
        outputBytes[outputLength++] =  '=';
    } else if (i == inputLength -1) {
        // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] &0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[i] &0x03) << 4];
        outputBytes[outputLength++] ='=';
        outputBytes[outputLength++] ='=';
    }
    
    //truncate data to match actual output length
    outputBytes =realloc(outputBytes, outputLength);
    NSString *result = [[NSString alloc] initWithBytesNoCopy:outputBytes length:outputLength encoding:NSUTF8StringEncoding freeWhenDone:YES];
    
#if !__has_feature(objc_arc)
    [result autorelease];
#endif
    
    return (outputLength >= 4)? result: nil;
}

@end
