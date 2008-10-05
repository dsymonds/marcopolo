//
//  ContextTreeTest.m
//  MarcoPolo
//
//  Created by David Symonds on 5/10/08.
//

#import "Context.h"
#import "ContextTree.h"
#import "ContextTreeTest.h"


@implementation ContextTreeTest

- (void)testEmptyTree
{
	ContextTree *tree = [ContextTree contextTree];

	STAssertEquals([tree count], 0, nil);
	STAssertEqualObjects([tree allContexts], [NSArray array], nil);
	STAssertEqualObjects([tree topLevelContexts], [NSArray array], nil);
}

- (void)testFlatTree
{
	ContextTree *tree = [ContextTree contextTree];

	NSArray *contexts = [NSArray arrayWithObjects:
			     [Context contextWithName:@"Home"],
			     [Context contextWithName:@"Work"], nil];

	[tree addContextsFromArray:contexts];

	STAssertEquals([tree count], 2, nil);
	int count = [[tree allContexts] count];
	STAssertEquals(count, 2, nil);
	count = [[tree topLevelContexts] count];
	STAssertEquals(count, 2, nil);
}

@end
