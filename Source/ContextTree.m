//
//  ContextTree.m
//  MarcoPolo
//
//  Created by David Symonds on 5/10/08.
//

#import "Context.h"
#import "ContextTree.h"


@implementation ContextTree

+ (id)contextTree
{
	return [[[self alloc] init] autorelease];
}

- (id)init
{
	if (!(self = [super init]))
		return nil;

	contexts_ = [[NSMutableArray alloc] init];
	topLevelContexts_ = [[NSMutableArray alloc] init];

	return self;
}

- (void)dealloc
{
	[contexts_ release];
	[topLevelContexts_ release];

	[super dealloc];
}

#pragma mark -

- (int)count
{
	return [contexts_ count];
}

- (BOOL)containsContext:(Context *)context
{
	return [contexts_ containsObject:context];
}

- (NSArray *)allContexts
{
	return contexts_;
}

- (NSArray *)topLevelContexts
{
	return topLevelContexts_;
}

#pragma mark -

- (void)addContext:(Context *)context
{
	if ([self containsContext:context]) {
		NSLog(@"ERROR: Tried to double-add a context!");
		return;
	}
	Context *parent = [context parent];
	if (parent && ![self containsContext:parent]) {
		NSLog(@"ERROR: Tried to refer to a parent not in this context tree");
		parent = nil;
	}
	[contexts_ addObject:context];
	if (!parent)
		[topLevelContexts_ addObject:context];
}

- (void)addContextsFromArray:(NSArray *)array
{
	NSEnumerator *en = [array objectEnumerator];
	Context *c;
	while ((c = [en nextObject]))
		[self addContext:c];
}

@end
