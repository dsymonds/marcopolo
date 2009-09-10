//
//  WiFiApple80211Sensor.h
//  MarcoPolo
//
//  Created by David Symonds on 2/08/09.
//

#import <Cocoa/Cocoa.h>
#import "Sensor.h"


@interface WiFiApple80211Sensor : NSObject<Sensor> {
	@private
	NSLock *lock_;
	NSMutableArray *accessPoints_;
	NSTimer *timer_;  // owned by run loop
}

@end
