#import "DodontSuggest.h"

static void refreshPrefs() {
	CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)bundleIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	if (keyList) {
		settings = (NSMutableDictionary* )CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)bundleIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
		CFRelease(keyList);
	} else settings = nil;
	if (!settings) settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", bundleIdentifier]];
	
	enabled         = [([settings objectForKey:@"enabled"] ?: @(true)) boolValue];
	timeColour      = [([settings objectForKey:@"timeColour"] ?: @"#9cdfff") stringValue];
}
	
static void PreferencesChangedCallback(CFNotificationCenterRef center, void* observer, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
	refreshPrefs();
}

%hook DodoTimeDateContainerView
- (void) didMoveToWindow {
	%orig;
	if (!self.subviews) return; // basic safety check
	UIColor* labelColour = LCPParseColorString(timeColour, @"#9cdfff"); // get custom colour from preferences
	for (UILabel* timeLabel in self.subviews) {
		if ([timeLabel isKindOfClass:[UILabel class]]) timeLabel.textColor = labelColour; // colour each uilabel in the time view
	}
}
%end

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, (CFStringRef)[NSString stringWithFormat:@"%@.prefschanged", bundleIdentifier], NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	refreshPrefs();
	if (enabled) %init;
}