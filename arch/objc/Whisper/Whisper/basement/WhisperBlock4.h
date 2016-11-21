//
//  WhisperBlock.h
//  Whisper
//
//  Created by fantaros on 2016/11/18.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WHISPER_BLOCKSIZE 4

@interface WhisperBlock4 : NSObject

-(instancetype) initWithByte0:(unsigned char) byte0 byte1:(unsigned char) byte1 byte2:(unsigned char) byte2 byte3:(unsigned char) byte3;
-(instancetype) initWithByteArray:(NSArray<NSNumber *> *) byteArray;

-(void) blockSwap:(unsigned char) swaper;
-(void) deBlockSwap:(unsigned char) swaper;
-(void) swapFrom:(NSInteger) from to:(NSInteger) to;
-(NSArray<NSNumber *> *) acceptByteArray:(NSArray<NSNumber *> *) output offset:(NSInteger) offset;
-(void) whispingWithOffset:(NSInteger) offset function:(unsigned char) function keys:(unsigned char) keys;

@end
