//
//  Device.h
//  Monitor 2
//
//  Created by Simon the Cinder on 09/12/2006.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "MOServiceParameter.h"
#import "MOServiceParameterList.h"
#import "MOSyringePumpDataSet.h"
#import "ValueKeys.h"

#define kDeviceTime                                 @"time"
#define kDeviceYValue                               @"y"
#define kDeviceLeftValue                            @"left"
#define kDeviceRightValue                           @"right"
#define kDeviceLabel                                @"label"
#define kDeviceSource                               @"source"
#define kDeviceDataType                             @"type"
#define kDeviceInspired                             @"inspired"
#define kDeviceExpired                              @"expired"
#define kDeviceSystolic                             @"sys"
#define kDeviceDiastolic                            @"dia"
#define kDevicePeak                                 @"peak"
#define kDeviceMean                                 @"mean"
#define kDevicePEEP                                 @"peep"
#define kDevicePlateau                              @"plateau"
#define kPumpConcentration                          @"concentration"
#define kDeviceT1                                   @"t1"
#define kDeviceT2                                   @"t2"
#define kDeviceT3                                   @"t3"
#define kDeviceT4                                   @"t4"


#define DataAvailableNotification                   @"DataAvailable"
#define DemographicDataAvailableNotification		@"DemographicDataAvailable"
#define kRecordingDevice                            @"Recording device"

#define kTimeMarker                                 @"Time"


#define kHTTPService                                @"Web Browser"
#define kVitalSignsService                          @"Vital Signs"
#define kInfusionPumpsService                       @"Infusion Rate"
#define kDemographicDataService                     @"Demographic Data"
#define kLabResultsService                          @"Lab Results"
#define kScheduleInboundService                     @"Schedule"



#define kSOH                1
#define kSTX                2
#define kETX                3
#define kETB                23
#define kEOT                4
#define kRecordSeparator    30
#define kAck                6
#define kNAK                21

#define kInvalidPressure        -88888



enum DeviceErrors{
    eNoError 	= 0,
	eUnableToParse,
    eGarbledData,
	eChecksumError,
	eUnableToStart,
	eAwaitingDataError,
    eNonMatchingRecordsError,
    eDeviceNotConnected,
    eNoDeviceError
};
typedef enum DeviceErrors	DeviceErrors;


enum DeviceStatus{
    eInvalidStatus 	= 0,
    eNeverStarted,
    eInitiatingCommunications,
    eCommunicating,
	eTerminatingCommunications
};
typedef enum DeviceStatus	DeviceStatus;

enum DataLogType{
    eMessage 	= 0,
    eRead,
    eWrite,
    eError
};
typedef enum DataLogType	DataLogType;

enum DeviceDataType {
    dSimpleType = 0,
    dPressureType,
    dGasType,
    dRespPressureType,
    dEEGType,
    dSyringePumpType,
    dTwitchType
};
typedef enum DeviceDataType    DeviceDataType;

struct GasRec {
    float        inspiratory;
    float        expiratory;
};
typedef struct GasRec    GasRec;

struct ThreePressureRec {
    float        systolic;
    float        mean;
    float        diastolic;
};
typedef struct ThreePressureRec    ThreePressureRec;

struct FourPressureRec {
    float        peak;
    float        plateau;
    float        mean;
    float        peep;
};
typedef struct FourPressureRec    FourPressureRec;

@protocol DeviceProtocols
-(BOOL)portOpen;
-(BOOL)portConnected;
-(void) queueData:(NSData*)theData atTime:(NSTimeInterval) theTime omitIfPresent:(BOOL)omitIfPresent;
-(void) queueString:(NSString *)theString atTime:(NSTimeInterval) theTime omitIfPresent:(BOOL)omitIfPresent;
-(void) setLogReads:(BOOL)logReads;
-(void) setLogWrites:(BOOL)logWrites;
-(NSString*)drugGenericName:(NSString*)rawName;
-(void) logString:(NSString*)toLog dataType:(DataLogType)dataType;
-(void) logData:(NSData*)toLog dataType:(DataLogType)dataType;
-(void) logError:(NSString*)errorMessage;
-(void) identifyingDataChanged;
@end


@interface Device : NSObject {
	int					status;
	NSInteger			curStatus;
	NSTimeInterval		lastStatusUpdate;
}
@property (nonatomic, retain)   NSMutableDictionary       *outputData;
@property (nonatomic, retain)   id<DeviceProtocols>       attachedPort;
@property (nonatomic, retain)   NSString                  *parserName;
@property (nonatomic, retain)   NSString                  *connectedDevice;
@property (nonatomic, retain)   MOServiceParameterList    *availableServices;
@property (nonatomic, retain)   NSMutableDictionary       *availableVitalSigns;
@property (nonatomic, retain)   NSMutableDictionary       *matchingServices;
@property (nonatomic, retain)   NSMutableDictionary       *demographicData;
@property (nonatomic, retain)   MOServiceParameter        *currentServiceParameter;
@property (nonatomic, retain)   NSMutableArray            *labResults;
@property (nonatomic, retain)   MOSyringePumpDataSet      *activePumps;
@property (nonatomic,strong)    NSNumber                  *pollingDelay;


-(MOServiceParameterList*)getAvailableServices;
-(NSMutableDictionary*)getAvailableVitalSigns;
-(NSMutableDictionary*)getAvailableMatchingCriteria;
-(void) startCommunications:(id<DeviceProtocols>)thePort;
-(void) stopCommunications;
-(NSUInteger) parseData:(NSMutableData*)theData; //Don't override this
-(NSUInteger) parseRawData:(char*) rawData length:(NSUInteger) totalLength;
-(NSTimeInterval)getExpectedCommsFrequency;
-(NSTimeInterval)getResetFrequency;
-(NSStringEncoding)stringEncoding;
-(BOOL)handlesCommsConnectionOfKind:(CommsChannelKind)commsChannelKind;
-(BOOL) canInfuseDrugs;
-(BOOL) canHavePollingDelay;
-(void)messageWritten:(NSData*)message tag:(long)tag;
-(void)messageTimedOut:(NSData*)message tag:(long)tag;




-(NSArray*)logPotentialData;
-(void) logDemographicDataAvailable;

- (NSInteger)curStatus;
- (void)setCurStatus:(NSInteger)newCurStatus;
- (NSTimeInterval)lastStatusUpdate;
- (void)setLastStatusUpdate:(NSTimeInterval)newLastStatusUpdate;

/**
 * checks to see if two pressure values (stored in a dictionary) are equal to each other
 * usually used to see if an NIBP value is a repeat
 **/
+(BOOL)pressure:(NSDictionary*)p1 isEqualToPressure:(NSDictionary*)p2;

-(NSString*) stringWithCString:(char*) theData length:(long)length;
-(void)plotStatus:(NSRect)rect messageRect:(NSRect)messageRect;
-(void) queueString:(NSString*)theString delayInSeconds:(float)delayInSeconds omitIfPresent:(BOOL)omitIfPresent;
-(BOOL)shouldWaitForChar:(char*)flagChar;
-(NSString*)makeLogString:(NSData*)logData;
-(NSString*)logStringFromStringWithExtras:(NSData*)logData;
-(NSString*)logStringFromData:(NSData*)logData;
-(void)warnOfAbsentConnection;
-(id)startString;
-(id)stopString;
+(float)getMaxStatusSize;
+(NSString*)escapeString;
+(NSString*)sohString;
+(NSString*)stxString;
+(NSString*)etxString;
+(NSString*)etbString;
+(NSString*)eotString;
+(NSString*)nakString;
+(NSString*)ackString;
+(NSString*)recordSeparatorString;

/**
 * Passes an error string to the main program to handle with NSLog or DDLogError
 *
 **/
-(void)logError:(NSString*)errorString;

/**
 * Mostly the write array can handle this function itself.
 * Occasionally the parser may need to check it, particularly if the write strings contain unique identifiers
 *
**/
+(BOOL)writeArray:(NSArray*)array containsDuplicate:(NSData*)data;

/**
 * Storing parsed data.
 **/
/**
 * Adds data stored in a dictionary to the output, filed under label and source. Normally you would call one of
 * the specific methods rather than this
 * if the source is null, it will be stored as unknown
 **/
-(void) addDataToOutput:(NSString*)label source:(NSString* _Nullable)source data:(NSDictionary*_Nonnull)theData;
/**
 * Adds a single piece of data as a float value to the parsed data output.
 **/

-(void) addFloatDataToOutput:(NSString*_Nonnull)label source:(NSString* _Nullable)source time:(NSTimeInterval)time data:(float)theData;
/**
 * Adds EEG values (left and right) to the parsed data output
 **/
-(void) addEEGDataToOutput:(NSString*_Nonnull)label source:(NSString* _Nullable)source_Nonnull time:(NSTimeInterval)time left:(float)left right:(float)right;

/**
 * Adds a GasRec value (inspiratory and expiratory) to the parsed data output
 **/
-(void) addGasDataToOutput:(NSString*_Nonnull)label source:(NSString* _Nullable)source time:(NSTimeInterval)time data:(GasRec)data;

/**
 * Makes a ThreePressureRec value (systolic, diastolic and mean) into a dictionary. You will need to add this manually by calling addDataToOUtput
 **/

-(NSDictionary*_Nonnull) makeCVPressure:(NSString *_Nonnull)label source:(NSString* _Nullable)source time:(NSTimeInterval)analysisTime data:(ThreePressureRec)data;
/**
 * Adds a ThreePressureRec value (systolic, diastolic and mean) to the parsed data output
 **/
-(void) addCVPressureToOutput:(NSString *_Nonnull)label source:(NSString* _Nullable)source time:(NSTimeInterval)analysisTime data:(ThreePressureRec)data;
/**
 * Adds a FourPressureRec value (peak, plateau, mean and peep) to the parsed data output
 **/
-(void) addRespPressureToOutput:(NSString *_Nonnull)label source:(NSString* _Nullable)source time:(NSTimeInterval) analysisTime data:(FourPressureRec)data;
/**
 * Adds a Twitch values (t1, t2, t3, t4) to the parsed data output
 **/
-(void) addTwitchDataToOutput:(NSString *_Nonnull)label source:(NSString* _Nullable)source time:(NSTimeInterval) analysisTime t1:(float)t1 t2:(float)t2 t3:(float)t3 t4:(float)t4;
/**
 * Adds infusion values (rate, concentration) to the parsed data output
 **/
-(void) addInfusionDataToOutput:(NSString *_Nonnull)drug time:(NSTimeInterval) analysisTime rate:(float)rate concentration:(float)concentration;
/**
 * Gets currently stored data for a label, source and timestamp
 * Usually used for devices which give compound data as discrete pieces
 **/
-(nullable NSDictionary*) getObjectWithLabel:(NSString*_Nonnull)label source:(NSString* _Nullable)source timeStamp:(NSTimeInterval)timeStamp;
/**
 * Removes currently stored data for a given label source and timestamp
 **/
-(void) removeObjectFromOutput:(NSString*_Nonnull)label source:(NSString* _Nullable)source time:(NSTimeInterval)timeStamp;
/**
 * Removes a dictionary object from the output
 * Calls removeObjectFromOutput:(NSString*)label source:(NSString* _Nullable)source time:(NSTimeInterval)timeStamp
 * If no values are stored in the dictionary for source, label and time nothing will be removed
 **/
//-(void) removeObjectFromOutput:(NSDictionary*_Nonnull)dataObject;

/**
 * Notifies the program that you have finished parsing the data. You must call this when you are finished
 **/
-(void) logEndOfData;

@end


void BlockMoveData (void* _Nonnull source, void* _Nonnull dest, unsigned long length);

float RoundToNSigFigs
	(
	 float	inputValue,
	 short	sigFigs
	 );
