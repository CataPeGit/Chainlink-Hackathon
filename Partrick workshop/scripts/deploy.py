from brownie import accounts, config, SimpleStorage


def deploy():
    account = accounts.add(config["wallets"]["from_key"])
    simple_storage = SimpleStorage.deploy(
        {"from": account}, publish_source=True)
    print(simple_storage.retrieve())
    storeTransaction = simple_storage.store(77, {"from": account})
    storeTransaction.wait(1)
    print(simple_storage.retrieve())


def main():
    deploy()
