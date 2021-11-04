#import "DodontSuggest.h"

static void refreshPrefs() {
	CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)bundleIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	if (keyList) {
		settings = (NSMutableDictionary* )CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)bundleIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
		CFRelease(keyList);
	} else settings = nil;
	if (!settings) settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", bundleIdentifier]];
	
	enabled         = [([settings objectForKey:@"enabled"] ?: @(true)) boolValue];
	hideSuggestions = [([settings objectForKey:@"hideSuggestions"] ?: @(true)) boolValue];
	hideMusicPlayer = [([settings objectForKey:@"hideMusicPlayer"] ?: @(false)) boolValue];
	colourTime      = [([settings objectForKey:@"colourTime"] ?: @(true)) boolValue];
	timeColour      = [([settings objectForKey:@"timeColour"] ?: @"#9cdfff") stringValue];
}
	
static void PreferencesChangedCallback(CFNotificationCenterRef center, void* observer, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
	refreshPrefs();
}

%hook DodoBottomView
- (void) layoutSubviews {
	%orig;
	if (!hideSuggestions && !hideMusicPlayer) return;
	self.subviews[1].subviews[0].hidden = true;
	if (hideMusicPlayer) self.subviews[1].hidden = true;
	else if (hideSuggestions && ![self.subviews[1].subviews[1].subviews[0] isKindOfClass:[UIImageView class]]) self.subviews[1].subviews[1].subviews[0].hidden = true;
	if (!colourTime) return;
	UIColor* labelColour = LCPParseColorString(timeColour, @"#9cdfff");
	for (UILabel* timeLabel in self.subviews[2].subviews) {
		if ([timeLabel isKindOfClass:[UILabel class]]) timeLabel.textColor = labelColour;
	}
}
%end

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, (CFStringRef)[NSString stringWithFormat:@"%@.prefschanged", bundleIdentifier], NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	refreshPrefs();
	if (enabled) %init;
}