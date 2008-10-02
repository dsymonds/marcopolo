//
//  ApplicationController.h
//  MarcoPolo
//
//  Created by David Symonds on 15/08/08.
//

#import <Cocoa/Cocoa.h>


@class ContextsController;
@class PreferencesController;


@interface ApplicationController : NSObject {
	IBOutlet NSMenu *statusBarMenu;
	NSStatusItem *statusBarItem_;

	PreferencesController *preferencesController_;

	ContextsController *contextsController_;
}

- (IBAction)runPreferences:(id)sender;

- (ContextsController *)contextsController;

@end
