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
	NSFileHandle* output_;
	NSMutableData *queuedData_;
	NSInvocation *processor_;
}

- (id)init;

- (void)setInput:(NSFileHandle *)fileHandle;
- (void)setOutput:(NSFileHandle *)fileHandle;

// Set the callback for when new lines arrive.
// The callback will receive a single NSString argument.
- (void)setInputProcessor:(id)object selector:(SEL)selector;

- (void)writeLine:(NSString *)line;

// Returns whether the input is closed (i.e. EOF is reached).
- (BOOL)closed;

@end
