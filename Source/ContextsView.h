//
//  ContextsView.h
//  MarcoPolo
//
//  Created by David Symonds on 2/10/08.
//

#import <Cocoa/Cocoa.h>


@class PreferencesPaneController;


@interface ContextsView : NSOutlineView {
	IBOutlet PreferencesPaneController *preferencesPaneController;
}

@end
