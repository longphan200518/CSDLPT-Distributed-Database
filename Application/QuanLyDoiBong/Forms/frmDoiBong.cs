using QuanLyDoiBong.DataAccess;
using QuanLyDoiBong.Models;

namespace QuanLyDoiBong.Forms
{
    public partial class frmDoiBong : Form
    {
        private DoiBongDAO dao = new DoiBongDAO();
        private DataGridView dgvDoiBong = null!;
        private TextBox txtMaDB = null!, txtTenDB = null!, txtCLB = null!, txtSearch = null!;
        private Button btnThem = null!, btnSua = null!, btnXoa = null!, btnLamMoi = null!;

        // Modern color scheme
        private readonly Color PrimaryColor = Color.FromArgb(41, 128, 185);      // Blue
        private readonly Color SecondaryColor = Color.FromArgb(52, 152, 219);    // Light Blue
        private readonly Color SuccessColor = Color.FromArgb(39, 174, 96);       // Green
        private readonly Color DangerColor = Color.FromArgb(231, 76, 60);        // Red
        private readonly Color WarningColor = Color.FromArgb(243, 156, 18);      // Orange
        private readonly Color DarkColor = Color.FromArgb(44, 62, 80);           // Dark Blue
        private readonly Color LightColor = Color.FromArgb(236, 240, 241);       // Light Gray
        private readonly Color HeaderColor = Color.FromArgb(26, 188, 156);       // Turquoise

        public frmDoiBong()
        {
            InitializeComponent();
            InitializeControls();
            LoadData();
        }

        private void InitializeComponent()
        {
            this.Text = "⚽ QUẢN LÝ ĐỘI BÓNG";
            this.Size = new Size(1200, 750);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.BackColor = LightColor;
            this.Font = new Font("Segoe UI", 9.75F, FontStyle.Regular);
        }

        private void InitializeControls()
        {
            // ===== HEADER PANEL =====
            Panel pnlHeader = new Panel 
            { 
                Dock = DockStyle.Top, 
                Height = 80, 
                BackColor = PrimaryColor 
            };

            Label lblTitle = new Label
            {
                Text = "⚽ QUẢN LÝ ĐỘI BÓNG",
                Font = new Font("Segoe UI", 20F, FontStyle.Bold),
                ForeColor = Color.White,
                Location = new Point(30, 20),
                AutoSize = true
            };

            Label lblSubtitle = new Label
            {
                Text = "Hệ thống cơ sở dữ liệu phân tán",
                Font = new Font("Segoe UI", 10F, FontStyle.Italic),
                ForeColor = Color.FromArgb(220, 240, 255),
                Location = new Point(35, 50),
                AutoSize = true
            };

            pnlHeader.Controls.AddRange(new Control[] { lblTitle, lblSubtitle });

            // ===== INFO PANEL WITH MODERN DESIGN =====
            Panel pnlInfo = new Panel 
            { 
                Dock = DockStyle.Top, 
                Height = 200, 
                BackColor = Color.White,
                Padding = new Padding(20)
            };

            // Group Box with modern styling
            GroupBox grpInfo = new GroupBox
            {
                Text = "  📝 THÔNG TIN ĐỘI BÓNG  ",
                Font = new Font("Segoe UI", 11F, FontStyle.Bold),
                ForeColor = DarkColor,
                Location = new Point(20, 10),
                Size = new Size(1140, 170)
            };

            // Mã đội
            Label lblMaDB = new Label 
            { 
                Text = "Mã đội:", 
                Location = new Point(30, 40), 
                Font = new Font("Segoe UI", 10F, FontStyle.Bold),
                ForeColor = DarkColor,
                AutoSize = true 
            };
            txtMaDB = new TextBox 
            { 
                Location = new Point(150, 37), 
                Width = 200,
                Height = 35,
                Font = new Font("Segoe UI", 10F),
                BorderStyle = BorderStyle.FixedSingle
            };

            // Tên đội
            Label lblTenDB = new Label 
            { 
                Text = "Tên đội:", 
                Location = new Point(30, 85), 
                Font = new Font("Segoe UI", 10F, FontStyle.Bold),
                ForeColor = DarkColor,
                AutoSize = true 
            };
            txtTenDB = new TextBox 
            { 
                Location = new Point(150, 82), 
                Width = 450,
                Height = 35,
                Font = new Font("Segoe UI", 10F),
                BorderStyle = BorderStyle.FixedSingle
            };

            // CLB
            Label lblCLB = new Label 
            { 
                Text = "Câu lạc bộ:", 
                Location = new Point(30, 130), 
                Font = new Font("Segoe UI", 10F, FontStyle.Bold),
                ForeColor = DarkColor,
                AutoSize = true 
            };
            txtCLB = new TextBox 
            { 
                Location = new Point(150, 127), 
                Width = 450,
                Height = 35,
                Font = new Font("Segoe UI", 10F),
                BorderStyle = BorderStyle.FixedSingle
            };

            grpInfo.Controls.AddRange(new Control[] { lblMaDB, txtMaDB, lblTenDB, txtTenDB, lblCLB, txtCLB });
            pnlInfo.Controls.Add(grpInfo);

            // ===== BUTTONS PANEL WITH MODERN STYLING =====
            Panel pnlButtons = new Panel 
            { 
                Dock = DockStyle.Top, 
                Height = 80,
                BackColor = Color.White,
                Padding = new Padding(20, 0, 20, 10)
            };

            // Search box
            Label lblSearch = new Label
            {
                Text = "🔍",
                Location = new Point(700, 25),
                Font = new Font("Segoe UI", 14F),
                AutoSize = true
            };
            
            txtSearch = new TextBox
            {
                Location = new Point(730, 20),
                Width = 250,
                Height = 35,
                Font = new Font("Segoe UI", 10F),
                PlaceholderText = "Tìm kiếm theo tên đội...",
                BorderStyle = BorderStyle.FixedSingle
            };
            txtSearch.TextChanged += TxtSearch_TextChanged;

            btnThem = CreateModernButton("➕ Thêm", 30, 20, SuccessColor);
            btnSua = CreateModernButton("✏️ Sửa", 160, 20, WarningColor);
            btnXoa = CreateModernButton("🗑️ Xóa", 290, 20, DangerColor);
            btnLamMoi = CreateModernButton("🔄 Làm mới", 420, 20, SecondaryColor);

            btnThem.Click += BtnThem_Click;
            btnSua.Click += BtnSua_Click;
            btnXoa.Click += BtnXoa_Click;
            btnLamMoi.Click += (s, e) => { ClearInputs(); LoadData(); };

            pnlButtons.Controls.AddRange(new Control[] { btnThem, btnSua, btnXoa, btnLamMoi, lblSearch, txtSearch });

            // ===== DATAGRIDVIEW WITH MODERN STYLING =====
            Panel pnlGrid = new Panel
            {
                Dock = DockStyle.Fill,
                Padding = new Padding(20, 0, 20, 20),
                BackColor = Color.White
            };

            dgvDoiBong = new DataGridView
            {
                Dock = DockStyle.Fill,
                AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill,
                SelectionMode = DataGridViewSelectionMode.FullRowSelect,
                MultiSelect = false,
                ReadOnly = true,
                AllowUserToAddRows = false,
                BackgroundColor = Color.White,
                BorderStyle = BorderStyle.None,
                CellBorderStyle = DataGridViewCellBorderStyle.SingleHorizontal,
                ColumnHeadersBorderStyle = DataGridViewHeaderBorderStyle.None,
                EnableHeadersVisualStyles = false,
                RowHeadersVisible = false,
                Font = new Font("Segoe UI", 10F),
                RowTemplate = { Height = 40 }
            };

            // Header styling
            dgvDoiBong.ColumnHeadersDefaultCellStyle.BackColor = HeaderColor;
            dgvDoiBong.ColumnHeadersDefaultCellStyle.ForeColor = Color.White;
            dgvDoiBong.ColumnHeadersDefaultCellStyle.Font = new Font("Segoe UI", 11F, FontStyle.Bold);
            dgvDoiBong.ColumnHeadersDefaultCellStyle.Padding = new Padding(10);
            dgvDoiBong.ColumnHeadersHeight = 45;

            // Row styling
            dgvDoiBong.DefaultCellStyle.SelectionBackColor = SecondaryColor;
            dgvDoiBong.DefaultCellStyle.SelectionForeColor = Color.White;
            dgvDoiBong.AlternatingRowsDefaultCellStyle.BackColor = Color.FromArgb(245, 249, 252);
            
            dgvDoiBong.CellClick += DgvDoiBong_CellClick;

            pnlGrid.Controls.Add(dgvDoiBong);

            // Add all panels to form
            this.Controls.Add(pnlGrid);
            this.Controls.Add(pnlButtons);
            this.Controls.Add(pnlInfo);
            this.Controls.Add(pnlHeader);
        }

        private Button CreateModernButton(string text, int x, int y, Color bgColor)
        {
            Button btn = new Button
            {
                Text = text,
                Location = new Point(x, y),
                Size = new Size(120, 45),
                BackColor = bgColor,
                ForeColor = Color.White,
                Font = new Font("Segoe UI", 10F, FontStyle.Bold),
                FlatStyle = FlatStyle.Flat,
                Cursor = Cursors.Hand
            };
            btn.FlatAppearance.BorderSize = 0;
            btn.FlatAppearance.MouseOverBackColor = ControlPaint.Light(bgColor, 0.2f);
            return btn;
        }

        private void TxtSearch_TextChanged(object? sender, EventArgs e)
        {
            try
            {
                if (dgvDoiBong == null || txtSearch == null) return;
                
                string searchText = txtSearch.Text.Trim().ToLower();
                if (string.IsNullOrEmpty(searchText))
                {
                    LoadData();
                    return;
                }

                List<DoiBong> allData = dao.GetAll();
                List<DoiBong> filteredData = allData.Where(db => 
                    db.TenDB.ToLower().Contains(searchText) || 
                    db.CLB.ToLower().Contains(searchText) ||
                    db.MaDB.ToLower().Contains(searchText)
                ).ToList();

                dgvDoiBong.DataSource = null;
                dgvDoiBong.DataSource = filteredData;
                FormatDataGridView();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Lỗi tìm kiếm: {ex.Message}", "Lỗi", 
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void LoadData()
        {
            try
            {
                if (dgvDoiBong == null) return;
                
                dgvDoiBong.DataSource = null;
                List<DoiBong> list = dao.GetAll();
                dgvDoiBong.DataSource = list;
                FormatDataGridView();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Lỗi khi tải dữ liệu: {ex.Message}", "Lỗi", 
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void FormatDataGridView()
        {
            try
            {
                if (dgvDoiBong == null || dgvDoiBong.Columns.Count == 0) return;
                
                if (dgvDoiBong.Columns["MaDB"] != null)
                {
                    dgvDoiBong.Columns["MaDB"].HeaderText = "MÃ ĐỘI";
                    dgvDoiBong.Columns["MaDB"].Width = 150;
                }
                
                if (dgvDoiBong.Columns["TenDB"] != null)
                {
                    dgvDoiBong.Columns["TenDB"].HeaderText = "TÊN ĐỘI BÓNG";
                    dgvDoiBong.Columns["TenDB"].Width = 350;
                }
                
                if (dgvDoiBong.Columns["CLB"] != null)
                {
                    dgvDoiBong.Columns["CLB"].HeaderText = "CÂU LẠC BỘ";
                    dgvDoiBong.Columns["CLB"].AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill;
                }
            }
            catch (Exception)
            {
                // Silent fail for formatting
            }
        }

        private void DgvDoiBong_CellClick(object? sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = dgvDoiBong.Rows[e.RowIndex];
                txtMaDB.Text = row.Cells["MaDB"].Value?.ToString() ?? "";
                txtTenDB.Text = row.Cells["TenDB"].Value?.ToString() ?? "";
                txtCLB.Text = row.Cells["CLB"].Value?.ToString() ?? "";
                txtMaDB.ReadOnly = true;
            }
        }

        private void BtnThem_Click(object? sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaDB.Text) || string.IsNullOrWhiteSpace(txtTenDB.Text))
            {
                MessageBox.Show("⚠️ Vui lòng nhập đầy đủ thông tin!", "Cảnh báo", 
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            DoiBong db = new DoiBong
            {
                MaDB = txtMaDB.Text.Trim(),
                TenDB = txtTenDB.Text.Trim(),
                CLB = txtCLB.Text.Trim()
            };

            if (dao.Insert(db))
            {
                MessageBox.Show("✅ Thêm đội bóng thành công!", "Thành công", 
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
                ClearInputs();
                LoadData();
            }
            else
            {
                MessageBox.Show("❌ Thêm đội bóng thất bại! Mã đội có thể đã tồn tại.", "Lỗi", 
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void BtnSua_Click(object? sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaDB.Text))
            {
                MessageBox.Show("⚠️ Vui lòng chọn đội bóng cần sửa!", "Cảnh báo", 
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            DoiBong db = new DoiBong
            {
                MaDB = txtMaDB.Text.Trim(),
                TenDB = txtTenDB.Text.Trim(),
                CLB = txtCLB.Text.Trim()
            };

            if (dao.Update(db))
            {
                MessageBox.Show("✅ Cập nhật thông tin thành công!", "Thành công", 
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
                ClearInputs();
                LoadData();
            }
            else
            {
                MessageBox.Show("❌ Cập nhật thất bại!", "Lỗi", 
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void BtnXoa_Click(object? sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaDB.Text))
            {
                MessageBox.Show("⚠️ Vui lòng chọn đội bóng cần xóa!", "Cảnh báo", 
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            DialogResult result = MessageBox.Show(
                $"🗑️ Bạn có chắc muốn xóa đội bóng '{txtTenDB.Text}'?\n\nLưu ý: Thao tác này không thể hoàn tác!",
                "Xác nhận xóa", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (result == DialogResult.Yes)
            {
                if (dao.Delete(txtMaDB.Text))
                {
                    MessageBox.Show("✅ Xóa đội bóng thành công!", "Thành công", 
                        MessageBoxButtons.OK, MessageBoxIcon.Information);
                    ClearInputs();
                    LoadData();
                }
                else
                {
                    MessageBox.Show("❌ Xóa thất bại! Đội bóng đang có cầu thủ hoặc trận đấu liên quan.",
                        "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }

        private void ClearInputs()
        {
            txtMaDB.Clear();
            txtTenDB.Clear();
            txtCLB.Clear();
            txtMaDB.ReadOnly = false;
            txtMaDB.Focus();
        }
    }
}
