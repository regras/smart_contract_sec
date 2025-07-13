
        // SPDX-License-Identifier: MIT
        pragma solidity ^0.8.29;

        contract NeuronFlux {
            string public name;
            string public symbol;
            uint8 public constant decimals = 18;
            uint256 public totalSupply;
            uint256 private var_pXIoSP;

            mapping(address => uint256) public balanceOf;
            mapping(address => mapping(address => uint256)) public allowance;

            event Transfer(address indexed from, address indexed to, uint256 value);
            event Approval(address indexed owner, address indexed spender, uint256 value);

            constructor() {
                name = "NeuronFlux";
                symbol = "NRFLX";
                totalSupply = 31000000000 * 10 ** uint256(decimals);
                balanceOf[msg.sender] = totalSupply;
                emit Transfer(address(0), msg.sender, totalSupply);
                var_pXIoSP = block.timestamp % 1000;
            }


            function transfer(address _to, uint256 _value) external returns (bool) {
                require(balanceOf[msg.sender] >= _value, "ERC20: transfer amount exceeds balance");
                balanceOf[msg.sender] -= _value;
                balanceOf[_to] += _value;
                emit Transfer(msg.sender, _to, _value);
                return true;
            }

            function update_var_pXIoSP(uint256 newValue) public {
                var_pXIoSP = newValue;
            }

            function approve(address _spender, uint256 _value) external returns (bool) {
                allowance[msg.sender][_spender] = _value;
                emit Approval(msg.sender, _spender, _value);
                return true;
            }

            function get_var_pXIoSP() public view returns (uint256) {
                return var_pXIoSP;
            }

            function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
                require(balanceOf[_from] >= _value, "ERC20: transfer amount exceeds balance");
                require(allowance[_from][msg.sender] >= _value, "ERC20: transfer amount exceeds allowance");

                balanceOf[_from] -= _value;
                balanceOf[_to] += _value;
                allowance[_from][msg.sender] -= _value;
                emit Transfer(_from, _to, _value);
                return true;
            }

            
    uint256 private var_AHGHgd;

    function add_umnfm(uint256 newValue) public {
        var_AHGHgd = newValue;
    }

    function get_add_umnfm() public view returns (uint256) {
        return var_AHGHgd;
    }
    
        }
        