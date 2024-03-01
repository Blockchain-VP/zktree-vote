import sys
from slither.slither import Slither

# if len(sys.argv) != 2:
#     print("python functions_called.py functions_called.sol")
#     sys.exit(-1)

# Init slither
slither = Slither("ZKTreeVote.sol")

# Get the contract
contracts = slither.get_contract_from_name("ZKTreeVote")
assert len(contracts) == 1
contract = contracts[0]

for f in contract.functions:
    all_calls = f.all_internal_calls()

    all_calls_formated = [f.full_name for f in all_calls]

    # Print the result
    print(f"From function {f} reached are {all_calls_formated}")

