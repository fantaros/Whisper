//
//  WhisperBlock.h
//  Whisper
//
//  Created by fantaros on 2016/11/18.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSPWhisperKey.h"

@interface WSPWhisperBlock : NSObject

+ (instancetype) whisperBlock:(NSUInteger)blockSize;
+ (instancetype) whisperBlockWithByteArray:(NSArray *) array offset:(NSUInteger) offset blockSize:(NSUInteger)blockSize;

- (NSMutableArray *) bytes;

//添加新的分组
- (void) refreshDataWithBigByteArray:(NSArray *) bigArray offset:(NSUInteger) offset;
//分组交换-正向
- (void) blockSwapWithKey:(WSPWhisperKey *)key salt:(NSUInteger) salt;
//分组交换-反向
- (void) deBlockSwapWithKey:(WSPWhisperKey *)key salt:(NSUInteger) salt;
//whisping映射方法
- (void) whispingOnOffset:(NSInteger) offset keys:(unsigned char) keys function:(unsigned char) function;

@end
