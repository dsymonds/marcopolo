//
//  SensorRunnerMonitor.h
//  MarcoPolo
//
//  Created by David Symonds on 15/02/09.
//

#import <Cocoa/Cocoa.h>
#import "SensorController.h"
#import "SensorProtocolEndpoint.h"


@interface SensorRunnerMonitor : NSObject {
	@private
	SensorController *sensorController_;
	SensorProtocolEndpoint *endpoint_;
}

+ (SensorRunnerMonitor *)monitorWithSensorController:(SensorController *)sensorController;
- (id)initWithSensorController:(SensorController *)sensorController;

- (BOOL)finished;

@end
