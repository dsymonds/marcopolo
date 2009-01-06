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

	STAssertTrue([tree containsContext:[contexts objectAtIndex:0]], nil);
	STAssertTrue([tree containsContext:[contexts objectAtIndex:1]], nil);
	STAssertFalse([tree containsContext:[Context contextWithName:@"Park"]], nil);
}

- (void)testComplexTree
{
	// Tree looks like:
	//  Work [w]
	//    Conference Room [wdc]
	//      Upstairs [wdcu]
	//    Desk [wd]
	//  Home [h]
	//    Couch [hc]
	//    Desk [hd]
	Context *w = [Context contextWithName:@"Work"];
	Context *wc = [Context contextWithName:@"Conference Room" parent:w];
	Context *wcu = [Context contextWithName:@"Upstairs" parent:wc];
	Context *wd = [Context contextWithName:@"Desk" parent:w];
	Context *h = [Context contextWithName:@"Home"];
	Context *hc = [Context contextWithName:@"Couch" parent:h];
	Context *hd = [Context contextWithName:@"Desk" parent:h];

	ContextTree *tree = [ContextTree contextTree];
	[tree addContextsFromArray:
	 [NSArray arrayWithObjects:w, wc, wcu, wd, h, hc, hd, nil]];

	STAssertEquals([tree count], 7, nil);
	int count = [[tree allContexts] count];
	STAssertEquals(count, 7, nil);
	count = [[tree topLevelContexts] count];
	STAssertEquals(count, 2, nil);

	STAssertTrue([tree containsContext:w], nil);
	STAssertTrue([tree containsContext:wc], nil);
	STAssertTrue([tree containsContext:wcu], nil);

	NSArray *kids = [tree childrenOfContext:w];
	count = [kids count];
	STAssertEquals(count, 2, nil);
	STAssertTrue([kids containsObject:wc], nil);
	STAssertTrue([kids containsObject:wd], nil);
}

@end
