###################################################################################
# 
# Project                     : Characteristics and Patterns of the Top and Bottom 10% of Areas in England by Life Satisfaction
# Author                      : Dionisio V. Del Orbe H.
# Purpose of this file        : Correlogram
# Output data.frame           : N/A
# Output image                : Panel C (export dimensions: width: 1000 Height: 531)
# Pre-run another .R file?    : Yes, parts 1~3 (code files).  
#
###################################################################################

################################################
### 0. Loading Packages used in this .R file ###
################################################

# Note: must use "install.packages(name_package)" for packages not installed

library(corrplot) # function:  cor.mtest() & corrplot() --> for plotting correlation
library(RColorBrewer) # for color pallet

######################
### 1. Correlogram ###
######################

# Defining frame with only top and bottom 10%

Indicators_merged_TopBottom <- Indicators_merged |>
  filter(satisfaction_top_bottom != "Other Areas")

# Checking normality to decide for Person or Spearman coefficient
# We use Shapiro:

shapiro.test(Indicators_merged_TopBottom$satisfaction)        # Not normal
shapiro.test(Indicators_merged_TopBottom$Income_pounds)       # Not normal
shapiro.test(Indicators_merged_TopBottom$anxiety)             # Normal
shapiro.test(Indicators_merged_TopBottom$Time_toWork_mins)    # Normal
shapiro.test(Indicators_merged_TopBottom$Emploment_perct)     # Normal
shapiro.test(Indicators_merged_TopBottom$Smokers_perct)       # Normal
shapiro.test(Indicators_merged_TopBottom$obesity_perct)       # Normal
shapiro.test(Indicators_merged_TopBottom$mean_pop_dens_2017)  # Not normal
# Result: we use Spearman as some variables are not normally distributed 


# Plotting correlation:

M_spearman = cor(Indicators_merged_TopBottom |> # the matrix
                   select(satisfaction,
                          Emploment_perct,
                          Time_toWork_mins,
                          mean_pop_dens_2017, 
                          Smokers_perct,
                          obesity_perct,
                          Income_pounds), 
                 method = "spearman")

Getting_sig = cor.mtest(Indicators_merged_TopBottom |> # getting the significance
                          select(satisfaction,
                                 Emploment_perct,
                                 Time_toWork_mins,
                                 mean_pop_dens_2017,
                                 Smokers_perct,
                                 obesity_perct,
                                 Income_pounds), conf.level = 0.95)

# labeling the variables for the graph
clear_var_names <- c("Life Satisfaction", 
                     "Employment Rate (%)",
                     "Time to Work (min)",
                     "Population Density\n      (people/km2)",
                     "Smoking Rate (%)",
                     "Obesity Rate (%)",
                     "Income (GBP)")

rownames(M_spearman) <- clear_var_names
colnames(M_spearman) <- clear_var_names

rownames(Getting_sig$p) <- clear_var_names
colnames(Getting_sig$p) <- clear_var_names

par(new=TRUE)
corrplot(M_spearman , 
         p.mat = Getting_sig$p,
         sig.level = 0.05, 
         diag = FALSE,
         method = "color", 
         type = "lower",
         addCoef.col = 'black',
         number.cex = 1, 
         col =colorRampPalette(c("#FFA07A", "white", "#4682B4"))(10),
         tl.pos = 'ld',
         tl.srt = 25,
         tl.col = 'black',
         tl.cex = 1,
         cl.cex = 1,
         cl.pos = 'b' 
)

text(
  x = 5.5, y = 7.9,                     
  labels = "Plots of\nSignificant\nCorrelations",     # extra note on figure
  col = "#585858",                     
  cex = 1.05,                       
  font = 1                          
)

arrows(x0 = 6.35, y0 = 7.9, x1 = 7.15, y1 = 7.9, # arrow on fig for clarity
       col = "#585858", lwd = 2, length = 0.1, lty = 1)

################################
### 2. Clearing environment  ###
################################

# clears environment (deletes variables not used in subsequent .R files)
rm(list = setdiff(ls(), c("Indicators_merged")))
