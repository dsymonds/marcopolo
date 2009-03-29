//
//  SensorProtocolEndpoint.m
//  MarcoPolo
//
//  Created by David Symonds on 29/03/09.
//

#import "SensorProtocolEndpoint.h"


@interface SensorProtocolEndpoint (Private)

- (void)processLine:(NSString *)line;

@end

#pragma mark -

@implementation SensorProtocolEndpoint

- (id)init
{
	if (!(self = [super init]))
		return nil;

	closed_ = NO;
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

#pragma mark -

- (void)handleMoreData:(NSNotification *)notification
{
	NSFileHandle *fh = [notification object];
	NSData *data = [fh availableData];
	if ([data length] == 0) {
		closed_ = YES;
		return;
	}
	[queuedData_ appendData:data];

	// Process complete lines
	while ([queuedData_ length] > 0) {
		NSString *str = [[[NSString alloc] initWithData:queuedData_
						       encoding:NSUTF8StringEncoding] autorelease];
		if (!str)
			break;
		unsigned nlIndex = [str rangeOfString:@"\n"].location;
		if (nlIndex != NSNotFound) {
			NSString *line = [str substringToIndex:nlIndex];
			[self processLine:line];
			str = [str substringFromIndex:nlIndex + 1];
			[queuedData_ setData:[str dataUsingEncoding:NSUTF8StringEncoding]];
		}
	}

	[fh waitForDataInBackgroundAndNotify];
}

- (void)processLine:(NSString *)line
{
	[processor_ setArgument:&line atIndex:2];
	[processor_ invoke];
}

@end
