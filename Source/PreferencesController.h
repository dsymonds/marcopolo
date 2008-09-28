//
//  PreferencesController.h
//  MarcoPolo
//
//  Created by David Symonds on 25/09/08.
//

#import <Cocoa/Cocoa.h>


@interface PreferencesController : NSObject {
	@private
	NSArray *panes_;
	NSMutableDictionary *currentPane_;

	NSWindow *preferencesWindow_;
	NSToolbar *toolbar_;
}

- (id)init;

- (void)runPreferences;

@end
