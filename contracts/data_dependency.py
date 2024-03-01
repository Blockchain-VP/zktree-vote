import sys

from slither import Slither
from slither.analyses.data_dependency.data_dependency import (
    is_dependent,
    is_tainted,
)
from slither.core.declarations.solidity_variables import SolidityVariableComposed

# if len(sys.argv) != 2:
#     print("Usage: python data_dependency.py file.sol")
#     sys.exit(-1)

slither = Slither("ZKTreeVote.sol")

contracts = slither.get_contract_from_name("ZKTreeVote.sol")
assert len(contracts) == 1
contract = contracts[0]
destination = contract.get_state_variable_from_name("destination")
source = contract.get_state_variable_from_name("source")
assert source
assert destination

print(f"{source} is dependent of {destination}: {is_dependent(source, destination, contract)}")
assert not is_dependent(source, destination, contract)
print(f"{destination} is dependent of {source}: {is_dependent(destination, source, contract)}")
assert is_dependent(destination, source, contract)
print(f"{source} is tainted {is_tainted(source, contract)}")
assert not is_tainted(source, contract)
print(f"{destination} is tainted {is_tainted(destination, contract)}")
assert is_tainted(destination, contract)
