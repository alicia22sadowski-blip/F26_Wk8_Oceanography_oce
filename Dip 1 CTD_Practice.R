#Load
install.packages("oce") # Only needed once
library(oce)

#Read CTD file
file <-("C:/Users/beach/OneDrive/UCSB/Y2_2026_2027/EEMB R Seminar F26/KM2604_Dip1_datcnv.ros")
ctd <- read.ctd(file)
class(ctd)
summary(ctd)
plot(ctd)

#Examin variables
names(ctd@data)
names(ctd@metadata)
ctd@metadata

#Inspect Headers
header <- readLines(file, n=100)
cat(header, sep = "\n")

#Plot ctd 
temperature <- ctd[["temperature"]]
salinity <- ctd[["salinity"]]
depth <- ctd[["depth"]]

par(mfrow = c(1, 2))

# Temperature profile
plot(temperature, depth,
     type = "l",
     ylim = rev(range(depth, na.rm = TRUE)),
     xlab = "Temperature (°C)",
     ylab = "Depth (m)",
     main = "Temperature")

# Salinity profile
plot(salinity, depth,
     type = "l",
     ylim = rev(range(depth, na.rm = TRUE)),
     xlab = "salinity",
     ylab = "Depth (m)",
     main = "Salinity")

# Restore the default layout
par(mfrow = c(1, 1))
