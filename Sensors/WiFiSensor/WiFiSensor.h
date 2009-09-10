//
//  WiFiSensor.h
//  MarcoPolo
//
//  Created by David Symonds on 2/08/09.
//

#import <Cocoa/Cocoa.h>
#import "Sensor.h"


@interface WiFiSensor : NSObject<Sensor> {
	@private
	NSLock *lock_;
	NSMutableArray *accessPoints_;
	NSTimer *timer_;  // owned by run loop
}

@end
