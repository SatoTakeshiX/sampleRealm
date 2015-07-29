//
//  Owner.h
//  sampleRealm
//
//  Created by satoutakeshi on 2015/07/27.
//  Copyright (c) 2015年 satoutakeshi. All rights reserved.
//

#import <Realm/Realm.h>
#import "Dog.h"

@interface Owner : RLMObject

@property NSString *ID; //飼い主のID
@property NSInteger age; //飼い主の年齢
@property NSString* name; //飼い主の名前
@property RLMArray<Dog> *dogs; //飼っている犬一覧
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Owner>
RLM_ARRAY_TYPE(Owner)
