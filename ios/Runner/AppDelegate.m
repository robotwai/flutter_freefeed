#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                            methodChannelWithName:@"com.shanbay.shared.data/method"
                                            binaryMessenger:controller];
    
    [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        
        if ([@"getProfileJson" isEqualToString:call.method]) {
            //            int batteryLevel = [self getBatteryLevel];
            //
            //            if (batteryLevel == -1) {
            //                result([FlutterError errorWithCode:@"UNAVAILABLE"
            //                                           message:@"Battery info unavailable"
            //                                           details:nil]);
            //            } else {
            //                result(@(batteryLevel));
            //            }
            result(@("123"));
        } else {
            result(FlutterMethodNotImplemented);
        }
        // TODO
    }];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (int)getBatteryLevel {
    UIDevice* device = UIDevice.currentDevice;
    device.batteryMonitoringEnabled = YES;
    if (device.batteryState == UIDeviceBatteryStateUnknown) {
        return -1;
    } else {
        return (int)(device.batteryLevel * 100);
    }
}

@end
