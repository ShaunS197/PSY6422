# Set-up (Installing relevant libraries)
library(tidyverse)
library(ggplot2)
install.packages("RColorBrewer")
library(RColorBrewer)
library(here)
# Loading the chosen data-set
data_org <- read_csv(here("data/AltProt.csv"))

# Inspecting the data-set 
View(data_org)

# Tidying the loaded data set
# Dropping columns using select(), removing missing values using drop_na(), renaming columns using rename(), converting numeric to factor variables using mutate_at(), creating new columns using mutate()
data_tidy <- data_org %>% select(-c(23:162)) %>% drop_na() %>% rename("gender" = "DMQ_RESP_GENDER", "age_grp" = "DMQ_RESP_AGE_RECODED", "region" = "DMQ_REGION", "house_size" = "DMQ_HHCMP10", "kids" = "DMQ_KIDS02", "edu" = "DMQ_UK02EDU", "marital_stat" = "DMQ_UK01MAR", "income" = "DMQ_UK02INC", "ethnicity" = "DMQ_UK02ETH", "work_stat" = "DMQ_EMP01", "soc_grade" = "DMQ_UK01SG_RECODED", "awareness_insect" = "Q2089090438Edibleinsects", "awareness_labmeat" = "Q2089090438Labgrownmeatsometimesreferredtoasculturedmeatorcu", "awareness_plprot" = "Q2089090438Plantbasedproteins", "safety_plprot" = "Q2011120850", "safety_insect" = "Q2055782931", "safety_labmeat" = "Q2021612575", "willingness_labmeat" = "Q2018263715Labgrownmeatsometimesreferredtoasculturedmeatorcu", "willingness_insect" = "Q2018263715Edibleinsectsegmealwormsgrasshoppers", "willingness_plprot" = "Q2018263715Plantbasedproteinsegsoyhempseedquinoa", "replacement_ground" = "Q2079418049Groundintoafoodforaddedproteinegbreadburgersfalaf", "replacement_sweet" = "Q2079418049Madeintosweetsorjellies", "replacement_beverage" = "Q2079418049Madeintobeveragesegsportsdrinksproteinshakes", "replacement_meal" = "Q2079418049Amealorproteinreplacement")%>% mutate(tot_aware = awareness_insect+awareness_labmeat+awareness_plprot) %>% mutate(tot_safety = safety_plprot+safety_insect+safety_labmeat) %>% mutate(tot_willingness = willingness_labmeat+willingness_insect+willingness_plprot)
# Remove Northern Ireland from the data-set 
table(data_tidy$region)
data_tidy <- subset(data_tidy, region < 11)
# Converting numeric variables to factors 
data_tidy$gender <- cut(
  data_tidy$gender, 2, labels = c(
    'Male', 
    'Female'))
data_tidy$age_grp <-  cut(
  data_tidy$age_grp, 6, labels = c(
    '16-24', 
    '25-34',
    '35-44',
    '45-54',
    '55-64',
    '65-75'))
data_tidy$region <- cut(data_tidy$region, 10, labels = c('North East', 'North West', 'Yorkshire and The Humber', 'West Midlands', 'East Midlands', 'East of England','South West', 'South East', 'London', 'Wales'))

# Making a new column for region names as a char variable 
data_tidy$region <- as.character(data_tidy$region)
str(data_tidy)
data_tidy$edu <- cut(data_tidy$edu, 7, labels = c('Primary school', 'Secondary school (age under 15 years old)', 'GNVQ / GSVQ / GCSE/ SCE standard', 'NVQ1, NVQ2', 'NVQ3/ SCE Higher Grade/ Advanced GNVQ/ GCE A/AS or similar', 'NVQ4 / HNC / HND / Bachelors degree or similar','NVQ5 or post-graduate diploma'))
data_tidy$income <- cut(
  data_tidy$income, 11, labels = c(
    'Under £5,000', 
    '£5,000 - 9,999', 
    '£10,000 - 14,999', 
    '£15,000 - 19,999', 
    '£20,000 - 24,999', 
    '£25,000 - 34,999',
    '£35,000 - 44,999', 
    '£45,000 - 54,999', 
    '£55,000 - 99,999', 
    '£100,000 or more', 
    'Prefer not to answer'))
table(data_tidy$ethnicity)
data_tidy$ethnicity <- cut(
  data_tidy$ethnicity, 24, labels = c(
    'White', 'White', 'White', 'White', 'White', 'Mixed or multiple ethnic groups','Mixed or multiple ethnic groups', 'Mixed or multiple ethnic groups',  'Mixed or multiple ethnic groups', 'Mixed or multiple ethnic groups', 'Asian or Asian British', 'Asian or Asian British', 'Asian or Asian British', 'Asian or Asian British', 'Asian or Asian British','Asian or Asian British', 'Black, Black British, Caribbean or African', 'Black, Black British, Caribbean or African', 'Black, Black British, Caribbean or African', 
    'Black, Black British, Caribbean or African', 'Other ethnic group', 'Other ethnic group', 'Other ethnic group', 'Other ethnic group'))
str(data_tidy$ethnicity)

## Creating a map (Attempt no 1)
worldmap <- map_data('world')
ggplot()+geom_polygon(data = worldmap, aes( x = long, y = lat, group = group))+coord_fixed(ratio = 1.3, xlim = c(-10,3), ylim = c(50.3, 59))

## Creating a map (Attempt no 2)
#Installing relevant libraries 
library(rgdal)
 
setwd("C:\\Users\\solom\\Documents\\University of Sheffield\\Semester 2\\Data Management and Visualisation\\Assignments\\Final Assignment")

#shp <- readOGR(here("data", "ew_rgn_2022_bgc.shp"))
#shp <- readOGR('data/ew_rgn_2022_bcg.shp')

#gdal.SetConfigOption('SHAPE_RESTORE_SHX', 'YES')
#shp <- read_sf(here("data", "ew_rgn_2022_bgc.shp"), SHAPE_RESTORE_SHX)

shp_new <- readOGR(dsn= "C:\\Users\\solom\\Documents\\University of Sheffield\\Semester 2\\Data Management and Visualisation\\Assignments\\Final Assignment\\data\\Ew_rgn_2022_bgc\\ew_rgn_2022_bgc.shp", layer = "ew_rgn_2022_bgc")

shp_1 <- readOGR(here("data/Ew_rgn_2022_bgc/ew_rgn_2022_bgc.shp"))
shp_2 <- fortify(shp_1, region = "name")
shp_3 <- rename(shp_2, "region" = "id")
#shp <- fortify(shp, region = 'name')
#table(shp$id)

# Merging the two dataframes 

shp_new1 <- shp_3 %>% left_join(data_tidy, by = c('region'), multiple = "all")

shp_new1 <- arrange(shp_new1, order)  
 
 



p <- ggplot(data = shp_new1, aes(x = long, y = lat, group = group, fill = tot_willingness), alpha = 0.9)  
p + geom_polygon() + coord_equal() + theme_void() +
  ggtitle('Willingness to Consume Alternative Proteins across Regions',
          subtitle = 'England and Wales, 2022')+labs(fill="Willingness(Scale 0-20)") 
install.packages("viridis")
library(viridis)

p + geom_polygon() + coord_equal() + theme_void()  +
  scale_fill_viridis(trans = "log", breaks=c(1,4,8,12,16,20), name="Willingness", guide = guide_legend( keyheight = unit(3, units = "mm"), keywidth=unit(12, units = "mm"), label.position = "bottom", title.position = 'top', nrow=1) ) +
  labs(
    title = "Willingness to Consume Alternative Proteins",
    subtitle = "England and Wales",
    caption = "Data: Food Standards Agency| Creation: Shaun Solomon"
  ) + theme(
    text = element_text(color = "#22211d"),
    plot.background = element_rect(fill = "#f5f5f2", color = NA),
    panel.background = element_rect(fill = "#f5f5f2", color = NA),
    legend.background = element_rect(fill = "#f5f5f2", color = NA),
    
    plot.title = element_text(size= 22, hjust=0.01, color = "#4e4d47", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
    plot.subtitle = element_text(size= 17, hjust=0.01, color = "#4e4d47", margin = margin(b = -0.1, t = 0.43, l = 2, unit = "cm")),
    plot.caption = element_text( size=12, color = "#4e4d47", margin = margin(b = 0.3, r=-99, unit = "cm") ),
    
    legend.position = c(0.7, 0.09)
  )  

p + geom_polygon() + coord_equal() + theme_void()  +
  scale_fill_viridis(name="Willingness", guide = guide_legend( keyheight = unit(3, units = "mm"), keywidth=unit(12, units = "mm"), label.position = "bottom", title.position = 'top', nrow=1) ) +
  labs(
    title = "Willingness to Consume Alternative Proteins",
    subtitle = "England and Wales",
    caption = "Data: Food Standards Agency| Creation: Shaun Solomon"
  ) + theme(
    text = element_text(color = "#22211d"),
    plot.background = element_rect(fill = "#f5f5f2", color = NA),
    panel.background = element_rect(fill = "#f5f5f2", color = NA),
    legend.background = element_rect(fill = "#f5f5f2", color = NA),
    
    plot.title = element_text(size= 22, hjust=0.01, color = "#4e4d47", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
    plot.subtitle = element_text(size= 17, hjust=0.01, color = "#4e4d47", margin = margin(b = -0.1, t = 0.43, l = 2, unit = "cm")),
    plot.caption = element_text( size=12, color = "#4e4d47", margin = margin(b = 0.3, r=-99, unit = "cm") ),
    
    legend.position = c(0.7, 0.09)
  )  


par(mfrow = c(1, 2))
p1 <- ggplot(data = shp_new1, aes(x = long, y = lat, group = group, fill = tot_safety), alpha = 0.9)
p1 + geom_polygon() + coord_equal() + theme_void() +
  ggtitle('Perceived Safety of Consumption of Alternative Proteins across Regions',
          subtitle = 'England and Wales, 2022')+labs(fill="Perceived Safety")
p <- ggplot(data = shp_new1, aes(x = long, y = lat, group = group, fill = tot_willingness), alpha = 0.9)  
p + geom_polygon() + coord_equal() + theme_void() +
  ggtitle('Willingness to Consume Alternative Proteins across Regions',
          subtitle = 'England and Wales, 2022')+labs(fill="Willingness(Scale 0-20)") 

ggplot(data_tidy, aes(x = region, y = tot_safety)) + geom_boxplot()
ggplot(data_tidy, aes(x = region, y = tot_willingness)) + geom_boxplot()
data_tidy_sorted <- data_tidy %>% mutate(region = fct_reorder(region, -tot_safety))
ggplot(data_tidy_sorted, aes(x = region, y = tot_safety)) + geom_boxplot() + coord_flip() + scale_y_continuous(limits = c(0,20))
 
theme_set(theme_light(base_size = 18, base_family = "Poppins"))

g <-
  ggplot(data_tidy_sorted, aes(x = ethnicity, y = tot_safety, color = ethnicity)) +
  coord_flip() +
  scale_y_continuous(limits = c(0, 20), expand = c(0.02, 0.02)) +
  scale_fill_viridis(option = "inferno") +
  labs(x = NULL, y = "Perceived Safety") +
  theme(
    legend.position = "none",
    axis.title = element_text(size = 16),
    axis.text.x = element_text(size = 12),
    panel.grid = element_blank()
  )

g1 <- ggplot(data_tidy_sorted, aes (x = region, y = tot_safety, color = region))
coord_flip()+scale_y_continuous(limits = c(0, 20), expand = c(0.02, 0.02)) + scale_fill_viridis(option = "inferno")

g+geom_jitter(size = 3, alpha = 0.15, width =0.2) + stat_summary(fun = mean, geom = "point", size = 5)

ethnicity_average <- data_tidy_sorted %>% summarize(avg = mean(tot_safety, na.rm = TRUE)) %>% pull(avg)

g+geom_hline(aes(yintercept = region_average), color = "gray70", size = 0.6)+ stat_summary(fun = mean, geom = "point", size = 5)+geom_jitter(size = 3, alpha = 0.15, width =0.2) 

table(data_tidy$region, data_tidy$ethnicity)
