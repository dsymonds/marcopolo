//
//  SensorTesterTableView.m
//  MarcoPolo
//
//  Created by David Symonds on 1/08/09.
//

#import "SensorController.h"
#import "SensorTesterTableView.h"


@implementation SensorTesterTableView

- (void)keyDown:(NSEvent *)event
{
	if ([event keyCode] == 49) {
		// Space bar: start/stop the selected sensor.
		int row = [self selectedRow];
		if (row < 0) {
			NSBeep();
			return;
		}

		SensorController *sc = [[sensorArray arrangedObjects] objectAtIndex:row];
		[sc setStarted:![sc started]];
		return;
	}

	[super keyDown:event];
}

@end
