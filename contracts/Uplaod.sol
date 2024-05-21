// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract Upload {
  
  struct Access{
     address user; 
     bool access; //true or false
  }

  //mapping with array

  //will store the url of the images 
  mapping(address=>string[]) value;

  //will store the other who is accessing the file
  //will give the access to se the content or not
  mapping(address=>mapping(address=>bool)) ownership;


  mapping(address=>Access[]) accessList;

//will give the info about the previous data
  mapping(address=>mapping(address=>bool)) previousData;



//using this function user can add their url and images and ffiles

  function add(address _user,string memory url) external {
      value[_user].push(url);
  }

  //will give access to user
  function allow(address user) external {//def
      ownership[msg.sender][user]=true; 
      if(previousData[msg.sender][user]){
         for(uint i=0;i<accessList[msg.sender].length;i++){
             if(accessList[msg.sender][i].user==user){
                  accessList[msg.sender][i].access=true; 
             }
         }
      }else{
          accessList[msg.sender].push(Access(user,true));  
          previousData[msg.sender][user]=true;  
      }
    
  }
  function disallow(address user) public{
      ownership[msg.sender][user]=false;
      for(uint i=0;i<accessList[msg.sender].length;i++){
          if(accessList[msg.sender][i].user==user){ 
              accessList[msg.sender][i].access=false;  
          }
      }
  }


//will display the images 
  function display(address _user) external view returns(string[] memory){
      require(_user==msg.sender || ownership[_user][msg.sender],"You don't have access");
      return value[_user];
  }

//will display the list of users which i give accesss to them
  function shareAccess() public view returns(Access[] memory){
      return accessList[msg.sender];
  }
}