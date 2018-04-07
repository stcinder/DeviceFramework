//
//  SyringePump.h
//  Monitor2
//
//  Created by Simon the Cinder on 20/01/2014.
//  Copyright (c) 2014 Simon the Cinder. All rights reserved.
//

#import "Device.h"
enum PumpStatus{
    eNoPumpError 	= 0,
	eSyntaxError,
    eCommandError,
	eAlarm,
	eStandby
};
typedef enum PumpStatus	PumpStatus;

enum RequiredAction{
    eCheckRate = 1,
    eGetVolume = 2
};
typedef enum RequiredAction	RequiredAction;

@interface SyringePump : Device
@property (nonatomic,retain) NSString       *drugName;
@property (nonatomic,retain) NSNumber       *drugConcentration;

-(void) fixAlarms:(long)alarmType;
-(void) fixRate:(float)rate atTime:(NSTimeInterval)analysisTime;
-(void) fixVolume:(float)rate atTime:(NSTimeInterval)analysisTime;
@end
