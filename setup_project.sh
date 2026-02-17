#!/bin/bash

# ==============================
#  Automated Project Bootstrap
# ==============================

# --------- CONFIG -------------
PROJECT_NAME=""
BASE_DIR=""
ARCHIVE_NAME=""

# --------- TRAP FUNCTION -------------
cleanup_on_interrupt() {
    echo ""
    echo "⚠️  Script interrupted! Archiving current state..."

    if [ -d "$BASE_DIR" ]; then
        tar -czf "${ARCHIVE_NAME}.tar.gz" "$BASE_DIR"
        echo " Archive created: ${ARCHIVE_NAME}.tar.gz"

        rm -rf "$BASE_DIR"
        echo "Incomplete project directory removed."
    fi

    exit 1
}

trap cleanup_on_interrupt SIGINT

# --------- INPUT -------------
read -p "Enter project identifier (e.g. v1): " PROJECT_NAME

if [ -z "$PROJECT_NAME" ]; then
    echo " Project name cannot be empty."
    exit 1
fi

BASE_DIR="attendance_tracker_${PROJECT_NAME}"
ARCHIVE_NAME="attendance_tracker_${PROJECT_NAME}_archive"

# --------- DIRECTORY CREATION -------------

if [ -d "$BASE_DIR" ]; then
    echo " Directory already exists."
    exit 1
fi

echo " Creating project structure..."

mkdir -p "$BASE_DIR/Helpers"
mkdir -p "$BASE_DIR/reports"

# --------- FILE CREATION -------------

# attendance_checker.py
cat > "$BASE_DIR/attendance_checker.py" << 'EOF'
<PASTE attendance_checker.py CONTENT HERE>
EOF

# assets.csv
cat > "$BASE_DIR/Helpers/assets.csv" << 'EOF'
Email,Names,Attendance Count,Absence Count
alice@example.com,Alice Johnson,14,1
bob@example.com,Bob Smith,7,8
charlie@example.com,Charlie Davis,4,11
diana@example.com,Diana Prince,15,0
EOF

# config.json
cat > "$BASE_DIR/Helpers/config.json" << 'EOF'
{
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "live",
    "total_sessions": 15
}
EOF

# reports.log
touch "$BASE_DIR/reports/reports.log"

echo "Directory structure created."

# --------- CONFIGURATION SECTION -------------

read -p "Do you want to update attendance thresholds? (y/n): " choice

if [[ "$choice" == "y" || "$choice" == "Y" ]]; then

    read -p "Enter Warning threshold (default 75): " warning
    read -p "Enter Failure threshold (default 50): " failure

    # Validate numeric input
    if ! [[ "$warning" =~ ^[0-9]+$ ]] || ! [[ "$failure" =~ ^[0-9]+$ ]]; then
        echo " Thresholds must be numeric."
        exit 1
    fi

    sed -i "s/\"warning\": [0-9]*/\"warning\": $warning/" "$BASE_DIR/Helpers/config.json"
    sed -i "s/\"failure\": [0-9]*/\"failure\": $failure/" "$BASE_DIR/Helpers/config.json"

    echo " Thresholds updated."
fi

# --------- HEALTH CHECK -------------

echo " Running environment health check..."

if python3 --version &>/dev/null; then
    echo "Python3 is installed."
else
    echo "⚠️  Python3 is NOT installed."
fi

echo "🎉 Project setup complete!"
