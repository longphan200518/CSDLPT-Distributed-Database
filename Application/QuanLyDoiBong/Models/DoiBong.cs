namespace QuanLyDoiBong.Models
{
    /// <summary>
    /// Lớp đại diện cho Đội bóng
    /// </summary>
    public class DoiBong
    {
        public string MaDB { get; set; } = string.Empty;
        public string TenDB { get; set; } = string.Empty;
        public string CLB { get; set; } = string.Empty;

        public DoiBong() { }

        public DoiBong(string maDB, string tenDB, string clb)
        {
            MaDB = maDB;
            TenDB = tenDB;
            CLB = clb;
        }

        public override string ToString()
        {
            return $"{MaDB} - {TenDB} ({CLB})";
        }
    }
}
