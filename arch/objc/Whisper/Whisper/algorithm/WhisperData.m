//
//  WhisperDataSequence.m
//  Whisper
//
//  Created by fantaros on 2016/11/27.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "WhisperData.h"

@interface WhisperData ()

@property (strong, nonatomic) NSMutableArray *byteArray;

@end

@implementation WhisperData

@synthesize byteArray = _byteArray;

+ (instancetype) whisperData {
    return [[WhisperData alloc] init];
}

+ (instancetype) whisperDataWithCapacity:(NSUInteger) capacity {
    return [[WhisperData alloc] init];
}

+ (instancetype) whisperDataWithUnsignedCharArray:(NSArray *)array {
    return [[WhisperData alloc] initWithArray:array];
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

- (void) addNumber:(NSNumber *) number {
    if (number != nil) {
        [self.byteArray addObject:[NSNumber numberWithUnsignedChar: [number unsignedCharValue]]];
    }
}

- (void) acceptByteArray:(NSArray *)byteArray startOffset:(NSUInteger) offset {
    for (NSInteger i = 0; i < 4; ++i) {
        [self setNumber:[byteArray[i] copy] offset:offset + i];
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

- (unsigned char) unsignedCharValueAtIndex:(NSUInteger) offset {
    if (offset < [self dataLength]) {
        return [[self.byteArray objectAtIndex:offset] unsignedCharValue];
    }
    return 0;
}

@end
