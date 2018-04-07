//
//  Device.m
//  Monitor 2
//
//  Created by Simon the Cinder on 09/12/2006.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "Device.h"


@implementation Device
-(id) init
{
	self = [super init];
	self.outputData = [NSMutableDictionary dictionary];
	[self setParserName:Localize(@"uninitialised device")];
	return self;
}

-(void) dealloc
{
    self.outputData = nil;
    self.parserName = nil;
	[self setAttachedPort:nil];
    self.activePumps = nil;
    self.labResults = nil;
    self.currentServiceParameter = nil;
    self.availableServices = nil;
    self.matchingServices = nil;
    self.pollingDelay = nil;
}

-(NSMutableDictionary*)outputData
{
    if (nil == _outputData)
        _outputData = [NSMutableDictionary dictionary];
    return _outputData;
}

-(BOOL) canHavePollingDelay
{
    return NO;
}

+(NSString*)sohString
{
    static NSString        *sohString = nil;
    if (nil == sohString)
        sohString = [NSString stringWithFormat:@"%c",kSOH];
    return sohString;
}

+(NSString*)stxString
{
    static NSString        *sohString = nil;
    if (nil == sohString)
        sohString = [NSString stringWithFormat:@"%c",kSTX];
    return sohString;
}

+(NSString*)etxString
{
    static NSString        *sohString = nil;
    if (nil == sohString)
        sohString = [NSString stringWithFormat:@"%c",kETX];
    return sohString;
}

+(NSString*)etbString
{
    static NSString        *sohString = nil;
    if (nil == sohString)
        sohString = [NSString stringWithFormat:@"%c",kETB];
    return sohString;
}

+(NSString*)eotString
{
    static NSString        *sohString = nil;
    if (nil == sohString)
        sohString = [NSString stringWithFormat:@"%c",kEOT];
    return sohString;
}

+(NSString*)nakString
{
    static NSString        *sohString = nil;
    if (nil == sohString)
        sohString = [NSString stringWithFormat:@"%c",kNAK];
    return sohString;
}

+(NSString*)escapeString
{
    static NSString        *sohString = nil;
    if (nil == sohString)
        sohString = [NSString stringWithFormat:@"%c",0x1B];
    return sohString;
}

+(NSString*)ackString
{
    static NSString        *sohString = nil;
    if (nil == sohString)
        sohString = [NSString stringWithFormat:@"%c",kAck];
    return sohString;
}


+(NSString*)recordSeparatorString
{
    static NSString        *sohString = nil;
    if (nil == sohString)
        sohString = [NSString stringWithFormat:@"%c",kRecordSeparator];
    return sohString;
}

-(MOSyringePumpDataSet*)activePumps
{
    if (nil == _activePumps)
        self.activePumps = [[MOSyringePumpDataSet alloc]init];
    return _activePumps;
}

-(NSInteger)numActivePumps
{
    NSInteger       numActivePumps = 0;
    if (nil != _activePumps)
        numActivePumps = self.activePumps.count;
    return numActivePumps;
}

-(NSMutableDictionary*)availableVitalSigns
{
    if (nil == _availableVitalSigns) {
        self.availableVitalSigns = self.getAvailableVitalSigns;
    }
    return _availableVitalSigns;
}


-(NSMutableDictionary*)getAvailableMatchingCriteria
{
    return [NSMutableDictionary dictionaryWithCapacity:0];
}

-(NSMutableDictionary*)matchingServices
{
    if (nil == _matchingServices)
        self.matchingServices = [self getAvailableMatchingCriteria];
    return _matchingServices;
}

-(MOServiceParameterList*)availableServices
{
    if (nil == _availableServices) {
        NSSortDescriptor	*desc = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                              ascending:YES selector:@selector(compare:)];
        NSArray				*sortDescriptors=[NSArray arrayWithObjects:desc, nil];

        self.availableServices = self.getAvailableServices;
        
        [self.availableServices sortUsingDescriptors:sortDescriptors];
    }
    return _availableServices;
}

-(NSMutableDictionary*)getAvailableVitalSigns
{
    NSMutableDictionary         *dictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    return dictionary;
}

-(MOServiceParameterList*)getAvailableServices
{
    MOServiceParameterList         *dictionary = [[MOServiceParameterList alloc]init];
    return dictionary;
}


-(NSDictionary*)makeDefaultSettings
{
    return nil;
}


-(void)setAttachedPort:(id)attachedPort
{
    if (attachedPort == nil)
        _attachedPort = attachedPort;
    else if ([attachedPort conformsToProtocol:@protocol(DeviceProtocols)])
        _attachedPort = attachedPort;
    else
        NSCAssert(FALSE, @"must conform with DeviceProtocols");

}
-(NSUInteger) parseRawData:(char*) rawData length:(NSUInteger) totalLength
{
	//parses a data string, and then returns the number of bytes used
	NSUInteger		bytesUsed = totalLength;
	[self logError: @"Must override this function"];
	
	return bytesUsed;
}

-(NSUInteger) parseData:(NSMutableData*)theData
{
	//this is where we parse the received data
    NSUInteger		bytesUsed = 0;
    char			*rawData;
    NSUInteger		totalLength;
	
	totalLength = [theData length];
	rawData = (char *)[theData bytes];
	//rawData = (char *)[theData mutableBytes];
//    NSString        *string = [[NSString alloc]initWithBytes:rawData length:totalLength encoding:NSASCIIStringEncoding];
//    DDLogError(@"%@",string);

	//while (bytesUsed < totalLength)  {
		bytesUsed =  [self parseRawData:rawData length:totalLength];
	//}
	return bytesUsed;
}

-(void) logEndOfData
{
    NSMutableDictionary        *otherResults = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if ((_labResults != nil)&&(_labResults.count > 0))
        [otherResults setObject:self.labResults forKey:kLabResultsService];
    if ((_activePumps != nil)&&(_activePumps.count > 0))
        [otherResults setObject:[self.activePumps.storedData copy] forKey:kInfusionPumpsService];
    [otherResults setObject:self.parserName forKey:kParserName];
	[[NSNotificationCenter defaultCenter]
     postNotificationName:DataAvailableNotification
     object:[self getDataBuffer]
     userInfo:otherResults];
}

-(void) logDemographicDataAvailable
{
    if ((nil != _demographicData) &&(_demographicData.count > 0)) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:DemographicDataAvailableNotification
         object:[self demographicData]
         userInfo:[NSDictionary dictionaryWithObject:self forKey:kRecordingDevice]];
        self.demographicData = nil;
    }
}


-(NSMutableArray*)labResults
{
    if (nil == _labResults)
        self.labResults = [NSMutableArray array];
    return _labResults;
}

-(NSMutableDictionary*)demographicData
{
    if (nil == _demographicData)
        self.demographicData = [NSMutableDictionary dictionaryWithCapacity:0];
    return _demographicData;
}


-(void) startCommunications:(id<DeviceProtocols>)thePort
{
    self.attachedPort = thePort;
    [self setCurStatus:eAwaitingDataError];
}

-(void) stopCommunications
{
}


-(void) addDataToOutput:(NSString*)label source:(NSString* _Nullable )source data:(NSDictionary*_Nonnull)theData
{
    if (nil != label) {
        NSMutableDictionary        *typeDict = [self.outputData objectForKey:label];
        if (nil == typeDict) {
            typeDict = [NSMutableDictionary dictionary];
            [self.outputData setObject:typeDict forKey:label];
        }
        if (nil == source) {
            source = kUnknownSource;
        }
        

        NSMutableArray        *sourceArray = [typeDict objectForKey:source];
        if (nil == sourceArray) {
            sourceArray = [NSMutableArray array];
            [typeDict setObject:sourceArray forKey:source];
        }
        [sourceArray addObject:theData];
    }
    else
        [self logError:@"Nil label addDataToOutput"];

//    return newObject;
}

-(void) addFloatDataToOutput:(NSString*)label source:(NSString*)source time:(NSTimeInterval)time data:(float)theData
{
    NSMutableDictionary     *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithFloat:theData] forKey:kDeviceYValue];
    [dictionary setObject:[NSNumber numberWithDouble:time] forKey:kDeviceTime];
    [dictionary setObject:[NSNumber numberWithInt:dSimpleType] forKey:kDeviceDataType];
    [self addDataToOutput:label source:source data:dictionary];
}

-(void) addEEGDataToOutput:(NSString*)label source:(NSString*)source time:(NSTimeInterval)time left:(float)left right:(float)right
{
    NSMutableDictionary     *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithFloat:left] forKey:kDeviceLeftValue];
    [dictionary setObject:[NSNumber numberWithFloat:right] forKey:kDeviceRightValue];
    [dictionary setObject:[NSNumber numberWithDouble:time] forKey:kDeviceTime];
    [dictionary setObject:[NSNumber numberWithInt:dEEGType] forKey:kDeviceDataType];
    [self addDataToOutput:label source:source data:dictionary];
}

-(void) addGasDataToOutput:(NSString*)label source:(NSString*)source time:(NSTimeInterval)time data:(GasRec)data
{
    NSMutableDictionary     *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithFloat:data.expiratory] forKey:kDeviceExpired];
    [dictionary setObject:[NSNumber numberWithFloat:data.inspiratory] forKey:kDeviceInspired];
    [dictionary setObject:[NSNumber numberWithDouble:time] forKey:kDeviceTime];
    [dictionary setObject:[NSNumber numberWithInt:dGasType] forKey:kDeviceDataType];
    [self addDataToOutput:label source:source data:dictionary];
}

-(NSDictionary*) makeCVPressure:(NSString *)label source:(NSString *)source time:(NSTimeInterval)analysisTime data:(ThreePressureRec)data
{
    NSMutableDictionary     *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithFloat:data.systolic] forKey:kDeviceSystolic];
    [dictionary setObject:[NSNumber numberWithFloat:data.diastolic] forKey:kDeviceDiastolic];
    [dictionary setObject:[NSNumber numberWithFloat:data.mean] forKey:kDeviceMean];
    [dictionary setObject:[NSNumber numberWithDouble:analysisTime] forKey:kDeviceTime];
    [dictionary setObject:[NSNumber numberWithInt:dPressureType] forKey:kDeviceDataType];
    return dictionary;
}

-(void) addCVPressureToOutput:(NSString *)label source:(NSString *)source time:(NSTimeInterval)analysisTime data:(ThreePressureRec)data
{
    NSDictionary     *dictionary = [self makeCVPressure:label source:source time:analysisTime data:data];
    [self addDataToOutput:label source:source data:dictionary];
}

-(void) addRespPressureToOutput:(NSString *)label source:(NSString *)source time:(NSTimeInterval) analysisTime data:(FourPressureRec)data
{
    NSMutableDictionary     *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithFloat:data.peak] forKey:kDevicePeak];
    [dictionary setObject:[NSNumber numberWithFloat:data.peep] forKey:kDevicePEEP];
    [dictionary setObject:[NSNumber numberWithFloat:data.plateau] forKey:kDevicePlateau];
    [dictionary setObject:[NSNumber numberWithFloat:data.mean] forKey:kDeviceMean];
    [dictionary setObject:[NSNumber numberWithDouble:analysisTime] forKey:kDeviceTime];
    [dictionary setObject:[NSNumber numberWithInt:dRespPressureType] forKey:kDeviceDataType];
    [self addDataToOutput:label source:source data:dictionary];

}

-(void) addTwitchDataToOutput:(NSString *)label source:(NSString *)source time:(NSTimeInterval) analysisTime t1:(float)t1 t2:(float)t2 t3:(float)t3 t4:(float)t4
{
    NSMutableDictionary     *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithFloat:t1] forKey:kDeviceT1];
    [dictionary setObject:[NSNumber numberWithFloat:t2] forKey:kDeviceT2];
    [dictionary setObject:[NSNumber numberWithFloat:t3] forKey:kDeviceT3];
    [dictionary setObject:[NSNumber numberWithFloat:t4] forKey:kDeviceT4];
    [dictionary setObject:[NSNumber numberWithDouble:analysisTime] forKey:kDeviceTime];
    [dictionary setObject:[NSNumber numberWithInt:dTwitchType] forKey:kDeviceDataType];
    [self addDataToOutput:label source:source data:dictionary];
}

-(void) addInfusionDataToOutput:(NSString *)drug time:(NSTimeInterval) analysisTime rate:(float)rate concentration:(float)concentration
{
    NSMutableDictionary     *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:[NSNumber numberWithDouble:analysisTime] forKey:kDeviceTime];
    [dictionary setObject:[NSNumber numberWithFloat:rate] forKey:kDeviceYValue];
    [dictionary setObject:[NSNumber numberWithFloat:concentration] forKey:kPumpConcentration];
    [dictionary setObject:[NSNumber numberWithInt:dSyringePumpType] forKey:kDeviceDataType];
    [self addDataToOutput:kInfusionPump source:drug data:dictionary];

    //BUGBUG, will need to address this
    
    //    if numberOfRecentValues.infusion[1].rate = 0 then begin
    //        test := numberOfRecentValues;
    //        test.infusion[1].rate := 1;
    //        numberOfRecentValues := test;
    //    end;
    //    test := recentValues;
    //    test.infusion[1].rate := rate;
    //    test.infusion[1].massUnits := kNoMassUnits;
    //    recentValues := test;
}

+(BOOL)pressure:(NSDictionary*)p1 isEqualToPressure:(NSDictionary*)p2
{
    return [p1 isEqualToDictionary:p2];
}

-(nullable NSDictionary*) getObjectWithLabel:(NSString*_Nonnull)label source:(NSString* _Nullable)source timeStamp:(NSTimeInterval)timeStamp
{
    NSDictionary    *foundValue = nil;
    if (nil != label) {
        NSMutableDictionary        *typeDict = [self.outputData objectForKey:label];
        if (nil != typeDict) {
            if (nil == source) {
                source = kUnknownSource;
            }
            
            NSMutableArray        *sourceArray = [typeDict objectForKey:source];
            if (nil != sourceArray) {
                for (NSDictionary *dictionary in sourceArray) {
                    NSNumber        *time = [dictionary objectForKey:kDeviceTime];
                    if (timeStamp == time.doubleValue) {
                        foundValue = dictionary;
                        break;
                    }
                }
            }
        }
    }
	return foundValue;
}


-(void) removeObjectFromOutput:(NSString*)label source:(NSString*)source time:(NSTimeInterval)timeStamp
{
    if (nil != label) {
        NSMutableDictionary        *typeDict = [self.outputData objectForKey:label];
        if (nil != typeDict) {
            if (nil == source) {
                source = kUnknownSource;
            }
            
            NSMutableArray        *sourceArray = [typeDict objectForKey:source];
            if (nil != sourceArray) {
                for (NSDictionary *dictionary in sourceArray) {
                    NSNumber        *time = [dictionary objectForKey:kDeviceTime];
                    if (timeStamp == time.doubleValue) {
                        [sourceArray removeObject:dictionary];
                        break;
                    }
                }
            }
        }
    }
}

-(void) removeObjectFromOutput:(NSDictionary*)dataObject
{
    NSString        *label = [dataObject objectForKey:kDeviceLabel];
    NSString        *source = [dataObject objectForKey:kDeviceSource];
    NSNumber        *time = [dataObject objectForKey:kDeviceTime];
    [self removeObjectFromOutput:label source:source time:time.doubleValue];
}

-(NSDictionary*)getDataBuffer
{
	NSDictionary	*returnedData = self.outputData;
	
    self.outputData = nil;

	return returnedData;
}

-(NSString*) stringWithCString:(char*) theData length:(long)length
{
	NSString	*newString =[NSString stringWithCString:theData encoding:NSASCIIStringEncoding];
	
    if (newString.length >=length)
        newString = [newString substringToIndex:length];
    else
        [self logError: [NSString stringWithFormat:@"Malformed string %@. Expected length %li, actual %li",newString,newString.length, length]];
	
	return newString;
}

- (NSInteger)curStatus
{
	return curStatus;
}

- (void)setCurStatus:(NSInteger)newCurStatus
{
	curStatus = newCurStatus;
	[self setLastStatusUpdate:[NSDate timeIntervalSinceReferenceDate]];
}

- (NSTimeInterval)lastStatusUpdate
{
	return lastStatusUpdate;
}

- (void)setLastStatusUpdate:(NSTimeInterval)newLastStatusUpdate
{
	lastStatusUpdate = newLastStatusUpdate;
}

+(float)getMaxStatusSize
{
	return 16;
}

-(NSTimeInterval)getExpectedCommsFrequency
{
	return 5;
}


-(NSTimeInterval)getResetFrequency
{
    return [self getExpectedCommsFrequency]*5;
}

-(void)warnOfAbsentConnection
{
    
}

-(void)logError:(NSString*)errorString
{
    NSString    *finalString = [NSString stringWithFormat:@"%@: %@",self.className,errorString];
    [self.attachedPort logError:finalString];
}

-(void)plotStatus:(NSRect)rect messageRect:(NSRect)messageRect
{
	NSBezierPath	*thePath = [NSBezierPath bezierPathWithOvalInRect:rect];
	NSColor			*fillColor;
	float			lastComms;
	float			alpha;
	static BOOL		lastOn = NO;
	NSString		*delayString;
	NSFontManager	*fontManager = [NSFontManager sharedFontManager];
	NSFont			*theFont = [fontManager convertFont:[NSFont labelFontOfSize:6] toHaveTrait:NSCondensedFontMask];
	NSDictionary	*attributes = [NSMutableDictionary dictionaryWithObject:theFont forKey:NSFontAttributeName];
    NSInteger       lastStatus = curStatus;
	
	if ([NSDate timeIntervalSinceReferenceDate] > lastStatusUpdate + [self getExpectedCommsFrequency]*1.5) {
		[[NSColor blackColor] set];
		lastOn = !lastOn;
		if (lastOn)
			[thePath setLineWidth:0.5];
		else
			[thePath setLineWidth:1.5];
		[thePath stroke];
	}
	else {
		lastComms = [NSDate timeIntervalSinceReferenceDate] -lastStatusUpdate;
		alpha = 1-lastComms / ([self getExpectedCommsFrequency]*1.5);
		switch (lastStatus) {
			case eNoError:
				fillColor = [NSColor colorWithDeviceRed:0 green:1 blue:0 alpha:alpha];
				//fillColor = [NSColor greenColor];
				break;
			case eUnableToParse:
                //orange
				fillColor = [NSColor colorWithDeviceRed:1 green:0.5 blue:0 alpha:alpha];
				break;
			case eGarbledData:
                //red
				fillColor = [NSColor colorWithDeviceRed:1 green:0 blue:0 alpha:alpha];
				break;
			case eChecksumError:
                //blue
				fillColor = [NSColor colorWithDeviceRed:0 green:0 blue:0.5 alpha:alpha];
				break;
            case eUnableToStart:
                //purple
				fillColor = [NSColor colorWithDeviceRed:0.5 green:0 blue:0.5 alpha:alpha];
				break;
            case eAwaitingDataError:
                //pink
				fillColor = [NSColor colorWithDeviceRed:1 green:0 blue:1 alpha:alpha];
				break;
            case eNonMatchingRecordsError:
                //violet
				fillColor = [NSColor colorWithDeviceRed:0.5 green:0.5 blue:1 alpha:alpha];
				break;
            case eDeviceNotConnected:
                fillColor = [NSColor colorWithDeviceRed:0 green:1 blue:1 alpha:alpha];
                break;
			default:
				fillColor = [NSColor colorWithDeviceRed:0.5 green:0 blue:0.5 alpha:alpha];
                [self logError: @"Unhandled status"];
				break;
		}	
		[fillColor set];
		[thePath fill];
		if (eNoError != status){
			[[NSColor blackColor] set];
			[thePath stroke];
		}
		[[NSColor blackColor] set];
		delayString = [NSString stringWithFormat:@"%0.0f",lastComms];
		[delayString drawAtPoint:NSMakePoint(rect.origin.x+2.5,rect.origin.y) withAttributes:attributes];
	}
}

-(NSArray*)logPotentialData
{
	return nil;
}

-(BOOL)handlesCommsConnectionOfKind:(CommsChannelKind)commsChannelKind
{
    MOServiceParameterList  *parameters = [self.availableServices parameterListForCommsType:commsChannelKind];
    BOOL                    canHandle = parameters.count > 0;
    
    return canHandle;
}


-(void)messageWritten:(NSData*)message tag:(long)tag
{
    //ignore;
}

-(void)messageTimedOut:(NSData*)message tag:(long)tag
{
    //ignore;
}

-(NSStringEncoding)stringEncoding
{
    NSStringEncoding stringEncoding = NSASCIIStringEncoding;
    if (0 != self.currentServiceParameter.encodingType)
        stringEncoding = self.currentServiceParameter.encodingType;
    return stringEncoding;
    //    return NSUTF8StringEncoding;
}


-(void) queueString:(NSString*)theString delayInSeconds:(float)delayInSeconds omitIfPresent:(BOOL)omitIfPresent
{
	if (nil != self.attachedPort) {
		//NSLog([@"Sent: " stringByAppendingString:theString]);
		[self.attachedPort queueString:theString atTime:[NSDate timeIntervalSinceReferenceDate]+delayInSeconds omitIfPresent:omitIfPresent];
	}
	else
		[self logError: @"no open port"];
}

-(BOOL)shouldWaitForChar:(char*)flagChar
{
    *flagChar = 0x00;
    return NO;
}

-(NSString*)makeLogString:(NSData*)logData
{
    NSString        *logString = [[NSString alloc]initWithBytes:logData.bytes length:logData.length encoding:self.stringEncoding];
    NSString        *replaceString = [Device sohString];

    
    logString = [logString stringByReplacingOccurrencesOfString:@"\n" withString:@"␤"];
    logString = [logString stringByReplacingOccurrencesOfString:@"\r" withString:@"↵"];
    logString = [logString stringByReplacingOccurrencesOfString:replaceString withString:@"␁"];
    replaceString = [Device escapeString];
    logString = [logString stringByReplacingOccurrencesOfString:replaceString withString:@"␛"];
    replaceString = [Device stxString];
    logString = [logString stringByReplacingOccurrencesOfString:replaceString withString:@"␂"];
    replaceString = [Device eotString];
    logString = [logString stringByReplacingOccurrencesOfString:replaceString withString:@"␄"];
    replaceString = [Device etbString];
    logString = [logString stringByReplacingOccurrencesOfString:replaceString withString:@"␗"];
    replaceString = [Device recordSeparatorString];
    logString = [logString stringByReplacingOccurrencesOfString:replaceString withString:@"␞"];
    replaceString = [Device nakString];
    logString = [logString stringByReplacingOccurrencesOfString:replaceString withString:@"␕"];
    replaceString = [Device ackString];
    logString = [logString stringByReplacingOccurrencesOfString:replaceString withString:@"␆"];
    replaceString = [Device etxString];
    logString = [logString stringByReplacingOccurrencesOfString:replaceString withString:@"␃"];
    return logString;
//    return [self logStringFromStringWithExtras:logData];
}


-(NSString*)logStringFromStringWithExtras:(NSData*)logData
{
    NSString            *logString = @"";
    unichar             theChar;
    NSInteger           index;
    const unsigned char *dataBytes = (const unsigned char *)logData.bytes;
    
    
    for (index = 0;index < logData.length;index++) {
        theChar = dataBytes[index];
        logString = [logString stringByAppendingFormat:@"%c",theChar];
    }
    
    return logString;
}

-(NSString*)logStringFromData:(NSData*)logData
{
    NSString            *logString = @"\t";
    unichar             theChar;
    NSInteger           index;
    const unsigned char *dataBytes = (const unsigned char *)logData.bytes;
    
    
    for (index = 0;index < logData.length;index++) {
        theChar = dataBytes[index];
        logString = [logString stringByAppendingFormat:@"%02X ",theChar];
        if (index %4 == 3)
            logString = [logString stringByAppendingString:@"\t"];
    }
    
    return logString;
}


-(BOOL) canInfuseDrugs
{
    return NO;
}

-(id)startString
{
    return nil;
}

-(id)stopString
{
    return nil;
}

+(BOOL)writeArray:(NSArray*)array containsDuplicate:(NSData*)data
{
    return [array containsObject:data];
}
@end

void BlockMoveData (void* source, void* dest, unsigned long length)
{
    memmove(dest, source, length);
}

float RoundToNSigFigs
(
 float	inputValue,
 short	sigFigs
 )
{
	short		n;
	long		theInput;
	double		theExponent = 1;
	
	for (n=0; n<sigFigs; n++)
		theExponent = theExponent*10;
	theInput = round(inputValue*theExponent);
	inputValue = theInput;
	inputValue = inputValue/theExponent;
	return inputValue;
}
