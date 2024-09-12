#!/bin/bash

# Asks for confirmation to proceed in production
if [ "$1" = "prod" ]; then
    read -p "You are in production, do you want to proceed with the operation? (y/n): " confirmation
    if [[ ! $confirmation =~ ^[Yy]$ ]]; then
        echo "Operation canceled."
        exit 1  # Exits with an error code if the answer is not affirmative
    fi
fi
