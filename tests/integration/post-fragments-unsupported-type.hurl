# Confirm that posting an unsupported Content-Type produces a 415 error

POST http://localhost:8080/v1/fragments
# We're sending an unsupported type (application/pdf)
Content-Type: unknown/unknown
# Include HTTP Basic Auth credentials
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1
# Body of the request
`This is an unsupported fragment!`

# 1. Verify that we get a 415 Unsupported Media Type response
HTTP/1.1 415
[Asserts]
# Check the response status is error
jsonpath "$.status" == "error"
# Check that the error code is 415
jsonpath "$.error.code" == 415
# Check that the error message mentions media type
jsonpath "$.error.message" == "Unsupported Media Type"
