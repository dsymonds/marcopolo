//
//  USBSensor.h
//  MarcoPolo
//
//  Created by David Symonds on 15/06/08.
//

#import <Cocoa/Cocoa.h>
#import "Sensor.h"


@interface USBSensor : NSObject<Sensor> {
	NSLock *lock_;
	NSMutableArray *devices_;

	IONotificationPortRef notificationPort_;
	CFRunLoopSourceRef runLoopSource_;
	io_iterator_t addedIterator_, removedIterator_;
}

@end
