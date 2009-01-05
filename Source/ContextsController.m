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
		// XXX: DUMMY CONTEXTS
		ContextTree *tree = [ContextTree contextTree];
		[tree addContext:[Context contextWithName:@"Home"]];
		Context *work = [Context contextWithName:@"Work"];
		[tree addContext:work];
		[tree addContext:[Context contextWithName:@"Desk" parent:work]];
		[tree addContext:[Context contextWithName:@"Conference Room" parent:work]];
		ContextGroup *cg = [ContextGroup contextGroupWithName:@"Location"
							  contextTree:tree];
		[contextGroups_ addObject:cg];

		tree = [ContextTree contextTree];
		[tree addContext:[Context contextWithName:@"Automatic"]];
		[tree addContext:[Context contextWithName:@"Work"]];
		cg = [ContextGroup contextGroupWithName:@"Network" contextTree:tree];
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
	} else if ([item isKindOfClass:[ContextGroup class]]) {
		// A context group: top-level contexts.
		ContextTree *tree = [(ContextGroup *) item contextTree];
		return [[tree topLevelContexts] objectAtIndex:index];
	} else if ([item isKindOfClass:[Context class]]) {
		// A context in a tree: return its children
		Context *ctxt = (Context *) item;
		ContextTree *tree = [ctxt tree];
		return [[tree childrenOfContext:ctxt] objectAtIndex:index];
	}

	NSLog(@"ERROR: This should never be reached! (%s)", _cmd);
	return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	if ([item isKindOfClass:[ContextGroup class]])
		return YES;
	else if ([item isKindOfClass:[Context class]]) {
		// A context is expandable iff it has children.
		return ([self outlineView:outlineView numberOfChildrenOfItem:item] > 0);
	}

	NSLog(@"ERROR: This should never be reached! (%s)", _cmd);
	return NO;
}

- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
	if (!item) {
		// Top-level: context groups
		return [contextGroups_ count];
	} else if ([item isKindOfClass:[ContextGroup class]]) {
		// A context group: count the number of top-level contexts
		ContextTree *tree = [(ContextGroup *) item contextTree];
		return [[tree topLevelContexts] count];
	} else if ([item isKindOfClass:[Context class]]) {
		// A context in a tree: count its children
		Context *ctxt = (Context *) item;
		ContextTree *tree = [ctxt tree];
		return [[tree childrenOfContext:ctxt] count];
	}

	NSLog(@"ERROR: This should never be reached! (%s)", _cmd);
	return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	// TODO: support multiple columns

	if ([item isKindOfClass:[ContextGroup class]]) {
		ContextGroup *cg = item;
		return [cg name];
	} else if ([item isKindOfClass:[Context class]]) {
		return [(Context *) item name];
	}

	NSLog(@"ERROR: This should never be reached! (%s)", _cmd);
	return @"???";
}

//- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
//{
//}

@end
