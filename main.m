//
//  main.m
//  TabAndSplitApp
//
//  Created by jey on 11/3/11.
//  Copyright 2011 CSS CORP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabAndSplitAppAppDelegate.h"

int main(int argc
         , char *argv[]) {
    @autoreleasepool {
//        int retVal = UIApplicationMain(argc, argv, nil, nil);    
//        return retVal;
        
        
      /*   NSManagedObjectContext *context = managedObjectContext();
        
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error while saving %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
            exit(1);
        }
        
        NSError* err = nil;
        NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"User" ofType:@"json"];
        NSArray* Banks = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                         options:kNilOptions
                                                           error:&err];
        NSLog(@"Imported Banks: %@", Banks);*/
        
        
        
        
         return UIApplicationMain(argc, argv, nil, NSStringFromClass([TabAndSplitAppAppDelegate class]));
    }
    
   // return 0;
}

/*
int main (int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog (@"Programming is fun!");
    }
    return 0;
}*/


