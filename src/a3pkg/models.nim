import times

type
  User* = object
    ## User is the user model
    id*: int
    firstName*: string
    lastName*: string
    email*: string
    password*: string
    createdAt*: DateTime
    updatedAt*: DateTime
    accessLevel*: int

  Products* = object
    ## Product is the product model
    id*: int
    name*: string
    description*: string
    productType*: string
    pageName*: string
    price*: float
    createdAt*: DateTime
    updatedAt*: DateTime
    picURL*: string
    quantity*: int

  Cart* = object
    ## Cart is the cart model
    id*: int
    userId*: int
    productId*: int
    quantity*: int
    createdAt*: DateTime
    updatedAt*: DateTime

  Orders* = object
    ## Orders is the orders model
    id*: int
    userId*: int
    country*: string
    address*: string
    state*: string
    postalCode*: string
    phoneNumber*: string
    productId*: int
    quantity*: int
    createdAt*: DateTime
    updatedAt*: DateTime
    orderStatus*: string
    orderDate*: DateTime