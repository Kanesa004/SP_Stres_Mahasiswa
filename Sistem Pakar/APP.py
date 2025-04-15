import streamlit as st
from datetime import datetime
from koneksi import connect_db

# Daftar gejala
gejala = {
    "G01": "Sulit berkonsentrasi saat belajar",
    "G02": "Merasa cemas berlebihan tanpa alasan jelas",
    "G03": "Kesulitan tidur atau mengalami insomnia",
    "G04": "Mudah marah atau tersinggung ",
    "G05": "Kehilangan motivasi dalam belajar atau aktivitas lain ",
    "G06": "Sering merasa lelah meskipun tidak melakukan aktivitas berat",
    "G07": "Jantung sering berdebar tanpa sebab yang jelas ",
    "G08": "Sering mengalami sakit kepala atau nyeri otot",
    "G09": "Mengalami perubahan nafsu makan (meningkat atau menurun drastis)",
    "G010": "Sering merasa putus asa atau pesimis ",
    "G011": "Sulit mengontrol emosi dan sering menangis tanpa alasan jelas",
    "G012": "Menghindari interaksi sosial atau menarik diri dari lingkungan",
    "G013": "Sering merasa tegang dan sulit rileks",
    "G014": "Mengalami gangguan pencernaan seperti sakit perut atau mual",
    "G015": "Tidak menikmati aktivitas yang biasanya menyenangkan"
}

# Data diagnosa
diagnosa = {
    "S01": "Stres Ringan",
    "S02": "Stres Sedang",
    "S03": "Stres Berat"
}

def forward_chaining(gejala_terpilih):
    jumlah = len(gejala_terpilih)
    if 1 <= jumlah <= 5:
        return "S01"
    elif 6 <= jumlah <= 10:
        return "S02"
    elif jumlah >= 11:
        return "S03"
    else:
        return None

# Streamlit App
st.set_page_config(page_title="Deteksi Stres Mahasiswa", layout="centered")
st.title("🧠 Sistem Pakar Deteksi Tingkat Stres Mahasiswa")

menu = st.sidebar.selectbox("Navigasi", ["Diagnosa", "Riwayat"])

if menu == "Diagnosa":
    st.subheader("🔍 Form Diagnosa")

    nama = st.text_input("Nama Mahasiswa")
    kelas = st.text_input("Kelas")
    jurusan = st.text_input("Jurusan")

    st.write("Silakan pilih gejala yang kamu alami:")
    gejala_terpilih = []

    for kode, deskripsi in gejala.items():
        if st.checkbox(deskripsi):
            gejala_terpilih.append(kode)

    if st.button("Diagnosa Sekarang"):
        if not nama or not kelas or not jurusan:
            st.error("⚠️ Nama, Kelas, dan Jurusan harus diisi semua.")
        elif not gejala_terpilih:
            st.warning("⚠️ Silakan pilih minimal satu gejala sebelum melakukan diagnosa.")
        else:
            hasil_kode = forward_chaining(gejala_terpilih)
            hasil_nama = diagnosa[hasil_kode]
            st.success(f"Hasil Diagnosa: {hasil_nama}")

            now = datetime.now()
            tanggal = now.strftime("%Y-%m-%d %H:%M:%S")

            db = connect_db()
            cursor = db.cursor()

            # Simpan Mahasiswa
            cursor.execute("INSERT INTO Mahasiswa (Nama, Kelas, Jurusan) VALUES (%s, %s, %s)", (nama, kelas, jurusan))
            id_mhs = cursor.lastrowid

            # Simpan Laporan
            cursor.execute("INSERT INTO Laporan (Mahasiswa_idMahasiswa, Diagnosa_idDiagnosa, Tanggal) VALUES (%s, %s, %s)",
                        (id_mhs, hasil_kode, tanggal))
            id_laporan = cursor.lastrowid

            # Simpan Gejala
            for kode in gejala_terpilih:
                cursor.execute("INSERT INTO Gejala_has_Laporan (Gejala_idGejala, Laporan_idLaporan) VALUES (%s, %s)",
                            (kode, id_laporan))

            db.commit()
            st.success("✅ Data berhasil disimpan ke database.")

else:
    st.subheader("📜 Riwayat Diagnosa Mahasiswa")
    db = connect_db()
    cursor = db.cursor()
    cursor.execute("""
        SELECT 
            m.Nama, 
            l.Tanggal, 
            d.Nama_Diagnosa, 
            GROUP_CONCAT(g.Nama_Gejala SEPARATOR ', ') AS Gejala_Dipilih
        FROM Laporan l
        JOIN Mahasiswa m ON l.Mahasiswa_idMahasiswa = m.idMahasiswa
        JOIN Diagnosa d ON l.Diagnosa_idDiagnosa = d.idDiagnosa
        JOIN Gejala_has_Laporan ghl ON l.idLaporan = ghl.Laporan_idLaporan
        JOIN Gejala g ON ghl.Gejala_idGejala = g.idGejala
        GROUP BY l.idLaporan
        ORDER BY l.Tanggal DESC
    """)
    hasil = cursor.fetchall()

    if hasil:
        for row in hasil:
            nama, tanggal, diagnosa, gejala_dipilih = row
            with st.expander(f"🧑 {nama} — 🧠 {diagnosa}"):
                st.write(f"**Tanggal Diagnosa:** {tanggal}")
                st.write(f"**Gejala:** {gejala_dipilih}")
    else:
        st.info("Belum ada data riwayat diagnosa.")

