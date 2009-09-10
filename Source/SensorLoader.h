//
//  SensorLoader.h
//  MarcoPolo
//
//  Created by David Symonds on 13/03/09.
//

#import <Cocoa/Cocoa.h>
#import "Sensor.h"


@interface SensorLoader : NSObject {
}

// Returns whether we can load a sensor from the bundle.
// This catches OS X version restrictions.
// It does not guarantee that +sensorFromBundle will succeed.
+ (BOOL)canLoadSensorFromBundle:(NSBundle *)bundle;

// Loads the sensor from the given bundle. Returns nil on error.
+ (NSObject<Sensor> *)sensorFromBundle:(NSBundle *)bundle;

@end
