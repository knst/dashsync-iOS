//
//  DSDeterministicMasternodeListTests.m
//  DashSync_Tests
//
//  Created by Sam Westrich on 7/18/18.
//  Copyright © 2018 Dash Core Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DSChain.h"
#import "DSChainManager.h"
#import "DSChainsManager.h"
#import "DSCoinbaseTransaction.h"
#import "DSGetMNListDiffRequest.h"
#import "DSInsightManager.h"
#import "DSMasternodeManager+Mndiff.h"
#import "DSMasternodeProcessorContext.h"
#import "DSMerkleBlock.h"
#import "DSMerkleBlockEntity+CoreDataClass.h"
#import "DSOptionsManager.h"
#import "DSQuorumSnapshotEntity+CoreDataClass.h"
#import "DSSimplifiedMasternodeEntry.h"
#import "DSTransactionFactory.h"
#import "NSArray+Dash.h"
#import "NSData+Dash.h"
#import "NSString+Bitcoin.h"
#import "dash_shared_core.h"
#import <DashSync/DSMasternodeList.h>
#import <DashSync/DSMasternodeListEntity+CoreDataClass.h>
#import <DashSync/DSMasternodeManager+Mndiff.h>
#import <DashSync/DSMasternodeManager+Protected.h>
#import <DashSync/DSMnDiffProcessingResult.h>
#import <DashSync/DSQuorumEntry.h>
#import <DashSync/DSQuorumEntryEntity+CoreDataClass.h>
#import <DashSync/DSSimplifiedMasternodeEntry.h>
#import <DashSync/DSSimplifiedMasternodeEntryEntity+CoreDataClass.h>
#import <DashSync/NSManagedObject+Sugar.h>
#import <XCTest/XCTest.h>
#import <arpa/inet.h>

@interface DSDeterministicMasternodeListTests : XCTestCase

@end

@implementation DSDeterministicMasternodeListTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

// these have to be redone
//     -(void)testIndividualSimplifiedMasternodeEntry {
//         UInt256 transactionHashData = *(UInt256*)@"2a08656c679bcf0af27a6e1b46744f2afcfe22d48eb612282919876ce1bd5e67".hexToData.reverse.bytes;
//         UInt160 keyDataInt = *(UInt160*)@"01653d4a79ac7ee88482067d9e8d67882aee8a02".hexToData.reverse.bytes;
//         DSChain * devnetDRA = [DSChain devnetWithIdentifier:@"devnet-DRA"];
//         NSString * ipAddressString = @"13.250.100.254";
//         UInt128 ipAddress = { .u32 = { 0, 0, CFSwapInt32HostToBig(0xffff), 0 } };
//         struct in_addr addrV4;
//         if (inet_aton([ipAddressString UTF8String], &addrV4) != 0) {
//             uint32_t ip = ntohl(addrV4.s_addr);
//             ipAddress.u32[3] = CFSwapInt32HostToBig(ip);
//         } else {
//             NSLog(@"invalid address");
//         }
//         DSSimplifiedMasternodeEntry * simplifiedMasternodeEntry = [DSSimplifiedMasternodeEntry simplifiedMasternodeEntryWithProviderRegistrationTransactionHash:transactionHashData confirmedHash:<#(UInt256)#> address:<#(UInt128)#> port:<#(uint16_t)#> operatorBLSPublicKey:<#(UInt384)#> keyIDVoting:<#(UInt160)#> isValid:<#(BOOL)#> onChain:<#(DSChain *)#>sh:transactionHashData address:ipAddress port:12999 keyIDOperator:keyDataInt keyIDVoting:keyDataInt isValid:TRUE onChain:devnetDRA];
//         XCTAssertEqualObjects([NSData dataWithUInt256:simplifiedMasternodeEntry.simplifiedMasternodeEntryHash],@"6b8e569016e188ebd5908edc5f3ede1fc364bf55398717eaedfa30f0c6cf8b1d".hexToData,@"SMLE Hash not correct");
//
//         NSData * data = @"675ebde16c8719292812b68ed422fefc2a4f74461b6e7af20acf9b676c65082a00000000000000000000ffff0dfa64fe32c7028aee2a88678d9e7d068284e87eac794a3d6501028aee2a88678d9e7d068284e87eac794a3d650101".hexToData;
//
//         DSSimplifiedMasternodeEntry * simplifiedMasternodeEntryFromData = [DSSimplifiedMasternodeEntry simplifiedMasternodeEntryWithData:data onChain:devnetDRA];
//         XCTAssertEqualObjects(simplifiedMasternodeEntry.payloadData,simplifiedMasternodeEntryFromData.payloadData,@"SMLE methods have issues");
//     }
//
//- (void)testDSMasternodeBroadcastHash {
//     {
//         NSMutableArray<DSSimplifiedMasternodeEntry*>* entries = [NSMutableArray array];
//         for (unsigned int i = 0; i < 16; i++) {
//             NSString * transactionHashString = [NSString stringWithFormat:@"%064x",i];
//             UInt256 transactionHashData = *(UInt256*)transactionHashString.hexToData.reverse.bytes;
//             NSString * keyString = [NSString stringWithFormat:@"%040x",i];
//             NSData * keyData = keyString.hexToData.reverse;
//             UInt160 keyDataInt = *(UInt160*)keyData.bytes;
//             DSSimplifiedMasternodeEntry * simplifiedMasternodeEntry = [DSSimplifiedMasternodeEntry simplifiedMasternodeEntryWithProviderRegistrationTransactionHash:transactionHashData address:UINT128_ZERO port:i keyIDOperator:keyDataInt keyIDVoting:keyDataInt isValid:TRUE onChain:[DSChain mainnet]];
//             [entries addObject:simplifiedMasternodeEntry];
//         }
//
//         NSMutableArray * simplifiedMasternodeEntryHashes = [NSMutableArray array];
//
//         for (DSSimplifiedMasternodeEntry * entry in entries) {
//             [simplifiedMasternodeEntryHashes addObject:[NSData dataWithUInt256:entry.simplifiedMasternodeEntryHash]];
//         }
//
//         NSArray * stringHashes = @[@"6c06974f8f6d88bf30f21854836c994452e784c4f9aa2ea5c8ca6fcf10181f8b", @"90f788b6b946cced7ed765efeb9123c08bef8e025428a02ab7eedcc65c6a6cb0", @"45c2e12db6e85d0e30a460f69159a37f8a9d81e8b4949c640a64c9119dbe3f45", @"a56add792486a8c5067866609484e6d36f650da7cd4db5ca4111ecd579334a6c", @"09a0be55cebd876c1f97857c0950739dfc6e84ab62e1bb99918042d3eafb1be3", @"adb23c6a1308da95d777f88bede5576c54f52651979a3ca5e16d8a20001a7265", @"df45a56be881ab0d7812f8c43d6bb164d5abb42b37baaf3e01b82d6331a75d9b", @"5712e7a512f307aa652f15f494df1d47a082fb54a9557d54cb8fcc779bd65b48", @"58ab53be8cd4e97a48395ac8d812e684f3ab2d6be071f58055e7f6856076f1d4", @"4652b7caad564d56e106d025705ad3ee6f66e56bb8ce6ce86ac396f06f6eb75e", @"7480510e4dc4468bb23d9f3cb9fb10a170080afe270d5ba58948ebc746e24205", @"68f9e1572c626f1d946031c16c7020d8cbc565de8021869803f058308242266e", @"ca8895e0bea291d1d0e1bd8716de1369f217e7fcd0ee7969672434d71329b3cd", @"9db68eccc2dc8c80919e7507d28e38a1cd7381d2828cbe8ad19331ed94b1b550", @"42660058e883c3ea8157e36005e6941a1d1bea4ea1e9a03897c9682aa834e09f", @"55d90588e07417e7144a69fee1baea16dc647b497ee1affc2c3d91b09ad23c9c"];
//
//         NSMutableArray * verifyHashes = [NSMutableArray array];
//
//         for (NSString * stringHash in stringHashes) {
//             [verifyHashes addObject:stringHash.hexToData.reverse];
//         }
//
//         XCTAssertEqualObjects(simplifiedMasternodeEntryHashes,verifyHashes,@"Checking hashes");
//
//         NSString * root = @"ddfd8bcde9a5a58ce2a043864d8aae4998996b58f5221d4df0fd29d478807d54";
//         NSData * merkleRoot = [NSData merkleRootFromHashes:verifyHashes];
//
//         XCTAssertEqualObjects(root.hexToData.reverse,merkleRoot,
//                               @"MerkleRootEqual");
//
//     }
//
//     {
//         NSMutableArray<DSSimplifiedMasternodeEntry*>* entries = [NSMutableArray array];
//         for (unsigned int i = 0; i < 15; i++) {
//             NSString * transactionHashString = [NSString stringWithFormat:@"%064x",i];
//             UInt256 transactionHashData = *(UInt256*)transactionHashString.hexToData.reverse.bytes;
//             NSString * keyString = [NSString stringWithFormat:@"%040x",i];
//             NSData * keyData = keyString.hexToData.reverse;
//             UInt160 keyDataInt = *(UInt160*)keyData.bytes;
//             NSString * ipAddressString = [NSString stringWithFormat:@"0.0.0.%d",i];
//             UInt128 ipAddress = { .u32 = { 0, 0, CFSwapInt32HostToBig(0xffff), 0 } };
//             struct in_addr addrV4;
//             if (inet_aton([ipAddressString UTF8String], &addrV4) != 0) {
//                 uint32_t ip = ntohl(addrV4.s_addr);
//                 ipAddress.u32[3] = CFSwapInt32HostToBig(ip);
//             } else {
//                 NSLog(@"invalid address");
//             }
//
//             DSSimplifiedMasternodeEntry * simplifiedMasternodeEntry = [DSSimplifiedMasternodeEntry simplifiedMasternodeEntryWithProviderRegistrationTransactionHash:transactionHashData address:ipAddress port:i keyIDOperator:keyDataInt keyIDVoting:keyDataInt isValid:TRUE onChain:[DSChain mainnet]];
//             [entries addObject:simplifiedMasternodeEntry];
//         }
//
//         XCTAssertEqualObjects(entries[3].payloadData,@"030000000000000000000000000000000000000000000000000000000000000000000000000000000000ffff0000000300030300000000000000000000000000000000000000030000000000000000000000000000000000000001".hexToData,@"Value 3 did not match");
//
//         NSMutableArray * simplifiedMasternodeEntryHashes = [NSMutableArray array];
//
//         for (DSSimplifiedMasternodeEntry * entry in entries) {
//             [simplifiedMasternodeEntryHashes addObject:[NSData dataWithUInt256:entry.simplifiedMasternodeEntryHash]];
//         }
//
//         NSArray * stringHashes = @[@"aa8bfb825f433bcd6f1039f27c77ed269386e05577b0fe9afc4e16b1af0076b2",
//                                    @"686a19dba9b515f77f11027cd1e92e6a8c650448bf4616101fd5ddbe6e2629e7",
//                                    @"c2efc1b08daa791c71e1d5887be3eaa136381f783fcc5b7efdc5909db38701bb",
//                                    @"ce394197d6e1684467fbf2e1619f71ae9d1a6cf6548b2235e4289f95d4bccbbd",
//                                    @"aeeaf7b498aa7d5fa92ee0028499b4f165c31662f5e9b0a80e6e13b38fd61f8d",
//                                    @"0c1c8dc9dc82eb5432a557580e5d3d930943ce0d0db5daebc51267afb46b6d48",
//                                    @"1c4add10ea844a46734473e48c2f781059b35382219d0cf67d6432b540e0bbbe",
//                                    @"1ae1ad5ff4dd4c09469d21d569a025d467dca1e407581a2815175528e139b7da",
//                                    @"d59b231cdc80ce7eda3a3f37608abda818659c189d31a7ef42024d496e290cbc",
//                                    @"2d5e6c87e3d4e5b3fdd600f561e8dec1ea720560569398006050480232f1257c",
//                                    @"3d6af35f08efeea22f3c8fcb78038e56dac221f3173ca4e2230ea8ae3cbd3c60",
//                                    @"ecf547077c37b79da954c4ef46a3c4fb136746366bfb81192ed01de96fd66348",
//                                    @"626af5fb8192ead7bbd79ad7bfe2c3ea82714fdfd9ac49b88d7a411aa6956853",
//                                    @"6c84a4485fb2ba35b4dcd4d89cbdd3d813446514bb7a2046b6b1b9813beaac0f",
//                                    @"453ca2a83140da73a37794fe6fddd701ea5066f21c2f1df8a33b6ff6134043c3",];
//
//         NSMutableArray * verifyHashes = [NSMutableArray array];
//
//         for (NSString * stringHash in stringHashes) {
//             [verifyHashes addObject:stringHash.hexToData.reverse];
//         }
//
//         XCTAssertEqualObjects(simplifiedMasternodeEntryHashes,verifyHashes,@"Checking hashes");
//
//         NSString * root = @"926efc8dc7b5b060254b102670b918133fea67c5e1bc2703d596e49672878c22";
//         NSData * merkleRoot = [NSData merkleRootFromHashes:verifyHashes];
//
//         XCTAssertEqualObjects(root.hexToData.reverse,merkleRoot,
//                               @"MerkleRootEqual");
//
//     }
// }

+ (NSData *)messageFromFileWithPath:(NSString *)filePath {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:filePath ofType:@"dat"];
    NSData *message = [NSData dataWithContentsOfFile:path];
    XCTAssert(message.length, @"File must exist for file %@", filePath);
    return message;
}

+ (DSMasternodeList *)masternodeListFromJsonFile:(NSString *)filePath forChain:(DSChain *)chain {
    NSData *data = [DSDeterministicMasternodeListTests messageFromFileWithPath:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    UInt256 blockHash = ((NSString *)json[@"blockHash"]).hexToData.UInt256;
    UInt256 masternodeMerkleRoot = ((NSString *)json[@"masternodeMerkleRoot"]).hexToData.UInt256;
    UInt256 quorumMerkleRoot = ((NSString *)json[@"quorumMerkleRoot"]).hexToData.UInt256;
    uint32_t knownHeight = (uint32_t)[[json objectForKey:@"knownHeight"] unsignedIntegerValue];

    NSMutableArray<NSDictionary *> *nodes = [json mutableArrayValueForKey:@"mnList"];
    NSMutableArray<NSDictionary *> *llmqs = [json mutableArrayValueForKey:@"newQuorums"];

    NSMutableArray *quorums = [NSMutableArray arrayWithCapacity:llmqs.count];
    NSMutableArray *masternodes = [NSMutableArray arrayWithCapacity:nodes.count];

    for (NSDictionary *node in nodes) {
        UInt256 proRegTxHash = ((NSString *)node[@"proRegTxHash"]).hexToData.UInt256;
        UInt256 confirmedHash = ((NSString *)node[@"confirmedHash"]).hexToData.UInt256;
        UInt128 ipAddress = ((NSString *)node[@"service"]).hexToData.UInt128;
        UInt160 keyIdVoting = ((NSString *)node[@"votingAddress"]).base58ToData.UInt160;
        UInt384 operatorPublicKey = ((NSString *)node[@"operatorPublicKey"]).hexToData.UInt384;
        BOOL isValid = [[node valueForKey:@"isValid"] boolValue];
        DSSimplifiedMasternodeEntry *entry = [DSSimplifiedMasternodeEntry
            simplifiedMasternodeEntryWithProviderRegistrationTransactionHash:proRegTxHash
                                                               confirmedHash:confirmedHash
                                                                     address:ipAddress
                                                                        port:0
                                                        operatorBLSPublicKey:operatorPublicKey
                                                    operatorPublicKeyVersion:0
                                               previousOperatorBLSPublicKeys:@{}
                                                                 keyIDVoting:keyIdVoting
                                                                    isValid:isValid
                                                                        type:0
                                                            platformHTTPPort:0
                                                                platformNodeID: UINT160_ZERO
                                                            previousValidity:@{}
                                                      knownConfirmedAtHeight:knownHeight
                                                                updateHeight:knownHeight
                                               simplifiedMasternodeEntryHash:UINT256_ZERO
                                     previousSimplifiedMasternodeEntryHashes:@{}
                                                                     onChain:chain];
        [masternodes addObject:entry];
    }

    for (NSDictionary *llmq in llmqs) {
        DSQuorumEntry *entry = [[DSQuorumEntry alloc] initWithVersion:[[llmq valueForKey:@"version"] unsignedIntegerValue]
                                                                 type:(LLMQType)[[llmq objectForKey:@"llmqType"] unsignedIntegerValue]
                                                           quorumHash:((NSString *)llmq[@"quorumHash"]).hexToData.UInt256
                                                          quorumIndex:(uint32_t)[[llmq objectForKey:@"quorumIndex"] unsignedIntegerValue]
                                                         signersCount:(int32_t)[[llmq objectForKey:@"signersCount"] integerValue]
                                                        signersBitset:((NSString *)llmq[@"signers"]).hexToData
                                                    validMembersCount:(int32_t)[[llmq objectForKey:@"validMembersCount"] integerValue]
                                                   validMembersBitset:((NSString *)llmq[@"quorumHash"]).hexToData
                                                      quorumPublicKey:((NSString *)llmq[@"quorumPublicKey"]).hexToData.UInt384
                                         quorumVerificationVectorHash:((NSString *)llmq[@"quorumVvecHash"]).hexToData.UInt256
                                             quorumThresholdSignature:((NSString *)llmq[@"quorumSig"]).hexToData.UInt768
                                     allCommitmentAggregatedSignature:((NSString *)llmq[@"membersSig"]).hexToData.UInt768
                                                      quorumEntryHash:UINT256_ZERO
                                                              onChain:chain];

        [quorums addObject:entry];
    }


    DSMasternodeList *masternodeList = [DSMasternodeList masternodeListWithSimplifiedMasternodeEntries:masternodes
                                                                                         quorumEntries:quorums
                                                                                           atBlockHash:blockHash
                                                                                         atBlockHeight:knownHeight
                                                                          withMasternodeMerkleRootHash:masternodeMerkleRoot
                                                                              withQuorumMerkleRootHash:quorumMerkleRoot
                                                                                               onChain:chain];

    return masternodeList;
}

- (void)testMasternodeListDiff1 {
    // baseBlockHash 00000bafbc94add76cb75e2ec92894837288a481e5c005f6563d91623bf8bc2c (0) blockHash 0000001618273379c4d96403954480bdf5c522d734f457716db1295d7a3646e0 (8000)

    NSString *hexString = @"2cbcf83b62913d56f605c0e581a48872839428c92e5eb76cd7ad94bcaf0b0000e046367a5d29b16d7157f434d722c5f5bd8044950364d9c479332718160000000100000001f3382f83c5a0f4c3b7f4a85017e72be79aa2377ddce9ee9cfcec1c0d34fbf118010103000500010000000000000000000000000000000000000000000000000000000000000000ffffffff4b02401f0484ed195c08fabe6d6d6514aa332002bdcdf36ae5fe780027807d397a699b3a80ee7be2fa819650b48f01000000000000006ffffff5010000000d2f6e6f64655374726174756d2f000000000340c3609a010000001976a914cb594917ad4e5849688ec63f29a0f7f3badb5da688ac2485c78d010000001976a914870ca3662658f261952cbfa56969283ad1e84dc588ac1c3e990c000000001976a914870ca3662658f261952cbfa56969283ad1e84dc588ac00000000260100401f00007a823221095ab36f929350bf65f799d0a0f98114b2e4c30f289411e3c2da3505006242911ec289c2b1559009f988cbfa48a36f606c0aa37c4c6e6b536ab0a9d9eca178ef8076c76fd5eb17b5fb8f748bb04202f26efb7fba6840092acde00a00000000000000000000000000ffff3f21ee554e4e08b32c435d28b26ea4c42089edacadaf8016651931f22a8273feedc3f535592f2ea709aa3bf87f9e751073cf05b82aac3cf9e251ef3f1147f64a3af6c29319eb326385bf0128f89142530ec3f0832aba5d71d14ac1ff284cfb8c7ac1b59df6c5c41750cf71f1652828ff41af6e504bb2081165b27cf520ea3381f716bb1a105e261d00000000000000000000000000ffff5fb73511271710d647e3107b77440e2e9957092aeadbba86d02eb95ec23e490c023936bbd4eda6cf8850f98d01bddf4db0a405bc6a373f86e46dd739b18399d05b219de3217e751b201a01735b425b8ae3330507aa1fb4c5c679578bc15c814582d1e9c41cf0e11fa3cbd1dd41a1bf278f9d1b78622dca0d9533ab2dc65d71d7225975fadca9fa1f00000000000000000000000000ffff5fb73511271c0f9764003b7ede1d0d01f2cf16fc0f706f5394d2da1bacda404615c60d5bcb0b22a76776fd9be00f1d4a4a668ff3fa223cfbfddad5b5ad0644feead52e00560717eba6e901d79c543b826e0254c6c8aab06dd8b1445677df23d93f228798535d3030ea4ac2bbaf9ff7a4ffcf3931de9233fa8e151f187bf30235000e3b5fb102b01200000000000000000000000000ffff5fb735112711845e9bf2879d98ece4aa8b78ca074e32f968bd93bac973a1abafd61f900b70e7178b6352d830d0fecc2653d0f04a915189842a43e2868f4e5451c2051466a8d6b1bfc2bb01fe85d7358334177035e982db8388fd37b752325df17a53717b78e2b0c91b299f3554b945bbff333cff1a0d4d95c848b52e558060fd7b2f2e37dadbfd1a00000000000000000000000000ffff12ca34aa4e20157eff76f9632db9536c8af64a2283f3da7f91db86dacdfbf193ada958f69980e18d8d1f44d225fddcffc7176a941a26715baed3fbb275664b20a5c0f525568e609ab0c20120ba3f10dc821c8a929aeb9a32e98339fc2f7a3d64b705129777c9a39780a01e3554b945bbff333cff1a0d4d95c848b52e558060fd7b2f2e37dadbfd1a00000000000000000000000000ffff3f21ee554e26983c80e3e31fea6f3d56d54059e8c95a467285f33914182f1e274616cdbe2f1e1c6c0c7dce13710480ec4658208e9392fdf9ff7c06cbf660a2c93d466d5379492eb733420140befe806aca699fddfebe35a1edaede5bf3c33442cbd4a338db99ccb9f5717c6dbc9a92d48276c26702cee31a36b25c8002baaff59298c11e9457b42400000000000000000000000000ffff8c523b3327130008f22c7d80df8a9487d09ad2a93f7cdbff39b63467154fac0acb1035fb261f6fb6dc9c3eca70ab9f5939bc401d739c72c1b5e1df55233bf2b9548557e410481553de3200a01b70e913df11ee62bc4d21eeeea6a540fa5c2cf975952c728be8eed09623733554b945bbff333cff1a0d4d95c848b52e558060fd7b2f2e37dadbfd1a00000000000000000000000000ffff3432d0354e258dfa69a96f23bd77e72c1a00984bb0df5ce93a76ca1d20694e8ad20b1dfea530cb6ee0b964b78ebb2bc8bfac22f61647e19574f5e7b2fa793c90eaed6bda49d7559e95d30121958ba1693c76e70a81c354111cc48a50579587329978c563e2e5655991a2a35a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff12ca34aa4e380a9117edbb85963c1c5fdbcdcaf33483ee37676e8a34c3f8d298418df77bbdf16791821a75354f0a4f2114c090a4798c318a716eb1abea572d94e176aa2df977f73b05ab0141e985aec00b41aac2d42a5c2cca1fd333fb42dea7465930666df9179e341d2b5a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff22ff0f144e2b8fd425f945936b02a97c8807d20272742d351356bff653f9467ab29b4bdb6f19bdf863ad5a325f63a0080b9dd80037a9b619e80a88b324974c98c90f8c2289c3ca916580010106207e0dbdce8e18a97328eb9e2de99c87477cd0b2ad1b34b4231327fea08b3554b945bbff333cff1a0d4d95c848b52e558060fd7b2f2e37dadbfd1a00000000000000000000000000ffff3432d0354e298348757a2ed830f3a40f0e52ca4823f48c1ab5017dc424ee68c1e8fad27c0ab008bc974866db18bc76bc7d2bebb2997695ca25c4c132186aabbf5c7bfa331119a01969f9014172e5a561e36ae49358bc4c6c37ff688f54a05ae8842b496b86feb71f06b886bbaf9ff7a4ffcf3931de9233fa8e151f187bf30235000e3b5fb102b01200000000000000000000000000ffff6deb47384e1f8d1412ff39045ef39c2e19a75cb3ad986afc14c3139ed0a3392b41d471558676029a8137f95b0ba0e7315bf11c497f0fc8270f9d208c75006659cedd927f04ccf829242c018167aa267eb42b78d112b3600358ea7679328be8ceecec2cd68148985b6654405a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3f21ee554e3a07e472824512fd8004e7c81c3dff74c72f898c2a25f71246de316f6dbc976fe4e54d103e6276e457c415f53ba867e1d7ce2eeb1be671205ee68db332dd0f4871f549baf101a1d700ddb67ae80c1cb4fdb76dac6484dc1dc2741334ad5e48f78fd08713a13478ef8076c76fd5eb17b5fb8f748bb04202f26efb7fba6840092acde00a00000000000000000000000000ffff3432d0354e4d88a5857ea0eb8a5fe369bb672144867c4908300089472108afb9d54a70f7d6e4b339d01509dd9231da90b14cb401df2f007aec84e8af1b8f2da40a74b4d3beeaa8b47348012354b77c0f261f3d5b8424cbe67c2f27130f01c531732a08b8ae3f28aaa1b1fbb04a8e207d15ce5d20436e1caa792d46d9dffde499917d6b958f98102900000000000000000000000000ffffad3d1ee74a4496a9d730b5800ad10d2fb52b0067b5145d763b227fccb90f37f14f94afd9a9927776f9af8cfcd271f9ce9d06b97af01aad66a452e506399c18cf8ec93ee72ba9e09c5dab01e3845dbdaf3aac0f0f1997815ad9084c97f7d5788355a5d3ed2971f98dde1c2178ef8076c76fd5eb17b5fb8f748bb04202f26efb7fba6840092acde00a00000000000000000000000000ffff12ca34aa4e500a10b1fec64669c47086bc0f1d48ea6b37045f7e46c73c5ec41f7576653d7a6d7c79bd1215f16675bb31a59a7137241b99e1db7c082547cb66e0e84505f6a12e5a62733c0163cd3bf06404d78f80163afeb4b13e187dc1c1d04997ef04f1a2ecb3166dd00479521b08e5ad66c2fd6c2f514abe8416cd412dd2794d0f40d353fdd70500000000000000000000000000ffff2d20ed4c4e1f02a2e2673109a5e204f8a82baf628bb5f09a8dfc671859e84d2661cae03e6c6e198a037e968253e94cd099d07b98e94e0b3c7481f9b39efdcf96260c5e8b0f85ff3f646f0183ba23283a9b9dfda9cda5c3ee7e16881425506e976d60a39876a46ce82f38af5a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff12ca34aa4e3c9446b87f833f500e114d024d50024278f22d773111e8e5601e05178005298e5fc2933e400e235c0a51417872f68cc20d773bddc2720f67dd88bfcc61a857d8d9b2d92aae0103df73261636cb60d11484684c25e652217aad6f7f07862c324964cc87b1a7f45a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff22ff0f144e2f067ad7a999ad2dc7f41c735a3dff1d50068f0fc0fde50a7da1c472728ff33f9dd6b20385aaf3c34d9a259dcef975c48b9bd06acb04e2cf63daee7da0c65ce68715d5299b01045480c439ccaf9f38afff4a07e8a212735cdea7e7e8f2511c0883e2583e2b68ef6d852f7e1d547e18f881e4cb053d531b046c0750a8c620553524c81800000000000000000000000000ffff40c13ece4e1f05f2269374676476f00068b7cb168d124b7b780a92e8564e18edf45d77497abd9debf186ee98001a0c9a6dfccbab7a0af4aa6fd6b27d9649267b4ae48e3be5399c89d63a01c4842fe854e91a7b01fc1a1ec923e9f287da74f53a510e60b4b0bbb5433bf1dcdd41a1bf278f9d1b78622dca0d9533ab2dc65d71d7225975fadca9fa1f00000000000000000000000000ffff9f41e9344e1f15e97fb8029420a71f7125cbf963696c3fbf9636f6d2fa8997d35d37416e2c837182f2e7b7623498736253e5469eb894b2d4f9828fb06df1afb28683314ea5f84faf83f901a49e8534a2d427ef3a94d3ddaf2b05702e87e99d148739e949b64a7c1ebf695f78ef8076c76fd5eb17b5fb8f748bb04202f26efb7fba6840092acde00a00000000000000000000000000ffff22ff0f144e4f9155ae06f2e689f4fa68d5ff89e0d95feeacb431cce7065615d2de64095024e1b60bdfe740e5da5facf13cbbe9d06960265fa2c8a28b6abd1b22272a2cc52d2d8437317501c551d5597cc4f8ab6921af4f896ab68e6e71d15bfa8a1bec00769f6894157f075a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3f21ee554e3689fd3e2cc5690053c4252a2a95fccde944b141a3ac8e6b8c36c6b61e71d076f5cc4f9ba0f191d8051ea9b5c51cc5848059c75118444f9a31b03b4285c5dfb26da4f136b1012507422a27822ce0fafa7847828eced46309ff30968980ab12d74d8c751507306645fce7c379f7dc790472e00b2e4c9595c0a8932ec0102ac2e63fd00000000000000000000000000000ffffad3d1ee74a498bb67827af87431673e737c49312c5a16fd284daf1c4050e530b604ec4f85f217080503f978a6bec89d1ad4bca089c322583b4b7628ef1186853ff1166818d69d3aeaa420186d4f4152d96ff46c1f8ff948d11923899d2459f4656d5419682d8e16a41c7df3554b945bbff333cff1a0d4d95c848b52e558060fd7b2f2e37dadbfd1a00000000000000000000000000ffff3432d0354e218312e0ba7e4ace816595ade43d2293d70c3dce6b3e7e0ce9e99016f99177277bb42e6d3c2d687ab3e8bed13fb0d3489011dd36c51a435a18af6d4b28b7bc23e706953df401461dc135037403e79929e97099d82532e48cc3f877f8d243bda0673cc73198755a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3432d0354e2d8c8c7a5b96ed96dd5dbc40db042c301a9d70d5cb98ec073d41cc6a3c68d73ef0d6524cfa210ae1496a880e50fca3fcd15c5002882d6407c275f8850cafd70467a539a86301862677231ca31abd98e260e0678fe63d8580bf7a142a1afa68542aa7185409435a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3f21ee554e428077763a1a91d7595a05b06f805430cac72fc6737a0c0161624dadac33b21868d903d85bed5fc491be49f0653b8779bb40df4e10076edb905b93a9026c68d39aefb1883c0127847c25d2cde5ff46975adea87a4c6822f573ee66ac940d16ae205d9f6e88830c30771d54f702cdcc27c59ed99b19a36f0fae289fe666a5c51e43601900000000000000000000000000ffff5fb73392752f9426621a0df5cd8a4432c4050f39163a76ab39b2682aa3ea2064993265d66324be3d45ab22d5f9910c8ad09b96bbc952d8c76e6f482f2a7f933386eb007e514cbbd947fe0167964c4cdb2589996ddf706e1141b14c8bd3f293a3a9020dc6ece012a05827395a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff12ca34aa4e408e74c08f84a93b8831dd42e76537e8a17964123293de69c1cb24097035e0803822eac311434638fc73a5ad43739475425a3df63bd03dd223defa3c05f2de19deb9fc99aa01a9d8b58154cbc573203f183f012ed3c037f6ca26a8c2c05c85551d8382ef72565a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3432d0354e4910a2c0d103b24425b2359eac65b6997d2207c43700eed6371616a796c0a333e7401ad3a51b565a58bd7d0e604a0c80e04b4c9c61319479726a46b6dba6c1938ecf660c3101c9ab494d5c6fa05c87f689f9de3ef0da18b397a07361e436e5a2f2d4697056f0f87168d853c9859f79e28b08e7339456b5ea19a053c3a1edb0ddbe111500000000000000000000000000ffff5fb735112719865d6f26ed3f5309e4aed19583cf179bc779e21c967485f355b214ffb6ba461a01b575a9c62b3a02d08a37d01817af832e54ec3e1b5bb6fb8de073c9451760b2127c09a601ca485207dc1a501f9a694d7cd0f007846c40e7af8d148116c647923cdf7b9d996645fce7c379f7dc790472e00b2e4c9595c0a8932ec0102ac2e63fd00000000000000000000000000000ffffad3d1ee74a48101d302d6c69d9ecb9e13e755947f3af22f63ed4ecbf466ff64bd35c3d86bf2e4d8455ab736715d8f064c8c8e4d3c585b6a6ecf5eefa2ac295cc6103d1e42c7276e72172016a59f9b585d75f1b2cb43b7c0fb90a294fa45e0c1f7a432f82139a3ddfbecd3ed2b9c32684bce2de8afb2ba9bc9f7547d3a43fc88bf0a33ae2dddf6e3700000000000000000000000000ffff6c3dc02f4e1f0634f8b926631cb2b14c81720c6130b3f6f5429da1c9dc9c33918b2474b7ffff239caa9b59c7b1a782565052232d052a1bba3b56ededb76c1834f3b3e02c159aba4777a6014acaabcb7ee31149510138a0b11b087cc5a2ff0a24225bd52b52e1c2c58a113d5a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff8c523b33271197e409f5889b8c033c412a939d2419824a2b0321e29c357a43bcc74644d1945c6a5fe7f8977edeb6210cb038039bc30f84a5d378f42cbf6b07b826f192cf691480e7070f01ea721d7420a9b58025894d08f9fecc73b7b87ed09277fa99dad5aa028ea357e176f5ce05c6c2a6de5d8a69c23a56f19dfc8f5f357c9457adf560f0f60b00000000000000000000000000ffffac3d1ee74a46983ca9ab507b3eb4e7b0d31ccef3f4553493ee5334116a3f79689f9b808a201ead332a26f7052fd17123cf142f96d85fc59f2dfb9d43f7570319c048b73a3b2e33f60778008a9a7d61d25db8904a3409468d81d49c3c190ec1f41371b036abf720e0a431fbd75782917293040170ddb8557a0c4dc1577d621f3269fe65409fddb40600000000000000000000000000ffff8c523b334e1f8b0c48578e5bfe77be25aec9e2745c8e699a6069411b3d9f90703a9f4dcce37bd62b511f3ff089422a7ba29d46e2b61675748f3aa899da653297380853319a3844e16e36018a3e98538662189dfebf2af3e9d22950256af8da8508d69ddbe4b247e846377c5a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3f21ee554e4a86f43bc634d21567e456fea9ff6556e361d00da0ee46955244009847e492402c8dc82b4247330fab96ac9f0c538496b2cbea42ed3362203f066b29126deb6d1758cb16c3016bf850444b40d517c148f79bab13778e464815829a8a0cea7391c6d0c0e636bc8cd6c3d98dfa6e65171d7050963c7f9fa87ed1fadd04e028b49681492400000000000000000000000000ffff5fb7358027110077eb37d4559f880e21dbc3840a1a8ec8c32787fab07bd12e7fde1ad5f94ae95d6e4694f3533799d14e18c6832497428f95e1e0c681187eb1950ecdce67096ed6f5bd71008bc18fff3bc302051c51b545677173c459ae62e7cde27b31aa843193d870eb255a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3f21ee554e2e1393265406093dc6bda557446b9808a40f13896a683bd9801511c75752812f4a1ad4ecd3d9e9cf4c3afc62bb6cacdfe3867f01fcfb84d68804ff6f24f02b7e6d9a888e07018b3ba1e49dd244741546eb6f2a68c82d4990c55999bf385a070d27cc7534c4784e275f599b8886b49daa3285f5d4780d103b0475ce0123a2ae3dcb232f00000000000000000000000000ffffad3d1ee74a401828028671209b5196d2204d5bc3ce3ecd554dee9ff231883f04e67bea856fcae19d7a6154039140e9e3a6c6cf3fad4d3ee3c4a4a092ba275cdff0c03b912eb1d83c5e8c012cae9e9e4e356b719de38866f5a4b3727728a2a3d6a00a5f44075a015d0f9a0d5a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff12ca34aa4e309179babbf6ca397dc089cbe29eaffb58ffc0afda1d6c7678ab3739d5b63c7f90428cbb4c4079823a3a71a25bf89f56b3c938bffbf5480f6f019e4aae7651450a8894b4bb010c67b8d2c4ab23820d89d82cb5f841b3b3734edda30f10aaa2c2bfe53a4c96645a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff22ff0f144e4390a7a1f6b509e1f13c56262b8ebce0129cb751b16d8cd681634e62714553bc4dd773a88adf16184b9f951a9b8f0d1d54b85bcda0e2d5fe1e4b122a8d39e1ba860e451b61010dbde78360328a8ed44b5620aafd17dc85fdd76609b8dbb8e3e04964d02dd35bd912379d1d92a5c6922464c487848dd37fc15e7365086f30bf8995861500000000000000000000000000ffff12ca34aa4e1f16657cbdf9339c69126511f50b07253b69d7137f225d601d4674e2829091c4aade3afd83f9b1f3d8f0205b9e73603aafd3ef3a787dd137e66e96675ddf58b205bc32aee5018de9f50be6536ed7f22ecd23bb19447387dca77f2d67024a97ce394d0d538b163554b945bbff333cff1a0d4d95c848b52e558060fd7b2f2e37dadbfd1a00000000000000000000000000ffff22ff0f144e238e5e237e8bc750e5237f3c63bdd80034be58f6698ea1a696c29ff7f81cc251dabc5f925b65289e428461e2c74ba894ef0b5468254e500cb9881f73567c545b5ddfc51f50012dca894a2b5af0bf82abf0cfba978555f41a669278b6e91ca14c0593beaf220076f5ce05c6c2a6de5d8a69c23a56f19dfc8f5f357c9457adf560f0f60b00000000000000000000000000ffffad3d1ee74a4794b7723262031b6cd2e79b07f36a794d3e684c538a6f2418fff01c027fab1ca4663ab0b92670ee1797fa71d8676362a0ed8648ca7d2813a5bf93338e12d05db2e07d4d8c010ed18ce6df1e9a7a957852f65486a0eb17c70b8d51a24faf4a0a2e047100bb7b5a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3432d0354e390bb7f50754a1fcd59d9d13bb7487060a7e6c9226af162de0d173b132e033e8da6e0f53eff5a1fe3a3d63e853217611a434762055a745abc52735a1fab5b7c509f873a64001ae4a298a414e8a8470e8c5b911a3c6f9200a806fa1dac65bf0e317c32ebcec8e84c09dfa353c83ce072c6a67d2081e80418db10e7dd8260b5acdd5f92400000000000000000000000000ffff5fb73392c34f92f5e861ac88ddd95e3829afc45f9358ea0973e19da8e42eabbfe8f2d9e5fa32204e7f1de5e20c7e45ee51ab262cf7dd70238a568f0ed035de6210a002f65fbd549ba8e101ee4ad05d852e40c676005d0d1830e45259b1c8b778e61d1b40a3758013f2988cd3730f336bd25c6a63868741dfced8b86873b3936c8590d890130d485300000000000000000000000000ffffb23ecbf94e1f12045d8b6c7f20036dac4c2f98b1d73c774ce4278b61412ac567b40f463ecfea23b3c291ed508cc7f2ff137cba1a5a028786b97f452773d464034d70fa600bcef8000c57018f248bfe318e4c9a889569491d58aa249a66a25716f09a1395e77229d1c14a94f56f0efbeaf436e98631e20bc7649afaa481cd62daee03f3af120daf2b00000000000000000000000000ffff8c523b3327159685ef9d056c2497dbdbe95e605f09e6b7fb0475051cdca625b53e3f761f20ce7353949e6e433f5cdb9cfca7ea0805699409bbb382053d51256b9622b11bf08e9919088a012f6dd2089625cd550f968418db3aa3aa7ec2c82b9936ea1b64ae3e49a9448ac45bda13c71a8effac4181b4f818da0cee9311c1e93a15787dfef825772300000000000000000000000000ffffad3d1ee74a458700add55a28ef22ec042a2f28e25fb4ef04b3024a7c56ad7eed4aebc736f312d18f355370dfb6a5fec9258f464b227e4d1eaa54b66e968265bdc5c88ce521e5608cb2fd01afbbb769dc2c57794ce684821642ada3253eba9dd86db233fc1a700fa728f474f5a34aa25efb245ea50e885e479abd9c71d32abc11a4e73882221b3f3700000000000000000000000000ffffad3d1ee74a41925d20af1a6d0ccd3890f0aead4a05a59be22e005b6d732f855311915b351a9153b2c83d84611b2c9958f806c93f7b5fa7ad30eadd503811c7f7dac3397e2544669e43d50190f28100e7b321ea2aa4e8eac6c21fa51757af4ed00fa835175f253da89a5b1b5a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff22ff0f144e3782dd9b3523f18f7cb1eb08ada48b7940eaf46aa9ed6cd1d79fe702d5d5689cbb552da3fa27a5f07efcbbb05cae2d5585dae0a3ff4070d41b6e0a13e0bdbd0af040d71c4101d023a6c0acc1b2847b50c93d64060c0d2a5a36778fb175c08d9567c537f7ffe95a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3f21ee554e321266fc3da4ce754a1c26d4f5656a5f9a3217cfdf70d2595c75b5e191041b3224c55a3542248a63a94b0ca059012aa7f66d61b96d1624f7a203d2b698b7ac446cd6cdbbbf01f000645cfc9a7d31dec37de64a6d6fefc0025e3882108240424650097cd4580e99c5d4cafe1844368f515708d3f8664ccf1f0c4644d9a08c3c80bab80c00000000000000000000000000ffff23a165234e1f995d3388b0289eccbaccfb505ebf86c8186507b5fe4b6f137ecdd7769340eda6cf44355b51493e35a722a40809cc42238bd206d0ac79c8f268227cc8308b27da055b239501f0308e1b7599190a2245435455e21d1dab86345f59f7ebd5931c93d96cd6723d3554b945bbff333cff1a0d4d95c848b52e558060fd7b2f2e37dadbfd1a00000000000000000000000000ffff22ff0f144e279470f54b992d3359b3a1deeb973a9ae4dbd0aa139b713448cd04547138f5855dca3065bcc61b1f1ff3390fe040f5833708c2ac3f1a099b745f17800a346a1c4bc920050001f15834be4b99fad17cf5857e8689241deb9f01ae1319d4e30f26fbc2a5a2a67218133ea3f6c6aa4a4c9ffb1927e68b99d93231412190deb9059a72662600000000000000000000000000ffff5fb733924e1f987d8b49e8aca918aead0d50b28fd0f61ed166f28b6365acef6a9aaee144a692f5b3cce00a40719917a042d16d1849b810c42881c057bf486a77dbb2926437523da4adb60111211081e2169c2294e986c881c1ba10a72acdfab62d9c7fed7d7aa1239194475a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3f21ee554e3e8260a3c57731ad90a95499e04802e094e4daad6a2ccd242761c1849342bd8cad744dcc5ebc3301fb9513c30ae82e8923e42fb7cd831ca6d386fbb8f945acf6eb146e2b0b01d19a8662b3614ccdffc199e6956eebce58855abe56cdd3a92d1de03a436a4d585a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3f21ee554e46873c0707fc70cc07e162664bc5bd0d61de2d8f2af0d0bf543c1411bf7a713360435923cfadaabc994de9156cabfd352ec33d99f91bbe4f3701c3684b0960c583a2f07b610111c3e585b5067a6d4cc6fd0690e66f8154d075598186be2bf04a39721ebcea118eebc867becf636c1871a8935b2a1a5e58f11c65dfcb36af325c30d41f00000000000000000000000000ffff5fb73511271414926e7ba179612df5cb1cc4ebbe311cfa9679e41f14ed7b35d12cc33d419073f013bf751be85f2b50e28910df33246349a36b7e56a5229ee2226219e8c4d1395626b92e0131af341643a35547531ab7f33f933b4bfac24661881e129b696516c8149e2ec3fc1d3f3a2e3f3459a2b5ffb6e67830f03ad7f3803bbf7ba5d32887a80c00000000000000000000000000ffff5fb73511271209f87f98c0ad49811131a31e94d875bb6c88f64226727a508094ea8e5f25f8f6cba8d2fb27f0f7e662233c565c1cf114eb3a40e2f4b4ac2cbcce12d71041f31b051d8684015235f5a493f0e83df8e088935262a1acb600073f8dd1e2215421a0f265a999455a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff12ca34aa4e44172cbd28e4bd100792c4455d761c523eacb2fedc49b6b20c67952e2ae5446d11931815254756a37d21d553131ce4a09e13bd7869b809fb31fb781f22948b498568289f0601b287610a92abd2251682e838175d2a742694dd64db25c22e794a3e0642dca689b90fe5000497348c6edb4c1c607ffb22b9ced8d6cf6551dca7c5380f3800000000000000000000000000ffffad3d1ee74a4307ffa44583c9908f4aaca8dd97990c56043e475723f90940ef5fd7d493152540f25f58fb8c965ee5e1be4f850a661476c1ad3af209f75deaeb9216fc8339fd48d376f9b001f22b5b0872698c28c6c5672aa0e62efacaa2664f9a79e49822fb61b7315ef1905a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff12ca34aa4e34071be08369f71e4b4b4e587ff64eeff402dba0e9c6dbecfe3b3f80bcd2bbbb433c01e42191eb0f5e3a95e56d8cb4a085a0d68a5ded90c01f23c7e86acc5deebfdc9fa4cd017480487c2ce567ebf6d3603dbae12a6015ce33e532dee9f0c7a4a9706a27d2f584c09dfa353c83ce072c6a67d2081e80418db10e7dd8260b5acdd5f92400000000000000000000000000ffff5fb73392ea5f95d5badff945693fd24158932b41e311e6fb3cca1e1e551eeed72cddba2e3b04abe86547a265fb7ee958875f9c33134db268e95c7ce631c89b56ffe1c3929423c1750d4b0174495e022ba898fe7753c55fb07ab876d087da453156b8585478d942adf1c47e5a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3432d0354e4181d241a9f83b7dcd577fa215b1b2745cffff34d26290139bfbe30e8884b1e34fad596de7555797429029cda262f3c40625f547a7694aff98b19a7e9d4e344b4c1f7545840154ea82ebdb6b0eff568bf917ad5d0b8334ce294af9ec8268b37385d354714cb25a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff12ca34aa4e4c19c7b27ba7332cf4641137836b3a7ea78b9a53672a28d2ae5a4507dca234e5cf9a64406c98d96f120f3398075a23b0a645092ea3f00922937321d82aeb43f9df3c307dab01d509859a3a70d4f6c9c6430ba5a5c6ecd6f375d05dd1dd02cbbe22350d3b3bfab90fe5000497348c6edb4c1c607ffb22b9ced8d6cf6551dca7c5380f3800000000000000000000000000ffffad3d1ee74a4289e308c9d2d8a3cb35f9d7bb7220b1eca82c952b82111119670dacae18a509628c775287e4e796128cd6379b80dffd7d8d3433cb6b9a1a29fdf07613172bbfdab744889601d5673d1de3c45b85128b7e4e3f36706f7ca7ae424b377ea4693eded49e44c44a5a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3432d0354e4587203a9163f2c3d296dbb8af5d7faec7b1fd204a8b1a5ec29a1c1c420d35dc88dc681b8752dd3fc5337dda715bfbc29aa85be0b3232261a9d146a884a53102964bcf37af01f592d892b27d10896c76bd13221870d9013e7c7a8b13c72e33a393c9c4e857dbf1652828ff41af6e504bb2081165b27cf520ea3381f716bb1a105e261d00000000000000000000000000ffff5fb7351127160dee44e338280a8e534c9e8bea9cb9d73163070d90d511e5c83859c384790e12da189e791404126eb2fe080593ad9a73ef664b6f476a958bcc490d4f170eb0ba926bfbdb01f52a17a6e5325b40485807bbe147bb3fda1aefa770505a71c71d7af3ba63ecd55a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff22ff0f144e3384d8be6b408c129aabee53bac357bddd9eab338cd6cd96333a797d7fdeed36d7dbea5166b67b2cd160d46ac1bea832571aed89d64b9fb55bc49fa788c9b9c743c865505901358b1a766d3e8b71f90d3fe85231f2aa3c6504cbf2be7194d65f3a4517f459d93554b945bbff333cff1a0d4d95c848b52e558060fd7b2f2e37dadbfd1a00000000000000000000000000ffff12ca34aa4e24110e94442ed21e4bd3fe5b2e9726c3df4993fc61a10f1a5f37b6504b5d64b6e02e4f3177a6786876a1b5f756681000091a4b8c06d7f55bf4b036ce47ee75f675a715da4a0135372ba93701b380bd9df59538bdd426d2d995f257e90a63e88179ec87dd43f4f1652828ff41af6e504bb2081165b27cf520ea3381f716bb1a105e261d00000000000000000000000000ffff5fb7351127189809c680a8b7852279f00438526b2d940e65a0e746725adf2bf00ffc054ad2601b9011cf1edbd391426afd1b204d696f73f00a974aec5cfbcc3a34823f5736f0b7c8a4600156446d367c54618b42c90e54dfde45fbd07116dfa21425fa6db009a425bfcd3fc381e621c33b448e2d7bce9d631a2697a91f1916525b99937117daef2200000000000000000000000000ffff8c523b3327128a84f0696ae42026a72b89f066a4a55d3ee12545c672d0de9dfcd62ef63e8e0bd15d8febf1817ce2c76af812dbb9ab9af423ffc0afa8294451b9352ebc5a4ae45c6291bb01168147b72bd50c225608f2cd65ce90cf930c725b95b82e40e279b01b34e0a1c7dd41a1bf278f9d1b78622dca0d9533ab2dc65d71d7225975fadca9fa1f00000000000000000000000000ffff5fb73511271b802913fa3cc02a35fb8e1b26b644f8a2395078818f9bb3be8ad08fc8cb175f16c43e2b0aa2fc12a7f8dda3914946f702ce357534f97142aa704c8be0924950a7873b557501d6410cd8bb11cba290e20c9b183f0739cb630628994b66aa72c40b32ac38e2085a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3432d0354e3d10c0a1cc322597069f80ea22c04c4e5a442fff97ae4ec952a91eff9d8d9787760f20a227b1ada2025a6e9d74146e446752966d0882633324adcd18d1c4d9dd741e141e8e01b607b7d015fa271ccae5740685b3fea4be2b856da2e4f06838ed23038638873a84c09dfa353c83ce072c6a67d2081e80418db10e7dd8260b5acdd5f92400000000000000000000000000ffff5fb73392ea608851d988149766aaaafca285ded50de031ce42036033e3239f4f903abda26740ba235e22d26a693136a5ac27555f3de88c166622c0a0b8dcd8e5e70b630ce52a06b2e1ab01f92e1162ab0190dc924727897bf4d27eca18a3ebde01c67e2fb82c9205452f8decd2cf880d6b648eca3984400156eeed9443f809d23488d4b7ffbe621600000000000000000000000000ffff5fb73511271a8c01a1351c0f42892d6b68c106ba584f91dcc2869f384830c968688d09becfd0f7468e7ac7f02983724a6e95a887a1483cfbfddad5b5ad0644feead52e00560717eba6e9013987a05e9b1fb72cd13eb1ff70a20ea8fe5835e6f9ecacab48e0538c77b0a75a8eebc867becf636c1871a8935b2a1a5e58f11c65dfcb36af325c30d41f00000000000000000000000000ffff5fb735112713940c2271fbfbe83cd9dadaf03da32e840466cd4eb0e358749d5f22da2ca22610c6cdcb664b1c082b84cd4516d73ce5d56be7a3a831cac698f630a281ad80e7e343aced960159c38b8d6a0664411f92a6326e8ef0707ecf185405252854ddb477d89127a32d3554b945bbff333cff1a0d4d95c848b52e558060fd7b2f2e37dadbfd1a00000000000000000000000000ffffad3d1ee74a4b932f6fc90c9dcaacdf9d836a2a7e60d090fe5e55b0b02f5a4f608a4b8235ba5aa7abc4e05f9387d1d942adc57c87f5b7c9fe0e7daab67759c331e39d4b9c05174e852f0701fa18d6f63ae9d791cd65d7cc1cc646bfcbb8706e2a6357364d5d58ea7696eaf65a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff22ff0f144e3b18c60c196da02ae838b5cdddff0b84ffeaa5c72e2fae933d3a173914695f9d3f2f13a12567cf8a6445e1fd2472aad3a05f2dc45127038c872951c469596ae2f1b600437c01ba5136a927bdf3b74c279b277b3fb5dfcbf7773475cd770758c071ed882f186e5a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff12ca34aa4e2c95758d8a2466f990857e8d1db8761463d8537f3c2cc59b94db7017e6d51f47075657c5ea8d1f801c9c71b34f3cf8b57bd1c5eea17a8f6a3f8d7155e76ae9581f6e518831015a5a77fa5422d4fd9fd45a991fd186106c6e0fa4cd151051067ab2a8624aff0b5a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3432d0354e35919f8cf51ccd17f119db6f0bac1a37ad10e0b634c1a0cb76fab44b881fde5170247695275f0e7c10286fe58fff4a97ce2d3a1f4839a73715992e9c4ac586fad7eeab356a01ba26fb851daf4a571f2e58a0ee53443f99907fc0e5f3ec422820148d39d110525a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff22ff0f144e4783bb6205d6d010166f99a1f6f671492210caceb92271b1ea21695f8831545f0f51a80beb06b054b558aca09e49e1b1d172d83737bf5ebc4ef9578ee806f253eec6c655e2011a3f5ec38a74ee8799405e7aad8bf265244f1e9d4226fb1099f6431a4a6170b478ef8076c76fd5eb17b5fb8f748bb04202f26efb7fba6840092acde00a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000227283c70c84ccd7853235d8e58496e23b0846b4009bdc261b20c6697097a0693ccc5d8e08342196ceee3c67b2f3f703af03638cc98eebc867becf636c1871a8935b2a1a5e58f11c65dfcb36af325c30d41f00000000000000000000000000ffff5fb7351127158a209b5083c2b601ea18a04f0e92ee5befecf765486deb9643dc3b3fd193080c2659bba166f3873364964d5e8f7e4b9344ba46c120c527424de6a08ce3ce2b7c9dc81083011baf6cc0d348c45bd7826fd085fa3a0bdcfa7441542bc94396e131da11e91dea3554b945bbff333cff1a0d4d95c848b52e558060fd7b2f2e37dadbfd1a00000000000000000000000000ffff12ca34aa4e2800381a3116667c251265178d35698c8a7c801a9765714c793d2dc03fbba5e9bcc9899a3b8fbbce3f07be22a36d0a4448fdc40895465e75cab40053a076bd3ea0a20c1194015bf7a008043994cdb799392bda7b5bbbd714ac2c9b2846a3ac7589be18ad357d5a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff22ff0f144e4b0872f496d7ca93e1e7e0e2aafac36c5a45e86b0780de1a8c5ec665343e7204538f116c5a4ace4fa9cec823ebb8f04af14dd387f5bcec1e45ee7dc221baae1095411402aa019c8dc7c74d6b97310a44dfd37ae62492c2a615bb660ede1e2adac449c52398b25a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff22ff0f144e3f1243421c72eb76a1d3058de901007b28211ca225466fd7fb046ecc0fbedb3d8ff59c144a46f720712e4525dae6bed584b600745efd3dc74652cfc4f9c6d99f9ccadf0350019c4e2fe4c34ab54bcdbf5fb8d3305e4e2c1499b789ef7bc90ec106ed62f236813554b945bbff333cff1a0d4d95c848b52e558060fd7b2f2e37dadbfd1a00000000000000000000000000ffff3f21ee554e22902c12f4e752167465dfaa1cb88b45878c3602a0543bfb36be2ace7bd9725f7c4fd76446dabe9948f251adb808ac3ad42dff4926d431871ca8f78fb6b623c0e9ed113e7e01dc670576c36fd5a92e8e580ab4f898a228d6f9f66b19fcb3df185b66870577fb5a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff12ca34aa4e4880f5458a1d7ae69cb8dbc6b7d69ac112e008bf34a985eb86cd973824023d8705cd02e2392f3c7682c3a9fac2a6c4ef48438f76f99f51d8f671f6872302cb9728e12cd7f1017db41143e8d6e3ca290a69a44797ee967e02f4297186fec08a8a0272f864369d3554b945bbff333cff1a0d4d95c848b52e558060fd7b2f2e37dadbfd1a00000000000000000000000000ffffad3d1ee74a4a862599b105fae8d252fef9707d02988e9f302ce6ffa7d1566908979816af6752e1470dab2f6bbed45ca65e64e4b74a3fec4308c6a9bb3109cf662b0f427cb183bc70f93e011d09e6c4660596a0cb7a714a044d41f208b514ee79147f9d73d5bcec839f4f9f83f4a966a456d795192b83bd2c866dbefee9dc9435dc3fdb42882e1c2c00000000000000000000000000ffff2d20d39b4e1f08e37b3fcba972fe0c2c0ea15f8285c8bfb262ad4d8a6741a530154f1abc4edd367a22abd0cb1934647f033913cca58aa2dbf2c2b6149412562f306841959b9cac234b73013de971af0ebc17861419d05f0250c7f4f073d444df1404914c5afe0afd65ffb45a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3432d0354e318cbd9ea64deb7cdff20eb3895473799d89c6cd11b5929934bcf5e28b04961be6398f4030f66ba12c13d1b749dcbfc4d361a091feea151cb4c9aff33d0c35b73226dc8a7f017d1ae31c1be20466c400285a293f88badafaad90fa8bc5b77d8da36631cf4e71677e5cc06119499c3f65458f202ed9ef3ce17d98ade4a6574fce0a653200000000000000000000000000ffff365b82aa4e1f08a37fd91db686b551ab91b86ab073c2c44e1d0bab4f99c1edfbc2b12abafd1e9a96715afd16173ab749db890276929ff1b9b7fc7bcfd49a904edeb77cafc68844897e91011dfbc526d3abe5490752532a2f305df97432c482c0404fd236f8bf8f0e4cc6555a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff3f21ee554e2a9625089978a7d330992669359de9168b481fa76ca0725ce4f55bd7561618109c9a8035f608723f68458ebeff4dba5eade27f552b67828b408a673ac6e30c11a054f25ba201bd27495194b6933f075412be4c301511eea1e0f75c1d8e3274cf89941a63f3b6dd41a1bf278f9d1b78622dca0d9533ab2dc65d71d7225975fadca9fa1f00000000000000000000000000ffff332650224e1f820710bf028cf0f81d0e8115f0654dffcdd83e598ddfdfd91bac653dbc534a3177844fe8c87e991727d581bcf775432e73787fcf2171e8644ea78cfcde314393bc66bdb0011f21e71597ffa891c91c1f24c4aa7925cef68f86ae9603c13b2b018e05651fae6cd6b4af357f054a9b9ae6257b20c9936034256118e06a3048c68f934c00000000000000000000000000ffff6deb45144e1f84175e1361b4f718341f496e3ad40644a99c292f184f7bf31ab2a711c6d3b63ad14fe4df227974fee5a8d4ba45fcf52118cd93dfee4f5f9aa9563d595f3fb4cf0f2cd8db00bfddb9d5eb05ffc2fa5573d09549f23ea9e1cd7ecb650f3eb16ea0f95cade5320c30771d54f702cdcc27c59ed99b19a36f0fae289fe666a5c51e43601900000000000000000000000000ffff5fb733929c3f1326ddac1044e0219dba7dccf6b43d1deed3e897717ca06757243b02516cfa67e24026f7a317cf575b40c10e7f6bf7f087da2642cf967c493f126137d4f15e9de36b97680100140100010016067cae80c66fcd79e3d7369c2c05cc331fdb23849f5f6b026f331800000032ffffffffffff0332ffffffffffff038b5797f440953049cfc28b8997f8029c8ccc2c5390f7dfc9621d70d62cd124a18ff35b0436ba341d3999789ecb80acbb4c82324321a47e9c54c3d7a3b5fa89d0ab2596ba0292c505c1652b1d0df1d4c386f63205f2514d79f9df488825466292f2891e6eb448c4b98d23641950f5d51e440b88c0d4ed729c8adc2153ba5f3000084cdc67672e8481f9dae91087962d3548b1fe6637d0818f8af92fc3078aafaa23fe1addc55792baf105309bdd83693886567104f9fb4f7f7842c2d2fd66b1cf9b56a7bfb73aa249577bae0b167ea0706d2d8aad39c474fac3583d142e475862052f9fcc787fa7b0e1f742e78b0f3af2eb03d0da35a9e779e874a2300748be8b1fb950ed420a431add47b8dee71522ab0100010d5fd66e2d6fe70070f26c97da9676e42030c9cb2609e940cc4e9a632b00000032ffffffffffff0332ffffffffffff03127e84f6dce16b9993e9e1fcdd1fd929439a0417054b6e9825b369686b46d1e8a1854ab3b59458a726e5ccca319974e501fe750a7ffb9ac53490259ed45c6f3461e4139d0e79914f1a507bc5f2c7c1b00c993b32d888cc9829dfad1ac3d28602d94a4a86f3948752c355bb2e22a0920adbe2e495e5a0f28bed7bd821b0084c71021318f4b1c67777fcf05be298b958491dc35ec8862c8f0a4a2432c692805d7537a2c4de235bc9a60ec023b19f8098f197b23e492b16786be48e9de07f27db7a3168586731fbe16869dfba161ee7d58319decd332aabe15f3a98a15e96a0ecc612ed28ed5989721782fa0bdd0805df641d5f183fe507837e231b084be31e0dcec22bf0770b59fda2951dd3fe0a0028830100011ad979c3e8c249280ccbd9893804a1cc2e80da531cfb2e4ca85b2a2bd901000032ffffffdeefff0332ffffffdeefff03891ef13657c4f57c58c7fd3feb07aac1dc3a48f9d6307f6cdafa09e80cb11bf509f885b41d4658fea42a2b9453d9cc172d2c738998926560e57fb1cd36964e963ee890b486c0ca689331479add7c9c5599c41918d81dc2a3fcbf11d3a37c31daf5c80beac4461186073b506bb56c33625b7303b782c8fae4c15fab7a0d81747d05becd9a50616593a917fb7f3dfd95c6eedce2d11a0bf1bdb40ea8561d70306f15c5b470119897840140a84297ad6ffe872ab0af8d7a02166075aac803764270dd8d324ac5aaa2908e554c8e0eccec5a1a2a2917937b9d8aa165dea12a3942cd16936d7d7d669956d1f7236fcc5b0e1b917eceb4f756e0594d598b223e52bb47f20a54c482a808a09090388ee37633990100011c9088e1db454f6301578a039bf44771a019117393012fa9d20133630000000032fffffeff3f7f0132fffffeff3f7f018fe597eb15a77d4369ac8be0cf2268644a0017c874b3c110ef94ad3df1829a31ac61bd9664cca4cf3405cdf008c660ec816a615c7539760b2f2ffee0fa522c2465ebfc4cda2822ec7aa5c7f020c13a97872c73566f9b2dd5aa6db7d5074579c020bdc422f68b7c85f1245a7782a5190e818315c635b7fcec7cf60374059515d70411b38ccde499b0e086f490337f8a8782021bfe72968aead0e5905525dd351ec6ff8c29d2cf2f307aac7471f25f5aca0f2e616daf78d72f15daee4bc3ccae2c7a934357f51c0f7669dddf6a3d50d89a4e53ed2c6a5a0b8e80edd922476a9151175106ec3612e0452fab85acc92a41e24fa5fc70e7693e57814a16183aee440f5244bf2393afc60dc6ec9e33c4c5329b0100011cc40a9169c62568dc56ca7c4c217defeedba53f74382684b59c3e6f0800000032ffff7ffeffff0332ffff7ffeffff0317efdd8de51ea29ded58de3a1fddff3bc8ef0f84734183969caec6c5aa7914be781ddc6024814caabef0ba8c26393a765233a109b0d2694bd08167e7a3ee2d70dc97059b9234abf51bd666499849907008b0d5f4ba9fad45049a74265e8d132d4649a1fbcbca489577ad7b579450ada9d53bf6605ff9bf9c917e5853e68ebe160f522cecfdcb5e8f560c7c17d8a1a0c921e667c46ebbe546db188d68e4e673e8d83525a9c0801b4e02b8b4be25bc121a02eb276724a91959eb02328ed066d7f716c01d2b80c95d12a02f93c2f3863544383179a3d65f47219d7fd67f40a91dd8107be89b3d8e593bdffe4dbefd965be2f34e16b4ae7f34033d4dc4c294646b09acf3df19884f81a3d8d433455ae9b14901000126d49bec6c7d1cdbf13949bd09e3317744e8efe9cda31185220d516c0000000032ffcbdffffeff0332ffcbdffffeff0398b95c5520c49148a37cc1f355ef4b3d6fb88b40c2c321f63fac75026128c87db7e098057e006c9df800676551907befd77832687348369ca5de677e0cd8cc01aa9c2f4f516767ae910816bccc19789f96b22817c4fe311c722919733ce244587186cbb674b4608412d7758d76d49f205d46421ce0d1eda65de202d0953888bd002d199b3f6a4968cd70ef1972310a515e67354c3a1904086e1990a4fb34798c304b01d1b173f45731fe2642b688fbad8a483c95e129c10388adc0feb9e5d8d34bf3ca1722efa2ec4b3f274a739d506a667c69dd00a46ac02c87567715cb159816af26d380ad85ee71cd741ff6e6a4845a0c75d5d13e46e7627e5beebb3173a1ad8b34f9d95a79588bc6d2777776ff4d01000134cb4f87e0427bc84210cd21cebc74353ee9bf9c32ebf8e214b7cde11700000032ffffffffffff0332ffffffffffff0394cc36d651ee5dfb39d53b71fe19cac355b63db5380c0120194d558b99d9fc3b2a8bdfda07aaf99e960f669ddc2a205f17bb44c61bd703188193c288c6dd72d90683a4a1cc280254b04708fa7f269795890f5162cbd5b6e7c33499f45e2cd140ed803b62cec9417b98c9f34e3552f50881fa0beae004fd0bf69fc2d7b5ea1cdd197a871f3d93a867d02ab7aa364fcf05f6d2e814ca66a76618c852df11085a24233e05d8207f9913d374475391c11d92917c608e9e1766b554854a4ed86b6ef9380277e8f30a6022282460bafcc21485b48b463838daedad96bb75b0884cff7708ba7cbb0f856fc37a6e8d67b72ca9f6a94b327609174ed1e6133952ac83ce4f1e421b5518ad5d141cbcd9634242e8d901000141d41a4b3ffe1aae316c357495b99a711b37436f2357d0cc25b7b3ec0800000032ffffffffffff0332ffffffffffff0399f4968fadbee9f34c921606012949dd0d573f494ba2d110b8107b797f04cb17bd81bbafa8277d256668777420e21b84e98e56fcb32d84365d962785e3901d47a204f76020abfab3de700f79c87c6dde94606c790182f70426af56b8470f0e919bc3e5bc68e85e01e68da26755234ce22883061cbd27e6ba71471d37152b99e905b38caa068833bd5c26c38229ba35e27903c28f3081e3f417ab578186bd5054aa695524707c530aea9a04190683be6412ed831436eb7e881f291fd8d67c102e0d273e726bcbd3cb862485a308570d2ef83cd35583ab88eee8255eef16d87e2f037c3b16ef8b9ca2523b45d1b282eb71cbb22619e41ac45f2e26671bd30cd2499ea8f171aef35ea808d56edc573aeb40010001679c4997606fcbeb78fc6dea5535a622fdfeb27aad1f0cd957ef5d752800000032ffffffffffff0332ffffffffffff03839df8ee86852cada6a498b618a06f24fa65a9b342cbf3613ddb570af0ead8def105bf003c220427353a9d417d5749ed64e453954dcc0c744fb3b5fd75c291d3e6f5771ab4ac6754dcb78d4bc58a730990cfc24e60e45157a16dfdb6dcf2945f92998d0fa2f3743b878885236692926a207a81e40ded33e0ce07ee96002376210ddc1b0ea397acc73a436f69f297ab03a6a923f3afca4eaf277cbeaa5bfeafaac507442a1b09b853d7e4239cf81380b50752bb15308ae784b48bf5394a2e8edf5829dc96c85aa519cc9ab4443ddd8c346ba74cd5139877ff752b7d3c05b8845e0ac95f3fc8f8cda08653d544b4f7455ed041cd005a687e73a45a9d71abd8fe91984178cff74b549bfaa20ed99c0916cc0100017d6aa5e197437547309c89d6da87721d1c38419e44a4f2c29abb98cf0b00000032ffffffffffff0332ffffffffffff03109e366d0e90d1a2f3a49a989df4f89396d2568eb5ca949c8c14f100a1a02dfb76a99fb2260ab30bd2f285b019d81418c9284ff1a5cf009f0b5b92053d44c2d3757c92d8e49bce2f8dab398f5564f7a30cbde83aec89ee9e655d1c4f5816c24a7fbd5134698257acbbbdbe2cac4cc003bc627d7dbfe07b9f082c882e0b22933303cdfd5d130d9da54f2f665306bbd5b5d58b9cf2e4053a412f299afda042d477a0b1a10b734e9759676b3019195f1063027d9ebdd76c3fdf516b29771f652d4055a883aa7e95a50eb5d6cfa04def3f2f2d57c27cb1e062eb063f9da0581bf1af0f65bea01977b2797e7764aed1349a354c49d80b8231fb201951c9df3a2507dccd066ed62aa6800d0e42e1ff250b85cb010001817519671ce9111fc37d0aafbd295ded77c5076492255361f0cf65101a00000032ffffffffffff0332ffffffffffff03901afc1e7456c20cc0337f1719a95bd81e748f48d654136818f5ed96a4cbc69cb6f4ab6cf84d8d931a80381ae1b4ab8ae8621b72234d1357d0a0a1f635d74009c0feafa7beae02133412e2871204ea98993910df8aa45883c3383c5a25b53cde5a4dde7f2c60bc6741d49ffb24501dc24f0ae5c293b3e3cc51e7a18c62377e7504131f263b6f592ef04c73ebf6c8b9d8f4408920284c510d99e4748d0e58e7f91c7570d31c491cd5c41786f6ca8fba6e97570b5c949b02753f257a957e53812050b5340440605add4ddf7d67893b7a35d199c712c7525d93e1c75279b47b0cb516146ccebd138b3a84fbd83b5fcc026e2b57f8ef2824246a6e6562624b150674d41e723a9ad23ee08e0a1f07d6562d8001000185611453d8c4e27360b689c62c18eaa0b95addb97db342246659187b0000000032ff7fffffbdff0332ff7fffffbdff0382234d2c2792368e972497afa4ed4f28df80efcf44cc76a019166bd3ec7f05f44eb5c53599f03305766b24a20a81391f86f42d79585f94c72a793b2ae969439a137ac39123b1cd72bf5b661d8707f598847d55ed1d11e37dbc564f6eafdafd5345134ffcd062cdf50c018b8c11920b34f872f74ac9d4d1d32f50e5e2730180c009be27c5e69461f29c1a0027fcbb3bd271111042872dec255413ac5dd9e1aaa6280d26bfb59f6936d84fd53f13f11b9d86d13e84e7c62e50b04fd6fc8952676abdaa499982a8764ea25363dd663a9307d9062b3232c6068c071e3ed5c34b0c1f0a0a6ff477be7f0e0efde09ec2c8b1b428fa5fe9579fe9eebf0ebeb1271d775d94deb5795be8bbad95d2001e51c422550100018d80561839648b844ade10b6e81069fa6c4bde6166dd59242be3487a0000000032ff7effffbebe0232ff7effffbebe0281d0717b893b557f54daacbd060bcffa2dc341175d0b89c7974dc57ef482ae27e10fb273eda534596993999950817cd4ed93bc215d15350bd7030be811cf1df2c114f6b34df9bd4095161af93608ed908d2bbb0b9c5b8626eb852ea0ff4f250919becc2d24653910fb8e11cf5573062f9f64c03a5031f1d462163ce98e8bf78a1470f7074a8e6fe23ccb53d73635ecd5ad71b26a938fc21638bcae7d272af9fa919f296a17e77191e3d4c708bc6e1b9a19e702ff84ff851312cceba1de528ee7ffe33647ae28ef895b35558512901394b430c804c7c42494a3312545606b55980480985494fa2c49f50c65d47570380f13c2851ce33d8584b64e8b659146d73267d821c78d09ba7caea3d03641f78c7a010001a148569984bf8f51d4a5f8e266744de7bc1e67897acb3ef6c16b98970900000032ffffffffffff0332ffffffffffff0316417bc1f47689eedcd10713c5b7754f75b97d538a55903f38e875227d711540c4876ca40b0f6f8cd2ad696a598031e50d53200d013f10415494b769218df8f33e0f9abced9ecd98a43b763de9c123f492fba8b76634ce3935a53a60c8e69100f3e66a80c3682fbae220260879c9ad67fc4d55e37cfda4b9f657e6cdacc6eae60ce5333712079938afdb6c82fb8a7f10d088dcfd34bba435cb76ac5d6710e328d037eeee8d1e042d63c2c53220da1b7c8d87f0bb7f55cbf3e0b1e90cf189e7394aa1ea2dff09d8358c83483663b356d9d68dbabab26561aed07d4669afdba7660c990b3d8954d34e40d7e2351115076fbc7c06fddd7c281296216097c1d77d4f92d28ade6032c67ed3d54b0ff2e147e2010001c1ab5b8d04affb2003750e0c06028f8b1eda3901ea54c9dc6111f2ee0a00000032ffffffffffff0332ffffffffffff0389f4c49dc5c223547163a793755687a6a25d1a8e9908c3cd040764fba24debd6de22f44b251fcd193ebe0e50284169e34260679dd6c451db091e6fd585de1afcb6fbb8e3e763fae2fc7a586969fe075618ab0bb240c29b88b69d984ce7f7700e58e333ae5f8110b439a45fd7ade36e9bf7c624c60931c0b4c889ebef943fe1bb08a9170919386c16a5108c0e35ba75048b7b0d2ecd6be9d9ff09cc8d2bee218c7a0345b35bd6148eb6844cc81008972d0acb1c0e79cee9062df3933a64179bf7d5f0e5c8049e9ab4e00c764da6b53bfa3351128023983dc6854f5ae1b3e0a4ba19dfb7c8e0cf0bac6b769e3d6fbbc734dbda2eded4dd0478d3c83e2bd886c3a0cf19b4515a5643fd72fce5027f777cdd010001d1fb1815f0a3188ad342380434eec3c28433ad3c3f1245de0056d01e5500000032ffffffffffff0332ffffffffffff0386802a52812933d4e0417793ced1f9f4e1c578ce4cd5e69e03d752550e30dc31228e38f1e32926ee5696d1ff6f319b36f6b13681a4a22670b01b29abb5e1303e7fd023b18a0823117af27ab24b0b4b7396c23addb7b3eb5a0a178be4b8ff0a6495e6c581bd54abedd0d7e57d3f871c39a1eeef02c8357536e01e616586a83e5304ae7b8d8a463d5fca20dd6ab7230398305dc145db3c414df218793b895ca4e4a93a1491aa7960cedba0a8d29cf254b487b14d095e03ce7be0b492fa0768b91654fd01006bdb6d1088bc3562bd704f70c7392539c2ced02c9b3375c86cd872ed0d89444483fc319bbc641ad2299b2a54ed2939734c16fff0c294dae280c05ec3785ff83eda3334fd54a357813b62c89a010001d4540de9899d1c4cf42c8e8cc6aa82d26b380f1eece4d3c98c0884690000000032fffff7fefffd0332fffff7fefffd0393b58ee38247653ad05f53cc90e86d7e93ea0a4f6b6a398f581ab122ddaf0bb7b4c28564a176545199eb72086411671cc5bd4205e47bb63d0f51746e83264859537b226b5bf3a909b41063b442e070cd867492fd032678317be0dad23e0e9ccb02c5340e1ca7ac0bb235c180059f1d1ee5464f996a0afdf98d78ab9c6b8f2bcf0051258101437c9a5b308c739b8c4fa453256ad860b46486fd1d3f5221bb33080f0e48d9f363e6140d1d41ecf6c0765b817f26fa6ecf210f9ff12389b5fadfc09a0b78da45d3cab0c7be29417b879a52158ee616e78c24e60368c9dd0ced616505f173ea8af4590e1a2fdcb2b365cb1f1aa59c3ed279af315d6cc10f759c4d602289c53789e8596278ebb6c778cb6e64010001e5ce43fe4705032af4a50bf3a5764a4f397d0d394f4b78fddf522bed0000000032dffbff9edfff0332dffbff9edfff03089ea9aaf700dfd7bc3ac551308d6a2e42a7988bc1b86b66786867594f364852a06c9cd38a31bb193cd40f5cfc3a91d2d7b5e991fc4039e9ea9fe063a4709c01f040a3a11fbfd3d17b5868af3eafb2898fd1d17c19a858f8db26cdcfd71e5bbe1a729e199f3fa489bee2334301357c2c6d89a8c29da071d065322b7739ae5915076ab217df1e2633aabb5d890b01f455a72f6cf5f8d5aba0e3be21af98bf36a2768d332701a3f1c24f6a01aaeafd3d9895a2fc5bbf3cade14e0e6c17def74846206bcc8b84fabe058f3190c9de14cfbb4b3f2232a28058c97d1b0ecaab458c1a0ca668d0d8cfa16a3358a760a43bad3d11ea28e337d21bc0691e98b41a6083316cceef5805bca00238afe2995d4c2f35010001eb34572e6b6c6596a89f11e3c7bd9f35c75987d7e3f25842a4b988a82e00000032ff7fffffffff0332ff7fffffffff031044eca68f0e6055355745555ea2338a9405290308add438931bcba80737f7ae3c6d2dfcfb0ca1472882e3a5c3dbfbf081221215915acec7ed705e3fe9f2135357c8bf074b0aa10b40964ac751f878c38ea28c44d80e62c5632e9161dd383c48d81095def4cffb8b5ed28d5a863801950d7ef589d6e39390ade9afebd4a6a4e506413904bdd8aeadede5aa385930b1fa3ae0527e8c576765a74b1c7ec95af77ccfe5d7183ca0c579d2bf57de438f6c32868e3b5bc07e172427f7151237ba60d8c505957239cecb59bd4dec034638be4e7dfd79a197ae651d0fa7e3a7eb82eb1f0db7e2cef5a092a19c0cf6e6c92d812b3df8b9e2b8f603054c3fde9b0f8f0e063179e1bc898a9720e3fc9fac77037ddb010001f180157efc2d6264291268be978288948e2407faa8482fc56699f90c0800000032fffff7ffffff0332fffff7ffffff030454e350d96050bc3438bd2cb4ba043f166e65f38faf2d8c38d1c70ce19dd7c505ff2d2145357a40b9c434052bf4943270eec32a5d77c70b62b64d1438032e28ed48cd18ddb515ffcf40be44092dc10d02116c58b65aee901fbc919c18ac2a73675dd894618684c26d394261b29423ba7443c10d3a1fd2a7c68489791daebab1138a94417b1bb36eb32cff0883bb4b5a9dee7b8925575b6272b81017a8e7fa309d54905a91cd10221e113f501f2e1a6887595105ef6f1aaaa09c468992a874016e2b9689dcf49b3723d7b370ffe2ea760c20644c7f9d34d04eb1193c850b938b1386cb0ff2074ab72d5b9e6282efdcd7121637943f200fc68e35d4f6aff660b0c446040611f76e20b578f3ba4f05b2b0";

    NSArray *verifyStringHashes = @[
        @"2dca894a2b5af0bf82abf0cfba978555f41a669278b6e91ca14c0593beaf2200",
        @"63cd3bf06404d78f80163afeb4b13e187dc1c1d04997ef04f1a2ecb3166dd004",
        @"c551d5597cc4f8ab6921af4f896ab68e6e71d15bfa8a1bec00769f6894157f07",
        @"d6410cd8bb11cba290e20c9b183f0739cb630628994b66aa72c40b32ac38e208",
        @"5a5a77fa5422d4fd9fd45a991fd186106c6e0fa4cd151051067ab2a8624aff0b",
        @"2cae9e9e4e356b719de38866f5a4b3727728a2a3d6a00a5f44075a015d0f9a0d",
        @"f000645cfc9a7d31dec37de64a6d6fefc0025e3882108240424650097cd4580e",
        @"11c3e585b5067a6d4cc6fd0690e66f8154d075598186be2bf04a39721ebcea11",
        @"8de9f50be6536ed7f22ecd23bb19447387dca77f2d67024a97ce394d0d538b16",
        @"90f28100e7b321ea2aa4e8eac6c21fa51757af4ed00fa835175f253da89a5b1b",
        @"20ba3f10dc821c8a929aeb9a32e98339fc2f7a3d64b705129777c9a39780a01e",
        @"e3845dbdaf3aac0f0f1997815ad9084c97f7d5788355a5d3ed2971f98dde1c21",
        @"8bc18fff3bc302051c51b545677173c459ae62e7cde27b31aa843193d870eb25",
        @"41e985aec00b41aac2d42a5c2cca1fd333fb42dea7465930666df9179e341d2b",
        @"59c38b8d6a0664411f92a6326e8ef0707ecf185405252854ddb477d89127a32d",
        @"2507422a27822ce0fafa7847828eced46309ff30968980ab12d74d8c75150730",
        @"bfddb9d5eb05ffc2fa5573d09549f23ea9e1cd7ecb650f3eb16ea0f95cade532",
        @"a1d700ddb67ae80c1cb4fdb76dac6484dc1dc2741334ad5e48f78fd08713a134",
        @"67964c4cdb2589996ddf706e1141b14c8bd3f293a3a9020dc6ece012a0582739",
        @"b607b7d015fa271ccae5740685b3fea4be2b856da2e4f06838ed23038638873a",
        @"4acaabcb7ee31149510138a0b11b087cc5a2ff0a24225bd52b52e1c2c58a113d",
        @"f0308e1b7599190a2245435455e21d1dab86345f59f7ebd5931c93d96cd6723d",
        @"6a59f9b585d75f1b2cb43b7c0fb90a294fa45e0c1f7a432f82139a3ddfbecd3e",
        @"56446d367c54618b42c90e54dfde45fbd07116dfa21425fa6db009a425bfcd3f",
        @"8167aa267eb42b78d112b3600358ea7679328be8ceecec2cd68148985b665440",
        @"862677231ca31abd98e260e0678fe63d8580bf7a142a1afa68542aa718540943",
        @"5235f5a493f0e83df8e088935262a1acb600073f8dd1e2215421a0f265a99945",
        @"11211081e2169c2294e986c881c1ba10a72acdfab62d9c7fed7d7aa123919447",
        @"d5673d1de3c45b85128b7e4e3f36706f7ca7ae424b377ea4693eded49e44c44a",
        @"ba26fb851daf4a571f2e58a0ee53443f99907fc0e5f3ec422820148d39d11052",
        @"1dfbc526d3abe5490752532a2f305df97432c482c0404fd236f8bf8f0e4cc655",
        @"a9d8b58154cbc573203f183f012ed3c037f6ca26a8c2c05c85551d8382ef7256",
        @"d19a8662b3614ccdffc199e6956eebce58855abe56cdd3a92d1de03a436a4d58",
        @"3987a05e9b1fb72cd13eb1ff70a20ea8fe5835e6f9ecacab48e0538c77b0a75a",
        @"0dbde78360328a8ed44b5620aafd17dc85fdd76609b8dbb8e3e04964d02dd35b",
        @"a49e8534a2d427ef3a94d3ddaf2b05702e87e99d148739e949b64a7c1ebf695f",
        @"0c67b8d2c4ab23820d89d82cb5f841b3b3734edda30f10aaa2c2bfe53a4c9664",
        @"045480c439ccaf9f38afff4a07e8a212735cdea7e7e8f2511c0883e2583e2b68",
        @"ba5136a927bdf3b74c279b277b3fb5dfcbf7773475cd770758c071ed882f186e",
        @"7d1ae31c1be20466c400285a293f88badafaad90fa8bc5b77d8da36631cf4e71",
        @"28f89142530ec3f0832aba5d71d14ac1ff284cfb8c7ac1b59df6c5c41750cf71",
        @"f15834be4b99fad17cf5857e8689241deb9f01ae1319d4e30f26fbc2a5a2a672",
        @"a01b70e913df11ee62bc4d21eeeea6a540fa5c2cf975952c728be8eed0962373",
        @"afbbb769dc2c57794ce684821642ada3253eba9dd86db233fc1a700fa728f474",
        @"461dc135037403e79929e97099d82532e48cc3f877f8d243bda0673cc7319875",
        @"8b3ba1e49dd244741546eb6f2a68c82d4990c55999bf385a070d27cc7534c478",
        @"0ed18ce6df1e9a7a957852f65486a0eb17c70b8d51a24faf4a0a2e047100bb7b",
        @"8a3e98538662189dfebf2af3e9d22950256af8da8508d69ddbe4b247e846377c",
        @"40befe806aca699fddfebe35a1edaede5bf3c33442cbd4a338db99ccb9f5717c",
        @"5bf7a008043994cdb799392bda7b5bbbd714ac2c9b2846a3ac7589be18ad357d",
        @"74495e022ba898fe7753c55fb07ab876d087da453156b8585478d942adf1c47e",
        @"9c4e2fe4c34ab54bcdbf5fb8d3305e4e2c1499b789ef7bc90ec106ed62f23681",
        @"27847c25d2cde5ff46975adea87a4c6822f573ee66ac940d16ae205d9f6e8883",
        @"4172e5a561e36ae49358bc4c6c37ff688f54a05ae8842b496b86feb71f06b886",
        @"b287610a92abd2251682e838175d2a742694dd64db25c22e794a3e0642dca689",
        @"0106207e0dbdce8e18a97328eb9e2de99c87477cd0b2ad1b34b4231327fea08b",
        @"ee4ad05d852e40c676005d0d1830e45259b1c8b778e61d1b40a3758013f2988c",
        @"f92e1162ab0190dc924727897bf4d27eca18a3ebde01c67e2fb82c9205452f8d",
        @"ae4a298a414e8a8470e8c5b911a3c6f9200a806fa1dac65bf0e317c32ebcec8e",
        @"f22b5b0872698c28c6c5672aa0e62efacaa2664f9a79e49822fb61b7315ef190",
        @"8f248bfe318e4c9a889569491d58aa249a66a25716f09a1395e77229d1c14a94",
        @"ca485207dc1a501f9a694d7cd0f007846c40e7af8d148116c647923cdf7b9d99",
        @"7db41143e8d6e3ca290a69a44797ee967e02f4297186fec08a8a0272f864369d",
        @"fe85d7358334177035e982db8388fd37b752325df17a53717b78e2b0c91b299f",
        @"1d09e6c4660596a0cb7a714a044d41f208b514ee79147f9d73d5bcec839f4f9f",
        @"42911ec289c2b1559009f988cbfa48a36f606c0aa37c4c6e6b536ab0a9d9eca1",
        @"21958ba1693c76e70a81c354111cc48a50579587329978c563e2e5655991a2a3",
        @"1f21e71597ffa891c91c1f24c4aa7925cef68f86ae9603c13b2b018e05651fae",
        @"83ba23283a9b9dfda9cda5c3ee7e16881425506e976d60a39876a46ce82f38af",
        @"54ea82ebdb6b0eff568bf917ad5d0b8334ce294af9ec8268b37385d354714cb2",
        @"9c8dc7c74d6b97310a44dfd37ae62492c2a615bb660ede1e2adac449c52398b2",
        @"1a3f5ec38a74ee8799405e7aad8bf265244f1e9d4226fb1099f6431a4a6170b4",
        @"3de971af0ebc17861419d05f0250c7f4f073d444df1404914c5afe0afd65ffb4",
        @"bd27495194b6933f075412be4c301511eea1e0f75c1d8e3274cf89941a63f3b6",
        @"6bf850444b40d517c148f79bab13778e464815829a8a0cea7391c6d0c0e636bc",
        @"d79c543b826e0254c6c8aab06dd8b1445677df23d93f228798535d3030ea4ac2",
        @"31af341643a35547531ab7f33f933b4bfac24661881e129b696516c8149e2ec3",
        @"2f6dd2089625cd550f968418db3aa3aa7ec2c82b9936ea1b64ae3e49a9448ac4",
        @"168147b72bd50c225608f2cd65ce90cf930c725b95b82e40e279b01b34e0a1c7",
        @"9bdc261b20c6697097a0693ccc5d8e08342196ceee3c67b2f3f703af03638cc9",
        @"735b425b8ae3330507aa1fb4c5c679578bc15c814582d1e9c41cf0e11fa3cbd1",
        @"f52a17a6e5325b40485807bbe147bb3fda1aefa770505a71c71d7af3ba63ecd5",
        @"358b1a766d3e8b71f90d3fe85231f2aa3c6504cbf2be7194d65f3a4517f459d9",
        @"f592d892b27d10896c76bd13221870d9013e7c7a8b13c72e33a393c9c4e857db",
        @"c4842fe854e91a7b01fc1a1ec923e9f287da74f53a510e60b4b0bbb5433bf1dc",
        @"86d4f4152d96ff46c1f8ff948d11923899d2459f4656d5419682d8e16a41c7df",
        @"ea721d7420a9b58025894d08f9fecc73b7b87ed09277fa99dad5aa028ea357e1",
        @"d023a6c0acc1b2847b50c93d64060c0d2a5a36778fb175c08d9567c537f7ffe9",
        @"1baf6cc0d348c45bd7826fd085fa3a0bdcfa7441542bc94396e131da11e91dea",
        @"c9ab494d5c6fa05c87f689f9de3ef0da18b397a07361e436e5a2f2d4697056f0",
        @"35372ba93701b380bd9df59538bdd426d2d995f257e90a63e88179ec87dd43f4",
        @"03df73261636cb60d11484684c25e652217aad6f7f07862c324964cc87b1a7f4",
        @"7480487c2ce567ebf6d3603dbae12a6015ce33e532dee9f0c7a4a9706a27d2f5",
        @"fa18d6f63ae9d791cd65d7cc1cc646bfcbb8706e2a6357364d5d58ea7696eaf6",
        @"d509859a3a70d4f6c9c6430ba5a5c6ecd6f375d05dd1dd02cbbe22350d3b3bfa",
        @"8a9a7d61d25db8904a3409468d81d49c3c190ec1f41371b036abf720e0a431fb",
        @"dc670576c36fd5a92e8e580ab4f898a228d6f9f66b19fcb3df185b66870577fb",
        @"2354b77c0f261f3d5b8424cbe67c2f27130f01c531732a08b8ae3f28aaa1b1fb",
    ];

    NSArray *verifyStringSMLEHashes = @[
        @"f75d5984c7136a0c52f0b1c6aa87d4203907a0d62d1b6ae06ab6eaa021b44199",
        @"b1686aa4a68bb56fa915dc2249394661cfabc3b0240351e49593ee7079c74bcc",
        @"4ed757fa84f0a1d279373e2841196186c9023c90948371c7ccab25554824efe8",
        @"65b884169a46354b3ec79848fec5a6a8eef5302748a6244fa56e34a2c06734f6",
        @"40e747e109b975101954113683a0a5b25bafecea3e98f27232c60b47db50e6fc",
        @"7ca916b4b9fb3549f6982cde58b992a258c372fea0d6ce69043f99b48315b73f",
        @"0c880508bc97150e4b5ed8232a11c27df401496f5afaace0ce2256e462adfe76",
        @"df88b8c121af50e64b998be0226301d6e6108e0afb1573e4fb2cf7e00c48e9a0",
        @"20e27d2e035002641212e3db6be3750b4d0cab6c2faa9a9561778ece0cd6f1af",
        @"4babd7eeae3327a402132abd7b9ffd97225a64b2c4206f6a08cdd2a7dd6ba3f6",
        @"ef99e5a033ec235ba80c71bf4bc44945c4344a2f1712aeb11c1be7d9c07ae606",
        @"b95013b285a944bf810d6cb23cc613b0197604e74db0fbf2074a0c72df4dc95f",
        @"70c9dc3e6e2421d7eeb8be379284f470b43592298aa6cfcc5d2a538e46512f4c",
        @"9c5da1bacfc6350e3329a2cfac76ec78d2351546fdc224971efd79e412949375",
        @"41373b50a6ce69368ea7cd4ad13d663f777653d8ac69a1bc7a305a8b99fee36c",
        @"cbcb8eb2d8cc5b609923114546b63c54f7a7ecb66918a143914f01d23d145170",
        @"43471bd379d1cd1933d88ef2842a203de9334b0c02976025256bf1fd7df99415",
        @"5a2952f5b21b6c251aaf51d1784c355eae94bac540fc5fcda2b41966cde84056",
        @"fb6b938139b4c2a48ad5bebe9caf5f2083325f6c7413c194d2c0870d0f5a1d9f",
        @"d9e7936959cb47f52d36fa5b81bb16ac8bcdf99f26e492184c59678d2a62e7f1",
        @"dbd7d7bf750a0b7b35d4012f2d676eadc7212fd5d66f474069ebdcd50bd25079",
        @"a1196d35e273c9bdd334b2215c56e401be44f9895026cb52965b6870f1e3b98d",
        @"3d138eeaa5f63b564835d4f0348ea57d97486cb835a084be919dbaf6ffa6ecb6",
        @"73b309fc6c9799bae0358ef888b068a7aa20eb1de2383bd7d3d9c030c1e8b8fa",
        @"914d162c56ea339b19901c4a44cd88bcffc683caabe54a353789c09cea9e9f56",
        @"3bde2f97319f1a588f095071b27da7196b339d57860c297ad0b3c15f2913440f",
        @"01e4554ca14ae334274026dc6f7f586e456516a54dce16805bd3bb7df4602be2",
        @"0fa4ba7423d9e6a4b0a9521870138cd613ba91d155645194d81017ac5743a5cd",
        @"4a3201d6c220ad5d838e8ed149caf4402bd89f3c1ad6e0957b1354cc275affd5",
        @"ad86aa32d2fdc821ed9ab248392e3e49ed0d28cb96014d2d35eeb9a7e3013ab0",
        @"92c3933a79ed2c4f90c50ae89fdf2fca5fecc111b490e371889ba8e15efc41ea",
        @"919d40eff132a9ed31853c7384e4a7456b3bae5ba17f4f3bb1f402a5189adb4c",
        @"df88465189c18e15945cf37df808ca494a7b2ecbac36e4a1eb8a67802d14fa65",
        @"4b168b226030c1cd953b94cbeee4a26b761a2e39b370626abb8901632cb08db7",
        @"0cf472d8c3fb23b4456c1d76a2fa0f899457ea6db926ef29fa6e1ccb32a74fd6",
        @"c90ea0ed583bc95f3fb8e2f45319aeca31f0d4e272e53869ddbc68aac662bdc4",
        @"3a5ce3c8c32c209cdf12a234b42aa8e38bf2bd041650a5043e88a3c27ddbd403",
        @"b178ceed4a30285679797155aa6fdbda31663a4d9e8bcba981c332bdeac022e6",
        @"0e4751a43e8c9d209b16cecf135d35c6003181bd6e2c6a97c04a532fe68ceac2",
        @"598922001099fa40502f3ca4b7e7456ea48244d68be5fabc8ba1b29b62d7325c",
        @"370fde22aaed5e2b0da27043ac2ff0608b52b29780e41ff021061030443ae20d",
        @"ab75bb47a1437e1a893b24b6a682f2845aa5a97e8b533e31d5da252c41f723f0",
        @"71cf8fa5a73ea9ddc7e09cc1a70393a8e85a810976018a53b52d147d686fd367",
        @"93edc13c4df24a0dc3b3e265a086bd8f69917ab4613c7259654f4e67e140951b",
        @"1e04ba43bdb86cefd34b00d61ca3ad80e652ce30d91298203299c7e255e53ac9",
        @"be9e5dd529fcb66b8a72dd40155bf06e4cd2bcd389913f63290c67715e3ba2fc",
        @"642fd11e9eb7727fee1aa908706d30c09be7a8bddc5fafb49a2431e9625d8d7e",
        @"626908ecc1d017449f0bcc393baf2c350d9f484be004789a547e9cf94a7ec6fc",
        @"76d14be3721e4534db2f00a0a2cd486603a043eb0bf155566987146418e0a637",
        @"1c3b17ef431517a26f2c2d1494bad4b06686452922c441de7c0095eedc5a93a1",
        @"134126313cbf4aef0a65f15b64d8c058975196ab3dacf30a361386f210b157d4",
        @"77d6b60432de60e77a6921bc58884e0f52c1e678a23863708fbf6697c9b0d19e",
        @"f6d11e1ebf291bf4ac6e574c40f86a83eb12a4b73a354276b3006fa216803ea9",
        @"d823378bc63d2a44b24f04dc750ddfc72a5793211121e58e46ef178c9f373d64",
        @"15cabfebd4c657b5ff2bb4c6bfb50d562935bcecf75bd70f4a981914344e8b09",
        @"c2ec1153a273d5adfff01bfd08f595baa0e8126481f2617e4ea37011c55216e1",
        @"c4d1a2e7bdf9ea419856d29d6c19a2dbca44ca5b337f48eb784c868f08719083",
        @"10bb48868e7a763e31f2ab1a5fd24d7adfb6e19308dbccc4b83183024466b11e",
        @"3c01accf8fa4c60c3ff14d2c5874f6d2672cec4efb726b80e80415f7bf03175a",
        @"c61cfbeb41b91e6e99126fa76c5d8a8376088d99385347be18f2ee750614e566",
        @"f23c8b054a28f4f54a43e14269b117966d51c8066b4ee69bb5368902a24950c5",
        @"bab1188c2037ded50d38f4cb875c6c61bacd19e4ddcdafe4eb86c0d4c4a6827b",
        @"0038e73b99e343ca975dce01ab1c63009b68994acf15a88c94f5950967053237",
        @"6e3276e3745af81f229a19797720f4c6f4b96654339cab77e5cf1b54693ad368",
        @"1cef6569dd095177f0cd12ef2c3d8f48081429eabc8f497185b90c73206a172a",
        @"2f3cd563c4ac12aa3ebb9a89f242b69ce2eff34a54ec83e75446edbff03321e0",
        @"84edf5320c8524531c3cc843996696026bea406c326990ffa265e30b29aae256",
        @"64b86b8b48f4d9f884368d79520a0adcc239687126bf245400ff81a4485e4a7f",
        @"ea4c93192dc54a4a862a992a2a7a47e77ed8fd4c454ea92de663b77ac5183e6f",
        @"b98bb14865b11f9b2f3e0d54cbca6dcec2a1dcb4d256e5e0f1951b434b9196e1",
        @"264fc627722365937d903c2e358b93fb33d3cd2a5f06cc8b8bfe7a400bbd3375",
        @"e7871a69194eb1837aabc4ff5460d357c17f5dd02bc5248195ab55a43efe3eb7",
        @"4acb694ee81a889b3e1e0e0a0f56a2ee2162a17cb3df6ffa6484520dbaa39b87",
        @"370c132e0170da64bebd0b738a63797bc2515c350712ab93c63b4ebf10ae5de3",
        @"1f4ab767f64d321f61d0a0995faa3096bf54742d62efe594aeabba6dbfc7e830",
        @"c2e326a9cf0eef8f71f88607caf6de05470280bb39d37d1001293da38c51f219",
        @"f75ab125a732fdc03d3310fd86467c5fe0ec2b105bb78783ebf1a24c2beb57a1",
        @"e184bb5593f302b5f7463520d3ab13db94788d9000e774b1560299672914d511",
        @"65b25e426b55fb2ca44c95b2738d775b97304c0af18745454f92d59f96512e80",
        @"1d02719acd012fef9c6734cfce121fb1e2b3bb2c135994699e6b99568ee0d1be",
        @"c5147cf07943ab5e7797947b5702c8b80b55bf1e6eaf6a00e5311c471fe32dce",
        @"35dcae6d88a079188b8da96789104dced067c57a82a22c7e10a606d7b4bda1dd",
        @"4a7aa2a5408002b4742223809565eef9aaa6e0681322a031f859177813167c9f",
        @"2606fc8205ad4b1a89f8cd4b1568ae029f8fd2a839afe7456a1f95c890d91a6e",
        @"e969ef9630cba22800158836c3ef72c02b4580d02fb7c4a8afa2f5b85340fd8c",
        @"40b2b42058667f969bcbc2015897494baa99440aafe374e75b07b9234ae0f317",
        @"f7a0c9825ba4353de2d6190ed0164d6b172ba1a778984b15a28e50476d8b61c5",
        @"2d3c332768ef0d89653773b5114a6bc14abe351137b6942d4ec3cfd176e52a28",
        @"ebb1f65a8af9af3f4fdb258c5acd38c7e9ff656836c83670710faade59e6bcbe",
        @"7c7339dc4ddf10eca4abe00251e65859396914c56030d4faff1b2e91c295f4fe",
        @"5a832be116f16a700054ed6761052b03c40d74bcae666c2b9b1cc3a019a36e21",
        @"ba53501b35ff90f93d6cf99462ef96211be215362eb9f9b6c65464531e35d0fa",
        @"4bdc967d3f0600f6cee7874ab9064e0298cd9a0911fa48e7f46b7bf920ab12f0",
        @"6c21634ede6b6b0bc7539349a3edf884137a8d418fd73a00d7d449bbaa40e833",
        @"7096d138cfaad0855a052c603f5666cd1bae259552c2e97237fe3def4dfd05b0",
        @"0ac44988afcdb876cee272a59fe30546d800fd3751e780a3c1f9bd2fe0370835",
        @"02b85de6d2827d76c97b76a6c8aacc3547561a79b52bdc40a99b3425ea77d9f9",
        @"6d1c7cec21aad2b93d9823cae3b39e66636a34daa033008d964d660301508684",
    ];

    [self performMNListDiffTestForMessage:hexString
                shouldBeTotalTransactions:1
                       verifyStringHashes:verifyStringHashes
                   verifyStringSMLEHashes:verifyStringSMLEHashes
                        blockHeightLookup:^uint32_t(UInt256 blockHash) {
                            return [[DSChain testnet] heightForBlockHash:blockHash];
                        }
                                  onChain:[DSChain testnet]];
}

- (void)testMasternodeListDiff2 {
    // baseBlockHash 0000000008505f14c60121d111e5a3800710f16bc50e8cae49c81d30d6a3a722 (116616) blockHash 0000000001ae45c1c24bad5a83a6cf12d7c493aa92579055c39fc16558ba26da (116716)

    NSString *hexString = @"dd44f406dd871809340bbc4ea57704ba30b071e56f7a7cda9050520300000000da26ba5865c19fc355905792aa93c4d712cfa6835aad4bc2c145ae010000000002000000023b5e149504fbfc1918cbc4aaab44facbbda04e6215ca285967d1db80df2784437b448b5158f30edea16a64fb7e26a46f4d276caa2eaaa76c9ed930028269fa3e010303000500010000000000000000000000000000000000000000000000000000000000000000ffffffff4c03ecc70104e482015d08fabe6d6db432313a00009a9659a973dcf54d002a33e432871286fae7589ce7284257998e01000000000000005800001e8d0000000d2f6e6f64655374726174756d2f000000000200240e43000000001976a914b7ce0ea9ce2010f58ba4aaa6caa76671c438e89088acf6230e43000000001976a9148ef443a84e2b900681658633bcfb74fc9907fb1388ac00000000460200ecc70100cde35283e3b9b7d40cd29c0cccd486e0688fc1d3b9a3bf3da5cfaf652969784fb9e5ab20f3848e99574228e79c58e7fa86128732e4332a004df5dc73a959969a038687a74d07ec7ac88b0c33086840a14b5699cba97608958ae325e57ae5c45252cba39456575e98db070d408313dda1fad6a16af765eb729506dec902134e7538df4e5b556d2d354fae3bfc4f396825011d42c2bb1fb99baa5b31924fb3840f36092354b77c0f261f3d5b8424cbe67c2f27130f01c531732a08b8ae3f28aaa1b1fbb04a8e207d15ce5d20436e1caa792d46d9dffde499917d6b958f98102900000000000000000000000000ffffad3d1ee74a4496a9d730b5800ad10d2fb52b0067b5145d763b227fccb90f37f14f94afd9a9927776f9af8cfcd271f9ce9d06b97af01aad66a452e506399c18cf8ec93ee72ba9e09c5dab0123cfd922f1991606944a5e178e75e3cca63c3fb7e94720b4e4649403d9116c0c0a60ce718c6a479feb17b13a16d18245222a6a8699ff8b9a2cbed6fe07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bd185938a5bb256c9aa0e6a2d86d6a687600c9c0004431d5c73ecb095daa699363d0a19e5b6e549414e6608cecd1188dbf551a777f87642a37e81f3d63e25a4426e06087954c872fde1894ea3c937517060000000000000000000000000000ffff2f4b449a4e1f842b8e5b5cc0841de193f440d5fa3e0b4a34df7fffa798fb8c3df46fa31187162cc3b3ecf929689ae35e04cbac6e069ff0a5dd8f973cec456a2423da87b5f1aa97f282e00049e7c0077dc7f325ae9402913e681d3a3433e407e8e3f7670d1e0e1f56b8e37f9fc11712d2dc9bbc1086769db77a550a8315ff64ac5e20dfbfdabe070000000000000000000000000000ffff0567885a4e2582c635ec296af1d424586d4a77d10159fae30591e6f0d7e64060ea613dd8ee5392f9e0f2c14156147ee849b320e76b68c74055edbaadc7948fae10912f87eed3652a6f5c014acaabcb7ee31149510138a0b11b087cc5a2ff0a24225bd52b52e1c2c58a113d5a4a633d79445e9acfbc878f263e03b0a3c930091f7383b5467eba7b4c00000000000000000000000000ffff8c523b33271197e409f5889b8c033c412a939d2419824a2b0321e29c357a43bcc74644d1945c6a5fe7f8977edeb6210cb038039bc30f84a5d378f42cbf6b07b826f192cf691480e7070f0093f882118caffcec59e7305e5141ced538880a37dbd68e075102f9dc0f51c22bc722194540a1b092c3554f6ebd9faf2dbd04acc8be221f9e3596311b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b017f68e82b1206e7e04c38bd976667ab36223f00732a3af01eda255d6ebbeb575b273c554d6aa375d096be755a42813d388f18823e9080bd678e91eda4ce3f855410830feb1643f64dfb968eb16e68100000000000000000000000000000ffffd93ddd094e1f97d330e64458b15b8c89b9469309fa3392389ea7914d6ece7ed2db3a1244c020f544e18a00f66f636272bdde847f91fde214131460d26a3080c859c2dedb23d4182f99c20179db996f952e018739bebbdd0a643257835125cc49094f417dd56e67c65549556a37ce09bb8a91791f7ad1e407d7a1380c88c284eca4d8cab974890400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b671e3853e648bd893b1afd21519616360237691001e6a0a8a0f3dcebed9a4d91265517bd9aea459ebea468eb0c7734b3e3d470530afe8232cb86ba16eaa78cbb6092250af0424b76a3abaddd1ecd2df020000000000000000000000000000ffff0567885a4e2414f2a5efab36b3b205fa374f96692964cb114df9bb45dec65232ea352ad61158f56d09ad508ecca27e88d75553a00ec3f3fa8bab192527e21a828c3aa96c794e58ae38b601180116ccff406f895d7fb7778f6fd5fb6fa1f778ea6a97cd97aade5cda01000000000116ea8db3515ed3755b5898f787663248dcdb675ecf9001495042480c00000000012a1c8466f4a44a7fe0010bfb10b3a51d256f75e3b662b933e2bb6e0200000000012b059731c6a9aa722ccb52107e0e214d971bc2fceb7c804475e7680700000000013c4db348e4a2c2f37905d5b1cbfd2a3a52aa7ffec5c879614fa8e00000000000013c8a5f6c0101cbb0fe3e5e9af871f3c90a1aaa68b1d0834b045f8a0400000000013de093a8efd7aebcfcb14bff15cfdfa072dd7e1807e869d3e9a5a80d0000000001430f69b3bf088319092353104d9de5582f61c98a2f15e45083d0500b00000000014a15b59cdf800839d48851dd8f442b9660d458a6dcddd7d1837220040000000001507b200984632d4aa88ebcb687de36e866ae00a2390b3e71c7bef30100000000015649ef2aedcce8109a2413d228c9ef87954c68f1f7d48cf304838408000000000179cdc7dc9771dbc90f278c749349655505d73e1ae395769a031b1d09000000000185ea712a3657301a5f976444688b1dea80ae5420e84e1695e100860100000000018765775b9426ea4f3a8533a3491453a0160fff197e5cdad6379e2c0b000000000187eada4bbb85a686af020a5f3f6f4acf6e9ebda200012d0d32975f0800000000018d6987ca3e9018be6031ca8c472955a0c7e7b5e37c16917d6112e9130000000001901448fb51c7a5ac592164e8be3b54cc0fe1073d4fcd3a2de7f239030000000001985f6d323753ea0e8d291c357800555cc6e8dbc021aa33125dd8b00a0000000001a47146c50428d4426f21b4bfb54baa3c13ec123b4de866d5eee39c150000000001b7e26ad935bf43904c2b03bfd833be0a8c730d44db110f4c3183af000000000001c354cafa4b8dfe2ebd3214ce04fb80fc958e960dcd295b62998f39000000000001d65f489e33abc9e2e4ddf0d8e510a266580ca24106b4a909de3de40c0000000001f3af3a7af64f5f49eec628869fb379db1e4a024d0d7a3d371fff17080000000001ffc04084719fe130783a58d6f2676d3dab451af07ac03f4ad86faa080000000018010001229c4bf2f4d69677f115f62c78282073d3dea5a84c211c4e2a517d060000000032ffffffffffff0332ffffffffffff030a5e0fe8af096098c11ff30cf4df8004d0bd9ba264f16298e5229936cb1a2c73ac96c48950ec97bab52f204ccc07f571d6c596cda9296c7cb8a8d9f16a21d5e459feb575470296deee1a2f9aba30727097540424624e7675756ee353fb214bd16d4bf437541a99b2f7d4a1b721134678e86edcde6dcf23514f8debdc5eee3a4c03a6744be8f0468f8edda1cdf056da9bda5dfc6ae88641c8da3738b2e7ed64a641ca2199c8ccd27642af627afeb0e3f191f03a27623a74c87a7c5142c31a0c873d1da6cfc8056279998dca4754f89ced6e4638aa4740ff31aacaa7b2b1bc1b8b0f6c1b4ab40e7279881e13f65e9c04a049f95f9e1610b93254e85970750d3f64388c193538c71e512af44957eedaf38e01000122a7a3d6301dc849ae8c0ec56bf1100780a3e511d12101c6145f50080000000032ffffffffffff0332ffffffffffff0304aa1479cc8acc54940cd5d58e56ef21c6458ed0feccbd6f45af2e04766e618274078685028f63e166bc0232ab704950364da4ff9cf9b5a2bc5641993726b6e7d1bd344965259c193b77f3c3e84ca82818f1261a05994084e0a65e32e765e08a80953728dccbb619e6880f471bc4cfcd70b7e9741606df6e1554be12dae0d0a719f7d97cce84179beecb1757619a52d08fcc8def9f07a887b48c5b6f7b45ffc4b2f70449cbd1ff0993f067590299ea4b04db6dc6158cafcd4ff4c2b29000a8b440fd8cfffcf6c0402d387e56e4e2b93818713f96e46ee57b99c6422a0a86abe3133d09922ce7589f11b1224d955addd7295708bab056202fa443b68e72676fddb073490abd102057401a482d7d09290d0100012d86cf8a2fd4d2de16e4b3ecd4bba1c33a32367805ab4fc1c247be0d0000000032ffffffffffff0332ffffffffffff0309b3135b269a5fdefe98fbd888734d4528dd87d57c9025d0d3d851ca90df69702b544c051097fcf5013e2591a96197bbbb474c097a53b63fe10f337a17f0a9b0e0f5d29bc7a3659daffcf3b4290fca9489d24758a98bf3343a0b78af57efaa7758cf5e758d7de480e49fa55ba5ce01e33513e4346728ba1a8b642ca51d2b5e39004b617649838eaffb637cd5da146b30987dddf048e1364d787ed7113df94e1ca68c8f3f95ef63c9840efd88ac31d0cf8ba4155ea1fbbf281e48f449b92d76385f0d5ab151c4748fae6f11852a56b98b1fbcb3fcd89f0927be9471cb7f95720d14822e691bf43cbb97861ee1bf81ac3b1f9956484752078ef042cd4cd36f6108dc52ad4e9696acd835e2888bf637c05201000138169f721527a5a655146a7680d0d20e6ac7be0818fd8ab66a24bc080000000032ffffffffffff0332ffffffffffff0302a916f5736dbbc6c4ff75ec784ebcacdd2a47cc7f78a67bc8b4f172ac6f7510d6f5320887e7bfe553ba38be8a4b42ff0d7f3bda2ac045c160f9107dcd40d4bcb3e003f028d066df1c0ad19554b170de97e9a8c1bf68ab419dcb88d93a7d35426090f7ea6551d3225542b9dcfa97220cbbf6003befebd5146833e4b77a0a0a670ea6156405c04e0341700a3ee70501d01322dd4e305cf52d509c488059bc52d278de341a3378a17b05c7dcf13388bae38d095fa548c755502929afaf1beada57dc8a7da2d51cf97cf9c12911c2ab49051e39d032111ee28455f2071caf10b2ad02c6690898703a0ecac855a18ee7d02bdac7524fea00eead690920a04f967d3eeea86acfc8d6a9c694a9550cb961e8130100013c9a9a918b5d9048208ac3c0aca342dea16af6f647acaca7e8d714000000000032ffffffffffff0332ffffffffffff0388f0db6b93926394e2403df8c0f8578e7a79ff4840726e0ab8a488e0ea29303ce88436e1d9c95985ad634d2a94857f16991b69999679254d67f1b322b879e8ca5579d086d0fc3a207a0d3866481e79ba8f3c934c71ebeee1e5acc136b9639fb6036a2669d3b57ae8fa1ddcac26356ca511998312099fb684a8b939b81fea6bab013b396ae626360c2f678f6cd81a071875c5833dea3cb9152a3dca223ff6d583174325438dc146e8e47c196e243467528e622c90ef10ae687e4be58d13a4552586b8c3c991c148e886f02bae3dd21af85481f1d073ee93fa4d10f76398561c2a12bb503878aada47b9bf56ad06fd632d69c5df05976169f94e08b12cd4eb3fa06ad945f7530496f009dab8883fadff790100013caabc62a671fa3c006491677042282742c32081131aab5b1c55f2040000000032ffffffffffff0332ffffffffffff038337d1cbe6e04fd53cd188a2d9d3fdf512429c2c8d94160dfb422a0955895e5512f3c168d0e8c29c13e29f791a5bc380b7116ee82c478a695d04c0f0d70650eda502dcb7e4d15ccd5109b7f2e269f57c159fd12fecfd806223105e2aeb6184fc89864f09952fb6abb67a9230be74a4bb4ac9763701a5ac7a90ceba8ed4d8761103da982770a8a4ebc7d1e9ffc9790b387dd9d1e4e7970e1defb3cd430e2a9583416c8d894e0978bbd7a84f106a01416999abaab5382f9e71b383c9988c4e7ad536d2a95426cc4b764b3e495dd5b45ff0e2a6f5bad631039f9aedc5b09a01683311f453ee70678e5458f2187f74563ec3a1e2308c04deff959c7de8a9bfbd1d836d70d80f9969b94d51b2a7787cd46e3a0100015d117681bf78ae1fed26bc063fbf06008d0fd56351f769a6b6263b040000000032fffffffffffb0332fffffffffffb0305cc4ab8742fd3d129c86e8be070599f43dbe66b0fd17afe93f29cf4884b9019b3648cf69af90a9ae7aa1e56144ac0f28f14e573cdec4fb46e66aa4cfb3e2b5eb7ba3f634ad3ff6205a84152486b25430c6d4d330de573b9cb74d25c58c11f014a3ccd70671427276fb80287e3ef695823b0856065d144803d2013e0b4e35f8f17948cc4e64db5b5ef37a188c7e9049dc9d9db910613e3c3862522ac758b849955e54e9f56ef8ed12f32b2764383b2dd983093eb0996cbc3ea9a526a9643159b235904c99c7e234c5f100c745245e7fae61a05538230ead59c084ce67776887b0b3f6df1ebd940aaaadbad17ef09dda30512c962efad058ab7eb98cb31dff9efb6e295755220dbfd353abf2c0354270901000170d9854c7682f09f289bcd75cf6505f4b5bad12370d475032d4800000000000032fffffffffffe0332fffffffffffe0392d8fcc39b65236efd68051128d99b6098ec90d25bea351ba68202e236f1bf0aa73d1ab5d738763b154ef0c277421fc211b6dc4d5cdce38c738272d482df5eae8473dd65a822e85546214025ab0985ac93f4baf9a24db3d415a661d82c6c078efd43cc3498b51f2a7f3be0a618c24b42c17f28ae0b6b5ba3310ec51f475583bc020494b12a79af0586d9619001de1c94c1e813e26496b8a8a1e5cee553e5422c6e3099567fd0627ec21ca9bf5f9d12910a004d74df8ba679c575236e7d371b32da1fff031076d395ad4033e6f950d640e3eb6f2e53298f3ed7567f0c8342d6bd0f6390ed7da0668875b6bdef0006452133cdd68f4518b5f2913c856b7d7ed2142300820d5f226fbaa8813260ccae3ce00100017311d9d049c1f7bd326d4d0d45f342340f7840db77208adac758c5090000000032fffffbffffed0332ffffffffffff0302f8d5127f469400542a9d52d16ad9b90d1596f822b1aefd9056d48155ebb993416b6ad00c9c13d1269d7b3e20a5c520d8393c68ab84ac31db33b611a891ea2f5837b8d3f592db5a27a4c1c5399bbef181a5b9a8c83fca1b6d4e6a996f532f2785aa7d9a7b75162c1fa31bf3414a1e93ca0718f18a7e813f4cf93169d7a3c123104e247ac21226893e488428a228747cdf7751566ab05118d9da1c90f26855dd500551afa8c2cb0f2e9cb0c41e99d9d49805fd4610a744d0c8db3d9cedfecf5b98122a8150a64b68c37e0ceda1e5aaaccf44f998e81f4f506126d69c279410fa14dab67581036a3acbd95ca20231f712cfe1f48b4d93576e4417e5cdc2f494f8bd69a868394da16722f347a033094acb010001747c9b153f8aacbd233347d79371cad75525702bb84e4c26bbcc01060000000032ffffffffffff0332ffffffffffff03854d1c416322f76a2b2929e785d3f4507b49c4f43e563a8edf36861fd7c8b863481a7d168424a809331c0da7ff1d983d0e6d82bc2f3d83282b8f1b5328aa06643f9adcff7fb8fef87c8ac2245a912e771441bad128c06149cc7b400d9978cf1465092650e97c288b6de1556c08c410645d885d19558c99a5b0d2ae760cbb789a0167099befc47a825f3c795b7e6feb377ac3241251d08659c96fc1d46fba34999bfeb351ca6099cee491fd3df16dadc01065dd7877dac34930c071de1994fed7d6612ef6a72886767e420e35ba8079dfb411ccbc1bf22d2ae06e5ef33b01082d19e553b5c5c6d6b02cbea959b6b644863adf1ae98157e2a96a7a1f6a9637d158b7234f359a692625b69904f8087863330100017588e7f26743910c556ebf1a565e8335229619245951154b4e20730d0000000032fffdffffffff0332fffdffffffff03960948ddcdadf3e503f9774928333bcb598738139659565d6ba0e0bb293c0087a7a839760c0f8614b78084785ad7adce1b7ae50bb0022441020619de1aaf932405293ec6e8062d50500cce13c7799353044e571f077a5eda2a91d3a41c61f5457d80bfa6a9b43aed520c6aefa4ff908cd59fa7e9bb687584a114f5bbff14d58716ff128d817fcf0bcc7c50474ac7c6b3661e8b502d1f1c366451ad3ea9fddcebf69923a41eaf9ab7435ff839bca8bf2d83fc2c482d5f50636ca951121b2f83aa6c77575b9a8c29464d6c74c46e8435e754061226f4b47c1529a77bae668e06b3109446c9fb5308ed4b2ea93c676109c04ef6be8610e7b00483de2481828414ad15ea9c5cf47fd6e9c45ab77cc3d47b8c010001a855a2b709b073515165f8471f4c3a9264abe8be59764b80538fdf2b0000000032ffffffffffbf0332ffffffffffbf030807fe8cc708ab80facab488b6cc4d1b90e501bfc8b942105f15f74baebcd4589724f89fb0f115815154c0687253b09a99f466e4108a55f8d473435324b124280cc0b920c835959510d0e938d714cbe28126e78d2afd6ef1c9c71e4632d258b2b84b25dc08faeb9674300564bec6e371f075ba348cf2a92793572912d5784a670ff759ee04eeaa74506195b3b69dc059c74328388582cc9945b4646c672b9c6b83b286b3f27a1ed18fc999dabbc8c29981e686edfd62406d1b516437eb28f609bc2a56d5374eeb0dfca61ac33b14f7d99623aee180fb728d7733385e56044cb314a6f63e5b7cff659b9b14d893b28b82a6fef6796c765779d5a2ab0ab345df9aaf2b507764cf9d1415d6f47239517c9b010001abb44f0bcd7959f00e8766b1a689a832259c0bf87f3e42411f1150010000000032ffffffffffff0332ffffffffffff03995fbb3d11d32b2100e7811d8fb0bd262e8edf4d25691fd6c08760845910e459661b3760eb0e3fdb5d413eb4400e8f53cd81735018fa176a29fa073f671e8f0f4651b938e599ae5ad5d954eaea5c166891b131fdb47df2fd282e6bce006c39494af36031510b0194cc9927ef2734ba1d214b3184513c580cf0ab39dbf2211d3b0ee474494123d34e64ab3c21618e864dadb078f030371b94ea35a1c46fca60c738a778acbe633704221e518a8879ef95885107e15f2a385b829712f0334fce99cbdd978349e80d06075aa2036fcacc17661a0b53b70cb6daa5ca3e1410543ef00ade2619124c77e2abdccbe4c817b4f0aad3800c80879c3e0d2c60e81afa7e02d98f3cb946e2fc6f9bc5d5adf3a74096010001b0bc05871d2f1578b91f2c78cdce9e92a5fb6718585187977ae1ba0a0000000032ffffffffffff0332ffffffffffff030bf782d4ea0c1b7995f722f1de4cf655202dcddeedc2f0913c57f29aa6f72806ebddc15f93eef92c2990af727eee415dc42416236dd0c03f82201527f17acb00d60885e43fa920aa43491c6c465e75c300cf0e98f6c7083397f1ae078d5558c792bca461f0bf17dbe5386b5ef5cfbf363bb27c7289909614dcbcf09883672a5007e652b1a690d0a819e60e5acbb8e68feecb2d1569376a492510f778d71262b212997d1045f86f54c3927fe5626ba9ec934abca5e0ae0f99c3eb40ba313318d57dfae76f343ab7c3b6e208415d0fb29a66d99b5831043a45c8043deb3ff2038a06050aab6e4cde88674346d0ae1463bb2314932569b27ce5143051d568cb230602f595cc57fb63468c8430b5ecbe1085010001b79421d25a6e9ed1f9d1c9477b19b4ad31710d7918364d7a7bc922020000000032ffffffffffff0332ffffffffffff0318f1d65cb7b75468a508ee009b086bdf236339f5d6750796dcc740a734f86d406a6b6bb732337122c73103c469542c733463748462774bea3d1f570bdfd001fcac4ee2f42279f2fbd66adedb213b44b60d203236832d3b4983a26cfdb0e80fe74071120778593e9549d49ae9167324c67338fb13ceac7461733424c77eb3e0b90741c84f199914ec2db36f4d8d7afdabe29b58f2c90d180433c9643f2d5c7aba9c6eb05b3d491957b073af7cb9e338c50d228f21887b62b240a537181ff69eddbb6a83f09f45db44c2a965e7e4f75e0e0adca63257db97aadaa3c205659e73270879d781c9aef9940638f4e8aa766615099b7294ee198abedc2614f10cccea8d2b825234c04c8c9e6577ec7ee0637b45010001c51f7a354b8de02094de692028d471a1fc196c0b2b7866fa4c7283080000000032ffffffffffff0332ffffffffffff030dd22046d88a41449a47f443989d4b47e9e40f2b2f397ba4437249c571b3b822cc298fb9edb51dbe1cc7ef3eeb7a19b8e0fbab04bcef15ebfb50b3f185eec18e8352e64682b601e146aee976fce40bff029129774b1dd31e20fd9b2684c1ec24d4cc4d40acfb4065342b5e59a3eb9b85f754dff6d10aad76bfaead32d99d37f514cd613d21606130e21187318502f69fd845f8cb9c20f3afd7442c9715257e368bd7b7f71bb7fb9f22ec6513842e4b0906d9fa3255563d2adf80bf63c97cd3b62ad1e74b7ecca7aed3c25b7fcd5ebabdd128a8f6749e5ad5af801725de10650b10b2dde6ae8f439927d6369a90abc735af6fb86161f44155a95c269a00f51b129f6cbce9b16e099a62fd4b6a5507e1d6010001d2e2629601f122f2f32d9d0753132bb46329ce0f3a080b2b780aac010000000032ffffffffffff0332ffffffffffff0388f2e1a245b157aa9a55f0bb9336d25e99a11c159b881bca36f7946dab1d8be0ea0676f1e55b656aa5622286aaca38e3fa329b291ae781591d5524c8e0b93b2ae83d7cc36ae20d091ae69731cb60e77e0a0424c568f731be57c9b93dd943cd9354530926de7716a8a76039191dde3441c94db26c1837525f84cdb47ae23550c70ee7c1181465db23c1920922b8773e67f771d40fa46831479dfb8306ccb9997c2a303e16fe573ce2a432a6da5fd7dcd70ca9b9333da637a3bcf1af25c5bd868826c6bf2b6da2f3dcd6a9fc7d0281717576228ba955930163937fafec64f3364c032f188166f2a8759268d548fa6822417eac89107396ec1bdc33c74ff3a8e1b491dcb5d74be16f20cdf09d4bae492dc7010001e08bc7fd0ecc0d32351c73289381470c7ca6d8cdfdfd3bd405b247060000000032ffffffffffff0332ffffffffffff0305eaf5657157f44d6b428e1e2a0955bdeec1766edadb7c02002d0b231a2488dc7db1fe1c5164bedcec9574813e1ecec616339956d977239d755c1a31545e01212ae916114c0200f336f112e0c044f25b0d253bfdf2a20009766a9d7a8814343fd18c06214916b68db5d1f275c1be91f87b5a41c2edc25992da7a635637decb0505e0c9f42fc4df27c217a30360abae8f313a2229868f1f0cddb0d197a44c0eaeec70cb1b31a5c2a66052ff37278aa14d95622dd27a00f3c6bae42749761e5fc24d77f3e89bce3588140cda45f9c5d9b07bedfff259f98fe3afdd3854b4d83558152ebdd2ea382578225efc94917520ff3cdbf5c3f4c77a12980a29e44f1ab36c33650f1115cf0857d5cd4182c5dcc0b8010001e93a1a5cc2d3ad72234b21751b534e243653854c4b0cdd15208d01120000000032ffffffffffff0332ffffffffffff0317516b8119d82badfafcb6f3a6714830a1df0d13dd81b3aa24912f43cce663abb3a6c7dbb7636cad0b85a2d3849e629518575db75eedf681b1545a9c70f2f4d46727a169d4b4ed59032a055ac51fc68c97649d0f968172c4ba8a96633efb98ece36326559fc7a7e390e25e88e0c0dd5f37076e0e03168a1de6bd4c7d6f613e6a0f09eb1a69935f7328b19fc6427b73ba34be843ca56d2efe7d0f069e43c18791bf5713b527e20c20e87f2f7ffb01450e8d3b3b3d551612f9f3e04c3fce2dcb802798dbea27db382dadbaba49466fe8fdc72ea620e8ff9aa29143855b6ebd095b1356c3d9b3461bd23bf4d4f1eebfca7bd487e776ef8909be0bbbe6a9db0cd40eec5cb97379c7889ec7c92723b7ffa408010001ec4d8ea1cb816fa14988e6bc1f8938ac90b9ef214d3a537261b81d060000000032ffffffffffff0332ffffffffffff038ff86c7cfe9d23836921884d37a4af5cb1d88c5a930ca1f00529a4445343b9b71be75d7c06a5731037c100fe066ef9a4c55119ce464e6546ba2d656d55ea9a8c15b0f4939ce1b9325e4cabdce34529ad00cf4007211573579dfbfed3e93cd4172d8a5daf54368a1e31889b81d269ca6ee374a560358a9b4a633d64ffa1214f5002e2482b3ee4eed2a92e42d4b901874578f5570506acc302d0e255cb4008bb34847ac4907ca2dd01e56318c12a7b4e0e84607a353985d420c585c1d76aac1ac97f705295b9c5b1637a8611aff3c6305a6522b93c874b3ded3acb050e1482ae24199136df912fc27cd32e4cfb0dfd38d5ce9700c7fd1c0707bf6aa3556d121e652e62adb99c0ab19e493b41b36d1cee96010001ed41a2bae64f1e7179da19e4eb675e2e295b1ca7d30f1c88746a9e0e0000000032ffffffffffff0332ffffffffffff03988bd458f03de72343f737f6feca7062a9c2226c947bc117cd45df9e824880c17d885c9c045d16e1a341afb557851ab23b104969bdd7c6f3ab175258670f9121b70bdf495546b4570de97ba90f7cb42781c78f5c4f958f84bddd69178de0aee0fdfa5c61918c183792bbdfeffbf00c3df06f81167cba06b60e9654ca63f4959e0efccbd371801f8ff0d60db308d8c2abf09909bb49403c9f46de07d19834b1ad3dca5047d4094a566294826c780c35a38e17d593c286ebcee95a60e0bd9e290e646f909cbf1903989ca965756dd9ad13fa225dd1bce3e3dc8746e1a115d21cbe0631c580458496eba0cf25ff55d1e5adae93b9168fb73aa3b0462625e5f8ef07b836279da7a4ccad764e329c9548a7f6010001efa17ae3097aa9c88554ac58ec07b09529d2f464f38b420e62d0d90a0000000032ffffffffffff0332ffffffffffff030b42c50982b77e7e95fbb35216e285999ee986f889ff3d5d989397de11f1f0964e2a7fb61b4a48426f55524c6f59b39147cd4212f001fc31aeb1456843aac9d85bd95fcaf751410e02fd27e86bfbb6b98164d055bad5677965d3d83b93cb8f52010b466a6e02a4b3d8cc6f2403780764d9dca5201f8f7e0c2d508896607848391417e71da7263108993fc049c8dad1fd579d83809acfae8548db95cb3dcb128986ea5c996aaafce2764486c21a7d82dd81234f156a14a79d1cb344bb28cc0ecef519a0c87a7ab5c187a54e4964e63cc94e3fdbd9216ed04ded0aea4a6abee3e9104a2bcdad64507e1043f45671f46a7f146faa79877e4c6bf789e28c5759227df7d4718aee7762e298ba2fd429e54e40010001efc1fa2d7ff2f31687c5d07e48df90bf408a74c2f78d08c7edd4a20a0000000032ffffffffffff0332ffffffffffff030ba2d75b60a28889aac86be1f3916525df469c87f4919b0c396f378f139ea7fbedf327b6e950e6b805aaa84e34c4d3cd0df8094c77bb90379e3c3726797fac83b6e8e67f0a7c3ab76150bb5cbcf3c14e99eee4dc821cd19d752803b0514238911de6fe3ddd9427dab5761470bad0c6dba4b237c8baf6989fba3c52e346f687160d9f1a78ba68470fb59d892b6b79059ced52d090f8e7f5e7b574cfb727e8a44c8d03354cee8ab9b9b1b3d6e8458a98968cfbb720e12c430a3a50661eb9a02770b20dedab3b1328039434641325580d22acd1163f5a377109fdcfd04f2fea442e055d28d24e5d17e650d1bfb188cbaa36b07656fdd22167c4158590538be597330560c2c559bd995fb95472b2cc933da8010001f96c82076e81fd4c978242541bece467baed54c93168782eaa1ada080000000032ffffffffffff0332ffffffffffff0316332cc4a845cebd690dbe138fb1df1e812979e628f366b634ce4ccbc021c879a39befd0c1ab0ab9a9d23459a49ac67a28282e4974ff2e0b5a43c0868d49f46dc54e2be961d479fa2b4fbbe57c666927930caa4d4eb0c9416d12eb570f8ef6a5a8c4f405acd51227c08d2c11084967b251c5bdf8f54b2e7e4199b23ed12f479705b5eb8be17c3f8bff63fdf014e58846077dcfb483b00d29ceb50b3220db02ebcb66e58a4c0466038671a1dc8109876498c4b44abcf11a76fd7d9cf029e2cd2511ad48f6fde37abd4b9c543f042a1330908c2e6bd678b28f70586c5f83dbba37096d58d49834458c661963492c586e9ed5cb6d23c3e9b86bcf0646fb7911d842b11a6f5a905f1d3b61c0da58d1283728";

    NSArray *verifyStringHashes = @[
        @"23cfd922f1991606944a5e178e75e3cca63c3fb7e94720b4e4649403d9116c0c",
        @"93f882118caffcec59e7305e5141ced538880a37dbd68e075102f9dc0f51c22b",
        @"1e6a0a8a0f3dcebed9a4d91265517bd9aea459ebea468eb0c7734b3e3d470530",
        @"4acaabcb7ee31149510138a0b11b087cc5a2ff0a24225bd52b52e1c2c58a113d",
        @"79db996f952e018739bebbdd0a643257835125cc49094f417dd56e67c6554955",
        @"4431d5c73ecb095daa699363d0a19e5b6e549414e6608cecd1188dbf551a777f",
        @"49e7c0077dc7f325ae9402913e681d3a3433e407e8e3f7670d1e0e1f56b8e37f",
        @"732a3af01eda255d6ebbeb575b273c554d6aa375d096be755a42813d388f1882",
        @"2354b77c0f261f3d5b8424cbe67c2f27130f01c531732a08b8ae3f28aaa1b1fb",
    ];

    NSArray *verifyStringSMLEHashes = @[
        @"085eca46adf569129effe75c418993dc1e6afe270d8dd15d3bd86a61f0daf7d6",
        @"43471bd379d1cd1933d88ef2842a203de9334b0c02976025256bf1fd7df99415",
        @"8cde8673f8228131d9ed4f14e920639a226c51a1884724878b433147dd3c8031",
        @"07d5bd2519b091171e0de1c685bcbaf63cf34866c068ed600e9192ad248aa72e",
        @"65aac8656da4feccf2ca3dccfbc4354846ed97f51c1278022d539dc0977bb614",
        @"ab082616b5da66b5614d1b97c3759276ad216944c8ac519d390679aaa0b2056a",
        @"065e829bb4c5e3c3890cc7890f7161e896866f740dd5ab9f7800eb87e7927cb9",
        @"1c3580556e5642cc25cc674e8cfae5c2b65848b34cac6809ee683ed247323195",
        @"860763c4d65bebc2f6b3da76da0e69c62eae470f2d7ff17be192dd266d90c777",
    ];

    [self performMNListDiffTestForMessage:hexString
                shouldBeTotalTransactions:2
                       verifyStringHashes:verifyStringHashes
                   verifyStringSMLEHashes:verifyStringSMLEHashes
                        blockHeightLookup:^uint32_t(UInt256 blockHash) {
                            return [[DSChain testnet] heightForBlockHash:blockHash];
                        }
                                  onChain:[DSChain testnet]];
}

- (void)performMNListDiffTestForMessage:(NSString *)hexString
              shouldBeTotalTransactions:(uint32_t)shouldBeTotalTransactions
                     verifyStringHashes:(NSArray *)verifyStringHashes
                 verifyStringSMLEHashes:(NSArray *)verifyStringSMLEHashes
                      blockHeightLookup:(BlockHeightFinder)blockHeightLookup
                                onChain:(DSChain *)chain {
    NSData *message = [hexString hexToData];

    NSUInteger length = message.length;
    NSUInteger offset = 0;

    if (length - offset < 32) return;
    UInt256 baseBlockHash = [message readUInt256AtOffset:&offset];
    XCTAssertTrue(!uint256_eq(baseBlockHash, UINT256_ZERO), @"Base block hash should NOT be empty here");
    if (length - offset < 32) return;
    __unused UInt256 blockHash = [message readUInt256AtOffset:&offset];
    if (length - offset < 4) return;
    uint32_t totalTransactions = [message readUInt32AtOffset:&offset];

    XCTAssertTrue(totalTransactions == shouldBeTotalTransactions, @"Invalid transaction count");

    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];

    DSMasternodeProcessorContext *mndiffContext = [[DSMasternodeProcessorContext alloc] init];
    [mndiffContext setIsFromSnapshot:YES];
    [mndiffContext setMerkleRootLookup:^UInt256(UInt256 blockHash) {
        return UINT256_ZERO;
    }];
    [mndiffContext setUseInsightAsBackup:NO];
    [mndiffContext setChain:chain];
    [mndiffContext setMasternodeListLookup:^DSMasternodeList *_Nonnull(UInt256 blockHash) {
        return nil;
    }];
    [mndiffContext setBlockHeightLookup:blockHeightLookup];

    DSMnDiffProcessingResult *result = [chain.chainManager.masternodeManager processMasternodeDiffFromFile:message protocolVersion:DEFAULT_CHECKPOINT_PROTOCOL_VERSION withContext:mndiffContext];
    DSMasternodeList *masternodeList = result.masternodeList;
    NSArray *proTxHashes = masternodeList.reversedRegistrationTransactionHashes;
    proTxHashes = [proTxHashes sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        UInt256 hash1 = *(UInt256 *)((NSData *)obj1).bytes;
        UInt256 hash2 = *(UInt256 *)((NSData *)obj2).bytes;
        return uint256_sup(hash1, hash2) ? NSOrderedDescending : NSOrderedAscending;
    }];
    NSArray *verifyHashes = [verifyStringHashes map:^(NSString *hash) {
        return hash.hexToData.reverse;
    }];
    verifyHashes = [[verifyHashes sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        UInt256 hash1 = *(UInt256 *)((NSData *)obj1).bytes;
        UInt256 hash2 = *(UInt256 *)((NSData *)obj2).bytes;
        return uint256_sup(hash1, hash2) ? NSOrderedDescending : NSOrderedAscending;
    }] mutableCopy];
    XCTAssertEqualObjects(verifyHashes, proTxHashes, @"Provider transaction hashes");
    NSArray *simplifiedMasternodeListHashes = [proTxHashes map:^(NSData *proTxHash) {
        DSSimplifiedMasternodeEntry *simplifiedMasternodeEntry = [masternodeList.simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash objectForKey:proTxHash];
        return [NSData dataWithUInt256:simplifiedMasternodeEntry.simplifiedMasternodeEntryHash];
    }];
    NSArray *verifySMLEHashes = [verifyStringSMLEHashes map:^(NSString *hash) {
        return hash.hexToData;
    }];
    XCTAssertEqualObjects(simplifiedMasternodeListHashes, verifySMLEHashes, @"SMLE transaction hashes");
    XCTAssert(result.foundCoinbase, @"The coinbase was not part of provided hashes");
    [expectation fulfill];

    [self waitForExpectations:@[expectation] timeout:10];
}

- (void)loadMasternodeListsForFiles:(NSArray *)files
                           withSave:(BOOL)save
                         withReload:(BOOL)reloading
                            onChain:(DSChain *)chain
                          inContext:(NSManagedObjectContext *)context
                  blockHeightLookup:(BlockHeightFinder)blockHeightLookup
                         completion:(void (^)(BOOL success, NSDictionary *masternodeLists))completion {
    // doing this none recursively for profiler
    __block DSMasternodeList *nextBaseMasternodeList = nil;
    __block NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    __block dispatch_group_t dispatch_group = dispatch_group_create();
    dispatch_group_enter(dispatch_group);
    __block BOOL stop = FALSE;
    for (NSString *file in files) {
        NSData *message = [DSDeterministicMasternodeListTests messageFromFileWithPath:file];
        NSLog(@"---> loadMasternodeListsForFiles: %@", file);
        NSUInteger length = message.length;
        NSUInteger offset = 0;
        if (length - offset < 32) return;
        __unused UInt256 baseBlockHash = [message readUInt256AtOffset:&offset];
        if (length - offset < 32) return;
        UInt256 blockHash = [message readUInt256AtOffset:&offset];
        __block dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        dispatch_group_enter(dispatch_group);
        DSMasternodeProcessorContext *mndiffContext = [[DSMasternodeProcessorContext alloc] init];
        [mndiffContext setIsFromSnapshot:YES];
        [mndiffContext setUseInsightAsBackup:NO];
        [mndiffContext setChain:chain];
        [mndiffContext setMerkleRootLookup:^UInt256(UInt256 blockHash) {
            return UINT256_ZERO;
        }];

        [mndiffContext setMasternodeListLookup:^DSMasternodeList *_Nonnull(UInt256 blockHash) {
            if (save && reloading) {
                return [chain.chainManager.masternodeManager masternodeListForBlockHash:blockHash];
            } else {
                return [dictionary objectForKey:uint256_data(blockHash)]; // no known previous lists
            }
        }];
        [mndiffContext setBlockHeightLookup:blockHeightLookup];

        DSMasternodeManager *masternodeManager = chain.chainManager.masternodeManager;
        DSMnDiffProcessingResult *result = [masternodeManager processMasternodeDiffFromFile:message protocolVersion:DEFAULT_CHECKPOINT_PROTOCOL_VERSION withContext:mndiffContext];
        XCTAssert(result.foundCoinbase, @"Did not find coinbase at height %u", blockHeightLookup(blockHash));
        // turned off on purpose as we don't have the coinbase block
        // XCTAssert(result.validCoinbase,@"Coinbase not valid at height %u",[chain heightForBlockHash:blockHash]);
        XCTAssert(result.rootMNListValid, @"rootMNListValid not valid at height %u", blockHeightLookup(blockHash));
        XCTAssert(result.rootQuorumListValid, @"rootQuorumListValid not valid at height %u", blockHeightLookup(blockHash));
        XCTAssert(result.validQuorums, @"validQuorums not valid at height %u", blockHeightLookup(blockHash));
        DSMasternodeList *masternodeList = result.masternodeList;
        if ([result isValid]) {
            if (reloading || save) {
                dispatch_group_enter(dispatch_group);
                dispatch_semaphore_t sem = dispatch_semaphore_create(0);
                [DSMasternodeManager saveMasternodeList:masternodeList
                                                toChain:chain
                              havingModifiedMasternodes:result.modifiedMasternodes
                                    createUnknownBlocks:YES
                                              inContext:context
                                             completion:^(NSError *_Nonnull error) {
                                                 NSAssert(!error, @"There should not be an error");
                                                 dispatch_semaphore_signal(sem);
                                                 dispatch_group_leave(dispatch_group);
                                             }];
                dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            }

            if (reloading) {
                DSMasternodeList *masternodeListNew = masternodeList;
                DSMasternodeList *masternodeListOld = nextBaseMasternodeList;
                [masternodeManager reloadMasternodeListsWithBlockHeightLookup:blockHeightLookup]; // simulate that we turned off the phone
                DSMasternodeList *reloadedMasternodeListNew = [chain.chainManager.masternodeManager masternodeListForBlockHash:masternodeListNew.blockHash];
                if (masternodeListOld) {
                    DSMasternodeList *reloadedMasternodeListOld = [chain.chainManager.masternodeManager masternodeListForBlockHash:masternodeListOld.blockHash];
                    NSArray *reloadedHashes = [reloadedMasternodeListOld hashesForMerkleRootWithBlockHeightLookup:blockHeightLookup];
                    NSArray *hashes = [masternodeListOld hashesForMerkleRootWithBlockHeightLookup:blockHeightLookup];
                    if (![reloadedHashes isEqualToArray:hashes]) {
                        NSMutableSet *reloadedSet = [NSMutableSet setWithArray:reloadedHashes];
                        NSMutableSet *originalSet = [NSMutableSet setWithArray:hashes];
                        NSMutableSet *intersection = [reloadedSet mutableCopy];
                        [intersection intersectSet:originalSet];
                        NSMutableSet *missing = [originalSet mutableCopy];
                        [missing minusSet:intersection];
                        NSMutableSet *appeared = [reloadedSet mutableCopy];
                        [appeared minusSet:intersection];
                    }
                    XCTAssertEqualObjects(reloadedMasternodeListNew.providerTxOrderedHashes, masternodeListNew.providerTxOrderedHashes);
                    XCTAssertEqualObjects(reloadedMasternodeListOld.providerTxOrderedHashes, masternodeListOld.providerTxOrderedHashes);
                    XCTAssertEqualObjects(reloadedHashes, hashes);
                    XCTAssertEqualObjects(uint256_data([reloadedMasternodeListOld calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup]), uint256_data([masternodeListOld calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup]), @"");
                }
                XCTAssertEqualObjects(uint256_data([reloadedMasternodeListNew calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup]), uint256_data([masternodeListNew calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup]), @"");
            }
            dictionary[uint256_data(masternodeList.blockHash)] = masternodeList;
            nextBaseMasternodeList = masternodeList;
        } else {
            dictionary[uint256_data(masternodeList.blockHash)] = masternodeList;
            stop = TRUE;
        }
        dispatch_semaphore_signal(sem);
        dispatch_group_leave(dispatch_group);
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        if (stop) {
            dispatch_group_leave(dispatch_group);
            return;
        }
    }
    if (!stop) {
        dispatch_group_leave(dispatch_group);
    }
    dispatch_group_notify(dispatch_group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        completion(!stop, dictionary);
    });
}

- (void)testMainnetMasternodeSaving {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:@"ML1100000" ofType:@"dat"];
    NSData *message = [NSData dataWithContentsOfFile:filePath];
    //    NSData *message = [DSDeterministicMasternodeListTests messageFromFileWithPath:@"ML1100000"];

    DSChain *chain = [DSChain mainnet];

    NSUInteger length = message.length;
    NSUInteger offset = 0;

    if (length - offset < 32) return;
    UInt256 baseBlockHash = [message readUInt256AtOffset:&offset];
    if (length - offset < 32) return;
    UInt256 blockHash = [message readUInt256AtOffset:&offset];

    NSLog(@"baseBlockHash %@ (%u) blockHash %@ (%u)", uint256_reverse_hex(baseBlockHash), [chain heightForBlockHash:baseBlockHash], uint256_reverse_hex(blockHash), [chain heightForBlockHash:blockHash]);

    XCTAssert(uint256_eq(chain.genesisHash, baseBlockHash) || uint256_is_zero(baseBlockHash), @"Base block hash should be from chain origin");

    DSMasternodeProcessorContext *mndiffContext = [[DSMasternodeProcessorContext alloc] init];
    [mndiffContext setIsFromSnapshot:YES];
    [mndiffContext setUseInsightAsBackup:NO];
    [mndiffContext setChain:chain];
    [mndiffContext setMasternodeListLookup:^DSMasternodeList *_Nonnull(UInt256 blockHash) {
        return nil;
    }];
    [mndiffContext setMerkleRootLookup:^UInt256(UInt256 blockHash) {
        return UINT256_ZERO;
    }];
    [mndiffContext setBlockHeightLookup:^uint32_t(UInt256 blockHash) {
        return 1100000;
    }];
    DSMnDiffProcessingResult *result = [chain.chainManager.masternodeManager processMasternodeDiffFromFile:message protocolVersion:DEFAULT_CHECKPOINT_PROTOCOL_VERSION withContext:mndiffContext];
    XCTAssert(result.foundCoinbase, @"Did not find coinbase at height %u", [chain heightForBlockHash:blockHash]);
    // turned off on purpose as we don't have the coinbase block
    // XCTAssert(result.validCoinbase,@"Coinbase not valid at height %u",[chain heightForBlockHash:blockHash]);
    XCTAssert(result.rootMNListValid, @"rootMNListValid not valid at height %u", [chain heightForBlockHash:blockHash]);
    XCTAssert(result.rootQuorumListValid, @"rootQuorumListValid not valid at height %u", [chain heightForBlockHash:blockHash]);
    XCTAssert(result.validQuorums, @"validQuorums not valid at height %u", [chain heightForBlockHash:blockHash]);
    if ([result isValid]) {
        NSLog(@"Valid masternode list found at height %u", [chain heightForBlockHash:blockHash]);
        // yay this is the correct masternode list verified deterministically for the given block
        NSManagedObjectContext *context = [NSManagedObjectContext chainContext];
        [context performBlockAndWait:^{
            DSChainEntity *chainEntity = [chain chainEntityInContext:context];
            [DSSimplifiedMasternodeEntryEntity deleteAllOnChainEntity:chainEntity];
            [DSQuorumEntryEntity deleteAllOnChainEntity:chainEntity];
            [DSMasternodeListEntity deleteAllOnChainEntity:chainEntity];
            [DSQuorumSnapshotEntity deleteAllOnChainEntity:chainEntity];
        }];
        [DSMasternodeManager saveMasternodeList:result.masternodeList
                                        toChain:chain
                      havingModifiedMasternodes:result.modifiedMasternodes
                            createUnknownBlocks:YES
                                      inContext:context
                                     completion:^(NSError *_Nonnull error) {
                                         NSAssert(!error, @"There should not be an error");
                                     }];
    }
}


- (void)testMNLSavingToDisk {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:@"ML_at_122088" ofType:@"dat"];
    NSData *message = [NSData dataWithContentsOfFile:filePath];

    DSChain *chain = [DSChain testnet];

    NSUInteger length = message.length;
    NSUInteger offset = 0;

    if (length - offset < 32) return;
    UInt256 baseBlockHash = [message readUInt256AtOffset:&offset];
    if (length - offset < 32) return;
    UInt256 blockHash = [message readUInt256AtOffset:&offset];

    NSLog(@"baseBlockHash %@ (%u) blockHash %@ (%u)", uint256_reverse_hex(baseBlockHash), [chain heightForBlockHash:baseBlockHash], uint256_reverse_hex(blockHash), [chain heightForBlockHash:blockHash]);

    //    XCTAssert(uint256_eq(chain.genesisHash, baseBlockHash) || uint256_is_zero(baseBlockHash),@"Base block hash should be from chain origin");
    DSMasternodeProcessorContext *mndiffContext = [[DSMasternodeProcessorContext alloc] init];
    [mndiffContext setIsFromSnapshot:YES];
    [mndiffContext setUseInsightAsBackup:NO];
    [mndiffContext setChain:chain];
    [mndiffContext setMasternodeListLookup:^DSMasternodeList *_Nonnull(UInt256 blockHash) {
        return nil;
    }];
    [mndiffContext setMerkleRootLookup:^UInt256(UInt256 blockHash) {
        return UINT256_ZERO;
    }];
    [mndiffContext setBlockHeightLookup:^uint32_t(UInt256 blockHash) {
        return 122088;
    }];
    DSMnDiffProcessingResult *result = [chain.chainManager.masternodeManager processMasternodeDiffFromFile:message protocolVersion:DEFAULT_CHECKPOINT_PROTOCOL_VERSION withContext:mndiffContext];
    NSData *masternodeListMerkleRoot = @"94d0af97187af3b9311c98b1cf40c9c9849df0af55dc63b097b80d4cf6c816c5".hexToData;
    DSMasternodeList *masternodeList = result.masternodeList;
    BOOL equal = uint256_eq(masternodeListMerkleRoot.UInt256, [masternodeList masternodeMerkleRoot]);
    XCTAssert(equal, @"MNList merkle root should be valid");
    XCTAssert(result.foundCoinbase, @"Did not find coinbase at height %u", [chain heightForBlockHash:blockHash]);
    //        XCTAssert(validCoinbase,@"Coinbase not valid at height %u",[chain heightForBlockHash:blockHash]); //turned off on purpose as we don't have the coinbase block
    XCTAssert(result.rootMNListValid, @"rootMNListValid not valid at height %u", [chain heightForBlockHash:blockHash]);
    XCTAssert(result.rootQuorumListValid, @"rootQuorumListValid not valid at height %u", [chain heightForBlockHash:blockHash]);
    XCTAssert(result.validQuorums, @"validQuorums not valid at height %u", [chain heightForBlockHash:blockHash]);
    if ([result isValid]) {
        NSLog(@"Valid masternode list found at height %u", [chain heightForBlockHash:blockHash]);
        // yay this is the correct masternode list verified deterministically for the given block
        NSManagedObjectContext *context = [NSManagedObjectContext chainContext];
        [context performBlockAndWait:^{
            DSChainEntity *chainEntity = [chain chainEntityInContext:context];
            [DSSimplifiedMasternodeEntryEntity deleteAllOnChainEntity:chainEntity];
            [DSQuorumEntryEntity deleteAllOnChainEntity:chainEntity];
            [DSMasternodeListEntity deleteAllOnChainEntity:chainEntity];
            [DSQuorumSnapshotEntity deleteAllOnChainEntity:chainEntity];
        }];
        [DSMasternodeManager saveMasternodeList:masternodeList
                                        toChain:chain
                      havingModifiedMasternodes:result.modifiedMasternodes
                            createUnknownBlocks:YES
                                      inContext:context
                                     completion:^(NSError *_Nonnull error) {
                                         NSAssert(!error, @"There should not be an error");
                                     }];
    }
}

- (void)testMNLSavingAndRetrievingFromDisk {
    DSChainManager *chainManager = [[DSChainsManager sharedInstance] testnetManager];
    DSChain *chain = chainManager.chain;
    NSData *message = [DSDeterministicMasternodeListTests messageFromFileWithPath:@"MNL_0_122064"];

    __block NSManagedObjectContext *context = [NSManagedObjectContext chainContext];
    [context performBlockAndWait:^{
        DSChainEntity *chainEntity = [chain chainEntityInContext:context];
        [DSSimplifiedMasternodeEntryEntity deleteAllOnChainEntity:chainEntity];
        [DSQuorumEntryEntity deleteAllOnChainEntity:chainEntity];
        [DSMasternodeListEntity deleteAllOnChainEntity:chainEntity];
        [DSQuorumSnapshotEntity deleteAllOnChainEntity:chainEntity];
    }];

    NSUInteger length = message.length;
    NSUInteger offset = 0;

    if (length - offset < 32) return;
    UInt256 baseBlockHash = [message readUInt256AtOffset:&offset];
    if (length - offset < 32) return;
    __block UInt256 blockHash122064 = [message readUInt256AtOffset:&offset];

    NoTimeLog(@"baseBlockHash %@ (%u) blockHash %@ (%u)", uint256_reverse_hex(baseBlockHash), [chain heightForBlockHash:baseBlockHash], uint256_reverse_hex(blockHash122064), [chain heightForBlockHash:blockHash122064]);

    XCTAssert(uint256_eq(chain.genesisHash, baseBlockHash) || uint256_is_zero(baseBlockHash), @"Base block hash should be from chain origin");

    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];

    uint32_t (^blockHeightLookup122064)(UInt256 blockHash) = ^uint32_t(UInt256 blockHash) {
        NoTimeLog(@"blockHeightLookup122064: %@: %@", uint256_hex(blockHash), uint256_reverse_hex(blockHash));
        if uint256_eq(chain.genesisHash, blockHash) {
            return 0;
        } else {
            return 122064;
        }
    };

    DSMasternodeProcessorContext *mndiffContext = [[DSMasternodeProcessorContext alloc] init];
    [mndiffContext setIsFromSnapshot:YES];
    [mndiffContext setUseInsightAsBackup:NO];
    [mndiffContext setChain:chain];
    [mndiffContext setMasternodeListLookup:^DSMasternodeList *_Nonnull(UInt256 blockHash) {
        return nil;
    }];
    [mndiffContext setMerkleRootLookup:^UInt256(UInt256 blockHash) {
        return @"ac841d3551d012e8ce5fbec60217043209317b50268d1c3717d79350d23fd593".hexToData.reverse.UInt256;
    }];
    [mndiffContext setBlockHeightLookup:blockHeightLookup122064];
    DSMnDiffProcessingResult *result = [chainManager.masternodeManager processMasternodeDiffFromFile:message protocolVersion:DEFAULT_CHECKPOINT_PROTOCOL_VERSION withContext:mndiffContext];
    DSMasternodeList *masternodeList122064 = result.masternodeList;
    XCTAssert(result.foundCoinbase, @"Did not find coinbase at height %u", [chain heightForBlockHash:blockHash122064]);
    // turned off on purpose as we don't have the coinbase block
     XCTAssert(result.validCoinbase, @"Coinbase not valid at height %u", [chain heightForBlockHash:blockHash122064]);
    XCTAssert(result.rootMNListValid, @"rootMNListValid not valid at height %u", [chain heightForBlockHash:blockHash122064]);
    XCTAssert(result.rootQuorumListValid, @"rootQuorumListValid not valid at height %u", [chain heightForBlockHash:blockHash122064]);
    XCTAssert(result.validQuorums, @"validQuorums not valid at height %u", [chain heightForBlockHash:blockHash122064]);
    XCTAssertEqualObjects(uint256_data([masternodeList122064 calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup122064]).hexString, @"86cfe9b759dfd012f8d00e980c560c5c1d9c487bfa8b59305e14c7fc60ef1150", @"");
    if ([result isValid]) {
        // yay this is the correct masternode list verified deterministically for the given block
        NoTimeLog(@"------- MasternodeList 122064 ------- %lu", [result.modifiedMasternodes count]);
        for (NSData *hash in result.modifiedMasternodes) {
            DSSimplifiedMasternodeEntry *simplifiedMasternodeEntry = result.modifiedMasternodes[hash];
            NoTimeLog(@"modified1: %@: %@ (%@)", hash.hexString, uint256_hex(simplifiedMasternodeEntry.simplifiedMasternodeEntryHash), simplifiedMasternodeEntry.previousSimplifiedMasternodeEntryHashes);
        }
        [DSMasternodeManager saveMasternodeList:masternodeList122064
                                        toChain:chain
                      havingModifiedMasternodes:result.modifiedMasternodes
                            createUnknownBlocks:YES
                                      inContext:context
                                     completion:^(NSError *_Nonnull error) {
            NSData *message = [DSDeterministicMasternodeListTests messageFromFileWithPath:@"MNL_122064_122088"];
            NSUInteger length = message.length;
            NSUInteger offset = 0;
            if (length - offset < 32) return;
            UInt256 baseBlockHash = [message readUInt256AtOffset:&offset];
            if (length - offset < 32) return;
            UInt256 blockHash = [message readUInt256AtOffset:&offset];
            NoTimeLog(@"baseBlockHash %@ (%u) blockHash %@ (%u)", uint256_reverse_hex(baseBlockHash), [chain heightForBlockHash:baseBlockHash], uint256_reverse_hex(blockHash), [chain heightForBlockHash:blockHash]);
            XCTAssert(uint256_eq(blockHash122064, baseBlockHash), @"Base block hash should be from block 122064");
            uint32_t (^blockHeightLookup122088)(UInt256 blockHash) = ^uint32_t(UInt256 blockHash) {
                return uint256_eq(chain.genesisHash, blockHash) ? 0 : 122088;
            };
            DSMasternodeProcessorContext *mndiffContext = [[DSMasternodeProcessorContext alloc] init];
            [mndiffContext setIsFromSnapshot:YES];
            [mndiffContext setUseInsightAsBackup:NO];
            [mndiffContext setChain:chain];
            [mndiffContext setMerkleRootLookup:^UInt256(UInt256 blockHash) {
                return @"6574ae2c1e712431ba43b23130fc426030c951c32a8fb73102adcfa1860fb000".hexToData.reverse.UInt256;
            }];
            [mndiffContext setMasternodeListLookup:^DSMasternodeList *_Nonnull(UInt256 blockHash) {
                if (uint256_eq(blockHash, masternodeList122064.blockHash)) {
                    return masternodeList122064;
                } else {
                    return nil;
                }
            }];
            [mndiffContext setBlockHeightLookup:blockHeightLookup122088];
            DSMnDiffProcessingResult *result122088 = [chainManager.masternodeManager processMasternodeDiffFromFile:message protocolVersion:DEFAULT_CHECKPOINT_PROTOCOL_VERSION withContext:mndiffContext];
            XCTAssert(result122088.foundCoinbase, @"Did not find coinbase at height %u", [chain heightForBlockHash:blockHash]);
            XCTAssert(result122088.validCoinbase, @"Coinbase not valid at height %u",[chain heightForBlockHash:blockHash]); //turned off on purpose as we don't have the coinbase block
            XCTAssert(result122088.rootMNListValid, @"rootMNListValid not valid at height %u", [chain heightForBlockHash:blockHash]);
            XCTAssert(result122088.rootQuorumListValid, @"rootQuorumListValid not valid at height %u", [chain heightForBlockHash:blockHash]);
            XCTAssert(result122088.validQuorums, @"validQuorums not valid at height %u", [chain heightForBlockHash:blockHash]);
            // BOOL equal = uint256_eq(masternodeListMerkleRoot.UInt256, [masternodeList masternodeMerkleRoot]);
            // XCTAssert(equal, @"MNList merkle root should be valid");
            DSMasternodeList *masternodeList122088 = result122088.masternodeList;
            NoTimeLog(@"------- MasternodeList 122088 ------- %lu", [result122088.modifiedMasternodes count]);
            for (NSData *hash in result122088.modifiedMasternodes) {
                DSSimplifiedMasternodeEntry *simplifiedMasternodeEntry = result122088.modifiedMasternodes[hash];
                NoTimeLog(@"modified2: %@: %@ (%@)", hash.hexString, uint256_hex(simplifiedMasternodeEntry.simplifiedMasternodeEntryHash), simplifiedMasternodeEntry.previousSimplifiedMasternodeEntryHashes);
            }
            [DSMasternodeManager saveMasternodeList:masternodeList122088
                                            toChain:chain
                          havingModifiedMasternodes:result122088.modifiedMasternodes
                                createUnknownBlocks:YES
                                          inContext:context
                                         completion:^(NSError *_Nonnull error) {
                NoTimeLog(@"------- RELOAD.START -------");
                [chainManager.masternodeManager reloadMasternodeLists];
                NoTimeLog(@"------- RELOAD.FINISH -------");
                DSMasternodeList *reloadedMasternodeList122088 = [chainManager.masternodeManager masternodeListForBlockHash:masternodeList122088.blockHash];
                DSMasternodeList *reloadedMasternodeList122064 = [chainManager.masternodeManager masternodeListForBlockHash:masternodeList122064.blockHash];
                DSSimplifiedMasternodeEntry *originalEntryFrom122088 = [[masternodeList122088 simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash] objectForKey:@"1bde434d4f68064d3108a09443ea45b4a6c6ac1f537a533efc36878cef2eb10f".hexToData.reverse]; // this is the entry that changed
                DSSimplifiedMasternodeEntry *originalEntryFrom122064 = [[masternodeList122064 simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash] objectForKey:@"1bde434d4f68064d3108a09443ea45b4a6c6ac1f537a533efc36878cef2eb10f".hexToData.reverse]; // this is the entry that changed
                // They are currently not equal
                XCTAssertNotEqual(originalEntryFrom122088, originalEntryFrom122064, @"These should NOT be the same object (unless we changed how this worked)");
                XCTAssertEqualObjects([originalEntryFrom122088.previousSimplifiedMasternodeEntryHashes allValues], @[@"14d8f2de996a2515815abeb8f111a3ffe8582443ce7a43a8399c1a1c86c65543".hexToData], @"This is what it used to be");
                XCTAssertEqualObjects(uint256_hex(originalEntryFrom122064.simplifiedMasternodeEntryHash), @"14d8f2de996a2515815abeb8f111a3ffe8582443ce7a43a8399c1a1c86c65543", @"The hash of the sme should be this");
                XCTAssertEqualObjects(uint256_hex(originalEntryFrom122088.simplifiedMasternodeEntryHash), @"e001033590361b172da9cb352f9736dbe9453c6a389068f7b76d71f9f3044d3b", @"The hash changed to this");
                DSSimplifiedMasternodeEntry *reloadedEntryFrom122064 = [[reloadedMasternodeList122064 simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash] objectForKey:@"1bde434d4f68064d3108a09443ea45b4a6c6ac1f537a533efc36878cef2eb10f".hexToData.reverse]; // this is the entry that changed
                DSSimplifiedMasternodeEntry *reloadedEntryFrom122088 = [[reloadedMasternodeList122088 simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash] objectForKey:@"1bde434d4f68064d3108a09443ea45b4a6c6ac1f537a533efc36878cef2eb10f".hexToData.reverse]; // this is the entry that changed
                XCTAssertNotEqual(reloadedEntryFrom122088, reloadedEntryFrom122064, @"These should be the same object");
                XCTAssertEqualObjects(uint256_hex(reloadedEntryFrom122064.simplifiedMasternodeEntryHash), @"e001033590361b172da9cb352f9736dbe9453c6a389068f7b76d71f9f3044d3b", @"The hash should remain on this");
                XCTAssertEqualObjects([reloadedEntryFrom122064.previousSimplifiedMasternodeEntryHashes allValues], @[@"14d8f2de996a2515815abeb8f111a3ffe8582443ce7a43a8399c1a1c86c65543".hexToData], @"This is what it used to be");
                NSArray *localProTxHashes122088 = [masternodeList122088.simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash allKeys];
                localProTxHashes122088 = [localProTxHashes122088 sortedArrayUsingComparator:^NSComparisonResult(NSData *_Nonnull obj1, NSData *_Nonnull obj2) {
                    return uint256_sup((*(UInt256 *)obj1.bytes), (*(UInt256 *)obj2.bytes)) ? NSOrderedDescending : NSOrderedAscending;
                }];
                NSArray *proTxHashes122088 = [reloadedMasternodeList122088.simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash allKeys];
                proTxHashes122088 = [proTxHashes122088 sortedArrayUsingComparator:^NSComparisonResult(NSData *_Nonnull obj1, NSData *_Nonnull obj2) {
                    return uint256_sup((*(UInt256 *)obj1.bytes), (*(UInt256 *)obj2.bytes)) ? NSOrderedDescending : NSOrderedAscending;
                }];
                XCTAssertEqualObjects(localProTxHashes122088, proTxHashes122088);
                NSArray *localProTxHashes122064 = [masternodeList122064.simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash allKeys];
                localProTxHashes122064 = [localProTxHashes122064 sortedArrayUsingComparator:^NSComparisonResult(NSData *_Nonnull obj1, NSData *_Nonnull obj2) {
                    return uint256_sup((*(UInt256 *)obj1.bytes), (*(UInt256 *)obj2.bytes)) ? NSOrderedDescending : NSOrderedAscending;
                }];
                NSArray *proTxHashes122064 = [reloadedMasternodeList122064.simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash allKeys];
                proTxHashes122064 = [proTxHashes122064 sortedArrayUsingComparator:^NSComparisonResult(NSData *_Nonnull obj1, NSData *_Nonnull obj2) {
                    return uint256_sup((*(UInt256 *)obj1.bytes), (*(UInt256 *)obj2.bytes)) ? NSOrderedDescending : NSOrderedAscending;
                }];
                XCTAssertEqualObjects(localProTxHashes122064, proTxHashes122064);
                NSArray *simplifiedMasternodeListDictionaryByRegistrationTransactionHashHashes = [localProTxHashes122064 map:^(NSData *proTxHash) {
                    DSSimplifiedMasternodeEntry *simplifiedMasternodeEntry = [reloadedMasternodeList122064.simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash objectForKey:proTxHash];
                    return uint256_data(simplifiedMasternodeEntry.simplifiedMasternodeEntryHash);
                }];
                NSArray *reloadedSimplifiedMasternodeListDictionaryByRegistrationTransactionHashHashes = [proTxHashes122064 map:^(NSData *proTxHash) {
                    DSSimplifiedMasternodeEntry *simplifiedMasternodeEntry = [reloadedMasternodeList122064.simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash objectForKey:proTxHash];
                    return uint256_data(simplifiedMasternodeEntry.simplifiedMasternodeEntryHash);
                }];
                XCTAssertEqualObjects(simplifiedMasternodeListDictionaryByRegistrationTransactionHashHashes, reloadedSimplifiedMasternodeListDictionaryByRegistrationTransactionHashHashes);
                XCTAssertEqualObjects(reloadedMasternodeList122064.providerTxOrderedHashes, masternodeList122064.providerTxOrderedHashes);
                
                
                NSArray *entries_122064 = [[masternodeList122064 simplifiedMasternodeEntries] sortedArrayUsingComparator:^NSComparisonResult(DSSimplifiedMasternodeEntry *_Nonnull obj1, DSSimplifiedMasternodeEntry *_Nonnull obj2) {
                    return uint256_sup(obj1.providerRegistrationTransactionHash, obj2.providerRegistrationTransactionHash) ? NSOrderedDescending : NSOrderedAscending;
                }];
                NSArray *reloaded_entries_122064 = [[reloadedMasternodeList122064 simplifiedMasternodeEntries] sortedArrayUsingComparator:^NSComparisonResult(DSSimplifiedMasternodeEntry *_Nonnull obj1, DSSimplifiedMasternodeEntry *_Nonnull obj2) {
                    return uint256_sup(obj1.providerRegistrationTransactionHash, obj2.providerRegistrationTransactionHash) ? NSOrderedDescending : NSOrderedAscending;
                }];

//                MasternodeEntry::new: entry_hash: 9e67c27bfe4555794fb439c6bf5b3e0ea4b70eb17c25e395ed6054ef5510765b
//                (2dca894a2b5af0bf82abf0cfba978555f41a669278b6e91ca14c0593beaf2200,
//                 76f5ce05c6c2a6de5d8a69c23a56f19dfc8f5f357c9457adf560f0f60b000000,
//                 SocketAddress { ip_address: 00000000000000000000ffffae22e96e, port: 19999 },
//                 94b7723262031b6cd2e79b07f36a794d3e684c538a6f2418fff01c027fab1ca4663ab0b92670ee1797fa71d8676362a0,
//                 404e7c7d61d784c76c0130e13804ff18a98ad1a3,
//                 0)
//
//                MasternodeEntry::new: entry_hash: c26dee2679812dd47f2e44be1010afdb18e102389d656e62201d6ae591dd242e
//                (2dca894a2b5af0bf82abf0cfba978555f41a669278b6e91ca14c0593beaf2200,
//                 76f5ce05c6c2a6de5d8a69c23a56f19dfc8f5f357c9457adf560f0f60b000000,
//                 SocketAddress { ip_address: 00000000000000000000ffffad3d1ee7, port: 19015 },
//                 94b7723262031b6cd2e79b07f36a794d3e684c538a6f2418fff01c027fab1ca4663ab0b92670ee1797fa71d8676362a0,
//                 ed8648ca7d2813a5bf93338e12d05db2e07d4d8c,
//                 0)

                
                NoTimeLog(@"------ INITIALIZED ------");
                for (DSSimplifiedMasternodeEntry *e in entries_122064) {
                    NoTimeLog(@"%@: %@: %@", uint256_hex(e.providerRegistrationTransactionHash), uint256_hex(e.simplifiedMasternodeEntryHash), e.previousSimplifiedMasternodeEntryHashes);
                }
                NoTimeLog(@"------ RELOADED ------");
                for (DSSimplifiedMasternodeEntry *e in reloaded_entries_122064) {
                    NoTimeLog(@"%@: %@: %@", uint256_hex(e.providerRegistrationTransactionHash), uint256_hex(e.simplifiedMasternodeEntryHash), e.previousSimplifiedMasternodeEntryHashes);
                }

                
                NSArray<NSData *> *reloadedHashesFrom122064 = [reloadedMasternodeList122064 hashesForMerkleRootWithBlockHeightLookup:blockHeightLookup122064];
                NSArray<NSData *> *hashesFrom122064 = [masternodeList122064 hashesForMerkleRootWithBlockHeightLookup:blockHeightLookup122088];
                NoTimeLog(@"------ INITIALIZED ------");
                for (NSData *h in hashesFrom122064) {
                    NoTimeLog(@"%@", h.hexString);
                }
                NoTimeLog(@"------ RELOADED ------");
                for (NSData *h in reloadedHashesFrom122064) {
                    NoTimeLog(@"%@", h.hexString);
                }
                NoTimeLog(@"------ -------- ------");
                XCTAssertEqualObjects(reloadedHashesFrom122064, hashesFrom122064, @"Hashes for merkle root calculation are not equal");
                
                UInt256 reloadedmnMerkleRoot_122088 = [reloadedMasternodeList122088 calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup122088];
                UInt256 mnMerkleRoot_122088 = [masternodeList122088 calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup122088];
                UInt256 reloadedmnMerkleRoot_122064 = [reloadedMasternodeList122064 calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup122064];
                UInt256 mnMerkleRoot_122064 = [masternodeList122064 calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup122064];
                UInt256 mnMerkleRoot_122064_122088 = [masternodeList122064 calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup122088];

                XCTAssertEqualObjects(uint256_hex(reloadedmnMerkleRoot_122088), uint256_hex(mnMerkleRoot_122088), @"");
                XCTAssertEqualObjects(uint256_hex(reloadedmnMerkleRoot_122064), uint256_hex(mnMerkleRoot_122064), @"");
                XCTAssertEqualObjects(uint256_hex(mnMerkleRoot_122064_122088), @"86cfe9b759dfd012f8d00e980c560c5c1d9c487bfa8b59305e14c7fc60ef1150", @"");
                [expectation fulfill];
            }];
        }];
    }
    [self waitForExpectations:@[expectation] timeout:10];
}

- (void)testSimplifiedMasternodeEntriesDeletion {
    DSChain *chain = [DSChain mainnet];
    __block NSManagedObjectContext *context = [NSManagedObjectContext viewContext];
    [context performBlockAndWait:^{
        NSUInteger count = [DSSimplifiedMasternodeEntryEntity countObjectsInContext:context matching:@"masternodeLists.@count == 0"];
        NSLog(@"Deleting %lu objects", (unsigned long)count);
    }];
    [[chain.chainManager masternodeManager] setUp];
    [context performBlockAndWait:^{
        NSUInteger count = [DSSimplifiedMasternodeEntryEntity countObjectsInContext:context matching:@"masternodeLists.@count == 0"];
        NSLog(@"has %lu objects", (unsigned long)count);
    }];

    [context performBlockAndWait:^{
        UInt256 hash = UINT256_ZERO;
        DSChainEntity *chainEntity = [chain chainEntityInContext:context];
        for (int i = 0; i < 1000; i++) {
            hash = [NSData dataWithUInt256:hash].SHA256;
            UInt256 confirmedHash = [NSData dataWithUInt256:hash].SHA256;
            UInt128 address = UINT128_ZERO;
            *address.u16 = i;
            DSSimplifiedMasternodeEntry *entry = [DSSimplifiedMasternodeEntry simplifiedMasternodeEntryWithProviderRegistrationTransactionHash:hash confirmedHash:confirmedHash address:address port:9999 operatorBLSPublicKey:UINT384_ZERO operatorPublicKeyVersion:0 previousOperatorBLSPublicKeys:@{} keyIDVoting:UINT160_ZERO isValid:YES type:0 platformHTTPPort:0 platformNodeID: UINT160_ZERO previousValidity:@{} knownConfirmedAtHeight:50 updateHeight:100 simplifiedMasternodeEntryHash:UINT256_ZERO previousSimplifiedMasternodeEntryHashes:@{} onChain:chain];
            DSSimplifiedMasternodeEntryEntity *managedObject = [DSSimplifiedMasternodeEntryEntity managedObjectInBlockedContext:context];
            [managedObject setAttributesFromSimplifiedMasternodeEntry:entry atBlockHeight:100 onChainEntity:chainEntity];
        }
        [context ds_save];
    }];

    [context performBlockAndWait:^{
        NSUInteger count = [DSSimplifiedMasternodeEntryEntity countObjectsInContext:context matching:@"masternodeLists.@count == 0"];
        NSLog(@"Deleting %lu objects", (unsigned long)count);
    }];
    [[chain.chainManager masternodeManager] setUp];
    [context performBlockAndWait:^{
        NSUInteger count = [DSSimplifiedMasternodeEntryEntity countObjectsInContext:context matching:@"masternodeLists.@count == 0"];
        NSLog(@"has %lu objects", (unsigned long)count);
    }];
}

- (void)createBlockHeightLookups {
    DSChain *chain = [DSChain testnet];
    __block NSManagedObjectContext *context = [NSManagedObjectContext chainContext];
    NSArray *files = @[@"MNL_0_122928"];

    __block NSMutableSet *blockHashes = [NSMutableSet set];
    for (NSString *file in files) {
        NSData *message = [DSDeterministicMasternodeListTests messageFromFileWithPath:file];

        NSUInteger length = message.length;
        NSUInteger offset = 0;

        if (length - offset < 32) return;
        __unused UInt256 baseBlockHash = [message readUInt256AtOffset:&offset];
        if (length - offset < 32) return;
        UInt256 blockHash = [message readUInt256AtOffset:&offset];
        [blockHashes addObject:uint256_data(blockHash).reverse];
    }
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);

    [self loadMasternodeListsForFiles:files
        withSave:NO
        withReload:NO
        onChain:chain
        inContext:context
        blockHeightLookup:^uint32_t(UInt256 blockHash) {
            [blockHashes addObject:uint256_data(blockHash).reverse];
            return UINT32_MAX;
        }
        completion:^(BOOL success, NSDictionary *masternodeLists) {
            [[DSInsightManager sharedInstance] blockHeightsForBlockHashes:[blockHashes allObjects]
                                                                  onChain:chain
                                                               completion:^(NSDictionary *_Nonnull blockHeightDictionary, NSError *_Null_unspecified error) {
                                                                   NSLog(@"%@", blockHeightDictionary);
                                                                   XCTAssert(blockHeightDictionary);
                                                                   NSMutableArray *mStringArray = [NSMutableArray array];
                                                                   for (NSData *data in blockHeightDictionary) {
                                                                       NSNumber *blockHeight = blockHeightDictionary[data];
                                                                       [mStringArray addObject:[NSString stringWithFormat:@"if ([blockHashString isEqualToString:@\"%@\"]) {\rreturn %d;\r}", data.hexString, blockHeight.unsignedIntValue]];
                                                                   }
                                                                   NSLog(@"%@", [mStringArray componentsJoinedByString:@" else "]);
                                                                   dispatch_semaphore_signal(sem);
                                                               }];
        }];


    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
}

- (void)testMNLMainnetReload {
    DSChain *chain = [DSChain mainnet];
    __block NSManagedObjectContext *context = [NSManagedObjectContext chainContext];
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    [chain chainManager];
    [context performBlockAndWait:^{
        DSChainEntity *chainEntity = [chain chainEntityInContext:context];
        [DSSimplifiedMasternodeEntryEntity deleteAllOnChainEntity:chainEntity];
        [DSQuorumEntryEntity deleteAllOnChainEntity:chainEntity];
        [DSMasternodeListEntity deleteAllOnChainEntity:chainEntity];
        [DSQuorumSnapshotEntity deleteAllOnChainEntity:chainEntity];
    }];
    [chain.chainManager.masternodeManager reloadMasternodeLists];
    NSArray *files = @[@"MNL_0_1090944", @"MNL_1090944_1091520", @"MNL_1091520_1091808", @"MNL_1091808_1092096", @"MNL_1092096_1092336", @"MNL_1092336_1092360", @"MNL_1092360_1092384", @"MNL_1092384_1092408", @"MNL_1092408_1092432", @"MNL_1092432_1092456", @"MNL_1092456_1092480", @"MNL_1092480_1092504", @"MNL_1092504_1092528", @"MNL_1092528_1092552", @"MNL_1092552_1092576", @"MNL_1092576_1092600", @"MNL_1092600_1092624", @"MNL_1092624_1092648", @"MNL_1092648_1092672", @"MNL_1092672_1092696", @"MNL_1092696_1092720", @"MNL_1092720_1092744", @"MNL_1092744_1092768", @"MNL_1092768_1092792", @"MNL_1092792_1092816", @"MNL_1092816_1092840", @"MNL_1092840_1092864", @"MNL_1092864_1092888", @"MNL_1092888_1092916"];

    NSDictionary *blockHeightsDict = @{
        @"00000ffd590b1485b3caadc19b22e6379c733355108f107a430458cdf3407ab6": @0,
        @"000000000000000bf16cfee1f69cd472ac1d0285d74d025caa27cebb0fb6842f": @1090392,
        @"000000000000000d6f921ffd1b48815407c1d54edc93079b7ec37a14a9c528f7": @1090776,
        @"000000000000000c559941d24c167053c5c00aea59b8521f5cef764271dbd3c5": @1091280,
        @"0000000000000003269a36d2ce1eee7753a2d2db392fff364f64f5a409805ca3": @1092840,
        @"000000000000001a505b133ea44b594b194f12fa08650eb66efb579b1600ed1e": @1090368,
        @"0000000000000006998d05eff0f4e9b6a7bab1447534eccb330972a7ef89ef65": @1091424,
        @"000000000000001d9b6925a0bc2b744dfe38ff7da2ca0256aa555bb688e21824": @1090920,
        @"000000000000000c22e2f5ca2113269ec62193e93158558c8932ba1720cea64f": @1092648,
        @"0000000000000020019489504beba1d6197857e63c44da3eb9e3b20a24f40d1e": @1092168,
        @"00000000000000112e41e4b3afda8b233b8cc07c532d2eac5de097b68358c43e": @1088640,
        @"00000000000000143df6e8e78a3e79f4deed38a27a05766ad38e3152f8237852": @1090944,
        @"0000000000000028d39e78ee49a950b66215545163b53331115e6e64d4d80328": @1091184,
        @"00000000000000093b22f6342de731811a5b3fa51f070b7aac6d58390d8bfe8c": @1091664,
        @"00000000000000037187889dd360aafc49d62a7e76f4ab6cd2813fdf610a7292": @1092504,
        @"000000000000000aee08f8aaf8a5232cc692ef5fcc016786af72bd9b001ae43b": @1090992,
        @"000000000000002395b6c4e4cb829556d42c659b585ee4c131a683b9f7e37706": @1092192,
        @"00000000000000048a9b52e6f46f74d92eb9740e27c1d66e9f2eb63293e18677": @1091976,
        @"000000000000001b4d519e0a9215e84c3007597cef6823c8f1c637d7a46778f0": @1091448,
        @"000000000000001730249b150b8fcdb1078cd0dbbfa04fb9a18d26bf7a3e80f2": @1092528,
        @"000000000000001c3073ff2ee0af660c66762af38e2c5782597e32ed690f0f72": @1092072,
        @"000000000000000c49954d58132fb8a1c90e4e690995396be91d8f27a07de349": @1092624,
        @"00000000000000016200a3f98e44f4b9e65da04b86bad799e6bbfa8972f0cead": @1090080,
        @"000000000000000a80933f2b9b8041fdfc6e94b77ba8786e159669f959431ff2": @1092600,
        @"00000000000000153afcdccc3186ad2ca4ed10a79bfb01a2c0056c23fe039d86": @1092456,
        @"00000000000000103bad71d3178a6c9a2f618d9d09419b38e9caee0fddbf664a": @1092864,
        @"000000000000001b732bc6d52faa8fae97d76753c8e071767a37ba509fe5c24a": @1092360,
        @"000000000000001a17f82d76a0d5aa2b4f90a6e487df366d437c34e8453f519c": @1091112,
        @"000000000000000caa00c2c24a385513a1687367157379a57b549007e18869d8": @1090680,
        @"0000000000000022e463fe13bc19a1fe654c817cb3b8e207cdb4ff73fe0bcd2c": @1091736,
        @"000000000000001b33b86b6a167d37e3fcc6ba53e02df3cb06e3f272bb89dd7d": @1092744,
        @"0000000000000006051479afbbb159d722bb8feb10f76b8900370ceef552fc49": @1092432,
        @"0000000000000008cc37827fd700ec82ee8b54bdd37d4db4319496977f475cf8": @1091328,
        @"0000000000000006242af03ba5e407c4e8412ef9976da4e7f0fa2cbe9889bcd2": @1089216,
        @"000000000000001dc4a842ede88a3cc975e2ade4338513d546c52452ab429ba0": @1091496,
        @"0000000000000010d30c51e8ce1730aae836b00cd43f3e70a1a37d40b47580fd": @1092816,
        @"00000000000000212441a8ef2495d21b0b7c09e13339dbc34d98c478cc51f8e2": @1092096,
        @"00000000000000039d7eb80e1bbf6f7f0c43f7f251f30629d858bbcf6a18ab58": @1090728,
        @"0000000000000004532e9c4a1def38cd71f3297c684bfdb2043c2aec173399e0": @1091904,
        @"000000000000000b73060901c41d098b91f69fc4f27aef9d7ed7f2296953e407": @1090560,
        @"0000000000000016659fb35017e1f6560ba7036a3433bfb924d85e3fdfdd3b3d": @1091256,
        @"000000000000000a3c6796d85c8c49b961363ee88f14bff10c374cd8dd89a9f6": @1092696,
        @"000000000000000f33533ba1c5d72f678ecd87abe7e974debda238c53b391737": @1092720,
        @"000000000000000150907537f4408ff4a8610ba8ce2395faa7e44541ce2b6c37": @1090608,
        @"000000000000001977d3a578e0ac3e4969675a74afe7715b8ffd9f29fbbe7c36": @1091400,
        @"0000000000000004493e40518e7d3aff585e84564bcd80927f96a07ec80259cb": @1092480,
        @"000000000000000df5e2e0eb7eaa36fcef28967f7f12e539f74661e03b13bdba": @1090704,
        @"00000000000000172f1765f4ed1e89ba4b717a475e9e37124626b02d566d31a2": @1090632,
        @"0000000000000018e62a4938de3428ddaa26e381139489ce1a618ed06d432a38": @1092024,
        @"000000000000000790bd24e65daaddbaeafdb4383c95d64c0d055e98625746bc": @1091832,
        @"0000000000000005f28a2cb959b316cd4b43bd29819ea07c27ec96a7d5e18ab7": @1092408,
        @"00000000000000165a4ace8de9e7a4ba0cddced3434c7badc863ff9e237f0c8a": @1091088,
        @"00000000000000230ec901e4d372a93c712d972727786a229e98d12694be9d34": @1090416,
        @"000000000000000bf51de942eb8610caaa55a7f5a0e5ca806c3b631948c5cdcc": @1092336,
        @"000000000000002323d7ba466a9b671d335c3b2bf630d08f078e4adee735e13a": @1090464,
        @"0000000000000019db2ad91ab0f67d90df222ce4057f343e176f8786865bcda9": @1091568,
        @"0000000000000004a38d87062bf37ef978d1fc8718f03d9222c8aa7aa8a4470f": @1090896,
        @"0000000000000022c909de83351791e0b69d4b4be34b25c8d54c8be3e8708c87": @1091592,
        @"0000000000000008f3dffcf342279c8b50e49c47e191d3df453fdcd816aced46": @1092792,
        @"000000000000001d1d7f1b88d6518e6248616c50e4c0abaee6116a72bc998679": @1092048,
        @"0000000000000020de87be47c5c10a50c9edfd669a586f47f44fa22ae0b2610a": @1090344,
        @"0000000000000014d1d8d12dd5ff570b06e76e0bbf55d762a94d13b1fe66a922": @1091760,
        @"000000000000000962d0d319a96d972215f303c588bf50449904f9a1a8cbc7c2": @1089792,
        @"00000000000000171c58d1d0dbae71973530aa533e4cd9cb2d2597ec30d9b129": @1091352,
        @"0000000000000004acf649896a7b22783810d5913b31922e3ea224dd4530b717": @1092144,
        @"0000000000000013479b902955f8ba2d4ce2eb47a7f9f8f1fe477ec4b405bddd": @1090512,
        @"000000000000001be0bbdb6b326c98ac8a3e181a2a641379c7d4308242bee90b": @1092216,
        @"000000000000001c09a68353536ccb24b51b74c642d5b6e7e385cff2debc4e64": @1092120,
        @"0000000000000013974ed8e13d0a50f298be0f2b685bfcfd8896172db6d4a145": @1090824,
        @"000000000000001dbcd3a23c131fedde3acd6da89275e7f9fcae03f3107da861": @1092888,
        @"000000000000000a8812d75979aac7c08ac69179037409fd7a368372edd05d23": @1090872,
        @"000000000000001fafca43cabdb0c6385daffa8a039f3b44b9b17271d7106704": @1090800,
        @"0000000000000006e9693e34fc55452c82328f31e069df740655b55dd07cb58b": @1091016,
        @"0000000000000010e7c080046121900cee1c7de7fe063c7d81405293a9764733": @1092384,
        @"0000000000000022ef41cb09a617d87c12c6841eea47310ae6a4d1e2702bb3d3": @1090752,
        @"0000000000000017705efcdaefd6a1856becc0b915de6fdccdc9e149c1ff0e8f": @1091856,
        @"0000000000000000265a9516f35dd85d32d103d4c3b95e81969a03295f46cf0c": @1091952,
        @"0000000000000002dfd994409f5b6185573ce22eae90b4a1c37003428071f0a8": @1090968,
        @"000000000000001b8d6aaa56571d987ee50fa2e2e9a28a8482de7a4b52308f25": @1091136,
        @"0000000000000020635160b49a18336031af2d25d9a37ea211d514f196220e9d": @1090440,
        @"000000000000001bfb2ac93ebe89d9831995462f965597efcc9008b2d90fd29f": @1091784,
        @"000000000000000028515b4c442c74e2af945f08ed3b66f05847022cb25bb2ec": @1091688,
        @"000000000000000ed6b9517da9a1df88d03a5904a780aba1200b474dab0e2e4a": @1090488,
        @"000000000000000b44a550a61f9751601065ff329c54d20eb306b97d163b8f8c": @1091712,
        @"000000000000001d831888fbd1899967493856c1abf7219e632b8e73f25e0c81": @1091064,
        @"00000000000000073b62bf732ab8654d27b1296801ab32b7ac630237665162a5": @1091304,
        @"0000000000000004c0b03207179143f028c07ede20354fab68c731cb02f95fc8": @1090656,
        @"000000000000000df9d9376b9c32ea640ecfac406b41445bb3a4b0ee6625e572": @1091040,
        @"00000000000000145c3e1b3bb6f53d5e2dd441ac41c3cfe48a5746c7b168a415": @1092240,
        @"000000000000000d8bf4cade14e398d69884e991591cb11ee7fec49167e4ff85": @1092000,
        @"000000000000001d098ef14fa032b33bcfc8e559351be8cd689e03c9678256a9": @1091472,
        @"0000000000000000c25139a9227273eb7547a1f558e62c545e62aeb236e66259": @1090584,
        @"0000000000000010785f105cc7c256b5365c597a9212e99beda94c6eff0647c3": @1091376,
        @"0000000000000000fafe0f7314104d81ab34ebd066601a38e5e914f2b3cefce9": @1092552,
        @"000000000000000ddbfad338961f2d900d62f1c3b725fbd72052da062704901c": @1090848,
        @"000000000000000e5d9359857518aaf3685bf8af55c675cf0d17a45383ca297f": @1091520,
        @"0000000000000012b444de0be31d695b411dcc6645a3723932cabc6b9164531f": @1092916,
        @"000000000000001c414007419fc22a2401b07ab430bf433c8cdfb8877fb6b5b7": @1092672,
        @"000000000000000355efb9a350cc76c7624bf42abea845770a5c3adc2c5b93f4": @1092576,
        @"000000000000000f327555478a9d580318cb6e15db059642eff84797bf133196": @1091808,
        @"0000000000000003b3ea97e688f1bec5f95930950b54c1bb01bf67b029739696": @1091640,
        @"000000000000001a0d96dbc0cac26e445454dd2506702eeee7df6ff35bdcf60e": @1091544,
        @"000000000000001aac60fafe05124672b19a1c3727dc17f106f11295db1053a3": @1092288,
        @"000000000000000e37bca1e08dff47ef051199f24e9104dad85014c323464069": @1091208,
        @"0000000000000013dd0059e5f701a39c0903e7f16d393f55fc896422139a4291": @1092768,
        @"000000000000000f4c8d5bdf6b89435d3a9789fce401286eb8f3f6eeb84f2a1d": @1091160,
        @"000000000000001414ff2dd44ee4c01c02e6867228b4e1ff490f635f7de949a5": @1091232,
        @"0000000000000013b130038d0599cb5a65165fc03b1b38fe2dd1a3bad6e253df": @1092312,
        @"00000000000000082cb9d6d169dc625f64a6a24756ba796eaab131a998b42910": @1091928,
        @"0000000000000001e358bce8df79c24def4787bf0bf7af25c040342fae4a18ce": @1091880
    };

    [self loadMasternodeListsForFiles:files
        withSave:YES
        withReload:NO
        onChain:chain
        inContext:context
        blockHeightLookup:^uint32_t(UInt256 blockHash) {
            NSNumber *blockHashNumber = blockHeightsDict[uint256_reverse_hex(blockHash)];
            NSLog(@"blockHeightLookup: %@ %@", uint256_reverse_hex(blockHash), blockHashNumber);
            if (blockHashNumber) return blockHashNumber.unsignedIntValue;
            NSAssert(NO, @"All values must be here");
            return UINT32_MAX;
        }
        completion:^(BOOL success, NSDictionary *masternodeLists) {
            XCTAssert(masternodeLists.count == 29, @"There should be 29 masternode lists");
            dispatch_semaphore_signal(sem);
        }];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
}

- (void)testMNLChaining {
    DSChain *chain = [DSChain mainnet];
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    __block NSManagedObjectContext *context = [NSManagedObjectContext chainContext];
    __block BOOL useCheckpointMasternodeLists = [[DSOptionsManager sharedInstance] useCheckpointMasternodeLists];
    [[DSOptionsManager sharedInstance] setUseCheckpointMasternodeLists:NO];
    [chain chainManager];
    [context performBlockAndWait:^{
        DSChainEntity *chainEntity = [chain chainEntityInContext:context];
        [DSSimplifiedMasternodeEntryEntity deleteAllOnChainEntity:chainEntity];
        [DSQuorumEntryEntity deleteAllOnChainEntity:chainEntity];
        [DSMasternodeListEntity deleteAllOnChainEntity:chainEntity];
        [DSQuorumSnapshotEntity deleteAllOnChainEntity:chainEntity];
    }];
    [chain.chainManager.masternodeManager reloadMasternodeLists];
    NSArray *files = @[@"MNL_0_1093824", @"MNL_1093824_1094400", @"MNL_1094400_1094976"];


    [self loadMasternodeListsForFiles:files
        withSave:NO
        withReload:NO
        onChain:chain
        inContext:context
        blockHeightLookup:^uint32_t(UInt256 blockHash) {
            NSString *blockHashString = uint256_reverse_hex(blockHash);
            if ([blockHashString isEqualToString:@"00000ffd590b1485b3caadc19b22e6379c733355108f107a430458cdf3407ab6"]) {
                return 0;
            } else if ([blockHashString isEqualToString:@"0000000000000010a7cd881eeb0d4252bbb8661b1c9f5eb4addebb7e7e726b88"]) {
                return 1093752;
            } else if ([blockHashString isEqualToString:@"000000000000000fa538169fbfd621d942d113ae6971b2fe9cffe02a5c9a25ae"]) {
                return 1094808;
            } else if ([blockHashString isEqualToString:@"00000000000000094fb5e8f10f035d1c96c7cab5aec44ada91ea535d8778e9ef"]) {
                return 1093704;
            } else if ([blockHashString isEqualToString:@"000000000000000e78706ecf6d744a2edc5143d3325ade22940dc14ccfd3f938"]) {
                return 1094400;
            } else if ([blockHashString isEqualToString:@"000000000000001583b7dcc1e3c670561e3f3dbd83cc74d2414f3dc839596f27"]) {
                return 1094736;
            } else if ([blockHashString isEqualToString:@"0000000000000009568e505b6d4b9b4330d0b4fe34c8602d2d45914aed6924f8"]) {
                return 1093536;
            } else if ([blockHashString isEqualToString:@"000000000000000071ae88cee71d08d320ce5091eb3877edb6cef554d6987d7f"]) {
                return 1094352;
            } else if ([blockHashString isEqualToString:@"000000000000001ebe8c3542f3a0f65a46d5f5ab4e380393bdbfda68d93221d7"]) {
                return 1094640;
            } else if ([blockHashString isEqualToString:@"000000000000001233f0f0963d1214b7cff3e091f56d7469f2ceed92fd0b1913"]) {
                return 1093272;
            } else if ([blockHashString isEqualToString:@"000000000000002283cf305dbfc4c37ec890d704eb2d267c9f5a418b0a171bb6"]) {
                return 1093920;
            } else if ([blockHashString isEqualToString:@"00000000000000212441a8ef2495d21b0b7c09e13339dbc34d98c478cc51f8e2"]) {
                return 1092096;
            } else if ([blockHashString isEqualToString:@"000000000000000c61002a6ef01e82aced8d5b394ae8faa1143fd893abfdd916"]) {
                return 1094232;
            } else if ([blockHashString isEqualToString:@"0000000000000003ba06634076289dff42839e247ae84ce1aab47ad902ae4705"]) {
                return 1093416;
            } else if ([blockHashString isEqualToString:@"000000000000000f9f34750629b5a2382268e8b6753afbd7c62735b82c452737"]) {
                return 1094040;
            } else if ([blockHashString isEqualToString:@"000000000000001cc1d7e03e3d37a6f0f62a8ac92a5c2947719140976559d91d"]) {
                return 1094280;
            } else if ([blockHashString isEqualToString:@"0000000000000027a2600911d015441d46e463f0ec693a72b8efb5dd196ff6a1"]) {
                return 1093320;
            } else if ([blockHashString isEqualToString:@"0000000000000016a94810e42937ff962a19bb3535b727088cb128c16e28475d"]) {
                return 1093800;
            } else if ([blockHashString isEqualToString:@"000000000000000dd26c943b68653b95a9bfc203e80c0050f6569156fe1fc94b"]) {
                return 1093296;
            } else if ([blockHashString isEqualToString:@"00000000000000144fabe7b89452957f62635a05c18a37fe9e276b1a623d3251"]) {
                return 1094496;
            } else if ([blockHashString isEqualToString:@"000000000000002406ca94753d91bae04ff66d83fbe7ff0e36649d44a09e7c34"]) {
                return 1094304;
            } else if ([blockHashString isEqualToString:@"00000000000000196db62f3ac00a290c0de3606d4bf58c550154c358f9d2ee45"]) {
                return 1094136;
            } else if ([blockHashString isEqualToString:@"000000000000001613deacecc4a85816e91ce006dee30b352f9ad5c245fad9cc"]) {
                return 1094448;
            } else if ([blockHashString isEqualToString:@"0000000000000002fa90f6d204488cb8386938173ed5eab5ab3df178866b058a"]) {
                return 1094088;
            } else if ([blockHashString isEqualToString:@"00000000000000019ec163300f2acd0aee00e63f162713096c95a7e9d47dd50f"]) {
                return 1094208;
            } else if ([blockHashString isEqualToString:@"00000000000000021eb17ff23549c328301f5df228d773c7d74ff5aae2baa466"]) {
                return 1093968;
            } else if ([blockHashString isEqualToString:@"00000000000000025ea597f951845fd9f759d8dd7deb381b8c48bfde0a3c2d28"]) {
                return 1094328;
            } else if ([blockHashString isEqualToString:@"000000000000000e5458bc47813b49b23d3a3f015bd74628e1950bc51086891b"]) {
                return 1094976;
            } else if ([blockHashString isEqualToString:@"00000000000000145abc88f4a079a42a16768c49381f17572c5ab6099170a09e"]) {
                return 1094568;
            } else if ([blockHashString isEqualToString:@"000000000000001463f239c0d3e3b0f466a06ae25d4eb0e81c5799b9ee8192c2"]) {
                return 1093680;
            } else if ([blockHashString isEqualToString:@"00000000000000084155d222800a8ea99afe4431dd0161cc888c2ebe177e19db"]) {
                return 1093656;
            } else if ([blockHashString isEqualToString:@"000000000000000dcdb06cced0211b9ca62b2947a2bd6e9830340f2c37c64d52"]) {
                return 1093824;
            } else if ([blockHashString isEqualToString:@"000000000000000fabcff485b9572368c3a06d985a1e4f77c53d735dc1af8507"]) {
                return 1094112;
            } else if ([blockHashString isEqualToString:@"000000000000000dfcb3a329719799a15e19c0be15ebd2338b2220c9bb2fd7af"]) {
                return 1093344;
            } else if ([blockHashString isEqualToString:@"000000000000000ff47ccc841c8ef3dfc6dc419b677c0e3399af6badfac4353d"]) {
                return 1094832;
            } else if ([blockHashString isEqualToString:@"000000000000000e1f5cb67880ca2ac7c4e93f9636a7117880b1e46702078b01"]) {
                return 1094592;
            } else if ([blockHashString isEqualToString:@"000000000000001b0b31e0ec23c1ac6329de09c066720ecf166c474b56231025"]) {
                return 1093440;
            } else if ([blockHashString isEqualToString:@"000000000000001a0228d6a5d3f5542eca7395cb91c0d028c8c988051e653fa7"]) {
                return 1094520;
            } else if ([blockHashString isEqualToString:@"000000000000002690fa0e9e0358d1088b995f947039fef48e851df2cc8a7c1a"]) {
                return 1094616;
            } else if ([blockHashString isEqualToString:@"0000000000000018a586b0d0ec8d74ad60381db5ed6449e4f86e63d28d131782"]) {
                return 1093464;
            } else if ([blockHashString isEqualToString:@"000000000000000aff92eefb5543f3afb2f145dd75ef504b2877013abe53a6b5"]) {
                return 1094904;
            } else if ([blockHashString isEqualToString:@"000000000000002344ae9bb8432a569ed0c949d86133799baa42d22336cbce2f"]) {
                return 1094472;
            } else if ([blockHashString isEqualToString:@"0000000000000000615083ccea9f8d36dc9ca0129ee8932892989e4dee510067"]) {
                return 1093512;
            } else if ([blockHashString isEqualToString:@"0000000000000021762a00c91394db56033e60c5031cd721d52767272ee252cc"]) {
                return 1094256;
            } else if ([blockHashString isEqualToString:@"00000000000000027ba127cd55d822250977b5d94148c71336745fe8899d886a"]) {
                return 1093632;
            } else if ([blockHashString isEqualToString:@"000000000000000edc8ad776fb0f9e407afae36237d2d8410b8f12424e892a6b"]) {
                return 1094016;
            } else if ([blockHashString isEqualToString:@"000000000000001577e4d463c654003d03833472a0de98922c98db18c33f92ca"]) {
                return 1093896;
            } else if ([blockHashString isEqualToString:@"0000000000000024cdf66dd7b20dd03711b2961b82c627557dfbb9acbba620b9"]) {
                return 1093776;
            } else if ([blockHashString isEqualToString:@"000000000000001c12e0007f8ec718282fff6cd63519a4fdc8cca698216def72"]) {
                return 1094928;
            } else if ([blockHashString isEqualToString:@"000000000000001c0b637ceb8879087a960cde2cd6b179041df416cf2b5bd731"]) {
                return 1093728;
            } else if ([blockHashString isEqualToString:@"0000000000000012d9cd9e407b037e64d33693a654eae85e54a2651d66dd5727"]) {
                return 1093608;
            } else if ([blockHashString isEqualToString:@"0000000000000020f1c98f7df0d89d369c9176644776b151ba8c230683b7d68a"]) {
                return 1094064;
            } else if ([blockHashString isEqualToString:@"0000000000000000983db6957230406f73a25d9ff929406db3607c62ba064dd3"]) {
                return 1094544;
            } else if ([blockHashString isEqualToString:@"0000000000000000ef3b052a6b6cf46fc53e7d700b35a640bea555537c963fe7"]) {
                return 1094856;
            } else if ([blockHashString isEqualToString:@"000000000000001bac84d4f9f18082b7f9a838a6b0a3c4d8dbfb9e8f54163432"]) {
                return 1093584;
            } else if ([blockHashString isEqualToString:@"000000000000000e5d9359857518aaf3685bf8af55c675cf0d17a45383ca297f"]) {
                return 1091520;
            } else if ([blockHashString isEqualToString:@"0000000000000017940e1aeb3bbf23165dabd152a8a8885c8ddf50e614a669d9"]) {
                return 1094184;
            } else if ([blockHashString isEqualToString:@"000000000000001c414007419fc22a2401b07ab430bf433c8cdfb8877fb6b5b7"]) {
                return 1092672;
            } else if ([blockHashString isEqualToString:@"000000000000001a304f460bd6c35a29a6ba19aba6a7c37818d8870d1b90a757"]) {
                return 1094376;
            } else if ([blockHashString isEqualToString:@"000000000000000772dfb8deff195bb86c24c825bd45155fa6abe7e2c824373f"]) {
                return 1094784;
            } else if ([blockHashString isEqualToString:@"000000000000001bf5e83d6cf96fce19773074ae4a7bcd1956d59a9e414a0431"]) {
                return 1094712;
            } else if ([blockHashString isEqualToString:@"000000000000001aa62cfba8db7fffc42287e3bc9c3a67f07c38369f04b4255d"]) {
                return 1094952;
            } else if ([blockHashString isEqualToString:@"0000000000000002c2037e0bdf7678cc1d2f307998d18b20f6799e2c04b861e1"]) {
                return 1093848;
            } else if ([blockHashString isEqualToString:@"000000000000001da5926d2dc7cd624bc9576d4e98fcbf2d3cda45c47695f566"]) {
                return 1094424;
            } else if ([blockHashString isEqualToString:@"000000000000000d5cadf1de431d8adda171a72296ded5c60a9f75d050cd9528"]) {
                return 1093248;
            } else if ([blockHashString isEqualToString:@"00000000000000171bc403369b98ed54ba716c532231d51740316ede6d3bff3a"]) {
                return 1093392;
            } else if ([blockHashString isEqualToString:@"000000000000001171446990f2fc89a7ac9e59e8bf33368a7151a0b9a3a3e8ae"]) {
                return 1093992;
            } else if ([blockHashString isEqualToString:@"000000000000001b7b535dfeac3eb2cfb481cf9c1fcda57541449962edc3ad01"]) {
                return 1092960;
            } else if ([blockHashString isEqualToString:@"000000000000001822bf109723eff5f406422b54736b2384d9d0c69e97276a88"]) {
                return 1093488;
            } else if ([blockHashString isEqualToString:@"000000000000002cef7980733f71f6b588a6d03a52103c637dca1ec3ae62296c"]) {
                return 1093872;
            } else if ([blockHashString isEqualToString:@"0000000000000016d802959ea0c6d903b4e2c8241f3cc670e002d3ae51347749"]) {
                return 1094160;
            } else if ([blockHashString isEqualToString:@"000000000000001e1ca2cf3ca2369e9d7efc4446214c13bf1c2c1970abb0437b"]) {
                return 1094880;
            } else if ([blockHashString isEqualToString:@"000000000000000cd0a2f51c3926225af4c8da1a95908ede547d6f6dd84fe72b"]) {
                return 1094664;
            } else if ([blockHashString isEqualToString:@"00000000000000132a6410a26e6825470a33cbd8a14d8ef25e569c41c9413f5f"]) {
                return 1094688;
            } else if ([blockHashString isEqualToString:@"00000000000000062d649600eb61e4e5167aba3a2fb782920a5cea1955c2689a"]) {
                return 1093560;
            } else if ([blockHashString isEqualToString:@"00000000000000260b705a14af12641139fa368795d954d5878b94881edfa455"]) {
                return 1093368;
            } else if ([blockHashString isEqualToString:@"000000000000000117e4a3c462adac43c1e34470558241ba5f4a08f32cee9217"]) {
                return 1094760;
            }
            NSLog(@"--- %@", blockHashString);
            NSAssert(NO, @"All values must be here");
            return UINT32_MAX;
        }
        completion:^(BOOL success1, NSDictionary *masternodeLists1) {
            BlockHeightFinder blockHeightLookup = ^uint32_t(UInt256 blockHash) {
                NSString *blockHashString = uint256_reverse_hex(blockHash);
                if ([blockHashString isEqualToString:@"00000ffd590b1485b3caadc19b22e6379c733355108f107a430458cdf3407ab6"]) {
                    return 0;
                } else if ([blockHashString isEqualToString:@"000000000000001c12e0007f8ec718282fff6cd63519a4fdc8cca698216def72"]) {
                    return 1094928;
                } else if ([blockHashString isEqualToString:@"000000000000000e5458bc47813b49b23d3a3f015bd74628e1950bc51086891b"]) {
                    return 1094976;
                } else if ([blockHashString isEqualToString:@"000000000000001a0228d6a5d3f5542eca7395cb91c0d028c8c988051e653fa7"]) {
                    return 1094520;
                } else if ([blockHashString isEqualToString:@"000000000000000772dfb8deff195bb86c24c825bd45155fa6abe7e2c824373f"]) {
                    return 1094784;
                } else if ([blockHashString isEqualToString:@"0000000000000000ef3b052a6b6cf46fc53e7d700b35a640bea555537c963fe7"]) {
                    return 1094856;
                } else if ([blockHashString isEqualToString:@"00000000000000144fabe7b89452957f62635a05c18a37fe9e276b1a623d3251"]) {
                    return 1094496;
                } else if ([blockHashString isEqualToString:@"0000000000000000983db6957230406f73a25d9ff929406db3607c62ba064dd3"]) {
                    return 1094544;
                } else if ([blockHashString isEqualToString:@"000000000000000e78706ecf6d744a2edc5143d3325ade22940dc14ccfd3f938"]) {
                    return 1094400;
                } else if ([blockHashString isEqualToString:@"000000000000001613deacecc4a85816e91ce006dee30b352f9ad5c245fad9cc"]) {
                    return 1094448;
                } else if ([blockHashString isEqualToString:@"000000000000001583b7dcc1e3c670561e3f3dbd83cc74d2414f3dc839596f27"]) {
                    return 1094736;
                } else if ([blockHashString isEqualToString:@"000000000000000fabcff485b9572368c3a06d985a1e4f77c53d735dc1af8507"]) {
                    return 1094112;
                } else if ([blockHashString isEqualToString:@"000000000000002690fa0e9e0358d1088b995f947039fef48e851df2cc8a7c1a"]) {
                    return 1094616;
                } else if ([blockHashString isEqualToString:@"000000000000000e1f5cb67880ca2ac7c4e93f9636a7117880b1e46702078b01"]) {
                    return 1094592;
                } else if ([blockHashString isEqualToString:@"000000000000001bf5e83d6cf96fce19773074ae4a7bcd1956d59a9e414a0431"]) {
                    return 1094712;
                } else if ([blockHashString isEqualToString:@"000000000000002344ae9bb8432a569ed0c949d86133799baa42d22336cbce2f"]) {
                    return 1094472;
                } else if ([blockHashString isEqualToString:@"000000000000000ff47ccc841c8ef3dfc6dc419b677c0e3399af6badfac4353d"]) {
                    return 1094832;
                } else if ([blockHashString isEqualToString:@"000000000000000cd0a2f51c3926225af4c8da1a95908ede547d6f6dd84fe72b"]) {
                    return 1094664;
                } else if ([blockHashString isEqualToString:@"000000000000001e1ca2cf3ca2369e9d7efc4446214c13bf1c2c1970abb0437b"]) {
                    return 1094880;
                } else if ([blockHashString isEqualToString:@"000000000000001da5926d2dc7cd624bc9576d4e98fcbf2d3cda45c47695f566"]) {
                    return 1094424;
                } else if ([blockHashString isEqualToString:@"00000000000000145abc88f4a079a42a16768c49381f17572c5ab6099170a09e"]) {
                    return 1094568;
                } else if ([blockHashString isEqualToString:@"000000000000000117e4a3c462adac43c1e34470558241ba5f4a08f32cee9217"]) {
                    return 1094760;
                } else if ([blockHashString isEqualToString:@"000000000000000fa538169fbfd621d942d113ae6971b2fe9cffe02a5c9a25ae"]) {
                    return 1094808;
                } else if ([blockHashString isEqualToString:@"000000000000000dcdb06cced0211b9ca62b2947a2bd6e9830340f2c37c64d52"]) {
                    return 1093824;
                } else if ([blockHashString isEqualToString:@"000000000000000d5cadf1de431d8adda171a72296ded5c60a9f75d050cd9528"]) {
                    return 1093248;
                } else if ([blockHashString isEqualToString:@"000000000000001aa62cfba8db7fffc42287e3bc9c3a67f07c38369f04b4255d"]) {
                    return 1094952;
                } else if ([blockHashString isEqualToString:@"000000000000001ebe8c3542f3a0f65a46d5f5ab4e380393bdbfda68d93221d7"]) {
                    return 1094640;
                } else if ([blockHashString isEqualToString:@"000000000000001c414007419fc22a2401b07ab430bf433c8cdfb8877fb6b5b7"]) {
                    return 1092672;
                } else if ([blockHashString isEqualToString:@"00000000000000132a6410a26e6825470a33cbd8a14d8ef25e569c41c9413f5f"]) {
                    return 1094688;
                } else if ([blockHashString isEqualToString:@"000000000000000aff92eefb5543f3afb2f145dd75ef504b2877013abe53a6b5"]) {
                    return 1094904;
                }
                NSLog(@"--- %@", blockHashString);
                NSAssert(NO, @"All values must be here");
                return UINT32_MAX;
            };
            [self loadMasternodeListsForFiles:@[@"MNL_0_1094976"]
                                     withSave:NO
                                   withReload:NO
                                      onChain:chain
                                    inContext:context
                            blockHeightLookup:blockHeightLookup
                                   completion:^(BOOL success2, NSDictionary *masternodeLists2) {
                                       NSData *block1094976Hash = [[masternodeLists2 allKeys] firstObject];
                                       DSMasternodeList *chainedMasternodeList = [masternodeLists1 objectForKey:block1094976Hash];
                                       DSMasternodeList *nonChainedMasternodeList = [masternodeLists2 objectForKey:block1094976Hash];
                                       if (!uint256_eq([chainedMasternodeList masternodeMerkleRoot], [nonChainedMasternodeList calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup])) {
                                           NSDictionary *comparisonResult = [chainedMasternodeList compare:nonChainedMasternodeList usingOurString:@"chained" usingTheirString:@"non chained" blockHeightLookup:blockHeightLookup];
                                           NSLog(@"%@", comparisonResult);
                                       }
                                       XCTAssert(uint256_eq([chainedMasternodeList masternodeMerkleRoot], [nonChainedMasternodeList calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup]), @"These should be equal");

                                       [[DSOptionsManager sharedInstance] setUseCheckpointMasternodeLists:useCheckpointMasternodeLists];
                                       dispatch_semaphore_signal(sem);
                                   }];
        }];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
}

- (void)testMNLDeepChaining {
    DSChain *chain = [DSChain mainnet];
    __block NSManagedObjectContext *context = [NSManagedObjectContext chainContext];
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    __block BOOL useCheckpointMasternodeLists = [[DSOptionsManager sharedInstance] useCheckpointMasternodeLists];
    [[DSOptionsManager sharedInstance] setUseCheckpointMasternodeLists:NO];
    [chain chainManager];
    [context performBlockAndWait:^{
        DSChainEntity *chainEntity = [chain chainEntityInContext:context];
        [DSSimplifiedMasternodeEntryEntity deleteAllOnChainEntity:chainEntity];
        [DSQuorumEntryEntity deleteAllOnChainEntity:chainEntity];
        [DSMasternodeListEntity deleteAllOnChainEntity:chainEntity];
        [DSQuorumSnapshotEntity deleteAllOnChainEntity:chainEntity];
    }];
    [chain.chainManager.masternodeManager reloadMasternodeLists];
    NSArray *files = @[@"MNL_0_1093824", @"MNL_1093824_1094400", @"MNL_1094400_1094976", @"MNL_1094976_1095264", @"MNL_1095264_1095432", @"MNL_1095432_1095456", @"MNL_1095456_1095480", @"MNL_1095480_1095504", @"MNL_1095504_1095528", @"MNL_1095528_1095552", @"MNL_1095552_1095576", @"MNL_1095576_1095600", @"MNL_1095600_1095624", @"MNL_1095624_1095648", @"MNL_1095648_1095672", @"MNL_1095672_1095696", @"MNL_1095696_1095720"];


    [self loadMasternodeListsForFiles:files
        withSave:NO
        withReload:NO
        onChain:chain
        inContext:context
        blockHeightLookup:^uint32_t(UInt256 blockHash) {
            NSString *blockHashString = uint256_reverse_hex(blockHash);
            if ([blockHashString isEqualToString:@"00000ffd590b1485b3caadc19b22e6379c733355108f107a430458cdf3407ab6"]) {
                return 0;
            } else if ([blockHashString isEqualToString:@"000000000000002283cf305dbfc4c37ec890d704eb2d267c9f5a418b0a171bb6"]) {
                return 1093920;
            } else if ([blockHashString isEqualToString:@"0000000000000003ba06634076289dff42839e247ae84ce1aab47ad902ae4705"]) {
                return 1093416;
            } else if ([blockHashString isEqualToString:@"0000000000000000983db6957230406f73a25d9ff929406db3607c62ba064dd3"]) {
                return 1094544;
            } else if ([blockHashString isEqualToString:@"00000000000000063cea204f55fbb2eb56816eacf6134bf338fb6f7d19586e68"]) {
                return 1095072;
            } else if ([blockHashString isEqualToString:@"0000000000000003b4e065db18ab97a5556bed3b4a1255f8da813e199a512755"]) {
                return 1095264;
            } else if ([blockHashString isEqualToString:@"00000000000000027ba127cd55d822250977b5d94148c71336745fe8899d886a"]) {
                return 1093632;
            } else if ([blockHashString isEqualToString:@"00000000000000129ebb2ed2350c8a39ee5c1cecb81baac16dc1e44a199c634a"]) {
                return 1095216;
            } else if ([blockHashString isEqualToString:@"00000000000000021eb17ff23549c328301f5df228d773c7d74ff5aae2baa466"]) {
                return 1093968;
            } else if ([blockHashString isEqualToString:@"000000000000002406ca94753d91bae04ff66d83fbe7ff0e36649d44a09e7c34"]) {
                return 1094304;
            } else if ([blockHashString isEqualToString:@"00000000000000196db62f3ac00a290c0de3606d4bf58c550154c358f9d2ee45"]) {
                return 1094136;
            } else if ([blockHashString isEqualToString:@"0000000000000020f1c98f7df0d89d369c9176644776b151ba8c230683b7d68a"]) {
                return 1094064;
            } else if ([blockHashString isEqualToString:@"000000000000001da5926d2dc7cd624bc9576d4e98fcbf2d3cda45c47695f566"]) {
                return 1094424;
            } else if ([blockHashString isEqualToString:@"000000000000000fa538169fbfd621d942d113ae6971b2fe9cffe02a5c9a25ae"]) {
                return 1094808;
            } else if ([blockHashString isEqualToString:@"0000000000000000b9cb58ca605b36d9604fa8e791125e4fe81d329acec4b1a8"]) {
                return 1095600;
            } else if ([blockHashString isEqualToString:@"000000000000001a304f460bd6c35a29a6ba19aba6a7c37818d8870d1b90a757"]) {
                return 1094376;
            } else if ([blockHashString isEqualToString:@"00000000000000229e6a8a83c7e8c34a6c7ceb105a1ad80c7e7b4f666363b1ba"]) {
                return 1095168;
            } else if ([blockHashString isEqualToString:@"0000000000000000ef3b052a6b6cf46fc53e7d700b35a640bea555537c963fe7"]) {
                return 1094856;
            } else if ([blockHashString isEqualToString:@"000000000000000d0a9b48693d41fc615193591b158e2ec91de40875514b370c"]) {
                return 1095024;
            } else if ([blockHashString isEqualToString:@"0000000000000006e0f176aa2fb71013645fae8f9635c41d79aba03abf2f968b"]) {
                return 1095696;
            } else if ([blockHashString isEqualToString:@"000000000000001ebe8c3542f3a0f65a46d5f5ab4e380393bdbfda68d93221d7"]) {
                return 1094640;
            } else if ([blockHashString isEqualToString:@"0000000000000003c1e5392b90ce0083fd803797ce039f5b5e93b8581a9cd110"]) {
                return 1095312;
            } else if ([blockHashString isEqualToString:@"000000000000001bf5e83d6cf96fce19773074ae4a7bcd1956d59a9e414a0431"]) {
                return 1094712;
            } else if ([blockHashString isEqualToString:@"00000000000000020599bb1afc06a0e03f5333d7edf91bf2b038c7b2e9fb4dcb"]) {
                return 1095648;
            } else if ([blockHashString isEqualToString:@"00000000000000132a6410a26e6825470a33cbd8a14d8ef25e569c41c9413f5f"]) {
                return 1094688;
            } else if ([blockHashString isEqualToString:@"0000000000000016d802959ea0c6d903b4e2c8241f3cc670e002d3ae51347749"]) {
                return 1094160;
            } else if ([blockHashString isEqualToString:@"000000000000001a1d7a8959d08fae46d1d77e380f643501045c9619b07cdb7d"]) {
                return 1095120;
            } else if ([blockHashString isEqualToString:@"0000000000000002c2037e0bdf7678cc1d2f307998d18b20f6799e2c04b861e1"]) {
                return 1093848;
            } else if ([blockHashString isEqualToString:@"0000000000000018a586b0d0ec8d74ad60381db5ed6449e4f86e63d28d131782"]) {
                return 1093464;
            } else if ([blockHashString isEqualToString:@"00000000000000212441a8ef2495d21b0b7c09e13339dbc34d98c478cc51f8e2"]) {
                return 1092096;
            } else if ([blockHashString isEqualToString:@"000000000000000117e4a3c462adac43c1e34470558241ba5f4a08f32cee9217"]) {
                return 1094760;
            } else if ([blockHashString isEqualToString:@"0000000000000002fa90f6d204488cb8386938173ed5eab5ab3df178866b058a"]) {
                return 1094088;
            } else if ([blockHashString isEqualToString:@"00000000000000084155d222800a8ea99afe4431dd0161cc888c2ebe177e19db"]) {
                return 1093656;
            } else if ([blockHashString isEqualToString:@"0000000000000000615083ccea9f8d36dc9ca0129ee8932892989e4dee510067"]) {
                return 1093512;
            } else if ([blockHashString isEqualToString:@"0000000000000027a2600911d015441d46e463f0ec693a72b8efb5dd196ff6a1"]) {
                return 1093320;
            } else if ([blockHashString isEqualToString:@"00000000000000019ec163300f2acd0aee00e63f162713096c95a7e9d47dd50f"]) {
                return 1094208;
            } else if ([blockHashString isEqualToString:@"0000000000000021762a00c91394db56033e60c5031cd721d52767272ee252cc"]) {
                return 1094256;
            } else if ([blockHashString isEqualToString:@"000000000000000dcdb06cced0211b9ca62b2947a2bd6e9830340f2c37c64d52"]) {
                return 1093824;
            } else if ([blockHashString isEqualToString:@"000000000000001c12e0007f8ec718282fff6cd63519a4fdc8cca698216def72"]) {
                return 1094928;
            } else if ([blockHashString isEqualToString:@"000000000000001bac84d4f9f18082b7f9a838a6b0a3c4d8dbfb9e8f54163432"]) {
                return 1093584;
            } else if ([blockHashString isEqualToString:@"000000000000000772dfb8deff195bb86c24c825bd45155fa6abe7e2c824373f"]) {
                return 1094784;
            } else if ([blockHashString isEqualToString:@"00000000000000062f90f8928ce313986c71663f868c434cccd455e152b3f2ff"]) {
                return 1095432;
            } else if ([blockHashString isEqualToString:@"000000000000000fabcff485b9572368c3a06d985a1e4f77c53d735dc1af8507"]) {
                return 1094112;
            } else if ([blockHashString isEqualToString:@"000000000000001171446990f2fc89a7ac9e59e8bf33368a7151a0b9a3a3e8ae"]) {
                return 1093992;
            } else if ([blockHashString isEqualToString:@"000000000000001233f0f0963d1214b7cff3e091f56d7469f2ceed92fd0b1913"]) {
                return 1093272;
            } else if ([blockHashString isEqualToString:@"00000000000000240088475057f73dd1ec5185a049f9591fe097ea5302fe1377"]) {
                return 1095720;
            } else if ([blockHashString isEqualToString:@"00000000000000144fabe7b89452957f62635a05c18a37fe9e276b1a623d3251"]) {
                return 1094496;
            } else if ([blockHashString isEqualToString:@"000000000000001aa62cfba8db7fffc42287e3bc9c3a67f07c38369f04b4255d"]) {
                return 1094952;
            } else if ([blockHashString isEqualToString:@"000000000000000b90f59f6a103723e4482e1b588a8cd7f122ce27d5d694122d"]) {
                return 1095504;
            } else if ([blockHashString isEqualToString:@"000000000000000c89a10adee5dd18be09c10f3997719f448621e3039a7078e2"]) {
                return 1095096;
            } else if ([blockHashString isEqualToString:@"0000000000000024cdf66dd7b20dd03711b2961b82c627557dfbb9acbba620b9"]) {
                return 1093776;
            } else if ([blockHashString isEqualToString:@"000000000000000f9f34750629b5a2382268e8b6753afbd7c62735b82c452737"]) {
                return 1094040;
            } else if ([blockHashString isEqualToString:@"0000000000000012d9cd9e407b037e64d33693a654eae85e54a2651d66dd5727"]) {
                return 1093608;
            } else if ([blockHashString isEqualToString:@"000000000000001b7b535dfeac3eb2cfb481cf9c1fcda57541449962edc3ad01"]) {
                return 1092960;
            } else if ([blockHashString isEqualToString:@"000000000000000071ae88cee71d08d320ce5091eb3877edb6cef554d6987d7f"]) {
                return 1094352;
            } else if ([blockHashString isEqualToString:@"0000000000000003b27df3db412427df13ba3dceb7ac5af75a5a65fa5fd40a7b"]) {
                return 1095144;
            } else if ([blockHashString isEqualToString:@"000000000000000ecbdb940a8094d7643859b064fde0ed32096fa493e0cd776c"]) {
                return 1095048;
            } else if ([blockHashString isEqualToString:@"000000000000000d5cadf1de431d8adda171a72296ded5c60a9f75d050cd9528"]) {
                return 1093248;
            } else if ([blockHashString isEqualToString:@"00000000000000087c9bb2d682436a6f590878b2124cdeba1744ef064065f996"]) {
                return 1095000;
            } else if ([blockHashString isEqualToString:@"00000000000000251c624ba68d162f443b9b8662bd41c8cbaf76edf0edf09449"]) {
                return 1095336;
            } else if ([blockHashString isEqualToString:@"000000000000001b0b31e0ec23c1ac6329de09c066720ecf166c474b56231025"]) {
                return 1093440;
            } else if ([blockHashString isEqualToString:@"000000000000001577e4d463c654003d03833472a0de98922c98db18c33f92ca"]) {
                return 1093896;
            } else if ([blockHashString isEqualToString:@"000000000000000ff47ccc841c8ef3dfc6dc419b677c0e3399af6badfac4353d"]) {
                return 1094832;
            } else if ([blockHashString isEqualToString:@"000000000000000cd0a2f51c3926225af4c8da1a95908ede547d6f6dd84fe72b"]) {
                return 1094664;
            } else if ([blockHashString isEqualToString:@"000000000000000e1f5cb67880ca2ac7c4e93f9636a7117880b1e46702078b01"]) {
                return 1094592;
            } else if ([blockHashString isEqualToString:@"00000000000000131b1a04b792ea5f4120014d67261db05da36c3e4cf424ff80"]) {
                return 1095624;
            } else if ([blockHashString isEqualToString:@"000000000000001d78e3addb7fb4f4e4de083e10703081d9e5ebbcf94fc94cea"]) {
                return 1095672;
            } else if ([blockHashString isEqualToString:@"00000000000000260b705a14af12641139fa368795d954d5878b94881edfa455"]) {
                return 1093368;
            } else if ([blockHashString isEqualToString:@"00000000000000010d1ec424a84a28093395309ea79ce7c4b6ab49e08f589750"]) {
                return 1095456;
            } else if ([blockHashString isEqualToString:@"000000000000001613deacecc4a85816e91ce006dee30b352f9ad5c245fad9cc"]) {
                return 1094448;
            } else if ([blockHashString isEqualToString:@"000000000000002690fa0e9e0358d1088b995f947039fef48e851df2cc8a7c1a"]) {
                return 1094616;
            } else if ([blockHashString isEqualToString:@"0000000000000013ddc64c114e35eaa454da80454c7a6abd0fd186bc47b3135c"]) {
                return 1095384;
            } else if ([blockHashString isEqualToString:@"000000000000000e78706ecf6d744a2edc5143d3325ade22940dc14ccfd3f938"]) {
                return 1094400;
            } else if ([blockHashString isEqualToString:@"000000000000000e5458bc47813b49b23d3a3f015bd74628e1950bc51086891b"]) {
                return 1094976;
            } else if ([blockHashString isEqualToString:@"000000000000000dd26c943b68653b95a9bfc203e80c0050f6569156fe1fc94b"]) {
                return 1093296;
            } else if ([blockHashString isEqualToString:@"000000000000001e1ca2cf3ca2369e9d7efc4446214c13bf1c2c1970abb0437b"]) {
                return 1094880;
            } else if ([blockHashString isEqualToString:@"000000000000002cef7980733f71f6b588a6d03a52103c637dca1ec3ae62296c"]) {
                return 1093872;
            } else if ([blockHashString isEqualToString:@"00000000000000062d649600eb61e4e5167aba3a2fb782920a5cea1955c2689a"]) {
                return 1093560;
            } else if ([blockHashString isEqualToString:@"000000000000001a0228d6a5d3f5542eca7395cb91c0d028c8c988051e653fa7"]) {
                return 1094520;
            } else if ([blockHashString isEqualToString:@"000000000000000dfcb3a329719799a15e19c0be15ebd2338b2220c9bb2fd7af"]) {
                return 1093344;
            } else if ([blockHashString isEqualToString:@"000000000000000aff92eefb5543f3afb2f145dd75ef504b2877013abe53a6b5"]) {
                return 1094904;
            } else if ([blockHashString isEqualToString:@"00000000000000129dab8cc8befddb59cf7e3c3e249939eb5a00a5394648f1b2"]) {
                return 1095480;
            } else if ([blockHashString isEqualToString:@"000000000000000225158fd4c0fad459645bbcd1a93e843fe22b652ab40d7535"]) {
                return 1095240;
            } else if ([blockHashString isEqualToString:@"0000000000000010a7cd881eeb0d4252bbb8661b1c9f5eb4addebb7e7e726b88"]) {
                return 1093752;
            } else if ([blockHashString isEqualToString:@"000000000000000c61002a6ef01e82aced8d5b394ae8faa1143fd893abfdd916"]) {
                return 1094232;
            } else if ([blockHashString isEqualToString:@"000000000000000e5d9359857518aaf3685bf8af55c675cf0d17a45383ca297f"]) {
                return 1091520;
            } else if ([blockHashString isEqualToString:@"000000000000001e25b165b99d2e2174d01b8bce715915031bc59d3145a2993c"]) {
                return 1095288;
            } else if ([blockHashString isEqualToString:@"0000000000000017940e1aeb3bbf23165dabd152a8a8885c8ddf50e614a669d9"]) {
                return 1094184;
            } else if ([blockHashString isEqualToString:@"00000000000000094fb5e8f10f035d1c96c7cab5aec44ada91ea535d8778e9ef"]) {
                return 1093704;
            } else if ([blockHashString isEqualToString:@"000000000000001583b7dcc1e3c670561e3f3dbd83cc74d2414f3dc839596f27"]) {
                return 1094736;
            } else if ([blockHashString isEqualToString:@"000000000000001822bf109723eff5f406422b54736b2384d9d0c69e97276a88"]) {
                return 1093488;
            } else if ([blockHashString isEqualToString:@"000000000000001c414007419fc22a2401b07ab430bf433c8cdfb8877fb6b5b7"]) {
                return 1092672;
            } else if ([blockHashString isEqualToString:@"00000000000000025ea597f951845fd9f759d8dd7deb381b8c48bfde0a3c2d28"]) {
                return 1094328;
            } else if ([blockHashString isEqualToString:@"000000000000001e91a161d9c3c4d42c108ac1326d746f21646fb5a988cb15da"]) {
                return 1095360;
            } else if ([blockHashString isEqualToString:@"000000000000001c0b637ceb8879087a960cde2cd6b179041df416cf2b5bd731"]) {
                return 1093728;
            } else if ([blockHashString isEqualToString:@"000000000000000751157bca41a61d1df27a318a59d3234e1cabc4f7c31656e0"]) {
                return 1095576;
            } else if ([blockHashString isEqualToString:@"0000000000000024030fa272c48f386c079bfcf655d4b09f0f2d092bb67303bb"]) {
                return 1095408;
            } else if ([blockHashString isEqualToString:@"000000000000001463f239c0d3e3b0f466a06ae25d4eb0e81c5799b9ee8192c2"]) {
                return 1093680;
            } else if ([blockHashString isEqualToString:@"000000000000000edc8ad776fb0f9e407afae36237d2d8410b8f12424e892a6b"]) {
                return 1094016;
            } else if ([blockHashString isEqualToString:@"00000000000000171bc403369b98ed54ba716c532231d51740316ede6d3bff3a"]) {
                return 1093392;
            } else if ([blockHashString isEqualToString:@"00000000000000143c121d0ebcc8ac6d22f5f2bf44b1b871569dec0e4df7c69c"]) {
                return 1095552;
            } else if ([blockHashString isEqualToString:@"0000000000000009568e505b6d4b9b4330d0b4fe34c8602d2d45914aed6924f8"]) {
                return 1093536;
            } else if ([blockHashString isEqualToString:@"000000000000001cc1d7e03e3d37a6f0f62a8ac92a5c2947719140976559d91d"]) {
                return 1094280;
            } else if ([blockHashString isEqualToString:@"000000000000002344ae9bb8432a569ed0c949d86133799baa42d22336cbce2f"]) {
                return 1094472;
            } else if ([blockHashString isEqualToString:@"000000000000000ea92aa407cf31a16fabca0f0f74718424d91869ad1b58edaa"]) {
                return 1095192;
            } else if ([blockHashString isEqualToString:@"00000000000000111d542d60aad39dafafcc65335a4d516388dc51fcba89035b"]) {
                return 1095528;
            } else if ([blockHashString isEqualToString:@"0000000000000016a94810e42937ff962a19bb3535b727088cb128c16e28475d"]) {
                return 1093800;
            } else if ([blockHashString isEqualToString:@"00000000000000145abc88f4a079a42a16768c49381f17572c5ab6099170a09e"]) {
                return 1094568;
            }
            NSAssert(NO, @"All values must be here");
            return UINT32_MAX;
        }
        completion:^(BOOL success1, NSDictionary *masternodeLists1) {
            BlockHeightFinder blockHeightLookup = ^uint32_t(UInt256 blockHash) {
                NSString *blockHashString = uint256_reverse_hex(blockHash);
                if ([blockHashString isEqualToString:@"00000ffd590b1485b3caadc19b22e6379c733355108f107a430458cdf3407ab6"]) {
                    return 0;
                } else if ([blockHashString isEqualToString:@"0000000000000024030fa272c48f386c079bfcf655d4b09f0f2d092bb67303bb"]) {
                    return 1095408;
                } else if ([blockHashString isEqualToString:@"000000000000000e5458bc47813b49b23d3a3f015bd74628e1950bc51086891b"]) {
                    return 1094976;
                } else if ([blockHashString isEqualToString:@"00000000000000229e6a8a83c7e8c34a6c7ceb105a1ad80c7e7b4f666363b1ba"]) {
                    return 1095168;
                } else if ([blockHashString isEqualToString:@"0000000000000003b27df3db412427df13ba3dceb7ac5af75a5a65fa5fd40a7b"]) {
                    return 1095144;
                } else if ([blockHashString isEqualToString:@"00000000000000240088475057f73dd1ec5185a049f9591fe097ea5302fe1377"]) {
                    return 1095720;
                } else if ([blockHashString isEqualToString:@"00000000000000010d1ec424a84a28093395309ea79ce7c4b6ab49e08f589750"]) {
                    return 1095456;
                } else if ([blockHashString isEqualToString:@"00000000000000020599bb1afc06a0e03f5333d7edf91bf2b038c7b2e9fb4dcb"]) {
                    return 1095648;
                } else if ([blockHashString isEqualToString:@"0000000000000000b9cb58ca605b36d9604fa8e791125e4fe81d329acec4b1a8"]) {
                    return 1095600;
                } else if ([blockHashString isEqualToString:@"000000000000000ea92aa407cf31a16fabca0f0f74718424d91869ad1b58edaa"]) {
                    return 1095192;
                } else if ([blockHashString isEqualToString:@"000000000000000751157bca41a61d1df27a318a59d3234e1cabc4f7c31656e0"]) {
                    return 1095576;
                } else if ([blockHashString isEqualToString:@"00000000000000129dab8cc8befddb59cf7e3c3e249939eb5a00a5394648f1b2"]) {
                    return 1095480;
                } else if ([blockHashString isEqualToString:@"000000000000000225158fd4c0fad459645bbcd1a93e843fe22b652ab40d7535"]) {
                    return 1095240;
                } else if ([blockHashString isEqualToString:@"0000000000000013ddc64c114e35eaa454da80454c7a6abd0fd186bc47b3135c"]) {
                    return 1095384;
                } else if ([blockHashString isEqualToString:@"00000000000000251c624ba68d162f443b9b8662bd41c8cbaf76edf0edf09449"]) {
                    return 1095336;
                } else if ([blockHashString isEqualToString:@"00000000000000131b1a04b792ea5f4120014d67261db05da36c3e4cf424ff80"]) {
                    return 1095624;
                } else if ([blockHashString isEqualToString:@"00000000000000143c121d0ebcc8ac6d22f5f2bf44b1b871569dec0e4df7c69c"]) {
                    return 1095552;
                } else if ([blockHashString isEqualToString:@"0000000000000003b4e065db18ab97a5556bed3b4a1255f8da813e199a512755"]) {
                    return 1095264;
                } else if ([blockHashString isEqualToString:@"0000000000000003c1e5392b90ce0083fd803797ce039f5b5e93b8581a9cd110"]) {
                    return 1095312;
                } else if ([blockHashString isEqualToString:@"000000000000001d78e3addb7fb4f4e4de083e10703081d9e5ebbcf94fc94cea"]) {
                    return 1095672;
                } else if ([blockHashString isEqualToString:@"00000000000000111d542d60aad39dafafcc65335a4d516388dc51fcba89035b"]) {
                    return 1095528;
                } else if ([blockHashString isEqualToString:@"00000000000000062f90f8928ce313986c71663f868c434cccd455e152b3f2ff"]) {
                    return 1095432;
                } else if ([blockHashString isEqualToString:@"000000000000000e78706ecf6d744a2edc5143d3325ade22940dc14ccfd3f938"]) {
                    return 1094400;
                } else if ([blockHashString isEqualToString:@"0000000000000006e0f176aa2fb71013645fae8f9635c41d79aba03abf2f968b"]) {
                    return 1095696;
                } else if ([blockHashString isEqualToString:@"00000000000000129ebb2ed2350c8a39ee5c1cecb81baac16dc1e44a199c634a"]) {
                    return 1095216;
                } else if ([blockHashString isEqualToString:@"000000000000000b90f59f6a103723e4482e1b588a8cd7f122ce27d5d694122d"]) {
                    return 1095504;
                } else if ([blockHashString isEqualToString:@"000000000000001e25b165b99d2e2174d01b8bce715915031bc59d3145a2993c"]) {
                    return 1095288;
                } else if ([blockHashString isEqualToString:@"000000000000000dcdb06cced0211b9ca62b2947a2bd6e9830340f2c37c64d52"]) {
                    return 1093824;
                } else if ([blockHashString isEqualToString:@"000000000000001e91a161d9c3c4d42c108ac1326d746f21646fb5a988cb15da"]) {
                    return 1095360;
                } else if ([blockHashString isEqualToString:@"00000000000000132a6410a26e6825470a33cbd8a14d8ef25e569c41c9413f5f"]) {
                    return 1094688;
                }
                NSAssert(NO, @"All values must be here");
                return UINT32_MAX;
            };
            [self loadMasternodeListsForFiles:@[@"MNL_0_1095720"]
                                     withSave:NO
                                   withReload:NO
                                      onChain:chain
                                    inContext:context
                            blockHeightLookup:blockHeightLookup
                                   completion:^(BOOL success2, NSDictionary *masternodeLists2) {
                                       NSData *block1095720Hash = [[masternodeLists2 allKeys] firstObject];
                                       DSMasternodeList *chainedMasternodeList = [masternodeLists1 objectForKey:block1095720Hash];
                                       DSMasternodeList *nonChainedMasternodeList = [masternodeLists2 objectForKey:block1095720Hash];
                                       if (!uint256_eq([chainedMasternodeList masternodeMerkleRoot], [nonChainedMasternodeList calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup])) {
                                           NSDictionary *comparisonResult = [chainedMasternodeList compare:nonChainedMasternodeList usingOurString:@"chained" usingTheirString:@"non chained" blockHeightLookup:blockHeightLookup];
                                           NSLog(@"%@", comparisonResult);
                                       }
                                       XCTAssert(uint256_eq([chainedMasternodeList masternodeMerkleRoot], [nonChainedMasternodeList calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup]), @"These should be equal");

                                       [[DSOptionsManager sharedInstance] setUseCheckpointMasternodeLists:useCheckpointMasternodeLists];
                                       dispatch_semaphore_signal(sem);
                                   }];
        }];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
}

- (void)testMNLReloadAgain {
    DSChain *chain = [DSChain mainnet];
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    __block NSManagedObjectContext *context = [NSManagedObjectContext chainContext];
    __block BOOL useCheckpointMasternodeLists = [[DSOptionsManager sharedInstance] useCheckpointMasternodeLists];
    [[DSOptionsManager sharedInstance] setUseCheckpointMasternodeLists:NO];
    [chain chainManager];
    [context performBlockAndWait:^{
        DSChainEntity *chainEntity = [chain chainEntityInContext:context];
        [DSSimplifiedMasternodeEntryEntity deleteAllOnChainEntity:chainEntity];
        [DSQuorumEntryEntity deleteAllOnChainEntity:chainEntity];
        [DSMasternodeListEntity deleteAllOnChainEntity:chainEntity];
        [DSQuorumSnapshotEntity deleteAllOnChainEntity:chainEntity];
    }];
    [chain.chainManager.masternodeManager reloadMasternodeLists];
    NSArray *files = @[@"MNL_0_1093824", @"MNL_1093824_1094400", @"MNL_1094400_1094976", @"MNL_1094976_1095264", @"MNL_1095264_1095432", @"MNL_1095432_1095456", @"MNL_1095456_1095480", @"MNL_1095480_1095504", @"MNL_1095504_1095528", @"MNL_1095528_1095552", @"MNL_1095552_1095576", @"MNL_1095576_1095600", @"MNL_1095600_1095624", @"MNL_1095624_1095648", @"MNL_1095648_1095672", @"MNL_1095672_1095696", @"MNL_1095696_1095720", @"MNL_1095720_1095744", @"MNL_1095744_1095768", @"MNL_1095768_1095792", @"MNL_1095792_1095816", @"MNL_1095816_1095840", @"MNL_1095840_1095864", @"MNL_1095864_1095888", @"MNL_1095888_1095912", @"MNL_1095912_1095936", @"MNL_1095936_1095960", @"MNL_1095960_1095984", @"MNL_1095984_1096003"];

    uint32_t (^blockHeightLookup)(UInt256 blockHash) = ^uint32_t(UInt256 blockHash) {
        NSString *blockHashString = uint256_reverse_hex(blockHash);
        NoTimeLog(@"testMNLReloadAgain: blockHeightLookup: %@ (%@)", blockHashString, uint256_hex(blockHash));
        if ([blockHashString isEqualToString:@"00000ffd590b1485b3caadc19b22e6379c733355108f107a430458cdf3407ab6"]) {
            return 0;
        } else if ([blockHashString isEqualToString:@"00000000000000063cea204f55fbb2eb56816eacf6134bf338fb6f7d19586e68"]) {
            return 1095072;
        } else if ([blockHashString isEqualToString:@"00000000000000229e6a8a83c7e8c34a6c7ceb105a1ad80c7e7b4f666363b1ba"]) {
            return 1095168;
        } else if ([blockHashString isEqualToString:@"0000000000000003b4e065db18ab97a5556bed3b4a1255f8da813e199a512755"]) {
            return 1095264;
        } else if ([blockHashString isEqualToString:@"000000000000001ebe8c3542f3a0f65a46d5f5ab4e380393bdbfda68d93221d7"]) {
            return 1094640;
        } else if ([blockHashString isEqualToString:@"000000000000000225158fd4c0fad459645bbcd1a93e843fe22b652ab40d7535"]) {
            return 1095240;
        } else if ([blockHashString isEqualToString:@"00000000000000025ea597f951845fd9f759d8dd7deb381b8c48bfde0a3c2d28"]) {
            return 1094328;
        } else if ([blockHashString isEqualToString:@"000000000000001cc1d7e03e3d37a6f0f62a8ac92a5c2947719140976559d91d"]) {
            return 1094280;
        } else if ([blockHashString isEqualToString:@"00000000000000129ebb2ed2350c8a39ee5c1cecb81baac16dc1e44a199c634a"]) {
            return 1095216;
        } else if ([blockHashString isEqualToString:@"000000000000001c12e0007f8ec718282fff6cd63519a4fdc8cca698216def72"]) {
            return 1094928;
        } else if ([blockHashString isEqualToString:@"000000000000001233f0f0963d1214b7cff3e091f56d7469f2ceed92fd0b1913"]) {
            return 1093272;
        } else if ([blockHashString isEqualToString:@"000000000000001a304f460bd6c35a29a6ba19aba6a7c37818d8870d1b90a757"]) {
            return 1094376;
        } else if ([blockHashString isEqualToString:@"0000000000000002c2037e0bdf7678cc1d2f307998d18b20f6799e2c04b861e1"]) {
            return 1093848;
        } else if ([blockHashString isEqualToString:@"0000000000000000ef3b052a6b6cf46fc53e7d700b35a640bea555537c963fe7"]) {
            return 1094856;
        } else if ([blockHashString isEqualToString:@"0000000000000024cdf66dd7b20dd03711b2961b82c627557dfbb9acbba620b9"]) {
            return 1093776;
        } else if ([blockHashString isEqualToString:@"000000000000002690fa0e9e0358d1088b995f947039fef48e851df2cc8a7c1a"]) {
            return 1094616;
        } else if ([blockHashString isEqualToString:@"000000000000001a1d7a8959d08fae46d1d77e380f643501045c9619b07cdb7d"]) {
            return 1095120;
        } else if ([blockHashString isEqualToString:@"000000000000002cef7980733f71f6b588a6d03a52103c637dca1ec3ae62296c"]) {
            return 1093872;
        } else if ([blockHashString isEqualToString:@"000000000000001a0228d6a5d3f5542eca7395cb91c0d028c8c988051e653fa7"]) {
            return 1094520;
        } else if ([blockHashString isEqualToString:@"000000000000001c0b637ceb8879087a960cde2cd6b179041df416cf2b5bd731"]) {
            return 1093728;
        } else if ([blockHashString isEqualToString:@"000000000000000772dfb8deff195bb86c24c825bd45155fa6abe7e2c824373f"]) {
            return 1094784;
        } else if ([blockHashString isEqualToString:@"0000000000000000615083ccea9f8d36dc9ca0129ee8932892989e4dee510067"]) {
            return 1093512;
        } else if ([blockHashString isEqualToString:@"0000000000000000ecede12e065e87251e1637894ef20f5a16195e94d28fabd1"]) {
            return 1095864;
        } else if ([blockHashString isEqualToString:@"00000000000000240088475057f73dd1ec5185a049f9591fe097ea5302fe1377"]) {
            return 1095720;
        } else if ([blockHashString isEqualToString:@"000000000000001171446990f2fc89a7ac9e59e8bf33368a7151a0b9a3a3e8ae"]) {
            return 1093992;
        } else if ([blockHashString isEqualToString:@"000000000000000071ae88cee71d08d320ce5091eb3877edb6cef554d6987d7f"]) {
            return 1094352;
        } else if ([blockHashString isEqualToString:@"00000000000000132a6410a26e6825470a33cbd8a14d8ef25e569c41c9413f5f"]) {
            return 1094688;
        } else if ([blockHashString isEqualToString:@"000000000000001aa62cfba8db7fffc42287e3bc9c3a67f07c38369f04b4255d"]) {
            return 1094952;
        } else if ([blockHashString isEqualToString:@"000000000000002344ae9bb8432a569ed0c949d86133799baa42d22336cbce2f"]) {
            return 1094472;
        } else if ([blockHashString isEqualToString:@"00000000000000084155d222800a8ea99afe4431dd0161cc888c2ebe177e19db"]) {
            return 1093656;
        } else if ([blockHashString isEqualToString:@"00000000000000196db62f3ac00a290c0de3606d4bf58c550154c358f9d2ee45"]) {
            return 1094136;
        } else if ([blockHashString isEqualToString:@"000000000000000e5458bc47813b49b23d3a3f015bd74628e1950bc51086891b"]) {
            return 1094976;
        } else if ([blockHashString isEqualToString:@"00000000000000111d542d60aad39dafafcc65335a4d516388dc51fcba89035b"]) {
            return 1095528;
        } else if ([blockHashString isEqualToString:@"000000000000001b0b31e0ec23c1ac6329de09c066720ecf166c474b56231025"]) {
            return 1093440;
        } else if ([blockHashString isEqualToString:@"000000000000001bac84d4f9f18082b7f9a838a6b0a3c4d8dbfb9e8f54163432"]) {
            return 1093584;
        } else if ([blockHashString isEqualToString:@"000000000000001c414007419fc22a2401b07ab430bf433c8cdfb8877fb6b5b7"]) {
            return 1092672;
        } else if ([blockHashString isEqualToString:@"000000000000001d78e3addb7fb4f4e4de083e10703081d9e5ebbcf94fc94cea"]) {
            return 1095672;
        } else if ([blockHashString isEqualToString:@"0000000000000006e0f176aa2fb71013645fae8f9635c41d79aba03abf2f968b"]) {
            return 1095696;
        } else if ([blockHashString isEqualToString:@"000000000000001e91a161d9c3c4d42c108ac1326d746f21646fb5a988cb15da"]) {
            return 1095360;
        } else if ([blockHashString isEqualToString:@"0000000000000027a2600911d015441d46e463f0ec693a72b8efb5dd196ff6a1"]) {
            return 1093320;
        } else if ([blockHashString isEqualToString:@"00000000000000171bc403369b98ed54ba716c532231d51740316ede6d3bff3a"]) {
            return 1093392;
        } else if ([blockHashString isEqualToString:@"00000000000000094fb5e8f10f035d1c96c7cab5aec44ada91ea535d8778e9ef"]) {
            return 1093704;
        } else if ([blockHashString isEqualToString:@"000000000000001c7298ff8e8b0ee663fa71fe61972523ba0a358b7975382a7a"]) {
            return 1096003;
        } else if ([blockHashString isEqualToString:@"0000000000000018a586b0d0ec8d74ad60381db5ed6449e4f86e63d28d131782"]) {
            return 1093464;
        } else if ([blockHashString isEqualToString:@"00000000000000062d649600eb61e4e5167aba3a2fb782920a5cea1955c2689a"]) {
            return 1093560;
        } else if ([blockHashString isEqualToString:@"00000000000000145abc88f4a079a42a16768c49381f17572c5ab6099170a09e"]) {
            return 1094568;
        } else if ([blockHashString isEqualToString:@"0000000000000012dbe5607c727e5ade78cdf401893be1f733a874c7612c3bd3"]) {
            return 1095792;
        } else if ([blockHashString isEqualToString:@"000000000000000117e4a3c462adac43c1e34470558241ba5f4a08f32cee9217"]) {
            return 1094760;
        } else if ([blockHashString isEqualToString:@"000000000000000c89a10adee5dd18be09c10f3997719f448621e3039a7078e2"]) {
            return 1095096;
        } else if ([blockHashString isEqualToString:@"000000000000000dcdb06cced0211b9ca62b2947a2bd6e9830340f2c37c64d52"]) {
            return 1093824;
        } else if ([blockHashString isEqualToString:@"0000000000000012d9cd9e407b037e64d33693a654eae85e54a2651d66dd5727"]) {
            return 1093608;
        } else if ([blockHashString isEqualToString:@"00000000000000144fabe7b89452957f62635a05c18a37fe9e276b1a623d3251"]) {
            return 1094496;
        } else if ([blockHashString isEqualToString:@"000000000000000fabcff485b9572368c3a06d985a1e4f77c53d735dc1af8507"]) {
            return 1094112;
        } else if ([blockHashString isEqualToString:@"000000000000000d0a9b48693d41fc615193591b158e2ec91de40875514b370c"]) {
            return 1095024;
        } else if ([blockHashString isEqualToString:@"00000000000000087c9bb2d682436a6f590878b2124cdeba1744ef064065f996"]) {
            return 1095000;
        } else if ([blockHashString isEqualToString:@"000000000000001577e4d463c654003d03833472a0de98922c98db18c33f92ca"]) {
            return 1093896;
        } else if ([blockHashString isEqualToString:@"000000000000001416a19e61b05a1f5e5956b0d0973e73f70af22500aff56cff"]) {
            return 1095984;
        } else if ([blockHashString isEqualToString:@"000000000000000dd26c943b68653b95a9bfc203e80c0050f6569156fe1fc94b"]) {
            return 1093296;
        } else if ([blockHashString isEqualToString:@"000000000000000dfcb3a329719799a15e19c0be15ebd2338b2220c9bb2fd7af"]) {
            return 1093344;
        } else if ([blockHashString isEqualToString:@"0000000000000009568e505b6d4b9b4330d0b4fe34c8602d2d45914aed6924f8"]) {
            return 1093536;
        } else if ([blockHashString isEqualToString:@"00000000000000020599bb1afc06a0e03f5333d7edf91bf2b038c7b2e9fb4dcb"]) {
            return 1095648;
        } else if ([blockHashString isEqualToString:@"000000000000001bc20fe2bb69d57c3ce9abc2b55aa8c5669f0fedc1e9a12b07"]) {
            return 1095888;
        } else if ([blockHashString isEqualToString:@"000000000000000ff47ccc841c8ef3dfc6dc419b677c0e3399af6badfac4353d"]) {
            return 1094832;
        } else if ([blockHashString isEqualToString:@"000000000000000ea92aa407cf31a16fabca0f0f74718424d91869ad1b58edaa"]) {
            return 1095192;
        } else if ([blockHashString isEqualToString:@"000000000000001613deacecc4a85816e91ce006dee30b352f9ad5c245fad9cc"]) {
            return 1094448;
        } else if ([blockHashString isEqualToString:@"00000000000000021eb17ff23549c328301f5df228d773c7d74ff5aae2baa466"]) {
            return 1093968;
        } else if ([blockHashString isEqualToString:@"0000000000000000b9cb58ca605b36d9604fa8e791125e4fe81d329acec4b1a8"]) {
            return 1095600;
        } else if ([blockHashString isEqualToString:@"00000000000000019ec163300f2acd0aee00e63f162713096c95a7e9d47dd50f"]) {
            return 1094208;
        } else if ([blockHashString isEqualToString:@"000000000000001822bf109723eff5f406422b54736b2384d9d0c69e97276a88"]) {
            return 1093488;
        } else if ([blockHashString isEqualToString:@"00000000000000251c624ba68d162f443b9b8662bd41c8cbaf76edf0edf09449"]) {
            return 1095336;
        } else if ([blockHashString isEqualToString:@"000000000000001da5926d2dc7cd624bc9576d4e98fcbf2d3cda45c47695f566"]) {
            return 1094424;
        } else if ([blockHashString isEqualToString:@"0000000000000012bcfc87a3d4accfa821544c4c43d8f8cd8a71c37cd2caff13"]) {
            return 1095936;
        } else if ([blockHashString isEqualToString:@"0000000000000003ba06634076289dff42839e247ae84ce1aab47ad902ae4705"]) {
            return 1093416;
        } else if ([blockHashString isEqualToString:@"000000000000000d5cadf1de431d8adda171a72296ded5c60a9f75d050cd9528"]) {
            return 1093248;
        } else if ([blockHashString isEqualToString:@"000000000000000aff92eefb5543f3afb2f145dd75ef504b2877013abe53a6b5"]) {
            return 1094904;
        } else if ([blockHashString isEqualToString:@"0000000000000020f1c98f7df0d89d369c9176644776b151ba8c230683b7d68a"]) {
            return 1094064;
        } else if ([blockHashString isEqualToString:@"000000000000000ecbdb940a8094d7643859b064fde0ed32096fa493e0cd776c"]) {
            return 1095048;
        } else if ([blockHashString isEqualToString:@"00000000000000062f90f8928ce313986c71663f868c434cccd455e152b3f2ff"]) {
            return 1095432;
        } else if ([blockHashString isEqualToString:@"0000000000000000983db6957230406f73a25d9ff929406db3607c62ba064dd3"]) {
            return 1094544;
        } else if ([blockHashString isEqualToString:@"000000000000000c61002a6ef01e82aced8d5b394ae8faa1143fd893abfdd916"]) {
            return 1094232;
        } else if ([blockHashString isEqualToString:@"0000000000000010a7cd881eeb0d4252bbb8661b1c9f5eb4addebb7e7e726b88"]) {
            return 1093752;
        } else if ([blockHashString isEqualToString:@"000000000000000e5d9359857518aaf3685bf8af55c675cf0d17a45383ca297f"]) {
            return 1091520;
        } else if ([blockHashString isEqualToString:@"0000000000000013fea89dca12ca39a3250bab6ff979c682b44c968892e7844e"]) {
            return 1095840;
        } else if ([blockHashString isEqualToString:@"0000000000000003c1e5392b90ce0083fd803797ce039f5b5e93b8581a9cd110"]) {
            return 1095312;
        } else if ([blockHashString isEqualToString:@"000000000000002283cf305dbfc4c37ec890d704eb2d267c9f5a418b0a171bb6"]) {
            return 1093920;
        } else if ([blockHashString isEqualToString:@"000000000000001b7b535dfeac3eb2cfb481cf9c1fcda57541449962edc3ad01"]) {
            return 1092960;
        } else if ([blockHashString isEqualToString:@"0000000000000024030fa272c48f386c079bfcf655d4b09f0f2d092bb67303bb"]) {
            return 1095408;
        } else if ([blockHashString isEqualToString:@"0000000000000016a94810e42937ff962a19bb3535b727088cb128c16e28475d"]) {
            return 1093800;
        } else if ([blockHashString isEqualToString:@"000000000000001b60d1cfaf8a46571472e51b0f9e6fe578049ebff252b53975"]) {
            return 1095912;
        } else if ([blockHashString isEqualToString:@"000000000000002406ca94753d91bae04ff66d83fbe7ff0e36649d44a09e7c34"]) {
            return 1094304;
        } else if ([blockHashString isEqualToString:@"0000000000000013ddc64c114e35eaa454da80454c7a6abd0fd186bc47b3135c"]) {
            return 1095384;
        } else if ([blockHashString isEqualToString:@"00000000000000189aaa0a392ba85175b6288d8685eeca3659c0cbe8feee4b2f"]) {
            return 1095768;
        } else if ([blockHashString isEqualToString:@"0000000000000002fa90f6d204488cb8386938173ed5eab5ab3df178866b058a"]) {
            return 1094088;
        } else if ([blockHashString isEqualToString:@"00000000000000143c121d0ebcc8ac6d22f5f2bf44b1b871569dec0e4df7c69c"]) {
            return 1095552;
        } else if ([blockHashString isEqualToString:@"000000000000001583b7dcc1e3c670561e3f3dbd83cc74d2414f3dc839596f27"]) {
            return 1094736;
        } else if ([blockHashString isEqualToString:@"000000000000000f9f34750629b5a2382268e8b6753afbd7c62735b82c452737"]) {
            return 1094040;
        } else if ([blockHashString isEqualToString:@"00000000000000010d1ec424a84a28093395309ea79ce7c4b6ab49e08f589750"]) {
            return 1095456;
        } else if ([blockHashString isEqualToString:@"000000000000000ebd63619a0cf899405d27aba2c07389de4016bc65a4d85fe1"]) {
            return 1095816;
        } else if ([blockHashString isEqualToString:@"000000000000000fa538169fbfd621d942d113ae6971b2fe9cffe02a5c9a25ae"]) {
            return 1094808;
        } else if ([blockHashString isEqualToString:@"00000000000000129dab8cc8befddb59cf7e3c3e249939eb5a00a5394648f1b2"]) {
            return 1095480;
        } else if ([blockHashString isEqualToString:@"00000000000000131b1a04b792ea5f4120014d67261db05da36c3e4cf424ff80"]) {
            return 1095624;
        } else if ([blockHashString isEqualToString:@"000000000000000edc8ad776fb0f9e407afae36237d2d8410b8f12424e892a6b"]) {
            return 1094016;
        } else if ([blockHashString isEqualToString:@"000000000000001e25b165b99d2e2174d01b8bce715915031bc59d3145a2993c"]) {
            return 1095288;
        } else if ([blockHashString isEqualToString:@"0000000000000016009c6bc3f60a97b8a8904e1f874b6308c3c3896a4aa69b89"]) {
            return 1095744;
        } else if ([blockHashString isEqualToString:@"00000000000000260b705a14af12641139fa368795d954d5878b94881edfa455"]) {
            return 1093368;
        } else if ([blockHashString isEqualToString:@"000000000000001bf5e83d6cf96fce19773074ae4a7bcd1956d59a9e414a0431"]) {
            return 1094712;
        } else if ([blockHashString isEqualToString:@"0000000000000003b27df3db412427df13ba3dceb7ac5af75a5a65fa5fd40a7b"]) {
            return 1095144;
        } else if ([blockHashString isEqualToString:@"00000000000000027ba127cd55d822250977b5d94148c71336745fe8899d886a"]) {
            return 1093632;
        } else if ([blockHashString isEqualToString:@"000000000000000e1f5cb67880ca2ac7c4e93f9636a7117880b1e46702078b01"]) {
            return 1094592;
        } else if ([blockHashString isEqualToString:@"000000000000000751157bca41a61d1df27a318a59d3234e1cabc4f7c31656e0"]) {
            return 1095576;
        } else if ([blockHashString isEqualToString:@"0000000000000017940e1aeb3bbf23165dabd152a8a8885c8ddf50e614a669d9"]) {
            return 1094184;
        } else if ([blockHashString isEqualToString:@"000000000000000cd0a2f51c3926225af4c8da1a95908ede547d6f6dd84fe72b"]) {
            return 1094664;
        } else if ([blockHashString isEqualToString:@"0000000000000021762a00c91394db56033e60c5031cd721d52767272ee252cc"]) {
            return 1094256;
        } else if ([blockHashString isEqualToString:@"000000000000000b90f59f6a103723e4482e1b588a8cd7f122ce27d5d694122d"]) {
            return 1095504;
        } else if ([blockHashString isEqualToString:@"000000000000001e1ca2cf3ca2369e9d7efc4446214c13bf1c2c1970abb0437b"]) {
            return 1094880;
        } else if ([blockHashString isEqualToString:@"000000000000001463f239c0d3e3b0f466a06ae25d4eb0e81c5799b9ee8192c2"]) {
            return 1093680;
        } else if ([blockHashString isEqualToString:@"0000000000000015a85e74db313a4b6020f073d0c3559180d22b6585fd51d090"]) {
            return 1095960;
        } else if ([blockHashString isEqualToString:@"0000000000000016d802959ea0c6d903b4e2c8241f3cc670e002d3ae51347749"]) {
            return 1094160;
        } else if ([blockHashString isEqualToString:@"00000000000000212441a8ef2495d21b0b7c09e13339dbc34d98c478cc51f8e2"]) {
            return 1092096;
        } else if ([blockHashString isEqualToString:@"000000000000000e78706ecf6d744a2edc5143d3325ade22940dc14ccfd3f938"]) {
            return 1094400;
        }
        NSAssert(NO, @"All values must be here");
        return UINT32_MAX;
    };

    [self loadMasternodeListsForFiles:files
                             withSave:YES
                           withReload:YES
                              onChain:chain
                            inContext:context
                    blockHeightLookup:blockHeightLookup
                           completion:^(BOOL success, NSDictionary *masternodeLists) {
                               [chain.chainManager.masternodeManager reloadMasternodeListsWithBlockHeightLookup:blockHeightLookup];
                               for (NSData *masternodeListBlockHash in masternodeLists) {
                                   NSLog(@"Testing masternode list at height %u", [chain heightForBlockHash:masternodeListBlockHash.UInt256]);
                                   DSMasternodeList *originalMasternodeList = [masternodeLists objectForKey:masternodeListBlockHash];
                                   DSMasternodeList *reloadedMasternodeList = [chain.chainManager.masternodeManager masternodeListForBlockHash:masternodeListBlockHash.UInt256 withBlockHeightLookup:blockHeightLookup];
                                   if (!uint256_eq([reloadedMasternodeList masternodeMerkleRootWithBlockHeightLookup:blockHeightLookup], [reloadedMasternodeList calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup])) {
                                       NSDictionary *comparisonResult = [originalMasternodeList compare:reloadedMasternodeList usingOurString:@"original" usingTheirString:@"reloaded" blockHeightLookup:blockHeightLookup];
                                       NSLog(@"Error comparison result is %@", comparisonResult);
                                   }
                                   XCTAssertEqualObjects(uint256_hex([reloadedMasternodeList masternodeMerkleRootWithBlockHeightLookup:blockHeightLookup]), uint256_hex([reloadedMasternodeList calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup]), @"These should be equal for height %d", reloadedMasternodeList.height);
                               }

                               [[DSOptionsManager sharedInstance] setUseCheckpointMasternodeLists:useCheckpointMasternodeLists];
                               dispatch_semaphore_signal(sem);
                           }];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
}

- (void)testQuorumIssue {
    DSChain *chain = [DSChain mainnet];
    __block NSManagedObjectContext *context = [NSManagedObjectContext chainContext];
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    __block BOOL useCheckpointMasternodeLists = [[DSOptionsManager sharedInstance] useCheckpointMasternodeLists];
    [[DSOptionsManager sharedInstance] setUseCheckpointMasternodeLists:NO];
    [chain chainManager];
    [context performBlockAndWait:^{
        DSChainEntity *chainEntity = [chain chainEntityInContext:context];
        [DSSimplifiedMasternodeEntryEntity deleteAllOnChainEntity:chainEntity];
        [DSQuorumEntryEntity deleteAllOnChainEntity:chainEntity];
        [DSMasternodeListEntity deleteAllOnChainEntity:chainEntity];
        [DSQuorumSnapshotEntity deleteAllOnChainEntity:chainEntity];
    }];
    [chain.chainManager.masternodeManager reloadMasternodeLists];
    NSArray *files = @[@"MNL_0_1096704", @"MNL_1096704_1097280", @"MNL_1097280_1097856", @"MNL_1097856_1098144", @"MNL_1098144_1098432", @"MNL_1098432_1098456", @"MNL_1098456_1098480", @"MNL_1098480_1098504", @"MNL_1098504_1098528", @"MNL_1098528_1098552", @"MNL_1098552_1098576", @"MNL_1098576_1098600", @"MNL_1098600_1098624", @"MNL_1098624_1098648", @"MNL_1098648_1098672", @"MNL_1098672_1098696", @"MNL_1098696_1098720", @"MNL_1098720_1098744", @"MNL_1098744_1098768", @"MNL_1098768_1098792", @"MNL_1098792_1098816", @"MNL_1098816_1098840", @"MNL_1098840_1098864", @"MNL_1098864_1098888", @"MNL_1098888_1098912", @"MNL_1098912_1098936", @"MNL_1098936_1098960", @"MNL_1098960_1098984", @"MNL_1098984_1099008"];

    BlockHeightFinder blockHeightLookup = ^uint32_t(UInt256 blockHash) {
        NSString *blockHashString = uint256_reverse_hex(blockHash);
        if ([blockHashString isEqualToString:@"00000ffd590b1485b3caadc19b22e6379c733355108f107a430458cdf3407ab6"]) {
            return 0;
        } else if ([blockHashString isEqualToString:@"0000000000000005f05fa51e0552ca6e46780be550da7230cd2d02f8ed4506ef"]) {
            return 1097808;
        } else if ([blockHashString isEqualToString:@"000000000000000faf2cac0d4b6b64fc168c3febe54a56a7ffc395cff98a9197"]) {
            return 1097208;
        } else if ([blockHashString isEqualToString:@"00000000000000096d80e8274bea062831d5befafae221dfcfd3717ce6cf6014"]) {
            return 1098576;
        } else if ([blockHashString isEqualToString:@"00000000000000123be8fccf32a966f94362e7676ff22e3fffc5acd0564478de"]) {
            return 1096392;
        } else if ([blockHashString isEqualToString:@"000000000000001d33b9dd2600867da9b4dceb9393bc5352d157dc0755255ae6"]) {
            return 1096224;
        } else if ([blockHashString isEqualToString:@"000000000000001aaa7a0a09708d929587fc17ff20e67cbd961e4661c210cd55"]) {
            return 1098288;
        } else if ([blockHashString isEqualToString:@"0000000000000005b792156d43ece54c07684f25a3bc68535635a168270c164f"]) {
            return 1098408;
        } else if ([blockHashString isEqualToString:@"000000000000000cb19c621f3f6f31890cfe20e96de7f07c7cc87df6e76c0fdb"]) {
            return 1096248;
        } else if ([blockHashString isEqualToString:@"000000000000000a4f7cd4fbdd47a1a3dabc82b7f48c5a47340c2440decd1ad1"]) {
            return 1098264;
        } else if ([blockHashString isEqualToString:@"000000000000001b6423cb52fefd813e6263dda5fd8e4f611c87c4c10f9efd63"]) {
            return 1098120;
        } else if ([blockHashString isEqualToString:@"000000000000000d81a502004fa824e8864fe72cce5e441c94e70781a1d5c248"]) {
            return 1098912;
        } else if ([blockHashString isEqualToString:@"000000000000002043543aca7a30d6ce95c030e51734341fdd2a8473eb07c4fc"]) {
            return 1098216;
        } else if ([blockHashString isEqualToString:@"00000000000000125044156d05c1b5309521483a76786cb549748b78bc1dd885"]) {
            return 1096176;
        } else if ([blockHashString isEqualToString:@"0000000000000008f5ae5a32a484eb829f78eece049e70395de65f0d03e20dd6"]) {
            return 1097448;
        } else if ([blockHashString isEqualToString:@"000000000000001168a451504cc254c531a006a77d707a279fbe9dd51a65acda"]) {
            return 1096824;
        } else if ([blockHashString isEqualToString:@"0000000000000017b0ee941a07532c47c814ec751854b551e3da2bf8addfc7da"]) {
            return 1096776;
        } else if ([blockHashString isEqualToString:@"000000000000000fc7af431ccc9374589ade89b86b826a38b0b36cadb2a0bdbf"]) {
            return 1096464;
        } else if ([blockHashString isEqualToString:@"00000000000000086edc17d34df01f002195a5d737063324f3e46930c57350b2"]) {
            return 1096896;
        } else if ([blockHashString isEqualToString:@"000000000000000812756367b7f38cc27ca1ac63f26c7ee81248be99b8a399fe"]) {
            return 1096944;
        } else if ([blockHashString isEqualToString:@"00000000000000226c79b8624a3b2855d8b84bc68a0b0f8461026e7cada81d4a"]) {
            return 1096368;
        } else if ([blockHashString isEqualToString:@"000000000000000e8cd9d448061b1a8198ad4741707b8d01a23b5b71cd7f5688"]) {
            return 1097784;
        } else if ([blockHashString isEqualToString:@"00000000000000037258bba0d30a803fd73fc60d27ce93b9f1293b52c78aa35f"]) {
            return 1097592;
        } else if ([blockHashString isEqualToString:@"000000000000001c7361f82e8da3d6a7fb34ad5ae4dde3ddcc1d9ddba8cafd39"]) {
            return 1097664;
        } else if ([blockHashString isEqualToString:@"000000000000000a37f2a18828ab4d27d2c1aae5e05a606ddba526750c024cd9"]) {
            return 1096416;
        } else if ([blockHashString isEqualToString:@"00000000000000015f263e5713680e8c256120ec739828028aa4124e1463f939"]) {
            return 1096536;
        } else if ([blockHashString isEqualToString:@"000000000000000dd632855f6ed62d0a421e9fbb6a4ef3a9b28aebf1af65e98b"]) {
            return 1098552;
        } else if ([blockHashString isEqualToString:@"0000000000000004586e94967e381843192f972678f1a1f58c4dde5e99d8fc44"]) {
            return 1097328;
        } else if ([blockHashString isEqualToString:@"0000000000000018534d3aae537bf48656883e4f441e0bd28670347cc5d0d6b1"]) {
            return 1097232;
        } else if ([blockHashString isEqualToString:@"0000000000000019112283be4f21b455b53a1b2ca7c04d4df4db64dc5eaf33e9"]) {
            return 1096344;
        } else if ([blockHashString isEqualToString:@"00000000000000120b56f64ed6c173562a814fef9cdb223f98ceb71ec0721453"]) {
            return 1098816;
        } else if ([blockHashString isEqualToString:@"000000000000001cc3f58f03c176be5a1aa858358d90d28396f5f14a5841dfc8"]) {
            return 1096296;
        } else if ([blockHashString isEqualToString:@"000000000000002021e36a9eb14321eea04df8c2d9f5a98aba4ae110811a265a"]) {
            return 1098360;
        } else if ([blockHashString isEqualToString:@"000000000000000080cc4309a7447bb9ece31700769dc379572d22e45798fa2f"]) {
            return 1098168;
        } else if ([blockHashString isEqualToString:@"0000000000000002d799bd937089094546ea6910362cdde13305a190cc228966"]) {
            return 1097760;
        } else if ([blockHashString isEqualToString:@"000000000000000d02d05da2fa63761aebc1dc6ad313da63b10809026aa32012"]) {
            return 1096632;
        } else if ([blockHashString isEqualToString:@"0000000000000016174a372e62c8c18817df356487d539135ead487ecec8d276"]) {
            return 1097160;
        } else if ([blockHashString isEqualToString:@"000000000000000b62b169b3621aca12f2a4b1faa5443e52c435118f0a185a1a"]) {
            return 1098768;
        } else if ([blockHashString isEqualToString:@"000000000000000e5458bc47813b49b23d3a3f015bd74628e1950bc51086891b"]) {
            return 1094976;
        } else if ([blockHashString isEqualToString:@"000000000000001a7eaa4cb338614eaa498c87171a5459c35b1879267896a8b8"]) {
            return 1096728;
        } else if ([blockHashString isEqualToString:@"000000000000000cf068c8605300fa6eaabf1cd72f0baa91ebbfc7f615efffb0"]) {
            return 1097904;
        } else if ([blockHashString isEqualToString:@"000000000000000a7db9d1cb6e97587548d12f9b15e1d7217c3bb9fc5f7aca62"]) {
            return 1096992;
        } else if ([blockHashString isEqualToString:@"00000000000000120aa3e7d582a37cd1ba9e33f7255643886dfce934e608f588"]) {
            return 1098144;
        } else if ([blockHashString isEqualToString:@"0000000000000006859c3d9a085c3bbe1aada948f6d573af21b41c68e66b9ac8"]) {
            return 1098840;
        } else if ([blockHashString isEqualToString:@"00000000000000199f543a7d3e9f6372d950721a88a9a10aa92917c7a663695b"]) {
            return 1098672;
        } else if ([blockHashString isEqualToString:@"00000000000000184ffe2c87ee0e8046b630bbb67e8708a59d78a501c22f7ead"]) {
            return 1096440;
        } else if ([blockHashString isEqualToString:@"00000000000000128cc9aebae3ea0753103e4c53286b2370e1dab2655ce68b19"]) {
            return 1098528;
        } else if ([blockHashString isEqualToString:@"0000000000000000fd8021168f6be48e6c1444e29f85fa72c654b4f616c071f6"]) {
            return 1098312;
        } else if ([blockHashString isEqualToString:@"0000000000000017693260e70c48015796efdbf6cfb36c3ed16a0ce0aa72110e"]) {
            return 1097520;
        } else if ([blockHashString isEqualToString:@"000000000000001ffbd9b2b064b32e64c6d3a3dae13780a8f67dd8123a52f824"]) {
            return 1096680;
        } else if ([blockHashString isEqualToString:@"000000000000000b08d1bcf29d13fc4cb8972420979a7cca01bb3e76e848b341"]) {
            return 1097880;
        } else if ([blockHashString isEqualToString:@"00000000000000138ee64cdd6c5c9eb641be56002a08cc4da3947c9a8427b811"]) {
            return 1097424;
        } else if ([blockHashString isEqualToString:@"00000000000000022ba51a9c85c3f2908e050e251031c127c379ed4c84dc3995"]) {
            return 1098024;
        } else if ([blockHashString isEqualToString:@"00000000000000069501469ea47bdc919909737c7ae881cb0048dc7406a547f4"]) {
            return 1098432;
        } else if ([blockHashString isEqualToString:@"000000000000001d396bfa004a77bc6a590ebd4e62c3be62e17c9f9183b6b2a6"]) {
            return 1097472;
        } else if ([blockHashString isEqualToString:@"000000000000000e5442292206c610d87af06af00500a22b3bf478d3ac05ab65"]) {
            return 1098984;
        } else if ([blockHashString isEqualToString:@"000000000000001212cd887e2064e0fef2efe30efad366a3043ac618c8d1f7e0"]) {
            return 1097136;
        } else if ([blockHashString isEqualToString:@"0000000000000017dd8f722b72713df020c25cd8bb189e1516fbb97f91712276"]) {
            return 1098000;
        } else if ([blockHashString isEqualToString:@"0000000000000017bb50e264cebfec81804847bb19b759e1deed6d5ccd54af70"]) {
            return 1096488;
        } else if ([blockHashString isEqualToString:@"000000000000000076e6e626df28690678d026dcb7655433cb77cbbce4585ab9"]) {
            return 1097352;
        } else if ([blockHashString isEqualToString:@"000000000000000b0e12838219dce4ee33bd3ebf148a6655cdef57f5ac74dec1"]) {
            return 1098744;
        } else if ([blockHashString isEqualToString:@"000000000000000ee7034001ad0ed7040a4a55a388824624b2770154cb7b2778"]) {
            return 1098480;
        } else if ([blockHashString isEqualToString:@"0000000000000002ae77e6e7922c995ab76163717382c2290699125b017aeb83"]) {
            return 1096608;
        } else if ([blockHashString isEqualToString:@"000000000000000e40f843520b37a0299e0f73c03cc09e20e1f7e1d15db0eac3"]) {
            return 1097496;
        } else if ([blockHashString isEqualToString:@"000000000000000931d7809849ee2c0520274565043c91011abab799484c2990"]) {
            return 1097304;
        } else if ([blockHashString isEqualToString:@"0000000000000000049b8adab54f72710bf6d897597766529325c713de86b5e4"]) {
            return 1098648;
        } else if ([blockHashString isEqualToString:@"000000000000002156a89bfcb10462994d1d0953b418583140f2874b84a750ca"]) {
            return 1097256;
        } else if ([blockHashString isEqualToString:@"0000000000000012d25cbba3536d24aa5cc53c622eeac03c65412383147f4394"]) {
            return 1099008;
        } else if ([blockHashString isEqualToString:@"000000000000000787490f469efdfb1dbf6b86150b86c48f127f7653211b2c41"]) {
            return 1098096;
        } else if ([blockHashString isEqualToString:@"000000000000000a3a980aec3a4421b54dbbb407f30ee949c13e3665cc372009"]) {
            return 1098624;
        } else if ([blockHashString isEqualToString:@"000000000000001fb0ced1479e7d15e7efed4b92b1d5ec43a1da297e8dc64a1e"]) {
            return 1097376;
        } else if ([blockHashString isEqualToString:@"0000000000000016f526c58ea7a5ba4091426d3d9d11434ef422cd6cbfa0a4d1"]) {
            return 1098960;
        } else if ([blockHashString isEqualToString:@"00000000000000057f1c57f1183758044c52c33ddd6b8ab2171afcb980062117"]) {
            return 1096560;
        } else if ([blockHashString isEqualToString:@"000000000000000c595ba7f4da46fb33fdfb5cbff49a5af1536de6baaf364658"]) {
            return 1098240;
        } else if ([blockHashString isEqualToString:@"0000000000000023382f4fda810321271b8d5b32fc5c0a8ae82d6e35e73ea7d5"]) {
            return 1097064;
        } else if ([blockHashString isEqualToString:@"000000000000001ad5328d0a3c97209bbbca4bb35d76119a8ac0231a36aa75c9"]) {
            return 1097280;
        } else if ([blockHashString isEqualToString:@"00000000000000106c3b9664269e2a92d53266f5485f24266e61d12f902f85ea"]) {
            return 1098720;
        } else if ([blockHashString isEqualToString:@"0000000000000018925fd95309371243ef4df332801968084363af572f6c5d45"]) {
            return 1097616;
        } else if ([blockHashString isEqualToString:@"0000000000000011038e77a86801cb5f05047d45e57b8a95b715f7f5bed2ac70"]) {
            return 1096272;
        } else if ([blockHashString isEqualToString:@"000000000000000f7943a003184c5e99b5951fa80d80d6585721e1819b046617"]) {
            return 1096512;
        } else if ([blockHashString isEqualToString:@"000000000000000e0e3a7248d77f94d3013cae7b27090941a944926683c7126c"]) {
            return 1096152;
        } else if ([blockHashString isEqualToString:@"000000000000000acc62d1c58e0cf316573ca248fcaefc98f77619d227d93413"]) {
            return 1096320;
        } else if ([blockHashString isEqualToString:@"0000000000000012b1e0582fa3c805bb15ebab29792766815ea008254395aebf"]) {
            return 1096848;
        } else if ([blockHashString isEqualToString:@"0000000000000016f620befa318c8b40bc5d9a955121261af09ac8ddeef93e5e"]) {
            return 1097088;
        } else if ([blockHashString isEqualToString:@"0000000000000017ae9d4db3c6e6fdf7827824423caa4599219f3af795ec6404"]) {
            return 1096704;
        } else if ([blockHashString isEqualToString:@"0000000000000013fea89dca12ca39a3250bab6ff979c682b44c968892e7844e"]) {
            return 1095840;
        } else if ([blockHashString isEqualToString:@"000000000000000c43df820465cf30f4e9d8a38330c5f7c4fcb90780aa88df38"]) {
            return 1096656;
        } else if ([blockHashString isEqualToString:@"0000000000000006b8f4ccbf679f3f5744d879c02851a361ef7e1e0ed9d57e18"]) {
            return 1097016;
        } else if ([blockHashString isEqualToString:@"000000000000001ad3de1c97c51b31072ea54380034b01bdf7da610b77f75189"]) {
            return 1098048;
        } else if ([blockHashString isEqualToString:@"000000000000001efb6b66a1cd0f2c6a41c9a820db8fc5de159aa186a09a4ce2"]) {
            return 1098936;
        } else if ([blockHashString isEqualToString:@"00000000000000005d2b5286b448a25d9c2006849d41fb0c9c4bb3bb8724c42d"]) {
            return 1098864;
        } else if ([blockHashString isEqualToString:@"0000000000000008997ba7c5b584a4dbffd17a8b5cd08cae51e7e6371f0ec3ca"]) {
            return 1098696;
        } else if ([blockHashString isEqualToString:@"0000000000000022a46ff5bb17d406fa821f70aa80c2b9aa37bc21edaea2569a"]) {
            return 1098072;
        } else if ([blockHashString isEqualToString:@"00000000000000125d8731954a9c15b86b34e78c1fbe2ca29bd3a99f38462689"]) {
            return 1098888;
        } else if ([blockHashString isEqualToString:@"0000000000000016ad254676362d6cad62acaa1f9900b6c951cfd73303fa0356"]) {
            return 1098792;
        } else if ([blockHashString isEqualToString:@"0000000000000020d7ac24b497e420c8eeb9de5ba55a4a204130dda9e09fc85a"]) {
            return 1097568;
        } else if ([blockHashString isEqualToString:@"000000000000001e3c72bec566addb499b9f633effe8cb4f1ddab303fa155d13"]) {
            return 1097544;
        } else if ([blockHashString isEqualToString:@"00000000000000143c121d0ebcc8ac6d22f5f2bf44b1b871569dec0e4df7c69c"]) {
            return 1095552;
        } else if ([blockHashString isEqualToString:@"000000000000001e1c9372e3d2db633498af3c900f87de1c5f19ed05a0df4072"]) {
            return 1097736;
        } else if ([blockHashString isEqualToString:@"00000000000000185588f0dcad30cbe720b5bc67abfae54e64d9f92e1e0b2d22"]) {
            return 1097040;
        } else if ([blockHashString isEqualToString:@"000000000000000185765bff94d5da02e62261ab2366d2ccaa0d86685c0485de"]) {
            return 1097976;
        } else if ([blockHashString isEqualToString:@"000000000000000557d8eb6ecdf684f3b7f3219794047ac4f44eff0d9bfbdb7b"]) {
            return 1097184;
        } else if ([blockHashString isEqualToString:@"00000000000000063d1eabcc5c29a51c0aa354b758b33e70f722f78c46741342"]) {
            return 1096200;
        } else if ([blockHashString isEqualToString:@"00000000000000134b8226f8db668803ee6abcfe4df2809b36de36205bd80227"]) {
            return 1096920;
        } else if ([blockHashString isEqualToString:@"000000000000001afbb65ce325134464e74de2c9e1f67c61501c434e82514094"]) {
            return 1097688;
        } else if ([blockHashString isEqualToString:@"000000000000000178d6cb5792aea8a9e51a716df4b20018761509dddd881b6b"]) {
            return 1097112;
        } else if ([blockHashString isEqualToString:@"0000000000000020eeb077e77f9e3e60975e2a7426b6084ff8ad5ca43ef17c41"]) {
            return 1096968;
        } else if ([blockHashString isEqualToString:@"000000000000000db1e46a7e9890b842506e2775fd4723fbbe2d420609087f21"]) {
            return 1096128;
        } else if ([blockHashString isEqualToString:@"00000000000000029151942416b68ff4aada689b12e47cc09ce7b802ded57505"]) {
            return 1096800;
        } else if ([blockHashString isEqualToString:@"000000000000001c5cdb520ddc3ec0511790352f6177d5e598656f83690bd734"]) {
            return 1096584;
        } else if ([blockHashString isEqualToString:@"0000000000000012bf85edb70e524a05c56644b0bdb0ce4a2d6d12739463c52b"]) {
            return 1096752;
        } else if ([blockHashString isEqualToString:@"000000000000000e5535ad543a6bfb463bc8f0636aac6a3e7f79683b7c94bf6f"]) {
            return 1097832;
        } else if ([blockHashString isEqualToString:@"0000000000000010404aecc04aff5a2be47a5c6caeeea32160df9fe8c47511ed"]) {
            return 1097856;
        } else if ([blockHashString isEqualToString:@"0000000000000001cf3f3937abd607c9ab0a50a354edf3614378aca4fb8fdf5e"]) {
            return 1098384;
        } else if ([blockHashString isEqualToString:@"00000000000000157572263a4b5a3c7a22f10c66c423be1d5a51aa24bc9f724b"]) {
            return 1097400;
        } else if ([blockHashString isEqualToString:@"000000000000001dcf7e0c3a9130750540511e0cf631ea2f81aac7617c821755"]) {
            return 1098504;
        } else if ([blockHashString isEqualToString:@"00000000000000071e19fd57488218254d12b773d3a7f8b2dc53b9d45805c9a8"]) {
            return 1096872;
        } else if ([blockHashString isEqualToString:@"00000000000000095ea3c8e00a43086c7d5f6ececc6642721f733eb27229ff86"]) {
            return 1097712;
        } else if ([blockHashString isEqualToString:@"000000000000000eb3238f4d8a2f95b0a4692548b6547cf495e4ce790e61d2b5"]) {
            return 1098192;
        } else if ([blockHashString isEqualToString:@"0000000000000016570cdc593f871223b3aec795c1049c2d40c702925e0d2800"]) {
            return 1098456;
        } else if ([blockHashString isEqualToString:@"00000000000000169f9688971408aadfd3159740d11b9f504719ceaafe117a26"]) {
            return 1098600;
        } else if ([blockHashString isEqualToString:@"0000000000000000cfd7003a6aa0b1e0ae1c556a9b83a064771e2ba5a4668169"]) {
            return 1097640;
        } else if ([blockHashString isEqualToString:@"00000000000000247cb10a7d823736b672866e1d015ce1446a9e0b3c87eb25e5"]) {
            return 1098336;
        } else if ([blockHashString isEqualToString:@"000000000000001df6026dcd49b32b8cda38807cc475d6868679e6eb77e5edf4"]) {
            return 1097952;
        } else if ([blockHashString isEqualToString:@"000000000000000e78706ecf6d744a2edc5143d3325ade22940dc14ccfd3f938"]) {
            return 1094400;
        } else if ([blockHashString isEqualToString:@"0000000000000000000000000000000000000000000000000000000000000000"]) {
            // Now we're storing base_block_height in diff so here can be zero hash
            return UINT32_MAX;
        }
        NSLog(@"--- %@", blockHashString);
        NSAssert(NO, @"All values must be here");
        return UINT32_MAX;
    };

    [self loadMasternodeListsForFiles:files
                             withSave:YES
                           withReload:YES
                              onChain:chain
                            inContext:context
                    blockHeightLookup:blockHeightLookup
                           completion:^(BOOL success, NSDictionary *masternodeLists) {
                               [chain.chainManager.masternodeManager reloadMasternodeListsWithBlockHeightLookup:blockHeightLookup];
                               for (NSData *masternodeListBlockHash in masternodeLists) {
                                   NSLog(@"Testing quorum of masternode list at height %u", blockHeightLookup(masternodeListBlockHash.UInt256));
                                   DSMasternodeList *originalMasternodeList = [masternodeLists objectForKey:masternodeListBlockHash];
                                   DSMasternodeList *reloadedMasternodeList = [chain.chainManager.masternodeManager masternodeListForBlockHash:masternodeListBlockHash.UInt256 withBlockHeightLookup:blockHeightLookup];
                                   XCTAssert(reloadedMasternodeList != nil, @"reloadedMasternodeList should exist");
#define LOG_QUORUM_ISSUE_COMPARISON_RESULT 1
                                   if (!uint256_eq([originalMasternodeList masternodeMerkleRootWithBlockHeightLookup:blockHeightLookup], [reloadedMasternodeList calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup])) {
                                       NSLog(@"%u original %@", blockHeightLookup(masternodeListBlockHash.UInt256), [originalMasternodeList toDictionaryUsingBlockHeightLookup:blockHeightLookup]);
                                       NSLog(@"%u reloaded %@", blockHeightLookup(masternodeListBlockHash.UInt256), [reloadedMasternodeList toDictionaryUsingBlockHeightLookup:blockHeightLookup]);
                                       NSDictionary *comparisonResult = [originalMasternodeList compare:reloadedMasternodeList usingOurString:@"original" usingTheirString:@"reloaded" blockHeightLookup:blockHeightLookup];
                                       NSLog(@"QUORUM_ISSUE_COMPARISON_RESULT %u %@", blockHeightLookup(masternodeListBlockHash.UInt256), comparisonResult);
                                   } else {
#if LOG_QUORUM_ISSUE_COMPARISON_RESULT
                                       if ((blockHeightLookup(masternodeListBlockHash.UInt256)) == 1097280) {
                                           NSDictionary *comparisonResult = [originalMasternodeList compare:reloadedMasternodeList usingOurString:@"original" usingTheirString:@"reloaded" blockHeightLookup:blockHeightLookup];
                                           NSLog(@"QUORUM_ISSUE_COMPARISON_RESULT %u %@", blockHeightLookup(masternodeListBlockHash.UInt256), comparisonResult);
                                       }
#endif
                                   }
                                   XCTAssertEqualObjects(uint256_hex([originalMasternodeList masternodeMerkleRootWithBlockHeightLookup:blockHeightLookup]), uint256_hex([reloadedMasternodeList calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup]), @"These should be equal for height %d", originalMasternodeList.height);
                               }
                               [[DSOptionsManager sharedInstance] setUseCheckpointMasternodeLists:useCheckpointMasternodeLists];
                               dispatch_semaphore_signal(sem);
                           }];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
}

- (void)testMNLSavingAndRetrievingInIncorrectOrderFromDisk {
    DSChain *chain = [DSChain mainnet];
    __block NSManagedObjectContext *context = [NSManagedObjectContext chainContext];
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    [chain chainManager];
    [context performBlockAndWait:^{
        DSChainEntity *chainEntity = [chain chainEntityInContext:context];
        [DSSimplifiedMasternodeEntryEntity deleteAllOnChainEntity:chainEntity];
        [DSQuorumEntryEntity deleteAllOnChainEntity:chainEntity];
        [DSMasternodeListEntity deleteAllOnChainEntity:chainEntity];
        [DSQuorumSnapshotEntity deleteAllOnChainEntity:chainEntity];
    }];
    [chain.chainManager.masternodeManager reloadMasternodeLists];
    NSArray *files = @[@"MNL_0_1090944", @"MNL_1090944_1091520", @"MNL_1091520_1091808", @"MNL_1091808_1092096", @"MNL_1092096_1092336", @"MNL_1092336_1092360", @"MNL_1092360_1092384", @"MNL_1092384_1092408", @"MNL_1092408_1092432", @"MNL_1092432_1092456", @"MNL_1092456_1092480", @"MNL_1092480_1092504", @"MNL_1092504_1092528", @"MNL_1092528_1092552", @"MNL_1092552_1092576", @"MNL_1092576_1092600", @"MNL_1092600_1092624", @"MNL_1092624_1092648", @"MNL_1092648_1092672", @"MNL_1092672_1092696", @"MNL_1092696_1092720", @"MNL_1092720_1092744", @"MNL_1092744_1092768", @"MNL_1092768_1092792", @"MNL_1092792_1092816", @"MNL_1092816_1092840", @"MNL_1092840_1092864", @"MNL_1092864_1092888", @"MNL_1092888_1092916"];
    MerkleRootFinder merkleRootLookup = ^UInt256(UInt256 blockHash) {
        return UINT256_ZERO;
    };
    BlockHeightFinder blockHeightLookup = ^uint32_t(UInt256 blockHash) {
        NSString *blockHashString = uint256_reverse_hex(blockHash);
        if ([blockHashString isEqualToString:@"00000ffd590b1485b3caadc19b22e6379c733355108f107a430458cdf3407ab6"]) {
            return 0;
        } else if ([blockHashString isEqualToString:@"000000000000000bf16cfee1f69cd472ac1d0285d74d025caa27cebb0fb6842f"]) {
            return 1090392;
        } else if ([blockHashString isEqualToString:@"000000000000000d6f921ffd1b48815407c1d54edc93079b7ec37a14a9c528f7"]) {
            return 1090776;
        } else if ([blockHashString isEqualToString:@"000000000000000c559941d24c167053c5c00aea59b8521f5cef764271dbd3c5"]) {
            return 1091280;
        } else if ([blockHashString isEqualToString:@"0000000000000003269a36d2ce1eee7753a2d2db392fff364f64f5a409805ca3"]) {
            return 1092840;
        } else if ([blockHashString isEqualToString:@"000000000000001a505b133ea44b594b194f12fa08650eb66efb579b1600ed1e"]) {
            return 1090368;
        } else if ([blockHashString isEqualToString:@"0000000000000006998d05eff0f4e9b6a7bab1447534eccb330972a7ef89ef65"]) {
            return 1091424;
        } else if ([blockHashString isEqualToString:@"000000000000001d9b6925a0bc2b744dfe38ff7da2ca0256aa555bb688e21824"]) {
            return 1090920;
        } else if ([blockHashString isEqualToString:@"000000000000000c22e2f5ca2113269ec62193e93158558c8932ba1720cea64f"]) {
            return 1092648;
        } else if ([blockHashString isEqualToString:@"0000000000000020019489504beba1d6197857e63c44da3eb9e3b20a24f40d1e"]) {
            return 1092168;
        } else if ([blockHashString isEqualToString:@"00000000000000112e41e4b3afda8b233b8cc07c532d2eac5de097b68358c43e"]) {
            return 1088640;
        } else if ([blockHashString isEqualToString:@"00000000000000143df6e8e78a3e79f4deed38a27a05766ad38e3152f8237852"]) {
            return 1090944;
        } else if ([blockHashString isEqualToString:@"0000000000000028d39e78ee49a950b66215545163b53331115e6e64d4d80328"]) {
            return 1091184;
        } else if ([blockHashString isEqualToString:@"00000000000000093b22f6342de731811a5b3fa51f070b7aac6d58390d8bfe8c"]) {
            return 1091664;
        } else if ([blockHashString isEqualToString:@"00000000000000037187889dd360aafc49d62a7e76f4ab6cd2813fdf610a7292"]) {
            return 1092504;
        } else if ([blockHashString isEqualToString:@"000000000000000aee08f8aaf8a5232cc692ef5fcc016786af72bd9b001ae43b"]) {
            return 1090992;
        } else if ([blockHashString isEqualToString:@"000000000000002395b6c4e4cb829556d42c659b585ee4c131a683b9f7e37706"]) {
            return 1092192;
        } else if ([blockHashString isEqualToString:@"00000000000000048a9b52e6f46f74d92eb9740e27c1d66e9f2eb63293e18677"]) {
            return 1091976;
        } else if ([blockHashString isEqualToString:@"000000000000001b4d519e0a9215e84c3007597cef6823c8f1c637d7a46778f0"]) {
            return 1091448;
        } else if ([blockHashString isEqualToString:@"000000000000001730249b150b8fcdb1078cd0dbbfa04fb9a18d26bf7a3e80f2"]) {
            return 1092528;
        } else if ([blockHashString isEqualToString:@"000000000000001c3073ff2ee0af660c66762af38e2c5782597e32ed690f0f72"]) {
            return 1092072;
        } else if ([blockHashString isEqualToString:@"000000000000000c49954d58132fb8a1c90e4e690995396be91d8f27a07de349"]) {
            return 1092624;
        } else if ([blockHashString isEqualToString:@"00000000000000016200a3f98e44f4b9e65da04b86bad799e6bbfa8972f0cead"]) {
            return 1090080;
        } else if ([blockHashString isEqualToString:@"000000000000000a80933f2b9b8041fdfc6e94b77ba8786e159669f959431ff2"]) {
            return 1092600;
        } else if ([blockHashString isEqualToString:@"00000000000000153afcdccc3186ad2ca4ed10a79bfb01a2c0056c23fe039d86"]) {
            return 1092456;
        } else if ([blockHashString isEqualToString:@"00000000000000103bad71d3178a6c9a2f618d9d09419b38e9caee0fddbf664a"]) {
            return 1092864;
        } else if ([blockHashString isEqualToString:@"000000000000001b732bc6d52faa8fae97d76753c8e071767a37ba509fe5c24a"]) {
            return 1092360;
        } else if ([blockHashString isEqualToString:@"000000000000001a17f82d76a0d5aa2b4f90a6e487df366d437c34e8453f519c"]) {
            return 1091112;
        } else if ([blockHashString isEqualToString:@"000000000000000caa00c2c24a385513a1687367157379a57b549007e18869d8"]) {
            return 1090680;
        } else if ([blockHashString isEqualToString:@"0000000000000022e463fe13bc19a1fe654c817cb3b8e207cdb4ff73fe0bcd2c"]) {
            return 1091736;
        } else if ([blockHashString isEqualToString:@"000000000000001b33b86b6a167d37e3fcc6ba53e02df3cb06e3f272bb89dd7d"]) {
            return 1092744;
        } else if ([blockHashString isEqualToString:@"0000000000000006051479afbbb159d722bb8feb10f76b8900370ceef552fc49"]) {
            return 1092432;
        } else if ([blockHashString isEqualToString:@"0000000000000008cc37827fd700ec82ee8b54bdd37d4db4319496977f475cf8"]) {
            return 1091328;
        } else if ([blockHashString isEqualToString:@"0000000000000006242af03ba5e407c4e8412ef9976da4e7f0fa2cbe9889bcd2"]) {
            return 1089216;
        } else if ([blockHashString isEqualToString:@"000000000000001dc4a842ede88a3cc975e2ade4338513d546c52452ab429ba0"]) {
            return 1091496;
        } else if ([blockHashString isEqualToString:@"0000000000000010d30c51e8ce1730aae836b00cd43f3e70a1a37d40b47580fd"]) {
            return 1092816;
        } else if ([blockHashString isEqualToString:@"00000000000000212441a8ef2495d21b0b7c09e13339dbc34d98c478cc51f8e2"]) {
            return 1092096;
        } else if ([blockHashString isEqualToString:@"00000000000000039d7eb80e1bbf6f7f0c43f7f251f30629d858bbcf6a18ab58"]) {
            return 1090728;
        } else if ([blockHashString isEqualToString:@"0000000000000004532e9c4a1def38cd71f3297c684bfdb2043c2aec173399e0"]) {
            return 1091904;
        } else if ([blockHashString isEqualToString:@"000000000000000b73060901c41d098b91f69fc4f27aef9d7ed7f2296953e407"]) {
            return 1090560;
        } else if ([blockHashString isEqualToString:@"0000000000000016659fb35017e1f6560ba7036a3433bfb924d85e3fdfdd3b3d"]) {
            return 1091256;
        } else if ([blockHashString isEqualToString:@"000000000000000a3c6796d85c8c49b961363ee88f14bff10c374cd8dd89a9f6"]) {
            return 1092696;
        } else if ([blockHashString isEqualToString:@"000000000000000f33533ba1c5d72f678ecd87abe7e974debda238c53b391737"]) {
            return 1092720;
        } else if ([blockHashString isEqualToString:@"000000000000000150907537f4408ff4a8610ba8ce2395faa7e44541ce2b6c37"]) {
            return 1090608;
        } else if ([blockHashString isEqualToString:@"000000000000001977d3a578e0ac3e4969675a74afe7715b8ffd9f29fbbe7c36"]) {
            return 1091400;
        } else if ([blockHashString isEqualToString:@"0000000000000004493e40518e7d3aff585e84564bcd80927f96a07ec80259cb"]) {
            return 1092480;
        } else if ([blockHashString isEqualToString:@"000000000000000df5e2e0eb7eaa36fcef28967f7f12e539f74661e03b13bdba"]) {
            return 1090704;
        } else if ([blockHashString isEqualToString:@"00000000000000172f1765f4ed1e89ba4b717a475e9e37124626b02d566d31a2"]) {
            return 1090632;
        } else if ([blockHashString isEqualToString:@"0000000000000018e62a4938de3428ddaa26e381139489ce1a618ed06d432a38"]) {
            return 1092024;
        } else if ([blockHashString isEqualToString:@"000000000000000790bd24e65daaddbaeafdb4383c95d64c0d055e98625746bc"]) {
            return 1091832;
        } else if ([blockHashString isEqualToString:@"0000000000000005f28a2cb959b316cd4b43bd29819ea07c27ec96a7d5e18ab7"]) {
            return 1092408;
        } else if ([blockHashString isEqualToString:@"00000000000000165a4ace8de9e7a4ba0cddced3434c7badc863ff9e237f0c8a"]) {
            return 1091088;
        } else if ([blockHashString isEqualToString:@"00000000000000230ec901e4d372a93c712d972727786a229e98d12694be9d34"]) {
            return 1090416;
        } else if ([blockHashString isEqualToString:@"000000000000000bf51de942eb8610caaa55a7f5a0e5ca806c3b631948c5cdcc"]) {
            return 1092336;
        } else if ([blockHashString isEqualToString:@"000000000000002323d7ba466a9b671d335c3b2bf630d08f078e4adee735e13a"]) {
            return 1090464;
        } else if ([blockHashString isEqualToString:@"0000000000000019db2ad91ab0f67d90df222ce4057f343e176f8786865bcda9"]) {
            return 1091568;
        } else if ([blockHashString isEqualToString:@"0000000000000004a38d87062bf37ef978d1fc8718f03d9222c8aa7aa8a4470f"]) {
            return 1090896;
        } else if ([blockHashString isEqualToString:@"0000000000000022c909de83351791e0b69d4b4be34b25c8d54c8be3e8708c87"]) {
            return 1091592;
        } else if ([blockHashString isEqualToString:@"0000000000000008f3dffcf342279c8b50e49c47e191d3df453fdcd816aced46"]) {
            return 1092792;
        } else if ([blockHashString isEqualToString:@"000000000000001d1d7f1b88d6518e6248616c50e4c0abaee6116a72bc998679"]) {
            return 1092048;
        } else if ([blockHashString isEqualToString:@"0000000000000020de87be47c5c10a50c9edfd669a586f47f44fa22ae0b2610a"]) {
            return 1090344;
        } else if ([blockHashString isEqualToString:@"0000000000000014d1d8d12dd5ff570b06e76e0bbf55d762a94d13b1fe66a922"]) {
            return 1091760;
        } else if ([blockHashString isEqualToString:@"000000000000000962d0d319a96d972215f303c588bf50449904f9a1a8cbc7c2"]) {
            return 1089792;
        } else if ([blockHashString isEqualToString:@"00000000000000171c58d1d0dbae71973530aa533e4cd9cb2d2597ec30d9b129"]) {
            return 1091352;
        } else if ([blockHashString isEqualToString:@"0000000000000004acf649896a7b22783810d5913b31922e3ea224dd4530b717"]) {
            return 1092144;
        } else if ([blockHashString isEqualToString:@"0000000000000013479b902955f8ba2d4ce2eb47a7f9f8f1fe477ec4b405bddd"]) {
            return 1090512;
        } else if ([blockHashString isEqualToString:@"000000000000001be0bbdb6b326c98ac8a3e181a2a641379c7d4308242bee90b"]) {
            return 1092216;
        } else if ([blockHashString isEqualToString:@"000000000000001c09a68353536ccb24b51b74c642d5b6e7e385cff2debc4e64"]) {
            return 1092120;
        } else if ([blockHashString isEqualToString:@"0000000000000013974ed8e13d0a50f298be0f2b685bfcfd8896172db6d4a145"]) {
            return 1090824;
        } else if ([blockHashString isEqualToString:@"000000000000001dbcd3a23c131fedde3acd6da89275e7f9fcae03f3107da861"]) {
            return 1092888;
        } else if ([blockHashString isEqualToString:@"000000000000000a8812d75979aac7c08ac69179037409fd7a368372edd05d23"]) {
            return 1090872;
        } else if ([blockHashString isEqualToString:@"000000000000001fafca43cabdb0c6385daffa8a039f3b44b9b17271d7106704"]) {
            return 1090800;
        } else if ([blockHashString isEqualToString:@"0000000000000006e9693e34fc55452c82328f31e069df740655b55dd07cb58b"]) {
            return 1091016;
        } else if ([blockHashString isEqualToString:@"0000000000000010e7c080046121900cee1c7de7fe063c7d81405293a9764733"]) {
            return 1092384;
        } else if ([blockHashString isEqualToString:@"0000000000000022ef41cb09a617d87c12c6841eea47310ae6a4d1e2702bb3d3"]) {
            return 1090752;
        } else if ([blockHashString isEqualToString:@"0000000000000017705efcdaefd6a1856becc0b915de6fdccdc9e149c1ff0e8f"]) {
            return 1091856;
        } else if ([blockHashString isEqualToString:@"0000000000000000265a9516f35dd85d32d103d4c3b95e81969a03295f46cf0c"]) {
            return 1091952;
        } else if ([blockHashString isEqualToString:@"0000000000000002dfd994409f5b6185573ce22eae90b4a1c37003428071f0a8"]) {
            return 1090968;
        } else if ([blockHashString isEqualToString:@"000000000000001b8d6aaa56571d987ee50fa2e2e9a28a8482de7a4b52308f25"]) {
            return 1091136;
        } else if ([blockHashString isEqualToString:@"0000000000000020635160b49a18336031af2d25d9a37ea211d514f196220e9d"]) {
            return 1090440;
        } else if ([blockHashString isEqualToString:@"000000000000001bfb2ac93ebe89d9831995462f965597efcc9008b2d90fd29f"]) {
            return 1091784;
        } else if ([blockHashString isEqualToString:@"000000000000000028515b4c442c74e2af945f08ed3b66f05847022cb25bb2ec"]) {
            return 1091688;
        } else if ([blockHashString isEqualToString:@"000000000000000ed6b9517da9a1df88d03a5904a780aba1200b474dab0e2e4a"]) {
            return 1090488;
        } else if ([blockHashString isEqualToString:@"000000000000000b44a550a61f9751601065ff329c54d20eb306b97d163b8f8c"]) {
            return 1091712;
        } else if ([blockHashString isEqualToString:@"000000000000001d831888fbd1899967493856c1abf7219e632b8e73f25e0c81"]) {
            return 1091064;
        } else if ([blockHashString isEqualToString:@"00000000000000073b62bf732ab8654d27b1296801ab32b7ac630237665162a5"]) {
            return 1091304;
        } else if ([blockHashString isEqualToString:@"0000000000000004c0b03207179143f028c07ede20354fab68c731cb02f95fc8"]) {
            return 1090656;
        } else if ([blockHashString isEqualToString:@"000000000000000df9d9376b9c32ea640ecfac406b41445bb3a4b0ee6625e572"]) {
            return 1091040;
        } else if ([blockHashString isEqualToString:@"00000000000000145c3e1b3bb6f53d5e2dd441ac41c3cfe48a5746c7b168a415"]) {
            return 1092240;
        } else if ([blockHashString isEqualToString:@"000000000000000d8bf4cade14e398d69884e991591cb11ee7fec49167e4ff85"]) {
            return 1092000;
        } else if ([blockHashString isEqualToString:@"000000000000001d098ef14fa032b33bcfc8e559351be8cd689e03c9678256a9"]) {
            return 1091472;
        } else if ([blockHashString isEqualToString:@"0000000000000000c25139a9227273eb7547a1f558e62c545e62aeb236e66259"]) {
            return 1090584;
        } else if ([blockHashString isEqualToString:@"0000000000000010785f105cc7c256b5365c597a9212e99beda94c6eff0647c3"]) {
            return 1091376;
        } else if ([blockHashString isEqualToString:@"0000000000000000fafe0f7314104d81ab34ebd066601a38e5e914f2b3cefce9"]) {
            return 1092552;
        } else if ([blockHashString isEqualToString:@"000000000000000ddbfad338961f2d900d62f1c3b725fbd72052da062704901c"]) {
            return 1090848;
        } else if ([blockHashString isEqualToString:@"000000000000000e5d9359857518aaf3685bf8af55c675cf0d17a45383ca297f"]) {
            return 1091520;
        } else if ([blockHashString isEqualToString:@"0000000000000012b444de0be31d695b411dcc6645a3723932cabc6b9164531f"]) {
            return 1092916;
        } else if ([blockHashString isEqualToString:@"000000000000001c414007419fc22a2401b07ab430bf433c8cdfb8877fb6b5b7"]) {
            return 1092672;
        } else if ([blockHashString isEqualToString:@"000000000000000355efb9a350cc76c7624bf42abea845770a5c3adc2c5b93f4"]) {
            return 1092576;
        } else if ([blockHashString isEqualToString:@"000000000000000f327555478a9d580318cb6e15db059642eff84797bf133196"]) {
            return 1091808;
        } else if ([blockHashString isEqualToString:@"0000000000000003b3ea97e688f1bec5f95930950b54c1bb01bf67b029739696"]) {
            return 1091640;
        } else if ([blockHashString isEqualToString:@"000000000000001a0d96dbc0cac26e445454dd2506702eeee7df6ff35bdcf60e"]) {
            return 1091544;
        } else if ([blockHashString isEqualToString:@"000000000000001aac60fafe05124672b19a1c3727dc17f106f11295db1053a3"]) {
            return 1092288;
        } else if ([blockHashString isEqualToString:@"000000000000000e37bca1e08dff47ef051199f24e9104dad85014c323464069"]) {
            return 1091208;
        } else if ([blockHashString isEqualToString:@"0000000000000013dd0059e5f701a39c0903e7f16d393f55fc896422139a4291"]) {
            return 1092768;
        } else if ([blockHashString isEqualToString:@"000000000000000f4c8d5bdf6b89435d3a9789fce401286eb8f3f6eeb84f2a1d"]) {
            return 1091160;
        } else if ([blockHashString isEqualToString:@"000000000000001414ff2dd44ee4c01c02e6867228b4e1ff490f635f7de949a5"]) {
            return 1091232;
        } else if ([blockHashString isEqualToString:@"0000000000000013b130038d0599cb5a65165fc03b1b38fe2dd1a3bad6e253df"]) {
            return 1092312;
        } else if ([blockHashString isEqualToString:@"00000000000000082cb9d6d169dc625f64a6a24756ba796eaab131a998b42910"]) {
            return 1091928;
        } else if ([blockHashString isEqualToString:@"0000000000000001e358bce8df79c24def4787bf0bf7af25c040342fae4a18ce"]) {
            return 1091880;
        } else if ([blockHashString isEqualToString:@"00000000000000084005fab00e74c09c1319eaac2fd85fe4d3b2f8119254a058"]) {
            return 1092912;
        } else if ([blockHashString isEqualToString:@"000000000000001e549677be4ad8cb89534b150678a09018da87ffda7d048d32"]) {
            return 1092940;
        }
        NSAssert(NO, @"All values must be here");
        return UINT32_MAX;
    };

    [self loadMasternodeListsForFiles:files
                             withSave:YES
                           withReload:NO
                              onChain:chain
                            inContext:context
                    blockHeightLookup:blockHeightLookup
                           completion:^(BOOL success, NSDictionary *masternodeLists) {
                               DSMasternodeList *masternodeList1092916 = [masternodeLists objectForKey:@"1f5364916bbcca323972a34566cc1d415b691de30bde44b41200000000000000".hexToData];
                               DSMasternodeList *masternodeList1092888 = [masternodeLists objectForKey:@"61a87d10f303aefcf9e77592a86dcd3adeed1f133ca2d3bc1d00000000000000".hexToData];
                               [chain.chainManager.masternodeManager reloadMasternodeListsWithBlockHeightLookup:blockHeightLookup]; // simulate that we turned off the phone
                               DSMasternodeList *reloadedMasternodeList1092916 = [chain.chainManager.masternodeManager masternodeListForBlockHash:@"0000000000000012b444de0be31d695b411dcc6645a3723932cabc6b9164531f".hexToData.reverse.UInt256];
                               DSMasternodeList *reloadedMasternodeList1092888 = [chain.chainManager.masternodeManager masternodeListForBlockHash:@"000000000000001dbcd3a23c131fedde3acd6da89275e7f9fcae03f3107da861".hexToData.reverse.UInt256];
                               NSArray *localProTxHashes1092916 = [masternodeList1092916.simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash allKeys];
                               localProTxHashes1092916 = [localProTxHashes1092916 sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
                                   UInt256 hash1 = *(UInt256 *)((NSData *)obj1).bytes;
                                   UInt256 hash2 = *(UInt256 *)((NSData *)obj2).bytes;
                                   return uint256_sup(hash1, hash2) ? NSOrderedDescending : NSOrderedAscending;
                               }];
                               NSArray *proTxHashes1092916 = [reloadedMasternodeList1092916.simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash allKeys];
                               proTxHashes1092916 = [proTxHashes1092916 sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
                                   UInt256 hash1 = *(UInt256 *)((NSData *)obj1).bytes;
                                   UInt256 hash2 = *(UInt256 *)((NSData *)obj2).bytes;
                                   return uint256_sup(hash1, hash2) ? NSOrderedDescending : NSOrderedAscending;
                               }];
                               XCTAssertEqualObjects(localProTxHashes1092916, proTxHashes1092916);
                               NSArray *localProTxHashes1092888 = [masternodeList1092888.simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash allKeys];
                               localProTxHashes1092888 = [localProTxHashes1092888 sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
                                   UInt256 hash1 = *(UInt256 *)((NSData *)obj1).bytes;
                                   UInt256 hash2 = *(UInt256 *)((NSData *)obj2).bytes;
                                   return uint256_sup(hash1, hash2) ? NSOrderedDescending : NSOrderedAscending;
                               }];
                               NSArray *proTxHashes1092888 = [reloadedMasternodeList1092888.simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash allKeys];
                               proTxHashes1092888 = [proTxHashes1092888 sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
                                   UInt256 hash1 = *(UInt256 *)((NSData *)obj1).bytes;
                                   UInt256 hash2 = *(UInt256 *)((NSData *)obj2).bytes;
                                   return uint256_sup(hash1, hash2) ? NSOrderedDescending : NSOrderedAscending;
                               }];
                               XCTAssertEqualObjects(localProTxHashes1092888, proTxHashes1092888);
                               NSMutableArray *simplifiedMasternodeListDictionaryByRegistrationTransactionHashHashes = [NSMutableArray array];
                               for (NSData *proTxHash in localProTxHashes1092888) {
                                   DSSimplifiedMasternodeEntry *simplifiedMasternodeEntry = [reloadedMasternodeList1092888.simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash objectForKey:proTxHash];
                                   [simplifiedMasternodeListDictionaryByRegistrationTransactionHashHashes addObject:[NSData dataWithUInt256:simplifiedMasternodeEntry.simplifiedMasternodeEntryHash]];
                               }
                               NSMutableArray *reloadedSimplifiedMasternodeListDictionaryByRegistrationTransactionHashHashes = [NSMutableArray array];
                               for (NSData *proTxHash in proTxHashes1092888) {
                                   DSSimplifiedMasternodeEntry *simplifiedMasternodeEntry = [reloadedMasternodeList1092888.simplifiedMasternodeListDictionaryByReversedRegistrationTransactionHash objectForKey:proTxHash];
                                   [reloadedSimplifiedMasternodeListDictionaryByRegistrationTransactionHashHashes addObject:[NSData dataWithUInt256:simplifiedMasternodeEntry.simplifiedMasternodeEntryHash]];
                               }
                               XCTAssertEqualObjects(reloadedMasternodeList1092888.providerTxOrderedHashes, masternodeList1092888.providerTxOrderedHashes);
                               XCTAssertEqualObjects([reloadedMasternodeList1092888 hashesForMerkleRootWithBlockHeightLookup:blockHeightLookup], [masternodeList1092888 hashesForMerkleRootWithBlockHeightLookup:blockHeightLookup]);
                               XCTAssertEqualObjects(simplifiedMasternodeListDictionaryByRegistrationTransactionHashHashes, reloadedSimplifiedMasternodeListDictionaryByRegistrationTransactionHashHashes);
                               XCTAssertEqualObjects(uint256_data([reloadedMasternodeList1092916 calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup]), uint256_data([masternodeList1092916 calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup]), @"");
                               XCTAssertEqualObjects(uint256_data([reloadedMasternodeList1092888 calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup]), uint256_data([masternodeList1092888 calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup]), @"");

                               NSData *message = [DSDeterministicMasternodeListTests messageFromFileWithPath:@"MNL_1092888_1092912"];
                               NSUInteger length = message.length;
                               NSUInteger offset = 0;

                               if (length - offset < 32) return;
                               UInt256 baseBlockHash = [message readUInt256AtOffset:&offset];
                               if (length - offset < 32) return;
                               __block UInt256 blockHash1092912 = [message readUInt256AtOffset:&offset];

                               NSLog(@"baseBlockHash %@ (%u) blockHash %@ (%u)", uint256_reverse_hex(baseBlockHash), blockHeightLookup(baseBlockHash), uint256_reverse_hex(blockHash1092912), blockHeightLookup(blockHash1092912));

                               DSMasternodeProcessorContext *mndiffContext = [[DSMasternodeProcessorContext alloc] init];
                               [mndiffContext setIsFromSnapshot:YES];
                               [mndiffContext setUseInsightAsBackup:NO];
                               [mndiffContext setChain:chain];
                               [mndiffContext setMasternodeListLookup:^DSMasternodeList *_Nonnull(UInt256 blockHash) {
                                   if (uint256_eq(blockHash, @"000000000000001dbcd3a23c131fedde3acd6da89275e7f9fcae03f3107da861".hexToData.reverse.UInt256)) {
                                       return reloadedMasternodeList1092888;
                                   } else if ([masternodeLists objectForKey:uint256_data(blockHash)]) {
                                       return [masternodeLists objectForKey:uint256_data(blockHash)];
                                   } else {
                                       return nil; // no known previous lists
                                   }
                               }];
                               [mndiffContext setMerkleRootLookup:merkleRootLookup];
                               [mndiffContext setBlockHeightLookup:blockHeightLookup];

                               DSMnDiffProcessingResult *result = [chain.chainManager.masternodeManager processMasternodeDiffFromFile:message protocolVersion:DEFAULT_CHECKPOINT_PROTOCOL_VERSION withContext:mndiffContext];
                               XCTAssert(result.foundCoinbase, @"Did not find coinbase at height %u", [chain heightForBlockHash:blockHash1092912]);
                               // XCTAssert(validCoinbase,@"Coinbase not valid at height %u",[chain heightForBlockHash:blockHash]); //turned off on purpose as we don't have the coinbase block
                               XCTAssert(result.rootMNListValid, @"rootMNListValid not valid at height %u", [chain heightForBlockHash:blockHash1092912]);
                               XCTAssert(result.rootQuorumListValid, @"rootQuorumListValid not valid at height %u", [chain heightForBlockHash:blockHash1092912]);
                               XCTAssert(result.validQuorums, @"validQuorums not valid at height %u", [chain heightForBlockHash:blockHash1092912]);
                               // BOOL equal = uint256_eq(masternodeListMerkleRoot.UInt256, [masternodeList masternodeMerkleRoot]);
                               // XCTAssert(equal, @"MNList merkle root should be valid");
                               DSMasternodeList *masternodeList1092912 = result.masternodeList;
                               [DSMasternodeManager saveMasternodeList:masternodeList1092912
                                                               toChain:chain
                                             havingModifiedMasternodes:result.modifiedMasternodes
                                                   createUnknownBlocks:YES
                                                             inContext:context
                                                            completion:^(NSError *_Nonnull error) {
                                                                NSData *message = [DSDeterministicMasternodeListTests messageFromFileWithPath:@"MNL_1092916_1092940"];

                                                                NSUInteger length = message.length;
                                                                NSUInteger offset = 0;

                                                                if (length - offset < 32) return;
                                                                UInt256 baseBlockHash = [message readUInt256AtOffset:&offset];
                                                                if (length - offset < 32) return;
                                                                __block UInt256 blockHash1092940 = [message readUInt256AtOffset:&offset];

                                                                NSLog(@"baseBlockHash %@ (%u) blockHash %@ (%u)", uint256_reverse_hex(baseBlockHash), [chain heightForBlockHash:baseBlockHash], uint256_reverse_hex(blockHash1092940), [chain heightForBlockHash:blockHash1092940]);
                                                                DSMasternodeProcessorContext *mndiffContext = [[DSMasternodeProcessorContext alloc] init];
                                                                [mndiffContext setIsFromSnapshot:YES];
                                                                [mndiffContext setUseInsightAsBackup:NO];
                                                                [mndiffContext setChain:chain];
                                                                [mndiffContext setMasternodeListLookup:^DSMasternodeList *_Nonnull(UInt256 blockHash) {
                                                                    if (uint256_eq(reloadedMasternodeList1092916.blockHash, blockHash)) {
                                                                        return reloadedMasternodeList1092916;
                                                                    }
                                                                    if ([masternodeLists objectForKey:uint256_data(blockHash)]) {
                                                                        return [masternodeLists objectForKey:uint256_data(blockHash)];
                                                                    }
                                                                    if (uint256_eq(masternodeList1092912.blockHash, blockHash)) {
                                                                        return masternodeList1092912;
                                                                    }
                                                                    return nil;
                                                                }];
                                                                [mndiffContext setMerkleRootLookup:merkleRootLookup];
                                                                [mndiffContext setBlockHeightLookup:blockHeightLookup];
                                                                DSMnDiffProcessingResult *result1092940 = [chain.chainManager.masternodeManager processMasternodeDiffFromFile:message protocolVersion:DEFAULT_CHECKPOINT_PROTOCOL_VERSION withContext:mndiffContext];
                                                                DSMasternodeList *masternodeList1092940 = result1092940.masternodeList;
                                                                XCTAssert(result1092940.foundCoinbase, @"Did not find coinbase at height %u", [chain heightForBlockHash:blockHash1092940]);
                                                                // XCTAssert(validCoinbase,@"Coinbase not valid at height %u",[chain heightForBlockHash:blockHash]); //turned off on purpose as we don't have the coinbase block
                                                                XCTAssert(result1092940.rootMNListValid, @"rootMNListValid not valid at height %u", [chain heightForBlockHash:blockHash1092940]);
                                                                XCTAssert(result1092940.rootQuorumListValid, @"rootQuorumListValid not valid at height %u", [chain heightForBlockHash:blockHash1092940]);
                                                                XCTAssert(result1092940.validQuorums, @"validQuorums not valid at height %u", [chain heightForBlockHash:blockHash1092940]);
                                                                DSQuorumEntry *quorum1092912 = [result1092940.addedQuorums firstObject];
                                                                // 1092912 and 1092916 are the same, 1092916 is older though and is original 1092912 is based off a reloaded 109
                                                                UInt256 llmqHash1092912 = [chain.chainManager.masternodeManager buildLLMQHashFor:quorum1092912];
                                                                NSArray *masternodeScores1092912 = [masternodeList1092912 scoresForQuorumModifier:llmqHash1092912 atBlockHeight:1092912];
                                                                NSArray *masternodeScores1092916 = [masternodeList1092916 scoresForQuorumModifier:llmqHash1092912 atBlockHeight:1092912];
                                                                //                BOOL a = [quorum1092912 validateWithMasternodeList:masternodeList1092912];
                                                                //
                                                                //                BOOL b = [quorum1092912 validateWithMasternodeList:masternodeList1092916];
                                                                //
                                                                //

                                                                //                NSArray * masternodesWithNoConfirmationHash1092912 = [[[NSSet setWithArray:masternodeList1092912.simplifiedMasternodeEntries] objectsPassingTest:^BOOL(id  _Nonnull obj, BOOL * _Nonnull stop) {
                                                                //                    return uint256_is_zero(((DSSimplifiedMasternodeEntry*)obj).confirmedHash);
                                                                //                }] allObjects];
                                                                //
                                                                //                NSArray * masternodesWithNoConfirmationHash1092916 = [[[NSSet setWithArray:masternodeList1092916.simplifiedMasternodeEntries] objectsPassingTest:^BOOL(id  _Nonnull obj, BOOL * _Nonnull stop) {
                                                                //                    return uint256_is_zero(((DSSimplifiedMasternodeEntry*)obj).confirmedHash);
                                                                //                }] allObjects];
                                                                //
                                                                //                NSArray * reloadedMasternodesWithNoConfirmationHash1092916 = [[[NSSet setWithArray:reloadedMasternodeList1092916.simplifiedMasternodeEntries] objectsPassingTest:^BOOL(id  _Nonnull obj, BOOL * _Nonnull stop) {
                                                                //                    return uint256_is_zero(((DSSimplifiedMasternodeEntry*)obj).confirmedHash);
                                                                //                }] allObjects];

                                                                // ours means reloaded

                                                                //                NSDictionary * interesting = [masternodeList1092912 compare:masternodeList1092916];

                                                                XCTAssertEqualObjects(masternodeScores1092912, masternodeScores1092916, @"These should be the same");
                                                                NSArray<DSSimplifiedMasternodeEntry *> *masternodes1092912 = [masternodeList1092912 validMasternodesForQuorumModifier:llmqHash1092912 quorumCount:[DSQuorumEntry quorumSizeForType:quorum1092912.llmqType] blockHeight:blockHeightLookup(masternodeList1092912.blockHash)];

                                                                NSArray<DSSimplifiedMasternodeEntry *> *masternodes1092916 = [masternodeList1092916 validMasternodesForQuorumModifier:llmqHash1092912 quorumCount:[DSQuorumEntry quorumSizeForType:quorum1092912.llmqType] blockHeight:blockHeightLookup(masternodeList1092916.blockHash)];
                                                                XCTAssertEqualObjects(masternodes1092912, masternodes1092916, @"These should be the same");
                                                                //                NSMutableArray * publicKeyArray = [NSMutableArray array];
                                                                //                uint32_t i = 0;
                                                                //                for (DSSimplifiedMasternodeEntry * masternodeEntry in masternodes) {
                                                                //                    if ([self.signersBitset bitIsTrueAtIndex:i]) {
                                                                //                        DSBLSKey * masternodePublicKey = [DSBLSKey blsKeyWithPublicKey:[masternodeEntry operatorPublicKeyAtBlockHash:masternodeList.blockHash] onChain:self.chain];
                                                                //                        [publicKeyArray addObject:masternodePublicKey];
                                                                //                    }
                                                                //                    i++;
                                                                //                }
                                                                //                [addedQuorums[0] val]
                                                                //

                                                                [DSMasternodeManager saveMasternodeList:masternodeList1092940
                                                                                                toChain:chain
                                                                              havingModifiedMasternodes:result1092940.modifiedMasternodes
                                                                                    createUnknownBlocks:YES
                                                                                              inContext:context
                                                                                             completion:^(NSError *_Nonnull error) {
                                                                                                 dispatch_semaphore_signal(sem);
                                                                                             }];
                                                            }];
                           }];
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
}

- (void)testTestnetQuorumVerification {
    NSData *message = [DSDeterministicMasternodeListTests messageFromFileWithPath:@"MNL_0_122928"];
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);

    DSChain *chain = [DSChain testnet];

    NSUInteger length = message.length;
    NSUInteger offset = 0;

    if (length - offset < 32) return;
    UInt256 baseBlockHash = [message readUInt256AtOffset:&offset];
    if (length - offset < 32) return;
    __block UInt256 blockHash119064 = [message readUInt256AtOffset:&offset];

    NSLog(@"baseBlockHash %@ (%u) blockHash %@ (%u)", uint256_reverse_hex(baseBlockHash), [chain heightForBlockHash:baseBlockHash], uint256_reverse_hex(blockHash119064), [chain heightForBlockHash:blockHash119064]);

    DSMasternodeProcessorContext *mndiffContext = [[DSMasternodeProcessorContext alloc] init];
    [mndiffContext setIsFromSnapshot:YES];
    [mndiffContext setUseInsightAsBackup:NO];
    [mndiffContext setChain:chain];
    [mndiffContext setMasternodeListLookup:^DSMasternodeList *_Nonnull(UInt256 blockHash) {
        return nil;
    }];
    [mndiffContext setMerkleRootLookup:^UInt256(UInt256 blockHash) {
        return UINT256_ZERO;
    }];

    NSDictionary *blockHashDict = @{
        @"00000bafbc94add76cb75e2ec92894837288a481e5c005f6563d91623bf8bc2c": @0,
        @"0000000009b4a670292967a9cd8da4ecad05586179a60e987a9b71b2c3ea1a58": @122904,
        @"00000000054437d43f5d12eaa4898d8b85e8521b1897674ee847f070045669ad": @122664,
        @"000000000525063bee5e6935224a03d160b21965bba60320802c8f3201d0ebae": @122736,
        @"000000000d201a317e82baaf536f889c83b62add5bd0375744ce1ee77e3d099f": @122760,
        @"0000000003bb193de9431c474ac0247bc20cfc2a318084329ea88fc642b554e3": @122616,
        @"000000000821a7211313a614aa3f4379af7870a38740a770d7baffd3bb6578e9": @122856,
        @"0000000008e87f07d3d1abbaa196d68cd4bf7b19ef0ddb0cbbcf1eb86f7aea46": @122880,
        @"0000000006cb4b5de2a176af028d859a1499a384f8c88f243f81f01bbc729c91": @122832,
        @"000000000a7c1dfff2586d2a635dd9b8ae491aae1b6ca72bc9070d1bd0cd50bc": @122424,
        @"000000000bca30e387a942d9dbcf6ad2273ab6061c50e5dc8282c6ff73cc3c99": @122376,
        @"0000000002ef3d706192992b6823ed1c6221a794d1225346c97c7a3d75c88b3f": @122640,
        @"000000000282ab23f92f5b517325e8da93ae470a9de3fe3aeebfcaa54cb48155": @122352,
        @"0000000003d2d2527624d1509885f0ab3d38d476d67c6fe0da7f5df8c460a675": @122520,
        @"000000000b6e93b1c97696e5de41fb3e9b94fab2df5654c1c2ddad636a6a85e3": @122472,
        @"000000000ce60869ccd9258c81307a71457581d4ce0f8e684aeda300a481d9a5": @122568,
        @"0000000001d975dfc73df9040e894576f27f6c252f1540b1c092c80353cdb823": @122928,
        @"00000000094f05e8cbf8c8fca55f688f4fbb6ec3624dbda9eab1039f005e64de": @122448,
        @"000000000108e218babaca583a3bc69f1273e6468e7eb27078da6374cdf14bb8": @122544,
        @"0000000015f89c20b07c7e6a5df001bd9838a1eee4d33a1468860daeab8d2ba3": @122808,
        @"0000000003a583ca0e218394876ddce04a94274add270c24ebd21b6570b0b202": @122712,
        @"0000000004c19db86b34bc9b5288b5af2aaff507e8474fa2db99e1ea03bacdfe": @122328,
        @"0000000002738de17d2db957ddbdd207d66c2e8977ba8d7d8da541b67d4eb0fa": @122592,
        @"0000000007697fd69a799bfa26576a177e817bc0e45b9fcfbf48b362b05aeff2": @72000,
        @"0000000006221f59fb1bc78200724447db51545cc43ffd5a78eed78106bbdb1a": @122784,
        @"0000000002ed5b13979a23330c5e219ea530ae801293df74d38c6cd6e7be78b9": @122688,
        @"0000000000bee166c1c3194f50f667900319e1fd9666aef8ec4a10accfbf3df3": @122400
    };

    [mndiffContext setBlockHeightLookup:^uint32_t(UInt256 blockHash) {
        NSString *blockHashString = uint256_reverse_hex(blockHash);
        NSNumber *blockHeight = blockHashDict[blockHashString];
        NSLog(@"blockHeightLookup: %@: %@", blockHashString, blockHeight);
        if (blockHeight) return blockHeight.unsignedIntValue;
        NSAssert(NO, @"All values must be here");
        return UINT32_MAX;
    }];
    DSMnDiffProcessingResult *result119064 = [chain.chainManager.masternodeManager processMasternodeDiffFromFile:message protocolVersion:DEFAULT_CHECKPOINT_PROTOCOL_VERSION withContext:mndiffContext];
    XCTAssert(result119064.foundCoinbase, @"Did not find coinbase at height %u", [chain heightForBlockHash:blockHash119064]);
    // turned off on purpose as we don't have the coinbase block
    // XCTAssert(validCoinbase,@"Coinbase not valid at height %u",[chain heightForBlockHash:blockHash]);
    XCTAssert(result119064.rootMNListValid, @"rootMNListValid not valid at height %u", [chain heightForBlockHash:blockHash119064]);
    XCTAssert(result119064.rootQuorumListValid, @"rootQuorumListValid not valid at height %u", [chain heightForBlockHash:blockHash119064]);
    XCTAssert(result119064.validQuorums, @"validQuorums not valid at height %u", [chain heightForBlockHash:blockHash119064]);

    if ([result119064 isValid]) {
        // yay this is the correct masternode list verified deterministically for the given block
        NSData *message = [DSDeterministicMasternodeListTests messageFromFileWithPath:@"MNL_122928_123000"];
        NSUInteger length = message.length;
        NSUInteger offset = 0;
        if (length - offset < 32) return;
        UInt256 baseBlockHash = [message readUInt256AtOffset:&offset];
        if (length - offset < 32) return;
        UInt256 blockHash = [message readUInt256AtOffset:&offset];
        NSLog(@"baseBlockHash %@ (%u) blockHash %@ (%u)", uint256_reverse_hex(baseBlockHash), [chain heightForBlockHash:baseBlockHash], uint256_reverse_hex(blockHash), [chain heightForBlockHash:blockHash]);

        XCTAssert(uint256_eq(blockHash119064, baseBlockHash), @"Base block hash should be from block 119064");
        NSDictionary *blockHashDict2 = @{
            @"000000000577855d5599ce9a89417628233a6ccf3a86b2938b191f3dfed2e63d": @123000,
            @"0000000003b852d8331f850491aeca3d91b43b3ef7af8208c82814c0e06cd75c": @122952,
            @"0000000001d975dfc73df9040e894576f27f6c252f1540b1c092c80353cdb823": @122928,
            @"0000000005938a06c7e88a5cd3a950655bde3ed7046e9ffad542ad5902395d2b": @122976
        };
        uint32_t (^blockHeightLookup2)(UInt256 blockHash) = ^uint32_t(UInt256 blockHash) {
            NSString *blockHashString = uint256_reverse_hex(blockHash);
            NSNumber *blockHeight = blockHashDict2[blockHashString];
            NSLog(@"blockHeightLookup2: %@: %@", blockHashString, blockHeight);
            if (blockHeight) return blockHeight.unsignedIntValue;
            NSAssert(NO, @"All values must be here");
            return UINT32_MAX;
        };
        DSMasternodeList *masternodeList119064 = result119064.masternodeList;
        DSMasternodeProcessorContext *mndiffContext = [[DSMasternodeProcessorContext alloc] init];
        [mndiffContext setIsFromSnapshot:YES];
        [mndiffContext setUseInsightAsBackup:NO];
        [mndiffContext setChain:chain];
        [mndiffContext setMasternodeListLookup:^DSMasternodeList *_Nonnull(UInt256 blockHash) {
            if (uint256_eq(blockHash, masternodeList119064.blockHash)) {
                return masternodeList119064;
            }
            return nil;
        }];
        [mndiffContext setMerkleRootLookup:^UInt256(UInt256 blockHash) {
            return UINT256_ZERO;
        }];
        [mndiffContext setBlockHeightLookup:blockHeightLookup2];
        DSMnDiffProcessingResult *result119200 = [chain.chainManager.masternodeManager processMasternodeDiffFromFile:message protocolVersion:DEFAULT_CHECKPOINT_PROTOCOL_VERSION withContext:mndiffContext];
        XCTAssert(result119200.foundCoinbase, @"Did not find coinbase at height %u", [chain heightForBlockHash:blockHash]);
        // XCTAssert(validCoinbase,@"Coinbase not valid at height %u",[chain heightForBlockHash:blockHash]); //turned off on purpose as we don't have the coinbase block
        XCTAssert(result119200.rootMNListValid, @"rootMNListValid not valid at height %u", [chain heightForBlockHash:blockHash]);
        XCTAssert(result119200.rootQuorumListValid, @"rootQuorumListValid not valid at height %u", [chain heightForBlockHash:blockHash]);
        XCTAssert(result119200.validQuorums, @"validQuorums not valid at height %u", [chain heightForBlockHash:blockHash]);

        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(DSQuorumEntry *entry, NSDictionary *bindings) {
            return uint256_eq(entry.quorumHash, blockHash119064) && entry.llmqType == LLMQType_Llmqtype50_60;
        }];

        DSQuorumEntry *quorumToVerify = [[result119200.addedQuorums filteredArrayUsingPredicate:predicate] firstObject];
        XCTAssert(quorumToVerify, @"There should be a quorum using 119064");
        [quorumToVerify validateWithMasternodeList:masternodeList119064];
        XCTAssert(quorumToVerify.verified, @"Unable to verify quorum");

        /*
        NSArray<DSSimplifiedMasternodeEntry *> *masternodes = [blockHash119200 validMasternodesForQuorumModifier:quorumToVerify.llmqQuorumHash quorumCount:[DSQuorumEntry quorumSizeForType:quorumToVerify.llmqType] blockHeightLookup:blockHeightLookup2];
        NSMutableArray *masternodeHashOrder = [NSMutableArray array];
        for (DSSimplifiedMasternodeEntry *masternode in masternodes) {
            [masternodeHashOrder addObject:uint256_reverse_hex([masternode providerRegistrationTransactionHash])];
        }
        NSArray *properOrder = @[
        @"c24aea30305d539887223fd923df775644b1d86db0aac8c654026e823b549cd7",
        @"869f7f2054a6ed4241967afb74c3b1a07701d2772b368eb0bbfd2e3365adf6f3",
        @"db85af3dad4d35c89f9c2ae0f932c70216b588611f3d250f71145a64cd0cc814",
        @"11eabc1e72394af02bbe86815975d054816fe69006fdc64c6d7a06b585e5c311",
        @"62e9acb81381fd2b2d41ed742af24f39e1dd23237b119e88f37de32bdde477eb",
        @"f5a48b2747f5a7b91b00d00ca510c5f82f1670416ddb17f635634c9d78ecfb56",
        @"f1eb4ac02ab1acbace0a01328e204c4fd7dec5e53a72cccac7729c5802dbeaf4",
        @"72a6a2a5c2fb260fe3d41913ae019feb1d2489867e85f57cd1fa994bbe3458f1",
        @"fbb1a1aa283faeb8082a7331c5010f13272f7ce6cb24845b3d1f260f7cb75423",
        @"8aa3403855cb28266f9ac3a6a86a38598fe73194501b873254377f67fd2bd9d0",
        @"f5ff9fbf1daf5db3539c7e307d9d50b12bb58a491b2f684c123256fd8193aa22",
        @"f773def21e01af33f508b4e978631b99405fd1ad3947984d3bbca5b41b221175",
        @"7d2cf73f05abc970b959e7de9beafeeb953a892f65253c4f17240af69562c157",
        @"7504ff244e65de04c91640380c0c996f1f5b09073a8eb387ceba1a3c1ba18ff7",
        @"82188f383d81425a75be96d075a36a4d553c275b57ebbb6e5d25da1ef03a2a73",
        @"5aa7b0778c53e048abacecf9e63558fea80ea270ffb13ed12cb71f9b5ea08739",
        @"035c55ab6fdd3e67b4aabb21d2baaa4507f5bb3c0954aed2353cabf9ec67e0d9",
        @"7d336336b7e8910f518b2b270c6d72a2d7fc05aec3c6720108da80805ffc3aab",
        @"bac5f35e6bd0bec2b4135ac2056c09714d8e6deb7c837d4f82229ed05ed539d7",
        @"0fb12eef8c8736fc3e537a531facc6a6b445ea4394a008314d06684f4d43de1b",
        @"db7fde05ba97f0e66eb623f6bfeb8f5c59eb3ebe37949033916796c274521d92",
        @"5ab82a5348b5d4c126b0c172665d364352be37c96ce442e710d4a844a6f80bf9",
        @"dfab7fd7e6f141d1ad7ff9fcaf8dafaf85b05dafc9058b376a33c6f4ee1da607",
        @"a79311b6e5dcc1c1e4ac21a7252a7a830df0d784f737abf2bac5e6f2853f4d66",
        @"9d3664f872028a8ac0fe867129f4027e96ee9747a4690a29cae3d6e84311b47d",
        @"cc36055f36345b85a2b8176e79feff0ff822c490691c7f8e8d3348b4b1a1d8ac",
        @"9212f5312730c7881b882b9fb7864dc686fa5a585b7a93253ccf1ce87ee59331",
        @"32e5ad5cf9a06eb13e0f65cb7ecde1a93ef24995d07355fac2ff05ebd5b9ddbf",
        @"8d0fdff45a02323afdbb8807c85b8542314b451611f71fe857d258db50d90fd6",
        @"3005473d3e4b73c7b08e46eaeb59a4aed97b516512d9a4d9bece3d0f8a0a6a1e",
        @"16dd484054212621d9ed312bfa4eb4958a14f4d9596143459304644034f73994",
        @"a0d428edcf2ad412c198e8e914c64911b6a144d665ef6e1df6c9c96819695a5e",
        @"c824bf8b44eeb1fa9c652e2c17b6eb11e91d9dc6567851e0a9c0b4720e75a70d",
        @"725eb7b78e1c2823e8cdf3360ef0afff554866d0264984f82bfd9a440deaea9b",
        @"a2d79b17e6c132dbe348995d6c0f5f36f90bace835748e77778a8ab8f25ba792",
        @"4e60af72569f2922b1bd0dc630e38b3d0be8ec0960467a0aab45abe52696cbf3",
        @"869b6700423da629920dc2101ec88e894f450f66aa751879dce0468945e04179",
        @"87d515401a0fbc402a747e63e7d44c54d68b049cddd58a4a49f12948601b0b70",
        @"fbfd403a9a4f7009be080a818b9804bc7627ad4621bd27322d7e31b1fd698639",
        @"ca6ffccd65d35bc6d31fd5ad79815c3d840ce65351a094484bcdc3f0d4ea3c63",
        @"eacf149c93ee560f91f83c99d0167f586aefd4534432f1593fc9eee39e7c0640",
        @"6c91363d97b286e921afb5cf7672c88a2f1614d36d32058c34bef8b44e026007",
        @"0569ce8b1a5fddf85850b5415b0435c46e198a8f146b1344bd618c8fc6e9e541",
        @"24b8107bc9c59dc4327824a1071d643fda4976131ba64dd4802b5dd3eb79ce6f",
        @"8393d3bd5423068c026bb7c118cfae9f61b94c495bf7898cb63b777b61d5cd1d",
        @"6234c6ef0f64f704045623c2802c6a8871c2a2e168d80190ff8e039ddd8dcef5",
        @"384ef1d5cdbc668f4cd51d0859e801e5ade7d6011cc000d8788c79c5015dc433",
        @"5f7825bb16aa754c5b4fbbe4be4a2e9f1ecc071e4abfbafe710baa2ca21156c1",
        @"78c43475cc270d075a38bf9959c590492dc8682a6feb46157444d29de4a13b8b",
        @"16e4599e188b5551cd6a25e77a64e477f27b8012e07658dee354a8c4f13ed4a8"
        ];
        XCTAssertEqualObjects(masternodeHashOrder, properOrder);*/
        dispatch_semaphore_signal(sem);
    }
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
}

- (void)testTestnetSizeQuorumVerification {
    NSData *message = [DSDeterministicMasternodeListTests messageFromFileWithPath:@"MNL_0_370368"];
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    DSChain *chain = [DSChain testnet];

    NSUInteger length = message.length;
    NSUInteger offset = 0;

    if (length - offset < 32) return;
    UInt256 baseBlockHash = [message readUInt256AtOffset:&offset];
    if (length - offset < 32) return;
    __block UInt256 blockHash370368 = [message readUInt256AtOffset:&offset];

    NSLog(@"baseBlockHash %@ (%u) blockHash %@ (%u)", uint256_reverse_hex(baseBlockHash), [chain heightForBlockHash:baseBlockHash], uint256_reverse_hex(blockHash370368), [chain heightForBlockHash:blockHash370368]);

    XCTAssert(uint256_eq(chain.genesisHash, baseBlockHash) || uint256_is_zero(baseBlockHash), @"Base block hash should be from chain origin");

    DSMasternodeProcessorContext *mndiffContext = [[DSMasternodeProcessorContext alloc] init];
    [mndiffContext setIsFromSnapshot:YES];
    [mndiffContext setUseInsightAsBackup:NO];
    [mndiffContext setChain:chain];
    [mndiffContext setMasternodeListLookup:^DSMasternodeList *_Nonnull(UInt256 blockHash) {
        return nil;
    }];
    [mndiffContext setMerkleRootLookup:^UInt256(UInt256 blockHash) {
        return UINT256_ZERO;
    }];
    [mndiffContext setBlockHeightLookup:^uint32_t(UInt256 blockHash) {
        return 370368;
    }];
    DSMnDiffProcessingResult *result370368 = [chain.chainManager.masternodeManager processMasternodeDiffFromFile:message protocolVersion:DEFAULT_CHECKPOINT_PROTOCOL_VERSION withContext:mndiffContext];
    XCTAssert(result370368.foundCoinbase, @"Did not find coinbase at height %u", [chain heightForBlockHash:blockHash370368]);
    // XCTAssert(validCoinbase,@"Coinbase not valid at height %u",[chain heightForBlockHash:blockHash]); //turned off on purpose as we don't have the coinbase block
    XCTAssert(result370368.rootMNListValid, @"rootMNListValid not valid at height %u", [chain heightForBlockHash:blockHash370368]);
    XCTAssert(result370368.rootQuorumListValid, @"rootQuorumListValid not valid at height %u", [chain heightForBlockHash:blockHash370368]);
    XCTAssert(result370368.validQuorums, @"validQuorums not valid at height %u", [chain heightForBlockHash:blockHash370368]);
    DSMasternodeList *masternodeList370368 = result370368.masternodeList;
    XCTAssert(masternodeList370368.validMasternodeCount == 302);
    NSArray<DSSimplifiedMasternodeEntry *> *masternodes = [masternodeList370368 validMasternodesForQuorumModifier:@"e3628a32060457a1b9d08d23cb10e7b73ff593ecbcdf0d5588af2177271ff961".hexToData.UInt256
                                                                                                      quorumCount:400
                                                                                                      blockHeight:370368];

    XCTAssertEqual(masternodes.count, 302, @"All masternodes should be used");
    if ([result370368 isValid]) {
        // yay this is the correct masternode list verified deterministically for the given block
        NSData *message = [DSDeterministicMasternodeListTests messageFromFileWithPath:@"MNL_370368_370944"];

        NSUInteger length = message.length;
        NSUInteger offset = 0;

        if (length - offset < 32) return;
        UInt256 baseBlockHash = [message readUInt256AtOffset:&offset];
        if (length - offset < 32) return;
        UInt256 blockHash = [message readUInt256AtOffset:&offset];

        NSLog(@"baseBlockHash %@ (%u) blockHash %@ (%u)", uint256_reverse_hex(baseBlockHash), [chain heightForBlockHash:baseBlockHash], uint256_reverse_hex(blockHash), [chain heightForBlockHash:blockHash]);

        XCTAssert(uint256_eq(blockHash370368, baseBlockHash), @"Base block hash should be from block 119064");

        DSMasternodeProcessorContext *mndiffContext = [[DSMasternodeProcessorContext alloc] init];
        [mndiffContext setIsFromSnapshot:YES];
        [mndiffContext setUseInsightAsBackup:NO];
        [mndiffContext setChain:chain];
        [mndiffContext setMasternodeListLookup:^DSMasternodeList *_Nonnull(UInt256 blockHash) {
            if (uint256_eq(blockHash, masternodeList370368.blockHash)) {
                return masternodeList370368;
            }
            return nil;
        }];
        [mndiffContext setMerkleRootLookup:^UInt256(UInt256 blockHash) {
            return UINT256_ZERO;
        }];

        [mndiffContext setBlockHeightLookup:^uint32_t(UInt256 blockHash) {
            return 370944;
        }];
        DSMnDiffProcessingResult *result370944 = [chain.chainManager.masternodeManager processMasternodeDiffFromFile:message protocolVersion:DEFAULT_CHECKPOINT_PROTOCOL_VERSION withContext:mndiffContext];
        XCTAssert(result370944.foundCoinbase, @"Did not find coinbase at height %u", [chain heightForBlockHash:blockHash]);
        // XCTAssert(result370944.validCoinbase,@"Coinbase not valid at height %u",[chain heightForBlockHash:blockHash]); //turned off on purpose as we don't have the coinbase block
        XCTAssert(result370944.rootMNListValid, @"rootMNListValid not valid at height %u", [chain heightForBlockHash:blockHash]);
        XCTAssert(result370944.rootQuorumListValid, @"rootQuorumListValid not valid at height %u", [chain heightForBlockHash:blockHash]);
        XCTAssert(result370944.validQuorums, @"validQuorums not valid at height %u", [chain heightForBlockHash:blockHash]);

        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(DSQuorumEntry *entry, NSDictionary *bindings) {
            return uint256_eq(entry.quorumHash, blockHash370368) && entry.llmqType == LLMQType_Llmqtype50_60;
        }];
        DSQuorumEntry *quorumToVerify = [[result370944.addedQuorums filteredArrayUsingPredicate:predicate] firstObject];

        XCTAssert(quorumToVerify, @"There should be a quorum using 119064");
        DSMasternodeList *masternodeList370944 = result370944.masternodeList;
        NSArray<DSSimplifiedMasternodeEntry *> *masternodes = [masternodeList370944 validMasternodesForQuorumModifier:[chain.chainManager.masternodeManager buildLLMQHashFor:quorumToVerify] quorumCount:[DSQuorumEntry quorumSizeForType:quorumToVerify.llmqType] blockHeight:370944];

        NSArray *masternodeHashOrder = [masternodes map:^(DSSimplifiedMasternodeEntry *masternode) {
            return uint256_reverse_hex([masternode providerRegistrationTransactionHash]);
        }];

        NSArray<DSSimplifiedMasternodeEntry *> *masternodes2 = [masternodeList370944 validMasternodesForQuorumModifier:@"e3628a32060457a1b9d08d23cb10e7b73ff593ecbcdf0d5588af2177271ff961".hexToData.UInt256
                                                                                                           quorumCount:400
                                                                                                     blockHeight:370944];

        XCTAssertEqual(masternodes2.count, 301, @"All masternodes should be used");

        dispatch_semaphore_signal(sem);
    }

    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
}

- (void)validateBitsets:(NSData *)bitset count:(int32_t)count {
    // The byte size of the signers and validMembers bitvectors must match “(quorumSize + 7) / 8”
    NSLog(@"validateBitsets: %@:%lu:%d:%d", bitset.hexString, [bitset length], count, count / 8);
    if (bitset.length != (count + 7) / 8) {
        NSAssert(NO, @"Error: The byte size of the signers bitvectors (%lu) must match “(quorumSize + 7) / 8 (%d)", bitset.length, (count + 7) / 8);
    }
    // No out-of-range bits should be set in byte representation of the signers and validMembers bitvectors
    uint32_t signersOffset = count / 8;
    uint8_t signersLastByte = [bitset UInt8AtOffset:signersOffset];
    uint8_t signersMask = UINT8_MAX >> (8 - signersOffset) << (8 - signersOffset);
    NSLog(@"lastByte: %d mask: %d", signersLastByte, signersMask);
    if (signersLastByte & signersMask) {
        NSAssert(NO, @"Error: No out-of-range bits should be set in byte representation of the signers bitvector");
    }
}

- (void)testBitsets {
    NSData *bitset1 = [NSData dataFromHexString:@"ffffffffffff03"];
    int32_t count1 = 50;
    NSData *bitset2 = [NSData dataFromHexString:@"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff3f000000000000000000000000"];
    int32_t count2 = 400;
    [self validateBitsets:bitset1 count:count1];
    [self validateBitsets:bitset2 count:count2];
}

- (void)testCheckpoints {
    DSChainManager *chainManager = [[DSChainsManager sharedInstance] testnetManager];
    DSChain *chain = chainManager.chain;
    NSData *message = [DSDeterministicMasternodeListTests messageFromFileWithPath:@"MNL_0_122064"];

    __block NSManagedObjectContext *context = [NSManagedObjectContext chainContext];
    [context performBlockAndWait:^{
        DSChainEntity *chainEntity = [chain chainEntityInContext:context];
        [DSSimplifiedMasternodeEntryEntity deleteAllOnChainEntity:chainEntity];
        [DSQuorumEntryEntity deleteAllOnChainEntity:chainEntity];
        [DSMasternodeListEntity deleteAllOnChainEntity:chainEntity];
        [DSQuorumSnapshotEntity deleteAllOnChainEntity:chainEntity];
    }];

    NSUInteger length = message.length;
    NSUInteger offset = 0;
    if (length - offset < 32) return;
    UInt256 baseBlockHash = [message readUInt256AtOffset:&offset];
    if (length - offset < 32) return;
    __block UInt256 blockHash122064 = [message readUInt256AtOffset:&offset];
    NSLog(@"baseBlockHash %@ (%u) blockHash %@ (%u)", uint256_reverse_hex(baseBlockHash), [chain heightForBlockHash:baseBlockHash], uint256_reverse_hex(blockHash122064), [chain heightForBlockHash:blockHash122064]);

    XCTAssert(uint256_eq(chain.genesisHash, baseBlockHash) || uint256_is_zero(baseBlockHash), @"Base block hash should be from chain origin");

    uint32_t (^blockHeightLookup122064)(UInt256 blockHash) = ^uint32_t(UInt256 blockHash) {
        NSLog(@"blockHeightLookup122064: %@: %@", uint256_hex(blockHash), uint256_reverse_hex(blockHash));
        if uint256_eq(chain.genesisHash, blockHash) {
            return 0;
        } else {
            return 122064;
        }
    };

    DSMasternodeProcessorContext *mndiffContext = [[DSMasternodeProcessorContext alloc] init];
    [mndiffContext setIsFromSnapshot:YES];
    [mndiffContext setUseInsightAsBackup:NO];
    [mndiffContext setChain:chain];
    [mndiffContext setMasternodeListLookup:^DSMasternodeList *_Nonnull(UInt256 blockHash) {
        return nil;
    }];
    [mndiffContext setMerkleRootLookup:^UInt256(UInt256 blockHash) {
        return @"ac841d3551d012e8ce5fbec60217043209317b50268d1c3717d79350d23fd593".hexToData.reverse.UInt256;
    }];
    [mndiffContext setBlockHeightLookup:blockHeightLookup122064];
    DSMnDiffProcessingResult *result = [chainManager.masternodeManager processMasternodeDiffFromFile:message protocolVersion:DEFAULT_CHECKPOINT_PROTOCOL_VERSION withContext:mndiffContext];
    DSMasternodeList *masternodeList122064 = result.masternodeList;
    XCTAssert(result.foundCoinbase, @"Did not find coinbase at height %u", [chain heightForBlockHash:blockHash122064]);
    // turned off on purpose as we don't have the coinbase block
//     XCTAssert(validCoinbase,@"Coinbase not valid at height %u",[chain heightForBlockHash:blockHash]);
    XCTAssert(result.rootMNListValid, @"rootMNListValid not valid at height %u", [chain heightForBlockHash:blockHash122064]);
    XCTAssert(result.rootQuorumListValid, @"rootQuorumListValid not valid at height %u", [chain heightForBlockHash:blockHash122064]);
    XCTAssert(result.validQuorums, @"validQuorums not valid at height %u", [chain heightForBlockHash:blockHash122064]);
    XCTAssertEqualObjects(uint256_data([masternodeList122064 calculateMasternodeMerkleRootWithBlockHeightLookup:blockHeightLookup122064]).hexString, @"86cfe9b759dfd012f8d00e980c560c5c1d9c487bfa8b59305e14c7fc60ef1150", @"");
}

- (uint32_t)extractProtocolVersion:(NSString *)masternodeListName {
    uint32_t protocolVersion = DEFAULT_CHECKPOINT_PROTOCOL_VERSION;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"__(\\d+)"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    NSTextCheckingResult *match = [regex
                                   firstMatchInString:masternodeListName
                                   options:0
                                   range:NSMakeRange(0, [masternodeListName length])];
    if (match) {
        NSString *numberString = [masternodeListName substringWithRange:[match rangeAtIndex:1]];
        if (numberString) {
            protocolVersion = (uint32_t)[numberString integerValue];
        }
    }
    return protocolVersion;
}

- (void)testCheckpointsName {
    XCTAssertEqual([self extractProtocolVersion:@"ML1088640__70218"], 70218);
    XCTAssertEqual([self extractProtocolVersion:@"ML1088640__70218"], DEFAULT_CHECKPOINT_PROTOCOL_VERSION);
    XCTAssertEqual([self extractProtocolVersion:@"ML1720000__70218"], 70218);
    XCTAssertEqual([self extractProtocolVersion:@"MNT530000__70228"], 70228);
    XCTAssertEqual([self extractProtocolVersion:@"MNL_1092916_1092940"], 70218);
    XCTAssertEqual([self extractProtocolVersion:@"MNL_0_122928"], 70218);
    XCTAssertEqual([self extractProtocolVersion:@"MNL_0_122928"], DEFAULT_CHECKPOINT_PROTOCOL_VERSION);
    XCTAssertEqual([self extractProtocolVersion:@"QRINFO_122222_122223__70227"], 70227);
    
}
@end
