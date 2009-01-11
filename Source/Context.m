//
//  Context.m
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import "Context.h"


@interface Context (Private)

- (void)setParent:(Context *)parent;
- (void)recomputeAttributedState;

@end

#pragma mark -

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
	[parent addChild:c];
	return c;
}

- (id)init
{
	if (!(self = [super init]))
		return nil;

	name_ = @"";

	children_ = [[NSMutableArray alloc] init];
	parent_ = nil;

	confidence_ = nil;
	attributedState_ = nil;

	return self;
}

- (void)dealloc
{
	[name_ release];
	[children_ release];
	[confidence_ release];
	[attributedState_ release];
	[super dealloc];
}

#pragma mark Accessors

- (NSString *)name
{
	return name_;
}

- (NSString *)attributedName
{
	return name_;
}

- (NSAttributedString *)attributedState
{
	return attributedState_;
}

- (Context *)parent
{
	return parent_;
}

- (NSMutableArray *)children
{
	return children_;
}

- (NSNumber *)confidence
{
	return confidence_;
}

- (NSString *)fullPath
{
	NSMutableString *path = [NSMutableString stringWithString:name_];
	Context *c;
	for (c = parent_; c; c = [c parent]) {
		[path insertString:[NSString stringWithFormat:@"%@/", [c name]]
			   atIndex:0];
	}
	return path;
}

- (void)setName:(NSString *)name
{
	[name_ autorelease];
	name_ = [name copy];
}

- (void)addChild:(Context *)child
{
	[children_ addObject:child];
	[child setParent:self];
}

- (void)setChildren:(NSArray *)children
{
	[children_ setArray:children];

	NSEnumerator *en = [children_ objectEnumerator];
	Context *c;
	while ((c = [en nextObject]))
		[c setParent:self];
}

- (void)setConfidence:(NSNumber *)confidence
{
	[confidence_ autorelease];
	confidence_ = [confidence retain];
	[self recomputeAttributedState];
}

#pragma mark -

- (void)setParent:(Context *)parent
{
	parent_ = parent;
}

- (void)recomputeAttributedState
{
	[self willChangeValueForKey:@"attributedState"];

	[attributedState_ release];
	if (confidence_ > 0) {
		NSNumberFormatter *nf = [[[NSNumberFormatter alloc] init] autorelease];
		[nf setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[nf setNumberStyle:NSNumberFormatterPercentStyle];
		attributedState_ = [[nf stringFromNumber:confidence_] retain];
	} else
		attributedState_ = nil;

	[self didChangeValueForKey:@"attributedState"];
}

@end
