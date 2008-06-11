//
//  Sensor.h
//  MarcoPolo
//
//  Created by David Symonds on 11/06/08.
//

#import <Cocoa/Cocoa.h>


// The abstract interface for all types of sensors.
// A sensor is considered "active" once it is created.
@interface Sensor : NSObject {
}

// Return this sensor's name. Must be reimplemented by descendant classes.
+ (NSString *)name;

// Whether this sensor takes on multiple values at a time, or only a single value.
// Must be reimplemented by descendant classes.
+ (BOOL)isMultiValued;

// The standard init/dealloc may be overridden by descendant classes.
- (id)init;
- (void)dealloc;

@end
