//
//  ContextPreferencesPaneController.h
//  MarcoPolo
//
//  Created by David Symonds on 11/01/09.
//

#import <Cocoa/Cocoa.h>
#import "PreferencesPaneController.h"


@interface ContextPreferencesPaneController : PreferencesPaneController {
	IBOutlet NSOutlineView *contextCollectionView;

	// Binding: canRemove
	NSNumber *canRemove;
}

@end
