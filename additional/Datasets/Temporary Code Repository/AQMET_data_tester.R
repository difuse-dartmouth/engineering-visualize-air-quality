####AQMET_data_tester.R####

# Title: AQ and MET Data Tester
# Project: ENGS 37 DIFUSE
# Author: Andy Bean '23
# Date: Feb 4, 2022, 6:00 PM

# This script will pull, clean, and export all data for the Air Quality Project
# as part of ENGS 37 for 22S in Berlin.
# Dartmouth College and Thayer School of Engineering, 2022


#=====================================================
####Procedure####

# For each data set
# 1. Import it using read_csv (important to use the underscore!)
# 2. display the head of the file
# 3. Run a timePlot on all possible variables
# 4. Log any missing variables
# 5. Log units for all data
#   a. this can be done by going to the raw imported data (separate file) and 
#      doing table(dat$unit[dat$variable == "pollutant"]) for each pollutant


# Call Libraries
library(openair); #vis pkg
library(tidyverse); #helps vis pkg
library(worldmet); #met pkg
library(dplyr); #data manip fxns
library(saqgetr); #euro pkg

# Set Working Directory
setwd("/Users/abean/Documents/RStudio/DIFUSE E37");

#===============
#Set 1: Berlin Bla Mah####

# must use **read_csv()**
dat1 <- read_csv("aq_berlin_bla_mah.csv")
head(dat1)

timePlot(
    dat1, 
    pollutant = c("co", "no", "no2", "nox", "o3"), 
    avg.time = "month")

timePlot(
    dat1,
    pollutant = c("pm10", "pm2.5", "ws", "wd"),
    avg.time = "month"
)

# no gaps!
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^3, except co in mg/m^3

#===============
#Set 2: Berlin Fri Fra####

# must use **read_csv()**
dat2 <- read_csv("aq_berlin_fri_fra.csv");
head(dat2)

timePlot(
    dat2, 
    pollutant = c("co", "no", "no2", "nox", "o3"), 
    avg.time = "month")

timePlot(
    dat2,
    pollutant = c("pm10", "benzene", "so2", "ws", "wd"),
    avg.time = "month"
)

# missing o3 entirely, missing pm2.5 entirely, missing so2 after early 2020
# (consider removing those because they threw big errors)
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^3, except co in mg/m^3


#===============
#Set 3: Berlin Neu Sil####

# must use **read_csv()**
dat3 <- read_csv("aq_berlin_neu_sil.csv");
head(dat3)

timePlot(
    dat3, 
    pollutant = c("no", "no2", "nox"), 
    avg.time = "month")

timePlot(
    dat3,
    pollutant = c("pm10", "pm2.5", "ws", "wd"),
    avg.time = "month"
)

# fewer readings, missing pm2.5 entirely
# (consider removing because they threw big errors)
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^3


#===============
#Set 4: Berlin Sch Bel####

# must use **read_csv()**
dat4 <- read_csv("aq_berlin_sch_bel.csv");
head(dat4)

timePlot(
    dat4, 
    pollutant = c("no", "no2", "nox"), 
    avg.time = "month")

timePlot(
    dat4,
    pollutant = c("ws", "wd"),
    avg.time = "month"
)

# fewer readings
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^3

#===============
#Set 5: Berlin Wed Amr####

# must use **read_csv()**
dat5 <- read_csv("aq_berlin_wed_amr.csv");
head(dat5)

timePlot(
    dat5, 
    pollutant = c("no", "no2", "nox", "benzene", "o3"), 
    avg.time = "month"
)

timePlot(
    dat5,
    pollutant = c("pm10", "pm2.5", "ws", "wd"),
    avg.time = "month"
)

# missing pm2.5 entirely, benzene gone after 2017. 
# (consider removing because they threw big errors)
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^3

#===============
#Set 6: Cologne Rod####

# must use **read_csv()**
dat6 <- read_csv("aq_cologne_rod.csv");
head(dat6)

timePlot(
    dat6, 
    pollutant = c("no", "no2", "nox", "o3"), 
    avg.time = "month")

timePlot(
    dat6,
    pollutant = c("pm10", "so2", "ws", "wd"),
    avg.time = "month"
)

# gaps in nox in 2020 and 2021, so2 gone after 2019
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^3


#===============
#Set 7: Cologne Tur####

# must use **read_csv()**
dat7 <- read_csv("aq_cologne_tur.csv");
head(dat7)

timePlot(
    dat7, 
    pollutant = c("no", "no2", "nox"), 
    avg.time = "month")

timePlot(
    dat7,
    pollutant = c("pm10", "pm2.5", "ws", "wd"),
    avg.time = "month"
)

# gaps in nox in 2020 and 2021
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^3


#===============
#Set 8: Dusseldorf Lor####

# must use **read_csv()**
dat8 <- read_csv("aq_dusseldorf_lor.csv");
head(dat8)

timePlot(
    dat8, 
    pollutant = c("no", "no2", "nox", "o3"), 
    avg.time = "month")

timePlot(
    dat8,
    pollutant = c("pm10", "pm2.5", "ws", "wd"),
    avg.time = "month"
)

# gaps in nox in 2020 and 2021
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^3


#===============
#Set 9: Dusseldorf Rat####

# must use **read_csv()**
dat9 <- read_csv("aq_dusseldorf_lor.csv");
head(dat9)

timePlot(
    dat9, 
    pollutant = c("no", "no2", "nox", "o3"), 
    avg.time = "month")

timePlot(
    dat9,
    pollutant = c("pm10", "pm2.5", "ws", "wd"),
    avg.time = "month"
)

# gaps in nox in 2020 and 2021
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^3


#===============
#Set 10: Hamburg Ste####

# must use **read_csv()**
dat10 <- read_csv("aq_hamburg_ste.csv");
head(dat10)

timePlot(
    dat10, 
    pollutant = c("no", "no2", "nox", "o3", "so2"), 
    avg.time = "month")

timePlot(
    dat10,
    pollutant = c("pm10", "pm2.5", "ws", "wd"),
    avg.time = "month"
)

# gaps in nox in late 2021
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^3


#===============
#Set 11: Hamburg Str####

# must use **read_csv()**
dat11 <- read_csv("aq_hamburg_str.csv");
head(dat11)

timePlot(
    dat11, 
    pollutant = c("no", "no2", "nox", "co", "benzene"), 
    avg.time = "month")

timePlot(
    dat11,
    pollutant = c("pm10", "toluene", "ws", "wd"),
    avg.time = "month"
)

# gaps in nox in late 2021; co, benzene, and toluene missing almost entirely
# (remove?)
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^3


#===============
#Set 12: Hamburg Ved####

# must use **read_csv()**
dat12 <- read_csv("aq_hamburg_ved.csv");
head(dat12)

timePlot(
    dat12, 
    pollutant = c("no", "no2", "nox", "so2"), 
    avg.time = "month")

timePlot(
    dat12,
    pollutant = c("pm10", "pm2.5", "ws", "wd"),
    avg.time = "month"
)

# gap in nox in late 2021
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^3


#===============
#Set 13: Hannover Main####

# must use **read_csv()**
dat13 <- read_csv("aq_hannover_main.csv");
head(dat13)

timePlot(
    dat13, 
    pollutant = c("no", "no2", "nox", "o3"), 
    avg.time = "month")

timePlot(
    dat13,
    pollutant = c("pm10", "pm2.5", "ws", "wd"),
    avg.time = "month"
)

# gap in nox beginning 2020
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^3


#===============
#Set 14: Hannover Verk####

# must use **read_csv()**
dat14 <- read_csv("aq_hannover_verk.csv");
head(dat14)

timePlot(
    dat14, 
    pollutant = c("no", "no2", "nox", "co"), 
    avg.time = "month")

timePlot(
    dat14,
    pollutant = c("pm10", "pm2.5", "ws", "wd"),
    avg.time = "month"
)

# gap in nox beginning 2020
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^3, except co in mg/m^3



#===============
#Set 15: Leipzig Mitte####

# must use **read_csv()**
dat15 <- read_csv("aq_leipzig_mitte.csv");
head(dat15)

timePlot(
    dat15, 
    pollutant = c("no", "no2", "nox", "benzene", "toluene"), 
    avg.time = "month")

timePlot(
    dat15,
    pollutant = c("so2", "pm10", "pm2.5", "ws", "wd"),
    avg.time = "month"
)

# some minor gaps in nox in 2020 and 2021, almost no o3, no pm2.5, no toluene after 2020
# (consider removing at least o3 and pm2.5)
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^-3


#===============
#Set 16: Leipzig West####

# must use **read_csv()**
dat16 <- read_csv("aq_leipzig_west.csv");
head(dat16)

timePlot(
    dat16, 
    pollutant = c("no", "no2", "nox", "o3"), 
    avg.time = "month")

timePlot(
    dat16,
    pollutant = c("pm10", "pm2.5", "ws", "wd"),
    avg.time = "month"
)

# some minor gaps in nox in 2020 and 2021, no pm2.5
# (consider removing at least pm2.5)
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^-3


#===============
#Set 17: Munich Loth####

# must use **read_csv()**
dat17 <- read_csv("aq_munich_loth.csv");
head(dat17)

timePlot(
    dat17, 
    pollutant = c("no", "no2", "nox", "co", "o3"), 
    avg.time = "month")

timePlot(
    dat17,
    pollutant = c("pm10", "pm2.5", "ws", "wd"),
    avg.time = "month"
)

# nox stops in 2020, co stops in 2018
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^-3, except co in mg


#===============
#Set 18: Munich Stac####

# must use **read_csv()**
dat18 <- read_csv("aq_munich_stac.csv");
head(dat18)

timePlot(
    dat18, 
    pollutant = c("no", "no2", "nox", "co", "o3"), 
    avg.time = "month")

timePlot(
    dat18,
    pollutant = c("so2", "pm10", "pm2.5", "ws", "wd"),
    avg.time = "month"
)

# nox stops in 2020, slight gap in o3 in early 2017, so2 stops in mid-2018
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^-3, except co in mg


#===============
#Set 19: Rural Col####

# must use **read_csv()**
dat19 <- read_csv("aq_rural_col.csv");
head(dat19)

timePlot(
    dat19, 
    pollutant = c("no", "no2", "nox","o3"), 
    avg.time = "month")

timePlot(
    dat19,
    pollutant = c("pm10", "pm2.5", "ws", "wd"),
    avg.time = "month"
)

# minor nox gaps in late 2020 and 2021, missing 2.5 entirely
# (consider removing pm2.5 at least)
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^-3


#===============
#Set 20: Rural Wit Bah####

# must use **read_csv()**
dat20 <- read_csv("aq_rural_wit_bah.csv");
head(dat20)

timePlot(
    dat20, 
    pollutant = c("no", "no2", "nox","o3"), 
    avg.time = "month")

timePlot(
    dat20,
    pollutant = c("pm10", "ws", "wd"),
    avg.time = "month"
)

# minor nox gap in and 2021
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^-3


#===============
#Set 21: Rural Wit Des####

# must use **read_csv()**
dat21 <- read_csv("aq_rural_wit_des.csv");
head(dat21)

timePlot(
    dat21, 
    pollutant = c("no", "no2", "nox","co", "benzene"), 
    avg.time = "month")

timePlot(
    dat21,
    pollutant = c("pm10", "toluene", "ws", "wd"),
    avg.time = "month"
)

# minor nox and toluene gap in late 2021,
# ws in m/s, wd in compass degrees
# all pollutants in ug/m^-3, except co in mg