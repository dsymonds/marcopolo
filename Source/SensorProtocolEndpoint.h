//
//  SensorProtocolEndpoint.h
//  MarcoPolo
//
//  Created by David Symonds on 29/03/09.
//

#import <Cocoa/Cocoa.h>


// This class controls one side of the sensor protocol.
@interface SensorProtocolEndpoint : NSObject {
	@private
	BOOL closed_;
	int valueLength_;  // total length of encoded value if non-zero.
	NSFileHandle *output_;
	NSMutableData *queuedData_;
	NSInvocation *processor_;
}

- (id)init;

- (void)setInput:(NSFileHandle *)fileHandle;
- (void)setOutput:(NSFileHandle *)fileHandle;

// Set the callback for when new data arrives.
// The callback will receive two arguments:
// - an NSObject, and
// - a BOOL, indicating whether it is a meta value (YES) or a sensor value (NO).
- (void)setInputProcessor:(id)object selector:(SEL)selector;

- (void)writeLine:(NSString *)line;
- (void)writeValue:(NSObject *)value;

// Returns whether the input is closed (i.e. EOF is reached).
- (BOOL)closed;

@end
