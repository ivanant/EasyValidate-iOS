/*
 Copyright Ivan Lam
 
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

#import "EasyValidate.h"
#import <UIKit/UIKit.h>
#import "ElementValidationDelegate.h"

@implementation EasyValidate

/*
 Check one element and return result.
 withAlert: whether show alert.
 */
-(bool) checkOneElement:(id <ElementValidationDelegate>) element
              withAlert:(bool) withAlert
{
    bool result = [element validate];
    // If validate fail and need to show alert
    if (!result && withAlert) {
        UIAlertView *resultAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"INPUT_WARNING_TITLE", nil)
                                                              message:[element getErrorMessage]
                                                             delegate:nil
                                                    cancelButtonTitle:NSLocalizedString(@"ALERT_OK_BUTTON", nil)
                                                    otherButtonTitles:nil];
        [resultAlert show];
    }
    return result;
}

/*
 Check all elements without show alert.
 */
-(bool) checkAllElementWithoutAlert:(NSArray <ElementValidationDelegate>*) elements
{
    for (id <ElementValidationDelegate> nElement in elements) {
        bool nResult = [self checkOneElement:nElement withAlert:NO];
        // If nResult is false, return and without continue.
        if (!nResult) {
            return NO;
        }
    }
    return YES;
}

/*
 Check all elements and show alert.
 onlyShowFirstAlert: whether show all error messages.
 */
-(bool) checkAllElementWithAlert:(NSArray <ElementValidationDelegate>*) elements
              onlyShowFirstAlert:(bool) isFirst
{
    for (id <ElementValidationDelegate> nElement in elements) {
        bool nResult = [self checkOneElement:nElement withAlert:NO];
        // If nResult is false and isFirst is YES, show alert, return and without continue.
        if (!nResult && isFirst) {
            UIAlertView *resultAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"INPUT_WARNING_TITLE", nil)
                                                                  message:[nElement getErrorMessage]
                                                                 delegate:nil
                                                        cancelButtonTitle:NSLocalizedString(@"ALERT_OK_BUTTON", nil)
                                                        otherButtonTitles:nil];
            [resultAlert show];
            return NO;
        }
    }
    return YES;    
}

@end
