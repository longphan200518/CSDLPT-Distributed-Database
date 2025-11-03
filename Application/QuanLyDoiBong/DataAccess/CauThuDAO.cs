using System.Data;
using System.Data.SqlClient;
using QuanLyDoiBong.Models;

namespace QuanLyDoiBong.DataAccess
{
    /// <summary>
    /// Lớp xử lý các thao tác CRUD cho bảng CauThu
    /// </summary>
    public class CauThuDAO
    {
        /// <summary>
        /// Lấy tất cả cầu thủ
        /// </summary>
        public List<CauThu> GetAll()
        {
            List<CauThu> list = new List<CauThu>();
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "SELECT MaCT, HoTen, MaDB FROM vw_CauThu ORDER BY MaCT";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    CauThu ct = new CauThu
                    {
                        MaCT = reader["MaCT"].ToString() ?? string.Empty,
                        HoTen = reader["HoTen"].ToString() ?? string.Empty,
                        MaDB = reader["MaDB"].ToString() ?? string.Empty
                    };
                    list.Add(ct);
                }
            }
            return list;
        }

        /// <summary>
        /// Lấy cầu thủ theo mã
        /// </summary>
        public CauThu? GetByMa(string maCT)
        {
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "SELECT MaCT, HoTen, MaDB FROM vw_CauThu WHERE MaCT = @MaCT";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@MaCT", maCT);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    return new CauThu
                    {
                        MaCT = reader["MaCT"].ToString() ?? string.Empty,
                        HoTen = reader["HoTen"].ToString() ?? string.Empty,
                        MaDB = reader["MaDB"].ToString() ?? string.Empty
                    };
                }
            }
            return null;
        }

        /// <summary>
        /// Lấy cầu thủ theo đội bóng
        /// </summary>
        public List<CauThu> GetByDoiBong(string maDB)
        {
            List<CauThu> list = new List<CauThu>();
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "SELECT MaCT, HoTen, MaDB FROM vw_CauThu WHERE MaDB = @MaDB ORDER BY HoTen";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@MaDB", maDB);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    CauThu ct = new CauThu
                    {
                        MaCT = reader["MaCT"].ToString() ?? string.Empty,
                        HoTen = reader["HoTen"].ToString() ?? string.Empty,
                        MaDB = reader["MaDB"].ToString() ?? string.Empty
                    };
                    list.Add(ct);
                }
            }
            return list;
        }

        /// <summary>
        /// Thêm cầu thủ mới
        /// </summary>
        public bool Insert(CauThu ct)
        {
            try
            {
                using (SqlConnection conn = DatabaseConnection.GetConnection())
                {
                    string query = "INSERT INTO vw_CauThu (MaCT, HoTen, MaDB) VALUES (@MaCT, @HoTen, @MaDB)";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MaCT", ct.MaCT);
                    cmd.Parameters.AddWithValue("@HoTen", ct.HoTen);
                    cmd.Parameters.AddWithValue("@MaDB", ct.MaDB);
                    conn.Open();
                    int rows = cmd.ExecuteNonQuery();
                    return rows > 0;
                }
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Cập nhật cầu thủ
        /// </summary>
        public bool Update(CauThu ct)
        {
            try
            {
                using (SqlConnection conn = DatabaseConnection.GetConnection())
                {
                    string query = "UPDATE vw_CauThu SET HoTen = @HoTen, MaDB = @MaDB WHERE MaCT = @MaCT";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MaCT", ct.MaCT);
                    cmd.Parameters.AddWithValue("@HoTen", ct.HoTen);
                    cmd.Parameters.AddWithValue("@MaDB", ct.MaDB);
                    conn.Open();
                    int rows = cmd.ExecuteNonQuery();
                    return rows > 0;
                }
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Xóa cầu thủ
        /// </summary>
        public bool Delete(string maCT)
        {
            try
            {
                using (SqlConnection conn = DatabaseConnection.GetConnection())
                {
                    string query = "DELETE FROM vw_CauThu WHERE MaCT = @MaCT";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MaCT", maCT);
                    conn.Open();
                    int rows = cmd.ExecuteNonQuery();
                    return rows > 0;
                }
            }
            catch
            {
                return false;
            }
        }
    }
}
