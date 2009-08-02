//
//  IPSensor.m
//  MarcoPolo
//
//  Created by David Symonds on 4/07/08.
//

#import "IPSensor.h"


#pragma mark C callbacks

static void ipChange(SCDynamicStoreRef store, CFArrayRef changedKeys, void *info)
{
	IPSensor *s = (IPSensor *) info;

	// This is spun off into a separate thread because DNS delays, etc., would
	// hold up the main thread, causing UI hanging.
	[NSThread detachNewThreadSelector:@selector(updateInThread:)
				 toTarget:s
			       withObject:nil];
}

#pragma mark -

@interface IPSensor (Private)

- (NSArray *)allAddresses;
- (void)updateInThread:(id)arg;

@end

#pragma mark -

@implementation IPSensor

- (id)init
{
	if (!(self = [super init]))
		return nil;

	lock_ = [[NSLock alloc] init];
	addresses_ = [[NSMutableArray alloc] init];
	store_ = nil;
	runLoop_ = nil;

	return self;
}

- (void)dealloc
{
	[lock_ release];
	[addresses_ release];
	[super dealloc];
}

- (NSString *)name
{
	return @"IP";
}

- (BOOL)isMultiValued
{
	return YES;
}

- (void)start
{
	// Register for asynchronous notifications
	SCDynamicStoreContext ctxt;
	ctxt.version = 0;
	ctxt.info = self;
	ctxt.retain = NULL;
	ctxt.release = NULL;
	ctxt.copyDescription = NULL;

	store_ = SCDynamicStoreCreate(NULL, CFSTR("MarcoPolo"), ipChange, &ctxt);
	runLoop_ = SCDynamicStoreCreateRunLoopSource(NULL, store_, 0);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoop_, kCFRunLoopCommonModes);
	NSArray *keys = [NSArray arrayWithObject:@"State:/Network/Global/IPv4"];
	SCDynamicStoreSetNotificationKeys(store_, (CFArrayRef) keys, NULL);
	// TODO: catch errors

	// (see comment in ipChange function to see why we don't call it directly)
	[NSThread detachNewThreadSelector:@selector(updateInThread:)
				 toTarget:self
			       withObject:nil];
}

- (void)stop
{
	CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoop_, kCFRunLoopCommonModes);
	CFRelease(runLoop_);
	CFRelease(store_);
	runLoop_ = nil;
	store_ = nil;

	[self willChangeValueForKey:@"value"];
	[lock_ lock];
	[addresses_ removeAllObjects];
	[lock_ unlock];
	[self didChangeValueForKey:@"value"];
}

- (BOOL)running
{
	return runLoop_ != nil;
}

- (NSObject *)value
{
	[lock_ lock];

	NSMutableArray *array = [NSMutableArray arrayWithCapacity:[addresses_ count]];
	NSEnumerator *en = [addresses_ objectEnumerator];
	NSString *ip;
	while ((ip = [en nextObject])) {
		[array addObject:[NSDictionary dictionaryWithObjectsAndKeys:
				  ip, @"data",
				  ip, @"description", nil]];
	}

	[lock_ unlock];

	return array;
}

#pragma mark -

- (NSArray *)allAddresses
{
	NSArray *all = [[NSHost currentHost] addresses];
	NSMutableArray *subset = [NSMutableArray array];
	NSEnumerator *e = [all objectEnumerator];
	NSString *ip;

	while ((ip = [[e nextObject] lowercaseString])) {
		// Localhost IPs (IPv4/IPv6)
		if ([ip hasPrefix:@"127.0.0."])		// RFC 3330
			continue;
		if ([ip isEqualToString:@"::1"])
			continue;

		// IPv6 multicast (RFC 4291, section 2.7)
		if ([ip hasPrefix:@"ff"])
			continue;

		// IPv4 Link-local address (RFC 3927)
		if ([ip hasPrefix:@"169.254."])
			continue;

		// IPv6 link-local unicast (RFC 4291, section 2.4)
		if ([ip hasPrefix:@"fe80:"])
			continue;

		[subset addObject:ip];
	}

	return subset;
}

- (void)updateInThread:(id)arg
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSArray *addrs = [self allAddresses];

	[self willChangeValueForKey:@"value"];
	[lock_ lock];
	[addresses_ setArray:addrs];
	[lock_ unlock];
	[self didChangeValueForKey:@"value"];

	[pool release];
}

@end
