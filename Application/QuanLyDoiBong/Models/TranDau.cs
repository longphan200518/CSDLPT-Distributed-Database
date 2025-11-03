namespace QuanLyDoiBong.Models
{
    /// <summary>
    /// Lớp đại diện cho Trận đấu
    /// </summary>
    public class TranDau
    {
        public string MaTD { get; set; } = string.Empty;
        public string MaDB1 { get; set; } = string.Empty;
        public string MaDB2 { get; set; } = string.Empty;
        public string TrongTai { get; set; } = string.Empty;
        public string SanDau { get; set; } = string.Empty;

        public TranDau() { }

        public TranDau(string maTD, string maDB1, string maDB2, string trongTai, string sanDau)
        {
            MaTD = maTD;
            MaDB1 = maDB1;
            MaDB2 = maDB2;
            TrongTai = trongTai;
            SanDau = sanDau;
        }

        public override string ToString()
        {
            return $"{MaTD} - {MaDB1} vs {MaDB2} tại {SanDau}";
        }
    }
}
