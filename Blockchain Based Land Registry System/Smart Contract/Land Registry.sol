// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.0 <0.9.0;

contract LandRegistration {

    address public LandInspector=msg.sender;

    modifier OnlyLandInspector() {
        
    require (LandInspector==msg.sender,
        "Only landinspector is authorized to perform this action");
        _;
    }
    
    struct LandRegistry{   
        
        address payable OwnerAddress;
        uint Area; 
        string City; 
        string State; 
        uint LandPrice; 
        uint PropertyPID;
        bool IsLandVerified;
    
    }

    struct BuyerDetails{
        
        address BuyerAddress;
        string Name;
        uint Age; 
        string City; 
        string CNIC; 
        string Email;
        bool IsBuyerVerified;
        
    }
    
    struct SellerDetails{

        address SellerAddress;
        string Name;
        uint Age; 
        string City; 
        string CNIC; 
        string Email;
        bool IsSellerVerified;
    
    }

    struct LandInspectorDetails{ 

        string Name;
        uint Age;
        string Designation; 
    
    } 

    mapping(uint => LandRegistry) public LandMapping; 
    mapping(uint => LandInspectorDetails) public InspectorMapping; 
    mapping(address => SellerDetails) public SellerMapping;
    mapping(address => BuyerDetails) public BuyerMapping; 


    event SellerRegistration(
        address _SellerRegistered,
        string Name, 
        uint Age,
        string City,
        string CNIC,
        string Email);
    
    event BuyerRegistration(
        address _BuyerRegistered,
        string Name, 
        uint Age,
        string City,
        string CNIC,
        string Email);
    
    event Verified(address _Id);
    
    event Rejected(address _Id);

    /*

    /////////////////// Register Seller ///////////////
    /////// Seller will register with his details
    /////// LandInspector can either verify that seller or reject that seller
    /////// We can also update the seller details
    /////// We can check if seller is verified or not


    */    
    function RegisterSeller(

        address SellerAddress,
        string memory Name, 
        uint Age,
        string memory City,
        string memory CNIC,
        string memory Email)  
        external
    {
    require(LandInspector != msg.sender,
        "Seller address cannot be same as LandInspector address");

    require(SellerAddress==msg.sender,
        "This address is already registered as another Seller or Buyer");
           
        SellerMapping[SellerAddress]=SellerDetails(
        msg.sender,
        Name,
        Age,
        City, 
        CNIC, 
        Email,
        false);
     
    emit SellerRegistration(
        msg.sender,
        Name, 
        Age,
        City,
        CNIC,
        Email);

    }

    function GetSellerDetails(address SellerAddress) 
        
        public view returns(
        string memory, 
        uint,
        string memory,
        string memory,
        string memory) 
    { 
        return(

        SellerMapping[SellerAddress].Name,
        SellerMapping[SellerAddress].Age,
        SellerMapping[SellerAddress].City,
        SellerMapping[SellerAddress].CNIC,
        SellerMapping[SellerAddress].Email);
        
    }

    function UpdateSellerDetails(

        address SellerAddress, 
        string memory _Name, 
        uint _Age, 
        string memory _City, 
        string memory _CNIC, 
        string memory _Email) external 
    {
    require(LandInspector!=msg.sender,
        "Only seller can update his data");
    
    require(SellerAddress==msg.sender,
        "This address is already registered as another Seller or Buyer");
   
        SellerMapping[SellerAddress].Name = _Name;
        SellerMapping[SellerAddress].Age = _Age;
        SellerMapping[SellerAddress].City = _City;
        SellerMapping[SellerAddress].CNIC = _CNIC;
        SellerMapping[SellerAddress].Email = _Email;

    }

    function IsSellerVerified(address SetSellerAddress) 
        public view returns(bool)
    {
        return 
        SellerMapping[SetSellerAddress].IsSellerVerified;
    }

    function VerifySeller(address _SellerAddress)
        public OnlyLandInspector 
    {
        SellerMapping[_SellerAddress].IsSellerVerified=true;
        
    emit Verified(_SellerAddress);
    
    }

    function RejectSeller(address _SellerAddress) 
        public OnlyLandInspector 
    {
        SellerMapping[_SellerAddress].IsSellerVerified=false;
    
    emit Rejected(_SellerAddress);
    
    }

    /*

    /////////////////// Register Buyer ////////////////
    //////// we will register Buyer with Buyer details
    //////// If Buyer is registered then landInpector either verify that Buyer 
    //////// or reject that buyer
    //////// We can also update the Buyer details 
    //////// We can check if Buyer is verified or not
    
    
    */  
    
   function RegisterBuyer(

        address BuyerAddress,
        string memory Name,
        uint Age,
        string memory City,
        string memory CNIC,
        string memory Email) 
        external 
    {
    require(LandInspector!=msg.sender,
        "Buyer address cannot be same as landinspector address");
    
    require(BuyerAddress==msg.sender,
        "This address is already registered");
    
        BuyerMapping[BuyerAddress]=BuyerDetails(
        msg.sender,
        Name,
        Age,
        City, 
        CNIC,
        Email,
        false);

    emit BuyerRegistration(
        msg.sender,
        Name, 
        Age,
        City,
        CNIC,
        Email);
        
    }

    function GetBuyerDetails(address BuyerAddress)
        
        external view returns(
        string memory, 
        uint,
        string memory,
        string memory,
        string memory) 
    { 
        return(
        BuyerMapping[BuyerAddress].Name,
        BuyerMapping[BuyerAddress].Age,
        BuyerMapping[BuyerAddress].City,
        BuyerMapping[BuyerAddress].CNIC,
        BuyerMapping[BuyerAddress].Email);

    }

    function UpdateBuyerDetails(
        
        address BuyerAddress, 
        string memory _Name, 
        uint _Age, 
        string memory _City, 
        string memory _CNIC, 
        string memory _Email) 
        external 
    {
    require(LandInspector!=msg.sender,
        "LandInspector is not allowned, Only Buyer can update his data");
    
    require(BuyerAddress==msg.sender,
        "This address is already registered as seller or buyer");

        BuyerMapping[BuyerAddress].Name = _Name;
        BuyerMapping[BuyerAddress].Age = _Age;
        BuyerMapping[BuyerAddress].City = _City;
        BuyerMapping[BuyerAddress].CNIC = _CNIC;
        BuyerMapping[BuyerAddress].Email = _Email;

    }

    function IsBuyerVerified(address SetBuyerAddress) 
        public view  returns(bool)
    {
        return 
        BuyerMapping[SetBuyerAddress].IsBuyerVerified;
    
    }
    
    function VerifyBuyer(address _BuyerAddress) 
        public OnlyLandInspector
    {
        BuyerMapping[_BuyerAddress].IsBuyerVerified=true;
        
    emit Verified(_BuyerAddress);
    
    }

    function RejectBuyer(address _BuyerAddress)
        public OnlyLandInspector 
    {
        BuyerMapping[_BuyerAddress].IsBuyerVerified=false;
        
    emit Rejected(_BuyerAddress);
    
    }
    
    /*
     
    ///////////////// Register LandInspector /////////////////
    ///////// we can get landinspector details
    ///////// we can check who is land inspector

    */
    
    function RegisterLandInspector(
       
        uint ID,
        string memory Name,
        uint Age,
        string memory Designation) 
        external
        OnlyLandInspector 
    {   
        InspectorMapping[ID]=LandInspectorDetails( 
        Name, 
        Age, 
        Designation);

    }

    function GetInspectorDetails(uint ID) 
        public view returns(
        string memory, 
        uint,
        string memory)
    {
        return(
        InspectorMapping[ID].Name,
        InspectorMapping[ID].Age,
        InspectorMapping[ID].Designation);

    }

    /*
     
    ///////////////////////// Add Land Details //////////////////
    /////// If seller is verified then seller upload land details
    /////// if seller is not verified by LandInspector they cannot add the land details.  
    /////// LandInspector will also verify the land added by seller by landID 
    /////// We can get land details by landID
    /////// We can check who is the owner of this land by landID 
    //////// We can check who is the current owner of this land. 
    
    */
     
    function RegisterLand(
        
        uint LandId,
        address payable OwnerAddress,
        uint Area,
        string memory City,
        string memory State,
        uint LandPrice,
        uint PropertyPID) 
        external  
    {
    require(IsSellerVerified(msg.sender),
        "Seller must be verified");
        
    require(OwnerAddress==msg.sender,
        "Seller adress must be the OwnerAdress");
    
    require(LandInspector!=OwnerAddress,
        "This adress is registered as landinspector address");
    
        LandMapping[LandId]= LandRegistry( 
        OwnerAddress, 
        Area, 
        City, 
        State, 
        LandPrice, 
        PropertyPID, 
        false);

    }

    function GetLandDetails(uint landId) 
        
        public view returns(
        address,
        uint,
        string memory, 
        string memory,
        uint,
        uint)
    {
        return(

        LandMapping[landId].OwnerAddress,
        LandMapping[landId].Area,
        LandMapping[landId].City,
        LandMapping[landId].State,
        LandMapping[landId].LandPrice,
        LandMapping[landId].PropertyPID);
    
    }
   
    function IsLandVerified(uint LandId)
        public view  returns(bool)
    {
        return 
        LandMapping[LandId].IsLandVerified;

    }

    function VerifyLand(uint LandId) 
        public OnlyLandInspector
    {
        LandMapping[LandId].IsLandVerified=true;
    
    }

    function GetLandCity(uint  _GetLandCity)
        public view returns(
        string memory)
    {
        return 
        LandMapping[_GetLandCity].City;

    }

    function GetLandPrice(uint  _GetLandPrice) 
        public view returns(uint)
    {
        return 
        LandMapping[_GetLandPrice].LandPrice;

    }

    function GetLandArea(uint  _GetLandArea)
        public view returns(uint)
    {
        return 
        LandMapping[_GetLandArea].Area;

    }

    function CurrentLandOwner(uint LandId)
        public view returns(
        address)
    {
        return 
        LandMapping[LandId].OwnerAddress;
    
    }

    /*

    ////////////////////////////////// Buy Land //////////////////////
    //////// Buyer can buy the land only if buyer and land both is verified
    //////// buyer need to give the  amount and landid that they wants to buy 
    
    */

    function BuyLand(
         
        uint LandId) 
        public payable 
    {
    require(LandMapping[LandId].IsLandVerified=true, 
        "Land is not verified by landInspector");

    require(BuyerMapping[msg.sender].BuyerAddress == msg.sender,
        "Only buyer is allowed to buy land");
    
    require(IsBuyerVerified(msg.sender)==true, 
        "Buyer is not verified");

    require(msg.value == LandMapping[LandId].LandPrice,
        " Not enough ether, it must be equal to LandPrice ");
    
        LandMapping[LandId].OwnerAddress.transfer(msg.value);

    }

    /*
    
    ////////////////////// TransferOwnership /////////////////////
    //////// Owenrship will change to current owner to newOnwer.
    //////// Owner of the land can transfer their land to any address if 
    //////// the is land is verified by  LandInspector 

    */
    
    function TransferOwnerShip(
        
        uint LandId, 
        address payable NewOwnerAddress) 
        public 
    {
    
    require(LandMapping[LandId].IsLandVerified=true,
        "Land must be verified by landinspector");
   
    require(LandMapping[LandId].OwnerAddress == msg.sender,
        "YOU ARE NOT THE OWNER OF THIS PROPERTY");
   
    require(LandMapping[LandId].OwnerAddress != NewOwnerAddress,
        "NewOwner address must be unique"); 
   
        LandMapping[LandId].OwnerAddress=NewOwnerAddress;
    }

    /*
    ////////////// Check buyer and seller account balance to 
    ////////////// confirm transaction
    */
    
    function ShowBalance(
        
        address _address) 
        external view returns(uint)
    {
        return address(_address).balance;
    }
}
