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

- (id)initWithSensor:(NSObject<Sensor> *)sensor;

// Binding: name
- (NSString *)name;

// Binding: started
- (BOOL)started;
- (void)setStarted:(BOOL)start;

// Binding: value
- (NSObject *)value;

@end
