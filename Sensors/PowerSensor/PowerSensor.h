//
//  PowerSensor.h
//  MarcoPolo
//
//  Created by David Symonds on 19/06/08.
//

#import <Cocoa/Cocoa.h>
#import "Sensor.h"


@interface PowerSensor : NSObject<Sensor> {
	@private
	enum {
		kUnknown = -1,
		kBattery = 0,
		kAC = 1
	} state_;
	CFRunLoopSourceRef runLoopSource_;
}

@end
