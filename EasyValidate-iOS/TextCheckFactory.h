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

#import <Foundation/Foundation.h>
#define AND @"&"
#define OR @"|"
#define PARAM_START @"["
#define PARAM_END @"]"
#define PARAM_KEY_VALUE_SEPARATOR @":"
#define PARAM_SEPARATOR @","
#define CHECKER_SUFFIX @"Checker"

@interface TextCheckFactory : NSObject
{
    
@protected
    // save error message
    NSMutableString* errorMsg;
}
-(bool)validateValue:(NSString*) value withRule:(NSString*) rule;
-(NSString *) getErrorMessage;
@end
