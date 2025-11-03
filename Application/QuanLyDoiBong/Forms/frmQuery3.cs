using QuanLyDoiBong.DataAccess;

namespace QuanLyDoiBong.Forms
{
    /// <summary>
    /// Form truy vấn 3: Số trận hòa tại một sân đấu
    /// </summary>
    public partial class frmQuery3 : Form
    {
        private QueryDAO queryDAO = new QueryDAO();
        private TranDauDAO tranDauDAO = new TranDauDAO();
        private ComboBox cboSanDau;
        private DataGridView dgvResult;
        private Button btnTimKiem;

        public frmQuery3()
        {
            InitializeComponent();
            InitializeControls();
            LoadSanDau();
        }

        private void InitializeComponent()
        {
            this.Text = "Truy vấn: Số trận hòa tại sân đấu";
            this.Size = new Size(800, 500);
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        private void InitializeControls()
        {
            Panel pnlSearch = new Panel { Dock = DockStyle.Top, Height = 80, Padding = new Padding(10) };

            Label lblSan = new Label { Text = "Chọn sân đấu:", Location = new Point(20, 25), AutoSize = true };
            cboSanDau = new ComboBox 
            { 
                Location = new Point(130, 22), 
                Width = 300,
                DropDownStyle = ComboBoxStyle.DropDownList
            };

            btnTimKiem = new Button 
            { 
                Text = "Tìm kiếm", 
                Location = new Point(440, 20), 
                Width = 120,
                Height = 30
            };
            btnTimKiem.Click += BtnTimKiem_Click;

            pnlSearch.Controls.AddRange(new Control[] { lblSan, cboSanDau, btnTimKiem });

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

        private void LoadSanDau()
        {
            List<string> sanList = tranDauDAO.GetAllSanDau();
            cboSanDau.DataSource = sanList;
        }

        private void BtnTimKiem_Click(object? sender, EventArgs e)
        {
            if (cboSanDau.SelectedItem == null)
            {
                MessageBox.Show("Vui lòng chọn sân đấu!", "Cảnh báo", 
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            string sanDau = cboSanDau.SelectedItem.ToString() ?? "";
            var result = queryDAO.GetSoTranHoaTaiSan(sanDau);
            
            dgvResult.DataSource = result;

            if (dgvResult.Columns.Count > 0)
            {
                dgvResult.Columns["SanDau"].HeaderText = "Sân Đấu";
                dgvResult.Columns["SoTranHoa"].HeaderText = "Số Trận Hòa";
            }

            if (result.Rows.Count > 0)
            {
                int soTranHoa = Convert.ToInt32(result.Rows[0]["SoTranHoa"]);
                MessageBox.Show($"Số trận hòa tại {sanDau}: {soTranHoa} trận", 
                    "Kết quả", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            else
            {
                MessageBox.Show($"Không có trận hòa nào tại {sanDau}", 
                    "Kết quả", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }
    }
}
