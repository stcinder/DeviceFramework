//
//  MOServiceParameter.m
//  Monitor2
//
//  Created by Simon the Cinder on 31/05/2014.
//  Copyright (c) 2014 Simon the Cinder. All rights reserved.
//

#import "MOServiceParameter.h"
#import "ValueKeys.h"
//#import "PMCKCase.h"

@implementation MOServiceParameter


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
    self.storedData = nil;
}

-(NSMutableDictionary*)storedData
{
    if (nil == _storedData)
        _storedData = [NSMutableDictionary dictionary];
    return _storedData;
}

-(NSString*)name
{
    return [self.storedData objectForKey:kParameterName];
}

-(void)setName:(NSString*)name
{
    if (nil != name)
        [self.storedData setObject:name forKey:kParameterName];
    else
        [self.storedData removeObjectForKey:kParameterName];
}

-(NSString*)patientName
{
    return [self.storedData objectForKey:kPatientName];
}

-(void)setPatientName:(NSString*)patientName
{
    if (nil != patientName)
        [self.storedData setObject:patientName forKey:kPatientName];
    else
        [self.storedData removeObjectForKey:kPatientName];
}

-(NSString*)mrn
{
    return [self.storedData objectForKey:kMedicalRecordNumber];
}

-(void)setMrn:(NSString*)mrn
{
    if (nil != mrn)
        [self.storedData setObject:mrn forKey:kMedicalRecordNumber];
    else
        [self.storedData removeObjectForKey:kMedicalRecordNumber];
}


-(NSString*)selectedBed
{
    return [self.storedData objectForKey:kSelectedBed];
}

-(void)setSelectedBed:(NSString*)selectedBed
{
    if (nil != selectedBed)
        [self.storedData setObject:selectedBed forKey:kSelectedBed];
    else
        [self.storedData removeObjectForKey:kSelectedBed];
}

-(NSString*)selectedWard
{
    return [self.storedData objectForKey:kSelectedWard];
}

-(void)setSelectedWard:(NSString*)selectedWard
{
    if (nil != selectedWard)
        [self.storedData setObject:selectedWard forKey:kSelectedWard];
    else
        [self.storedData removeObjectForKey:kSelectedWard];
}



-(NSMutableDictionary*)bedListForWards
{
    NSMutableDictionary *bedListForWards = [self.storedData objectForKey:kBedListForWards];
    if (nil == bedListForWards) {
        bedListForWards = [NSMutableDictionary dictionary];
        [self.storedData setObject:bedListForWards forKey:kBedListForWards];
    }
    return bedListForWards;

}

-(void)setBedListForWards:(NSMutableDictionary*)bedListForWards
{
    if (nil != bedListForWards)
        [self.storedData setObject:bedListForWards forKey:kBedListForWards];
    else
        [self.storedData removeObjectForKey:kBedListForWards];
}


-(NSArray*)wardList
{
    return [self.storedData objectForKey:kWardList];
}

-(void)setWardList:(NSArray*)wardList
{
    if (nil != wardList)
        [self.storedData setObject:wardList forKey:kWardList];
    else
        [self.storedData removeObjectForKey:kWardList];
}


-(NSString*)parserName
{
    return [self.storedData objectForKey:kParserName];
}

-(void)setParserName:(NSString*)parserName
{
    if (nil != parserName)
        [self.storedData setObject:parserName forKey:kParserName];
    else
        [self.storedData removeObjectForKey:kParserName];
}

-(NSString*)servicePort
{
    return [self.storedData objectForKey:kServicePort];
}

-(void)setServicePort:(NSString*)servicePort
{
    if (nil != servicePort)
        [self.storedData setObject:servicePort forKey:kServicePort];
    else
        [self.storedData removeObjectForKey:kServicePort];
}

-(long)matchDataBy
{
    return [[self.storedData objectForKey:kMatchDataBy]longValue];
}

-(void)setMatchDataBy:(long)matchDataBy
{
    NSNumber    *matchBy = [NSNumber numberWithLong:matchDataBy];
    [self.storedData setObject:matchBy forKey:kMatchDataBy];
}

-(long)actionOnIDDataChange
{
    return [[self.storedData objectForKey:kActionOnIDChange]longValue];
}

-(void)setActionOnIDDataChange:(long)actionOnIDDataChange
{
    NSNumber    *matchBy = [NSNumber numberWithLong:actionOnIDDataChange];
    [self.storedData setObject:matchBy forKey:kActionOnIDChange];
}

-(long)encodingType
{
    return [[self.storedData objectForKey:kEncodingType]longValue];
}

-(void)setEncodingType:(long)encodingType
{
    NSNumber    *matchBy = [NSNumber numberWithLong:encodingType];
    [self.storedData setObject:matchBy forKey:kEncodingType];
}


-(long)baud
{
    long        baud = [[self.storedData objectForKey:kBaudID]longValue];
    if (baud <= 0)
        baud = 9600;
    return baud;
}

-(void)setBaud:(long)baud
{
    NSNumber    *matchBy = [NSNumber numberWithLong:baud];
    [self.storedData setObject:matchBy forKey:kBaudID];
}

-(long)dataBits
{
    long        dataBits = [[self.storedData objectForKey:kDataBitsID]longValue];
    if (dataBits <= 0)
        dataBits = 8;
    return dataBits;
}

-(void)setDataBits:(long)dataBits
{
    NSNumber    *matchBy = [NSNumber numberWithLong:dataBits];
    [self.storedData setObject:matchBy forKey:kDataBitsID];
}

-(float)stopBits
{
    float        stopBits = [[self.storedData objectForKey:kStopBitsID]floatValue];
    if (stopBits <= 0)
        stopBits = 1.0;
    return stopBits;

}

-(void)setStopBits:(float)stopBits
{
    NSNumber    *matchBy = [NSNumber numberWithFloat:stopBits];
    [self.storedData setObject:matchBy forKey:kStopBitsID];
}


-(long)parity
{
    long        parity = [[self.storedData objectForKey:kParityID]longValue];
    return parity;
}

-(void)setParity:(long)parity
{
    NSNumber    *matchBy = [NSNumber numberWithLong:parity];
    [self.storedData setObject:matchBy forKey:kParityID];
}


-(NSString*)localizedName
{
    return NSLocalizedString(self.name, nil);
}

-(long)commsChannelKind
{
    long        number = [[self.storedData objectForKey:kCommsChannelKind]longValue];
    return number;
}


-(void)setCommsChannelKind:(long)commsChannelKind
{
    NSNumber    *matchBy = [NSNumber numberWithLong:commsChannelKind];
    [self.storedData setObject:matchBy forKey:kCommsChannelKind];
}



-(NSArray*)bedList
{
    NSArray         *bedList = nil;
    if (nil != self.selectedWard) {
        bedList = [self.bedListForWards objectForKey:self.selectedWard];
    }
    return bedList;
}


-(void)setBedList:(NSArray*)bedList
{
    if (nil != self.selectedWard) {
        if (nil != bedList) {
            [self.bedListForWards setObject:bedList forKey:self.selectedWard];
        }
        else
            [self.bedListForWards removeObjectForKey:self.selectedWard];
    }
}



-(id)copyWithZone:(NSZone *)zone
{
    MOServiceParameter      *newParameter = [[self.class alloc]init];
    newParameter.storedData = [self.storedData mutableCopy];
    return newParameter;
}

-(long)matchingServiceType
{
    long       matchingServiceType = self.matchDataBy;
    return matchingServiceType;
}

+(NSSet*)identifyingDataList
{
    static      NSSet   *idList = nil;
    
    if (nil == idList) {
        idList = [NSSet setWithObjects:kMedicalRecordNumber,kPatientIDNumber,kDOB,kFirstName,kSurname, nil];
    }
    return idList;
}

#pragma mark- ethernet
-(NSString*)serverName;
{
    return [self.storedData objectForKey:kServerNameID];
}

-(void)setServerName:(NSString*)serverName
{
    if (nil != serverName)
        [self.storedData setObject:serverName forKey:kServerNameID];
    else
        [self.storedData removeObjectForKey:kServerNameID];
}

-(NSString*)serviceIP
{
    return [self.storedData objectForKey:kServerIPID];
}

-(void)setServiceIP:(NSString*)serviceIP
{
    if (nil != serviceIP)
        [self.storedData setObject:serviceIP forKey:kServerIPID];
    else
        [self.storedData removeObjectForKey:kServerIPID];
}

-(long)protocolType
{
    long        number = [[self.storedData objectForKey:kProtocolTypeID]longValue];
    return number;
}


-(void)setProtocolType:(long)protocolType
{
    NSNumber    *matchBy = [NSNumber numberWithLong:protocolType];
    [self.storedData setObject:matchBy forKey:kProtocolTypeID];
}


-(float)pollingDelay
{
    float        number = [[self.storedData objectForKey:kPollingDelay]floatValue];
    if (0 >= number)
        number = 4.5;
    return number;
}

-(void)setPollingDelay:(float)pollingDelay
{
    NSNumber    *matchBy = [NSNumber numberWithFloat:pollingDelay];
    [self.storedData setObject:matchBy forKey:kPollingDelay];
}

-(BOOL)discontinousTCP
{
    BOOL        number = [[self.storedData objectForKey:kDiscontinousTCP]boolValue];
    return number;
}

-(void)setDiscontinousTCP:(BOOL)discontinousTCP
{
    NSNumber    *matchBy = [NSNumber numberWithBool:discontinousTCP];
    [self.storedData setObject:matchBy forKey:kDiscontinousTCP];
}

+(MOServiceParameter*)parameterOfType:(CommsChannelKind)type
{
    MOServiceParameter  *parameter = [[MOServiceParameter alloc]init];
    parameter.commsChannelKind   = type;
    return parameter;
}

@end
