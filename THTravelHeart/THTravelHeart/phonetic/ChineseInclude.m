 //
//  ChineseInclude.m
//  橙电
//
//  Created by 邹少军 on 15/9/30.
//  Copyright (c) 2015年 com.chengdian. All rights reserved.
//

#import "ChineseInclude.h"

@implementation ChineseInclude

+(BOOL)inIncludeChineseInString:(NSString *)str
{
    for (int i = 0; i < str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}
@end
