pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract CarToken {
    // Struct for storing the token unformation
    struct CarTokenInfo {
        string modelName;
        string color;
        uint128 weight;    
        uint16 horsePower; 
        uint price;
        // Here information about token owner is stored
        uint ownerAddress;
    }

    // State variable for storing the name and whole information about the token 
    mapping (string => CarTokenInfo) m_tokenStorage;
    
    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        _;
    }

    modifier checkRealOwner(string tokenName) {
        // Check owner address of token with address of person called function
        require(m_tokenStorage[tokenName].ownerAddress == msg.pubkey(), 1002, "You aren't owner this token");
        tvm.accept();
        _;
    }

    function tokenInStorage(string tokenName) internal returns(bool){
        // Ckeck whether token exists with this name
        return m_tokenStorage.exists(tokenName);
    }

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    // Function to create token
    function createToken(
        string tokenName,
        string color,
        uint128 weight,    
        uint16 horsePower
        ) 
        public checkOwnerAndAccept{
            // Ckeck whether token exists with this name
            require(!tokenInStorage(tokenName), 1001, "Such token already exist!");
            m_tokenStorage[tokenName] = CarTokenInfo(tokenName, color, weight, horsePower, 0, msg.pubkey());
    }

    // Function to set token price
    function setPrice(string tokenName, uint tokenPrice) public checkRealOwner(tokenName) {
        // This action can only do owner of this token. 
        require(tokenInStorage(tokenName), 1001, "Such token doesn't exist!");
        m_tokenStorage[tokenName].price = tokenPrice; 
    }
}
