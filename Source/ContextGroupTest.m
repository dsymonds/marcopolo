//
//  ContextGroupTest.m
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import "Context.h"
#import "ContextGroup.h"
#import "ContextGroupTest.h"


@implementation ContextGroupTest

- (void)testCreation
{
	// via class methods
	ContextGroup *cg = [ContextGroup contextGroup];
	STAssertNotNil(cg, nil);
	STAssertEquals([cg count], 0, nil);

	cg = [ContextGroup contextGroupWithContexts:[NSArray array]];
	STAssertNotNil(cg, nil);
	STAssertEquals([cg count], 0, nil);

	// via init and setters
	cg = [[[ContextGroup alloc] init] autorelease];
	[cg addContextsFromArray:[NSArray array]];
	STAssertNotNil(cg, nil);
	STAssertEquals([cg count], 0, nil);
}

- (void)testContextAccessors
{
	Context *home = [Context contextWithName:@"Home" parent:nil];
	Context *work = [Context contextWithName:@"Work" parent:nil];
	Context *workDesk = [Context contextWithName:@"Desk" parent:work];
	NSArray *contexts = [NSArray arrayWithObjects:
			     home, work, workDesk, nil];
	ContextGroup *cg = [ContextGroup contextGroupWithContexts:contexts];
	STAssertNotNil(cg, nil);
	STAssertEquals([cg count], 3, nil);
	STAssertEqualObjects([cg contexts], contexts, nil);

	NSSet *tlc = [NSSet setWithArray:[cg topLevelContexts]];
	STAssertTrue([tlc count] == 2, nil);
	NSSet *expected = [NSSet setWithObjects:home, work, nil];
	STAssertEqualObjects(tlc, expected, nil);
}

@end
