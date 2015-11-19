//
//  CategorySearchResultsViewController.m
//  FindUTC
//
//  Created by Sylvain Marchienne on 08/05/2015.
//  Copyright (c) 2015 FindUTC. All rights reserved.
//

#import "CategorySearchResultsViewController.h"

@interface CategorySearchResultsViewController ()

@end

@implementation CategorySearchResultsViewController

@synthesize searchResults;
@synthesize array;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    //  Custom Cell depuis un nib
    //
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreCell" bundle:nil] forCellReuseIdentifier:@"StoreCell"];

    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = @"StoreCell";
    StoreCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[StoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Store *aStore = [searchResults objectAtIndex:indexPath.row];
    
    cell.name.text = aStore.name;
    
    if(![aStore.nbOpinions isEqualToString:@"0"])
        cell.nbOpinions.text = [NSString stringWithFormat:@"%@ (%@ avis)", aStore.rate, aStore.nbOpinions];
    else
        cell.nbOpinions.text = @"Pas encore d'avis";
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainStoreViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"MainStoreViewController"];
    
    vc.store = [searchResults objectAtIndex:indexPath.row];
    
    self.presentingViewController.navigationItem.title = @"Rechercher";
    [self.presentingViewController.navigationController pushViewController:vc animated:YES];
}

@end
