//
//  DSChainManager.h
//  DashSync
//
//  Created by Sam Westrich on 5/6/18.
//

#import <Foundation/Foundation.h>
#import "DSChainPeerManager.h"

FOUNDATION_EXPORT NSString* _Nonnull const DSChainsDidChangeNotification;

@interface DSChainManager : NSObject

@property (nonatomic,strong) DSChainPeerManager * mainnetManager;
@property (nonatomic,strong) DSChainPeerManager * testnetManager;
@property (nonatomic,strong) NSArray * devnetManagers;
@property (nonatomic,readonly) NSArray * chains;
@property (nonatomic,readonly) NSArray * devnetChains;

-(DSChainPeerManager*)peerManagerForChain:(DSChain*)chain;

-(void)updateDevnetChain:(DSChain* _Nonnull)chain forServiceLocations:(NSMutableOrderedSet<NSString*>* _Nonnull)serviceLocations withStandardPort:(uint32_t)standardPort;

-(DSChain* _Nullable)registerDevnetChainWithIdentifier:(NSString* _Nonnull)identifier forServiceLocations:(NSMutableOrderedSet<NSString*>* _Nonnull)serviceLocations withStandardPort:(uint32_t)port;

-(void)removeDevnetChain:(DSChain* _Nonnull)chain;

+ (instancetype _Nullable)sharedInstance;

-(void)resetSpendingLimits;

@end
