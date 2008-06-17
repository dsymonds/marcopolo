//
//  LightSensor.h
//  MarcoPolo
//
//  Created by David Symonds on 17/06/08.
//

#import <Cocoa/Cocoa.h>
#import "Sensor.h"


@interface LightSensor : NSObject<Sensor> {
	NSTimer *timer_;
	NSLock *lock_;
	io_connect_t ioPort_;
	double value_;  // value in [0, 1]
}

@end
