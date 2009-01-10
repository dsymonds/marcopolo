//
//  ContextCollectionController.m
//  MarcoPolo
//
//  Created by David Symonds on 2/10/08.
//

#import "Context.h"
#import "ContextCollection.h"
#import "ContextCollectionController.h"
#import "ContextGroup.h"
#import "ContextTree.h"


@implementation ContextCollectionController

- (id)init
{
	if (!(self = [super init]))
		return nil;

	contextCollection_ = [[ContextCollection alloc] init];

	{
		// XXX: DUMMY CONTEXTS
		Context *home = [Context contextWithName:@"Home"];
		Context *work = [Context contextWithName:@"Work"];
		Context *work_desk = [Context contextWithName:@"Desk" parent:work];
		Context *work_conf = [Context contextWithName:@"Conference Room" parent:work];
		Context *net_auto = [Context contextWithName:@"Automatic"];
		Context *net_work = [Context contextWithName:@"Work"];

		[work setConfidence:[NSNumber numberWithFloat:0.8]];
		[work_desk setConfidence:[NSNumber numberWithFloat:0.85]];
		[net_work setConfidence:[NSNumber numberWithFloat:0.9]];

		ContextTree *location_tree = [ContextTree contextTree];
		[location_tree addContextsFromArray:[NSArray arrayWithObjects:
					    home, work, work_desk, work_conf, nil]];
		ContextGroup *cg = [ContextGroup contextGroupWithName:@"Location"
							  contextTree:location_tree];
		[cg setSelection:work_desk];
		[contextCollection_ addContextGroup:cg];

		ContextTree *net_tree = [ContextTree contextTree];
		[net_tree addContextsFromArray:[NSArray arrayWithObjects:
						net_auto, net_work, nil]];
		cg = [ContextGroup contextGroupWithName:@"Network"
					    contextTree:net_tree];
		[cg setSelection:net_work];
		[contextCollection_ addContextGroup:cg];
	}

	return self;
}

- (void)dealloc
{
	[contextCollection_ release];
	[super dealloc];
}

#pragma mark -
#pragma mark NSOutlineViewDataSource methods

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item
{
	if (!item) {
		// Top-level: a whole context group
		return [contextCollection_ contextGroupAtIndex:index];
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
		return [contextCollection_ count];
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

@end
