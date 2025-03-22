# Confirm that posting a fragment when not authenticated produces a 401 error

POST http://localhost:8080/v1/fragments
# We're sending a plain text fragment but not including authentication
Content-Type: text/plain
# Body of the request
`This is an unauthenticated request!`

# 1. Verify that we get a 401 Unauthorized response
HTTP/1.1 401
[Asserts]
# Check the response status is error
jsonpath "$.status" == "error"
# Check that the error code is 401
jsonpath "$.error.code" == 401
# Check that the error message mentions authorization/authentication
jsonpath "$.error.message" == "Unauthorized"
