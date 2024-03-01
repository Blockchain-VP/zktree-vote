import sys

from slither import Slither
from slither.analyses.data_dependency.data_dependency import (
    is_dependent,
    is_tainted,
)
from slither.core.declarations.solidity_variables import SolidityVariableComposed

slither = Slither("ZKTreeVote.sol")

contracts = slither.get_contract_from_name("ZKTreeVote")
contract = contracts[0]
options = contract.get_state_variable_from_name("optionCounter")
source = contract.get_state_variable_from_name("owner")
result = contract.get_state_variable_from_name("result")
assert source
assert options

print(f"{source} is tainted {is_tainted(source, contract)}")
print(f"{options} is tainted {is_tainted(options, contract)}")
print(f"{options} is dependent of {source}: {is_dependent(options, source, contract)}")
print(f"{result} is dependent of {source}: {is_dependent(result, source, contract)}")
print(f"{result} is dependent of {options}: {is_dependent(result, options, contract)}")
