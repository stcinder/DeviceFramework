//
//  MOServiceParameterList.m
//  Monitor2
//
//  Created by Simon the Cinder on 31/05/2014.
//  Copyright (c) 2014 Simon the Cinder. All rights reserved.
//

#import "MOServiceParameterList.h"

@implementation MOServiceParameterList
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.storedData = [aDecoder decodeObjectForKey:kServiceParameterStoredData];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.storedData forKey:kServiceParameterStoredData];
}

-(void)dealloc
{
    self.storedData  = nil;
}

-(NSMutableArray*)storedData
{
    if (nil == _storedData)
        _storedData = [NSMutableArray array];
    return _storedData;
}

-(MOServiceParameterList*)parameterListForCommsType:(NSInteger)commsType
{
    MOServiceParameter      *aParameter;
    MOServiceParameterList  *foundParameters = [[MOServiceParameterList alloc]init];
    
    for (aParameter in self.storedData) {
        if (aParameter.commsChannelKind == commsType)
            [foundParameters addObject:aParameter];
    }
    
    
    return foundParameters;
}

-(MOServiceParameter*)serviceForKey:(NSString*)key commsType:(NSInteger)commsType
{
    MOServiceParameter      *aParameter;
    MOServiceParameter      *foundParameter = nil;
    
    if (nil != key) {
        for (aParameter in self.storedData) {
            if (aParameter.commsChannelKind == commsType) {
                if ([aParameter.name isEqualToString:key]) {
                    foundParameter = aParameter;
                    break;
                }
            }
        }
    }
    else
        NSLog(@"Nil key at serviceForKey");
    
    return foundParameter;

}

-(void)addObject:(MOServiceParameter*)parameter
{
    if (nil != parameter)
        [self.storedData  addObject:parameter];
    else
        NSLog(@"nil parameter");
}

-(long)count
{
    return self.storedData.count;
}

-(void)sortUsingDescriptors:(NSArray*)sortDescriptors
{
    if (nil != sortDescriptors)
        [self.storedData sortUsingDescriptors:sortDescriptors];
    else
        NSLog(@"Nil sort descriptor array");
}

-(MOServiceParameter*)objectAtIndex:(long)index
{
    return [self.storedData objectAtIndex:index];
}
-(NSArray*)serviceNames
{
    NSMutableArray          *nameArray = [NSMutableArray arrayWithCapacity:0];
    MOServiceParameter      *aParameter;
    
    for (aParameter in self.storedData) {
        if (![nameArray containsObject:aParameter.name])
            [nameArray addObject:aParameter.name];
    }
        
    return nameArray;
}

@end
