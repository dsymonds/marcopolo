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
	BOOL started_;
}

+ (id)sensorControllerWithSensor:(NSObject<Sensor> *)sensor;
- (id)initWithSensor:(NSObject<Sensor> *)sensor;

// Binding: name
- (NSString *)name;

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
