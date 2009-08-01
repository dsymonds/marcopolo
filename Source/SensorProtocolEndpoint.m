//
//  SensorProtocolEndpoint.m
//  MarcoPolo
//
//  Created by David Symonds on 29/03/09.
//

#import "SensorProtocolEndpoint.h"


@interface SensorProtocolEndpoint (Private)

- (void)processInput:(NSObject *)object meta:(BOOL)meta;

@end

#pragma mark -

@implementation SensorProtocolEndpoint

- (id)init
{
	if (!(self = [super init]))
		return nil;

	closed_ = NO;
	valueLength_ = 0;
	output_ = nil;
	queuedData_ = [[NSMutableData alloc] init];
	processor_ = nil;

	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[output_ release];
	[queuedData_ release];
	[processor_ release];
	[super dealloc];
}

- (void)setInput:(NSFileHandle *)fileHandle
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[[NSNotificationCenter defaultCenter] addObserver:self
						 selector:@selector(handleMoreData:)
						     name:NSFileHandleDataAvailableNotification
						   object:fileHandle];
	[fileHandle waitForDataInBackgroundAndNotify];
}

- (void)setOutput:(NSFileHandle *)fileHandle
{
	[output_ autorelease];
	output_ = [fileHandle retain];
}

- (void)setInputProcessor:(id)object selector:(SEL)selector
{
	NSMethodSignature *sig = [object methodSignatureForSelector:selector];
	NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
	[inv setTarget:object];
	[inv setSelector:selector];

	processor_ = [inv retain];
}

- (BOOL)closed
{
	return closed_;
}

- (void)writeLine:(NSString *)line
{
	NSData *data = [[line stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
	[output_ writeData:data];
}

- (void)writeValue:(NSObject *)value
{
	NSData *objData = [NSKeyedArchiver archivedDataWithRootObject:value];
	if (!objData) {
		NSLog(@"%@: Sensor value could not be archived!", [self class]);
	}
	NSMutableData *data = [NSMutableData dataWithData:
			       [[NSString stringWithFormat:@"VALUE %d\n", [objData length]]
				dataUsingEncoding:NSUTF8StringEncoding]];
	[data appendData:objData];
	[output_ writeData:data];
}

#pragma mark -

- (BOOL)handleSensorValue
{
	if ([queuedData_ length] < valueLength_)
		return NO;

	NSRange range = NSMakeRange(0, valueLength_);
	NSData *objData = [queuedData_ subdataWithRange:range];
	[queuedData_ replaceBytesInRange:range withBytes:NULL length:0];
	valueLength_ = 0;

	NSObject *obj = [NSKeyedUnarchiver unarchiveObjectWithData:objData];
	if (obj) {
		[self processInput:obj meta:NO];
	} else {
		NSLog(@"Invalid sensor value received!");
	}
	return YES;
}

- (BOOL)handleMetaLine
{
	if ([queuedData_ length] == 0)
		return NO;

	// Look for first '\n' character. We can't convert the whole lot into an NSString
	// because queuedData_ could be holding sensor values.
	const unsigned char *p = [queuedData_ bytes];
	int nl;
	for (nl = 0; nl < [queuedData_ length]; ++nl) {
		if (*p++ == '\n')
			break;
	}
	if (nl >= [queuedData_ length])
		return NO;  // no '\n' found.

	NSData *lineData = [queuedData_ subdataWithRange:NSMakeRange(0, nl)];
	[queuedData_ replaceBytesInRange:NSMakeRange(0, nl + 1) withBytes:NULL length:0];

	NSString *line = [[[NSString alloc] initWithData:lineData
						encoding:NSUTF8StringEncoding] autorelease];
	if (!line) {
		NSLog(@"Decoding failed? [%@]", lineData);
		return YES;
	}
	if ([line hasPrefix:@"VALUE "]) {
		valueLength_ = [[line substringFromIndex:6] intValue];
	} else {
		[self processInput:line meta:YES];
	}
	return YES;
}

- (void)handleMoreData:(NSNotification *)notification
{
	NSFileHandle *fh = [notification object];
	NSData *data = [fh availableData];
	if ([data length] == 0) {
		closed_ = YES;
		return;
	}
	[queuedData_ appendData:data];

	BOOL more = YES;
	while (more) {
		more = (valueLength_ > 0) ? [self handleSensorValue] : [self handleMetaLine];
	}

	[fh waitForDataInBackgroundAndNotify];
}

- (void)processInput:(NSObject *)object meta:(BOOL)meta
{
	[processor_ setArgument:&object atIndex:2];
	[processor_ setArgument:&meta atIndex:3];
	[processor_ invoke];
}

@end
