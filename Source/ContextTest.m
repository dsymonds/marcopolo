//
//  ContextTest.m
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import "Context.h"
#import "ContextTest.h"
#import "TestHelpers.h"


@implementation ContextTest

- (void)testCreation
{
	// via class methods
	Context *c1 = [Context context];
	STAssertNotNil(c1, nil);
	STAssertEqualObjects([c1 name], @"", nil);
	STAssertNil([c1 parent], nil);

	Context *c2 = [Context contextWithName:@"foo"];
	STAssertNotNil(c2, nil);
	STAssertEqualObjects([c2 name], @"foo", nil);
	STAssertNil([c2 parent], nil);

	Context *c3 = [Context contextWithName:@"foo" parent:c1];
	STAssertNotNil(c3, nil);
	STAssertEqualObjects([c3 name], @"foo", nil);
	STAssertEquals([c3 parent], c1, nil);

	// via init and setters
	Context *c4 = [[[Context alloc] init] autorelease];
	[c4 setName:@"bar"];
	[c1 addChild:c4];
	STAssertNotNil(c4, nil);
	STAssertEqualObjects([c4 name], @"bar", nil);
	STAssertEquals([c4 parent], c1, nil);
}

- (void)testHierarchy
{
	// Build a hierarchy looking like this:
	// A
	//  B
	//   C
	//  D
	//   E
	//   F
	Context *a = [Context contextWithName:@"A"];
	Context *b = [Context contextWithName:@"B" parent:a];
	Context *c = [Context contextWithName:@"C" parent:b];
	Context *d = [Context contextWithName:@"D" parent:a];
	Context *e = [Context contextWithName:@"E" parent:d];
	Context *f = [Context contextWithName:@"F" parent:d];

	STAssertArrayOf2([a children], b, d);
	STAssertCount([a children], 2);
	STAssertArrayOf1([b children], c);
	STAssertCount([c children], 0);
	STAssertArrayOf2([d children], e, f);
	STAssertCount([e children], 0);
	STAssertCount([f children], 0);

	NSArray *expected = [NSArray arrayWithObjects:b, c, d, e, f, nil];
	STAssertEqualObjects([a descendants], expected, nil);

}

@end
