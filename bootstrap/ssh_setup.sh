#!/bin/bash

KEY_FILE="$HOME/.ssh/k3s_cluster.pub"
USER="admin"

HOSTS=(
    $M01_IP
    $M02_IP
    $M03_IP
    $W01_IP
    $W02_IP
    $W03_IP
)

echo "Enter the password for user '$USER':"
read -s PASSWORD
echo ""

echo "Copying SSH key to all hosts..."
echo ""

for host in "${HOSTS[@]}"; do
    echo "===> Copying key to $USER@$host"
    
    sshpass -p "$PASSWORD" ssh-copy-id -i "$KEY_FILE" -o StrictHostKeyChecking=no "$USER@$host"
    
    if [ $? -eq 0 ]; then
        echo "✓ Success: $host"
    else
        echo "✗ Failed: $host"
    fi
    echo ""
done

echo "Setting up passwordless sudo on all hosts..."
echo ""

for host in "${HOSTS[@]}"; do
    echo "===> Configuring passwordless sudo on $host"
    
    ssh -i "${KEY_FILE%.pub}" -o StrictHostKeyChecking=no "$USER@$host" << EOF
echo '$PASSWORD' | sudo -S bash -c "echo 'admin ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/admin && chmod 440 /etc/sudoers.d/admin"
echo "Testing passwordless sudo..."
sudo whoami
EOF
    
    if [ $? -eq 0 ]; then
        echo "✓ Passwordless sudo configured: $host"
    else
        echo "✗ Failed to configure sudo: $host"
    fi
    echo ""
done
unset PASSWORD

echo "Done! use ansible now..."
