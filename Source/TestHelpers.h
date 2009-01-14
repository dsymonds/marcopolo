//
//  TestHelpers.h
//  MarcoPolo
//
//  Created by David Symonds on 14/01/09.
//

#import <SenTestingKit/SenTestingKit.h>

// Some ST macros that don't suck.

#define STAssertEqualIntegers(a1, a2) \
	STAssertEquals((int) (a1), (int) (a2), nil)

#define STAssertCount(array, cnt) \
	STAssertEqualIntegers([(array) count], (cnt))

#define STAssertArrayOf1(array, obj1) \
	STAssertCount((array), 1); \
	STAssertEqualObjects([(array) objectAtIndex:0], (obj1), nil)
#define STAssertArrayOf2(array, obj1, obj2) \
	STAssertCount((array), 2); \
	STAssertEqualObjects([(array) objectAtIndex:0], (obj1), nil); \
	STAssertEqualObjects([(array) objectAtIndex:1], (obj2), nil)

