//
//  MOSyringePumpDataSet.m
//  Monitor2
//
//  Created by Simon the Cinder on 6/06/2014.
//  Copyright (c) 2014 Simon the Cinder. All rights reserved.
//

#import "MOSyringePumpDataSet.h"

@implementation MOSyringePumpDataSet
-(NSMutableSet*)storedData
{
    if (nil == _storedData)
        self.storedData = [NSMutableSet setWithCapacity:0];
    return _storedData;
}

-(NSInteger)count
{
    return self.storedData.count;
}



-(void) addObject:(MOSyringePumpData*)object
{
    if (nil != object)
        [self.storedData addObject:object];
    else
        NSLog(@"%@ trying to add nil object",self.className);
    
}

-(void) removeObject:(MOSyringePumpData*)object
{
    if (nil != object)
        [self.storedData removeObject:object];
    else
        NSLog(@"%@ trying to remove nil object",self.className);
}

-(void) removeAllObjects
{
    [self.storedData removeAllObjects];
}
@end
