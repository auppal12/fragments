# Test image format conversions
# 1. Create a PNG image fragment first (using a small 1x1 transparent PNG)
POST http://localhost:8080/v1/fragments
Content-Type: image/png
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1
# Minimal 1x1 transparent PNG (base64 encoded)
base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=;

# Store the Fragment's ID
HTTP/1.1 201
[Captures]
png_id: jsonpath "$.fragment.id"

# 2. Convert PNG to JPEG
GET http://localhost:8080/v1/fragments/{{png_id}}.jpg
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1

HTTP/1.1 200
Content-Type: image/jpeg

# 3. Convert PNG to WebP
GET http://localhost:8080/v1/fragments/{{png_id}}.webp
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1

HTTP/1.1 200
Content-Type: image/webp

# 4. Convert PNG to GIF
GET http://localhost:8080/v1/fragments/{{png_id}}.gif
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1
HTTP/1.1 200
Content-Type: image/gif

# 5. Create a JPEG image fragment (using a small 1x1 black JPEG)
POST http://localhost:8080/v1/fragments
Content-Type: image/jpeg
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1
# Minimal 1x1 black JPEG (base64 encoded)
base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAP//////////////////////////////////////////////////////////////////////////////////////wAALCAABAAEBAREA/8QAJgABAAAAAAAAAAAAAAAAAAAAAxABAAAAAAAAAAAAAAAAAAAAAP/aAAgBAQAAPwBH/9k=;

# Store the Fragment's ID
HTTP/1.1 201
[Captures]
jpeg_id: jsonpath "$.fragment.id"

# 6. Convert JPEG to PNG
GET http://localhost:8080/v1/fragments/{{jpeg_id}}.png
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1
HTTP/1.1 200
Content-Type: image/png

# 7. Try an unsupported conversion (image to text)
GET http://localhost:8080/v1/fragments/{{png_id}}.txt
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1

HTTP/1.1 415
[Asserts]
jsonpath "$.status" == "error"
jsonpath "$.error.message" contains "not supported"

# 8. Update PNG image with valid PNG data
PUT http://localhost:8080/v1/fragments/{{png_id}}
Content-Type: image/png
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1
# Another minimal PNG (base64 encoded) - slightly different from the first one
base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==;

HTTP/1.1 200
[Asserts]
jsonpath "$.status" == "ok"
jsonpath "$.fragment.id" == "{{png_id}}"
jsonpath "$.fragment.type" == "image/png"

# 9. Try to update PNG image with JPEG data (should fail)
PUT http://localhost:8080/v1/fragments/{{png_id}}
Content-Type: image/jpeg
[BasicAuth]
amitoj_1@gmail.com:testuserpassword1
# Minimal JPEG (base64 encoded)
base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAP//////////////////////////////////////////////////////////////////////////////////////wAALCAABAAEBAREA/8QAJgABAAAAAAAAAAAAAAAAAAAAAxABAAAAAAAAAAAAAAAAAAAAAP/aAAgBAQAAPwBH/9k=;

HTTP/1.1 400
[Asserts]
jsonpath "$.status" == "error"
jsonpath "$.error.message" contains "Content type cannot be changed"
