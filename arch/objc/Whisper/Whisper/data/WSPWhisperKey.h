//
//  WhisperKey.h
//  Whisper
//
//  Created by fantaros on 2016/11/27.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSPWhisperKey : NSObject

+ (instancetype) whisperKeyWithPassword: (NSString *) password;
+ (instancetype) whisperKeyWithPassword: (NSString *) password keyLength:(NSUInteger) keyLength;

@property (copy, nonatomic) NSArray *WhisperTable;
@property (copy, nonatomic) NSArray *WhisperSwapMagic;
//密钥整体的盐°
@property (assign, nonatomic) unsigned char keySalt;

//利用明文的信息对key再构造，并返回结构转换数组
- (NSArray *) recook:(NSInteger) outputLength blockSize:(NSUInteger) blockSize;
//输出乱序排列数组
- (NSArray *) buildSwapArray:(NSUInteger) seed salt:(NSUInteger) salt;

//计算某个字节数组的盐°
- (unsigned char) calculateSalt:(NSArray *) src;

//获得offset位置的密钥
- (unsigned char) getKey:(NSUInteger) offset;
//获得offset位置的已加工密钥
- (unsigned char) getRing:(NSUInteger) offset;

@end
