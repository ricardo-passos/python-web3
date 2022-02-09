import json
from solcx import compile_standard, install_solc
from web3 import Web3
from dotenv import load_dotenv
from os import getenv

with open("./blockchain/contracts/SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()

install_solc("0.6.0")

compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.6.0",
)

with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)

bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

load_dotenv()

provider = Web3.HTTPProvider(getenv("RPC_SERVER"))
w3 = Web3(provider)
chain_id = 5777

deployer_wallet_address = w3.toChecksumAddress(getenv("DEPLOYER_WALLET_ADDRESS"))
deployer_private_key = getenv("DEPLOYER_WALLET_PRIVATE_KEY")

SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)

nonce = w3.eth.getTransactionCount(deployer_wallet_address)

transaction = SimpleStorage.constructor().buildTransaction(
    {
        "chainId": chain_id,
        "from": deployer_wallet_address,
        "nonce": nonce,
        "gasPrice": w3.eth.gas_price,
    }
)

signed_tx = w3.eth.account.sign_transaction(
    transaction, private_key=deployer_private_key
)

tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)

store_transaction = simple_storage.functions.store(15).buildTransaction(
    {
        "chainId": chain_id,
        "from": deployer_wallet_address,
        "nonce": nonce + 1,
        "gasPrice": w3.eth.gas_price,
    }
)

signed_store_tx = w3.eth.account.sign_transaction(
    store_transaction, private_key=deployer_private_key
)

transaction_hash = w3.eth.send_raw_transaction(signed_store_tx.rawTransaction)
