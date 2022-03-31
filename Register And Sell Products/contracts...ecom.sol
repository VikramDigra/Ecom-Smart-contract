// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Ecommerse {
 
 struct Product{
     string name;
     string desc;
     address payable seller;
     uint productId;
     uint price;
     address buyer;
     bool delivered;
 }
 uint counter=1;
 Product[] public products;
address payable manager;
bool destroyed=false;
modifier isNotDestroyed{
    require(!destroyed,"Contract is destroyed");
    _;
}

constructor(){
    manager = payable(msg.sender);
}

  

  
  event registered(string tittle , uint productId, address seller);
  event bought (uint productId, address buyer);
  event deliver(uint productId);

 function registerProduct(string memory _name, string memory _desc, uint _price ) isNotDestroyed public{
  require(_price>0,"Price should me more than zero");
  Product memory tempProduct ;
  tempProduct.name = _name;
  tempProduct.desc = _desc;
  tempProduct.price = _price * 10**18;
  tempProduct.seller = payable(msg.sender);
  tempProduct.productId= counter;
  products.push(tempProduct);
  counter++;
  emit registered(_name,tempProduct.productId,msg.sender);
  }

  function buy(uint _productId) payable public isNotDestroyed{
      require(products[_productId-1].price ==msg.value,"Please pay the exact price");
      require(products[_productId-1].seller!=msg.sender,"Seller cannot buy");
      products[_productId-1].buyer = msg.sender;
      emit bought (_productId,msg.sender);
  }

  function delivery(uint _productId) public isNotDestroyed{
      require(products[_productId-1].buyer == msg.sender,"Only buyer can confirm this");
      products[_productId-1].delivered = true;
      products[_productId-1].seller.transfer(products[_productId-1].price);
      emit deliver(_productId);

  }
  function destroy() isNotDestroyed public{
      require(manager == msg.sender);
      manager.transfer(address(this).balance);
      destroyed=true;
  }

  fallback() payable external {
      payable(msg.sender).transfer(msg.value);
  }
  

}