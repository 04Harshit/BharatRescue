# Disaster Management Flutter App

## Overview

Welcome to the Disaster Management Flutter App, a powerful mobile application designed to empower users during disasters and emergencies. Leveraging the Flutter framework, this app delivers a seamless cross-platform experience on both iOS and Android devices. The app goes beyond conventional disaster management by offering real-time alerts, incident reporting, and crucial information about rescue centers.

## Features

### 1. **Real-time Alerts**
   - Receive instant and accurate disaster alerts, including weather updates, seismic activities, and other critical information for timely awareness and preparedness.

### 2. **Incident Reporting**
   - Report incidents directly from the app, providing valuable information about the disaster site, the number of people affected, and any urgent needs. Users can attach photos and additional details for comprehensive reporting.

### 3. **Notice Board**
   - Access a dynamic notice board that displays updates on ongoing rescue operations, including lists of people rescued and their current status. Stay informed about relief efforts in real-time.

### 4. **Complaint Filing**
   - File complaints about disasters you have encountered, detailing the nature of the incident, location, and any assistance required. This feature ensures that authorities are aware of local issues and can respond promptly.

### 5. **Rescue Center Locator**
   - Quickly locate nearby rescue centers on an interactive map, complete with contact details and services offered. This ensures that individuals can find help swiftly in the event of an emergency.

### 6. **Emergency Contacts**
   - Access a comprehensive list of emergency contacts, including local authorities, medical facilities, and other essential services, promoting efficient communication and assistance during crises.

### 7. **Community Collaboration**
   - Foster a sense of community resilience by enabling users to connect, share information, and coordinate efforts. This collaborative approach enhances overall disaster response capabilities.

## Installation Guide

### Prerequisites

- Ensure that Docker is installed on your machine. If not, you can download it from [Docker's official website](https://www.docker.com/products/docker-desktop).

### Installation Steps

1. **Download the Docker Image:**
   - Visit the Docker Hub repository to download the Disaster Management Flutter App image.
     [04harshitgarg/bharat_rescue Docker Image](https://hub.docker.com/repository/docker/04harshitgarg/bharat_rescue/)

2. **Pull the Docker Image:**
   - Open a terminal or command prompt and run the following command to pull the Docker image to your local machine:
     ```bash
     docker pull 04harshitgarg/bharat_rescue
     ```

3. **Create a Docker Container:**
   - Once the image is downloaded, create a Docker container using the following command:
     ```bash
     docker run -p 8080:80 04harshitgarg/bharat_rescue
     ```
     Adjust the port mapping according to your preference.

4. **Access the App:**
   - Open your web browser and navigate to [http://localhost:8080](http://localhost:8080) to access the Disaster Management Flutter App.

### Usage

- The app should now be accessible locally on your device. Follow the on-screen instructions to set up your account, explore features, and stay prepared for disasters.

### Additional Notes

- If you encounter any issues or have questions, refer to the app's documentation or contact the app's support team.
- Remember to stop the Docker container when you're done using the app:
  ```bash
  docker stop <container_id>
  ```
- For more detailed instructions or troubleshooting, check the app's documentation or Docker-related resources.

Thank you for contributing to community resilience through the Disaster Management Flutter App! Stay prepared, stay safe.
