//
//  ContextNode.m
//  MarcoPolo
//
//  Created by David Symonds on 19/01/09.
//

#import "ContextNode.h"


@interface ContextNode (Private)

- (void)setParent:(ContextNode *)parent;

// These should be overridden in Context/ContextGroup.
- (void)recomputeAttributedName;
- (void)recomputeAttributedState;

@end

#pragma mark -

@implementation ContextNode

- (id)init
{
	if (!(self = [super init]))
		return nil;

	name_ = @"";
	children_ = [[NSMutableArray alloc] init];

	parent_ = nil;

	return self;
}

- (void)dealloc
{
	[name_ release];
	[children_ release];
	[super dealloc];
}

#pragma mark NSCoding protocol

- (id)initWithCoder:(NSCoder *)decoder
{
	// XXX: How do I distinguish Context from ContextGroup?
	ContextNode *c = [[ContextNode alloc] init];
	[c setName:[decoder decodeObjectForKey:@"Name"]];
	[c setChildren:[decoder decodeObjectForKey:@"Children"]];
	return c;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:name_ forKey:@"Name"];
	[encoder encodeObject:children_ forKey:@"Children"];
}

#pragma mark Accessors

- (NSString *)name
{
	return name_;
}

- (NSMutableArray *)children
{
	return children_;
}

- (ContextNode *)parent
{
	return parent_;
}

- (NSAttributedString *)attributedName
{
	return attributedName_;
}

- (NSAttributedString *)attributedState
{
	return attributedState_;
}

- (NSArray *)descendants
{
	NSMutableArray *kids = [NSMutableArray arrayWithCapacity:[children_ count]];

	NSEnumerator *en = [children_ objectEnumerator];
	ContextNode *c;
	while ((c = [en nextObject])) {
		[kids addObject:c];
		[kids addObjectsFromArray:[c descendants]];
	}

	return kids;
}

#pragma mark Setters

- (void)setName:(NSString *)name
{
	[name_ autorelease];
	name_ = [name retain];
	[self recomputeAttributedName];
}

- (void)setChildren:(NSArray *)children
{
	[children_ setArray:children];

	NSEnumerator *en = [children_ objectEnumerator];
	ContextNode *c;
	while ((c = [en nextObject]))
		[c setParent:self];

	// XXX: Do we need to recompute it?
	//[self recomputeAttributedState];
}

- (void)addChild:(ContextNode *)child
{
	[children_ addObject:child];
	[child setParent:self];
}

- (void)setParent:(ContextNode *)parent
{
	parent_ = parent;
}

#pragma mark -

- (void)recomputeAttributedName
{
	[NSException raise:@"Abstract Class Exception"
		    format:@"%@ didn't implement -%@!", [self class], _cmd];
}

- (void)recomputeAttributedState
{
	[NSException raise:@"Abstract Class Exception"
		    format:@"%@ didn't implement -%@!", [self class], _cmd];
}

@end
