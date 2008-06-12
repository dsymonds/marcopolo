//
//  Sensor.h
//  MarcoPolo
//
//  Created by David Symonds on 11/06/08.
//

#import <Cocoa/Cocoa.h>


// The interface for all types of sensors.
// A sensor is considered "active" once it is created via alloc & init.
@protocol Sensor

// Return this sensor's name. MUST be reimplemented by descendant classes.
+ (NSString *)name;

// Whether this sensor takes on multiple values at a time, or only a single value.
// MUST be reimplemented by descendant classes.
+ (BOOL)isMultiValued;

// The standard init/dealloc MAY be extended by descendant classes.
- (id)init;
- (void)dealloc;

@end
