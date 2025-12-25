#import <Foundation/Foundation.h>
#import "STRootListController.h"
#import <spawn.h>

@implementation STRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)respring {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.whitetailani.serenatime.prefs"), NULL, NULL, YES);
	
    pid_t pid;
    const char *args[] = {"sh", "-c", "sbreload", NULL};
    posix_spawn(&pid, "/bin/sh", NULL, NULL, (char *const *)args, NULL);
}

- (UIImage *)loadImageForIdentifierName:(NSString *)identifier {
    NSString *bundlePath = [NSString stringWithFormat:@"/Library/PreferenceBundles/%@.bundle/%@", identifier, identifier];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:bundlePath];
    return image;
}

@end
