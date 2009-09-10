//
//  OS.m
//  MarcoPolo
//
//  Created by David Symonds on 2/08/09.
//

#import "OS.h"


int OSXVersion()
{
	long major, minor, bugfix;
	if (Gestalt(gestaltSystemVersionMajor, &major) ||
	    Gestalt(gestaltSystemVersionMinor, &minor) ||
	    Gestalt(gestaltSystemVersionBugFix, &bugfix))
		return 0;
	return ((major * 100) + minor) * 100 + bugfix;
}