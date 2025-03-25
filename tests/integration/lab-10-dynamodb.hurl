# Step 1: POST a new JSON fragment as authorized user
POST http://localhost:8080/v1/fragments
Content-Type: application/json
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1

`{"service": "DynamoDB"}`

# Step 2: Confirm 201 status and capture location and ID
HTTP/1.1 201
[Captures]
fragment1_url: header "Location"
fragment1_id: jsonpath "$.fragment.id"

# Step 3: GET the fragment info (metadata) using Location URL and verify data
GET {{fragment1_url}}/info
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1

HTTP/1.1 200
[Asserts]
jsonpath "$.status" == "ok"
jsonpath "$.fragment.id" == {{fragment1_id}}
jsonpath "$.fragment.ownerId" isString
jsonpath "$.fragment.created" isString
jsonpath "$.fragment.updated" isString
jsonpath "$.fragment.type" == "application/json"
jsonpath "$.fragment.size" == 23

# Step 4: POST a second Markdown fragment as the same user
POST http://localhost:8080/v1/fragments
Content-Type: text/markdown
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1

`DynamoDB is **great**.`

# Step 5: Confirm 201 status and capture second location and ID
HTTP/1.1 201
[Captures]
fragment2_url: header "Location"
fragment2_id: jsonpath "$.fragment.id"

# Step 6: GET the second fragment info (metadata) and verify data
GET {{fragment2_url}}/info
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1

HTTP/1.1 200
[Asserts]
jsonpath "$.status" == "ok"
jsonpath "$.fragment.id" == {{fragment2_id}}
jsonpath "$.fragment.ownerId" isString
jsonpath "$.fragment.created" isString
jsonpath "$.fragment.updated" isString
jsonpath "$.fragment.type" == "text/markdown"
jsonpath "$.fragment.size" == 22

# Step 7: GET all fragments for the user (IDs only) and verify both fragments exist
GET http://localhost:8080/v1/fragments
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1

HTTP/1.1 200
[Asserts]
jsonpath "$.status" == "ok"
jsonpath "$.fragments" contains {{fragment1_id}}
jsonpath "$.fragments" contains {{fragment2_id}}

# Step 8: DELETE the first fragment
DELETE {{fragment1_url}}
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1

# Step 9: Confirm 200 status for DELETE
HTTP/1.1 200

# Step 10: Try to GET the deleted fragment
GET {{fragment1_url}}
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1

# Step 11: Confirm 404 status since fragment should be deleted
HTTP/1.1 404

# Step 12: GET all fragments again and verify first fragment is gone but second remains
GET http://localhost:8080/v1/fragments
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1

HTTP/1.1 200
[Asserts]
jsonpath "$.status" == "ok"
jsonpath "$.fragments" not contains {{fragment1_id}}
jsonpath "$.fragments" contains {{fragment2_id}}
