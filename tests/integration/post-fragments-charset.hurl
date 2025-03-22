# Confirm that posting a fragment Content-Type that includes a charset (e.g., text/plain; charset=utf-8) works, and is returned as the fragment's type when doing a GET

POST http://localhost:8080/v1/fragments
# We're sending a plain text fragment with charset
Content-Type: text/plain; charset=utf-8
# Include HTTP Basic Auth credentials
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1
# Body of the request
`This is a fragment with charset!`

# 1. Verify successful creation
HTTP/1.1 201
[Asserts]
# Check the response status
jsonpath "$.status" == "ok"
# Check the fragment type includes the charset
jsonpath "$.fragment.type" == "text/plain; charset=utf-8"
# Capture the Location URL
[Captures]
fragment_url: header "Location"

# 2. Get the created fragment
GET {{fragment_url}}
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1

# 3. Verify the Content-Type header in the response includes the charset
HTTP/1.1 200
[Asserts]
header "Content-Type" == "text/plain; charset=utf-8"
body == "This is a fragment with charset!"
