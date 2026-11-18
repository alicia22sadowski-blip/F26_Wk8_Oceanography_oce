#Description
#The oce package provides functions for working with Oceanographic
#data, for calculations that are specific to Oceanography, 
#and for producing graphics that match the conventions of the field.

############################################################################

#Section 1: Set up, load, install packages 

install.packages("oce") # Download and install oce from CRAN
library(oce) #Attach oce
packageVersion("oce") #Installed Version 
help(package = "oce") #overall documentation 
?read.ctd #help for reading CTD files 

############################################################################

#Section 2: CTD Example
#CTD = conductivity (salinity), temperature and pressure
#helps identify thermocline/halocline/water masses 


#load data 
data(ctd) # Load the sample CTD object shipped with oce.

#Working with an S4 Object 
#Identify the class
class(ctd) # Display the object's class (including "ctd").
            #ctd is a S4 class
            #data= oceanographic measurements
            #metadata= information about measurements (station, location, etc)
            #processing log= record of processing operations 

#See available slots
slotNames(ctd)
summary(ctd) # Show a descriptive summary of the measurements.

#View measurements
names(ctd@data) # List the fields stored in the data slot.

#View metadata fields
names(ctd@metadata)

#Extract Variables 
pressure <- ctd[["pressure"]] # Extract the pressure vector, generally in dbar.
temperature <- ctd[["temperature"]] # Extract in-situ temperature, generally in °C.
salinity <- ctd[["salinity"]] # Extract practical salinity (dimensionless).
head(data.frame(pressure, temperature, salinity)) # Show the first six rows.

#create vertical profile of water column from dataset 

#temperature vs depth
plotProfile(ctd,
            xtype = "temperature",
            ytype = "depth")

#salinity vs depth
plotProfile(ctd,
            xtype = "salinity",
            ytype = "depth")

#temp and salinity vs depth 

plotProfile(ctd,
            xtype = "salinity+temperature",
            ytype = "depth")


#all three together 
plotProfile(ctd) # Ask oce to generate its default set of CTD diagnostic plots

##########################################################################################

#Section 3: Transect of CTD stations
#Section groups CTD casts along a cruise track --> compare horizontal and vertical structure 

data(section) # Load bundled set of casts 
class(section) # Confirm this is a section object.
summary(section) # Inspect station count and metadata.
plot(section, which = c(1, 2, 3, 99)) # Plot selected property panels and station map.
        #?"plot,section-method" shows numbering
        #1= temperature
        #2= salinityho
        #3= potential density
        #99 = location map 

#specify which stations 
GS <- subset(section, 102 <= stationId & stationId <= 124) # Select station IDs 102–124.
GS_grid <- sectionGrid(GS, p = seq(0, 1600, 25)) # Interpolate (estimate temp, salinity) data to 0–1600 dbar at 25-dbar steps.
GS_grid2 <- sectionGrid(GS, p = seq(0, 1600, )) # Interpolate (estimate temp, salinity) data to 0–1600 dbar 

#impact of 
plot(GS_grid, which = c(1, 99)) # Plot a gridded section panel and map.
plot(GS_grid2, which = c(1, 99)) # Plot a gridded section panel and map.

#########################################################################
#Section 4: ARGO floats 
#argo floats drift through the ocean and provide water column temp and salinity 

data(argo) # Load the Argo example supplied with oce.
class(argo) # Identify its data class.
summary(argo) # Inspect profiles, variables, and metadata.
plot(argo) # Display the default Argo visualization.

#Look at one station from argo float 
dim(argo[["temperature"]])
argo_station10 <- argo2ctd(argo, profile =10) #converts argo profile into a CTD object
class(argo_station10)
plotProfile(argo_station10, xtype = "temperature", ytype= "depth")

#Compare 2 ARGO profiles
# Extract two profiles
ctd1 <- argo2ctd(argo, profile = 1)
ctd10 <- argo2ctd(argo, profile = 10)

# Plot side by side
par(mfrow = c(1, 2))

plotProfile(ctd1, xtype = "temperature")
plotProfile(ctd10, xtype = "temperature")

# Restore default plotting layout
par(mfrow = c(1, 1))


###############################################################################
#Section 5: ADCP
#acoustic doppler profiler estimates water velocity in depth bins 
#can understand currents/inertial oscillations/interal waves 

data(adp) # Load a bundled acoustic Doppler profiler dataset.
class(adp) # Check its object class.
summary(adp) # Inspect measurement dimensions and metadata.
plot(adp) # Plot the default ADP diagnostic panels.
  #panel 1: red= eastward, blue= westward
  #panel 2:  red= northward, blue= southward
  #panel 3: red= upward motion, blue= downward motion

###############################################################################
#Section 6: Mapping Module
data(sealevel) # Load a sample sea-level time series.
class(sealevel) # Identify the object's class.
summary(sealevel) # Examine the observation period and values.
plot(sealevel) # Plot the sea-level time series.
?tidem # Read about harmonic tidal-model objects.

