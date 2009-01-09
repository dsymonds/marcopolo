//
//  ContextCollection.m
//  MarcoPolo
//
//  Created by David Symonds on 9/01/09.
//

#import "ContextCollection.h"


@implementation ContextCollection

- (id)init
{
	if (!(self = [super init]))
		return nil;

	contextGroups_ = [[NSMutableArray alloc] init];

	return self;
}

- (void)dealloc
{
	[contextGroups_ release];
	[super dealloc];
}

#pragma mark -

- (int)count
{
	return [contextGroups_ count];
}

- (ContextGroup *)contextGroupAtIndex:(int)index
{
	return [contextGroups_ objectAtIndex:index];
}

#pragma mark -

- (void)addContextGroup:(ContextGroup *)contextGroup
{
	[contextGroups_ addObject:contextGroup];
}

@end
