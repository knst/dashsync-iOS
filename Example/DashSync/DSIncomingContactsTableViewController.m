//
//  DSIncomingContactsTableViewController.m
//  DashSync_Example
//
//  Created by Andrew Podkovyrin on 15/03/2019.
//  Copyright © 2019 Dash Core Group. All rights reserved.
//

#import "DSIncomingContactsTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const CellId = @"CellId";

@interface DSIncomingContactsTableViewController ()

@end

@implementation DSIncomingContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Requests";
}

- (IBAction)refreshAction:(id)sender {
    [self.refreshControl beginRefreshing];
    __weak typeof(self) weakSelf = self;
    [self.blockchainUser fetchContacts:^(BOOL success) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        [strongSelf.refreshControl endRefreshing];
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.blockchainUser.ownContact.incomingFriendRequests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    
    NSString *username = self.blockchainUser.ownContact.incomingFriendRequests[indexPath.row].username;
    cell.textLabel.text = username;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *username = self.blockchainUser.ownContact.incomingFriendRequests[indexPath.row].username;
    __weak typeof(self) weakSelf = self;
    [self.blockchainUser sendNewContactRequestToUserWithUsername:username completion:^(BOOL success) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        if (success) {
            [strongSelf.tableView reloadData];
        }
        
        [strongSelf showAlertTitle:@"Confirming contact request:" result:success];
    }];
}

#pragma mark - Private

- (void)showAlertTitle:(NSString *)title result:(BOOL)result {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:result ? @"✅ success" : @"❌ failure" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

NS_ASSUME_NONNULL_END
