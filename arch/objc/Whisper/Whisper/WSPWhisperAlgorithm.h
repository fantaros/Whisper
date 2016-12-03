//
//  WhisperAlogrithm.h
//  Whisper
//
//  Created by fantaros on 2016/11/21.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSPWhisperData.h"
#import "WSPWhisperKey.h"

#define WHISPER_DEFAULT_BLOCKSIZE 3

@interface WSPWhisperAlgorithm : NSObject

+ (instancetype) whisperAlgorithm;
+ (instancetype) whisperAlgorithmWithBlockSize:(NSUInteger) blockSize;

//Whisper加密
- (WSPWhisperData *) encrypt:(WSPWhisperData *)baseData key:(WSPWhisperKey *) password;
//Whisper解密
- (WSPWhisperData *) decrypt:(WSPWhisperData *)baseData key:(WSPWhisperKey *) password;

@end
