//
//  SyringePump.m
//  Monitor2
//
//  Created by Simon the Cinder on 20/01/2014.
//  Copyright (c) 2014 Simon the Cinder. All rights reserved.
//

#import "SyringePump.h"

@implementation SyringePump
-(id) init
{
	self = [super init];
	return self;
}


-(void) fixAlarms:(long)alarmType;

{
    
    //if numberOfRecentValues.firstInfusion.status = 0 then begin
    //test.firstInfusion.status := 1;
    //numberOfRecentValues := test;
}


-(void) fixRate:(float)rate atTime:(NSTimeInterval)analysisTime
{
    [self addInfusionDataToOutput:self.drugName time:analysisTime rate:rate concentration:self.drugConcentration.floatValue];
}

-(void) fixVolume:(float)rate atTime:(NSTimeInterval)analysisTime
{
    //	if numberOfRecentValues.infusion[1].rate = 0 then begin
    //		test := numberOfRecentValues;
    //		test.infusion[1].rate := 1;
    //		numberOfRecentValues := test;
    //	end;
    //	test := recentValues;
    //	test.infusion[1].rate := rate;
    //	test.infusion[1].massUnits := kNoMassUnits;
    //	recentValues := test;
    //DDLogError(@"Volume %0.1f",rate);
}

-(BOOL) canInfuseDrugs
{
    return YES;
}



@end
