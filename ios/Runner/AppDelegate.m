#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <Flutter/Flutter.h>
#import "TtsPlugin.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    FlutterMethodChannel* ttsChannel = [FlutterMethodChannel
                                        methodChannelWithName:@"ptp.flutter.io/tts"
                                        binaryMessenger:controller];
    [ttsChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        TtsPlugin* instance = [TtsPlugin alloc];
        if ([@"speak" isEqualToString:call.method]) {
            [instance speak:call.arguments[@"text"]];
        } else if ([@"isLanguageAvailable" isEqualToString:call.method]) {
            BOOL isAvailable = [instance isLanguageAvailable:call.arguments[@"language"]];
            result(@(isAvailable));
        } else if ([@"setLanguage" isEqualToString:call.method]) {
            BOOL success = [instance setLanguage:call.arguments[@"language"]];
            result(@(success));
        } else if ([@"getAvailableLanguages" isEqualToString:call.method]) {
            result([instance getLanguages]);
        } else if ([@"stop" isEqualToString:call.method]) {
            [instance stop];
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];

  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
