# Dockerfile cho SQL Server với scripts tự động
FROM mcr.microsoft.com/mssql/server:2022-latest

USER root

# Copy SQL scripts vào container
COPY Database/*.sql /usr/src/app/

# Copy script khởi tạo
COPY setup.sh /usr/src/app/

# Cấp quyền execute
RUN chmod +x /usr/src/app/setup.sh

USER mssql

# Expose port
EXPOSE 1433

# Chạy SQL Server
CMD /opt/mssql/bin/sqlservr
