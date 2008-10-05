//
//  ContextGroupTest.m
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import "Context.h"
#import "ContextGroup.h"
#import "ContextGroupTest.h"
#import "ContextTree.h"


@implementation ContextGroupTest

- (void)testCreation
{
	// via class methods
	ContextGroup *cg = [ContextGroup contextGroupWithName:@"Location"];
	STAssertNotNil(cg, nil);
	STAssertEqualObjects([cg name], @"Location", nil);
	STAssertEquals([cg count], 0, nil);

	cg = [ContextGroup contextGroupWithName:@"Location"
				    contextTree:[ContextTree contextTree]];
	STAssertNotNil(cg, nil);
	STAssertEqualObjects([cg name], @"Location", nil);
	STAssertEquals([cg count], 0, nil);

	// via init and setters
	cg = [[[ContextGroup alloc] initWithName:@"Location"] autorelease];
	STAssertNotNil(cg, nil);
	STAssertEqualObjects([cg name], @"Location", nil);
	STAssertEquals([cg count], 0, nil);
}

@end
