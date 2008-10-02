//
//  ContextGroup.m
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import "Context.h"
#import "ContextGroup.h"


@implementation ContextGroup

+ (id)contextGroupWithName:(NSString *)name
{
	return [[[self alloc] initWithName:name] autorelease];
}

+ (id)contextGroupWithName:(NSString *)name contexts:(NSArray *)contextArray
{
	ContextGroup *cg = [self contextGroupWithName:name];

	[cg addContextsFromArray:contextArray];

	return cg;
}

- (id)initWithName:(NSString *)name
{
	if (!(self = [super init]))
		return nil;

	name_ = [name retain];
	contexts_ = [[NSMutableArray alloc] init];
	selection_ = nil;

	return self;
}

- (void)dealloc
{
	[name_ release];
	[contexts_ release];

	[super dealloc];
}

#pragma mark Accessors

- (NSString *)name
{
	return name_;
}

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
