
pragma solidity 0.7.3;

interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender)
    external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value)
    external returns (bool);

  function transferFrom(address from, address to, uint256 value)
    external returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

library SafeERC20 {
  function safeTransfer(
    IERC20 token,
    address to,
    uint256 value
  )
    internal
  {
    require(token.transfer(to, value));
  }

  function safeTransferFrom(
    IERC20 token,
    address from,
    address to,
    uint256 value
  )
    internal
  {
    require(token.transferFrom(from, to, value));
  }

  function safeApprove(
    IERC20 token,
    address spender,
    uint256 value
  )
    internal
  {
    require(token.approve(spender, value));
  }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/**
 * @dev A token holder contract that will allow a beneficiary to extract the
 * tokens after a given release time.
 */
contract TokenVesting {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // Address who will receive tokens
    address _beneficiary;

    // Amount of tokens released so far
    uint256 released;

    // Token address to release
    IERC20 _token;

    //Owner address
    address public _owner;

    // List of dates(in unix timestamp) on which tokens will be released
    uint256[] timeperiods;

    // Number of tokens to be released after each dates
    uint256[] tokenAmounts;

    // Total number of periods released
    uint256 periodsReleased;

    /// @notice Release Event
    event Released(uint256 amount, uint256 periods);

    /// @notice Initialize token vesting parameters
    constructor(
        uint256[] memory periods,
        uint256[] memory amounts,
        address beneficiary,
        address token,
        address owner
    ) {
        require(beneficiary != address(0), "beneficiary cant be null address");
        timeperiods = periods;
        tokenAmounts = amounts;
        _beneficiary = beneficiary;
        _token = IERC20(token);
        _owner = owner;

    }

    /// @notice Release tokens to beneficiary
    /// @dev multiple periods can be released in one call
    function release() external {
        require(periodsReleased < timeperiods.length, "Nothing to release");
        uint256 amount = 0;
        for (uint256 i = periodsReleased; i < timeperiods.length; i++) {
            if (timeperiods[i] <= block.timestamp) {
                amount = amount.add(tokenAmounts[i]);
                periodsReleased = periodsReleased.add(1);
            }
            else {
                break;
            }
        }
        require(amount > 0, "Nothing to release yet");
        released = released.add(amount);
        IERC20(_token).safeTransfer(_beneficiary, amount);

        emit Released(amount, periodsReleased);
    }

    /// @notice Transfers all the tokens to the owner
    function revoke() external{
          require(msg.sender == _owner, "Invalid Access");
          IERC20(_token).safeTransfer(_owner, IERC20(_token).balanceOf(address(this)));
    }

    /// @notice Get release amount and timestamp for a given period index
    function getPeriodData(uint index) external view returns(uint amount, uint timestamp){
        amount = tokenAmounts[index];
        timestamp = timeperiods[index];
    }

    /// @notice Get release amount and timestamp for a given period index
    function getGlobalData()
        external
        view
        returns(uint releasedPeriods, uint totalPeriods, uint totalReleased, address beneficiary, address token, address owner)
    {
        releasedPeriods = periodsReleased;
        totalPeriods = timeperiods.length;
        totalReleased = released;
        beneficiary = _beneficiary;
        token = address(_token);
        owner = _owner;
    }
}