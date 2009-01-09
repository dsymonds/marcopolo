//
//  ContextCollectionView.h
//  MarcoPolo
//
//  Created by David Symonds on 2/10/08.
//

#import <Cocoa/Cocoa.h>


@class PreferencesPaneController;


@interface ContextCollectionView : NSOutlineView {
	IBOutlet PreferencesPaneController *preferencesPaneController;
}

@end
