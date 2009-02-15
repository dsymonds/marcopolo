//
//  SensorRunnerMonitor.h
//  MarcoPolo
//
//  Created by David Symonds on 15/02/09.
//

#import <Cocoa/Cocoa.h>
#import "SensorController.h"


@interface SensorRunnerMonitor : NSObject {
	@private
	SensorController *sensorController_;
	NSPipe *inputPipe_;
	BOOL finished_;
	NSMutableData *queuedData_;
}

+ (SensorRunnerMonitor *)monitorWithSensorController:(SensorController *)sensorController;
- (id)initWithSensorController:(SensorController *)sensorController;

- (void)setInput:(NSFileHandle *)fileHandle;

- (BOOL)finished;

@end
