//
//  OS.m
//  MarcoPolo
//
//  Created by David Symonds on 2/08/09.
//

#import "OS.h"


int OSXMinorVersion()
{
	long major, minor;
	if (Gestalt(gestaltSystemVersionMajor, &major) || Gestalt(gestaltSystemVersionMinor, &minor))
		return 0;
	if (major != 10)
		return 0;
	return minor;
}