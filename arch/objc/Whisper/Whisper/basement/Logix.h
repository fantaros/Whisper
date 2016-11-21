//
//  Logix.h
//  Whisper
//
//  Created by fantaros on 2016/11/17.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Logix : NSObject

-(unsigned char) mappedLogixTableH:(unsigned char) src;

-(unsigned char) logixWithOperatorByte1:(unsigned char) opt1 operatorByte2:(unsigned char) opt2 methodType:(unsigned char) methodNo;

@end
