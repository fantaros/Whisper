//
//  WhisperDataSequence.h
//  Whisper
//
//  Created by fantaros on 2016/11/27.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSPWhisperKey.h"

@interface WSPWhisperData : NSObject

+ (instancetype) whisperData;
+ (instancetype) whisperDataWithData:(NSData *)data;
+ (instancetype) whisperDataWithNoneHeaderData:(NSData *)data;
+ (instancetype) whisperDataWithCapacity:(NSUInteger) capacity;
+ (instancetype) whisperDataWithUnsignedCharArray:(NSArray *)array;

@property (strong, class, nonatomic, readonly) NSCharacterSet *chiperAllowedCharsets;

- (NSMutableArray *) byteArray;
- (void) setByteArray:(NSMutableArray *)byteArray;

//清除明文中的盐分
- (void) lightDataWithSalt:(unsigned char) salt;

- (void) setUnsignedCharValue:(unsigned char) value offset:(NSUInteger) offset;
- (void) addUnsignedCharValue:(unsigned char) value;

- (void) setNumber:(NSNumber *) number offset:(NSUInteger) offset;
- (void) addNumber:(NSNumber *) number;

//分组加密完成后回写输出字符流
- (void) acceptByteArray:(NSArray *)byteArray startOffset:(NSUInteger) offset blockSize:(NSUInteger) blockSize;
//分组解密完成后回写输出字符流
- (void) deAcceptByteArray:(NSArray *)byteArray startOffset:(NSUInteger) offset blockSize:(NSUInteger) blockSize;

- (void) insertResultData:(NSArray *)array atIndexes:(NSIndexSet *)indexes;

- (NSInteger) dataLength;
- (NSInteger) dataLengthWithoutHeader;

- (unsigned char) unsignedCharValueAtIndex:(NSUInteger) offset;

- (void) resumeFromBlockArray:(NSArray *)blockArray;

//获得NSData数据对象
- (NSData *) data;
//解码加密头部数据
- (NSUInteger) decodeHeader;
//获得去除加密头部信息的NSData数据对象
- (NSData *) dataWithoutHeader;
//获得base64编码表示的结果
- (NSString *) base64String;

//将数据转换成字符串（仅在数据对象保持的是明文且NSData对象对应UTF8字符串时才能成功转换）
- (NSString *) decodeToUTF8String;

//将数据转换成字符串（仅在数据对象保持的是明文且NSData对象对应字符串时才能成功转换）
- (NSString *) decodeToString:(NSStringEncoding *)encoding;

@end
