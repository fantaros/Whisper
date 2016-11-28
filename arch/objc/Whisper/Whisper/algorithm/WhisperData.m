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

- (instancetype) initWithArray:(NSArray *)array {
    self = [super init];
    if (self){
        _byteArray = [array mutableCopy];
    }
    return self;
}

- (void) addUnsignedCharValue:(unsigned char) value {
    [self.resultData addObject:[NSNumber numberWithUnsignedChar:value]];
}

- (void) addNumber:(NSNumber *) number {
    if (number != nil) {
        [self.resultData addObject:[NSNumber numberWithUnsignedChar: [number unsignedCharValue]]];
    }
}

- (void) insertResultData:(NSArray *)array atIndexes:(NSIndexSet *)indexes {
    if (array != nil && indexes != nil) {
        [self.resultData insertObjects:array atIndexes:indexes];
    }
}

- (NSInteger) dataLength {
    return self.resultData.count != NSNotFound ? self.resultData.count : -1;
}

- (unsigned char) unsignedCharValueAtIndex:(NSUInteger) offset {
    if (offset < [self dataLength]) {
        return [[self.resultData objectAtIndex:offset] unsignedCharValue];
    }
    return 0;
}

@end
