# Use the official Python image as the base image
FROM python:3.9-slim

# Install necessary packages
RUN apt-get update && apt-get install -y git ssh nginx && apt-get clean

# Set the working directory for the application
WORKDIR /app

# Copy the server's SSH private key into the container (using build arguments for security)
ARG SSH_PRIVATE_KEY
RUN mkdir -p /root/.ssh/ && \
    echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa

# Disable strict host key checking (for simplicity, but consider the security implications)
RUN echo "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

# Clone the private GitHub repository
RUN git clone git@github.com:PeterTSmith1997/YWS-data.git .

# Set the working directory to the cloned repository
WORKDIR /app/YWS-data

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Remove the default Nginx configuration
RUN rm /etc/nginx/sites-enabled/default

# Copy your custom Nginx configuration file to the container
COPY nginx.conf /etc/nginx/sites-available/nginx.conf
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

# Copy SSL certificates from the repository or local directory into the container
# Adjust the paths according to where your SSL files are located
COPY path/to/your/ssl/cert.crt /etc/nginx/ssl/yourwebshield.crt
COPY path/to/your/ssl/key.key /etc/nginx/ssl/yourwebshield.key

# Expose port 80 and 443
EXPOSE 80
EXPOSE 443

# Start the Python application and Nginx
CMD service nginx start && python app.py
