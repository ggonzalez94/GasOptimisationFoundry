// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19; //newer version of the compiler is more optimized

contract GasContract {
    //constans
    uint256 public constant totalSupply = 1000000000; //this is the value that was set in the tests
    uint256 public constant tradePercent = 12;
    address public constant contractOwner = address(0x1234); //this is what is set in the test(vm.prank(owner))

    /*
     * State variables
     */
    //public
    mapping(address => uint256) public balances;
    mapping(address => uint256) public whitelist;

    //TODO: Constant arrays are not supported, but maybe this can help https://ethereum.stackexchange.com/questions/66388/standard-work-around-for-using-a-solidity-constant-array-which-is-not-supported
    address[5] public administrators = [
        0x3243Ed9fdCDE2345890DDEAf6b083CA4cF0F68f2,
        0x2b263f55Bf2125159Ce8Ec2Bb575C649f822ab46,
        0x0eD94Bc8435F3189966a49Ca1358a55d871FC3Bf,
        0xeadb3d065f8d15cc05e92594523516aD36d1c834,
        contractOwner
    ];

    //private
    mapping(address => uint256) private whiteListStruct;

    /*
     * Events
     */
    event AddedToWhitelist(address userAddress, uint256 tier);
    event WhiteListTransfer(address indexed);

    /*
     * Functions
     */

    constructor(address[] memory _admins, uint256 _totalSupply) {
        balances[contractOwner] = totalSupply;
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public returns (bool status_) {
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        status_ = true;
    }

    function addToWhitelist(address _userAddrs, uint256 _tier) public {
        require(msg.sender == contractOwner);
        require(_tier < 255);
        whitelist[_userAddrs] = (_tier > 3) ? 3 : (_tier == 1) ? 1 : 2;
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(address _recipient, uint256 _amount) public {
        uint256 whiteListValue = whitelist[msg.sender];
        whiteListStruct[msg.sender] = _amount;
        balances[msg.sender] = balances[msg.sender] - _amount + whiteListValue;
        balances[_recipient] = balances[_recipient] + _amount - whiteListValue;

        emit WhiteListTransfer(_recipient);
    }

    function balanceOf(address _user) public view returns (uint256 balance_) {
        balance_ = balances[_user];
    }

    function getPaymentStatus(
        address sender
    ) public view returns (bool, uint256) {
        return (whiteListStruct[sender] > 0, whiteListStruct[sender]);
    }
}
