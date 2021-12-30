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
	colourTime      = [([settings objectForKey:@"colourTime"] ?: @(true)) boolValue];
	timeColour      = [([settings objectForKey:@"timeColour"] ?: @"#9cdfff") stringValue];
}
	
static void PreferencesChangedCallback(CFNotificationCenterRef center, void* observer, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
	refreshPrefs();
}

%hook DodoBottomView
- (void) layoutSubviews {
	%orig;
	if (hideSuggestions) {
		if (self.subviews.count >= 2 && self.subviews[1].subviews.count >= 1 && self.subviews[1].subviews[1].subviews.count >= 1 && ![self.subviews[1].subviews[1].subviews[0] isKindOfClass:[UIImageView class]]) self.subviews[1].hidden = true;
	}
	
	if (!colourTime || (self.subviews.count < 3 || self.subviews[2].subviews.count == 0)) return;
	
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