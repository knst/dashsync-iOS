//  
//  Created by Sam Westrich
//  Copyright © 2021 Dash Core Group. All rights reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://opensource.org/licenses/MIT
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "DSDAPICoreNetworkService.h"
#import "DSHTTPJSONRPCClient.h"
#import "DSChain.h"
#import "DSPeer.h"
#import "DSDAPIGRPCResponseHandler.h"
#import "DSDashPlatform.h"
#import "NSData+Bitcoin.h"
#import "DPErrors.h"

@interface DSDAPICoreNetworkService ()

@property (strong, nonatomic) DSHTTPJSONRPCClient *httpJSONRPCClient;
@property (strong, nonatomic) Core *gRPCClient;
@property (strong, nonatomic) DSChain * chain;
@property (strong, nonatomic) NSString * ipAddress;
@property (strong, atomic) dispatch_queue_t grpcDispatchQueue;

@end

@implementation DSDAPICoreNetworkService

- (instancetype)initWithDAPINodeIPAddress:(NSString*)ipAddress httpLoaderFactory:(HTTPLoaderFactory *)httpLoaderFactory usingGRPCDispatchQueue:(dispatch_queue_t)grpcDispatchQueue onChain:(DSChain*)chain {
    NSParameterAssert(ipAddress);
    NSParameterAssert(httpLoaderFactory);

    self = [super init];
    if (self) {
        self.ipAddress = ipAddress;
        NSURL *dapiNodeURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%d",ipAddress,chain.standardDapiJRPCPort]];
        _httpJSONRPCClient = [DSHTTPJSONRPCClient clientWithEndpointURL:dapiNodeURL httpLoaderFactory:httpLoaderFactory];
        self.chain = chain;
        GRPCMutableCallOptions *options = [[GRPCMutableCallOptions alloc] init];
        // this example does not use TLS (secure channel); use insecure channel instead
        options.transportType = GRPCTransportTypeInsecure;
        options.userAgentPrefix = USER_AGENT;
        options.timeout = 30;
        self.grpcDispatchQueue = grpcDispatchQueue;
        
        NSString *dapiGRPCHost = [NSString stringWithFormat:@"%@:%d",ipAddress,3010];
        
        _gRPCClient = [Core serviceWithHost:dapiGRPCHost callOptions:options];
    }
    return self;
}

- (id<DSDAPINetworkServiceRequest>)getStatusWithSuccess:(void (^)(NSDictionary * status))success
                                                failure:(void (^)(NSError *error))failure {
    GetStatusRequest * statusRequest = [[GetStatusRequest alloc] init];
    DSDAPIGRPCResponseHandler * responseHandler = [[DSDAPIGRPCResponseHandler alloc] init];
    responseHandler.dispatchQueue = self.grpcDispatchQueue;
    responseHandler.successHandler = success;
    responseHandler.errorHandler = failure;
    GRPCUnaryProtoCall * call = [self.gRPCClient getStatusWithMessage:statusRequest responseHandler:responseHandler callOptions:nil];
    [call start];
    return (id<DSDAPINetworkServiceRequest>)call;
}


@end
