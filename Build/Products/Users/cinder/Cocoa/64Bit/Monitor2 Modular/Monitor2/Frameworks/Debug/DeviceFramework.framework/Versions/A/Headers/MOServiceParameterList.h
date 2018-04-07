//
//  MOServiceParameterList.h
//  Monitor2
//
//  Created by Simon the Cinder on 31/05/2014.
//  Copyright (c) 2014 Simon the Cinder. All rights reserved.
//

#import "MOServiceParameter.h"

@interface MOServiceParameterList : NSObject<NSCoding>
@property (strong,nonatomic) NSMutableArray *storedData;

-(long)count;
-(void)addObject:(MOServiceParameter*)parameter;
-(MOServiceParameterList*)parameterListForCommsType:(long)commsType;
-(MOServiceParameter*)serviceForKey:(NSString*)key commsType:(long)commsType;
-(MOServiceParameter*)objectAtIndex:(long)index;
-(NSArray*)serviceNames;
-(void)sortUsingDescriptors:(NSArray*)sortDescriptors;
@end
