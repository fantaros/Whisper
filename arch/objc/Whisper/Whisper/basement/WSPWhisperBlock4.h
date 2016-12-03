//
//  WhisperBlock.h
//  Whisper
//
//  Created by fantaros on 2016/11/18.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WHISPER_BLOCKSIZE 4

@interface WSPWhisperBlock4 : NSObject

+ (instancetype) whisperBlock4;
+ (instancetype) whisperBlock4WithByte0:(unsigned char) byte0 byte1:(unsigned char) byte1 byte2:(unsigned char) byte2 byte3:(unsigned char) byte3;
+ (instancetype) whisperBlock4WithByteArray:(NSArray *) byteArray;
+ (instancetype) whisperBlock4WithBigByteArray:(NSArray *) bigArray offset:(NSUInteger) offset;

//-(instancetype) initWithByte0:(unsigned char) byte0 byte1:(unsigned char) byte1 byte2:(unsigned char) byte2 byte3:(unsigned char) byte3;
//-(instancetype) initWithByteArray:(NSArray<NSNumber *> *) byteArray;
//-(instancetype) initWithBigByteArray:(NSArray<NSNumber *> *) bigArray offset:(NSUInteger) offset;

- (NSMutableArray *) bytes;

- (void) refreshDataWithBigByteArray:(NSArray *) bigArray offset:(NSUInteger) offset;
- (void) blockSwap:(unsigned char) swaper;
- (void) deBlockSwap:(unsigned char) swaper;
- (void) swapFrom:(NSInteger) from to:(NSInteger) to;
- (NSArray *) acceptByteArray:(NSArray *) output offset:(NSInteger) offset;
- (void) whispingWithOffset:(NSInteger) offset keys:(unsigned char) keys function:(unsigned char) function;

@end
