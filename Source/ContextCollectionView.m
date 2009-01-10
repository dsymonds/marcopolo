//
//  ContextCollectionView.m
//  MarcoPolo
//
//  Created by David Symonds on 2/10/08.
//

#import "ApplicationController.h"
#import "Context.h"
#import "ContextCollectionController.h"
#import "ContextCollectionView.h"
#import "ContextGroup.h"
#import "PreferencesPaneController.h"


@implementation ContextCollectionView

- (void)awakeFromNib
{
	ccc_ = [[preferencesPaneController applicationController] contextCollectionController];
	[self setDataSource:self];
}

#pragma mark -
#pragma mark NSOutlineViewDataSource methods

// Most of the data source methods merely proxy through to the ContextCollectionController

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item
{
	return [ccc_ outlineView:outlineView child:index ofItem:item];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	return [ccc_ outlineView:outlineView isItemExpandable:item];
}

- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
	return [ccc_ outlineView:outlineView numberOfChildrenOfItem:item];
}

- (NSString *)formatConfidence:(NSNumber *)confidence
{
	NSNumberFormatter *nf = [[[NSNumberFormatter alloc] init] autorelease];
	[nf setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[nf setNumberStyle:NSNumberFormatterPercentStyle];
	return [nf stringFromNumber:confidence];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	NSString *column = [tableColumn identifier];

	if ([item isKindOfClass:[ContextGroup class]]) {
		ContextGroup *cg = item;
		if ([column isEqualToString:@"name"])
			return [cg attributedName];
		else if ([column isEqualToString:@"state"]) {
			return [cg attributedState];
		}
	} else if ([item isKindOfClass:[Context class]]) {
		Context *c = item;
		if ([column isEqualToString:@"name"])
			return [c name];
		else if ([column isEqualToString:@"state"])
			return [self formatConfidence:[c confidence]];
	}

	NSLog(@"ERROR: This should never be reached! (%s)", _cmd);
	return @"???";
}

//- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
//{
// TODO!
//}

@end
