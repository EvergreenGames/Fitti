//
//  ErrorMessageView.m
//  Fitti
//
//  Created by Ruben Green on 7/15/20.
//  Copyright © 2020 Ruben Green. All rights reserved.
//

#import "ErrorMessageView.h"

@implementation ErrorMessageView

+(void)errorMessageWithString:(NSString*)string{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:string preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
}

@end
