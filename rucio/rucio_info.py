"""
Rucio Data Information Collector

This script collects information about replication rules and related data for given datasets from the Rucio system.
It generates a JSON file containing the collected information.

"""

from rucio.client.replicaclient import ReplicaClient
from rucio.client.ruleclient import RuleClient
from rucio.client.client import Client
from rucio.client.didclient import DIDClient
from rucio.common.exception import DataIdentifierNotFound
import json
import datetime
import argparse

did_client = DIDClient()
rule_client = RuleClient()
client = Client(account="dunepro")


def get_info(scope, name):
    """ 
    Get replication rule information for specified datasets.
    Args:
        scope (str): The Rucio scope.
        datasets (list): List of dataset names.
    Returns:
        list: List of dictionaries containing replication rule information for each dataset.
    """
    info = []
    for mdata in rule_client.list_replication_rules({'scope': scope}):
        if not scope  in mdata['scope'] or not mdata['name'] in name:
            continue
        if mdata['state'] != 'OK':
            continue
        # this query is slow ...
        total_size = sum(file_info['bytes'] for file_info in did_client.list_files(scope, mdata['name'])) 
        _info = { 
            "dataset": name,
            "catalog": "rucio",
            "did": mdata["id"],
            "did_type": mdata["did_type"],
            "site": mdata["rse_expression"],
            "created_at": mdata["created_at"].strftime("%Y-%m-%d %H:%M:%S"),
            "updated_at": mdata["updated_at"].strftime("%Y-%m-%d %H:%M:%S"),
            "size": total_size/1.0e9 # convert to GB
            }   
        info.append(_info)
    return info

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--scope', type=str, help='rucio scope')
    parser.add_argument('--datasets_file', type=str, help='file with datasets list')
    args = parser.parse_args()
    scope = args.scope
    datasets = []
    with open(args.datasets_file) as file:
        while line := file.readline():
            d = line.replace('\n', '') 
            datasets.append(d)
    
    info = get_info(scope, datasets)
    json = json.dumps(info)
    f = open('rucio_info.json', 'w')
    f.write(json)
    f.close()

