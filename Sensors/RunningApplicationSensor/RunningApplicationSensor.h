//
//  RunningApplicationSensor.h
//  MarcoPolo
//
//  Created by David Symonds on 1/08/09.
//

#import <Cocoa/Cocoa.h>
#import "Sensor.h"


@interface RunningApplicationSensor : NSObject<Sensor> {
	@private
	NSLock *lock_;
	NSMutableArray *apps_;
}

@end
