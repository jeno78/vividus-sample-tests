Description: Test demoing VIVIDUS capabilities for REST API    How to run:    ./gradlew runStories -Pvividus.configuration.suites=rest_api


Scenario: 1. Get all products
When I execute HTTP GET request for resource with URL `http://localhost:8080/api/products`
Then `${responseCode}` is equal to `200`

!-- GET - Get first product in all products response - success - 200 OK --
Scenario: 2. Verify the first product
When I execute HTTP GET request for resource with URL `http://localhost:8080/api/products`
Then `${responseCode}` is equal to `200`
Then JSON element value from `${response}` by JSON path `$[0].name` is equal to `Gaming Laptop`
Then JSON element value from `${response}` by JSON path `$[0].category` is equal to `Electronics`
Then JSON element value from `${response}` by JSON path `$[0].productId` is equal to `laptop1`
Then JSON element value from `${response}` by JSON path `$[0].price` is equal to `1299.99`
Then JSON element value from `${response}` by JSON path `$[0].stockQuantity` is equal to `10`
Then JSON element value from `${response}` by JSON path `$[0].reservedQuantity` is equal to `10`
Then JSON element value from `${response}` by JSON path `$[0].availableQuantity` is equal to `0`


!-- GET - Verify user details by user ID - success - 200 OK --
Scenario: 3. Verify user details
When I execute HTTP GET request for resource with URL `http://localhost:8080/api/auth/user/user1`
Then `${responseCode}` is equal to `200`
Then JSON element value from `${response}` by JSON path `$.data.userId` is equal to `user1`
Then JSON element value from `${response}` by JSON path `$.data.username` is equal to `john_doe`
Then JSON element value from `${response}` by JSON path `$.data.email` is equal to `john@example.com`
Then JSON element value from `${response}` by JSON path `$.success` is equal to `true`
Then JSON element value from `${response}` by JSON path `$.code` is equal to `SUCCESS`


!-- GET - Verify user not found by user ID - failure - 404 Not Found --
Scenario: 4. Verify user not found
When I execute HTTP GET request for resource with URL `http://localhost:8080/api/auth/user/unknown`
Then `${responseCode}` is equal to `404`
Then JSON element value from `${response}` by JSON path `$.message` is equal to `User not found`
Then JSON element value from `${response}` by JSON path `$.success` is equal to `false`
Then JSON element value from `${response}` by JSON path `$.code` is equal to `USER_NOT_FOUND`


!-- GET - Verify shopping cart is empty for user - success - 200 OK --
Scenario: 5. Verify shopping cart is empty
When I execute HTTP GET request for resource with URL `http://localhost:8080/api/cart/user1`
Then `${responseCode}` is equal to `200`
Then JSON element value from `${response}` by JSON path `$.data.userId` is equal to `user1`
!-- Then JSON element from `${response}` by JSON path `$.data.items` is an empty array --



!-- POST - Verify login functionality - success - 200 OK --
Scenario: 6. Verify login functionality
When I set request headers:
|name        |value           |
|Content-Type|application/json|
Given request body: {
  "username": "john_doe",
  "password": "password123"
}
When I execute HTTP POST request for resource with URL `http://localhost:8080/api/auth/login`
Then `${responseCode}` is equal to `200`
Then JSON element value from `${response}` by JSON path `$.data.username` is equal to `john_doe`
Then JSON element value from `${response}` by JSON path `$.data.email` is equal to `john@example.com`
Then JSON element value from `${response}` by JSON path `$.data.userId` is equal to `user1`


!-- POST - Verify login failure with incorrect password - failure - 401 Unauthorized --
Scenario: 7. Verify login failure with incorrect password
When I set request headers:
|name        |value           |
|Content-Type|application/json|
Given request body: {
  "username": "john_doe",
  "password": "password12345"
}
When I execute HTTP POST request for resource with URL `http://localhost:8080/api/auth/login`
Then `${responseCode}` is equal to `401`
Then JSON element value from `${response}` by JSON path `$.code` is equal to `LOGIN_FAILED`
Then JSON element value from `${response}` by JSON path `$.message` is equal to `Invalid credentials provided`


!-- POST - Verify login failure with malformed JSON - failure - 400 Bad Request --
Scenario: 8. Verify login failure with malformed JSON
When I set request headers:
|name        |value           |
|Content-Type|application/json|
Given request body: {
  "username": "john_doe",
  "password": "password12345",,,,,,,
}
When I execute HTTP POST request for resource with URL `http://localhost:8080/api/auth/login`
Then `${responseCode}` is equal to `400`


!-- GET - Verify specific product in shopping cart - success - 200 OK Empty cart--
Scenario: 9. Verify specific product in shopping cart
When I execute HTTP GET request for resource with URL `http://localhost:8080/api/cart/user1`
Then `${responseCode}` is equal to `200`


!-- POST - Add item to shopping cart - success - 200 OK --
Scenario: 10. Add item to shopping cart
When I set request headers:
|name        |value           |
|Content-Type|application/json|
Given request body: {
  "productId": "mouse1",
  "quantity": 2
}
When I execute HTTP POST request for resource with URL `http://localhost:8080/api/cart/user1/items`
Then `${responseCode}` is equal to `200`
Then JSON element value from `${response}` by JSON path `$.code` is equal to `SUCCESS`


!-- POST - Add item to shopping cart with empty productId - failure - 404 Not Found --
Scenario: 11. Add item to shopping cart with empty productId
When I set request headers:
|name        |value           |
|Content-Type|application/json|
Given request body: {
  "productId": "",
  "quantity": 2
}
When I execute HTTP POST request for resource with URL `http://localhost:8080/api/cart/user1/items`
Then `${responseCode}` is equal to `404`
Then JSON element value from `${response}` by JSON path `$.code` is equal to `PRODUCT_NOT_FOUND`


!-- POST - Add item to shopping cart with malformed productId - failure - 404 Not found--
Scenario: 12. Add item to shopping cart with malformed productId
When I set request headers:
|name        |value           |
|Content-Type|application/json|
Given request body: {
  "productId": "laptop1@@@@@@",
  "quantity": 2
}
When I execute HTTP POST request for resource with URL `http://localhost:8080/api/cart/user1/items`
Then `${responseCode}` is equal to `404`
Then JSON element value from `${response}` by JSON path `$.code` is equal to `PRODUCT_NOT_FOUND`


!-- POST - Create order with empty userId - failure - 400 Bad Request --
Scenario: 13. Create order with empty userId
When I set request headers:
|name        |value           |
|Content-Type|application/json|
Given request body: {
  "userId: ""
}
When I execute HTTP POST request for resource with URL `http://localhost:8080/api/orders`
Then `${responseCode}` is equal to `400`
Then JSON element value from `${response}` by JSON path `$.error` is equal to `Bad Request`


!-- PUT - Update item quantity with invalid value - failure - 400 Bad Request --
Scenario: 14. Update item quantity with invalid value
When I set request headers:
|name        |value           |
|Content-Type|application/json|
Given request body: {
  "quantity": -5
}
When I execute HTTP PUT request for resource with URL `http://localhost:8080/api/cart/user1/items/85dafa1a-6311-4fa3-bb06-4548fc233715`
Then `${responseCode}` is equal to `400`
Then JSON element value from `${response}` by JSON path `$.code` is equal to `INVALID_QUANTITY`





!--  E2E test --
!-- POST - Verify login functionality - success - 200 OK --
Scenario: 15. Verify login functionality
When I set request headers:
|name        |value           |
|Content-Type|application/json|
Given request body: {
  "username": "john_doe",
  "password": "password123"
}
When I execute HTTP POST request for resource with URL `http://localhost:8080/api/auth/login`
Then `${responseCode}` is equal to `200`
Then JSON element value from `${response}` by JSON path `$.data.username` is equal to `john_doe`
Then JSON element value from `${response}` by JSON path `$.data.email` is equal to `john@example.com`
Then JSON element value from `${response}` by JSON path `$.data.userId` is equal to `user1`

!-- POST - Add item to shopping cart - success - 200 OK --
Scenario: 16. Add item to shopping cart
When I set request headers:
|name        |value           |
|Content-Type|application/json|
Given request body: {
  "productId": "mouse1",
  "quantity": 2
}
When I execute HTTP POST request for resource with URL `http://localhost:8080/api/cart/user1/items`
Then `${responseCode}` is equal to `200`
Then JSON element value from `${response}` by JSON path `$.code` is equal to `SUCCESS`
When I save JSON element from `${response}` by JSON path `$.data.itemId` to story variable `itemId`


!-- GET - Verify specific product in shopping cart - success - 200 OK-
Scenario: 17. Verify specific product in shopping cart
When I execute HTTP GET request for resource with URL `http://localhost:8080/api/cart/user1`
Then `${responseCode}` is equal to `200`
When I save JSON element from `${response}` by JSON path `$.data.items[*].itemId` to story variable `itemIds`
When I save JSON element from `${response}` by JSON path `$` to story variable `myresponse`
Then `${myresponse}` matches `.*${itemId}.*`



!-- DELETE - Delete item from cart - success - 200 OK --
Scenario: 18. Delete item from cart
When I set request headers:
|name        |value           |
|Content-Type|application/json|
When I execute HTTP DELETE request for resource with URL `http://localhost:8080/api/cart/user1/items/#{removeWrappingDoubleQuotes(${itemId})}`
Then `${responseCode}` is equal to `200`


!-- POST - Add item to shopping cart - success - 200 OK --
Scenario: 19. Add item to shopping cart
When I set request headers:
|name        |value           |
|Content-Type|application/json|
Given request body: {
  "productId": "mouse1",
  "quantity": 2
}
When I execute HTTP POST request for resource with URL `http://localhost:8080/api/cart/user1/items`
Then `${responseCode}` is equal to `200`
Then JSON element value from `${response}` by JSON path `$.code` is equal to `SUCCESS`
When I save JSON element from `${response}` by JSON path `$.data.itemId` to story variable `itemId2`


!-- PUT - Update item quantity with valid value success - 200 OK --
Scenario: 20. Update item quantity with valid value
When I set request headers:
|name        |value           |
|Content-Type|application/json|
Given request body: {
  "quantity": 3
}
When I execute HTTP PUT request for resource with URL `http://localhost:8080/api/cart/user1/items/#{removeWrappingDoubleQuotes(${itemId2})}`
Then `${responseCode}` is equal to `200`
Then JSON element value from `${response}` by JSON path `$.data.newQuantity` is equal to `3`


!-- GET - Verify specific product in shopping cart - success - 200 OK-
Scenario: 21. Verify specific product in shopping cart
When I execute HTTP GET request for resource with URL `http://localhost:8080/api/cart/user1`
Then `${responseCode}` is equal to `200`
When I save JSON element from `${response}` by JSON path `$.data.items[*].itemId` to story variable `itemIds2`
When I save JSON element from `${response}` by JSON path `$` to story variable `myresponse2`
Then `${myresponse2}` matches `.*${itemId2}.*`


!-- PUT - Reserve inventory - success - 200 OK --
Scenario: 22. Reserve inventory
When I set request headers:
|name        |value           |
|Content-Type|application/json|
Given request body: {
  "quantity": 3
}
When I execute HTTP PUT request for resource with URL `http://localhost:8080/api/inventory/mouse1/reserve`
Then `${responseCode}` is equal to `200`


!-- POST - Make an order - success - 200 OK --
Scenario: 23. Make an order
When I set request headers:
|name        |value           |
|Content-Type|application/json|
Given request body: {
  "userId": "user1"
}
When I execute HTTP POST request for resource with URL `http://localhost:8080/api/orders`
Then `${responseCode}` is equal to `200`
