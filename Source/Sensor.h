//
//  Sensor.h
//  MarcoPolo
//
//  Created by David Symonds on 11/06/08.
//

#import <Cocoa/Cocoa.h>


// The interface for all types of sensors.
@protocol Sensor

// The standard init/dealloc MAY be extended by descendant classes.
- (id)init;
- (void)dealloc;

// Return this sensor's name. MUST be implemented.
- (NSString *)name;

// Whether this sensor takes on multiple values at a time,
// or only a single value. MUST be implemented.
- (BOOL)isMultiValued;

// Attempt to start/stop the sensor. MUST be implemented.
// TODO: -stop should imply that the "value" binding changes.
- (void)start;
- (void)stop;

// Whether the sensor is running. MUST be implemented.
// The KVO notification does NOT need to be posted during -start and -stop;
// it will be assumed they succeed if no change notification is made.
// Binding: "running" (read-only)
- (BOOL)running;

// Retrieve the current value(s) of this sensor. If it is multi-valued, this
// must return an NSArray of the values. MUST be implemented.
// Each value (or the value) MUST be an NSDictionary with two keys:
// - data: An NSCoding-conformant NSObject descendant.
// - description: A human-readable string describing the value.
// If there is no data (or the sensor is stopped) the sensor MAY return nil.
// Binding: "value" (read-only)
- (NSObject *)value;

@end
