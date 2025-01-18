# Project: Characteristics and Patterns of Areas in England with the Top and Bottom 10% Life Satisfaction (2017)

## Introduction
This project analyzes the life satisfaction of the top and bottom 10% areas in England in 2017, based on Local Authority Districts (LADs). The analysis is carried out through five `.R` script files. The first script loads the data, while the subsequent scripts each plot a specific panel of the overall figure presented below.

## Description of the Figure
![Final Figure](20250107_final_image.png)

The figure consists of four panels, each offering a unique perspective on the data:

1. **[Panel (a)] Geographical Distribution**:
   - The top 10% areas for life satisfaction appear in multiple clusters across the country.
   - Most areas in the bottom 10% are located in the South East, near London (highlighted by the circle).

2. **[Panel (b)] Urbanicity Classification**:
   - All 58 areas in this study are classified based on their degree of urbanicity.
   - Urban areas generally fall into the bottom 10% in greater percentages than rural areas.
   - The arrow indicates the categories of urbanicity, going from most rural to most urban.

3. **[Panel (c)] Spearman Correlation Matrix (Correlogram)**:
   - Displays significant correlations of life satisfaction with other variables:
     - **Positive correlations**: Employment rate and time to work (blue squares).
     - **Negative correlations**: Population density and smoking rate (red squares).
   - Non-significant correlations are marked with an "x" in the lower left.

4. **[Panel (d)] Scatter Plots**:
   - Visualizes the relationship between life satisfaction and the significantly correlated variables. They seem to follow linear relationships.
   - Highlights the top and bottom 10% areas for life satisfaction (in blue and orange, respectively), with the rest of other areas shown in gray.
