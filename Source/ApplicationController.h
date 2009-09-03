//
//  ApplicationController.h
//  MarcoPolo
//
//  Created by David Symonds on 15/08/08.
//

#import <Cocoa/Cocoa.h>


@class ContextCollection;
@class PreferencesController;
@class SensorArrayController;


@interface ApplicationController : NSObject {
	IBOutlet NSMenu *statusBarMenu;
	NSStatusItem *statusBarItem_;

	PreferencesController *preferencesController_;

	ContextCollection *contextCollection_;
	SensorArrayController *sensorArrayController_;
}

- (IBAction)runPreferences:(id)sender;

- (ContextCollection *)contextCollection;
- (SensorArrayController *)sensorArrayController;

@end
