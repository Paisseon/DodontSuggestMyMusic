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
	NSTask* task = [[NSTask alloc] init];
	[task setLaunchPath:@"/usr/bin/sreboot"]; // use bash
	[task setArguments:[NSArray arrayWithObjects:@"ldrestart", nil]]; // and use the CyPwn script (thanks Sudo!)
	[task launch]; // run the script
}
@end
