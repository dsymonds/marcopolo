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
	attrName_ = nil;
	attrState_ = nil;

	return self;
}

- (void)dealloc
{
	[name_ release];
	[contextTree_ release];
	[attrName_ release];
	[attrState_ release];
	[super dealloc];
}

#pragma mark Accessors

- (NSString *)name
{
	return name_;
}

- (NSAttributedString *)attributedName
{
	if (!attrName_) {
		NSDictionary *attrs = [NSDictionary dictionaryWithObject:[NSFont boldSystemFontOfSize:
									  [NSFont systemFontSize]]
								  forKey:NSFontAttributeName];
		attrName_ = [[NSAttributedString alloc] initWithString:name_ attributes:attrs];
	}

	return attrName_;
}

- (NSAttributedString *)attributedState
{
	if (!attrState_) {
		NSFont *font = [NSFont systemFontOfSize:[NSFont smallSystemFontSize]];
		NSDictionary *attrs = [NSDictionary dictionaryWithObject:font
								  forKey:NSFontAttributeName];
		NSString *s = selection_ ? [selection_ fullPath] : @"";
		attrState_ = [[NSAttributedString alloc] initWithString:s attributes:attrs];
	}

	return attrState_;
}

- (int)count
{
	return [contextTree_ count];
}

- (ContextTree *)contextTree
{
	return contextTree_;
}

- (Context *)selection
{
	return selection_;
}

#pragma mark -

- (void)setContextTree:(ContextTree *)contextTree
{
	[contextTree_ autorelease];
	contextTree_ = [contextTree retain];
}

- (void)setSelection:(Context *)context
{
	[attrState_ autorelease];
	attrState_ = nil;

	if (![contextTree_ containsContext:context]) {
		NSLog(@"-[%@ %@]: Asked to select a foreign context!", [self class], _cmd);
		selection_ = nil;
		return;
	}
	selection_ = context;
}

@end
