/*
 Copyright 2010 Microsoft Corp
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "UIApplication+WANetworkActivity.h"

static NSInteger wa_networkActivityCount = 0;

@implementation UIApplication (WANetworkActivity)

- (void)wa_refreshNetworkActivityIndicator 
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(wa_refreshNetworkActivityIndicator)
                               withObject:nil 
                            waitUntilDone:NO];
        return;
    }
    
    BOOL active = (self.wa_networkActivityCount > 0);
    self.networkActivityIndicatorVisible = active;
}

- (NSInteger)wa_networkActivityCount 
{
    @synchronized(self) {
        return wa_networkActivityCount;        
    }
}

- (void)wa_pushNetworkActivity 
{
    @synchronized(self) {
        wa_networkActivityCount++;
    }
    [self wa_refreshNetworkActivityIndicator];
}

- (void)wa_popNetworkActivity 
{
    @synchronized(self) {
        if (wa_networkActivityCount > 0) {
            wa_networkActivityCount--;
        } else {
            wa_networkActivityCount = 0;
        }        
    }
    [self wa_refreshNetworkActivityIndicator];
}

- (void)wa_resetNetworkActivity 
{
    @synchronized(self) {
        wa_networkActivityCount = 0;
    }
    [self wa_refreshNetworkActivityIndicator];        
}

@end
