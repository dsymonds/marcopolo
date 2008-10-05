//
//  Context.m
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import "Context.h"


@implementation Context

+ (id)context
{
	return [[[self alloc] init] autorelease];
}

+ (id)contextWithName:(NSString *)name
{
	Context *c = [self context];
	[c setName:name];
	return c;
}

+ (id)contextWithName:(NSString *)name parent:(Context *)parent
{
	Context *c = [self context];
	[c setName:name];
	[c setParent:parent];
	return c;
}

- (id)init
{
	if (!(self = [super init]))
		return nil;

	name_ = @"";
	parent_ = nil;

	return self;
}

- (void)dealloc
{
	[name_ release];
	[parent_ release];
	[super dealloc];
}

#pragma mark Accessors

- (NSString *)name
{
	return name_;
}

- (Context *)parent
{
	return parent_;
}

- (void)setName:(NSString *)name
{
	[name_ autorelease];
	name_ = [name copy];
}

- (void)setParent:(Context *)parent
{
	[parent_ autorelease];
	parent_ = [parent retain];
}

@end
