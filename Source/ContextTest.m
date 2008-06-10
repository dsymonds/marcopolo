//
//  ContextTest.m
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import "Context.h"
#import "ContextTest.h"


@implementation ContextTest

- (void)testCreation
{
	// via class methods
	Context *c1 = [Context context];
	STAssertNotNil(c1, nil);
	STAssertEqualObjects([c1 name], @"", nil);
	STAssertNil([c1 parent], nil);

	Context *c2 = [Context contextWithName:@"foo" parent:c1];
	STAssertNotNil(c2, nil);
	STAssertEqualObjects([c2 name], @"foo", nil);
	STAssertEquals([c2 parent], c1, nil);

	// via init and setters
	Context *c3 = [[[Context alloc] init] autorelease];
	[c3 setName:@"bar"];
	[c3 setParent:c1];
	STAssertNotNil(c3, nil);
	STAssertEqualObjects([c3 name], @"bar", nil);
	STAssertEquals([c3 parent], c1, nil);
}

@end
