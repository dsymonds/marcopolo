//
//  SensorData.h
//  MarcoPolo
//
//  Created by David Symonds on 11/06/08.
//

#import <Cocoa/Cocoa.h>


@interface SensorData : NSObject {
	@private
	NSString *type_;
	id value_;
}

+ (id)sensorDataWithType:(NSString *)type value:(id)value;
- (id)initWithType:(NSString *)type value:(id)value;

- (NSString *)type;
- (id)value;

@end
