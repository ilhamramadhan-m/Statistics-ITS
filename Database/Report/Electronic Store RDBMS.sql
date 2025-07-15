CREATE DATABASE database_tugasbesar;
USE database_tugasbesar;

CREATE TABLE Kasir (
    ID_Kasir VARCHAR(10) PRIMARY KEY,
    Nama_Kasir VARCHAR(50) NOT NULL,
    Tanggal_Lahir_Kasir DATE NOT NULL
);

CREATE TABLE Produk (
    ID_Produk VARCHAR(10) PRIMARY KEY,
    Kategori_Produk VARCHAR(20) NOT NULL,
    Merk_Produk VARCHAR(20) NOT NULL,
    Spesifikasi_Produk VARCHAR(50) NOT NULL,
    Warna_Produk VARCHAR(20) NOT NULL,
    nama_produk VARCHAR(100) NOT NULL,
    Stok_Produk INT NOT NULL,
    Harga_Produk INT NOT NULL
);

CREATE TABLE Membership (
    ID_Membership INT PRIMARY KEY,
    Jenis_Membership VARCHAR(20) NOT NULL,
    Garansi VARCHAR(20) NOT NULL,
    Diskon DECIMAL(5 , 3 ) NOT NULL,
    Membership_Fee INT NOT NULL,
    INDEX idx_jenis_membership (Jenis_Membership)
);

CREATE TABLE Pelanggan (
    ID_Pelanggan VARCHAR(10) PRIMARY KEY,
    ID_Membership INT NOT NULL,
    Nama_Pelanggan VARCHAR(50) NOT NULL,
    Alamat_Pelanggan VARCHAR(100) NOT NULL,
    No_Telepon_Pelanggan VARCHAR(15) NOT NULL,
    Email_Pelanggan VARCHAR(50) NOT NULL,
    Jarak_Alamat_Pelanggan FLOAT NOT NULL,
    CONSTRAINT fk_pm FOREIGN KEY (ID_Membership)
        REFERENCES Membership (ID_Membership)
);

CREATE TABLE Transaksi (
    ID_Transaksi VARCHAR(15) PRIMARY KEY,
    Tanggal_Transaksi DATE NOT NULL,
    Waktu_Transaksi TIME NOT NULL
);

CREATE TABLE Payment (
    ID_Payment VARCHAR(3) PRIMARY KEY,
    Jenis_Membership VARCHAR(20) NOT NULL,
    Payment_Method ENUM('Cash', 'Credit') NOT NULL,
    Bunga DECIMAL(4 , 2 ) NOT NULL,
    CONSTRAINT fk_membership FOREIGN KEY (Jenis_Membership)
        REFERENCES Membership (Jenis_Membership)
);

CREATE TABLE Pengiriman (
    ID_Pengiriman VARCHAR(4) PRIMARY KEY,
    Jasa_Pengiriman VARCHAR(20) NOT NULL,
    Jenis_Pengiriman VARCHAR(20) NOT NULL,
    Biaya_Pengiriman DECIMAL(10 , 2 ) NOT NULL
);

CREATE TABLE Detailtransaksi (
    ID_Transaksi VARCHAR(20) NOT NULL,
    ID_Kasir VARCHAR(20) NOT NULL,
    ID_Pelanggan VARCHAR(20) NOT NULL,
    ID_Membership INT NOT NULL,
    ID_Produk VARCHAR(20) NOT NULL,
    ID_Pengiriman VARCHAR(20) NOT NULL,
    ID_Payment VARCHAR(20) NOT NULL,
    Jumlah_Produk INT NOT NULL,
    CONSTRAINT fk_transaksi FOREIGN KEY (ID_Transaksi)
        REFERENCES Transaksi (ID_Transaksi),
    CONSTRAINT fk_kasir FOREIGN KEY (ID_Kasir)
        REFERENCES Kasir (ID_Kasir),
    CONSTRAINT fk_pelanggan FOREIGN KEY (ID_Pelanggan)
        REFERENCES Pelanggan (ID_Pelanggan),
    CONSTRAINT fk_membershiptrx FOREIGN KEY (ID_Membership)
        REFERENCES Membership (ID_Membership),
    CONSTRAINT fk_pro FOREIGN KEY (ID_Produk)
        REFERENCES Produk (ID_Produk),
    CONSTRAINT fk_pengiriman FOREIGN KEY (ID_Pengiriman)
        REFERENCES Pengiriman (ID_Pengiriman),
    CONSTRAINT fk_payment FOREIGN KEY (ID_Payment)
        REFERENCES Payment (ID_Payment)
);

#Trigger untuk mengurangi stok produk apabila dilakukan transaksi
DELIMITER //
CREATE TRIGGER kurangi_stok AFTER INSERT ON Detailtransaksi
FOR EACH ROW
BEGIN
    UPDATE Produk 
    SET Stok_Produk = Stok_Produk - NEW.Jumlah_Produk 
    WHERE ID_Produk = NEW.ID_Produk;
END;
//
DELIMITER ;

#Trigger untuk menambahkan stok produk apabila stok produk kurang dari 20
DELIMITER //
CREATE TRIGGER tambahkan_stok_after_transaction AFTER INSERT ON Detailtransaksi
FOR EACH ROW
BEGIN
    UPDATE Produk 
    SET Stok_Produk = 25 
    WHERE Stok_Produk < 20 AND ID_Produk = NEW.ID_Produk;
END;
//
DELIMITER ;

INSERT INTO Kasir (ID_Kasir, Nama_Kasir, Tanggal_Lahir_Kasir) VALUES
('CAB121299', 'Agus Budi', '1999-12-12'),
('CAH0040192', 'Andreas Hadi', '1992-01-04'),
('CRR170907', 'Rachmad Ramadhan', '1990-09-17'),
('CAS100897', 'Adjie Susanto', '1997-08-10'),
('CHH070593', 'Hasan Hasbullah', '1993-05-07');
SELECT 
    *
FROM
    Kasir;

INSERT INTO produk (ID_Produk, Kategori_Produk , Merk_Produk , Spesifikasi_Produk , Warna_Produk , nama_produk , Stok_Produk , Harga_Produk) VALUES 
('ACSG0501', 'AC', 'Samsung', 'Split 1/2 PK', 'Ivory White', 'Samsung Split 1/2 PK AC Ivory White', 25, 3500000),
('ACSG7501', 'AC', 'Samsung', 'Split 3/4 PK', 'Ivory White', 'Samsung Split 3/4 PK AC Ivory White', 25, 5000000),
('ACSG1001', 'AC', 'Samsung', 'Split 1 PK', 'Ivory White', 'Samsung Split 1 PK AC Ivory White', 25, 6500000),
('ACSG1501', 'AC', 'Samsung', 'Split 1,5 PK', 'Ivory White', 'Samsung Split 1,5 PK AC Ivory White', 25, 9500000),
('ACSG2001', 'AC', 'Samsung', 'Split 2 PK', 'Ivory White', 'Samsung Split 2 PK AC Ivory White', 25, 10250000),
('ACDN0501', 'AC', 'Daikin', 'Split 1/2 PK', 'Ivory White', 'Daikin Split 1/2 PK AC Ivory White', 25, 3250000),
('ACDN7501', 'AC', 'Daikin', 'Split 3/4 PK', 'Ivory White', 'Daikin Split 3/4 PK AC Ivory White', 25, 5000000),
('ACDN1001', 'AC', 'Daikin', 'Split 1 PK', 'Ivory White', 'Daikin Split 1 PK AC Ivory White', 25, 7500000),
('ACDN1501', 'AC', 'Daikin', 'Split 1,5 PK', 'Ivory White', 'Daikin Split 1,5 PK AC Ivory White', 25, 9500000),
('ACDN2001', 'AC', 'Daikin', 'Split 2 PK', 'Ivory White', 'Daikin Split 2 PK AC Ivory White', 25, 11000000),
('ACPC0501', 'AC', 'Panasonic', 'Split 1/2 PK', 'Ivory White', 'Panasonic Split 1/2 PK AC Ivory White', 25, 3500000),
('ACPC7501', 'AC', 'Panasonic', 'Split 3/4 PK', 'Ivory White', 'Panasonic Split 3/4 PK AC Ivory White', 25, 4750000),
('ACPC1001', 'AC', 'Panasonic', 'Split 1 PK', 'Ivory White', 'Panasonic Split 1 PK AC Ivory White', 25, 7250000),
('ACPC1501', 'AC', 'Panasonic', 'Split 1,5 PK', 'Ivory White', 'Panasonic Split 1,5 PK AC Ivory White', 25, 9250000),
('ACPC2001', 'AC', 'Panasonic', 'Split 2 PK', 'Ivory White', 'Panasonic Split 2 PK AC Ivory White', 25, 10250000),
('ACLG0501', 'AC', 'LG', 'Split 1/2 PK', 'Ivory White', 'LG Split 1/2 PK AC Ivory White', 25, 2500000),
('ACLG7501', 'AC', 'LG', 'Split 3/4 PK', 'Ivory White', 'LG Split 3/4 PK AC Ivory White', 25, 4500000),
('ACLG1001', 'AC', 'LG', 'Split 1 PK', 'Ivory White', 'LG Split 1 PK AC Ivory White', 25, 7500000),
('ACLG1501', 'AC', 'LG', 'Split 1,5 PK', 'Ivory White', 'LG Split 1,5 PK AC Ivory White', 25, 8500000),
('ACLG2001', 'AC', 'LG', 'Split 2 PK', 'Ivory White', 'LG Split 2 PK AC Ivory White', 25, 10250000),
('ACSP0501', 'AC', 'Sharp', 'Split 1/2 PK', 'Ivory White', 'Sharp Split 1/2 PK AC Ivory White', 25, 2250000),
('ACSP7501', 'AC', 'Sharp', 'Split 3/4 PK', 'Ivory White', 'Sharp Split 3/4 PK AC Ivory White', 25, 4000000),
('ACSP1001', 'AC', 'Sharp', 'Split 1 PK', 'Ivory White', 'Sharp Split 1 PK AC Ivory White', 25, 7000000),
('ACSP1501', 'AC', 'Sharp', 'Split 1,5 PK', 'Ivory White', 'Sharp Split 1,5 PK AC Ivory White', 25, 8000000),
('ACSP2001', 'AC', 'Sharp', 'Split 2 PK', 'Ivory White', 'Sharp Split 2 PK AC Ivory White', 25, 10000000),
('TVSG2402', 'TV', 'Samsung', 'LED 24"', 'Night Black', 'Samsung LED 24" TV Night Black', 25, 3000000),
('TVSG2403', 'TV', 'Samsung', 'LED 24"', 'Metal Gray', 'Samsung LED 24" TV Metal Gray', 25, 3000000),
('TVSG4302', 'TV', 'Samsung', 'LED 43"', 'Night Black', 'Samsung LED 43" TV Night Black', 25, 4500000),
('TVSG4303', 'TV', 'Samsung', 'LED 43"', 'Metal Gray', 'Samsung LED 43" TV Metal Gray', 25, 4500000),
('TVSG7002', 'TV', 'Samsung', 'LED 70"', 'Night Black', 'Samsung LED 70" TV Night Black', 25, 17250000),
('TVSG7003', 'TV', 'Samsung', 'LED 70"', 'Metal Gray', 'Samsung LED 70" TV Metal Gray', 25, 17250000),
('TVXI2402', 'TV', 'Xiaomi', 'LED 24"', 'Night Black', 'Xiaomi LED 24" TV Night Black', 25, 2750000),
('TVXI2403', 'TV', 'Xiaomi', 'LED 24"', 'Metal Gray', 'Xiaomi LED 24" TV Metal Gray', 25, 2750000),
('TVXI4302', 'TV', 'Xiaomi', 'LED 43"', 'Night Black', 'Xiaomi LED 43" TV Night Black', 25, 4250000),
('TVXI4303', 'TV', 'Xiaomi', 'LED 43"', 'Metal Gray', 'Xiaomi LED 43" TV Metal Gray', 25, 4250000),
('TVXI7002', 'TV', 'Xiaomi', 'LED 70"', 'Night Black', 'Xiaomi LED 70" TV Night Black', 25, 16500000),
('TVXI7003', 'TV', 'Xiaomi', 'LED 70"', 'Metal Gray', 'Xiaomi LED 70" TV Metal Gray', 25, 16500000),
('TVLG2402', 'TV', 'LG', 'LED 24"', 'Night Black', 'LG LED 24" TV Night Black', 25, 1250000),
('TVLG2403', 'TV', 'LG', 'LED 24"', 'Metal Gray', 'LG LED 24" TV Metal Gray', 25, 1250000),
('TVLG4302', 'TV', 'LG', 'LED 43"', 'Night Black', 'LG LED 43" TV Night Black', 25, 5000000),
('TVLG4303', 'TV', 'LG', 'LED 43"', 'Metal Gray', 'LG LED 43" TV Metal Gray', 25, 5000000),
('TVLG7002', 'TV', 'LG', 'LED 70"', 'Night Black', 'LG LED 70" TV Night Black', 25, 20250000),
('TVLG7003', 'TV', 'LG', 'LED 70"', 'Metal Gray', 'LG LED 70" TV Metal Gray', 25, 20250000),
('TVSP2402', 'TV', 'Sharp', 'LED 24"', 'Night Black', 'Sharp LED 24" TV Night Black', 25, 1750000),
('TVSP2403', 'TV', 'Sharp', 'LED 24"', 'Metal Gray', 'Sharp LED 24" TV Metal Gray', 25, 1750000),
('TVSP4302', 'TV', 'Sharp', 'LED 43"', 'Night Black', 'Sharp LED 43" TV Night Black', 25, 3250000),
('TVSP4303', 'TV', 'Sharp', 'LED 43"', 'Metal Gray', 'Sharp LED 43" TV Metal Gray', 25, 3250000),
('TVSP7002', 'TV', 'Sharp', 'LED 70"', 'Night Black', 'Sharp LED 70" TV Night Black', 25, 18250000),
('TVSP7003', 'TV', 'Sharp', 'LED 70"', 'Metal Gray', 'Sharp LED 70" TV Metal Gray', 25, 18250000),
('TVSY2402', 'TV', 'Sony', 'LED 24"', 'Night Black', 'Sony LED 24" TV Night Black', 25, 1750000),
('TVSY2403', 'TV', 'Sony', 'LED 24"', 'Metal Gray', 'Sony LED 24" TV Metal Gray', 25, 1750000),
('TVSY4302', 'TV', 'Sony', 'LED 43"', 'Night Black', 'Sony LED 43" TV Night Black', 25, 3500000),
('TVSY4303', 'TV', 'Sony', 'LED 43"', 'Metal Gray', 'Sony LED 43" TV Metal Gray', 25, 3500000),
('TVSY7002', 'TV', 'Sony', 'LED 70"', 'Night Black', 'Sony LED 70" TV Night Black', 25, 21750000),
('TVSY7003', 'TV', 'Sony', 'LED 70"', 'Metal Gray', 'Sony LED 70" TV Metal Gray', 25, 21750000),
('RCMO1004', 'Rice Cooker', 'Miyako', '1L', 'Cherry Red', 'Miyako 1L Rice Cooker Cherry Red', 25, 300000),
('RCMO1005', 'Rice Cooker', 'Miyako', '1L', 'Caramel Brown', 'Miyako 1L Rice Cooker Caramel Brown', 25, 300000),
('RCMO1804', 'Rice Cooker', 'Miyako', '1.8L', 'Cherry Red', 'Miyako 1.8L Rice Cooker Cherry Red', 25, 600000),
('RCMO1805', 'Rice Cooker', 'Miyako', '1.8L', 'Caramel Brown', 'Miyako 1.8L Rice Cooker Caramel Brown', 25, 600000),
('RCMO4004', 'Rice Cooker', 'Miyako', '4L', 'Cherry Red', 'Miyako 4L Rice Cooker Cherry Red', 25, 1200000),
('RCMO4005', 'Rice Cooker', 'Miyako', '4L', 'Caramel Brown', 'Miyako 4L Rice Cooker Caramel Brown', 25, 1200000),
('RCPS1004', 'Rice Cooker', 'Philips', '1L', 'Cherry Red', 'Philips 1L Rice Cooker Cherry Red', 25, 350000),
('RCPS1005', 'Rice Cooker', 'Philips', '1L', 'Caramel Brown', 'Philips 1L Rice Cooker Caramel Brown', 25, 350000),
('RCPS1804', 'Rice Cooker', 'Philips', '1.8L', 'Cherry Red', 'Philips 1.8L Rice Cooker Cherry Red', 25, 600000),
('RCPS1805', 'Rice Cooker', 'Philips', '1.8L', 'Caramel Brown', 'Philips 1.8L Rice Cooker Caramel Brown', 25, 600000),
('RCPS4004', 'Rice Cooker', 'Philips', '4L', 'Cherry Red', 'Philips 4L Rice Cooker Cherry Red', 25, 1050000),
('RCPS4005', 'Rice Cooker', 'Philips', '4L', 'Caramel Brown', 'Philips 4L Rice Cooker Caramel Brown', 25, 1050000),
('RCCS1004', 'Rice Cooker', 'Cosmos', '1L', 'Cherry Red', 'Cosmos 1L Rice Cooker Cherry Red', 25, 500000),
('RCCS1005', 'Rice Cooker', 'Cosmos', '1L', 'Caramel Brown', 'Cosmos 1L Rice Cooker Caramel Brown', 25, 500000),
('RCCS1804', 'Rice Cooker', 'Cosmos', '1.8L', 'Cherry Red', 'Cosmos 1.8L Rice Cooker Cherry Red', 25, 800000),
('RCCS1805', 'Rice Cooker', 'Cosmos', '1.8L', 'Caramel Brown', 'Cosmos 1.8L Rice Cooker Caramel Brown', 25, 800000),
('RCCS4004', 'Rice Cooker', 'Cosmos', '4L', 'Cherry Red', 'Cosmos 4L Rice Cooker Cherry Red', 25, 1200000),
('RCCS4005', 'Rice Cooker', 'Cosmos', '4L', 'Caramel Brown', 'Cosmos 4L Rice Cooker Caramel Brown', 25, 1200000),
('RCRI1004', 'Rice Cooker', 'Rinai', '1L', 'Cherry Red', 'Rinai 1L Rice Cooker Cherry Red', 25, 500000),
('RCRI1005', 'Rice Cooker', 'Rinai', '1L', 'Caramel Brown', 'Rinai 1L Rice Cooker Caramel Brown', 25, 500000),
('RCRI1804', 'Rice Cooker', 'Rinai', '1.8L', 'Cherry Red', 'Rinai 1.8L Rice Cooker Cherry Red', 25, 650000),
('RCRI1805', 'Rice Cooker', 'Rinai', '1.8L', 'Caramel Brown', 'Rinai 1.8L Rice Cooker Caramel Brown', 25, 650000),
('RCRI4004', 'Rice Cooker', 'Rinai', '4L', 'Cherry Red', 'Rinai 4L Rice Cooker Cherry Red', 25, 1050000),
('RCRI4005', 'Rice Cooker', 'Rinai', '4L', 'Caramel Brown', 'Rinai 4L Rice Cooker Caramel Brown', 25, 1050000),
('RCEX1004', 'Rice Cooker', 'Electrolux', '1L', 'Cherry Red', 'Electrolux 1L Rice Cooker Cherry Red', 25, 250000),
('RCEX1005', 'Rice Cooker', 'Electrolux', '1L', 'Caramel Brown', 'Electrolux 1L Rice Cooker Caramel Brown', 25, 250000),
('RCEX1804', 'Rice Cooker', 'Electrolux', '1.8L', 'Cherry Red', 'Electrolux 1.8L Rice Cooker Cherry Red', 25, 850000),
('RCEX1805', 'Rice Cooker', 'Electrolux', '1.8L', 'Caramel Brown', 'Electrolux 1.8L Rice Cooker Caramel Brown', 25, 850000),
('RCEX4004', 'Rice Cooker', 'Electrolux', '4L', 'Cherry Red', 'Electrolux 4L Rice Cooker Cherry Red', 25, 950000),
('RCEX4005', 'Rice Cooker', 'Electrolux', '4L', 'Caramel Brown', 'Electrolux 4L Rice Cooker Caramel Brown', 25, 950000),
('BLOE1006', 'Blender', 'Oxone', '1L', 'Light Green', 'Oxone 1L Blender Light Green', 25, 1250000),
('BLOE1007', 'Blender', 'Oxone', '1L', 'Light Blue', 'Oxone 1L Blender Light Blue', 25, 1250000),
('BLOE2006', 'Blender', 'Oxone', '2L', 'Light Green', 'Oxone 2L Blender Light Green', 25, 1800000),
('BLOE2007', 'Blender', 'Oxone', '2L', 'Light Blue', 'Oxone 2L Blender Light Blue', 25, 1800000),
('BLMO10006', 'Blender', 'Miyako', '1L', 'Light Green', 'Miyako 1L Blender Light Green', 25, 1150000),
('BLMO10007', 'Blender', 'Miyako', '1L', 'Light Blue', 'Miyako 1L Blender Light Blue', 25, 1150000),
('BLMO2006', 'Blender', 'Miyako', '2L', 'Light Green', 'Miyako 2L Blender Light Green', 25, 2350000),
('BLMO2007', 'Blender', 'Miyako', '2L', 'Light Blue', 'Miyako 2L Blender Light Blue', 25, 2350000),
('BLPS1006', 'Blender', 'Philips', '1L', 'Light Green', 'Philips 1L Blender Light Green', 25, 1350000),
('BLPS1007', 'Blender', 'Philips', '1L', 'Light Blue', 'Philips 1L Blender Light Blue', 25, 2350000),
('BLPS2006', 'Blender', 'Philips', '2L', 'Light Green', 'Philips 2L Blender Light Green', 25, 1750000),
('BLPS2007', 'Blender', 'Philips', '2L', 'Light Blue', 'Philips 2L Blender Light Blue', 25, 1750000),
('BLCS1006', 'Blender', 'Cosmos', '1L', 'Light Green', 'Cosmos 1L Blender Light Green', 25, 1150000),
('BLCS1007', 'Blender', 'Cosmos', '1L', 'Light Blue', 'Cosmos 1L Blender Light Blue', 25, 1150000),
('BLCS2006', 'Blender', 'Cosmos', '2L', 'Light Green', 'Cosmos 2L Blender Light Green', 25, 1900000),
('BLCS2007', 'Blender', 'Cosmos', '2L', 'Light Blue', 'Cosmos 2L Blender Light Blue', 25, 1900000),
('BLSP1006', 'Blender', 'Sharp', '1L', 'Light Green', 'Sharp 1L Blender Light Green', 25, 1350000),
('BLSP1007', 'Blender', 'Sharp', '1L', 'Light Blue', 'Sharp 1L Blender Light Blue', 25, 1350000),
('BLSP2006', 'Blender', 'Sharp', '2L', 'Light Green', 'Sharp 2L Blender Light Green', 25, 1600000),
('BLSP2007', 'Blender', 'Sharp', '2L', 'Light Blue', 'Sharp 2L Blender Light Blue', 25, 1600000),
('LELG0108', 'Lemari Es', 'LG', '1-Door', 'Black Doff', 'LG 1-Door Lemari Es Black Doff', 25, 1500000),
('LELG0109', 'Lemari Es', 'LG', '1-Door', 'Bloody Red', 'LG 1-Door Lemari Es Bloody Red', 25, 1500000),
('LELG0208', 'Lemari Es', 'LG', '2-Door', 'Black Doff', 'LG 2-Door Lemari Es Black Doff', 25, 4750000),
('LELG0209', 'Lemari Es', 'LG', '2-Door', 'Bloody Red', 'LG 2-Door Lemari Es Bloody Red', 25, 4750000),
('LELG0308', 'Lemari Es', 'LG', 'Multi Door', 'Black Doff', 'LG Multi Door Lemari Es Black Doff', 25, 12000000),
('LELG0309', 'Lemari Es', 'LG', 'Multi Door', 'Bloody Red', 'LG Multi Door Lemari Es Bloody Red', 25, 12000000),
('LELG0408', 'Lemari Es', 'LG', 'Side-by-Side', 'Black Doff', 'LG Side-by-Side Lemari Es Black Doff', 25, 25250000),
('LELG0409', 'Lemari Es', 'LG', 'Side-by-Side', 'Bloody Red', 'LG Side-by-Side Lemari Es Bloody Red', 25, 25250000),
('LESG0108', 'Lemari Es', 'Samsung', '1-Door', 'Black Doff', 'Samsung 1-Door Lemari Es Black Doff', 25, 3000000),
('LESG0109', 'Lemari Es', 'Samsung', '1-Door', 'Bloody Red', 'Samsung 1-Door Lemari Es Bloody Red', 25, 3000000),
('LESG0208', 'Lemari Es', 'Samsung', '2-Door', 'Black Doff', 'Samsung 2-Door Lemari Es Black Doff', 25, 5000000),
('LESG0209', 'Lemari Es', 'Samsung', '2-Door', 'Bloody Red', 'Samsung 2-Door Lemari Es Bloody Red', 25, 5000000),
('LESG0308', 'Lemari Es', 'Samsung', 'Multi Door', 'Black Doff', 'Samsung Multi Door Lemari Es Black Doff', 25, 11750000),
('LESG0309', 'Lemari Es', 'Samsung', 'Multi Door', 'Bloody Red', 'Samsung Multi Door Lemari Es Bloody Red', 25, 11750000),
('LESG0408', 'Lemari Es', 'Samsung', 'Side-by-Side', 'Black Doff', 'Samsung Side-by-Side Lemari Es Black Doff', 25, 15500000),
('LESG0409', 'Lemari Es', 'Samsung', 'Side-by-Side', 'Bloody Red', 'Samsung Side-by-Side Lemari Es Bloody Red', 25, 15500000),
('LESP0108', 'Lemari Es', 'Sharp', '1-Door', 'Black Doff', 'Sharp 1-Door Lemari Es Black Doff', 25, 1250000),
('LESP0109', 'Lemari Es', 'Sharp', '1-Door', 'Bloody Red', 'Sharp 1-Door Lemari Es Bloody Red', 25, 1250000),
('LESP0208', 'Lemari Es', 'Sharp', '2-Door', 'Black Doff', 'Sharp 2-Door Lemari Es Black Doff', 25, 4750000),
('LESP0209', 'Lemari Es', 'Sharp', '2-Door', 'Bloody Red', 'Sharp 2-Door Lemari Es Bloody Red', 25, 4750000),
('LESP0308', 'Lemari Es', 'Sharp', 'Multi Door', 'Black Doff', 'Sharp Multi Door Lemari Es Black Doff', 25, 13250000),
('LESP0309', 'Lemari Es', 'Sharp', 'Multi Door', 'Bloody Red', 'Sharp Multi Door Lemari Es Bloody Red', 25, 13250000),
('LESP0408', 'Lemari Es', 'Sharp', 'Side-by-Side', 'Black Doff', 'Sharp Side-by-Side Lemari Es Black Doff', 25, 23000000),
('LESP0409', 'Lemari Es', 'Sharp', 'Side-by-Side', 'Bloody Red', 'Sharp Side-by-Side Lemari Es Bloody Red', 25, 23000000),
('LETA0108', 'Lemari Es', 'Toshiba', '1-Door', 'Black Doff', 'Toshiba 1-Door Lemari Es Black Doff', 25, 3000000),
('LETA0109', 'Lemari Es', 'Toshiba', '1-Door', 'Bloody Red', 'Toshiba 1-Door Lemari Es Bloody Red', 25, 3000000),
('LETA0208', 'Lemari Es', 'Toshiba', '2-Door', 'Black Doff', 'Toshiba 2-Door Lemari Es Black Doff', 25, 3000000),
('LETA0209', 'Lemari Es', 'Toshiba', '2-Door', 'Bloody Red', 'Toshiba 2-Door Lemari Es Bloody Red', 25, 3000000),
('LETA0308', 'Lemari Es', 'Toshiba', 'Multi Door', 'Black Doff', 'Toshiba Multi Door Lemari Es Black Doff', 25, 10250000),
('LETA0309', 'Lemari Es', 'Toshiba', 'Multi Door', 'Bloody Red', 'Toshiba Multi Door Lemari Es Bloody Red', 25, 10250000),
('LETA0408', 'Lemari Es', 'Toshiba', 'Side-by-Side', 'Black Doff', 'Toshiba Side-by-Side Lemari Es Black Doff', 25, 26000000),
('LETA0409', 'Lemari Es', 'Toshiba', 'Side-by-Side', 'Bloody Red', 'Toshiba Side-by-Side Lemari Es Bloody Red', 25, 26000000),
('LEPN0108', 'Lemari Es', 'Polytron', '1-Door', 'Black Doff', 'Polytron 1-Door Lemari Es Black Doff', 25, 1750000),
('LEPN0109', 'Lemari Es', 'Polytron', '1-Door', 'Bloody Red', 'Polytron 1-Door Lemari Es Black Doff', 25, 1750000),
('LEPN0208', 'Lemari Es', 'Polytron', '2-Door', 'Black Doff', 'Polytron 2-Door Lemari Es Black Doff', 25, 4250000),
('LEPN0209', 'Lemari Es', 'Polytron', '2-Door', 'Bloody Red', 'Polytron 2-Door Lemari Es Bloody Red', 25, 4250000),
('LEPN0308', 'Lemari Es', 'Polytron', 'Multi Door', 'Black Doff', 'Polytron Multi Door Lemari Es Black Doff', 25, 9250000),
('LEPN0309', 'Lemari Es', 'Polytron', 'Multi Door', 'Bloody Red', 'Polytron Multi Door Lemari Es Bloody Red', 25, 9250000),
('LEPN0408', 'Lemari Es', 'Polytron', 'Side-by-Side', 'Black Doff', 'Polytron Side-by-Side Lemari Es Black Doff', 25, 15750000),
('LEPN0409', 'Lemari Es', 'Polytron', 'Side-by-Side', 'Bloody Red', 'Polytron Side-by-Side Lemari Es Bloody Red', 25, 15750000),
('VCDY0110', 'Vacuum Cleaner', 'Dyson', 'Upright', 'Orange Sunset', 'Dyson Upright Vacuum Cleaner Orange Sunset', 25, 500000),
('VCDY0111', 'Vacuum Cleaner', 'Dyson', 'Upright', 'Green Sage', 'Dyson Upright Vacuum Cleaner Green Sage', 25, 500000),
('VCDY0210', 'Vacuum Cleaner', 'Dyson', 'Canister', 'Orange Sunset', 'Dyson Canister Vacuum Cleaner Orange Sunset', 25, 1100000),
('VCDY0211', 'Vacuum Cleaner', 'Dyson', 'Canister', 'Green Sage', 'Dyson Canister Vacuum Cleaner Green Sage', 25, 1100000),
('VCDY0310', 'Vacuum Cleaner', 'Dyson', 'Stick', 'Orange Sunset', 'Dyson Stick Vacuum Cleaner Orange Sunset', 25, 2900000),
('VCDY0311', 'Vacuum Cleaner', 'Dyson', 'Stick', 'Green Sage', 'Dyson Stick Vacuum Cleaner Green Sage', 25, 2900000),
('VCDY0410', 'Vacuum Cleaner', 'Dyson', 'Handheld', 'Orange Sunset', 'Dyson Handheld Vacuum Cleaner Orange Sunset', 25, 4300000),
('VCDY0411', 'Vacuum Cleaner', 'Dyson', 'Handheld', 'Green Sage', 'Dyson Handheld Vacuum Cleaner Green Sage', 25, 4300000),
('VCDY0510', 'Vacuum Cleaner', 'Dyson', 'Robot', 'Orange Sunset', 'Dyson Robot Vacuum Cleaner Orange Sunset', 25, 8050000),
('VCDY0511', 'Vacuum Cleaner', 'Dyson', 'Robot', 'Green Sage', 'Dyson Robot Vacuum Cleaner Green Sage', 25, 8050000),
('VCEX0110', 'Vacuum Cleaner', 'Electrolux', 'Upright', 'Orange Sunset', 'Electrolux Upright Vacuum Cleaner Orange Sunset', 25, 400000),
('VCEX0111', 'Vacuum Cleaner', 'Electrolux', 'Upright', 'Green Sage', 'Electrolux Upright Vacuum Cleaner Green Sage', 25, 400000),
('VCEX0210', 'Vacuum Cleaner', 'Electrolux', 'Canister', 'Orange Sunset', 'Electrolux Canister Vacuum Cleaner Orange Sunset', 25, 1100000),
('VCEX0211', 'Vacuum Cleaner', 'Electrolux', 'Canister', 'Green Sage', 'Electrolux Canister Vacuum Cleaner Green Sage', 25, 1100000),
('VCEX0310', 'Vacuum Cleaner', 'Electrolux', 'Stick', 'Orange Sunset', 'Electrolux Stick Vacuum Cleaner Orange Sunset', 25, 2500000),
('VCEX0311', 'Vacuum Cleaner', 'Electrolux', 'Stick', 'Green Sage', 'Electrolux Stick Vacuum Cleaner Green Sage', 25, 2500000),
('VCEX0410', 'Vacuum Cleaner', 'Electrolux', 'Handheld', 'Orange Sunset', 'Electrolux Handheld Vacuum Cleaner Orange Sunset', 25, 4050000),
('VCEX0411', 'Vacuum Cleaner', 'Electrolux', 'Handheld', 'Green Sage', 'Electrolux Handheld Vacuum Cleaner Green Sage', 25, 4050000),
('VCEX0510', 'Vacuum Cleaner', 'Electrolux', 'Robot', 'Orange Sunset', 'Electrolux Robot Vacuum Cleaner Orange Sunset', 25, 6550000),
('VCEX0511', 'Vacuum Cleaner', 'Electrolux', 'Robot', 'Green Sage', 'Electrolux Robot Vacuum Cleaner Green Sage', 25, 6550000),
('VCBH0110', 'Vacuum Cleaner', 'Bosch', 'Upright', 'Orange Sunset', 'Bosch Upright Vacuum Cleaner Orange Sunset', 25, 500000),
('VCBH0111', 'Vacuum Cleaner', 'Bosch', 'Upright', 'Green Sage', 'Bosch Upright Vacuum Cleaner Green Sage', 25, 500000),
('VCBH0210', 'Vacuum Cleaner', 'Bosch', 'Canister', 'Orange Sunset', 'Bosch Canister Vacuum Cleaner Orange Sunset', 25, 900000),
('VCBH0211', 'Vacuum Cleaner', 'Bosch', 'Canister', 'Green Sage', 'Bosch Canister Vacuum Cleaner Green Sage', 25, 900000),
('VCBH0310', 'Vacuum Cleaner', 'Bosch', 'Stick', 'Orange Sunset', 'Bosch Stick Vacuum Cleaner Orange Sunset', 25, 2500000),
('VCBH0311', 'Vacuum Cleaner', 'Bosch', 'Stick', 'Green Sage', 'Bosch Stick Vacuum Cleaner Green Sage', 25, 2500000),
('VCBH0410', 'Vacuum Cleaner', 'Bosch', 'Handheld', 'Orange Sunset', 'Bosch Handheld Vacuum Cleaner Orange Sunset', 25, 5300000),
('VCBH0411', 'Vacuum Cleaner', 'Bosch', 'Handheld', 'Green Sage', 'Bosch Handheld Vacuum Cleaner Green Sage', 25, 5300000),
('VCBH0510', 'Vacuum Cleaner', 'Bosch', 'Robot', 'Orange Sunset', 'Bosch Robot Vacuum Cleaner Orange Sunset', 25, 7050000),
('VCBH0511', 'Vacuum Cleaner', 'Bosch', 'Robot', 'Green Sage', 'Bosch Robot Vacuum Cleaner Green Sage', 25, 7050000),
('VCPC0110', 'Vacuum Cleaner', 'Panasonic', 'Upright', 'Orange Sunset', 'Panasonic Upright Vacuum Cleaner Orange Sunset', 25, 600000),
('VCPC0111', 'Vacuum Cleaner', 'Panasonic', 'Upright', 'Green Sage', 'Panasonic Upright Vacuum Cleaner Green Sage', 25, 600000),
('VCPC0210', 'Vacuum Cleaner', 'Panasonic', 'Canister', 'Orange Sunset', 'Panasonic Canister Vacuum Cleaner Orange Sunset', 25, 950000),
('VCPC0211', 'Vacuum Cleaner', 'Panasonic', 'Canister', 'Green Sage', 'Panasonic Canister Vacuum Cleaner Green Sage', 25, 950000),
('VCPC0310', 'Vacuum Cleaner', 'Panasonic', 'Stick', 'Orange Sunset', 'Panasonic Stick Vacuum Cleaner Orange Sunset', 25, 3100000),
('VCPC0311', 'Vacuum Cleaner', 'Panasonic', 'Stick', 'Green Sage', 'Panasonic Stick Vacuum Cleaner Green Sage', 25, 3100000),
('VCPC0410', 'Vacuum Cleaner', 'Panasonic', 'Handheld', 'Orange Sunset', 'Panasonic Handheld Vacuum Cleaner Orange Sunset', 25, 5050000),
('VCPC0411', 'Vacuum Cleaner', 'Panasonic', 'Handheld', 'Green Sage', 'Panasonic Handheld Vacuum Cleaner Green Sage', 25, 5050000),
('VCPC0510', 'Vacuum Cleaner', 'Panasonic', 'Robot', 'Orange Sunset', 'Panasonic Robot Vacuum Cleaner Orange Sunset', 25, 6300000),
('VCPC0511', 'Vacuum Cleaner', 'Panasonic', 'Robot', 'Green Sage', 'Panasonic Robot Vacuum Cleaner Green Sage', 25, 6300000),
('VCSG0110', 'Vacuum Cleaner', 'Samsung', 'Upright', 'Orange Sunset', 'Samsung Upright Vacuum Cleaner Orange Sunset', 25, 400000),
('VCSG0111', 'Vacuum Cleaner', 'Samsung', 'Upright', 'Green Sage', 'Samsung Upright Vacuum Cleaner Green Sage', 25, 400000),
('VCSG0210', 'Vacuum Cleaner', 'Samsung', 'Canister', 'Orange Sunset', 'Samsung Canister Vacuum Cleaner Orange Sunset', 25, 1150000),
('VCSG0211', 'Vacuum Cleaner', 'Samsung', 'Canister', 'Green Sage', 'Samsung Canister Vacuum Cleaner Green Sage', 25, 1150000),
('VCSG0310', 'Vacuum Cleaner', 'Samsung', 'Stick', 'Orange Sunset', 'Samsung Stick Vacuum Cleaner Orange Sunset', 25, 2100000),
('VCSG0311', 'Vacuum Cleaner', 'Samsung', 'Stick', 'Green Sage', 'Samsung Stick Vacuum Cleaner Green Sage', 25, 2100000),
('VCSG0410', 'Vacuum Cleaner', 'Samsung', 'Handheld', 'Orange Sunset', 'Samsung Handheld Vacuum Cleaner Orange Sunset', 25, 5050000),
('VCSG0411', 'Vacuum Cleaner', 'Samsung', 'Handheld', 'Green Sage', 'Samsung Handheld Vacuum Cleaner Green Sage', 25, 5050000),
('VCSG0510', 'Vacuum Cleaner', 'Samsung', 'Robot', 'Orange Sunset', 'Samsung Robot Vacuum Cleaner Orange Sunset', 25, 8050000),
('VCSG0511', 'Vacuum Cleaner', 'Samsung', 'Robot', 'Green Sage', 'Samsung Robot Vacuum Cleaner Green Sage', 25, 8050000);
SELECT 
    *
FROM
    Produk;

INSERT INTO Membership (ID_Membership, Jenis_Membership, Garansi, Diskon, Membership_Fee) VALUES
(0, 'Non-Member', '2 x 24 Jam', 0.000, 0),
(1, 'Bronze', '7 x 24 Jam', 0.025, 5000),
(2, 'Silver', '14 x 24 Jam', 0.035, 7500),
(3, 'Gold', '28 x 24 Jam', 0.050, 10000);
SELECT 
    *
FROM
    Membership;

INSERT INTO Pelanggan (ID_Pelanggan, ID_Membership, Nama_Pelanggan, Alamat_Pelanggan, No_Telepon_Pelanggan, Email_Pelanggan, Jarak_Alamat_Pelanggan) VALUES
('AA1403', 0, 'Ahmaddin Ahmad', 'Jl KH Moh Mansyur 41 A', '021-7651403', 'ahmaddin@gmail.com', 1.23),
('AM3905', 1, 'Ahmades Miqailla', 'Jl Krakatau 110', '021-63863905', 'ahmadesmiq@gmail.com', 2.45),
('AG5590', 2, 'Ahsanil Gusnawati', 'Jl Terusan Kopo 299', '021-6295590', 'gusnawati.ahsan@gmail.com', 3.67),
('AI5689', 1, 'Aida Ishak', 'Jl Pintu Air Raya 58-64 Ged Istana Pasar Baru', '021-7665689', 'aidaishak99@gmail.com', 4.89),
('BT5513', 0, 'Bong Tjen Khun', 'Gg Nuri 4-6', '021-65305513', 'bongtjenk@gmail.com', 5.01),
('BB8015', 0, 'Bonny Budi Setiawan', 'Jl Pd Kelapa 1 Bl I-14/5', '021-6928015', 'bonbudset@gmail.com', 6.32),
('FI6047', 3, 'Fransisous Iwo', 'Jl WR Supratman 27', '021-7376047', 'fransious.iwo@gmail.com', 7.54),
('EK8696', 1, 'Edy Kosasih', 'Jl Melawai IV PD Psr Jaya Blok M AKS 3/3', '021-5228696', 'kosasih1927@gmail.com', 8.76),
('HI3234', 0, 'Harun Ibrahim Tajuddin Nur', 'Jl Jend A Yani 286 Ged Graha Pangeran Unit 7/C-1 7th Floor', '021-5813234', 'tajuddin.harun@gmail.com', 9.98),
('GP4505', 0, 'Gregorius Petrus Aji Wijaya', 'Jl Sutan Iskandar Muda No. 20B', '021-5634505', 'gregpetrus@gmail.com', 10.11),
('GC7731', 3, 'Gregory Campbell Hinchlife', 'Jl H Agus Salim 88', '031-7457731', 'hinchlife.campbell@gmail.com', 2.34),
('LW6014', 1, 'Lenny Wijaya', 'Jl H Abdul Majid 25', '021-4806014', 'lennywijaya00@gmail.com', 3.56),
('KS2627', 1, 'Kiki Sutantyo', 'Jl MH Thamrin 14', '021-65302627', 'kikithamrins@gmail.com', 4.78),
('JB7493', 1, 'Jusup Budihartono Prajogo', 'Jl Kapuk Kamal Muara 20 Kamal', '021-5607493', 'jusupprajogo@gmail.com', 5.9),
('JS0114', 0, 'Johny Surjana', 'Jl HR Rasuna Said Setiabudi Bldg I Bl C/4-5', '021-4520114', 'johnysurjanaa@gmail.com', 6.21),
('RS9997', 3, 'Raja Sapta Ervian', 'Jl Raya Kalirungkut 5', '021-27929997', 'kingsapta@gmail.com', 7.43),
('RB0308', 0, 'Ratnawati Budiman', 'Jl Aipda KS Tubun 1 G', '021-6680308', 'aipdaratnawati@gmail.com', 8.65),
('SS6648', 3, 'Samuel Setiawan', 'Jl Kedinding Tgh', '021-47866648', 'samuelset@gmail.com', 9.87),
('SM5337', 0, 'Shariq Mukhtar', 'Jl Pajajaran No. 70B', '021-7695337', 'shariqmukhtar10@gmail.com', 10.09),
('NH6056', 2, 'Niniek Haryani', 'Jl Salendro Tmr III 9', '021-6626056', 'niniekharyani@gmail.com', 3.12);
SELECT 
    *
FROM
    Pelanggan;

INSERT INTO Payment (ID_Payment, Jenis_Membership, Payment_Method, Bunga) VALUES
('C00', 'Non-Member', 'Cash', 0),
('C11', 'Bronze', 'Cash', 0),
('C21', 'Silver', 'Cash', 0),
('C31', 'Gold', 'Cash', 0),
('C12', 'Bronze', 'Credit', 0.05),
('C22', 'Silver', 'Credit', 0.03),
('C32', 'Gold', 'Credit', 0.02);
SELECT 
    *
FROM
    Payment;

INSERT INTO Pengiriman (ID_Pengiriman, Jasa_Pengiriman, Jenis_Pengiriman, Biaya_Pengiriman) VALUES
('TK00', 'Self Pick-up', 'Ambil Sendiri', 0),
('JE01', 'JNE', 'Reg', 15000),
('JE02', 'JNE', 'Yes', 10000),
('JE03', 'JNE', 'Oke', 20000),
('SC01', 'SiCepat', 'Halu', 5000),
('SC02', 'SiCepat', 'H3lo', 20000),
('JT01', 'J&T', 'EZ', 9000),
('JT02', 'J&T', 'Economy', 13500);
SELECT 
    *
FROM
    Pengiriman;

INSERT INTO Transaksi (ID_Transaksi, Tanggal_Transaksi, Waktu_Transaksi) VALUES
('WTS-131222-1503', '2022-12-13', '15:03:43'),
('WTS-100923-0819', '2023-09-10', '08:19:18'),
('WTS-140523-0845', '2023-05-14', '08:45:22'),
('WTS-241023-2034', '2023-10-24', '20:34:19'),
('WTS-191123-1846', '2023-11-19', '18:46:25'),
('WTS-220923-0958', '2023-09-22', '09:58:42'),
('WTS-301023-1640', '2023-10-30', '16:40:39'),
('WTS-131023-1706', '2023-10-13', '17:06:48'),
('WTS-291023-2151', '2023-10-29', '21:51:17'),
('WTS-170523-0229', '2023-05-17', '02:29:34'),
('WTS-051123-0719', '2023-11-05', '07:19:58'),
('WTS-090823-0554', '2023-08-09', '05:54:11'),
('WTS-150423-0123', '2023-04-15', '01:23:31'),
('WTS-220723-1354', '2023-07-22', '13:54:39'),
('WTS-191023-1204', '2023-10-19', '12:04:50'),
('WTS-140723-0920', '2023-07-14', '09:20:11'),
('WTS-150323-0847', '2023-03-15', '08:47:17'),
('WTS-230423-0803', '2023-04-23', '08:03:55'),
('WTS-270523-1735', '2023-05-27', '17:35:29'),
('WTS-151023-0640', '2023-10-15', '06:40:04'),
('WTS-020823-2302', '2023-08-02', '23:02:49'),
('WTS-020323-1545', '2023-03-02', '15:45:24'),
('WTS-091123-0515', '2023-11-09', '05:15:31'),
('WTS-160423-1911', '2023-04-16', '19:11:27'),
('WTS-190923-1706', '2023-09-19', '17:06:04'),
('WTS-271123-0438', '2023-11-27', '04:38:20'),
('WTS-260223-1428', '2023-02-26', '14:28:17'),
('WTS-060423-1213', '2023-04-06', '12:13:35'),
('WTS-130823-2329', '2023-08-13', '23:29:32'),
('WTS-090523-1454', '2023-05-09', '14:54:52'),
('WTS-050723-1133', '2023-07-05', '11:33:48'),
('WTS-200623-0257', '2023-06-20', '02:57:20'),
('WTS-150623-1523', '2023-06-15', '15:23:05'),
('WTS-090423-0727', '2023-04-09', '07:27:28'),
('WTS-161123-2231', '2023-11-16', '22:31:09'),
('WTS-010323-0630', '2023-03-01', '06:30:50'),
('WTS-060323-2143', '2023-03-06', '21:43:59'),
('WTS-300723-2338', '2023-07-30', '23:38:11'),
('WTS-100823-1135', '2023-08-10', '11:35:05'),
('WTS-270523-1820', '2023-05-27', '18:20:27'),
('WTS-120123-0451', '2023-01-12', '04:51:00'),
('WTS-030923-0710', '2023-09-03', '07:10:10'),
('WTS-171123-0441', '2023-11-17', '04:41:09'),
('WTS-181123-1614', '2023-11-18', '16:14:43'),
('WTS-170223-0607', '2023-02-17', '06:07:56'),
('WTS-311222-1844', '2022-12-31', '18:44:02'),
('WTS-140523-2145', '2023-05-14', '21:45:51'),
('WTS-060423-0150', '2023-04-06', '01:50:35'),
('WTS-170423-2335', '2023-04-17', '23:35:51'),
('WTS-071023-2110', '2023-10-07', '21:10:04');
SELECT 
    *
FROM
    Transaksi;

INSERT INTO Detailtransaksi (ID_Transaksi, ID_Kasir, ID_Pelanggan, ID_Membership, ID_Produk, ID_Pengiriman, ID_Payment, Jumlah_Produk) VALUES
('WTS-131222-1503', 'CAH0040192', 'BB8015', 0, 'VCSG0311', 'JT02', 'C00', 1),
('WTS-131222-1503', 'CAH0040192', 'BB8015', 0, 'ACDN1501', 'JT02', 'C00', 2),
('WTS-100923-0819', 'CAS100897', 'EK8696', 1, 'LEPN0109', 'JE03', 'C11', 1),
('WTS-100923-0819', 'CAS100897', 'EK8696', 1, 'ACLG1501', 'JE03', 'C11', 2),
('WTS-140523-0845', 'CAH0040192', 'SM5337', 0, 'RCRI1805', 'TK00', 'C00', 2),
('WTS-140523-0845', 'CAH0040192', 'SM5337', 0, 'VCPC0110', 'TK00', 'C00', 1),
('WTS-241023-2034', 'CHH070593', 'RS9997', 3, 'LESP0208', 'JT01', 'C32', 1),
('WTS-191123-1846', 'CAH0040192', 'GP4505', 0, 'RCMO1005', 'JE03', 'C00', 1),
('WTS-191123-1846', 'CAH0040192', 'GP4505', 0, 'VCSG0110', 'JE03', 'C00', 2),
('WTS-220923-0958', 'CHH070593', 'RS9997', 3, 'LESP0408', 'JE01', 'C31', 2),
('WTS-301023-1640', 'CRR170907', 'BT5513', 0, 'LETA0308', 'JE02', 'C00', 1),
('WTS-301023-1640', 'CRR170907', 'BT5513', 0, 'BLPS2006', 'JE02', 'C00', 2),
('WTS-131023-1706', 'CAS100897', 'LW6014', 1, 'LETA0108', 'TK00', 'C11', 1),
('WTS-291023-2151', 'CHH070593', 'HI3234', 0, 'TVSY7002', 'JE02', 'C00', 1),
('WTS-291023-2151', 'CHH070593', 'HI3234', 0, 'LELG0408', 'JE02', 'C00', 1),
('WTS-170523-0229', 'CHH070593', 'GP4505', 0, 'VCSG0110', 'SC02', 'C00', 2),
('WTS-051123-0719', 'CRR170907', 'EK8696', 1, 'BLPS1006', 'JT02', 'C11', 1),
('WTS-051123-0719', 'CRR170907', 'EK8696', 1, 'LETA0309', 'JT02', 'C11', 1),
('WTS-090823-0554', 'CHH070593', 'FI6047', 3, 'RCCS1004', 'SC02', 'C32', 1),
('WTS-090823-0554', 'CHH070593', 'FI6047', 3, 'BLOE1007', 'SC02', 'C32', 2),
('WTS-150423-0123', 'CAS100897', 'JB7493', 1, 'VCSG0410', 'JE02', 'C12', 1),
('WTS-150423-0123', 'CAS100897', 'JB7493', 1, 'VCSG0511', 'JE02', 'C12', 1),
('WTS-220723-1354', 'CAB121299', 'NH6056', 2, 'RCMO4004', 'JT01', 'C22', 1),
('WTS-220723-1354', 'CAB121299', 'NH6056', 2, 'RCRI4004', 'JT01', 'C22', 2),
('WTS-191023-1204', 'CAB121299', 'LW6014', 1, 'RCEX1805', 'JT02', 'C12', 1),
('WTS-140723-0920', 'CAS100897', 'SM5337', 0, 'LELG0309', 'JE01', 'C00', 1),
('WTS-150323-0847', 'CAS100897', 'AG5590', 2, 'RCMO1804', 'SC01', 'C21', 2),
('WTS-230423-0803', 'CHH070593', 'GC7731', 3, 'VCBH0411', 'JE02', 'C32', 1),
('WTS-270523-1735', 'CAS100897', 'SM5337', 0, 'RCPS1804', 'JE01', 'C00', 2),
('WTS-151023-0640', 'CAH0040192', 'AG5590', 2, 'BLMO10007', 'JT01', 'C21', 2),
('WTS-020823-2302', 'CRR170907', 'NH6056', 2, 'LEPN0209', 'SC01', 'C22', 1),
('WTS-020323-1545', 'CAB121299', 'HI3234', 0, 'VCEX0511', 'JE03', 'C00', 2),
('WTS-091123-0515', 'CAH0040192', 'BB8015', 0, 'VCSG0410', 'SC02', 'C00', 1),
('WTS-160423-1911', 'CAS100897', 'JS0114', 0, 'RCCS1804', 'TK00', 'C00', 1),
('WTS-190923-1706', 'CAH0040192', 'BT5513', 0, 'LEPN0109', 'SC02', 'C00', 1),
('WTS-271123-0438', 'CRR170907', 'AG5590', 2, 'LETA0409', 'TK00', 'C21', 2),
('WTS-260223-1428', 'CAH0040192', 'EK8696', 1, 'BLPS2007', 'JT01', 'C11', 2),
('WTS-060423-1213', 'CRR170907', 'AM3905', 1, 'BLOE1007', 'SC02', 'C11', 2),
('WTS-130823-2329', 'CAS100897', 'FI6047', 3, 'VCEX0311', 'JE02', 'C32', 1),
('WTS-090523-1454', 'CAH0040192', 'GC7731', 3, 'LESP0308', 'JT01', 'C31', 1),
('WTS-050723-1133', 'CRR170907', 'NH6056', 2, 'VCEX0210', 'JE01', 'C21', 1),
('WTS-200623-0257', 'CAH0040192', 'HI3234', 0, 'VCSG0311', 'SC01', 'C00', 1),
('WTS-150623-1523', 'CAB121299', 'AM3905', 1, 'LETA0108', 'JE02', 'C12', 1),
('WTS-090423-0727', 'CHH070593', 'SS6648', 3, 'LELG0109', 'JE01', 'C32', 1),
('WTS-161123-2231', 'CHH070593', 'AG5590', 2, 'VCBH0311', 'JT02', 'C22', 2),
('WTS-010323-0630', 'CHH070593', 'RS9997', 3, 'BLMO2007', 'JE02', 'C32', 2),
('WTS-060323-2143', 'CAH0040192', 'RB0308', 0, 'LETA0408', 'SC02', 'C00', 1),
('WTS-300723-2338', 'CRR170907', 'KS2627', 1, 'VCDY0311', 'JE01', 'C11', 1),
('WTS-100823-1135', 'CHH070593', 'SS6648', 3, 'BLSP2006', 'JE03', 'C31', 2),
('WTS-270523-1820', 'CRR170907', 'LW6014', 1, 'VCSG0110', 'JE02', 'C11', 2),
('WTS-120123-0451', 'CRR170907', 'GP4505', 0, 'VCSG0311', 'TK00', 'C00', 2),
('WTS-030923-0710', 'CRR170907', 'AI5689', 1, 'VCBH0211', 'JT02', 'C12', 2),
('WTS-171123-0441', 'CAB121299', 'BB8015', 0, 'VCPC0111', 'SC01', 'C00', 2),
('WTS-181123-1614', 'CHH070593', 'RB0308', 3, 'LELG0308', 'JT01', 'C32', 1),
('WTS-170223-0607', 'CHH070593', 'GP4505', 0, 'VCSG0510', 'JT01', 'C00', 2),
('WTS-311222-1844', 'CHH070593', 'GP4505', 0, 'LESP0309', 'JT01', 'C00', 2),
('WTS-140523-2145', 'CRR170907', 'NH6056', 2, 'LETA0309', 'JE01', 'C22', 1),
('WTS-060423-0150', 'CAS100897', 'AA1403', 0, 'VCBH0510', 'JE01', 'C00', 2),
('WTS-170423-2335', 'CRR170907', 'BT5513', 0, 'LESP0209', 'JE03', 'C00', 1),
('WTS-071023-2110', 'CAS100897', 'FI6047', 3, 'LEPN0308', 'JT01', 'C31', 1);
SELECT 
    *
FROM
    detailtransaksi;

SELECT 
    *
FROM
    produk;

## PROCEDURE PENGHITUNGAN SUB-TOTAL BIAYA PER TRANSAKSI
DELIMITER $$

CREATE PROCEDURE calculate_total_price()
BEGIN
  CREATE TEMPORARY TABLE sales_summary (
    id_transaksi VARCHAR(20),
	id_kasir VARCHAR(20),
    customer_id VARCHAR(10),
    product_id VARCHAR(10),
    product_price DECIMAL(10,2),
    product_qty INT,  
    membership VARCHAR(20),
    membership_fee DECIMAL(10,2),
    payment_method VARCHAR(20),
    discount DECIMAL(5,3),
    bunga DECIMAL(4,2),
    shipping VARCHAR(20), 
    shipping_cost DECIMAL(10,2),  
    sub_total_price DECIMAL(10,2)
  );

  INSERT INTO sales_summary 
  SELECT
	dt.ID_transaksi,
	LEFT(k.id_kasir, 20) AS id_kasir,
    p.ID_Pelanggan,
    pr.ID_Produk,
    pr.Harga_Produk,
    dt.Jumlah_Produk,
    m.Jenis_Membership,
    CASE
     WHEN m.Jenis_Membership = 'Non-Member' THEN 0
     WHEN m.Jenis_Membership = 'Silver' THEN 5000
     WHEN m.Jenis_Membership = 'Bronze' THEN 7500
     WHEN m.Jenis_Membership = 'Gold' THEN 10000
    END AS membership_fee,
    py.Payment_Method AS payment_method,
    CASE 
    WHEN m.Jenis_Membership = 'Non-Member' THEN 0
	WHEN m.Jenis_Membership = 'Silver' AND (dt.Jumlah_Produk * pr.Harga_Produk) >= 10000000 THEN 0.035
	WHEN m.Jenis_Membership = 'Bronze' AND (dt.Jumlah_Produk * pr.Harga_Produk) >= 10000000 THEN 0.025
	WHEN m.Jenis_Membership = 'Gold' AND (dt.Jumlah_Produk * pr.Harga_Produk) >= 10000000 THEN 0.05
    ELSE 0
	END AS discount,
    CASE
      WHEN py.Payment_Method = 'Credit' AND m.Jenis_Membership = 'Bronze' THEN 0.05
      WHEN py.Payment_Method = 'Credit' AND m.Jenis_Membership = 'Silver' THEN 0.03
      WHEN py.Payment_Method = 'Credit' AND m.Jenis_Membership = 'Gold' THEN 0.02
      WHEN py.Payment_Method = 'Cash' THEN 0
    END AS bunga,
    pg.Jasa_Pengiriman,
    pg.Biaya_Pengiriman * p.Jarak_Alamat_Pelanggan AS shipping_cost,
    (dt.Jumlah_Produk * pr.Harga_Produk) - 
    CASE 
      WHEN m.Jenis_Membership = 'Non-Member' THEN 0
      WHEN m.Jenis_Membership = 'Silver' AND (dt.Jumlah_Produk * pr.Harga_Produk) >= 10000000 THEN (dt.Jumlah_Produk * pr.Harga_Produk * 0.035)  
      WHEN m.Jenis_Membership = 'Bronze' AND (dt.Jumlah_Produk * pr.Harga_Produk) >= 10000000 THEN (dt.Jumlah_Produk * pr.Harga_Produk * 0.025) 
      WHEN m.Jenis_Membership = 'Gold' AND (dt.Jumlah_Produk * pr.Harga_Produk) >= 10000000 THEN (dt.Jumlah_Produk * pr.Harga_Produk * 0.05)
      ELSE 0
    END + 
    (pg.Biaya_Pengiriman * p.Jarak_Alamat_Pelanggan) + 
    CASE
     WHEN m.Jenis_Membership = 'Non-Member' THEN 0
     WHEN m.Jenis_Membership = 'Silver' THEN 5000
     WHEN m.Jenis_Membership = 'Bronze' THEN 7500
     WHEN m.Jenis_Membership = 'Gold' THEN 10000
    END +
    (dt.Jumlah_Produk * pr.Harga_Produk * 
      CASE
        WHEN py.Payment_Method = 'Credit' AND m.Jenis_Membership = 'Bronze' THEN 0.05
        WHEN py.Payment_Method = 'Credit' AND m.Jenis_Membership = 'Silver' THEN 0.03
        WHEN py.Payment_Method = 'Credit' AND m.Jenis_Membership = 'Gold' THEN 0.02
        WHEN py.Payment_Method = 'Cash' THEN 0
        ELSE 0
      END
    ) AS sub_total_price
  FROM
    detailtransaksi dt
	 JOIN Kasir k ON dt.ID_Kasir = k.ID_Kasir
    JOIN produk pr ON dt.ID_Produk = pr.ID_Produk
    JOIN pelanggan p ON dt.ID_Pelanggan = p.ID_Pelanggan 
    JOIN membership m ON dt.ID_Membership = m.ID_Membership
    JOIN payment py ON dt.ID_Payment = py.ID_Payment
    JOIN pengiriman pg ON dt.ID_Pengiriman = pg.ID_Pengiriman;
  
  -- Tampilkan ringkasan total penjualan per pelanggan  
SELECT 
    id_transaksi,
    id_kasir,
    customer_id,
    product_id,
    product_price,
    SUM(product_qty) AS total_quantity,
    MAX(membership) AS membership,
    payment_method,
    SUM(discount) AS discount,
    SUM(bunga) AS total_bunga,
    shipping,
    SUM(shipping_cost) AS total_shipping_cost,
    SUM(sub_total_price) AS grand_total
FROM
    sales_summary
GROUP BY id_transaksi , id_kasir , customer_id , product_id , product_price , payment_method , shipping;

END$$

DELIMITER ;

CALL calculate_total_price();
SELECT 
    *
FROM
    sales_summary;

## PROCEDURE NOTA KESELURUHAN ID TRANSAKSI
DELIMITER //

CREATE PROCEDURE generate_invoice()
BEGIN
    DROP TABLE IF EXISTS sales_summary_temp;
CREATE TABLE sales_summary_temp LIKE sales_summary;
    INSERT INTO sales_summary_temp SELECT * FROM sales_summary;
SELECT 
    ss.id_transaksi,
    t.tanggal_transaksi,
    t.waktu_transaksi,
    ss.customer_id,
    k.Nama_Kasir,
    (SELECT 
            membership
        FROM
            sales_summary_temp
        WHERE
            id_transaksi = ss.id_transaksi
        LIMIT 1) AS membership,
    (SELECT 
            GROUP_CONCAT(DISTINCT CONCAT(p.Kategori_Produk,
                            ' ',
                            p.Merk_Produk,
                            ' ',
                            p.Spesifikasi_Produk,
                            ' ',
                            p.Warna_Produk))
        FROM
            sales_summary_temp ss2
                JOIN
            produk p ON ss2.product_id = p.ID_Produk
        WHERE
            ss2.id_transaksi = ss.id_transaksi) AS nama_produk,
    (SELECT 
            GROUP_CONCAT(dt.Jumlah_Produk
                    SEPARATOR ', ')
        FROM
            detailtransaksi dt
        WHERE
            dt.ID_Transaksi = ss.id_transaksi) AS jumlah_produk,
    (SELECT 
            SUM(p.Harga_Produk * dt.Jumlah_Produk)
        FROM
            produk p
                JOIN
            detailtransaksi dt ON p.ID_Produk = dt.ID_Produk
        WHERE
            dt.ID_Transaksi = ss.id_transaksi) AS selling_price,
    MAX(ss.membership_fee) AS membership_fee,
    MAX(ss.payment_method) AS payment_method,
    SUM(ss.discount) AS discount,
    SUM(ss.bunga) AS bunga,
    MAX(ss.shipping) AS shipping,
    MAX(ss.shipping_cost) AS shipping_cost,
    (SELECT 
            SUM(sub_total_price)
        FROM
            sales_summary_temp ss2
        WHERE
            ss2.id_transaksi = ss.id_transaksi) AS total_price
FROM
    sales_summary_temp ss
        JOIN
    transaksi t ON ss.id_transaksi = t.ID_Transaksi
        JOIN
    kasir k ON ss.id_kasir = k.ID_Kasir
GROUP BY ss.id_transaksi , ss.customer_id , k.Nama_Kasir;

    DROP TABLE sales_summary_temp;
END;
//
DELIMITER ;

CALL generate_invoice();

## PROCEDURE NOTA PER ID TRANSAKSI
DELIMITER //

CREATE PROCEDURE generate_invoice_pertransaction(IN transaksi_id VARCHAR(255))
BEGIN
    DROP TABLE IF EXISTS sales_summary_temp;

CREATE TABLE sales_summary_temp LIKE sales_summary;

    INSERT INTO sales_summary_temp
    SELECT * FROM sales_summary WHERE id_transaksi = transaksi_id;

SELECT 
    ss.id_transaksi,
    t.tanggal_transaksi,
    t.waktu_transaksi,
    ss.customer_id,
    k.Nama_Kasir,
    (SELECT 
            membership
        FROM
            sales_summary_temp
        WHERE
            id_transaksi = ss.id_transaksi
        LIMIT 1) AS membership,
    (SELECT 
            GROUP_CONCAT(DISTINCT CONCAT(p.Kategori_Produk,
                            ' ',
                            p.Merk_Produk,
                            ' ',
                            p.Spesifikasi_Produk,
                            ' ',
                            p.Warna_Produk))
        FROM
            sales_summary_temp ss2
                JOIN
            produk p ON ss2.product_id = p.ID_Produk
        WHERE
            ss2.id_transaksi = ss.id_transaksi) AS nama_produk,
    (SELECT 
            GROUP_CONCAT(dt.Jumlah_Produk
                    SEPARATOR ', ')
        FROM
            detailtransaksi dt
        WHERE
            dt.ID_Transaksi = ss.id_transaksi) AS jumlah_produk,
    (SELECT 
            SUM(p.Harga_Produk * dt.Jumlah_Produk)
        FROM
            produk p
                JOIN
            detailtransaksi dt ON p.ID_Produk = dt.ID_Produk
        WHERE
            dt.ID_Transaksi = ss.id_transaksi) AS selling_price,
    MAX(ss.membership_fee) AS membership_fee,
    MAX(ss.payment_method) AS payment_method,
    SUM(ss.discount) AS discount,
    SUM(ss.bunga) AS bunga,
    MAX(ss.shipping) AS shipping,
    MAX(ss.shipping_cost) AS shipping_cost,
    (SELECT 
            SUM(sub_total_price)
        FROM
            sales_summary_temp ss2
        WHERE
            ss2.id_transaksi = ss.id_transaksi) AS total_price
FROM
    sales_summary_temp ss
        JOIN
    transaksi t ON ss.id_transaksi = t.ID_Transaksi
        JOIN
    kasir k ON ss.id_kasir = k.ID_Kasir
GROUP BY ss.id_transaksi , ss.customer_id , k.Nama_Kasir;

    DROP TABLE sales_summary_temp;
END;
//
DELIMITER ;
CALL generate_invoice_pertransaction('WTS-131222-1503');SELECT 
    D.ID_Produk,
    CONCAT(P.Kategori_Produk,
            ' ',
            P.Merk_Produk,
            ' ',
            P.Spesifikasi_Produk,
            ' ',
            P.Warna_Produk) AS Nama_Produk,
    SUM(D.Jumlah_Produk) AS Jumlah_Produk
FROM
    Detailtransaksi D
        JOIN
    Produk P ON D.ID_Produk = P.ID_Produk
GROUP BY D.ID_Produk , Nama_Produk
ORDER BY D.ID_Produk;

SELECT 
    MONTH(T.Tanggal_Transaksi) AS Bulan,
    D.ID_Produk,
    CONCAT(P.Kategori_Produk,
            ' ',
            P.Merk_Produk,
            ' ',
            P.Spesifikasi_Produk,
            ' ',
            P.Warna_Produk) AS Nama_Produk,
    SUM(D.Jumlah_Produk) AS Jumlah_Produk
FROM
    Transaksi T
        JOIN
    Detailtransaksi D ON T.ID_Transaksi = D.ID_Transaksi
        JOIN
    Produk P ON D.ID_Produk = P.ID_Produk
GROUP BY Bulan , D.ID_Produk , Nama_Produk
ORDER BY Bulan , D.ID_Produk;

SELECT 
    MONTH(T.Tanggal_Transaksi) AS Bulan,
    D.ID_Produk,
    CONCAT(P.Kategori_Produk,
            ' ',
            P.Merk_Produk,
            ' ',
            P.Spesifikasi_Produk,
            ' ',
            P.Warna_Produk) AS Nama_Produk,
    SUM(D.Jumlah_Produk) AS Jumlah_Produk
FROM
    Transaksi T
        JOIN
    Detailtransaksi D ON T.ID_Transaksi = D.ID_Transaksi
        JOIN
    Produk P ON D.ID_Produk = P.ID_Produk
WHERE
    MONTH(T.Tanggal_Transaksi) = 11
GROUP BY Bulan , D.ID_Produk , Nama_Produk
ORDER BY Bulan , D.ID_Produk;

SELECT 
    d.ID_Produk,
    p.Kategori_Produk,
    p.Merk_Produk,
    p.Spesifikasi_Produk,
    p.Warna_Produk,
    p.Harga_Produk,
    SUM(d.Jumlah_Produk) AS Total_Pembelian
FROM
    detailtransaksi d
        JOIN
    Produk p ON d.ID_Produk = p.ID_Produk
GROUP BY d.ID_Produk , p.Kategori_Produk , p.Merk_Produk , p.Spesifikasi_Produk , p.Warna_Produk , p.Harga_Produk
ORDER BY Total_Pembelian DESC
LIMIT 1;

SELECT 
    P.ID_Produk,
    P.Kategori_Produk,
    P.Merk_Produk,
    P.Spesifikasi_Produk,
    P.Warna_Produk,
    P.Harga_Produk,
    SUM(D.Jumlah_Produk) AS Total_Pembelian
FROM
    detailtransaksi AS D
        JOIN
    produk AS P ON D.ID_Produk = P.ID_Produk
GROUP BY P.ID_Produk , P.Kategori_Produk , P.Merk_Produk , P.Spesifikasi_Produk , P.Warna_Produk , P.Harga_Produk
HAVING Total_Pembelian = 1;
