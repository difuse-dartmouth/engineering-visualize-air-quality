####AQMET_data_extractor_all.R####

# Title: AQ and MET Data Pull and Export
# Project: ENGS 37 DIFUSE
# Author: Andy Bean '23
# Date: March 4, 2022, 10:00 AM

# This script will pull, clean, and export all data for the Air Quality Project
# as part of ENGS 37 for 22S in Berlin.
# Dartmouth College and Thayer School of Engineering, 2022
# DIFUSE Data Science Project


#=====================================================
####Procedure####

# First, identify a city location and search for a meteorological site there.
# If there is one, extract its data and refine aq sites using it's lat/long.
# Find the closest aq site possible and export that data also.
# Then pivot the aq data and left join it to the met data.
# Finally, eliminate unneccesary rows and export the data as a csv.

# If there is a met site in a city, it is acceptable to take multiple aq sites
# in that same city to make multiple data sets. Especially if those aq sites
# are looking at different parts of the city (background vs. traffic, etc.).

# Call Libraries
library(openair); #vis pkg
library(tidyverse); #helps vis pkg
library(worldmet); #met pkg
library(dplyr); #data manip fxns
library(saqgetr); #euro pkg

# Set Working Directory
setwd("/Users/abean/Documents/RStudio/DIFUSE E37");

# data for all sites and sort down to Germany
sites_dat <- get_saq_sites();
de_sites <- filter(sites_dat, country == 'germany');


#=====================================================
####Berlin (5 sites)####

# Look for met site in Berlin
# getMeta(lat = 52.54, lon = 13.34, returnMap = TRUE)
# *NOTE* this met site is currently missing years 2016 and 2018 and 2021, but 
# an earlier export obtained them.

# there is only one site for Berlin, so we'll take that 
berlin_met <- importNOAA(code = "103850-99999", year = 2014:2021);
cleaned_b_met <- select(berlin_met, station:air_temp);

# filter all aq sites to this location
# berlin_sites <- filter(de_sites, latitude > 52.3 & latitude < 52.5 & longitude > 13.4 & longitude < 13.6);

# extract aq data
# 1 choose Blankenfelde-Mahlow (closest, west of new airport)
bla_mah_dat <- get_saq_observations(
    site = "debb086",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

# 2 also take B Wedding-Amrumer Str. (east of old airport)
wed_amr_dat <- get_saq_observations(
    site = "debe010",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

# 3 also take B Schöneberg-Belziger Straße
sch_bel_dat <- get_saq_observations(
    site = "debe018",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

# 4 also take B Neukölln-Silbersteinstr
neu_sil_dat <- get_saq_observations(
    site = "debe063",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

# 5 also take B Friedrichshain-Frankfurter Allee (east berlin)
fri_fra_dat <- get_saq_observations(
    site = "debe065",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

# pivot aq data
pivoted_bla_mah <- bla_mah_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);
pivoted_wed_amr <- wed_amr_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);
pivoted_sch_bel <- sch_bel_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);
pivoted_neu_sil <- neu_sil_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);
pivoted_fri_fra <- fri_fra_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);

# append to met
aq_berlin_bla_mah <- left_join(cleaned_b_met, pivoted_bla_mah, by = "date");
aq_berlin_wed_amr <- left_join(cleaned_b_met, select(pivoted_wed_amr, -pm2.5, -benzene), by = "date"); 
aq_berlin_sch_bel <- left_join(cleaned_b_met, pivoted_sch_bel, by = "date");
aq_berlin_neu_sil <- left_join(cleaned_b_met, select(pivoted_neu_sil, -pm2.5), by = "date");
aq_berlin_fri_fra <- left_join(cleaned_b_met, select(pivoted_fri_fra, -pm2.5, -o3), by = "date");

#export
write.csv(aq_berlin_bla_mah,"aq_berlin_bla_mah.csv", row.names = TRUE);
write.csv(aq_berlin_wed_amr,"aq_berlin_wed_amr.csv", row.names = TRUE);
write.csv(aq_berlin_sch_bel,"aq_berlin_sch_bel.csv", row.names = TRUE);
write.csv(aq_berlin_neu_sil,"aq_berlin_neu_sil.csv", row.names = TRUE);
write.csv(aq_berlin_fri_fra,"aq_berlin_fri_fra.csv", row.names = TRUE);


#=====================================================
####Hannover (2 sites)####

# Look for met site in Hannover 52.3797932,9.6213879
# getMeta(lat = 52.38, lon = 9.62, returnMap = TRUE);

# another airport site for Hannover 
hannover_met <- importNOAA(code = "103380-99999", year = 2014:2021);
cleaned_h_met <- select(hannover_met, station:air_temp);

# filter all aq sites to this location
# hannover_sites <- filter(de_sites, latitude > 52.3 & latitude < 52.7 & longitude > 9.5 & longitude < 9.9);

# 1 take main background Hannover
hannover_dat <- get_saq_observations(
    site = "deni054",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

# 2 take urban Hannover at Verkehr
hannover_v_dat <- get_saq_observations(
    site = "deni048",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

#pivot, append, and export
pivoted_hannover <- hannover_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);
pivoted_hannover_v <- hannover_v_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);

aq_hannover_main <- left_join(cleaned_h_met, pivoted_hannover, by = "date");
aq_hannover_verk <- left_join(cleaned_h_met, pivoted_hannover_v, by = "date");

write.csv(aq_hannover_main,"aq_hannover_main.csv", row.names = TRUE);
write.csv(aq_hannover_verk,"aq_hannover_verk.csv", row.names = TRUE);

#=====================================================
####Leipzig (2 sites)####


# Look for met site in Leipzig 51.3419134,12.2535512
# getMeta(lat = 51.34, lon = 12.25, returnMap = TRUE);
# *NOTE* this met site is currently missing years 2015 and 2020 and 2021, but 
# an earlier export obtained them.

# another airport site for Leipzig 
leipzig_met <- importNOAA(code = "104690-99999", year = 2014:2021);
cleaned_l_met <- select(leipzig_met, station:air_temp);

# filter all aq sites to this location
# leipzig_sites <- filter(de_sites, latitude > 51.3 & latitude < 52.6 & longitude > 12.1 & longitude < 12.4);

# 1 take west background Leipzig
leipzig_west_dat <- get_saq_observations(
    site = "desn059",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

# 2 take mitte urban Leipzig
leipzig_mitte_dat <- get_saq_observations(
    site = "desn025",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

#pivot, append, and export
pivoted_l_west <- leipzig_west_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);
pivoted_l_mitte <- leipzig_mitte_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);

aq_leipzig_west <- left_join(cleaned_l_met, select(pivoted_l_west, -pm2.5), by = "date");
aq_leipzig_mitte <- left_join(cleaned_l_met, select(pivoted_l_mitte, -o3, -pm2.5), by = "date");

write.csv(aq_leipzig_west,"aq_leipzig_west.csv", row.names = TRUE);
write.csv(aq_leipzig_mitte,"aq_leipzig_mitte.csv", row.names = TRUE);

#=====================================================
####Munich (2 sites)####

# Look for met site in Munich 48.1524493,11.4163436
# getMeta(lat = 48.15, lon = 11.41, returnMap = TRUE);
# *NOTE* this met site is currently missing years 2016 and 2020, but an earlier
# export obtained them.

# another airport site for Munich 
munich_met <- importNOAA(code = "108644-99999", year = 2014:2021);
cleaned_m_met <- select(munich_met, station:air_temp);

# filter all aq sites to this location
# munich_sites <- filter(de_sites, latitude > 48.0 & latitude < 48.4 & longitude > 11.2 & longitude < 11.8);

# 1 take background Munich at Lothstraße 
munich_loth_dat <- get_saq_observations(
    site = "deby039",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

# 2 take Munich traffic at Stachus
munich_stac_dat <- get_saq_observations(
    site = "deby037",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

#pivot, append, and export
pivoted_m_loth <- munich_loth_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);
pivoted_m_stac <- munich_stac_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);

aq_munich_loth <- left_join(cleaned_m_met, pivoted_m_loth, by = "date");
aq_munich_stac <- left_join(cleaned_m_met, pivoted_m_stac, by = "date");

write.csv(aq_munich_loth,"aq_munich_loth.csv", row.names = TRUE);
write.csv(aq_munich_stac,"aq_munich_stac.csv", row.names = TRUE);

#========================================
####Hamburg (3 sites)####

# look for met site in Hamburg 53.5586526,9.64764
# getMeta(lat = 53.56, lon = 9.65, returnMap = TRUE);

# another airport site for Hamburg 
hamburg_met <- importNOAA(code = "101470-99999", year = 2014:2021);
cleaned_ham_met <- select(hamburg_met, station:air_temp);

# filter all aq sites to this location
# hamburg_sites <- filter(de_sites, latitude > 53.4 & latitude < 53.8 & longitude > 9.7 & longitude < 10.2);

# 1 take background Hamburg at Sternschanze 
hamburg_ste_dat <- get_saq_observations(
    site = "dehh008",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

# 2 take Hamburg traffic at Stresemannstraße
hamburg_str_dat <- get_saq_observations(
    site = "dehh026",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

# 3 take Hamburg industrial at Veddel
hamburg_ved_dat <- get_saq_observations(
    site = "dehh015",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

#pivot, append, and export
pivoted_ham_ste <- hamburg_ste_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);
pivoted_ham_str <- hamburg_str_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);
pivoted_ham_ved <- hamburg_ved_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);

aq_hamburg_ste <- left_join(cleaned_ham_met, pivoted_ham_ste, by = "date");
aq_hamburg_str <- left_join(cleaned_ham_met, select(pivoted_ham_str, -co, -benzene, -toluene), by = "date");
aq_hamburg_ved <- left_join(cleaned_ham_met, pivoted_ham_ved, by = "date");

write.csv(aq_hamburg_ste,"aq_hamburg_ste.csv", row.names = TRUE);
write.csv(aq_hamburg_str,"aq_hamburg_str.csv", row.names = TRUE);
write.csv(aq_hamburg_ved,"aq_hamburg_ved.csv", row.names = TRUE);


#========================================
####Cologne (2 sites)####

# look for met site in Cologne 50.8883624,6.8007287
# getMeta(lat = 50.88, lon = 6.80, returnMap = TRUE);

# the Cologne Bonn airport should do
cologne_met <- importNOAA(code = "105130-99999", year = 2014:2021);
cleaned_c_met <- select(cologne_met, station:air_temp);

# filter all aq sites to this location
# cologne_sites <- filter(de_sites, latitude > 50.6 & latitude < 51.0 & longitude > 6.9 & longitude < 7.3);

# 1 take background Cologne at Rodenkirchen 
cologne_rod_dat <- get_saq_observations(
    site = "denw059",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

# 2 take Cologne traffic at Turiner Straße
cologne_tur_dat <- get_saq_observations(
    site = "denw212",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

#pivot, append, and export
pivoted_col_rod <- cologne_rod_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);
pivoted_col_tur <- cologne_tur_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);

aq_cologne_rod <- left_join(cleaned_c_met, pivoted_col_rod, by = "date");
aq_cologne_tur <- left_join(cleaned_c_met, pivoted_col_tur, by = "date");

write.csv(aq_cologne_rod,"aq_cologne_rod.csv", row.names = TRUE);
write.csv(aq_cologne_tur,"aq_cologne_tur.csv", row.names = TRUE);


#========================================
####Dusseldorf (2 sites)####

# Already saw met site in Dusseldorf in search for Cologne
# getMeta(lat = 50.88, lon = 6.80, returnMap = TRUE);

# the Dusseldorf airport
dusseldorf_met <- importNOAA(code = "104000-99999", year = 2014:2021);
cleaned_d_met <- select(dusseldorf_met, station:air_temp);

# filter all aq sites to this location
#dusseldorf_sites <- filter(de_sites, latitude > 51.0 & latitude < 51.5 & longitude > 6.5 & longitude < 7.0);

# 1 take urban background Dusseldorf at Lorick
dussel_lor_dat <- get_saq_observations(
    site = "denw071",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

# 2 take Dusseldorf suburban background at Ratingen
dussel_rat_dat <- get_saq_observations(
    site = "denw078",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

#pivot, append, and export
pivoted_dus_lor <- dussel_lor_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);
pivoted_dus_rat <- dussel_rat_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);

aq_dusseldorf_lor <- left_join(cleaned_d_met, pivoted_dus_lor, by = "date");
aq_dusseldorf_rat <- left_join(cleaned_d_met, pivoted_dus_rat, by = "date");

write.csv(aq_dusseldorf_lor,"aq_dusseldorf_lor.csv", row.names = TRUE);
write.csv(aq_dusseldorf_rat,"aq_dusseldorf_rat.csv", row.names = TRUE);

#========================================
####Rural Germany (3 sites)####

# Look for a met site in a rural/forested area (nearer to Berlin) 
# 52.0060973,12.2697284
# getMeta(lat = 52.00, lon = 12.27, returnMap = TRUE);
# *NOTE* this met site is currently missing years 2015 and 2019, but an earlier
# export obtained them.

#Found the Holzdorf Airport
holzdorf_met <- importNOAA(code = "104760-99999", year = 2014:2021);
cleaned_hol_met <- select(holzdorf_met, station:air_temp);

# filter all aq sites to this location
# holzdorf_sites <- filter(de_sites, latitude > 51.0 & latitude < 52.5 & longitude > 12.5 & longitude < 14.0);

# 1 take Collemburg site (a little south, but very remote pollution data)
rural_col_dat <- get_saq_observations(
    site = "desn076",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

# 2 take Wittenburg Bahnstrasse background site, closer to met source
rural_wit_bah_dat <- get_saq_observations(
    site = "dest066",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

# 3 take Wittenburg Dessauer Strasse traffic site, closer to met source
rural_wit_des_dat <- get_saq_observations(
    site = "dest092",
    start = 2014,
    end = 2021,
    verbose = TRUE
);

#pivot, append, and export
pivoted_rur_col <- rural_col_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);
pivoted_rur_wit_bah <- rural_wit_bah_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);
pivoted_rur_wit_des <- rural_wit_des_dat %>% 
    saq_clean_observations(summary = "hour", valid_only = TRUE, spread = TRUE);

aq_rural_col <- left_join(cleaned_hol_met, select(pivoted_rur_col, -pm2.5), by = "date");
aq_rural_wit_bah <- left_join(cleaned_hol_met, pivoted_rur_wit_bah, by = "date");
aq_rural_wit_des <- left_join(cleaned_hol_met, pivoted_rur_wit_des, by = "date");

write.csv(aq_rural_col,"aq_rural_col.csv", row.names = TRUE);
write.csv(aq_rural_wit_bah,"aq_rural_wit_bah.csv", row.names = TRUE);
write.csv(aq_rural_wit_des,"aq_rural_wit_des.csv", row.names = TRUE);

#===
# END ####
#===