//
//  ContextGroup.m
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import "Context.h"
#import "ContextGroup.h"


@interface ContextGroup (Private)

- (void)recomputeAttributedState;

@end

#pragma mark -

@implementation ContextGroup

+ (id)contextGroupWithName:(NSString *)name
{
	return [[[self alloc] initWithName:name] autorelease];
}

+ (id)contextGroupWithName:(NSString *)name topLevelContexts:(NSArray *)contexts
{
	ContextGroup *cg = [self contextGroupWithName:name];

	[cg addTopLevelContextsFromArray:contexts];

	return cg;
}

- (id)initWithName:(NSString *)name
{
	if (!(self = [super init]))
		return nil;

	name_ = [name retain];
	children_ = [[NSMutableArray alloc] init];
	selection_ = nil;

	attrName_ = nil;
	attrState_ = nil;

	return self;
}

- (void)dealloc
{
	[name_ release];
	[children_ release];
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
	return attrState_;
}

- (NSMutableArray *)children
{
	return children_;
}

- (Context *)selection
{
	return selection_;
}

#pragma mark -

- (void)addTopLevelContext:(Context *)context
{
	[children_ addObject:context];
}

- (void)addTopLevelContextsFromArray:(NSArray *)contexts
{
	NSEnumerator *en = [contexts objectEnumerator];
	Context *c;
	while ((c = [en nextObject]))
		[self addTopLevelContext:c];
}

- (void)setChildren:(NSArray *)children
{
	// TODO: deal with selection_

	[children_ setArray:children];
}

- (void)setSelection:(Context *)context
{
	// TODO: Verify this context is actually in this context group!
//	if (![contextTree_ containsContext:context]) {
//		NSLog(@"-[%@ %@]: Asked to select a foreign context!", [self class], _cmd);
//		selection_ = nil;
//		return;
//	}
	selection_ = context;
	[self recomputeAttributedState];
}

- (void)recomputeAttributedState
{
	[self willChangeValueForKey:@"attributedState"];

	[attrState_ release];
	if (selection_) {
		NSFont *font = [NSFont systemFontOfSize:[NSFont smallSystemFontSize]];
		NSMutableParagraphStyle *para = [[[NSMutableParagraphStyle alloc] init] autorelease];
		[para setAlignment:NSRightTextAlignment];
		NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
				       font, NSFontAttributeName,
				       para, NSParagraphStyleAttributeName, nil];
		attrState_ = [[NSAttributedString alloc] initWithString:[selection_ fullPath]
							     attributes:attrs];
	} else
		attrState_ = nil;

	[self didChangeValueForKey:@"attributedState"];
}

@end
