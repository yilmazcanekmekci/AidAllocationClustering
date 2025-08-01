# AidAllocationClustering

## Project Overview
This project applies clustering algorithms to allocate a $30 million humanitarian aid budget optimally to countries based on socioeconomic indicators. The main goal is to identify countries most in need using data such as child mortality, health expenditure, income, and life expectancy.

## Dataset
The dataset includes 167 countries with the following variables:
- Child Mortality Rate
- Exports
- Health Expenditure (% of GDP)
- Imports
- Income per Capita
- Inflation Rate
- Life Expectancy
- Total Fertility Rate
- GDP per Capita

## Methods
- Data preprocessing.
- Clustering techniques applied:
  - K-Means (best performing)
  - Hierarchical Clustering
  - Gaussian Mixture Models (GMM)
- Clusters visualized on a world map.
- Aid allocation based on weighted scores of child mortality, health expenditure, and life expectancy in the most needy cluster.

## Results
- K-Means with 3 clusters gave the best separation of countries.
- Aid budget distributed fairly based on normalized weighted scores of key humanitarian indicators.

## How to Use
1. Load the dataset.
2. Run the clustering scripts.
3. Visualize clusters on the map.
4. Perform aid allocation based on cluster 3.

## Future Work
- Include more economic and social indicators.
- Explore dimensionality reduction techniques more deeply.
- Improve clustering performance with additional features.

## Contact
For questions or contributions, please open an issue or contact [yilmazcanekmekci@gmail.com].

