
from scripts.tools import get_account
from brownie import Admin, Web3Club, BitUser


def deploy():
    account = get_account()
    bitUser = BitUser.deploy({"from": account})
    web3Club = Web3Club.deploy({'from': account})
    admin = Admin.deploy(bitUser.address, web3Club.address, {"from": account})
    admin_change_tx = bitUser.setOwner(admin.address, {"from": account})
    admin_change_tx.wait(1)
    admin_change_tx = web3Club.setOwner(admin.address, {"from": account})
    admin_change_tx.wait(1)
    print(admin.address)


def main():
    deploy()
