//
//  Dog.m
//  sampleRealm
//
//  Created by satoutakeshi on 2015/07/28.
//  Copyright (c) 2015年 satoutakeshi. All rights reserved.
//

#import "Dog.h"

@implementation Dog

// Specify default values for properties

+ (NSString *)primaryKey {
    return @"ID";
}

// Define "owners" as the inverse relationship to Owner.dogs
- (NSArray *)owners {
    return [self linkingObjectsOfClass:@"Owner" forProperty:@"dogs"];
}

@end
