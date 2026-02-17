# Deploy Agent - Attendance Tracker

## How to Run

chmod +x setup_project.sh
./setup_project.sh

## Features

- Automated directory creation
- Dynamic threshold configuration
- Environment validation
- SIGINT trap handling
- Automatic archiving on interruption

## How to Trigger Archive

While running the script, press:

CTRL + C

The project will:
1. Create a compressed archive
2. Delete the incomplete directory
