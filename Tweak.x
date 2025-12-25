#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import "Tweak.h"

@interface TimeUtils : NSObject

@property NSDateFormatter *dateFormatter;
- (NSString *)getSecondTime;
- (instancetype)initWithDateFormatter:(NSDateFormatter *)formatter;

@end

NSDictionary *preferences;
TimeUtils *utilInstance;

static void updatePrefDict(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.whitetailani.serenatime.prefs.plist"];
	
	NSString *timeZoneID = preferences[@"timeZoneID"];
	if ([timeZoneID isEqualToString:@"America/Seattle"]) {
    	timeZoneID = @"America/Los_Angeles";
    }
	utilInstance.dateFormatter.timeZone = [[NSTimeZone alloc] initWithName:timeZoneID];
}

@implementation TimeUtils

- (instancetype)initWithDateFormatter:(NSDateFormatter *)formatter {
	self = [super init];
	self.dateFormatter = formatter;
	[self.dateFormatter setDateFormat:@"HH:mm"];
	
	NSString *timeZoneID = preferences[@"timeZoneID"];
	if ([timeZoneID isEqualToString:@"America/Seattle"]) {
    	timeZoneID = @"America/Los_Angeles";
    }
	self.dateFormatter.timeZone = [[NSTimeZone alloc] initWithName:timeZoneID];
	
	return self;
}

- (NSString *)getSecondTime {
    return [self.dateFormatter stringFromDate:[NSDate date]];;
}

@end

%group TwoTime
%hook _UIStatusBarStringView

- (void)setText:(NSString *)text {
    if (self.fontStyle == 1) {
        %orig([NSString stringWithFormat:@"%@ - %@", text, [utilInstance getSecondTime]]);
    } else {
        %orig(text);
    }
}

%end
%end

%ctor {
    preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.whitetailani.serenatime.prefs.plist"];
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, updatePrefDict, CFSTR("com.whitetailani.serenatime.prefs"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    
    utilInstance = [[TimeUtils alloc] initWithDateFormatter:[[NSDateFormatter alloc] init]];

    if ([preferences[@"enabled"] boolValue] == YES) {
        %init(TwoTime);
    }
}
