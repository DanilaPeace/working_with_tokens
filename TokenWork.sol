pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract TokenWork {

    struct CarToken {
        string modelName;
        string color;
        uint128 weight;    
        uint16 horsePower; 
        uint price;
    }

    mapping(string => uint) tokenToOwner;
    mapping (string => CarToken) tokenStorage;
    
    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        _;
    }

    modifier checkRealOwner(string tokenName) {
        require(tokenToOwner[tokenName] == msg.pubkey(), 1002, "You aren't owner this token");
        tvm.accept();
        _;
    }

    function tokenInStorage(string tokenName) internal returns(bool){
        // Ckeck whether token exists with this name
        return tokenStorage.exists(tokenName);
    }

    constructor() public checkOwnerAndAccept{
        require(tvm.pubkey() != 0, 101);
        tvm.accept();
    }

    function createToken(
        string tokenName,
        string color,
        uint128 weight,    
        uint16 horsePower
        ) 
        public checkOwnerAndAccept{
            // Ckeck whether token exists with this name
            require(!tokenInStorage(tokenName), 1001, "Such token is already exist!");
            tokenToOwner[tokenName] = msg.pubkey();
            tokenStorage[tokenName] = CarToken(tokenName, color, weight, horsePower, 0);
    }

    function setPrice(string tokenName, uint tokenPrice) public checkRealOwner(tokenName) {
        require(tokenInStorage(tokenName), 1001, "Such token isn't exist yet!");
        tokenStorage[tokenName].price = tokenPrice; 
    }
}
