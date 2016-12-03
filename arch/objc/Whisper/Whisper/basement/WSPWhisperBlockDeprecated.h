//
//  WhisperBlock.h
//  Whisper
//
//  Created by fantaros on 2016/11/18.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WHISPER_BLOCKSIZE 4

@interface WSPWhisperBlockDeprecated : NSObject

+ (instancetype) whisperBlock4 OBJC_DEPRECATED("DEPRECATED since Whisper 3.0");
+ (instancetype) whisperBlock4WithByte0:(unsigned char) byte0 byte1:(unsigned char) byte1 byte2:(unsigned char) byte2 byte3:(unsigned char) byte3 OBJC_DEPRECATED("DEPRECATED since Whisper 3.0");
+ (instancetype) whisperBlock4WithByteArray:(NSArray *) byteArray OBJC_DEPRECATED("DEPRECATED since Whisper 3.0");
+ (instancetype) whisperBlock4WithBigByteArray:(NSArray *) bigArray offset:(NSUInteger) offset OBJC_DEPRECATED("DEPRECATED since Whisper 3.0");

- (NSMutableArray *) bytes OBJC_DEPRECATED("DEPRECATED since Whisper 3.0");

- (void) refreshDataWithBigByteArray:(NSArray *) bigArray offset:(NSUInteger) offset OBJC_DEPRECATED("DEPRECATED since Whisper 3.0");
- (void) blockSwap:(unsigned char) swaper OBJC_DEPRECATED("DEPRECATED since Whisper 3.0");
- (void) deBlockSwap:(unsigned char) swaper OBJC_DEPRECATED("DEPRECATED since Whisper 3.0");
- (void) swapFrom:(NSInteger) from to:(NSInteger) to OBJC_DEPRECATED("DEPRECATED since Whisper 3.0");
- (NSArray *) acceptByteArray:(NSArray *) output offset:(NSInteger) offset OBJC_DEPRECATED("DEPRECATED since Whisper 3.0");
- (void) whispingWithOffset:(NSInteger) offset keys:(unsigned char) keys function:(unsigned char) function OBJC_DEPRECATED("DEPRECATED since Whisper 3.0");

@end
