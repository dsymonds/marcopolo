//
//  SensorTableView.h
//  MarcoPolo
//
//  Created by David Symonds on 1/08/09.
//

#import <Cocoa/Cocoa.h>


// A custom NSTableView for displaying a list of sensors.
// Hitting space while a row is selected will start/stop that sensor.
@interface SensorTableView : NSTableView {
	IBOutlet NSArrayController *sensorArray;
}

@end
