//
//  MPCController.m
//  MultipeerChat
//
//  Created by Spiros Gerokostas on 3/28/14.
//  Copyright (c) 2014 Spiros Gerokostas. All rights reserved.
//

#import "MPCController.h"

NSString *const kMPCControllerDidChangeStateNotification = @"MPCControllerDidChangeStateNotification";
NSString *const kMPCControllerDidReceiveDataNotification = @"MPCControllerDidReceiveDataNotification";
NSString *const kMPCControllerDidStartReceivingResourceNotification = @"MPCControllerDidStartReceivingResourceNotification";
NSString *const kMPCControllerDidFinishReceivingResourceNotification = @"MPCControllerDidFinishReceivingResourceNotification";
NSString *const kMPCControllerDidReceiveStreamNotification = @"MPCControllerDidReceiveStreamNotification";

@implementation MPCController

@synthesize advertiserAssistant = _advertiserAssistant;
@synthesize peerID = _peerID;
@synthesize session = _session;
@synthesize browser = _browser;

#pragma mark - Singleton

+ (MPCController *)sharedController
{
    static MPCController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    return sharedController;
}

- (void)setupMCPeerIDWithDisplayName:(NSString *)displayName
{
    _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    _session = [[MCSession alloc] initWithPeer:_peerID];
    _session.delegate = self;
}

- (void)setupMCBrowser
{
    _browser = [[MCBrowserViewController alloc] initWithServiceType:@"MPCController" session:_session];
}

- (void)startAdvertiserAssistant
{
    _advertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:@"MPCController" discoveryInfo:nil session:_session];
    [_advertiserAssistant start];
}

- (void)stopAdvertiserAssistant
{
    [_advertiserAssistant stop];
    _advertiserAssistant = nil;
}

#pragma mark - MCSession Delegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSDictionary *dictionary = @{@"peerID": peerID,
                                 @"state":[NSNumber numberWithInt:state]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMPCControllerDidChangeStateNotification object:nil userInfo:dictionary];
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSDictionary *dictionary = @{@"peerID": peerID,
                                 @"data": data};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMPCControllerDidReceiveDataNotification object:nil userInfo:dictionary];
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    NSDictionary *dictionary = @{@"peerID": peerID,
                                 @"resourceName": resourceName,
                                 @"progress": progress};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMPCControllerDidStartReceivingResourceNotification object:nil userInfo:dictionary];
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    NSDictionary *dictionary = @{@"peerID": peerID,
                                 @"resourceName": resourceName,
                                 @"localURL": localURL};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMPCControllerDidFinishReceivingResourceNotification object:nil userInfo:dictionary];
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    NSDictionary *dictionary = @{@"peerID": peerID,
                                 @"streamName": streamName};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMPCControllerDidReceiveStreamNotification object:nil userInfo:dictionary];
}

@end
