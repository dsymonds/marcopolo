//
//  PreferencesController.h
//  MarcoPolo
//
//  Created by David Symonds on 25/09/08.
//

#import <Cocoa/Cocoa.h>


@interface PreferencesController : NSObject {
	@private
	NSWindow *preferencesWindow_;
	NSArray *panes_;
}

- (id)init;

- (void)runPreferences;

@end
