/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "NSObject+FBKVOController.h"

#import <objc/message.h>

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Convert your project to ARC or specify the -fobjc-arc flag.
#endif

#pragma mark NSObject Category -

NS_ASSUME_NONNULL_BEGIN

static void *NSObjectKVOControllerKey = &NSObjectKVOControllerKey;
static void *NSObjectKVOControllerNonRetainingKey = &NSObjectKVOControllerNonRetainingKey;

@implementation NSObject (FBKVOController)

- (FBKVOController *)KVOController
{
  // 通过管理对象,获取KVOController对象
  id controller = objc_getAssociatedObject(self, NSObjectKVOControllerKey);
  
  // lazily create the KVOController
  // 如果没有
  if (nil == controller) {
    // 进行初始化,并存储起来
    controller = [FBKVOController controllerWithObserver:self];
    self.KVOController = controller;
  }
  
  return controller;
}

- (void)setKVOController:(FBKVOController *)KVOController
{
  // 通过管理对象对 KVOController 对象进行存储
  objc_setAssociatedObject(self, NSObjectKVOControllerKey, KVOController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (FBKVOController *)KVOControllerNonRetaining
{
  // 通过管理对象,获取KVOControllerNonRetaining对象
  id controller = objc_getAssociatedObject(self, NSObjectKVOControllerNonRetainingKey);
  
  // 如果没有
  if (nil == controller) {
    // 进行初始化,并存储起来
    controller = [[FBKVOController alloc] initWithObserver:self retainObserved:NO];
    self.KVOControllerNonRetaining = controller;
  }
  
  return controller;
}

- (void)setKVOControllerNonRetaining:(FBKVOController *)KVOControllerNonRetaining
{
  // 通过管理对象对 KVOControllerNonRetaining 对象进行存储
  objc_setAssociatedObject(self, NSObjectKVOControllerNonRetainingKey, KVOControllerNonRetaining, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


NS_ASSUME_NONNULL_END
