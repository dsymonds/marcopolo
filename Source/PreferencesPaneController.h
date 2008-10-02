//
//  PreferencesPaneController.h
//  MarcoPolo
//
//  Created by David Symonds on 3/10/08.
//

#import <Cocoa/Cocoa.h>


@class ApplicationController;


@interface PreferencesPaneController : NSObject {
	@private
	ApplicationController *applicationController_;
}

- (id)initWithApplicationController:(ApplicationController *)applicationController;

- (ApplicationController *)applicationController;

@end
