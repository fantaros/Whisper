//
//  WhisperKey.h
//  Whisper
//
//  Created by fantaros on 2016/11/27.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSPWhisperKeyDeprecated : NSObject

+ (instancetype) whisperKeyWithPassword: (NSString *) password;
+ (instancetype) whisperKeyWithPassword: (NSString *) password keyLength:(NSUInteger) keyLength;

@property (copy, nonatomic) NSArray *WhisperTable;
@property (copy, nonatomic) NSArray *WhisperSwapMagic;
@property (assign, nonatomic) unsigned char keySalt;

- (NSArray *) recook:(NSInteger) outputLength blockSize:(NSUInteger) blockSize;
- (NSArray *) buildSwapArray:(NSUInteger) seed salt:(NSUInteger) salt;

- (unsigned char) calculateSalt:(NSArray *) src;

- (unsigned char) getKey:(NSUInteger) offset;

- (unsigned char) getRing:(NSUInteger) offset;

@end
