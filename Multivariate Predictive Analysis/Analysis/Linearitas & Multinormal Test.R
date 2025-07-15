# Load package
library(readxl)
library(tseries)
library(MVN)

# Load dataset dari Excel
df <- read_xlsx("C:/Statistics Undergraduate/Analisis Data Statistik/Final Project/Dataset.xlsx")
df

# Mengambil kolom variabel
DXY <- ts(df$DXY)
EUR_USD <- ts(df$EUR_USD)

# Pengujian linearitas dengan Terasvirta
terasvirta.test(DXY)
terasvirta.test(EUR_USD)

# Load hasil permodelan VAR
hasil <- read_xlsx("C:/Statistics Undergraduate/Analisis Data Statistik/Final Project/Hasil_VAR.xlsx")
hasil

# Mengambil kolom residual
residual_data <- hasil[, c("RES1", "RES2")]

# Pengujian Multinormal dengan Mardia Tests
mardia_result <- mardia(as.matrix(residual_data))
print(mardia_result)
