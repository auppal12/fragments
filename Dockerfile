# Stage 1: Build Stage
FROM node:22@sha256:cfef4432ab2901fd6ab2cb05b177d3c6f8a7f48cb22ad9d7ae28bb6aa5f8b471 AS builder

LABEL maintainer="Amitoj Uppal <auppal12@myseneca.ca>" \
      description="Fragments node.js microservice"

# We default to use port 8080 in our service
# Reduce npm spam when installing within Docker
# Disable color when run inside Docker
ENV PORT=8080 \
    NPM_CONFIG_LOGLEVEL=warn \
    NPM_CONFIG_COLOR=false \
    NODE_ENV=production

# Use /app as our working directory
WORKDIR /app

#Copy all files starting with package name and .json type
COPY package*.json ./

# Install node dependencies defined in package-lock.json (production only)
RUN npm ci --only=production

# Copy src to /app/src/
COPY ./src ./src

# Copy our HTPASSWD file
COPY ./tests/.htpasswd ./tests/.htpasswd





#--------------------------------------------------------------



# Stage 2: Production Stage
FROM node:22@sha256:cfef4432ab2901fd6ab2cb05b177d3c6f8a7f48cb22ad9d7ae28bb6aa5f8b471

# Use /app as our working directory
WORKDIR /app

# Copy built files from builder stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/src ./src
COPY --from=builder /app/tests/.htpasswd ./tests/.htpasswd

# Start the container by running our server
CMD ["npm", "start"]

# We run our service on port 8080
EXPOSE 8080
