//
//  WhisperAlogrithm.h
//  Whisper
//
//  Created by fantaros on 2016/11/21.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhisperData.h"
#import "WhisperKey.h"

@interface WhisperAlogrithm : NSObject

- (WhisperData *) encrypto:(WhisperData *)baseData key:(WhisperKey *) password;

- (WhisperData *) decrypto:(WhisperData *)baseData key:(WhisperKey *) password;

@end
