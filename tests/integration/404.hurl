# route does not exist Test
GET http://localhost:8080/no-such-route

# We should get back an HTTP 1.1 404 response
HTTP/1.1 404

# Extra checks to perform against the response
[Asserts]
jsonpath "$.status" == "error"
jsonpath "$.error.message" == "not found"
jsonpath "$.error.code" == 404
