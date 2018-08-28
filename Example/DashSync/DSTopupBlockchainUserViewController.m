//
//  DSTopupBlockchainUserViewController.m
//  DashSync_Example
//
//  Created by Sam Westrich on 7/27/18.
//  Copyright © 2018 Dash Core Group. All rights reserved.
//

#import "DSTopupBlockchainUserViewController.h"
#import "DSWalletChooserViewController.h"
#import "DSAccountChooserViewController.h"
#import "DSBlockchainUserRegistrationTransaction.h"
#import <DashSync/DashSync.h>

@interface DSTopupBlockchainUserViewController ()

- (IBAction)done:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UITextField *topupAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *walletIdentifierLabel;
@property (strong, nonatomic) IBOutlet UILabel *fundingAccountIdentifierLabel;
@property (strong, nonatomic) DSWallet * wallet;
@property (strong, nonatomic) DSAccount * fundingAccount;

@end

@implementation DSTopupBlockchainUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setToDefaultAccount];
    if (self.fundingAccount) {
        self.wallet = self.fundingAccount.wallet;
        self.usernameLabel.text = self.blockchainUser.username;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setToDefaultAccount {
    self.fundingAccount = nil;
    for (DSWallet * wallet in self.chainPeerManager.chain.wallets) {
        for (DSAccount * account in wallet.accounts) {
            if (account.balance > 0) {
                self.fundingAccount = account;
                break;
            }
        }
        if (self.fundingAccount) break;
    }
}

-(void)setWallet:(DSWallet *)wallet {
    _wallet = wallet;
    self.walletIdentifierLabel.text = wallet.uniqueID;
}

-(void)setFundingAccount:(DSAccount *)fundingAccount {
    _fundingAccount = fundingAccount;
    self.fundingAccountIdentifierLabel.text = [NSString stringWithFormat:@"%@-%u",fundingAccount.wallet.uniqueID,fundingAccount.accountNumber];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)raiseIssue:(NSString*)issue message:(NSString*)message {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:issue message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:TRUE completion:^{
        
    }];
}

- (IBAction)done:(id)sender {
    NSScanner *scanner = [NSScanner scannerWithString:self.topupAmountLabel.text];
    uint64_t topupAmount = 0;
    [scanner scanUnsignedLongLong:&topupAmount];
    if (!_wallet) {
        [self raiseIssue:@"No wallet with balance" message:@"To topup a blockchain user you must have a wallet with enough balance to pay a credit fee"];
        return;
    } else if (!_fundingAccount) {
        [self raiseIssue:@"No funding account with balance" message:@"To topup a blockchain user you must have a wallet with enough balance to pay a credit fee"];
        return;
    }
    
    [self.blockchainUser topupTransactionForTopupAmount:topupAmount fundedByAccount:self.fundingAccount completion:^(DSBlockchainUserTopupTransaction *blockchainUserTopupTransaction) {
        if (blockchainUserTopupTransaction) {
            [self.fundingAccount signTransaction:blockchainUserTopupTransaction withPrompt:@"Fund Transaction" completion:^(BOOL signedTransaction) {
                if (signedTransaction) {
                    [self.chainPeerManager publishTransaction:blockchainUserTopupTransaction completion:^(NSError * _Nullable error) {
                        if (error) {
                            [self raiseIssue:@"Error" message:error.localizedDescription];
                            
                        } else {
                            [self.navigationController popViewControllerAnimated:TRUE];
                        }
                    }];
                } else {
                    [self raiseIssue:@"Error" message:@"Transaction was not signed."];
                    
                }
            }];
        } else {
            [self raiseIssue:@"Error" message:@"Unable to create BlockchainUserTopupTransaction."];
            
        }
    }];
}

-(void)viewController:(UIViewController*)controller didChooseWallet:(DSWallet*)wallet {
    self.wallet = wallet;
}

-(void)viewController:(UIViewController*)controller didChooseAccount:(DSAccount *)account {
    self.fundingAccount = account;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BlockchainUserTopupChooseWalletSegue"]) {
        DSWalletChooserViewController * chooseWalletSegue = (DSWalletChooserViewController*)segue.destinationViewController;
        chooseWalletSegue.chain = self.chainPeerManager.chain;
        chooseWalletSegue.delegate = self;
    } else if ([segue.identifier isEqualToString:@"BlockchainUserTopupChooseFundingAccountSegue"]) {
        DSAccountChooserViewController * chooseAccountSegue = (DSAccountChooserViewController*)segue.destinationViewController;
        chooseAccountSegue.chain = self.chainPeerManager.chain;
        chooseAccountSegue.delegate = self;
    }
}




@end
