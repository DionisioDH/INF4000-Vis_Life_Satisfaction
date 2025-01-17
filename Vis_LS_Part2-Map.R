###################################################################################
# 
# Project                     : Characteristics and Patterns of the Top and Bottom 10% of Areas in England by Life Satisfaction
# Author                      : Dionisio V. Del Orbe H.
# Purpose of this file        : Plot map of England's satisfaction (top and bottom 10%)
# Output data.frame           : N/A
# Output image                : Yes, panel A
# Pre-run another .R file?    : Yes, part 1 code.  
#
###################################################################################

################################################
### 0. Loading Packages used in this .R file ###
################################################

# Note: must use "install.packages(name_package)" for packages not installed

library(ggthemes)   # function: theme_map()     --> theme for plotting map

########################################################
### 6. Adding top and bottom 10% of life satisfaction ##
########################################################

top10_quantile <- quantile(Indicators_merged7$satisfaction, 0.9, na.rm = TRUE)
bottom10_quantile <- quantile(Indicators_merged7$satisfaction, 0.1, na.rm = TRUE)


Indicators_merged7 <- Indicators_merged7 |>
  mutate(satisfaction_top_bottom = case_when( 
    satisfaction < bottom10_quantile ~ "Bottom 10%",
    satisfaction > top10_quantile  ~ "Top 10%",
    .default =  "Other Areas")) 

Indicators_merged7$satisfaction_top_bottom <- factor(Indicators_merged7$satisfaction_top_bottom, 
                                                     ordered = TRUE, 
                                                     levels = c("Top 10%", "Other Areas", "Bottom 10%"))

View(
  Indicators_merged7 |>
    select(ltla22cd, satisfaction, satisfaction_top_bottom) |>
    arrange(satisfaction)
)

View(
  Indicators_merged7 |>
    group_by(satisfaction_top_bottom) |> 
    summarise(n())
) # 29 in bottom 10% & 29 in top 10%


Indicators_merged7_withOtherAreas <- Indicators_merged7




##############################################################
### 7. loading "LAD boundaries" data set for plotting map  ###
##############################################################

#7.1 loads geographic coordinates of boundaries of LADs
LADs_boundaries <- st_read("Data/Local_Authority_Districts.geojson") #374 rows (all of UK)
LADs_boundaries <- LADs_boundaries |> filter(!grepl("^(W|S|K|N)", LAD22CD)) # 309 rows (only England)

#7.2 Joining map coordinates with indicators frame:
# left_join used to keep all boundary definitions for plotting
Map_Indicators_merged <- LADs_boundaries |>
  left_join(Indicators_merged, by= c("LAD22CD"="LAD_codes"))# 309 rows


##################################################
### 1. Computation of top and bottom 10% areas ###
##################################################


##################################################################
### 2. Plotting map of areas below and above life sat. average ###
##################################################################

#2.1 Adding column with % difference of Life Satisfaction from national average
# Note: for 2017 life sat avg in England was 7.68 (obtained from: 
# https://explore-local-statistics.beta.ons.gov.uk/indicators/wellbeing-satisfaction

Map_Indicators_merged <- Map_Indicators_merged |>
  mutate(Sat_perc_above_below_avg = (satisfaction-7.68)/7.68*100)

#2.2 Plotting the map:

Map_Indicators_merged |>
  ggplot()+
  geom_sf(aes(fill= Sat_perc_above_below_avg), color = "darkgray", lwd = 0.5) +
  labs(fill = "Life Satisfaction\n\n(% difference\n from national\naverage)\n") +
  # this is a 3 color gradient below:
  scale_fill_gradient2(midpoint=0, low= "#FF6347",
                       mid='lightgray', high= "#4682B4",
                       na.value = "white")+
  theme_map() +
  theme(
    legend.position = c(.05, 0.35),       
    legend.background = element_rect(fill = "transparent"),  
    legend.title = element_text(size = 16.5, hjust = 0.5, lineheight = 0.75), 
    legend.text = element_text(size = 16.5)   
  )+
  annotate(
    "point",
    x = 0.30, y = 51.35, 
    shape = 21,         
    size = 58,          
    color = "#7A7A7A",    
    fill = NA,         
    stroke = 1.12        
  ) + 
  # Arrow pointing towards the circle
  annotate(
    "segment",
    x = 1.9, y = 51.8 ,          
    xend =1.5 , yend = 51.6, 
    arrow = arrow(length = unit(0.35, "cm")),
    color = "#7A7A7A",         
    size = 0.73                 
  ) + 
  annotate(
    "segment",
    x = 1.9, y = 51.8 ,          
    xend =1.9 , yend = 53.5, 
    color = "#7A7A7A",        
    size = 0.73               
  )+  
  geom_text(
    data = data.frame(x = 0.55, y = 53.44, label = "Cluster of\nareas below\naverage"),
    aes(x = x, y = y, label = label),
    hjust = 0,
    vjust = 0,
    size = 5.7, 
    lineheight = 0.8, 
    color = "black"
  )

################################
### 3. Clearing environment  ###
################################

# clears environment (deletes variables not used in subsequent .R files)
rm(list = setdiff(ls(), c("Indicators_merged")))