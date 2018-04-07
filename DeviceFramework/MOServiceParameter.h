//
//  MOServiceParameter.h
//  Monitor2
//
//  Created by Simon the Cinder on 31/05/2014.
//  Copyright (c) 2014 Simon the Cinder. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kParameterName      @"name"
#define kParserName         @"parserName"
#define kServicePort        @"servicePort"
#define kMatchDataBy        @"matchDataBy"
#define kActionOnIDChange   @"actionOnIDDataChange"
#define kSelectedBed        @"selectedBed"
#define kSelectedWard       @"selectedWard"
#define kWardList           @"wardList"
#define kBedListForWards    @"bedListForWards"
#define kEncodingType       @"encodingType"
#define kPatientName        @"patientName"
#define kCommsChannelKind   @"commsChannelKind"

enum CommsChannelKind{
    eUnknownChannelKind = -1,
	eSerialChannelKind = 0,
    eNetworkChannelKind,
    eWebChannelKind,
    eUSBChannelKind
};
typedef enum CommsChannelKind	CommsChannelKind;

enum DataMatchingServices{
    eInvalidDataMatchingService 	= 0,
    eMatchByID,
    eMatchByMRN,
    eMatchByNameAndDOB,
    eMatchByWardAndBed
};
typedef enum NSInteger	DataMatchingServices;

enum IdentifyingDataChangedAction{
	eIgnoreNewData,
	eAcceptNewData,
	eStartNewCaseWithNewData
};
typedef enum NSInteger	IdentifyingDataChangedAction;

//serial parameters

#define kBaudID         @"baud"
#define kStopBitsID     @"stopBits"
#define kDataBitsID     @"dataBits"
#define kParityID       @"parity"
enum {
    eNoParity = 0,
    eEvenParity,
    eOddParity,
    eInvalidParity
};

//Ethernet
#define kServerNameID       @"serverName"
#define kServerIPID         @"serviceIP"
#define kProtocolTypeID     @"protocolType"
#define kDiscontinousTCP    @"discontinousTCP"
#define kPollingDelay       @"pollingDelay"

enum ProtocolType{
    eInvalidProtocol = -1,
    eTCPProtocol     = 0,
    eUDPProtocol,
    eGCDTCPProtocol
};
typedef enum ProtocolType    ProtocolType;


#define kServiceParameterStoredData     @"storedData"

@interface MOServiceParameter : NSObject<NSCoding>
@property (strong,nonatomic) NSMutableDictionary   *storedData;

//@property (nonatomic, retain)   NSString    *bed;
//@property (nonatomic, retain)   NSString    *ward;


//-(NSString*)fullBedName;
-(NSString*)name;
-(void)setName:(NSString*)name;
-(NSString*)parserName;
-(void)setParserName:(NSString*)parserName;
-(NSString*)servicePort;
-(void)setServicePort:(NSString*)servicePort;
-(NSString*)patientName;
-(void)setPatientName:(NSString*)patientName;
-(NSString*)mrn;
-(void)setMrn:(NSString*)mrn;
-(NSMutableDictionary*)bedListForWards;
-(void)setBedListForWards:(NSMutableDictionary*)bedListForWards;
-(NSArray*)wardList;
-(void)setWardList:(NSArray*)wardList;
-(NSString*)selectedBed;
-(void)setSelectedBed:(NSString*)selectedBed;
-(NSString*)selectedWard;
-(void)setSelectedWard:(NSString*)selectedWard;


-(long)matchDataBy;
-(void)setMatchDataBy:(long)matchDataBy;
-(long)actionOnIDDataChange;
-(void)setActionOnIDDataChange:(long)actionOnIDDataChange;
-(long)encodingType;
-(void)setEncodingType:(long)encodingType;


-(NSArray*)bedList;
-(void)setBedList:(NSArray*)bedList;
-(NSString*)localizedName;
-(long)commsChannelKind;
-(void)setCommsChannelKind:(long)commsChannelKind;

-(long)matchingServiceType;
+(NSSet*)identifyingDataList;

//serial data
-(long)baud;
-(void)setBaud:(long)baud;

-(long)dataBits;
-(void)setDataBits:(long)dataBits;

-(float)stopBits;
-(void)setStopBits:(float)stopBits;

-(long)parity;
-(void)setParity:(long)parity;

//ethernet
-(NSString*)serverName;
-(void)setServerName:(NSString*)serverName;
-(NSString*)serviceIP;
-(void)setServiceIP:(NSString*)serviceIP;
-(long)protocolType;
-(void)setProtocolType:(long)protocolType;

-(float)pollingDelay;
-(void)setPollingDelay:(float)pollingDelay;
-(BOOL)discontinousTCP;
-(void)setDiscontinousTCP:(BOOL)discontinousTCP;

+(MOServiceParameter*)parameterOfType:(CommsChannelKind)type;
@end
