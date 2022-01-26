// SPDX-License-Identifier: unlicensed
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract YieldFarmer {
    enum Protocol {
        A,
        B,
        C
    }
    Protocol public currentProtocol;
    IERC20 public token;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function deposit(uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        withdrawFrom(currentProtocol);
        _rebalance();
    }

    function withdraw(uint256 amount) external {
        withdrawFrom(currentProtocol);
        token.transfer(msg.sender, amount);
        _rebalance();
    }

    function rebalance() public {
        withdrawFrom(currentProtocol);
        _rebalance();
    }

    function _rebalance() internal {
        uint256 yieldA = getYieldA();
        uint256 yieldB = getYieldB();
        uint256 yieldC = getYieldC();

        if (yieldA >= yieldB && yieldA >= yieldC) {
            investTo(Protocol.A);
            currentProtocol = Protocol.A;
        } else if (yieldB >= yieldA && yieldB >= yieldC) {
            investTo(Protocol.B);
            currentProtocol = Protocol.B;
        } else if (yieldC >= yieldA && yieldC >= yieldB) {
            investTo(Protocol.C);
            currentProtocol = Protocol.C;
        }
    }

    function withdrawFrom(Protocol protocol) internal {}

    function investTo(Protocol protocol) internal {}

    function getYieldA() public view returns (uint256) {}

    function getYieldB() public view returns (uint256) {}

    function getYieldC() public view returns (uint256) {}
}
