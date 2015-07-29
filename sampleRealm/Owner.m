//
//  Owner.m
//  sampleRealm
//
//  Created by satoutakeshi on 2015/07/27.
//  Copyright (c) 2015年 satoutakeshi. All rights reserved.
//

#import "Owner.h"
@implementation Owner

+ (NSString *)primaryKey {
    return @"ID";
}

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
