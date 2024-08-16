# Use the official Python image as the base image
FROM python:3.9-slim

# Install Nginx, Git, and other dependencies
RUN apt-get update && apt-get install -y nginx git && apt-get clean

# Set the working directory for the application
WORKDIR /app

# Clone the GitHub repository
RUN git clone https://github.com/PeterTSmith1997/YWS-data .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Remove the default Nginx configuration
RUN rm /etc/nginx/sites-enabled/default

# Copy your custom Nginx configuration file to the container
COPY nginx.conf /etc/nginx/sites-available/nginx.conf

# Link the custom Nginx configuration file
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

# Copy SSL certificates into the container
COPY /path/to/your/ssl/cert.crt /etc/nginx/ssl/yourwebshield.crt
COPY /path/to/your/ssl/key.key /etc/nginx/ssl/yourwebshield.key

# Expose port 80 and 443
EXPOSE 80
EXPOSE 443

# Start the Python application and Ngix
CMD service nginx start && python app.py
