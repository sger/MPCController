//
//  MPCController.h
//  MultipeerChat
//
//  Created by Spiros Gerokostas on 3/28/14.
//  Copyright (c) 2014 Spiros Gerokostas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

extern NSString *const kMPCControllerDidChangeStateNotification;
extern NSString *const kMPCControllerDidReceiveDataNotification;
extern NSString *const kMPCControllerDidStartReceivingResourceNotification;
extern NSString *const kMPCControllerDidFinishReceivingResourceNotification;
extern NSString *const kMPCControllerDidReceiveStreamNotification;

@interface MPCController : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCAdvertiserAssistant *advertiserAssistant;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCPeerID *peerID;

+ (MPCController *)sharedController;

- (void)setupMCPeerIDWithDisplayName:(NSString *)displayName;
- (void)setupMCBrowser;
- (void)startAdvertiserAssistant;
- (void)stopAdvertiserAssistant;

@end
