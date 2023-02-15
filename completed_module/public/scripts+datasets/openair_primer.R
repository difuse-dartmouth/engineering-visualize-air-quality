####openair_primer.R####

# Title: Openaur Primer
# Project: ENGS 37 DIFUSE
# Author: Andy Bean and Monika Roznere
# Date: Mar 3, 2022

# This script will introduce the basic functions in the openair R package.
# We will be using a dataset from the UK.
# Dartmouth College and Thayer School of Engineering, 2022

#=====================================================

#Install openair if not done so
# install.packages("openair")

library(openair) # vis pkg
library(tidyverse) # helps vis pkg


## Load Data

data <- importAURN(site = "my1", year = 2000:2005)

# If you do not want to load data from an R package, you may load data directly from your computer.
# Uncomment the last line in block.
# In this case, the provided "intro_dataset.csv" has tab delimited values, so the command is read.delim().
# A window should pop up - navigate to the file "intro_dataset.csv" and select it.
# file.choose() prompts pop-up window for file selection.
# data <- read.csv(file.choose())


## Time Plot

timePlot(data)
timePlot(data, 
         pollutant = c("no", "no2", "nox", "o3"), 
         avg.time = "month",
         main="Title")

# How to add a title to the plot
? timePlot
timePlot(data, 
         pollutant = c("no", "no2", "nox", "o3"), 
         avg.time = "month")


## Wind Rose

? windRose
windRose(data)

# One way to check if windspeed is ever 0.
timePlot(data, pollutant = c("ws"), avg.time = "month")

windRose(data, type = "year", layout = c(3, 2))
windRose(data, type = "pm10", layout = c(3, 2))


## Pollution Rose

? pollutionRose
pollutionRose(data)
pollutionRose(data, pollutant = "no")
pollutionRose(data, pollutant = "no", type = "no2", layout = c(4, 1))
pollutionRose(data, pollutant = "nox", seg = 1, normalise = TRUE)

# Make a pollution rose for only the year 2002 that is tracking the level of pm10
data2 <- importAURN(site = "my1", year = 2003)
pollutionRose(data2, pollutant="pm10")
# or...
pollutionRose(selectByDate(data, year = 2003), pollutant="pm10")


## Calendar Plot

calendarPlot(data)
calendarPlot(data, annotate = "ws")

#  Make a calendar plot for just the year 2003 tracking nitrous oxide only
calendarPlot(data2, pollutant="no")
# or...
calednarPlot(selectByDate(data, year=2003), pollutant="no")


## Polar Annulus

? polarAnnulus
polarAnnulus(data, poll = "nox", period = "season", main = "Season")
polarAnnulus(data, poll = "nox", period = "weekday", main = "Weekday")
polarAnnulus(data, poll = "nox", period = "hour", main = "Hour")


## Scatter Plot

# scatterPlot(data, x = "...", y = "...")
# Use the command scatterPlot to compare “no” on the x axis and “nox” on the y axis.
? scatterPlot
scatterPlot(data, x="no", y="nox")

data2000 <- selectByDate(data, year = 2000)
scatterPlot(data2000, x="no", y="nox")
scatterPlot(data2000, x="no", y="nox", method="hexbin", col="jet")
