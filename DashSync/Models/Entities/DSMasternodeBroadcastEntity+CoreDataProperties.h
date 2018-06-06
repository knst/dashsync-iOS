//
//  DSMasternodeBroadcastEntity+CoreDataProperties.h
//  DashSync
//
//  Created by Sam Westrich on 6/4/18.
//
//

#import "DSMasternodeBroadcastEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DSMasternodeBroadcastEntity (CoreDataProperties)

+ (NSFetchRequest<DSMasternodeBroadcastEntity *> *)fetchRequest;

@property (nonatomic, assign) uint32_t address;
@property (nullable, nonatomic, retain) NSData *mnbHash;
@property (nonatomic, assign) uint16_t port;
@property (nonatomic, assign) uint32_t protocolVersion;
@property (nonatomic, assign) uint64_t signatureTimestamp;
@property (nonatomic, assign) uint32_t utxoIndex;
@property (nullable, nonatomic, retain) NSData *utxoHash;
@property (nullable, nonatomic, retain) NSData *publicKey;
@property (nullable, nonatomic, retain) NSData *signature;
@property (nonatomic, retain) DSChainEntity * chain;

@end

NS_ASSUME_NONNULL_END
