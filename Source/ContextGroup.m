//
//  ContextGroup.m
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import "Context.h"
#import "ContextGroup.h"
#import "ContextTree.h"


@implementation ContextGroup

+ (id)contextGroupWithName:(NSString *)name
{
	return [[[self alloc] initWithName:name] autorelease];
}

+ (id)contextGroupWithName:(NSString *)name contextTree:(ContextTree *)contextTree
{
	ContextGroup *cg = [self contextGroupWithName:name];

	[cg setContextTree:contextTree];

	return cg;
}

- (id)initWithName:(NSString *)name
{
	if (!(self = [super init]))
		return nil;

	name_ = [name retain];
	contextTree_ = [[ContextTree alloc] init];
	selection_ = nil;

	return self;
}

- (void)dealloc
{
	[name_ release];
	[contextTree_ release];

	[super dealloc];
}

#pragma mark Accessors

- (NSString *)name
{
	return name_;
}

- (int)count
{
	return [contextTree_ count];
}

- (ContextTree *)contextTree
{
	return contextTree_;
}

#pragma mark -

- (void)setContextTree:(ContextTree *)contextTree
{
	[contextTree_ autorelease];
	contextTree_ = [contextTree retain];
}

@end
