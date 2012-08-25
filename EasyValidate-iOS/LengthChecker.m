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

#import "LengthChecker.h"
@implementation LengthChecker
@synthesize max = _max;
@synthesize min = _min;


-(id) init
{
    self = [super init];
    // Init value
    if(self)
    {
        self.max = -1;
        self.min = -1;
    }
    return self;
}

-(bool) validate:(NSString*) value
{
    // Get the real length
    int length = 0;
    if( nil != value)
    {
        length  = [value length];
    }

    if(self.min >=0 && length < self.min)
    {
        return NO;
    }
    if (self.max >=0 && length > self.max)
    {
        return NO;
    }
    return YES;
}

-(NSString *) getErrorMessage
{
    NSString *result = nil;
    if(self.min != -1 && self.max != -1){
        result = [NSString stringWithFormat:@"%@ %d~%d", NSLocalizedString(@"LENGTH_RANGE_ERROR_MESSAGE", nil), self.min, self.max];
    }else if(self.min != -1 && self.max == -1){
        result = [NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"LENGTH_MIN_ERROR_MESSAGE", nil), self.min];
    }else if(self.min == -1 && self.max != -1){
        result = [NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"LENGTH_MAX_ERROR_MESSAGE", nil), self.max];
    }
    
    return result;
}
@end
