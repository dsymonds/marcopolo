//
//  PreferencesController.h
//  MarcoPolo
//
//  Created by David Symonds on 25/09/08.
//

#import <Cocoa/Cocoa.h>


@class ApplicationController;


@interface PreferencesController : NSObject {
	@private
	ApplicationController *applicationController_;

	NSArray *panes_;
	NSMutableDictionary *currentPane_;

	NSWindow *preferencesWindow_;
	NSToolbar *toolbar_;
}

- (id)initWithApplicationController:(ApplicationController *)applicationController;

- (void)runPreferences;

// Bindings
- (ApplicationController *)application;

@end
