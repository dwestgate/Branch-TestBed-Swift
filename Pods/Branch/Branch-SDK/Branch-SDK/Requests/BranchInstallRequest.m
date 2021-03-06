//
//  BranchInstallRequest.m
//  Branch-TestBed
//
//  Created by Graham Mueller on 5/26/15.
//  Copyright (c) 2015 Branch Metrics. All rights reserved.
//

#import "BranchInstallRequest.h"
#import "BNCPreferenceHelper.h"
#import "BNCSystemObserver.h"
#import "BranchConstants.h"
#import "BNCStrongMatchHelper.h"

@implementation BranchInstallRequest

- (id)initWithCallback:(callbackWithStatus)callback {
    return [super initWithCallback:callback isInstall:YES];
}

- (void)makeRequest:(BNCServerInterface *)serverInterface key:(NSString *)key callback:(BNCServerCallback)callback {
    BNCPreferenceHelper *preferenceHelper = [BNCPreferenceHelper preferenceHelper];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
   
    [self safeSetValue:[BNCSystemObserver getBundleID] forKey:BRANCH_REQUEST_KEY_BUNDLE_ID onDict:params];
    [self safeSetValue:[BNCSystemObserver getTeamIdentifier] forKey:BRANCH_REQUEST_KEY_TEAM_ID onDict:params];
    [self safeSetValue:[BNCSystemObserver getAppVersion] forKey:BRANCH_REQUEST_KEY_APP_VERSION onDict:params];
    [self safeSetValue:[BNCSystemObserver getDefaultUriScheme] forKey:BRANCH_REQUEST_KEY_URI_SCHEME onDict:params];
    [self safeSetValue:[BNCSystemObserver getUpdateState] forKey:BRANCH_REQUEST_KEY_UPDATE onDict:params];
    [self safeSetValue:[NSNumber numberWithBool:preferenceHelper.checkedFacebookAppLinks] forKey:BRANCH_REQUEST_KEY_CHECKED_FACEBOOK_APPLINKS onDict:params];
    [self safeSetValue:preferenceHelper.linkClickIdentifier forKey:BRANCH_REQUEST_KEY_LINK_IDENTIFIER onDict:params];
    [self safeSetValue:preferenceHelper.spotlightIdentifier forKey:BRANCH_REQUEST_KEY_SPOTLIGHT_IDENTIFIER onDict:params];
    [self safeSetValue:preferenceHelper.universalLinkUrl forKey:BRANCH_REQUEST_KEY_UNIVERSAL_LINK_URL onDict:params];
    
    params[BRANCH_REQUEST_KEY_DEBUG] = @(preferenceHelper.isDebug);
    
    if ([[BNCStrongMatchHelper strongMatchHelper] shouldDelayInstallRequest]) {
        NSInteger delay = 750;
        if (preferenceHelper.installRequestDelay) {
            delay = preferenceHelper.installRequestDelay;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [serverInterface postRequest:params url:[preferenceHelper getAPIURL:BRANCH_REQUEST_ENDPOINT_INSTALL] key:key callback:callback];
        });
    }
    else {
        [serverInterface postRequest:params url:[preferenceHelper getAPIURL:BRANCH_REQUEST_ENDPOINT_INSTALL] key:key callback:callback];
    }
}

- (NSString *)getActionName {
    return @"install";
}

@end
