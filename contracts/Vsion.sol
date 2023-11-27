// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./IUniswapV2Router02.sol";
import "./IUniswapV2Factory.sol";

contract VSION is ERC20, Ownable, ERC20Burnable {
    using SafeMath for uint256;
    mapping(address => bool) private _isExcludedFromFees;

    string public NAME = "VSION Hub Ecosystem | DAP Protocol";
    string public WEBSITE = "https://vsion.io";
    string public TELEGRAM = "https://t.me/vsionhub";
    string public EMAIL_INFO = "info@vsion.io";
    string public POWER_BY = "https://criptovision.com";
    uint public SELL_TAX = 20;
    uint public BUY_TAX = 10;
    uint public constant PERCENT_DIVIDER = 1000;

    IUniswapV2Router02 public ROUTER;
    IUniswapV2Factory public FACTORY;

    address public ROUTER_MAIN =
        address(0x10ED43C718714eb63d5aA57B78B54704E256024E);

    event ExcludeFromFees(address indexed account, bool isExcluded);

    address public DAPFEE = payable(0xc8364B02bBE37D4C2E856B14599F4E5eF9c188CC);
    address[4] private TOKENPAIR = [
        0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56,
        0x55d398326f99059fF775485246999027B3197955,
        0x2170Ed0880ac9A755fd29B2688956BD959F933F8,
        0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c
    ];
    mapping(address => bool) public pancakeSwapPair;
    uint public feeExpiration;
    uint public constant feeExpirationStep = 400 days;
    modifier transferTaxFree() {
        uint256 taxSell = SELL_TAX;
        uint taxBuy = BUY_TAX;
        SELL_TAX = 0;
        BUY_TAX = 0;
        _;
        SELL_TAX = taxSell;
        BUY_TAX = taxBuy;
    }

    constructor() ERC20("VSION Hub Ecosystem Token", "VSN") {
        _mint(msg.sender, 10000000 ether);
        ROUTER = IUniswapV2Router02(ROUTER_MAIN);
        FACTORY = IUniswapV2Factory(ROUTER.factory());
        initializePairs();
        feeExpiration = block.timestamp + feeExpirationStep;
        _isExcludedFromFees[address(this)] = true;
    }

    function isEnableFee() public view returns (bool) {
        if (feeExpirationSeconds() > 0) {
            return true;
        } else {
            return false;
        }
    }

    function feeExpirationSeconds() public view returns (uint) {
        if (feeExpiration > block.timestamp) {
            return feeExpiration - block.timestamp;
        } else {
            return 0;
        }
    }

    function isPair(address _address) public view returns (bool) {
        return pancakeSwapPair[_address];
    }

    function initializePairs() private {
        address pair = FACTORY.createPair(address(this), ROUTER.WETH());
        pancakeSwapPair[pair] = true;
        for (uint i = 0; i < TOKENPAIR.length; i++) {
            pair = FACTORY.createPair(address(this), TOKENPAIR[i]);
            pancakeSwapPair[pair] = true;
        }
    }

    function getTaxes() public view returns (uint, uint) {
        return (SELL_TAX, BUY_TAX);
    }

    function transferIsWhitelist(
        address sender,
        address receiver
    ) public view returns (bool) {
        return _isExcludedFromFees[sender] || _isExcludedFromFees[receiver];
    }

    function _transfer(
        address sender,
        address receiver,
        uint256 amount
    ) internal virtual override {
        uint256 taxAmount;
        bool isWhitelisted = transferIsWhitelist(sender, receiver);
        if (!isWhitelisted && (BUY_TAX > 0 || SELL_TAX > 0) && isEnableFee()) {
            if (isPair(sender)) {
                taxAmount = (amount * BUY_TAX) / PERCENT_DIVIDER;
            } else if (isPair(receiver)) {
                taxAmount = (amount * SELL_TAX) / PERCENT_DIVIDER;
            }
        }

        if (taxAmount > 0) {
            super._transfer(sender, DAPFEE, taxAmount);
        }
        super._transfer(sender, receiver, amount - taxAmount);
    }

    function excludeFromFees(
        address account,
        bool excluded
    ) external onlyOwner {
        require(
            _isExcludedFromFees[account] != excluded,
            "Account is already the value of 'excluded'"
        );
        _isExcludedFromFees[account] = excluded;
        emit ExcludeFromFees(account, excluded);
    }

    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
    }
}
