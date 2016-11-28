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

@interface WSPWhisperAlogrithm : NSObject

- (WSPWhisperData *) encrypto:(WSPWhisperData *)baseData key:(WSPWhisperKey *) password;

- (WSPWhisperData *) decrypto:(WSPWhisperData *)baseData key:(WSPWhisperKey *) password;

@end
