using QuanLyDoiBong.DataAccess;

namespace QuanLyDoiBong.Forms
{
    /// <summary>
    /// Form truy vấn 2: Số trận cầu thủ đã tham gia
    /// </summary>
    public partial class frmQuery2 : Form
    {
        private QueryDAO queryDAO = new QueryDAO();
        private TextBox txtHoTen;
        private DataGridView dgvResult;
        private Button btnTimKiem;

        public frmQuery2()
        {
            InitializeComponent();
            InitializeControls();
        }

        private void InitializeComponent()
        {
            this.Text = "Truy vấn: Số trận cầu thủ đã tham gia";
            this.Size = new Size(800, 500);
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        private void InitializeControls()
        {
            Panel pnlSearch = new Panel { Dock = DockStyle.Top, Height = 80, Padding = new Padding(10) };

            Label lblHoTen = new Label { Text = "Họ tên cầu thủ:", Location = new Point(20, 25), AutoSize = true };
            txtHoTen = new TextBox { Location = new Point(130, 22), Width = 300 };

            btnTimKiem = new Button 
            { 
                Text = "Tìm kiếm", 
                Location = new Point(440, 20), 
                Width = 120,
                Height = 30
            };
            btnTimKiem.Click += BtnTimKiem_Click;

            pnlSearch.Controls.AddRange(new Control[] { lblHoTen, txtHoTen, btnTimKiem });

            dgvResult = new DataGridView
            {
                Dock = DockStyle.Fill,
                AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                MultiSelect = false,
                ReadOnly = true,
                AllowUserToAddRows = false
            };

            this.Controls.Add(dgvResult);
            this.Controls.Add(pnlSearch);
        }

        private void BtnTimKiem_Click(object? sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtHoTen.Text))
            {
                MessageBox.Show("Vui lòng nhập họ tên cầu thủ!", "Cảnh báo", 
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            var result = queryDAO.GetSoTranThamGia(txtHoTen.Text.Trim());
            dgvResult.DataSource = result;

            if (dgvResult.Columns.Count > 0)
            {
                dgvResult.Columns["MaCT"].HeaderText = "Mã Cầu Thủ";
                dgvResult.Columns["HoTen"].HeaderText = "Họ Tên";
                dgvResult.Columns["SoTranThamGia"].HeaderText = "Số Trận Tham Gia";
                if (dgvResult.Columns.Contains("TongSoBanThang"))
                    dgvResult.Columns["TongSoBanThang"].HeaderText = "Tổng Số Bàn Thắng";
            }

            MessageBox.Show($"Tìm thấy {result.Rows.Count} cầu thủ", 
                "Kết quả", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
    }
}
