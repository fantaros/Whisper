//
//  Logix.h
//  Whisper
//
//  Created by fantaros on 2016/11/17.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSPLogix : NSObject

//返回某个部分异或方法的映射
-(unsigned char) mappedLogixTableH:(unsigned char) src;
//通过部分异或映射计算两个操作数的结果
-(unsigned char) logixWithOperatorByte1:(unsigned char) opt1 operatorByte2:(unsigned char) opt2 methodType:(unsigned char) methodNo;

@end
