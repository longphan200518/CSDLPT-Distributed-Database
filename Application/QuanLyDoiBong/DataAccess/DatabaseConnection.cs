using System.Data.SqlClient;

namespace QuanLyDoiBong.DataAccess
{
    /// <summary>
    /// Lớp quản lý kết nối đến database GlobalDB
    /// </summary>
    public class DatabaseConnection
    {
        private static string? _connectionString;

        /// <summary>
        /// Connection string mặc định cho Docker SQL Server
        /// </summary>
        public static string ConnectionString
        {
            get
            {
                if (string.IsNullOrEmpty(_connectionString))
                {
                    // Connection string cho SQL Server trên Docker
                    // Server: localhost,1433 (hoặc tên container nếu app cũng chạy trong Docker)
                    // User: sa
                    // Password: YourStrong@Passw0rd (phải khớp với docker-compose.yml)
                    _connectionString = @"Server=localhost,1433;Database=GlobalDB;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True;";
                }
                return _connectionString;
            }
            set => _connectionString = value;
        }

        /// <summary>
        /// Tạo và trả về SqlConnection mới
        /// </summary>
        public static SqlConnection GetConnection()
        {
            return new SqlConnection(ConnectionString);
        }

        /// <summary>
        /// Kiểm tra kết nối database
        /// </summary>
        public static bool TestConnection()
        {
            try
            {
                using (var conn = GetConnection())
                {
                    conn.Open();
                    return true;
                }
            }
            catch
            {
                return false;
            }
        }
    }
}
