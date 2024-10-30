# Django Ecommerce on EC2

## Project Overview

This project is a Django-based ecommerce application with a React frontend, deployed on AWS EC2 instances. The infrastructure is managed using Terraform.

## Infrastructure Setup

The project uses Terraform to provision AWS resources:

- 1 VPC
- 2 Availability Zones
- 3 Subnets (1 public, 2 private)
- 3 EC2 instances (frontend in public subnet, backend in private subnet, RDS instance)
- 2 Route Tables
- Internet Gateway
- NAT Gateway
- Elastic IP
- Security Groups for each subnet
- 1 RDS instance

For detailed Terraform configuration, see the [main.tf](./terraform/main.tf) file.

## Backend Setup (Django)

1. Install Python 3.9 using deadsnakes PPA:
   ```
   sudo add-apt-repository ppa:deadsnakes/ppa
   sudo apt update
   sudo apt install python3.9 python3.9-venv python3.9-dev
   ```

2. Create and activate a Python 3.9 virtual environment:
   ```
   python3.9 -m venv env
   source env/bin/activate
   ```

3. Install project dependencies:
   ```
   pip install -r requirements.txt
   ```

4. Modify `settings.py`:
   - Update `ALLOWED_HOSTS` to include EC2 private IP
   - Update `default` database with postgres RDS details

   See [settings.py](./backend/my_project/settings.py) for details.

5. Load data to Postgres RDS 
   - Create tables in RDS
   ```
   python manage.py makemigrations account
   python manage.py makemigrations payments
   python manage.py makemigrations product
   python manage.py migrate
   ```
   - Migrate data from sqlite file to RDS
   ```
   python manage.py dumpdata --database=sqlite --natural-foreign --natural-primary -e contenttypes -e auth.Permission --indent 4 > datadump.json

   python manage.py loaddata datadump.json
   ```

   See [settings.py](./backend/my_project/settings.py) for details.

6. Run Django server:
   ```
   python manage.py runserver 0.0.0.0:8000
   ```

## Frontend Setup (React)

1. Update system packages and install git:
   ```
   sudo apt update
   sudo apt install -y git
   ```

2. Clone the repository:
   ```
   git clone https://github.com/YashMarmat/FullStack_Ecommerce_App.git
   ```

3. Install Node.js and npm:
   ```
   curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
   sudo apt install -y nodejs
   ```

4. Navigate to the frontend directory:
   ```
   cd FullStack_Ecommerce_App/frontend
   ```

5. Update `package.json`:
   - Modify the "proxy" field to point to the backend EC2 private IP:
     ```json
     "proxy": "http://BACKEND_PRIVATE_IP:8000"
     ```

   See [package.json](./frontend/package.json) for details.

6. Install dependencies:
   ```
   npm i
   ```

7. Set Node.js options for legacy compatibility and start the app:
   ```
   export NODE_OPTIONS=--openssl-legacy-provider
   npm start
   ```


