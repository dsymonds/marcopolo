//
//  CrashSensor.h
//  MarcoPolo
//
//  Created by David Symonds on 2/08/09.
//

#import <Cocoa/Cocoa.h>
#import "Sensor.h"


// A sensor for testing. It crashes three seconds after starting.
@interface CrashSensor : NSObject<Sensor> {
	@private
	NSTimer *crashTimer_, *updateTimer_;
}

@end
