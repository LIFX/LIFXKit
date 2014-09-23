//
//  LFXClientDevice.m
//  LIFXKit
//
//  Created by Chris Miles on 22/04/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "LFXClientDevice.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation LFXClientDevice

+ (NSString *)bestIPAddress
{
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;

    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces))
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6)
            {
                NSString *name = @(temp_addr->ifa_name);
                NSString *addr = @(inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)); // pdp_ip0

                if([name isEqualToString:@"en0"])
                {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                }
                else if([name isEqualToString:@"pdp_ip0"])
                {
                    // Interface is the cell connection on the iPhone
                    cellAddress = addr;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : @"0.0.0.0";
}

@end
