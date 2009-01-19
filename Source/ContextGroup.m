//
//  ContextGroup.m
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import "Context.h"
#import "ContextGroup.h"


@interface ContextGroup (Private)

- (void)recomputeAttributedName;
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

	[cg setChildren:contexts];

	return cg;
}

- (id)initWithName:(NSString *)name
{
	if (!(self = [super init]))
		return nil;

	[self setName:name];
	selection_ = nil;

	return self;
}

#pragma mark Accessors

- (Context *)selection
{
	return selection_;
}

#pragma mark Setters

//- (void)setChildren:(NSArray *)children
//{
//	[children_ setArray:children];
//
//	// Check that the selection hasn't gone away.
//	// TODO: This doesn't work beyond immediate children changing.
//	if (selection_) {
//		if (![[self descendants] containsObject:selection_])
//			selection_ = nil;
//		[self recomputeAttributedState];
//	}
//}

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

- (void)recomputeAttributedName
{
	[self willChangeValueForKey:@"attributedName"];

	NSDictionary *attrs = [NSDictionary dictionaryWithObject:[NSFont boldSystemFontOfSize:
								  [NSFont systemFontSize]]
							  forKey:NSFontAttributeName];
	attributedName_ = [[NSAttributedString alloc] initWithString:[self name] attributes:attrs];

	[self didChangeValueForKey:@"attributedName"];
}

- (void)recomputeAttributedState
{
	[self willChangeValueForKey:@"attributedState"];

	[attributedState_ release];
	if (selection_) {
		NSFont *font = [NSFont systemFontOfSize:[NSFont smallSystemFontSize]];
		NSMutableParagraphStyle *para = [[[NSMutableParagraphStyle alloc] init] autorelease];
		[para setAlignment:NSRightTextAlignment];
		NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
				       font, NSFontAttributeName,
				       para, NSParagraphStyleAttributeName, nil];
		attributedState_ = [[NSAttributedString alloc] initWithString:[selection_ fullPath]
							     attributes:attrs];
	} else
		attributedState_ = nil;

	[self didChangeValueForKey:@"attributedState"];
}

@end
