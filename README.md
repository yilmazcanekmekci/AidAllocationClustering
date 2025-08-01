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

## Methodology

### Clustering Approach

To segment countries into meaningful groups reflecting their aid needs, three clustering techniques were employed:

1. **K-Means Clustering**
2. **Hierarchical Clustering (Complete Linkage)**
3. **Gaussian Mixture Models (GMM)**

### Determination of Optimal Clusters

- **Elbow Method:** Suggested 3 clusters as the optimal balance between explained variance and model complexity.
- **Silhouette Analysis:** Highest score at k=2, but k=3 was chosen considering elbow method results and cluster interpretability.

### Clustering Evaluation Metrics

- **Silhouette Score:** Measures intra-cluster cohesion and inter-cluster separation; values range from -1 to +1.
- **Calinski-Harabasz Index:** Evaluates cluster compactness and separation; higher values indicate better-defined clusters.

| Algorithm           | Silhouette Score | Calinski-Harabasz Score |
|---------------------|------------------|-------------------------|
| K-Means (k=3)       | 0.45             | 66.23                   |
| Hierarchical (k=3)  | 0.38             | 49.65                   |
| Gaussian Mixture (k=3) | 0.41          | 56.27                   |

**Insight:** K-Means demonstrated superior performance, yielding well-separated and balanced clusters.

---

## Results

### Cluster Interpretation

- **Cluster 1:** Countries with relatively high income, GDP, and life expectancy, indicating lower immediate need for humanitarian aid.
- **Cluster 2:** Countries with moderate socioeconomic indicators.
- **Cluster 3:** Countries with high child mortality, low health expenditure, and low life expectancy—identified as the primary target group for aid allocation.

### Geographic Visualization

Clusters were visualized on a world map to provide spatial context and facilitate interpretation of global aid distribution patterns.

<img width="896" height="612" alt="image" src="https://github.com/user-attachments/assets/ea6d3070-f7c6-4d9a-8f35-c99de59cbd62" />

---

## Aid Allocation Strategy

Focusing on **Cluster 3**, aid distribution was based on a weighted scoring system considering three critical indicators:

- **Child Mortality Rate (child_mort)**
- **Health Expenditure (% GDP)**
- **Life Expectancy (life_expec)**

<img width="860" height="751" alt="image" src="https://github.com/user-attachments/assets/5c0f32f7-c421-4a25-9831-aaca62f59f83" />

---

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

