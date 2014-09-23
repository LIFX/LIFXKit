//
//  LFXTCPGatewayConnection.h
//  LIFX
//
//  Created by Nick Forge on 14/09/13.
//  Copyright (c) 2013 LIFX Labs. All rights reserved.
//

#import "LFXGatewayConnection.h"

extern NSString * const LFXTCPGatewayConnectionErrorDomain;

@interface LFXTCPGatewayConnection : LFXGatewayConnection

@property (nonatomic) BOOL useTLS;
@property (nonatomic) BOOL shouldSkipTLSVerification;
@property (nonatomic) BOOL shouldVerifyTLSHostname;
@property (nonatomic) SecCertificateRef trustedTLSRootCertificate;

@end
