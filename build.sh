#!/usr/bin/env bash
set -o errexit

pip install -r requirements.txt
python manage.py collectstatic --no-input
python manage.py migrate

echo "=== Checking Superuser Environment Variables ==="
echo "Username: ${DJANGO_SUPERUSER_USERNAME:-NOT SET}"
echo "Email: ${DJANGO_SUPERUSER_EMAIL:-NOT SET}"
echo "Password: ${DJANGO_SUPERUSER_PASSWORD:+SET}"

echo "=== Creating Superuser ==="
python manage.py shell << 'PYEOF'
from django.contrib.auth import get_user_model
import os

User = get_user_model()
username = os.environ.get('DJANGO_SUPERUSER_USERNAME')
email = os.environ.get('DJANGO_SUPERUSER_EMAIL')
password = os.environ.get('DJANGO_SUPERUSER_PASSWORD')

print(f"Attempting to create superuser: {username}")

if username and email and password:
    if User.objects.filter(username=username).exists():
        print(f"User '{username}' already exists")
        user = User.objects.get(username=username)
        print(f"  - Is superuser: {user.is_superuser}")
        print(f"  - Is staff: {user.is_staff}")
        print(f"  - Is active: {user.is_active}")
    else:
        try:
            User.objects.create_superuser(
                username=username,
                email=email,
                password=password
            )
            print(f"✓ Superuser '{username}' created successfully!")
        except Exception as e:
            print(f"✗ Error creating superuser: {str(e)}")
else:
    print("✗ Missing environment variables!")
    print(f"  Username: {'SET' if username else 'NOT SET'}")
    print(f"  Email: {'SET' if email else 'NOT SET'}")
    print(f"  Password: {'SET' if password else 'NOT SET'}")
PYEOF

echo "=== Superuser creation complete ==="