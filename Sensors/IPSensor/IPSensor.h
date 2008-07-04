//
//  IPSensor.h
//  MarcoPolo
//
//  Created by David Symonds on 4/07/08.
//

#import <Cocoa/Cocoa.h>
#import <SystemConfiguration/SCDynamicStore.h>
#import "Sensor.h"


@interface IPSensor : NSObject<Sensor> {
	NSLock *lock_;
	NSMutableArray *addresses_;
	SCDynamicStoreRef store_;
	CFRunLoopSourceRef runLoop_;
}

@end
