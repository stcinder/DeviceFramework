//
//  MOSyringePumpData.m
//  Monitor2
//
//  Created by Simon the Cinder on 6/06/2014.
//  Copyright (c) 2014 Simon the Cinder. All rights reserved.
//

#import "MOSyringePumpData.h"
//#import "Drug.h"
#import "ValueKeys.h"

@implementation MOSyringePumpData
-(id)init
{
    self = [super init];
    if (nil != self) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector:@selector(infusionDrugChanged:)
                                                     name:kInfusionDrugChanged
                                                   object:nil];
    }
    return self;
}

-(void) dealloc
{
    self.serialNumber = nil;
    self.drugName = nil;
    self.pumpName = nil;
    self.pumpDrugLabel = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)infusionDrugChanged:(NSNotification*)notification
{
    NSString            *pumpID = notification.object;
    NSDictionary        *userInfo = notification.userInfo;
    NSString            *originalName;
    NSString            *newName;
    NSNumber            *newConcentration;
    
    if ((nil != pumpID)&&([pumpID isEqualToString:self.getPumpID])) {
        originalName = [userInfo objectForKey:kOriginalDrugName];
        newName = [userInfo objectForKey:kNewDrugName];
        newConcentration = [userInfo objectForKey:kNewConcentration];
        
        if (nil != originalName) {
            if ([originalName isEqualToString:self.drugName]) {
                self.drugName = newName;
                self.drugConcentration = newConcentration.floatValue;
                if (self.drugConcentration == 0)
                    NSLog(@"%@ zero concentration",self.className);
            }
        }
    }
}

-(float)concentrationVolumeMultiplier
{
    if (0 >= _concentrationVolumeMultiplier)
        _concentrationVolumeMultiplier = 1;
    return _concentrationVolumeMultiplier;
}

-(float)infusionConcentrationInMgPerMl:(float)bodyWeightInKg
{
    float           concentration = self.drugConcentration * self.concentrationVolumeMultiplier;
    
    return concentration;
}

-(float)drugConcentration
{
    float       concentration = _drugConcentration;
    if (0 >= concentration)
        concentration = self.transmittedConcentration;
    
    if (0 >= concentration)
        concentration = 1;
    
    return concentration;
}


-(NSString*)getPumpID
{
    return self.serialNumber;
}
//


-(NSString*)drugName
{
    NSString                *returnName = _drugName;
    
    if (nil == returnName)
        returnName = self.pumpDrugLabel;
    if (nil == returnName) {
        returnName = [self getPumpID];
    }
    if (nil == returnName)
        returnName = kUntitledDrug;
    return returnName;
}

-(NSString*)rawDrugName
{
    return _drugName;
}

-(void)setRate:(float)rate
{
    _rate = rate;
    self.dataTime = [NSDate timeIntervalSinceReferenceDate];
}

-(BOOL) hasDrugIdentificationData
{
    BOOL            hasDrugIdentificationData = ((nil != _drugName)&&(_drugName.length > 0));
    
//    if (!hasDrugIdentificationData)
//        hasDrugIdentificationData = _transmittedConcentration > 0;
    return hasDrugIdentificationData;
}
@end
