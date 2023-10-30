//
//  main.m
//  hello-objc
//
//  Created by Anders Ackerman on 10/29/2023.
//

#import <Foundation/Foundation.h>
#import "./NSString_MD5.h"
#import <stdio.h>

int main(int argc, const char **argv) {
    
    @autoreleasepool {
        NSLog(@"hello world");
        int i = 0;
        for (;;) {
            NSString * mystr = @"iwrupvqb";

            NSString *newstr = [mystr stringByAppendingFormat:@"%d", i]; 

            // NSLog(@"newstr => %@", newstr);

            NSString * md5 = [newstr MD5String];
            // NSLog(@" str => %@", md5);

            int zeros = 0;
            for(int i = 0 ; i < 5; i++) {
                if ([md5 characterAtIndex:i] == '0') {
                    zeros++;
                    // NSLog(@"ZEROS %d",zeros);
                    if (zeros == 5) {
                        break;
                    }
                }
            }
            if (zeros == 5) {
                NSLog(@" str => %@ with => %@", md5, newstr);
                break;
            }
            i++;
        }
    }
    
    return 0;
}