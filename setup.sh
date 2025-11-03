#!/bin/bash

# Script tự động khởi tạo database trong Docker container

# Đợi SQL Server khởi động hoàn tất
sleep 30s

echo "Starting database initialization..."

# Chạy các SQL scripts theo thứ tự
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i /usr/src/app/01_CreateDatabases.sql
echo "✓ Created databases"

/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i /usr/src/app/02_CreateTables.sql
echo "✓ Created tables"

/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i /usr/src/app/03_CreateViews.sql
echo "✓ Created views"

/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i /usr/src/app/04_CreateTriggers.sql
echo "✓ Created triggers"

/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i /usr/src/app/05_SampleData.sql
echo "✓ Inserted sample data"

/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong@Passw0rd -i /usr/src/app/06_StoredProcedures.sql
echo "✓ Created stored procedures"

echo "Database initialization completed!"
