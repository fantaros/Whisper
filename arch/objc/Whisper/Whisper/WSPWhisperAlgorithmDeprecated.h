//
//  WhisperAlogrithm.h
//  Whisper
//
//  Created by fantaros on 2016/11/21.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSPWhisperData.h"
#import "WSPWhisperKeyDeprecated.h"

@interface WSPWhisperAlgorithmDeprecated : NSObject

+ (instancetype) whisperAlgorithm OBJC_DEPRECATED("DEPRECATED since Whisper 3.0");

- (WSPWhisperData *) encryptWithBlockSize4:(WSPWhisperData *)baseData key:(WSPWhisperKeyDeprecated *) password OBJC_DEPRECATED("DEPRECATED since Whisper 3.0");
- (WSPWhisperData *) decryptWithBlockSize4:(WSPWhisperData *)baseData key:(WSPWhisperKeyDeprecated *) password OBJC_DEPRECATED("DEPRECATED since Whisper 3.0");

@end
