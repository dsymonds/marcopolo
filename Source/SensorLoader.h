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

// Loads the sensor from the given bundle. Returns nil on error.
+ (NSObject<Sensor> *)sensorFromBundle:(NSBundle *)bundle;

@end
