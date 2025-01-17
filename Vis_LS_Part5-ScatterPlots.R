###################################################################################
# 
# Project                     : Characteristics and Patterns of the Top and Bottom 10% of Areas in England by Life Satisfaction
# Author                      : Dionisio V. Del Orbe H.
# Purpose of this file        : Scatter plots
# Output data.frame           : N/A
# Output image                : Panel D (export dimensions: width: 571 Height: 459)
# Pre-run another .R file?    : Yes, parts 1~4 (code files).  
#
###################################################################################

################################################
### 0. Loading Packages used in this .R file ###
################################################

# Note: must use "install.packages(name_package)" for packages not installed

library(gridExtra) # to put plots in grid with grid.arrange()

##############################################
### 1. scatter plots for sign correlations ###
##############################################

custom_colors <- c(
  "Other Areas" = "lightgray", 
  "Bottom 10%" = "#FF6347",  
  "Top 10%" = "#4682B4")

# Plot1
plot1 <- ggplot(Indicators_merged, aes(x = Emploment_perct, y = satisfaction)) +
  geom_point(size = 3, alpha = 0.55, aes(color = satisfaction_top_bottom)) +
  scale_color_manual(values = custom_colors) +
  theme_classic() +
  labs(y = "Life Satisfaction", x = "Employment Rate, %") +
  theme(
    legend.position = c(0.23,0.87),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 12),
    legend.text = element_text(size = 8.5),
    legend.key.size = unit(0.4, "cm"),
    legend.title = element_blank(), 
    legend.background = element_rect(fill = "transparent", color = "gray"),
    legend.margin = margin(0, 0, 0, 0), 
    legend.box.margin = margin(0, 0, 0, 0)
  ) +
  scale_y_continuous(limits = c(7, 8.6))

# Plot2
plot2 <- ggplot(Indicators_merged, aes(x = Time_toWork_mins, y = satisfaction)) +
  geom_point(size = 3, alpha = 0.55, aes(color = satisfaction_top_bottom)) +
  scale_color_manual(values = custom_colors) +
  theme_classic() +
  labs(y = "Life Satisfaction", x = "Time to Work, Min") +
  theme(
    legend.position = "none",
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 12),
    legend.text = element_text(size = 14),
    legend.title = element_blank()
  ) +
  scale_y_continuous(limits = c(7, 8.6))

# Plot3
plot3 <- ggplot(Indicators_merged, aes(x = mean_pop_dens_2017, y = satisfaction)) +
  geom_point(size = 3, alpha = 0.55, aes(color = satisfaction_top_bottom)) +
  scale_color_manual(values = custom_colors) +
  theme_classic() +
  labs(y = "Life Satisfaction", x = expression("Population Density, People/Km"^2)) +
  theme(
    legend.position = "none",
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 12),
    legend.text = element_text(size = 14),
    legend.title = element_blank()
  ) +
  scale_y_continuous(limits = c(7, 8.6))

# Plot4
plot4 <- ggplot(Indicators_merged, aes(x = Smokers_perct, y = satisfaction)) +
  geom_point(size = 3, alpha = 0.55, aes(color = satisfaction_top_bottom)) +
  scale_color_manual(values = custom_colors) +
  theme_classic() +
  labs(y = "Life Satisfaction", x = "Smoking Rate, %") +
  theme(
    legend.position = "none",
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 12),
    legend.text = element_text(size = 14),
    legend.title = element_blank()
  )  +
  scale_y_continuous(limits = c(7, 8.6))

grid.arrange(plot1, plot2, plot3, plot4, ncol = 2)
