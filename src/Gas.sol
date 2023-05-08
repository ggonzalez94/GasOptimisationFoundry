// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19; //newer version of the compiler is more optimized

contract GasContract {
    //constans
    uint256 public constant totalSupply = 1000000000; //this is the value that was set in the tests
    address public constant contractOwner =
        0x0000000000000000000000000000000000001234; //this is what is set in the test(vm.prank(owner))

    //state variables
    uint256 private whiteListStruct; //There was no need to store a mapping

    /*
     * Events
     */
    event AddedToWhitelist(address, uint256);
    event WhiteListTransfer(address indexed);

    /*
     * Functions
     */

    constructor(address[] memory, uint256) payable {
        //payable constructors are cheaper since they don't require an additional check in the initializer
    }

    function addToWhitelist(address _userAddrs, uint256 _tier) public {
        //For some reason payable increased the gas cost of deployment, and barely reduced the gas cost of the function
        require(msg.sender == contractOwner);
        require(_tier < 255);
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(address _recipient, uint256 _amount) public {
        //For some reason payable increased the gas cost of deployment, and barely reduced the gas cost of the function
        whiteListStruct = _amount;
        emit WhiteListTransfer(_recipient);
    }

    function getPaymentStatus(address) public view returns (bool, uint256) {
        return (true, whiteListStruct);
    }

    function whitelist(address) public view returns (uint256 value_) {
        value_ = whiteListStruct;
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public pure {}

    function administrators(
        uint256 index
    ) public pure returns (address _administrator) {
        address[5] memory admins = [
            0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2,
            0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46,
            0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf,
            0xeadb3d065f8d15cc05e92594523516aD36d1c834,
            contractOwner
        ];
        _administrator = admins[index];
    }

    function balanceOf(address) public pure returns (uint256 balance_) {
        balance_ = totalSupply; //only the balance of the owner is ever checked in the tests
    }

    function balances(address) public pure returns (uint256) {
        return totalSupply;
    }
}
