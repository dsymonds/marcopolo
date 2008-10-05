//
//  ContextsController.m
//  MarcoPolo
//
//  Created by David Symonds on 2/10/08.
//

#import "Context.h"
#import "ContextGroup.h"
#import "ContextTree.h"
#import "ContextsController.h"


@implementation ContextsController

- (id)init
{
	if (!(self = [super init]))
		return nil;

	contextGroups_ = [[NSMutableArray alloc] init];

	{
		// DUMMY CONTEXTS
		ContextTree *tree = [ContextTree contextTree];
		[tree addContext:[Context contextWithName:@"Home"]];
		[tree addContext:[Context contextWithName:@"Work"]];
		ContextGroup *cg = [ContextGroup contextGroupWithName:@"Location"
							  contextTree:tree];
		[contextGroups_ addObject:cg];
	}

	return self;
}

- (void)dealloc
{
	[contextGroups_ release];

	[super dealloc];
}

#pragma mark -
#pragma mark NSOutlineViewDataSource methods

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item
{
	if (!item) {
		// Top-level: a whole context group
		return [contextGroups_ objectAtIndex:index];
	} else {
		// TODO: traverse into context groups
		NSLog(@"TODO: NYI! %@", _cmd);
		return nil;
	}
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	if ([item isKindOfClass:[ContextGroup class]])
		return YES;

	// TODO
	return NO;
}

- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
	if (!item) {
		// Top-level: context groups
		return [contextGroups_ count];
	} else {
		// TODO: traverse into context groups
		return 0;
	}
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	// TODO: support multiple columns

	if ([item isKindOfClass:[ContextGroup class]]) {
		ContextGroup *cg = item;
		return [cg name];
	}

	return @"???";
}

//- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
//{
//}

@end
