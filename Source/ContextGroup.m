//
//  ContextGroup.m
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import "Context.h"
#import "ContextGroup.h"


@implementation ContextGroup

+ (id)contextGroup
{
	return [[[self alloc] init] autorelease];
}

+ (id)contextGroupWithContexts:(NSArray *)contextArray
{
	ContextGroup *cg = [self contextGroup];

	[cg addContextsFromArray:contextArray];

	return cg;
}

- (id)init
{
	if (!(self = [super init]))
		return nil;

	contexts_ = [[NSMutableArray alloc] init];
	selection_ = nil;

	return self;
}

#pragma mark Accessors

- (int)count
{
	return [contexts_ count];
}

- (NSArray *)contexts
{
	return contexts_;
}

- (NSArray *)topLevelContexts
{
	NSMutableArray *array = [NSMutableArray array];
	NSEnumerator *en = [contexts_ objectEnumerator];
	Context *c;
	while ((c = [en nextObject]))
		if (![c parent])
			[array addObject:c];
	return array;
}

- (void)addContext:(Context *)context
{
	[contexts_ addObject:context];
}

- (void)addContextsFromArray:(NSArray *)contextArray
{
	NSEnumerator *en = [contextArray objectEnumerator];
	Context *c;
	while ((c = [en nextObject]))
		[self addContext:c];
}

@end
