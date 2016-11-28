//
//  WhisperAlogrithm.m
//  Whisper
//
//  Created by fantaros on 2016/11/21.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "WhisperAlogrithm.h"
#import "WhisperBlock4.h"

@interface WhisperAlogrithm ()

@property (strong, nonatomic) WhisperBlock4 *block;

@end

@implementation WhisperAlogrithm



- (WhisperData *) encrypto:(WhisperData *)baseData key:(WhisperKey *) password {
    NSArray *org = baseData.byteArray;
    if (org != nil) {
        for (NSInteger i = 0; i < org.count; ++i) {
            
        }
    }
//    m_con = new WhisperBlock(input, inoffset);
//    byte ring = m_param.GetRing(inoffset);
//    byte key;
//    //Whisping
//    m_con.BlockSwap(ring);
//    for (i = 0; i < 4; i++)
//    {
//        key = m_param.GetKey(inoffset + i);
//        m_con.Whisping(i, m_param.GetKey((int)key), key);
//    }
//    m_con.Accept(output, outoffset)
    return nil;
}

@end
