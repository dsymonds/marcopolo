//
//  ContextCollection.m
//  MarcoPolo
//
//  Created by David Symonds on 9/01/09.
//

#import "Context.h"
#import "ContextCollection.h"
#import "ContextGroup.h"


#pragma mark -

@implementation ContextCollection

- (id)init
{
	if (!(self = [super init]))
		return nil;

	contextGroups_ = [[NSMutableArray alloc] init];

	{
		// XXX: DUMMY CONTEXTS
		Context *home = [Context contextWithName:@"Home"];
		Context *work = [Context contextWithName:@"Work"];
		Context *work_desk = [Context contextWithName:@"Desk" parent:work];
		Context *work_conf = [Context contextWithName:@"Conference Room" parent:work];
		Context *net_auto = [Context contextWithName:@"Automatic"];
		Context *net_work = [Context contextWithName:@"Work"];

		[work setConfidence:[NSNumber numberWithFloat:0.8]];
		[work_desk setConfidence:[NSNumber numberWithFloat:0.85]];
		[work_conf setConfidence:[NSNumber numberWithFloat:0.6]];
		[net_work setConfidence:[NSNumber numberWithFloat:0.9]];

		ContextGroup *cg = [ContextGroup contextGroupWithName:@"Location"
						     topLevelContexts:[NSArray arrayWithObjects:
								       home, work, nil]];
		[cg setSelection:work_desk];
		[self addContextGroup:cg];

		cg = [ContextGroup contextGroupWithName:@"Network"
				       topLevelContexts:[NSArray arrayWithObjects:
							 net_auto, net_work, nil]];
		[cg setSelection:net_work];
		[self addContextGroup:cg];
	}

	return self;
}

- (void)dealloc
{
	[contextGroups_ release];
	[super dealloc];
}

#pragma mark -

- (NSArray *)children
{
	return contextGroups_;
}

#pragma mark -

- (void)addContextGroup:(ContextGroup *)contextGroup
{
	[contextGroups_ addObject:contextGroup];
}

- (void)setChildren:(NSArray *)children
{
	[contextGroups_ setArray:children];
}

@end
