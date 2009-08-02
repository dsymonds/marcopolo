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
@interface SensorStub : NSObject<Sensor> {
	@private
	NSObject<Sensor> *sensor_;
	NSString *sensorRunnerPath_, *bundlePath_;

	NSTask *task_;
	SensorProtocolEndpoint *endpoint_;
	BOOL running_;
	NSObject *value_;
}

+ (id)sensorStubWithSensorInBundle:(NSBundle *)bundle;
- (id)initWithSensorInBundle:(NSBundle *)bundle;

- (NSString *)name;

- (BOOL)isMultiValued;

- (void)start;
- (void)stop;
- (BOOL)running;

- (NSObject *)value;

@end
