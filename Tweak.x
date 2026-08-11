#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import "Tweak.h"

@interface TimeUtils : NSObject

@property NSDateFormatter *dateFormatter;
- (NSString *)getAnotherTime;
- (instancetype)initWithDateFormatter:(NSDateFormatter *)formatter prefVar:(NSString *)prefVar;

@end

NSDictionary *preferences;
TimeUtils *secondInstance;
TimeUtils *thirdInstance;

static void updatePrefDict(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.whitetailani.serenatime.prefs.plist"];
	
	NSString *timeZoneID = preferences[@"timeZoneID"];
	if ([timeZoneID isEqualToString:@"America/Seattle"]) {
    	timeZoneID = @"America/Los_Angeles";
    }
    
    NSString *thirdTimeZoneID = preferences[@"thirdTimeZoneID"];
	if ([thirdTimeZoneID isEqualToString:@"America/Seattle"]) {
    	thirdTimeZoneID = @"America/Los_Angeles";
    }
    
	secondInstance.dateFormatter.timeZone = [[NSTimeZone alloc] initWithName:timeZoneID];
	thirdInstance.dateFormatter.timeZone = [[NSTimeZone alloc] initWithName:thirdTimeZoneID];
}

@implementation TimeUtils

- (instancetype)initWithDateFormatter:(NSDateFormatter *)formatter prefVar:(NSString *)prefVar {
	self = [super init];
	self.dateFormatter = formatter;
	[self.dateFormatter setDateFormat:@"HH:mm"];
	
	NSString *timeZoneID = preferences[prefVar];
	if ([timeZoneID isEqualToString:@"America/Seattle"]) {
    	timeZoneID = @"America/Los_Angeles";
    }
	self.dateFormatter.timeZone = [[NSTimeZone alloc] initWithName:timeZoneID];
	
	return self;
}

- (NSString *)getAnotherTime {
    return [self.dateFormatter stringFromDate:[NSDate date]];
}

@end

%group TwoTime
%hook _UIStatusBarStringView

- (void)setText:(NSString *)text {
	NSString *timeText = [NSString stringWithFormat:@"%@ - %@", text, [secondInstance getAnotherTime]];
	if ([preferences[@"thirdEnabled"] boolValue] == YES) {
		timeText = [NSString stringWithFormat:@"%@ - %@", timeText, [thirdInstance getAnotherTime]];
	}
    if (self.fontStyle == 1) {
        %orig(timeText);
    } else {
        %orig(text);
    }
}

%end
%end

%ctor {
    preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.whitetailani.serenatime.prefs.plist"];
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, updatePrefDict, CFSTR("com.whitetailani.serenatime.prefs"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    
    secondInstance = [[TimeUtils alloc] initWithDateFormatter:[[NSDateFormatter alloc] init] prefVar:@"timeZoneID"];
    if ([preferences[@"thirdEnabled"] boolValue] == YES) {
    	thirdInstance = [[TimeUtils alloc] initWithDateFormatter:[[NSDateFormatter alloc] init] prefVar:@"thirdTimeZoneID"];
    }

    if ([preferences[@"enabled"] boolValue] == YES) {
        %init(TwoTime);
    }
}
