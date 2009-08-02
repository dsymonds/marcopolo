//
//  LightSensor.m
//  MarcoPolo
//
//  Created by David Symonds on 17/06/08.
//

#import "LightSensor.h"


#define kLightUpdateInterval	((NSTimeInterval) 0.5)


@interface LightSensor (Private)

- (void)tick:(NSTimer *)timer;

@end

@implementation LightSensor

- (id)init
{
	if (!(self = [super init]))
		return nil;

	timer_ = nil;
	lock_ = [[NSLock alloc] init];
	value_ = -1;

	return self;
}

- (void)dealloc
{
	[lock_ release];
	[timer_ invalidate];
	[timer_ release];
	[super dealloc];
}

- (NSString *)name
{
	return @"Light";
}

- (BOOL)isMultiValued
{
	return NO;
}

- (void)start
{
	// Find the IO service
	kern_return_t kr;
	io_service_t serviceObject = IOServiceGetMatchingService(kIOMasterPortDefault,
								 IOServiceMatching("AppleLMUController"));
	if (serviceObject) {
		// Open the IO service
		kr = IOServiceOpen(serviceObject, mach_task_self(), 0, &ioPort_);
		IOObjectRelease(serviceObject);
	}
	if (!serviceObject || (kr != KERN_SUCCESS)) {
		[self willChangeValueForKey:@"running"];
		[self didChangeValueForKey:@"running"];
		return;
	}

	timer_ = [NSTimer scheduledTimerWithTimeInterval:kLightUpdateInterval
						  target:self
						selector:@selector(tick:)
						userInfo:nil
						 repeats:YES];
	[timer_ fire];
}

- (void)stop
{
	[timer_ invalidate];
	timer_ = nil;
}

- (BOOL)running
{
	return timer_ != nil;
}

- (NSObject *)value
{
	if (![self running])
		return nil;

	[lock_ lock];
	double v = value_;
	[lock_ unlock];

	return [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithDouble:v], @"data",
		[NSString stringWithFormat:@"%.0f%%", v * 100], @"description", nil];
}

- (void)tick:(NSTimer *)timer
{
	// Read from the sensor device - index 0, 0 inputs, 2 outputs
	int l, r;
	double v = 0;
	if (IOConnectMethodScalarIScalarO(ioPort_, 0, 0, 2, &l, &r) == KERN_SUCCESS) {
		// Average of left and right
		static const double kMaxCombinedLightValue = 4096.0;
		v = (l + r) / kMaxCombinedLightValue;
	}

	[self willChangeValueForKey:@"value"];
	[lock_ lock];
	value_ = v;
	[lock_ unlock];
	[self didChangeValueForKey:@"value"];
}

@end
