//
//  MOSyringePumpData.h
//  Monitor2
//
//  Created by Simon the Cinder on 6/06/2014.
//  Copyright (c) 2014 Simon the Cinder. All rights reserved.
//

enum PowerSupply{
    ePowerSupplyBattery = 0,
    ePowerSupplyMains
};
typedef NSInteger PowerSupply;

#define kInfusionDrugChanged    @"Infusion drug changed"
#define kOriginalDrugName       @"originalDrugName"
#define kNewDrugName            @"newDrugName"
#define kNewConcentration       @"newDrugConcentration"


@interface MOSyringePumpData : NSObject
@property (nonatomic,retain)    NSString            *pumpName;
@property (nonatomic,retain)    NSString            *pumpDrugLabel;
@property (nonatomic,retain)    NSString            *drugName;
@property (nonatomic)           float               rate;
@property (nonatomic)           float               volumeInfused;
@property (nonatomic)           float               drugConcentration;
@property (nonatomic)           float               transmittedConcentration;
@property (nonatomic)           long                concentrationUnit;
@property (nonatomic)           long                concentrationWeightUnit;
@property (nonatomic)           float               concentrationVolumeMultiplier;
@property (nonatomic)           float               doseRate;
@property (nonatomic)           long                doseUnit;
@property (nonatomic)           long                doseWeightUnit;
@property (nonatomic)           float               doseVolumeMultiplier;
@property (nonatomic)           NSTimeInterval      doseTimeMultiplier;
@property (nonatomic)           NSTimeInterval      dataTime;
@property (nonatomic,retain)    NSString            *serialNumber;

-(float)infusionConcentrationInMgPerMl:(float)bodyWeightInKg;
-(NSString*)getPumpID;
-(BOOL) hasDrugIdentificationData;
-(NSString*)rawDrugName;
@end
