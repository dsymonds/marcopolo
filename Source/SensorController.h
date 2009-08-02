//
//  SensorController.h
//  MarcoPolo
//
//  Created by David Symonds on 13/06/08.
//

#import <Cocoa/Cocoa.h>

@protocol Sensor;


// MVC wrapper for a sensor.
@interface SensorController : NSObject {
	@private
	NSObject<Sensor> *sensor_;
}

+ (id)sensorControllerWithSensor:(NSObject<Sensor> *)sensor;
+ (id)sensorControllerWithSensorInBundle:(NSBundle *)bundle;
- (id)initWithSensor:(NSObject<Sensor> *)sensor;
- (id)initWithSensorInBundle:(NSBundle *)bundle;

// Binding: name
- (NSString *)name;

// Binding: running
- (BOOL)running;
- (void)setRunning:(BOOL)shouldRun;

// Binding: value
- (NSObject *)value;

// Binding: value summary
// This is either the value's description (if it's single-valued),
// or the number of values (if it's multi-valued).
- (NSObject *)valueSummary;

@end
