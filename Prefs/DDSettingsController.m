#import "DDSettingsController.h"

@implementation DDSettingsController
- (void) viewDidLoad {
	[super viewDidLoad];
}

- (void) layoutHeader {
	[super layoutHeader];
}

- (NSBundle *)resourceBundle {
	return [NSBundle bundleWithPath:@"/Library/PreferenceBundles/DodontSuggestPrefs.bundle"];
}

- (void) respring {
	// [[(Class)objc_getClass("FBSystemService") sharedInstance] exitAndRelaunch:true]; // doesn't work here but keeping bc it might be useful elsewhere
	setuid(0);
	setgid(0);
	pid_t pid;
	const char *args[] = {"sbreload", NULL, NULL, NULL};
	posix_spawn(&pid, "usr/bin/sbreload", NULL, NULL, (char *const *)args, NULL);
}
@end
