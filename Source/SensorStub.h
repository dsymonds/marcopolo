//
//  SensorStub.h
//  MarcoPolo
//
//  Created by David Symonds on 13/03/09.
//

#import <Cocoa/Cocoa.h>
#import "Sensor.h"
#import "SensorProtocolEndpoint.h"


// KVO-compliant stub for running a sensor in a separate process.
// This is the endpoint on the application side.
// See SensorRunnerMonitor for the sensor side.
@interface SensorStub : NSObject {
	@private
	NSObject<Sensor> *sensor_;
	NSTask *task_;
	SensorProtocolEndpoint *endpoint_;
	BOOL started_;
}

+ (id)sensorStubWithSensorInBundle:(NSBundle *)bundle;
- (id)initWithSensorInBundle:(NSBundle *)bundle;

// Binding: name
- (NSString *)name;

- (BOOL)isMultiValued;

// Binding: started
- (BOOL)started;
- (void)setStarted:(BOOL)start;

// Binding: value
- (NSObject *)value;

// Binding: value summary
// This is either the value's description (if it's single-valued),
// or the number of values (if it's multi-valued).
- (NSObject *)valueSummary;

@end
