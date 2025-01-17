###################################################################################
# 
# Project                     : Characteristics and Patterns of the Top and Bottom 10% of Areas in England by Life Satisfaction
# Author                      : Dionisio V. Del Orbe H.
# Purpose of this file        : Plot map of England's satisfaction (top and bottom 10%)
# Output data.frame           : "Indicators_merged" (updated)
# Output image                : Panel A (export dimensions: width: 1000 Height: 834)
# Pre-run another .R file?    : Yes, part 1 code.  
#
###################################################################################

################################################
### 0. Loading Packages used in this .R file ###
################################################

# Note: must use "install.packages(name_package)" for packages not installed

library(sf)         # function: st_read()      --> to read .geojson files
library(ggthemes)   # function: theme_map()     --> theme for plotting map

########################################################
### 1. Adding top and bottom 10% of life satisfaction ##
########################################################

top10_quantile <- quantile(Indicators_merged$satisfaction, 0.9, na.rm = TRUE)
bottom10_quantile <- quantile(Indicators_merged$satisfaction, 0.1, na.rm = TRUE)


Indicators_merged <- Indicators_merged |>
  mutate(satisfaction_top_bottom = case_when( 
    satisfaction < bottom10_quantile ~ "Bottom 10%",
    satisfaction > top10_quantile  ~ "Top 10%",
    .default =  "Other Areas")) 

Indicators_merged$satisfaction_top_bottom <- factor(Indicators_merged$satisfaction_top_bottom, 
                                                     ordered = TRUE, 
                                                     levels = c("Top 10%", "Other Areas", "Bottom 10%"))

View(
  Indicators_merged |>
    group_by(satisfaction_top_bottom) |> 
    summarise(n())
) # 29 cases in bottom 10%,  29 cases in top 10%, and 234 in other areas


##############################################################
### 2. loading "LAD boundaries" data set for plotting map  ###
##############################################################

#2.1 loads geographic coordinates of boundaries of LADs
LADs_boundaries <- st_read("Data/Local_Authority_Districts.geojson") #374 rows (all of UK)
LADs_boundaries <- LADs_boundaries |> filter(!grepl("^(W|S|K|N)", LAD22CD)) # 309 rows (only England)

#2.2 Joining map coordinates with indicators frame:
# left_join used to keep all boundary definitions for plotting
Map_Indicators_merged <- LADs_boundaries |>
  left_join(Indicators_merged, by= c("LAD22CD"="LAD_codes"))# 309 rows



####################################################
### 3. plotting map with top and bottom life sat ###
####################################################


# plotting map

custom_colors <- c(
  "Other Areas" = "lightgray", 
  "Bottom 10%" = "#FF6347",  
  "Top 10%" = "#4682B4"  
)


Map_Indicators_merged |>
  ggplot()+
  geom_sf(aes(fill= satisfaction_top_bottom), color = "white", lwd = 0.3) +
  labs(fill = "Satisfaction\nLevels") +
  scale_fill_manual(values = custom_colors,
                    guide = guide_legend(
                      keywidth = 2,
                      keyheight = 1 ),
                    na.value = "lightgray",
                    limits = levels(Map_Indicators_merged$satisfaction_top_bottom),
                    labels = c("Top 10%" = "Top 10%",
                               "Other Areas" = "Other Areas\n& Missing Values", 
                               "Bottom 10%" = "Bottom 10%"),
                    drop = TRUE
  )+
  theme_map() +
  theme(
    legend.position = c(.05, 0.35),   
    legend.background = element_rect(fill = "transparent"),  
    legend.title = element_text(size = 17), 
    legend.text = element_text(size = 17)  
  ) +
  annotate(
    "point",
    x = 0.40, y = 51.35, 
    shape = 21,         
    size = 50,          
    color = "black",    
    fill = NA,         
    stroke = 1.3      
  ) + 
  annotate(
    "segment",
    x = 1.9, y = 51.8 ,        
    xend =1.5 , yend = 51.6, 
    arrow = arrow(length = unit(0.35, "cm")), 
    color = "black",      
    size = 0.75               
  ) + 
  annotate(
    "segment",
    x = 1.9, y = 51.8 ,         
    xend =1.9 , yend = 53.5, 
    color = "black",         
    size = 0.75               
  )+  
  geom_text(
    data = data.frame(x = 0.55, y = 53.42, label = "55% of all the\nbottom 10%\nareas"),
    aes(x = x, y = y, label = label),
    hjust = 0,
    vjust = 0,
    size = 6
  ) +  
  geom_text(
    data = data.frame(x = -2.45, y = 50.30, label = "Data Source (all panels): UK’s ONS"),
    aes(x = x, y = y, label = label),
    hjust = 0,
    vjust = 0,
    size = 5.1
  )


################################
### 4. Clearing environment  ###
################################

# clears environment (deletes variables not used in subsequent .R files)
rm(list = setdiff(ls(), c("Indicators_merged")))