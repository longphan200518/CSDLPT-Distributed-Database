using System.Data;
using System.Data.SqlClient;
using QuanLyDoiBong.Models;

namespace QuanLyDoiBong.DataAccess
{
    /// <summary>
    /// Lớp xử lý các thao tác CRUD cho bảng ThamGia
    /// </summary>
    public class ThamGiaDAO
    {
        /// <summary>
        /// Lấy tất cả bản ghi tham gia
        /// </summary>
        public List<ThamGia> GetAll()
        {
            List<ThamGia> list = new List<ThamGia>();
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "SELECT MaTD, MaCT, SoTrai FROM vw_ThamGia ORDER BY MaTD, MaCT";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    ThamGia tg = new ThamGia
                    {
                        MaTD = reader["MaTD"].ToString() ?? string.Empty,
                        MaCT = reader["MaCT"].ToString() ?? string.Empty,
                        SoTrai = reader["SoTrai"] != DBNull.Value ? Convert.ToInt32(reader["SoTrai"]) : 0
                    };
                    list.Add(tg);
                }
            }
            return list;
        }

        /// <summary>
        /// Lấy danh sách cầu thủ tham gia một trận đấu
        /// </summary>
        public List<ThamGia> GetByTranDau(string maTD)
        {
            List<ThamGia> list = new List<ThamGia>();
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "SELECT MaTD, MaCT, SoTrai FROM vw_ThamGia WHERE MaTD = @MaTD ORDER BY MaCT";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@MaTD", maTD);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    ThamGia tg = new ThamGia
                    {
                        MaTD = reader["MaTD"].ToString() ?? string.Empty,
                        MaCT = reader["MaCT"].ToString() ?? string.Empty,
                        SoTrai = reader["SoTrai"] != DBNull.Value ? Convert.ToInt32(reader["SoTrai"]) : 0
                    };
                    list.Add(tg);
                }
            }
            return list;
        }

        /// <summary>
        /// Lấy danh sách trận đấu của một cầu thủ
        /// </summary>
        public List<ThamGia> GetByCauThu(string maCT)
        {
            List<ThamGia> list = new List<ThamGia>();
            using (SqlConnection conn = DatabaseConnection.GetConnection())
            {
                string query = "SELECT MaTD, MaCT, SoTrai FROM vw_ThamGia WHERE MaCT = @MaCT ORDER BY MaTD";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@MaCT", maCT);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    ThamGia tg = new ThamGia
                    {
                        MaTD = reader["MaTD"].ToString() ?? string.Empty,
                        MaCT = reader["MaCT"].ToString() ?? string.Empty,
                        SoTrai = reader["SoTrai"] != DBNull.Value ? Convert.ToInt32(reader["SoTrai"]) : 0
                    };
                    list.Add(tg);
                }
            }
            return list;
        }

        /// <summary>
        /// Thêm bản ghi tham gia mới
        /// </summary>
        public bool Insert(ThamGia tg)
        {
            try
            {
                using (SqlConnection conn = DatabaseConnection.GetConnection())
                {
                    string query = "INSERT INTO vw_ThamGia (MaTD, MaCT, SoTrai) VALUES (@MaTD, @MaCT, @SoTrai)";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MaTD", tg.MaTD);
                    cmd.Parameters.AddWithValue("@MaCT", tg.MaCT);
                    cmd.Parameters.AddWithValue("@SoTrai", tg.SoTrai);
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
        /// Cập nhật số trái
        /// </summary>
        public bool Update(ThamGia tg)
        {
            try
            {
                using (SqlConnection conn = DatabaseConnection.GetConnection())
                {
                    string query = "UPDATE vw_ThamGia SET SoTrai = @SoTrai WHERE MaTD = @MaTD AND MaCT = @MaCT";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MaTD", tg.MaTD);
                    cmd.Parameters.AddWithValue("@MaCT", tg.MaCT);
                    cmd.Parameters.AddWithValue("@SoTrai", tg.SoTrai);
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
        /// Xóa bản ghi tham gia
        /// </summary>
        public bool Delete(string maTD, string maCT)
        {
            try
            {
                using (SqlConnection conn = DatabaseConnection.GetConnection())
                {
                    string query = "DELETE FROM vw_ThamGia WHERE MaTD = @MaTD AND MaCT = @MaCT";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@MaTD", maTD);
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
