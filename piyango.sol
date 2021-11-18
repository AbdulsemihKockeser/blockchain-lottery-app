pragma solidity ^0.8.4;

contract piyango {
    
    address public manager;
    address payable[] public players;
    
    constructor() public {
        
        manager= msg.sender;
        
    }
    modifier onlyManager(){
        require(msg.sender== manager,"Only manager can call this function");
        _;
    }
    
// Events

event playerInvested(address player, uint amount);
event winnerSelected(address winner, uint amount);

// Invest money

function invest() payable public {
    
    require(msg.sender!=manager, "manager cannot invest");   // kullanıcı bu piyangoya katılamaz
    
    //limit
    
    require (msg.value>=0.1 ether,"Invest minimum od 0.1 ether");  // veya msg.value==3 ether diyebiliriz.
    players.push(payable(msg.sender));
    emit playerInvested(msg.sender, msg.value);
    
   }

  function getBalance() public view onlyManager returns(uint){
      return address(this).balance;
  }
  
  function random () private view returns(uint) {
      return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, players.length)));
      
  }
   function selectWinner() public onlyManager {
       
       uint r=random();
       uint index= r%players.length;
       address payable winner= players[index];
       emit  winnerSelected(winner, address(this).balance);
       winner.transfer(address(this).balance);
       players= new address payable[](0);
   }  


}