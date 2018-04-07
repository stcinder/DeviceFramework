//
//  MOSyringePumpDataSet.h
//  Monitor2
//
//  Created by Simon the Cinder on 6/06/2014.
//  Copyright (c) 2014 Simon the Cinder. All rights reserved.
//

#import "MOSyringePumpData.h"

@interface MOSyringePumpDataSet : NSObject
@property (nonatomic,retain) NSMutableSet          *storedData;

-(NSInteger)count;
-(void) addObject:(MOSyringePumpData*)object;
-(void) removeObject:(MOSyringePumpData*)object;
-(void) removeAllObjects;

@end
