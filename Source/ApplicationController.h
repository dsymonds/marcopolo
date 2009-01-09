//
//  ApplicationController.h
//  MarcoPolo
//
//  Created by David Symonds on 15/08/08.
//

#import <Cocoa/Cocoa.h>


@class ContextCollectionController;
@class PreferencesController;


@interface ApplicationController : NSObject {
	IBOutlet NSMenu *statusBarMenu;
	NSStatusItem *statusBarItem_;

	PreferencesController *preferencesController_;

	ContextCollectionController *contextCollectionController_;
}

- (IBAction)runPreferences:(id)sender;

- (ContextCollectionController *)contextCollectionController;

@end
