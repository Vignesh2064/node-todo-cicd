# Node Base Image
#FROM node:12.2.0-alpine

#Working Directry
#WORKDIR /node

#Copy the Code
#COPY . .

#Install the dependecies
#RUN npm install
#RUN npm run test
#EXPOSE 8000

#Run the code
#CMD ["node","app.js"]
# Node Base Image with Alpine
# Use the latest Node.js Alpine version
FROM node:20-alpine

# Set the working directory in the container
WORKDIR /node

# Copy the project files into the container
COPY . .

# Upgrade npm to the latest version (if you need a specific version, you can specify it here)
RUN npm install -g npm@latest

# Install the dependencies
RUN npm install

# Run the tests (optional step)
RUN npm run test

# Expose the port the app will run on
EXPOSE 8000

# Run the application
CMD ["node", "app.js"]

