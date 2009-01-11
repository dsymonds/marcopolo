//
//  ContextPreferencesPaneController.m
//  MarcoPolo
//
//  Created by David Symonds on 11/01/09.
//

#import "ContextPreferencesPaneController.h"


@implementation ContextPreferencesPaneController

- (void)awakeFromNib
{
	[[NSNotificationCenter defaultCenter] addObserver:self
						 selector:@selector(selectionChanged:)
						     name:NSOutlineViewSelectionDidChangeNotification
						   object:contextCollectionView];
}

- (void)selectionChanged:(id)sender
{
	[self willChangeValueForKey:@"canRemove"];

	BOOL removable = NO;
	int row = [contextCollectionView selectedRow];
	if (row >= 0) {
		id item = [contextCollectionView itemAtRow:row];
		removable = ![contextCollectionView isExpandable:item];
	}
	[self setValue:[NSNumber numberWithBool:removable] forKey:@"canRemove"];

	[self didChangeValueForKey:@"canRemove"];
}

@end
