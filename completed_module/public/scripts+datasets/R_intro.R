####R_intro.R####

# Title: Introduction to R and RStudio
# Project: ENGS 37 DIFUSE
# Author: Monika Roznere and Andy Bean
# Date: Feb 9, 2022

# This script will step through loading and manipulating simple air quality data
# to get you familiar with basic R commands.
# Dartmouth College and Thayer School of Engineering, 2022

#=====================================================

## Load Data

# Load a small air quality data file provided by R.
# We are creating a dataframe named "air_quality_data" that is a list of vectors of the same length that are related across.
# Read the arrow <- as "gets".
air_quality_data_full <- airquality

# If you do not want to load data from an R package, you may load data directly from your computer.
# Uncomment the last line in block.
# In this case, the provided "intro_dataset.csv" has tab delimited values, so the command is read.delim().
# A window should pop up - navigate to the file "intro_dataset.csv" and select it.
# file.choose() prompts pop-up window for file selection.
# air_quality_data_full <- read.csv(file.choose())


## Basic Data Info

# Prints the entire dataframe in the Console.
air_quality_data_full
# lists the column names for you
colnames(air_quality_data_full)
# str() gives # rows, # columns (variables), and the object (modeling) type of each variable.
str(air_quality_data_full)
# head() shows the first 6 rows of data.
head(air_quality_data_full)
# length() gives # rows, $ notation denotes column.
length(air_quality_data_full$Ozone)


## Taking a Subset of Data

# We will only be using 2 variables (Ozone and Month).
# Thus, we will take this subset:
air_quality_data <- subset(air_quality_data_full, select=c(Ozone, Month))

# One can also choose the columns by what you do not want included:
# air_quality_data <- subset(air_quality_data_full, select=-c(Wind, Solar.R, Temp, Day))


## Verifying Data

colnames(air_quality_data)

air_quality_data
str(air_quality_data)
head(air_quality_data)

## Histograms

help(hist)

# The default histogram in R:
hist(air_quality_data$Ozone)

# To save the graph, click "Export/Save as Image..." in the 'Plots' window. Or save as PDF.

# When you make a figure, you will always want to modify the graphical parameters from the default settings.
# Here we remove the main title and change the label on the x-axis.
hist(air_quality_data$Ozone, xlab="ppb", main="")
hist(air_quality_data$Ozone, xlab="ug/L", main="")
# To make the notation prettier.
hist(air_quality_data$Ozone, xlab=expression(paste(mu,"g/",L)), main="")
micrograms_per_liter <- expression(paste(mu,"g/",L)) # Can correspond the expression (value) to a variable name.

# Changing the number of bins in a histogram: 
# R determines the number of bins (or breaks) to put in a histogram that makes it look "prettiest" using something called the Sturges method.
# Alternatively, you can tell R how many bins you would like it to create:
hist(air_quality_data$Ozone, xlab="ppb", main="", breaks=22)
hist(air_quality_data$Ozone, xlab="ppb", main="", breaks=5)

# Notice that you can change the look of the histogram by changing the range of values shown on the x-axis:
hist(air_quality_data$Ozone, xlab="ppb", main="", breaks=22, xlim=c(0,200))

# But we really want a histogram of Ozone for each month. There are lots of different ways to accomplish this.
# First, the brute force method:
# Note, brackets index values are inclusive.
air_quality_data$Ozone[1:31] # Compare these values printed to console with the air_quality_data table.
hist(air_quality_data$Ozone[1:31], xlab="ppb", main="May")
hist(air_quality_data$Ozone[32:61], xlab="ppb", main="June")
hist(air_quality_data$Ozone[62:92], xlab="ppb", main="July")
hist(air_quality_data$Ozone[93:123], xlab="ppb", main="August")
hist(air_quality_data$Ozone[124:153], xlab="ppb", main="September")

air_quality_data$Month==5

# Using logical selection
hist(air_quality_data$Ozone[air_quality_data$Month==5], xlab="ppb", main="May")

# Next, let's try using a package to accomplish the same thing using a formula:
install.packages("lattice") 
library(lattice)

? histogram

histogram(~ Ozone | Month, data=air_quality_data)
histogram(~ Ozone | Month, data=air_quality_data, type="count") # Notice the difference?

#This is great for quickly looking at the data, but what if you want to change the look of the graphic before putting it in your write-up?
# Let's build up a graphic from scratch. R is awesome for producing publication-ready graphics.
# As a result, the number of graphical parameters you can control is overwhelming. 
? par

# Now we will set some graphical parameters ourselves.
# Build the figure we want:
par(mfrow=c(5,1), mar=c(4,2,2,2)+0.01, oma=c(2,2,0,0))
hist(air_quality_data$Ozone[1:31], xlab="", main="May", xlim=c(0,200))
hist(air_quality_data$Ozone[32:61], xlab="", main="June", xlim=c(0,200))
hist(air_quality_data$Ozone[62:92], xlab="", main="July", xlim=c(0,200))
hist(air_quality_data$Ozone[93:123], xlab="", main="August", xlim=c(0,200))
hist(air_quality_data$Ozone[124:153], xlab="", main="September", xlim=c(0,200))
mtext("ppb", 1, outer=TRUE, cex=1.5)
mtext("Frequency", 2, outer=TRUE, cex=1.5)


## Boxplots

# If you are having trouble plotting the boxplot due to the previous par window formatting, run this:
par(mfrow=c(1,1), mar=c(4,2,2,2)+0.01, oma=c(2,2,0,0))

boxplot(air_quality_data$Ozone, ylab="ppb", main="")
boxplot(air_quality_data$Ozone ~ air_quality_data$Month, xlab="Month", ylab="ppb")
# A neat trick:
points(air_quality_data$Month, air_quality_data$Ozone, col="red", cex=0.5)


## Numeric summaries

by(air_quality_data$Ozone, air_quality_data$Month, summary)


## Data Clean-Up

# nas <- is.na(air_quality_data)
# Returns a logical array of TRUEs where NAs are in the original set.
# New array is same size as data

# To remove rows of data that includes NA values:
air_quality_data_cleaned <- air_quality_data[complete.cases(air_quality_data), ]
air_quality_data_cleaned
hist(air_quality_data_cleaned$Ozone)


## Tidyverse Examples

install.packages("tidyverse")
install.packages("ggplot2")
library(tidyverse)
library(ggplot2)

# Histogram

qplot(air_quality_data$Ozone,
      geom = "histogram", # graph type
      binwidth = 3, # bin size
      main = "Histogram of Ozone", # figure title
      xlab = "ppb", # label for x axis
      fill = I("green"), # fill color
      col = I("black"), # outline color
      alpha = I(.5), # fill transparency (between 0-see through and 1-opaque)
      xlim = c(0, 200)) # x axis range

ggplot(data = air_quality_data, aes(air_quality_data$Ozone)) +
  geom_histogram(breaks = seq(0, 200, by = 3),
                 col = "black",
                 aes(fill = ..count..)) +
  scale_fill_gradient("Count", low = "green", high = "red")+
  labs(title = "Histogram of Ozone", x = "ppb", y = "Count")

multi <- air_quality_data %>% #tidyverse's "piping" functionality with "%>%"
  ggplot(aes(x = Ozone, color = Month, fill = Month)) +
  geom_histogram(alpha = 0.5, binwidth = 3) +
  theme(legend.position = "none") +
  xlab("") +
  ylab("ppb") +
  facet_wrap(~Month)
multi

# Boxplot

outliboxplot <- air_quality_data %>%
  ggplot(aes(x = Month, y = Ozone, fill = Month)) +
  geom_boxplot(outlier.color = "black", outlier.shape = 8, outlier.size = 2) + # outlier boxplot
  stat_summary(fun = mean, geom = "point", shape = 23, size = 4) # add mean diamond
outliboxplot

dotnboxplot <- air_quality_data %>%
  ggplot(aes(x = Month, y = Ozone)) + 
  geom_boxplot() + 
  geom_jitter(color = "black", size = 0.9, alpha = 0.8) +
  theme(panel.border = element_blank(),
        panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line(color = "black"))
dotnboxplot

# Numeric summaries

? summarise

# To remove instances of NAs, as the following function calls will not work properly.
air_quality_data_cleaned <- air_quality_data[complete.cases(air_quality_data), ]

air_quality_data_cleaned %>%
  group_by(Month) %>%
  summarise(count = n(),
            df = count-1,
            mean = mean(Ozone),
            sd = sd(Ozone))

air_quality_data_cleaned %>%
  group_by(Month) %>%
  summarise(count = n(),
            df = count-1,
            min = min(Ozone),
            Q1 = quantile(Ozone, 0.25),
            M = median(Ozone),
            Q3 = quantile(Ozone, 0.75),
            max = max(Ozone))


#===
# END ####
#===
