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

Clustering algorithms were evaluated using two key metrics:

- **Silhouette Score:** Measures how similar an object is to its own cluster compared to other clusters. Scores range from -1 to 1, where higher is better.
- **Calinski-Harabasz Index:** Evaluates cluster dispersion; higher values indicate better-defined clusters.

| Algorithm           | Silhouette Score | Calinski-Harabasz Score |
|---------------------|------------------|-------------------------|
| K-Means (k=3)       | 0.45             | 66.23                   |
| Hierarchical (k=3)  | 0.38             | 49.65                   |
| Gaussian Mixture (k=3) | 0.41          | 56.27                   |

**Interpretation:**  
K-Means clustering outperformed the other methods in both metrics, producing more distinct and well-separated clusters. This justifies the choice of K-Means for segmenting countries and guiding the aid allocation strategy.

---

Aid allocation was then performed on the most vulnerable cluster identified by K-Means, based on a weighted scoring system incorporating child mortality, health expenditure, and life expectancy.

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

