pragma solidity >=0.5 <=0.9;

import "./YKToken.sol";

contract EthSwap {
    string public name = "YKSwap Instant Exchange";
    Token public token;
    // hardcoded rate
    uint256 public rate = 100;

    // Events
    event TokenPurchased(
        address account,
        address token,
        uint256 amount,
        uint256 rate
    );
    event TokenSold(
        address account,
        address token,
        uint256 amount,
        uint256 rate
    );

    constructor(Token _token) public {
        token = _token;
    }

    function buyToken() public payable {
        // Calculate the number of tokens to buy
        uint256 amount = msg.value * rate;

        // Require wheher Swap has enough YKTokens
        require(token.balanceOf(address(this)) >= amount);

        // Make Transaction
        token.transfer(msg.sender, amount);

        // Emit 'TokensPurchased' event
        emit TokenPurchased(msg.sender, address(token), amount, rate);
    }

    function sellToken(uint256 _amount) public {
        // Require whether user has enough tokens to make the sell
        require(token.balanceOf(msg.sender) >= _amount);

        // Amount of ETH
        uint256 amount = _amount / rate;

        // Check whether SWAP has enough ETH swap
        require(address(this).balance >= amount);

        // Sell YKToken
        token.transferFrom(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(amount);

        // Emit 'TokenSold' event
        emit TokenSold(msg.sender, address(token), _amount, rate);
    }
}
