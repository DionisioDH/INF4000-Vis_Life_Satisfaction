# Life Satisfaction Analysis in England (2017)

## Introduction
This project analyzes the life satisfaction of the top and bottom 10% areas in England in 2017, based on Local Authority Districts (LADs). The analysis is implemented using 5 `.R` script files. The first script focuses on loading the data, while the subsequent scripts each plot a specific panel of the final figure.

## Description of the Figure
![Final Figure](20250107_final_image.png)

The figure consists of four panels, each offering a unique perspective on the data:

1. **Geographical Distribution**:
   - The top 10% areas for life satisfaction tend to cluster across the country.
   - Most areas in the bottom 10% are located in the South East, near London (highlighted by the circle).

2. **Urbanicity Classification**:
   - All 58 areas in this study are classified based on their degree of urbanicity.
   - Urban areas generally fall into the bottom 10% in greater percentages than rural areas.
   - The arrow indicates the gradient of urbanicity, from most rural to most urban.

3. **Spearman Correlation Matrix (Correlogram)**:
   - Displays significant correlations of life satisfaction with other variables:
     - **Positive correlations**: Employment rate and time to work (blue squares).
     - **Negative correlations**: Population density and smoking rate (red squares).
   - Non-significant correlations are marked with an "x" in the lower left.

4. **Scatter Plots**:
   - Visualizes the relationship between life satisfaction and the significantly correlated variables.
   - Highlights the top and bottom 10% areas for life satisfaction, with other areas shown in gray.

## Scripts Overview
1. **Data Loading Script**: Prepares and processes the dataset for analysis.
2. **Plotting Scripts (4)**: Each script generates a specific panel of the figure as described above.
