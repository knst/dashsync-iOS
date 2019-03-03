//
//  DSLocalMasternode+Protected.h
//  DashSync
//
//  Created by Sam Westrich on 2/14/19.
//

#import "DSLocalMasternode.h"

NS_ASSUME_NONNULL_BEGIN

@interface DSLocalMasternode ()

-(instancetype)initWithIPAddress:(UInt128)ipAddress onPort:(uint32_t)port inWallet:(DSWallet*)wallet;

-(instancetype)initWithIPAddress:(UInt128)ipAddress onPort:(uint32_t)port inFundsWallet:(DSWallet*)wallet inOperatorWallet:(DSWallet*)operatorWallet inOwnerWallet:(DSWallet*)ownerWallet inVotingWallet:(DSWallet*)votingWallet;

-(instancetype)initWithIPAddress:(UInt128)ipAddress onPort:(uint32_t)port inFundsWallet:(DSWallet*)wallet fundsWalletIndex:(NSUInteger)fundsWalletIndex inOperatorWallet:(DSWallet*)operatorWallet operatorWalletIndex:(NSUInteger)operatorWalletIndex inOwnerWallet:(DSWallet*)ownerWallet ownerWalletIndex:(NSUInteger)ownerWalletIndex inVotingWallet:(DSWallet*)votingWallet votingWalletIndex:(NSUInteger)votingWalletIndex;

-(instancetype)initWithProviderTransactionRegistration:(DSProviderRegistrationTransaction*)providerRegistrationTransaction;

-(void)updateWithUpdateRegistrarTransaction:(DSProviderUpdateRegistrarTransaction*)providerUpdateRegistrarTransaction save:(BOOL)save;

-(void)updateWithUpdateServiceTransaction:(DSProviderUpdateServiceTransaction*)providerUpdateServiceTransaction save:(BOOL)save;

-(void)updateWithUpdateRevocationTransaction:(DSProviderUpdateRevocationTransaction*)providerUpdateRevocationTransaction save:(BOOL)save;

@end

NS_ASSUME_NONNULL_END
