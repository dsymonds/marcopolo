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
	ContextGroup *cg = [ContextGroup contextGroupWithName:@"Location"];
	STAssertNotNil(cg, nil);
	STAssertEqualObjects([cg name], @"Location", nil);
	int count = [[cg children] count];
	STAssertEquals(count, 0, nil);

	cg = [ContextGroup contextGroupWithName:@"Location"
			       topLevelContexts:[NSArray array]];
	STAssertNotNil(cg, nil);
	STAssertEqualObjects([cg name], @"Location", nil);
	STAssertEquals(count, 0, nil);

	// via init and setters
	cg = [[[ContextGroup alloc] initWithName:@"Location"] autorelease];
	STAssertNotNil(cg, nil);
	STAssertEqualObjects([cg name], @"Location", nil);
	STAssertEquals(count, 0, nil);
}

// TODO: Much more testing is needed here!

@end
