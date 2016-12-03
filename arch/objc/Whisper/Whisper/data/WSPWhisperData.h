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

- (void) setUnsignedCharValue:(unsigned char) value offset:(NSUInteger) offset;
- (void) addUnsignedCharValue:(unsigned char) value;

- (void) setNumber:(NSNumber *) number offset:(NSUInteger) offset;
- (void) addNumber:(NSNumber *) number;

- (void) acceptByteArray:(NSArray *)byteArray startOffset:(NSUInteger) offset;

- (void) insertResultData:(NSArray *)array atIndexes:(NSIndexSet *)indexes;

- (NSInteger) dataLength;
- (NSInteger) dataLengthWithoutHeader;

- (unsigned char) unsignedCharValueAtIndex:(NSUInteger) offset;

- (NSData *) data;
- (NSUInteger) decodeHeader;
- (NSData *) dataWithoutHeader;
- (NSString *) base64String;
- (NSString *) decodeToString;
//- (NSString *) base64StringWithoutHeader;

@end
