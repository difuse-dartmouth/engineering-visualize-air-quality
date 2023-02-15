####more_on_openair.R####

# Title: More on Openair
# Project: ENGS 37 DIFUSE
# Author: Andy Bean and Monika Roznere
# Date: Feb 17, 2022

# This script will step through a variety of standard and advanced openair plot
# functionalities. It will use the same simple dataset from the UK as before.
# Please try out these examples with the dataset from your Germany site.
# Dartmouth College and Thayer School of Engineering, 2022

#=====================================================

library(openair);
library(tidyverse);

dat <- importAURN(site = "my1", year = 2000:2005);

### WIND ROSE
# plot a windrose for everything
windRose(dat)

# plot by year
windRose(dat, type = "year", layout = c(3, 2))

# plot by pm10 (the type function is useful!)
windRose(dat, type = "pm10", layout = c(3, 2))


### POLLUTION ROSE
# basic example for nox
pollutionRose(dat, pollutant = "nox")

# link with s02 using type
pollutionRose(dat, pollutant = "nox", type = "so2", layout = c(4, 1))

# segment and normalize
# seg = 1 removes the spaces between the bars
# normalize makes the length of all bars the same to see pollutant proportions more clearly
pollutionRose(dat, pollutant = "nox", seg = 1, normalise = TRUE)


### POLAR FREQUENCIES
# basic example, a more detailed wind description
polarFreq(dat)

# bin by year
polarFreq(dat, type = "year")

# add pollutant
# we can see in detail how high concentrations came from SE in 2000, but moved north and decreased in frequency starting in 2003
polarFreq(dat, type = "year", pollutant = "pm10", statistic = "mean", min.bin = 2)


### PERCENTILE ROSE
#basic example, the concentrations of the pollutant are marked on the rings and the percentiles are shaded
percentileRose(dat, pollutant = "pm10")

#can also customize the percentiles and smooth the plot
#we see the pm10 is pretty even from all directions
percentileRose(dat, pollutant = "pm10", percentile = c(25, 50, 75, 90, 95, 99), col = "jet", smooth = TRUE)


### POLAR PLOTS
# basic polar plot
# so we see that there is only a high concentration from the SW when the wind speed is higher than usual
polarPlot(dat, pollutant = "pm10")


### POLAR ANNULUS
polarAnnulus(dat, poll = "pm10", period = "season", main = "Season")
polarAnnulus(dat, poll = "pm10", period = "weekday", main = "Weekday")
polarAnnulus(dat, poll = "pm10", period = "hour", main = "Hour")


### TIME SERIES PLOTS
# plot the values of pollutants over time
timePlot(dat,
         pollutant = c("nox", "o3", "pm2.5", "pm10", "ws"),
         y.relation = "free")

# in a more specific time
timePlot(selectByDate(dat, year = 2002, month = "aug"),
         pollutant = c("nox", "o3", "pm2.5", "pm10", "ws"),
         y.relation = "free")

# with averaging
timePlot(dat, pollutant = c("o3", "no2"), avg.time = "month", y.relation = "free")


### TEMPORAL VARIATION PLOTS
# time var with normalization
timeVariation(dat, 
              pollutant = c("nox", "co", "no2", "o3"), 
              normalise = TRUE)

# time var splitting by date
dat1 <- splitByDate(dat, dates= "1/1/2003",
                    labels = c("before Jan. 2003", "After Jan. 2003"))
timeVariation(dat1, pollutant = "pm10", 
              group = "split.by", 
              difference = TRUE)

# Can also make greater CIs or group by a new feature that you determine


### TIME PROP PLOTS
# break down so2 by proportion contribution from wind direction
timeProp(selectByDate(dat, year = 2003),
         pollutant = "no2", avg.time = "7 day",
         proportion = "wd", date.breaks = 10, key.position = "top",
         key.columns = 4, ylab = "no2 (ug/m3)")

# break down by wind speed instead
timeProp(selectByDate(dat, year = 2003),
         pollutant = "no2",
         avg.time = "7 day",
         n.levels = 3,
         cols = "viridis",
         proportion = "ws", date.breaks = 10,
         key.position = "top", key.columns = 3,
         ylab = "no2 (ug/m3)")


### TREND LEVEL HEAT MAP
# Trendlevel makes a heatmap by two variables x and y. By default it is month x and hour y
trendLevel(dat, pollutant = "nox", cols = "viridis")

# With wind direction as y
trendLevel(dat, pollutant = "nox", y = "wd", 
           border = "white", 
           cols = "viridis")

# or with one pollutant as x and another as y
trendLevel(dat, x = "nox", y = "no2", pollutant = "o3", 
           border = "white", cols = "viridis",
           n.levels = 30, statistic = "max", 
           limits = c(0, 50))


### CALENDAR PLOT
# basic calendar plot
calendarPlot(dat, pollutant = "o3", year = 2003)

# annotate with the wind direction
calendarPlot(dat, pollutant = "o3", year = 2003, annotate = "ws")

# can add averaging functions or specific binning fxns


### THEIL-SEN TRENDS# basic t_s
TheilSen(dat, pollutant = "o3", 
         ylab = "ozone (ppb)", 
         deseason = TRUE,
         date.format = "%Y")

# can be typed by wd
TheilSen(dat, pollutant = "o3", type = "wd", 
         deseason = TRUE,
         date.format = "%Y",
         ylab = "ozone (ppb)")


### SMOOTH TREND
# smooth trend that might not be a straight line
smoothTrend(dat, pollutant = "o3", ylab = "concentration (ppb)",
            main = "monthly mean o3")

# deseasonalized (removing the effects of the seasonal cycle)
smoothTrend(dat, pollutant = "o3", deseason = TRUE, ylab = "concentration (ppb)",
            main = "monthly mean deseasonalised o3")

# with type by wind direction
smoothTrend(dat, pollutant = "o3", deseason = TRUE,
            type = "wd")


### SCATTER PLOTS
# creating some basic and higher level scatter plots
# this is basic R scatter plot, looks nicer in ggplot2
data2003 <- selectByDate(dat, year = 2003)
scatterPlot(data2003, x = "nox", y = "no2")

# hex binning and shading
scatterPlot(data2003, x = "nox", y = "no2", method = "hexbin", col= "jet")

# further specs by density, linear fit, and grouping
# can also add z variable which is heatmapped

# grouping example. o3 is in shading, x and y are nox and no2, and there are charts for weekend/weekday and also season
scatterPlot(data2003, 
            x = "nox", y = "no2", z = "o3", 
            type = c("season", "weekend"),
            limits = c(0, 30))
