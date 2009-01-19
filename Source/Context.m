//
//  Context.m
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import "Context.h"


@interface Context (Private)

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

+ (id)contextWithName:(NSString *)name parent:(ContextNode *)parent
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

	confidence_ = nil;

	return self;
}

- (void)dealloc
{
	[confidence_ release];
	[super dealloc];
}

#pragma mark Accessors

- (NSNumber *)confidence
{
	return confidence_;
}

- (NSString *)fullPath
{
	NSMutableArray *walk = [NSMutableArray array];

	ContextNode *c;
	for (c = self; c && [c isKindOfClass:[Context class]]; c = [c parent])
		[walk insertObject:[c name] atIndex:0];

	return [walk componentsJoinedByString:@"/"];
}

#pragma mark Setters

- (void)setConfidence:(NSNumber *)confidence
{
	[confidence_ autorelease];
	confidence_ = [confidence retain];
	[self recomputeAttributedState];
}

#pragma mark -

- (void)recomputeAttributedName
{
	[self willChangeValueForKey:@"attributedName"];

	[attributedName_ release];
	attributedName_ = [[NSAttributedString alloc] initWithString:[self name]];

	[self didChangeValueForKey:@"attributedName"];
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
