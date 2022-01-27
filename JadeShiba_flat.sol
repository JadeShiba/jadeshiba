// SPDX-License-Identifier: Unlicensed

// File: contracts/iterableMapLib.sol
 
pragma solidity ^0.8.4;

library IterableMapping 
{
    // Iterable mapping from address to uint;
    struct Map
    {
        address[] keys;
        mapping(address => uint) values;
        mapping(address => uint) indexOf;
        mapping(address => bool) inserted;
    }
 
    function get(Map storage map, address key) public view returns (uint)
    {
        return map.values[key];
    }
 
    function getIndexOfKey(Map storage map, address key) public view returns (int) 
    {
        if(!map.inserted[key]) 
        {
            return -1;
        }
        return int(map.indexOf[key]);
    }
 
    function getKeyAtIndex(Map storage map, uint index) public view returns (address)
    {
        return map.keys[index];
    }
 
 
    function size(Map storage map) public view returns (uint)
    {
        return map.keys.length;
    }
 
    function set(Map storage map, address key, uint val) public
    {
        if (map.inserted[key])
        {
            map.values[key] = val;
        } 
        else
        {
            map.inserted[key] = true;
            map.values[key] = val;
            map.indexOf[key] = map.keys.length;
            map.keys.push(key);
        }
    }
 
    function remove(Map storage map, address key) public
    {
        if (!map.inserted[key])
        {
            return;
        }
 
        delete map.inserted[key];
        delete map.values[key];
 
        uint index = map.indexOf[key];
        uint lastIndex = map.keys.length - 1;
        address lastKey = map.keys[lastIndex];
 
        map.indexOf[lastKey] = index;
        delete map.indexOf[key];
 
        map.keys[index] = lastKey;
        map.keys.pop();
    }
}
// File: contracts/mathLib.sol


 
pragma solidity ^0.8.4;

library SafeMath 
{
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256)
    {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }
 
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256)
    {
        if (b > a) return (false, 0);
        return (true, a - b);
    }
 
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) 
    {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }
 
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) 
    {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }
 
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256)
    {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }
 
    function add(uint256 a, uint256 b) internal pure returns (uint256)
    {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
 
    function sub(uint256 a, uint256 b) internal pure returns (uint256)
    {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }
 
    function mul(uint256 a, uint256 b) internal pure returns (uint256)
    {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
 
    function div(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }
 
    function mod(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }
 
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) 
    {
        require(b <= a, errorMessage);
        return a - b;
    }
 
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256)
    {
        require(b > 0, errorMessage);
        return a / b;
    }
 
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256)
    {
        require(b > 0, errorMessage);
        return a % b;
    }
}
 
library SafeMathInt 
{
    function mul(int256 a, int256 b) internal pure returns (int256) 
    {
        // Prevent overflow when multiplying INT256_MIN with -1
        // https://github.com/RequestNetwork/requestNetwork/issues/43
        require(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));

        int256 c = a * b;
        require((b == 0) || (c / b == a));
        return c;
    }
 
    function div(int256 a, int256 b) internal pure returns (int256) 
    {
        // Prevent overflow when dividing INT256_MIN by -1
        // https://github.com/RequestNetwork/requestNetwork/issues/43
        require(!(a == - 2**255 && b == -1) && (b > 0));

        return a / b;
    }

    function sub(int256 a, int256 b) internal pure returns (int256)
    {
        require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));

        return a - b;
    }

    function add(int256 a, int256 b) internal pure returns (int256) 
    {
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));
        return c;
    }

    function toUint256Safe(int256 a) internal pure returns (uint256) 
    {
        require(a >= 0);
        return uint256(a);
    }
}
 
library SafeMathUint 
{
    function toInt256Safe(uint256 a) internal pure returns (int256) 
    {
        int256 b = int256(a);
        require(b >= 0);
        return b;
    }
}
// File: contracts/ownable.sol


 
pragma solidity ^0.8.4;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context 
{
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    //constructor () internal { }

    function _msgSender() internal view virtual returns (address payable)
    {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) 
    {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context 
{
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
    * @dev Initializes the contract setting the deployer as the initial owner.
    */
    constructor () 
    {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
    * @dev Returns the address of the current owner.
    */
    function owner() public view returns (address) 
    {
        return _owner;
    }

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner()
    {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
    * @dev Leaves the contract without owner. It will not be possible to call
    * `onlyOwner` functions anymore. Can only be called by the current owner.
    *
    * NOTE: Renouncing ownership will leave the contract without an owner,
    * thereby removing any functionality that is only available to the owner.
    */
    function renounceOwnership() public onlyOwner 
    {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
    * @dev Transfers ownership of the contract to a new account (`newOwner`).
    * Can only be called by the current owner.
    */
    function transferOwnership(address newOwner) public onlyOwner 
    {
        _transferOwnership(newOwner);
    }

    /**
    * @dev Transfers ownership of the contract to a new account (`newOwner`).
    */
    function _transferOwnership(address newOwner) internal 
    {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
// File: contracts/interface.sol



pragma solidity ^0.8.4;

interface IERC20
{
    /**
    * @dev Returns the amount of tokens in existence.
    */
    function totalSupply() external view returns (uint256);

    /**
    * @dev Returns the token decimals.
    */
    //function decimals() external view returns (uint8);

    /**
    * @dev Returns the token symbol.
    */
    //function symbol() external view returns (string memory);

    /**
    * @dev Returns the token name.
    */
    //function name() external view returns (string memory);

    /**
    * @dev Returns the bep token owner.
    */
    //function getOwner() external view returns (address);

    /**
    * @dev Returns the amount of tokens owned by `account`.
    */
    function balanceOf(address account) external view returns (uint256);

    /**
    * @dev Moves `amount` tokens from the caller's account to `recipient`.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * Emits a {Transfer} event.
    */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
    * @dev Returns the remaining number of tokens that `spender` will be
    * allowed to spend on behalf of `owner` through {transferFrom}. This is
    * zero by default.
    *
    * This value changes when {approve} or {transferFrom} are called.
    */
    function allowance(address _owner, address spender) external view returns (uint256);

    /**
    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * IMPORTANT: Beware that changing an allowance with this method brings the risk
    * that someone may use both the old and the new allowance by unfortunate
    * transaction ordering. One possible solution to mitigate this race
    * condition is to first reduce the spender's allowance to 0 and set the
    * desired value afterwards:
    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    *
    * Emits an {Approval} event.
    */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
    * @dev Moves `amount` tokens from `sender` to `recipient` using the
    * allowance mechanism. `amount` is then deducted from the caller's
    * allowance.
    *
    * Returns a boolean value indicating whether the operation succeeded.
    *
    * Emits a {Transfer} event.
    */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
    * @dev Emitted when `value` tokens are moved from one account (`from`) to
    * another (`to`).
    *
    * Note that `value` may be zero.
    */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
    * a call to {approve}. `value` is the new allowance.
    */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/dividendPayingToken.sol







pragma solidity ^0.8.4;

contract ERC20 is Context, IERC20
{
    using SafeMath for uint256;
 
    mapping (address => uint256) private _balances;
 
    mapping (address => mapping (address => uint256)) private _allowances;
 
    uint256 private _totalSupply;
 
    string private _name;
    string private _symbol;
    uint8 private _decimals;
 
    constructor (string memory pName, string memory pSymbol) 
    {
        _name = pName;
        _symbol = pSymbol;
        _decimals = 18;
    }

    function name() public view virtual returns (string memory)
    {
        return _name;
    }
 
    function symbol() public view virtual returns (string memory)
    {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8)
    {
        return _decimals;
    }
 
    function totalSupply() public view virtual override returns (uint256)
    {
        return _totalSupply;
    }
 
    function balanceOf(address account) public view virtual override returns (uint256)
    {
        return _balances[account];
    }
 
    function transfer(address recipient, uint256 amount) public virtual override returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
 
    function allowance(address owner, address spender) public view virtual override returns (uint256)
    {
        return _allowances[owner][spender];
    }
 
    function approve(address spender, uint256 amount) public virtual override returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }
 
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool)
    {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
 
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool)
    {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
 
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool)
    {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
 
    function _transfer(address sender, address recipient, uint256 amount) internal virtual
    {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
 
        _beforeTokenTransfer(sender, recipient, amount);
 
        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }
 
    function _mint(address account, uint256 amount) internal virtual
    {
        require(account != address(0), "ERC20: mint to the zero address");
 
        _beforeTokenTransfer(address(0), account, amount);
 
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
 
    function _burn(address account, uint256 amount) internal virtual
    {
        require(account != address(0), "ERC20: burn from the zero address");
 
        _beforeTokenTransfer(account, address(0), amount);
 
        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
 
    function _approve(address owner, address spender, uint256 amount) internal virtual
    {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
 
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
 
    function _setupDecimals(uint8 decimals_) internal virtual
    {
        _decimals = decimals_;
    }
 
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual
    {
        //
    }
}

interface iDividendPayingToken 
{
  function dividendOf(address _owner) external view returns(uint256);
 
  function withdrawDividend() external;
 
  event DividendsDistributed(address indexed from, uint256 weiAmount);
 
  event DividendWithdrawn(address indexed to, uint256 weiAmount);
}

interface iDividendPayingTokenOptional
{
    function withdrawableDividendOf(address _owner) external view returns(uint256);

    function withdrawnDividendOf(address _owner) external view returns(uint256);

    function accumulativeDividendOf(address _owner) external view returns(uint256);
}

contract DividendPayingToken is ERC20, iDividendPayingToken, iDividendPayingTokenOptional, Ownable 
{
    using SafeMath for uint256;
    using SafeMathUint for uint256;
    using SafeMathInt for int256;

    uint256 constant internal magnitude = 2**128;

    uint256 internal magnifiedDividendPerShare;
    uint256 internal lastAmount;

    address public dividendToken;


    mapping(address => int256) internal magnifiedDividendCorrections;
    mapping(address => uint256) internal withdrawnDividends;
    mapping(address => bool) _isAuth;

    uint256 public totalDividendsDistributed;

    modifier onlyAuth()
    {
        require(_isAuth[msg.sender], "Auth: caller is not the authorized");
        _;
    }
 
    constructor(string memory _name, string memory _symbol, address _token) ERC20(_name, _symbol)
    {
        dividendToken = _token;
        _isAuth[msg.sender] = true;
    }
 
    function setAuth(address account) external onlyOwner
    {
        _isAuth[account] = true;
    }


    function distributeDividends(uint256 amount) public onlyOwner
    {
        require(totalSupply() > 0);

        if (amount > 0)
        {
            magnifiedDividendPerShare = magnifiedDividendPerShare.add((amount).mul(magnitude) / totalSupply());
            
            emit DividendsDistributed(msg.sender, amount);

            totalDividendsDistributed = totalDividendsDistributed.add(amount);
        }
    }
 
    function withdrawDividend() public virtual override
    {
        _withdrawDividendOfUser(payable(msg.sender));
    }

    function setDividendTokenAddress(address newToken) external virtual onlyOwner
    {
        dividendToken = newToken;
    }
 
    function _withdrawDividendOfUser(address payable user) internal returns (uint256)
    {
        uint256 _withdrawableDividend = withdrawableDividendOf(user);
        
        if (_withdrawableDividend > 0) 
        {
            withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
            emit DividendWithdrawn(user, _withdrawableDividend);
            bool success = IERC20(dividendToken).transfer(user, _withdrawableDividend);

            if(!success)
            {
                withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
                return 0;
            }

            return _withdrawableDividend;
        }

        return 0;
    }
 
 
    function dividendOf(address _owner) public view override returns(uint256)
    {
        return withdrawableDividendOf(_owner);
    }

    function withdrawableDividendOf(address _owner) public view override returns(uint256)
    {
        return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
    }

    function withdrawnDividendOf(address _owner) public view override returns(uint256)
    {
        return withdrawnDividends[_owner];
    }
 
 
    function accumulativeDividendOf(address _owner) public view override returns(uint256)
    {
        return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
            .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
    }
 
    function _transfer(address from, address to, uint256 value) internal virtual override 
    {
        require(false);

        int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
        magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
        magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
    }
 
    function _mint(address account, uint256 value) internal override
    {
        super._mint(account, value);

        magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
          .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
    }

    function _burn(address account, uint256 value) internal override 
    {
        super._burn(account, value);

        magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
          .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
    }
 
    function _setBalance(address account, uint256 newBalance) internal 
    {
        uint256 currentBalance = balanceOf(account);

        if(newBalance > currentBalance)
        {
            uint256 mintAmount = newBalance.sub(currentBalance);
            _mint(account, mintAmount);
        }
        else if(newBalance < currentBalance)
        {
            uint256 burnAmount = currentBalance.sub(newBalance);
            _burn(account, burnAmount);
        }
    }
}

contract TOKEN_X_DividendTracker is Ownable, DividendPayingToken
{
    using SafeMath for uint256;
    using SafeMathInt for int256;
    using IterableMapping for IterableMapping.Map;
 
    IterableMapping.Map private tokenHoldersMap;
    uint256 public lastProcessedIndex;
 
    mapping (address => bool) public excludedFromDividends;
 
    mapping (address => uint256) public lastClaimTimes;
 
    uint256 public claimWait;
    uint256 public minimumTokenBalanceForDividends;
 
    event ExcludeFromDividends(address indexed account);
    event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
 
    event Claim(address indexed account, uint256 amount, bool indexed automatic);
 
    constructor(address _dividentToken) DividendPayingToken("JSI_DIVIDEND", "JSI_DIVIDEND",_dividentToken)
    {
        //Wait period to claim reward token
    	claimWait = 3600;
        
        //Min token to hold to Rx reward (1,000,000 tokens)
        minimumTokenBalanceForDividends = 1000000 * (10**18);

        //Min token to hold to Rx reward (1,000,000,000 tokens)
        //minimumTokenBalanceForDividends = 1000000000 * (10**18);
    }
 
    function _transfer(address, address, uint256) pure internal override 
    {
        require(false, "Token_Dividend_Tracker: No transfers allowed");
    }
 
    function withdrawDividend() pure public override 
    {
        require(false, "Token_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main Boda contract.");
    }
 
    function setDividendTokenAddress(address newToken) external override onlyOwner
    {
      dividendToken = newToken;
    }
 
    function updateMinimumTokenBalanceForDividends(uint256 _newMinimumBalance) external onlyOwner 
    {
        require(_newMinimumBalance != minimumTokenBalanceForDividends, "New mimimum balance for dividend cannot be same as current minimum balance");
        minimumTokenBalanceForDividends = _newMinimumBalance * (10**18);
    }
 
    function excludeFromDividends(address account) external onlyOwner
    {
    	require(!excludedFromDividends[account]);
    	excludedFromDividends[account] = true;
 
    	_setBalance(account, 0);
    	tokenHoldersMap.remove(account);
 
    	emit ExcludeFromDividends(account);
    }
 
    function updateClaimWait(uint256 newClaimWait) external onlyOwner
    {
        require(newClaimWait >= 3600 && newClaimWait <= 86400, "Token_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
        require(newClaimWait != claimWait, "Token_Dividend_Tracker: Cannot update claimWait to same value");
        emit ClaimWaitUpdated(newClaimWait, claimWait);
        claimWait = newClaimWait;
    }
 
    function getLastProcessedIndex() external view returns(uint256) 
    {
    	return lastProcessedIndex;
    }
 
    function getNumberOfTokenHolders() external view returns(uint256) 
    {
        return tokenHoldersMap.keys.length;
    }
 
 
    function getAccount(address _account)
        public view returns (
            address account,
            int256 index,
            int256 iterationsUntilProcessed,
            uint256 withdrawableDividends,
            uint256 totalDividends,
            uint256 lastClaimTime,
            uint256 nextClaimTime,
            uint256 secondsUntilAutoClaimAvailable) 
    {
        account = _account;
 
        index = tokenHoldersMap.getIndexOfKey(account);
 
        iterationsUntilProcessed = -1;
 
        if(index >= 0) 
        {
            if(uint256(index) > lastProcessedIndex)
            {
                iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
            }
            else 
            {
                uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
                                                        tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
                                                        0;
 
 
                iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
            }
        }
 
 
        withdrawableDividends = withdrawableDividendOf(account);
        totalDividends = accumulativeDividendOf(account);
 
        lastClaimTime = lastClaimTimes[account];
 
        nextClaimTime = lastClaimTime > 0 ?
                                    lastClaimTime.add(claimWait) :
                                    0;
 
        secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
                                                    nextClaimTime.sub(block.timestamp) :
                                                    0;
    }
 
    function getAccountAtIndex(uint256 index)
        public view returns (
            address,
            int256,
            int256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256) 
    {
    	if(index >= tokenHoldersMap.size())
        {
            return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
        }
 
        address account = tokenHoldersMap.getKeyAtIndex(index);
 
        return getAccount(account);
    }
 
    function canAutoClaim(uint256 lastClaimTime) private view returns (bool)
    {
    	if(lastClaimTime > block.timestamp)
        {
    		return false;
    	}
 
    	return block.timestamp.sub(lastClaimTime) >= claimWait;
    }
 
    function setBalance(address payable account, uint256 newBalance) external onlyOwner
    {
    	if(excludedFromDividends[account])
        {
    		return;
    	}
 
    	if(newBalance >= minimumTokenBalanceForDividends)
        {
            _setBalance(account, newBalance);
    		tokenHoldersMap.set(account, newBalance);
    	}
    	else
        {
            _setBalance(account, 0);
    		tokenHoldersMap.remove(account);
    	}
 
    	processAccount(account, true);
    }
 
    function process(uint256 gas) public returns (uint256, uint256, uint256)
    {
    	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
 
    	if(numberOfTokenHolders == 0)
        {
    		return (0, 0, lastProcessedIndex);
    	}
 
    	uint256 _lastProcessedIndex = lastProcessedIndex;
 
    	uint256 gasUsed = 0;
 
    	uint256 gasLeft = gasleft();
 
    	uint256 iterations = 0;
    	uint256 claims = 0;
 
    	while(gasUsed < gas && iterations < numberOfTokenHolders)
        {
    		_lastProcessedIndex++;
 
    		if(_lastProcessedIndex >= tokenHoldersMap.keys.length)
            {
    			_lastProcessedIndex = 0;
    		}
 
    		address account = tokenHoldersMap.keys[_lastProcessedIndex];
 
    		if(canAutoClaim(lastClaimTimes[account]))
            {
    			if(processAccount(payable(account), true))
                {
    				claims++;
    			}
    		}
 
    		iterations++;
 
    		uint256 newGasLeft = gasleft();
 
    		if(gasLeft > newGasLeft)
            {
    			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
    		}
 
    		gasLeft = newGasLeft;
    	}
 
    	lastProcessedIndex = _lastProcessedIndex;
 
    	return (iterations, claims, lastProcessedIndex);
    }
 
    function processAccount(address payable account, bool automatic) public onlyOwner returns (bool)
    {
        uint256 amount = _withdrawDividendOfUser(account);
 
    	if(amount > 0)
        {
    		lastClaimTimes[account] = block.timestamp;
            emit Claim(account, amount, automatic);
    		return true;
    	}
 
    	return false;
    }
}
// File: contracts/uniswapRouter.sol


 
pragma solidity >=0.6.2;

interface IUniswapV2Factory 
{
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function createPair(address tokenA, address tokenB) external returns (address pair);
  
    //plus
    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair
{
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);

    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);

    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to);

    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;
    
    //plus
    function initialize(address, address) external;
}

interface IUniswapV2Router01
{
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 
{
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}
// File: contracts/JadeShiba.sol





pragma solidity ^0.8.4;

contract JadeShiba is ERC20, Ownable
{
    using SafeMath for uint256;

    IUniswapV2Router02 public uniswapV2Router;
    address public immutable uniswapV2Pair;

    //Marketing Wallet
    address public marketingWallet = 0x8B23bc1b1a164b5c5E86949Acd5d569f774Ba43C; 

    //Dividend Token (BUSD)
    address public dividendTokenAddress = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;

    //Liquidity Wallet
    address public liquidityWallet = 0xbC4c720EdB3Ae3b929B63b504Ea43d855F5ace0f;

    //Dead Wallet
    address public deadAddress = 0x000000000000000000000000000000000000dEaD;

    //Pancakeswap BSC MainNet Router: 0x10ED43C718714eb63d5aA57B78B54704E256024E 
    //Pancakeswap BSC TestNet Router: 0xD99D1c33F9fC3444f8101754aBC46c52416550D1
    address public pancakeSwapBSCRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    bool private swapping;

    bool public tradingIsEnabled = false;
    bool public swapAndLiquifyEnabled = true;
    bool public dividendEnabled = true;
    bool public marketingEnabled = true;
    bool public marketingSwapEnabled = true;

    TOKEN_X_DividendTracker public tokenXDividendTracker;

    uint256 public maxBuyTransactionAmount = 10000000000000 * (10**18);

    uint256 public maxSellTransactionAmount = 1000000000000 * (10**18);

    uint256 public maxWalletBalance = 1000000000000000 * (10**18);

    uint256 public swapTokensThreshold = 20 * 10**6 * 10**18;

    uint256 public liquidityFee;
    uint256 public previousLiquidityFee;

    uint256 public dividendFee;
    uint256 public previousDividendFee;

    uint256 public marketingFee;
    uint256 public previousMarketingFee;

    //totalFees not used
    uint256 public totalFees = dividendFee.add(marketingFee).add(liquidityFee);

    //Buy Fee
    uint256 public _dividendFeeBuy = 7;
    uint256 public _marketingFeeBuy = 3;
    uint256 public _LpFeeBuy = 2;

    //Sell Fee
    uint256 public _dividendFeeSell = 7;
    uint256 public _marketingFeeSell = 3;
    uint256 public _LpFeeSell = 2;

    //Tracker vars
    uint256 public dividendTokensInContract;
    uint256 public liquidityTokensInContract;
    uint256 public marketingTokensInContract;
    uint256 public totalLiquidityBnbFromFees;

    uint256 public sellFeeIncreaseFactor = 100;

    uint256 public gasForProcessing = 600000;

    mapping (address => bool) private isExcludedFromFees;

    // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
    // could be subject to a maximum transfer amount
    mapping (address => bool) public automatedMarketMakerPairs;

    event UpdateDividendTracker(address indexed newAddress, address indexed oldAddress);

    event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);

    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event MarketingEnabledUpdated(bool enabled);
    event TokenXDividendEnabledUpdated(bool enabled);
    event MarketingSwapEnabledUpdated(bool enabled);

    event ExcludeFromFees(address indexed account, bool isExcluded);
    event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);

    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);

    event MarketingWalletUpdated(address indexed newMarketingWallet, address indexed oldMarketingWallet);

    event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);

    event SwapAndLiquify(uint256 tokensSwapped,
                         uint256 bnbReceived,
                         uint256 tokensIntoLiqudity);

    event SendDividends(uint256 amount);

    event ProcessedDividendTracker(uint256 iterations,
                                   uint256 claims,
                                   uint256 lastProcessedIndex,
                                   bool indexed automatic,
                                   uint256 gas,
                                   address indexed processor);

    constructor() ERC20("Jade Shiba Inu", "JSI")
    {
        tokenXDividendTracker = new TOKEN_X_DividendTracker(dividendTokenAddress);
        
    	IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(pancakeSwapBSCRouter);

         // Create a uniswap pair for this new token
        address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
 
        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = _uniswapV2Pair;

        _setAutomatedMarketMakerPair(_uniswapV2Pair, true);

        //Exclude from rx dividend
        excludeFromDividend(address(this));
        excludeFromDividend(address(_uniswapV2Router));
        excludeFromDividend(deadAddress);
        excludeFromDividend(address(tokenXDividendTracker));
        excludeFromDividend(liquidityWallet);
        excludeFromDividend(owner());

        //Exclude from paying fees or having max transaction amount
        excludeFromFees(address(this), true);
        excludeFromFees(deadAddress, true);
        excludeFromFees(marketingWallet, true);
        excludeFromFees(liquidityWallet, true);
        excludeFromFees(owner(), true);

        setAuthOnDividends(owner());

        /*
            _mint is an internal function in ERC20.sol that is only called here,
            and CANNOT be called ever again
        */
        //Mint 1 Quadrillion Token (1,000,000,000,000,000)
        _mint(owner(), 1000000000000000 * (10**18));
    }

	// Ensures that the contract is able to receive BNB
    receive() external payable
    {
        //
  	}

    //Interface to exclude dividend and fees for specified address (e.g. partner or exchange)
  	function prepareForPartherOrExchangeListing(address _partnerOrExchangeAddress) external onlyOwner
    {
  	    tokenXDividendTracker.excludeFromDividends(_partnerOrExchangeAddress);
        excludeFromFees(_partnerOrExchangeAddress, true);
  	}

    //Interface to update the max balance in the contract
  	function setWalletBalance(uint256 _maxWalletBalance) external onlyOwner
    {
  	    maxWalletBalance = _maxWalletBalance;
  	}

    //Interface to set the max buy per transaction
  	function setMaxBuyTransaction(uint256 _maxTxn) external onlyOwner
    {
  	    maxBuyTransactionAmount = _maxTxn * (10**18);
  	}

    //Interface to set the max sell per transaction
  	function setMaxSellTransaction(uint256 _maxTxn) external onlyOwner
    {
  	    maxSellTransactionAmount = _maxTxn * (10**18);
  	}

    //Interface to get the liquidity wallet address
	function getAutoLiquidityWallet() public view returns (address) 
    {
		return liquidityWallet;
	}

    //Interface to set the liquidity wallet address
	function setAutoLiquidityWallet(address newLiquidityWallet) public onlyOwner 
    {
        //Require is used to check for conditions and throw an exception if the condition is not met.
  	    require(liquidityWallet != newLiquidityWallet, "The liquidity wallet is already this address");
		
        liquidityWallet = newLiquidityWallet;

        //Exclude from dividend and fees
        excludeFromDividend(liquidityWallet);
        excludeFromFees(liquidityWallet, true);
	}

    //Permit updating the buy transaction fee structure depending on volume
  	function setBuyTransactionFee(uint256 dividendRewardsFeeBuy,
                                  uint256 marketingFeeBuy,
                                  uint256 LpFeeBuy) external onlyOwner
    {
        _dividendFeeBuy = dividendRewardsFeeBuy;
        _marketingFeeBuy = marketingFeeBuy;
        _LpFeeBuy = LpFeeBuy;
  	}

    //Permit updating the sell transaction fee structure depending on volume
  	function setSellTransactionFee(uint256 dividendRewardsFeeSell,
                                   uint256 marketingFeeSell,
                                   uint256 LpFeeSell) external onlyOwner
    {
        _dividendFeeSell = dividendRewardsFeeSell;
        _marketingFeeSell = marketingFeeSell;
        _LpFeeSell = LpFeeSell;
  	}

	function getTotalLiquidityBnbFromFees() public view returns (uint256)
    {
		return totalLiquidityBnbFromFees;
	}


  	function updateDividendToken(address _newContract) external onlyOwner
    {
  	    dividendTokenAddress = _newContract;
  	    tokenXDividendTracker.setDividendTokenAddress(_newContract);
  	}

    function updateTokenDividendTracker(address newAddress) external onlyOwner
    {
        require(newAddress != address(tokenXDividendTracker), "The dividend tracker already has that address");
 
        TOKEN_X_DividendTracker newTokenDividendTracker = TOKEN_X_DividendTracker(payable(newAddress));
 
        require(newTokenDividendTracker.owner() == address(this), "The new dividend tracker must be owned by the token contract");
 
        newTokenDividendTracker.excludeFromDividends(address(this));
        newTokenDividendTracker.excludeFromDividends(address(uniswapV2Router));
        newTokenDividendTracker.excludeFromDividends(address(deadAddress));
        newTokenDividendTracker.excludeFromDividends(address(newTokenDividendTracker)); 
        newTokenDividendTracker.excludeFromDividends(address(liquidityWallet));
        newTokenDividendTracker.excludeFromDividends(address(owner()));
 
        emit UpdateDividendTracker(newAddress, address(tokenXDividendTracker));
 
        tokenXDividendTracker = newTokenDividendTracker;
    }

  	function updateMarketingWallet(address _newWallet) external onlyOwner
    {
  	    require(_newWallet != marketingWallet, "The marketing wallet is already this address");
        
        excludeFromFees(_newWallet, true);
        emit MarketingWalletUpdated(marketingWallet, _newWallet);
  	    marketingWallet = _newWallet;
  	}

  	function setSwapTokensThreshold(uint256 _swapAmount) external onlyOwner
    {
  	    swapTokensThreshold = _swapAmount * (10**18);
  	}

  	function setSellTransactionMultiplier(uint256 _multiplier) external onlyOwner
    {
  	    sellFeeIncreaseFactor = _multiplier;
  	}
 
    //Interface to enable/disable trading
    function setTradingIsEnabled(bool _enabled) external onlyOwner
    {
        tradingIsEnabled = _enabled;
    }

    function setAuthOnDividends(address account) public onlyOwner
    {
        tokenXDividendTracker.setAuth(account);
    }

    function setDividendEnabled(bool _enabled) external onlyOwner
    {
        require(dividendEnabled != _enabled, "Can't set flag to same status");
        
        if (_enabled == false)
        {
            previousDividendFee = dividendFee;
            dividendFee = 0;
            dividendEnabled = _enabled;
        }
        else
        {
            //Re-enable
            dividendEnabled = _enabled;
        }
 
        emit TokenXDividendEnabledUpdated(_enabled);
    }

    function setMarketingEnabled(bool _enabled) external onlyOwner
    {
        require(marketingEnabled != _enabled, "Can't set flag to same status");
        
        if (_enabled == false)
        {
            previousMarketingFee = marketingFee;
            marketingFee = 0;
            marketingEnabled = _enabled;
        } 
        else
        {
            //Re-enable
            marketingEnabled = _enabled;
        }

        emit MarketingEnabledUpdated(_enabled);
    }

    function setMarketingSwapEnabled(bool _enabled) external onlyOwner
    {
        require(marketingSwapEnabled != _enabled, "Can't set flag to same status");
        
        if (_enabled == false)
        {
            marketingSwapEnabled = _enabled;
        } 
        else
        {
            //Re-enable
            marketingSwapEnabled = _enabled;
        }
        
        emit MarketingSwapEnabledUpdated(_enabled);
    }

    //Interface to enable/disable liquidity fee
    function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner
    {
        require(swapAndLiquifyEnabled != _enabled, "Can't set flag to same status");
        
        if (_enabled == false)
        {
            previousLiquidityFee = liquidityFee;
            liquidityFee = 0;
            swapAndLiquifyEnabled = _enabled;
        }
        else
        {
            //Re-enable
            swapAndLiquifyEnabled = _enabled;
        }
 
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }

    //Interface to update uniswap router address
    function updateUniswapV2Router(address newAddress) external onlyOwner
    {
        require(newAddress != address(uniswapV2Router), "The router already has that address");
        
        emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
        
        uniswapV2Router = IUniswapV2Router02(newAddress);
    }

    //Interface to enable/disable account from transaction fee
    function excludeFromFees(address account, bool excluded) public onlyOwner
    {
        require(isExcludedFromFees[account] != excluded, "Account is already exluded from fees");
        
        isExcludedFromFees[account] = excluded;
 
        emit ExcludeFromFees(account, excluded);
    }

    //Interface to exclude account from dividend fee
    function excludeFromDividend(address account) public onlyOwner
    {
        tokenXDividendTracker.excludeFromDividends(address(account));
    }

    function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner
    {
        require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
 
        _setAutomatedMarketMakerPair(pair, value);
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private onlyOwner
    {
        require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
        
        automatedMarketMakerPairs[pair] = value;
 
        if(value)
        {
            tokenXDividendTracker.excludeFromDividends(pair);
        }
 
        emit SetAutomatedMarketMakerPair(pair, value);
    }

    //Interface to update gas progressing
    function updateGasForProcessing(uint256 newValue) external onlyOwner
    {
        require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
        
        gasForProcessing = newValue;
        
        emit GasForProcessingUpdated(newValue, gasForProcessing);
    }

    //Interface to update the min dividend balance
    function updateMinimumBalanceForDividends(uint256 newMinimumBalance) external onlyOwner
    {
        tokenXDividendTracker.updateMinimumTokenBalanceForDividends(newMinimumBalance);
    }

    //Interface to update dividend claim period (1 - 24 hrs (i.e. 3600 - 86400 seconds))
    function updateDividendClaimWait(uint256 claimWait) external onlyOwner
    {
        tokenXDividendTracker.updateClaimWait(claimWait);
    }

    //Interface to get the dividend claim period
    function getDividendClaimWait() external view returns(uint256)
    {
        return tokenXDividendTracker.claimWait();
    }

    //Interface to get total dividend distributed to holders
    function getTotalDividendsDistributed() external view returns (uint256)
    {
        return tokenXDividendTracker.totalDividendsDistributed();
    }

    //Interface to determine if an account is excluded from fees
    function getIsExcludedFromFees(address account) public view returns(bool)
    {
        return isExcludedFromFees[account];
    }

    //Interface to get withdrawable dividend for specified account
    function withdrawableDividendOf(address account) external view returns(uint256)
    {
    	return tokenXDividendTracker.withdrawableDividendOf(account);
  	}

    //Interface to get the balance of dividend tokens
	function dividendTokenBalanceOf(address account) external view returns (uint256)
    {
		return tokenXDividendTracker.balanceOf(account);
	}

    //Interface to get account dividend info
    function getAccountDividendsInfo(address account)
        external view returns (address,
                               int256,
                               int256,
                               uint256,
                               uint256,
                               uint256,
                               uint256,
                               uint256)
    {
        return tokenXDividendTracker.getAccount(account);
    }

    //Interface to get account dividend info at index
	function getAccountDividendsInfoAtIndex(uint256 index)
        external view returns (address,
                               int256,
                               int256,
                               uint256,
                               uint256,
                               uint256,
                               uint256,
                               uint256)
    {
    	return tokenXDividendTracker.getAccountAtIndex(index);
    }

	function processDividendTracker(uint256 gas) external onlyOwner
    {
		(uint256 tokenIterations, uint256 tokenClaims, uint256 tokenLastProcessedIndex) = tokenXDividendTracker.process(gas);
		
        emit ProcessedDividendTracker(tokenIterations, tokenClaims, tokenLastProcessedIndex, false, gas, msg.sender);
    }

    //Claim dividend
    function claim() external
    {
		tokenXDividendTracker.processAccount(payable(msg.sender), false);
    }

    //Interface to get last dividend processed index
    function getLastDividendProcessedIndex() external view returns(uint256)
    {
    	return tokenXDividendTracker.getLastProcessedIndex();
    }

    //Interface to get the number of dividend token holders
    function getNumberOfXTokenDividendTokenHolders() external view returns(uint256)
    {
        return tokenXDividendTracker.getNumberOfTokenHolders();
    }

    function _transfer(address from, address to, uint256 amount) internal override
    {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(tradingIsEnabled || (isExcludedFromFees[from] || isExcludedFromFees[to]), "Trading has not started yet");
 
        bool excludedAccount = isExcludedFromFees[from] || isExcludedFromFees[to];
 
        if(!automatedMarketMakerPairs[to] && tradingIsEnabled && !excludedAccount)
        {
            require(balanceOf(to).add(amount) <= maxWalletBalance, 'Wallet balance is exceeding maxWalletBalance');
        }

        if (tradingIsEnabled &&
            automatedMarketMakerPairs[from] &&
            !excludedAccount)
        {
            require(amount <= maxBuyTransactionAmount, "Transfer amount exceeds the maxTxAmount.");

            dividendFee = _dividendFeeBuy;
            marketingFee = _marketingFeeBuy;
            liquidityFee = _LpFeeBuy;
        } 
        else if (tradingIsEnabled &&
                 automatedMarketMakerPairs[to] &&
                 !excludedAccount)
        {
            require(amount <= maxSellTransactionAmount, "Sell transfer amount exceeds the maxSellTransactionAmount.");

            dividendFee = _dividendFeeSell;
            marketingFee = _marketingFeeSell;
            liquidityFee = _LpFeeSell;
        }

        uint256 contractTokenBalance = balanceOf(address(this));

        bool canSwap = contractTokenBalance >= swapTokensThreshold;

        if (!swapping && canSwap && from != uniswapV2Pair)
        {
            swapping = true;

            //Swap liquidity tokens 
            if(swapAndLiquifyEnabled)
            {
                uint256 liquidityTokens = liquidityTokensInContract;

                swapAndLiquify(liquidityTokens);
                
                //Reset
                liquidityTokensInContract = 0;
            }

            //Swap dividend tokens  
            if (dividendEnabled)
            {
                uint256 dividendTokens = dividendTokensInContract;

                swapAndSendDividends(dividendTokens);
                
                //Reset
                dividendTokensInContract = 0;
            }

             //Swap marketing tokens to dividend tokens (e.g. BITCOIN, BUSD and ETC) and transfer to marketing wallet 
            if (marketingSwapEnabled)
            {
                uint256 marketingTokens = marketingTokensInContract;

                swapAndSendMarketingToken(marketingTokens);

                //Reset
                marketingTokensInContract = 0;
            }

            swapping = false;
        }

        bool takeFee = tradingIsEnabled && !swapping && !excludedAccount;

        if(takeFee)
        {
        	uint256 totlaFees;

            uint256 tmpMarketingTokens;
            uint256 tmpDividendTokens;
            uint256 tmpLiquidityTokens;

            tmpMarketingTokens = amount.mul(marketingFee).div(100);
            tmpDividendTokens = amount.mul(dividendFee).div(100);
            tmpLiquidityTokens = amount.mul(liquidityFee).div(100);

            //Total fees
            totlaFees = tmpMarketingTokens.add(tmpDividendTokens).add(tmpLiquidityTokens);

            dividendTokensInContract = dividendTokensInContract.add(tmpDividendTokens);
            liquidityTokensInContract = liquidityTokensInContract.add(tmpLiquidityTokens);
            marketingTokensInContract = marketingTokensInContract.add(tmpMarketingTokens);

            // if sell, multiply by sell factor
            if(automatedMarketMakerPairs[to])
            {
                totlaFees = totlaFees.div(100).mul(sellFeeIncreaseFactor);
            }
 
        	amount = amount.sub(totlaFees);

            super._transfer(from, address(this), totlaFees);

            //Marketing wallet rx contract tokens?
            if(!marketingSwapEnabled)
            {
                super._transfer(address(this), marketingWallet, marketingTokensInContract);

                marketingTokensInContract = 0;
            }
        }

        //Transfer balance amount (i.e. fees already taken) to user
        super._transfer(from, to, amount);

        try tokenXDividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
        
        try tokenXDividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
        
        if(!swapping)
        {
	    	uint256 gas = gasForProcessing;
 
	    	try tokenXDividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex)
            {
	    		emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, msg.sender);
	    	}
	    	catch 
            {
                //
	    	}
        }
    }

    function swapAndLiquify(uint256 tokenAmount) private 
    {
        uint256 tokenHalf = tokenAmount.div(2);
        uint256 tokenBnbHalf = tokenAmount.sub(tokenHalf);

        // capture the contract's current ETH balance.
        // this is so that we can capture exactly the amount of ETH that the
        // swap creates, and not make the liquidity event include any ETH that
        // has been manually sent to the contract
        uint256 initialBalance = address(this).balance;
 
        swapTokensForBNB(tokenHalf, address(this));

        uint256 bnbAmount = address(this).balance.sub(initialBalance);

        addLiquidity(tokenBnbHalf, bnbAmount);

        //Notify event
        emit SwapAndLiquify(tokenHalf, bnbAmount, tokenBnbHalf);
    }

    function swapTokensForBNB(uint256 tokenAmount, address _recipient) private
    {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
 
        //Allow pancakeswap to spend the contract tokens (defined by contract address)
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        //Execute the swap and send the received swapped tokens to recipient
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            _recipient,
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private
    {
        totalLiquidityBnbFromFees = totalLiquidityBnbFromFees.add(bnbAmount);

        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount);
 
        uniswapV2Router.addLiquidityETH{value: bnbAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            liquidityWallet,
            block.timestamp);
    }

    function swapAndSendMarketingToken(uint256 tokens) private
    {
        swapTokensForDividendToken(tokens, address(this), dividendTokenAddress);

        uint256 marketingTokens = IERC20(dividendTokenAddress).balanceOf(address(this));

        bool success = IERC20(dividendTokenAddress).transfer(marketingWallet, marketingTokens);
    
		require(success, "Failed to send swapped tokens to marketing wallet");
    }

    function swapAndSendDividends(uint256 tokens) private
    {
        swapTokensForDividendToken(tokens, address(this), dividendTokenAddress);
        
        uint256 dividendToken = IERC20(dividendTokenAddress).balanceOf(address(this));

        transferDividends(dividendTokenAddress, address(tokenXDividendTracker), tokenXDividendTracker, dividendToken);
    }

    function swapTokensForDividendToken(uint256 _tokenAmount, address _recipient, address _dividendAddress) private
    {
        address[] memory path = new address[](3);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        path[2] = _dividendAddress;

        //Allow pancakeswap to spend the contract tokens (defined by contract address)
        _approve(address(this), address(uniswapV2Router), _tokenAmount);
 
        // make the swap
        uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            _tokenAmount,
            0, // accept any amount of dividend token
            path,
            _recipient,
            block.timestamp
        );
    }

    function transferToWallet(address payable recipient, uint256 amount) private
    {
        recipient.transfer(amount);
    }
 
    function transferDividends(address pDividendTokenAddress, address pTokenXDividendTracker, DividendPayingToken dividendPayingTracker, uint256 amount) private 
    {
        bool success = IERC20(pDividendTokenAddress).transfer(pTokenXDividendTracker, amount);
 
        if (success)
        {
            dividendPayingTracker.distributeDividends(amount);
            emit SendDividends(amount);
        }
    }
}