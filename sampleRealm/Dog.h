//
//  Dog.h
//  sampleRealm
//
//  Created by satoutakeshi on 2015/07/28.
//  Copyright (c) 2015年 satoutakeshi. All rights reserved.
//

#import <Realm/Realm.h>
@class Owner;

@interface Dog : RLMObject
@property NSString *ID; //インデックス
@property NSInteger age; //犬の年齢
@property NSString *name; //犬の名前
@property Owner *owner; //飼い主

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Dog>
RLM_ARRAY_TYPE(Dog)
