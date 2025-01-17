###################################################################################
# 
# Project                     : Characteristics and Patterns of the Top and Bottom 10% of Areas in England by Life Satisfaction
# Author                      : Dionisio V. Del Orbe H.
# Purpose of this file        : Plot 100% Stack Bar Chart
# Output data.frame           : N/A
# Output image                : Panel B (export dimensions: width: 892 Height: 590)
# Pre-run another .R file?    : Yes, part 1 and part 2 code files.  
#
###################################################################################

################################################
### 0. Loading Packages used in this .R file ###
################################################

# Note: must use "install.packages(name_package)" for packages not installed

library(scales) # this is to get % scale

##############################
### 1. full percent stack ###
##############################

# Getting counts for each category
Indicators_merged |> 
  filter(satisfaction_top_bottom != "Other Areas") |> 
  group_by(Rural_Classification, satisfaction_top_bottom) |>  
  summarize(n())

custom_colors_barChart <- c( # these are clearer colors than the map to make image less loaded with dark colors
  "Other Areas" = "lightgray",  
  "Bottom 10%" = "#FFA07A",  
  "Top 10%" = "#4682B4")



Indicators_merged |>
  filter(satisfaction_top_bottom != "Other Areas") |> # only getting top and bottom 10%
  ggplot(aes(x = Rural_Classification))+
  labs(x = "", y = "Percentage of areas in the top/bottom")+
  geom_bar(aes(fill=satisfaction_top_bottom), position = "fill", width = 0.65)+  # position="stack" makes it percent chart
  scale_y_continuous(labels = scales::percent)+
  scale_fill_manual(values = custom_colors_barChart) +
  scale_x_discrete( # we shorten names with these labels
    labels = c("Mainly Rural (rural including hub towns >=80%)" = "Mainly\nRural",
               "Largely Rural (rural including hub towns 50-79%)"  = "Largely\nRural",
               "Urban with Significant Rural (rural including hub towns 26-49%)" = "Urban\n(Significant\nRural)",
               "Urban with City and Town"  = "Urban\n(City &\n Town)",
               "Urban with Minor Conurbation" = "Urban\n(Minor\nConur-\nbation)", 
               "Urban with Major Conurbation" = "Urban\n(Major\nConur-\nbation)")
  ) +
  theme_minimal() +
  theme(
    legend.position = "top",
    legend.justification = "right",
    axis.text = element_text(size = 16.5),
    axis.title = element_text(size = 20.2),
    legend.text = element_text(size = 16.5),
    legend.title = element_blank(), 
    axis.text.x = element_text(angle = 0))+
  annotate("segment", x = 1, xend = 6, y = -.05, yend = -.05,
           arrow = arrow(type = "open",
                         length = unit(0.2, "inches")
           ), size = 1.2) +
  annotate("label", x = 0.65, y = -0.2, label = "Most Rural", hjust = 0, vjust = 0, size = 5.6) +
  annotate("label", x = 5.55, y = -0.2, label = "Most Urban", hjust = 0, vjust = 0, size = 5.6) +
  annotate("text", x = 1, y = 0.625, label = "n = 6\n(75%)", hjust = 0.5, vjust = 0.5, size = 5, color = "black")+
  annotate("text", x = 1, y = 0.125, label = "n = 2\n(25%)", hjust = 0.5, vjust = 0.5, size = 5, color = "black")+
  annotate("text", x = 2, y = 0.125, label = "n = 2\n(25%)", hjust = 0.5, vjust = 0.5, size = 5, color = "black")+
  annotate("text", x = 2, y = 0.625, label = "n = 6\n(75%)", hjust = 0.5, vjust = 0.5, size = 5, color = "black")+
  annotate("text", x = 3, y = 0.5625, label = "n = 7\n(87.5%)", hjust = 0.5, vjust = 0.5, size = 5, color = "black")+
  annotate("text", x = 3, y = 0.07, label = "n = 1\n(12.5%)", hjust = 0.5, vjust = 0.5, size = 4, color = "black")+
  annotate("text", x = 4, y = 0.666, label = "n = 10\n(66.67%)", hjust = 0.5, vjust = 0.5, size = 5, color = "black")+
  annotate("text", x = 4, y = .15625, label = "n = 5\n(33.33%)", hjust = 0.5, vjust = 0.5, size = 5, color = "black")+
  annotate("text", x = 5, y = 0.5, label = "n = 3\n(100%)", hjust = 0.5, vjust = 0.5, size = 5, color = "black")+
  annotate("text", x = 6, y = 0.5, label = "n = 16\n(100%)", hjust = 0.5, vjust = 0.5, size = 5, color = "black")
# the annotations above put the number cases in each category as calculated in the beginning of this code.


################################
### 2. Clearing environment  ###
################################

# clears environment (deletes variables not used in subsequent .R files)
rm(list = setdiff(ls(), c("Indicators_merged")))
