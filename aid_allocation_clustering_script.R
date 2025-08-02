locationWD <- c("C:\\Users\\YILMAZ\\Desktop")
setwd(locationWD)
getwd()

country_data <- read.csv("country_data.csv", header = TRUE, sep = ",")


# - DATA PREPARATION AND ANALYZE

# 1. Quality assessment
head(country_data)
str(country_data)
summary(country_data)

# 2. Checking for missing data
country_data[!complete.cases(country_data),]

# 3. Data format ordering 
country_data$country <- as.factor(country_data$country)
country_data$child_mort <- as.numeric(country_data$child_mort)
country_data$exports <- as.numeric(country_data$exports)
country_data$health <- as.numeric(country_data$health)
country_data$imports <- as.numeric(country_data$imports)
country_data$income <- as.numeric(country_data$income)
country_data$inflation <- as.numeric(country_data$inflation)
country_data$life_expec <- as.numeric(country_data$life_expec)
country_data$total_fer <- as.numeric(country_data$total_fer)
country_data$gdpp <- as.numeric(country_data$gdpp)

# 4. Standardization
columns_to_standardize <- c("child_mort", "exports", "health", "imports", "income", 
                            "inflation", "life_expec", "total_fer", "gdpp")

country_data[columns_to_standardize] <- scale(country_data[columns_to_standardize])
country_data

# 5. Checking the relationship between the features
install.packages("corrplot")
library(corrplot)
cor_matrix <- corrplot(cor(country_data[, !names(country_data) %in% "country"]))

print(cor_matrix)

# 6. Finding outlier countries

detect_outliers <- function(data, columns) {
  outlier_countries <- list()
  
  for (col in columns) {
    Q1 <- quantile(data[[col]], 0.25, na.rm = TRUE)
    Q3 <- quantile(data[[col]], 0.75, na.rm = TRUE)
    IQR_value <- Q3 - Q1
    
    lower_bound <- Q1 - 1.5 * IQR_value
    upper_bound <- Q3 + 1.5 * IQR_value
    
    outliers <- data$country[data[[col]] < lower_bound | data[[col]] > upper_bound]
    
    if (length(outliers) > 0) {
      outlier_countries[[col]] <- outliers
    }
  }
  
  return(outlier_countries)
}

outlier_countries <- detect_outliers(country_data, columns_to_standardize)

print(outlier_countries)


par(mfrow=c(3,3))  
for (col in columns_to_standardize) {
  boxplot(country_data[[col]], main = col, col = "lightblue", horizontal = TRUE)
}



# - FINDING OPTIMAL CLUSTER NUMBER 

install.packages("factoextra")
install.packages("cluster")
install.packages("fpc")
library(factoextra)
library(cluster)
library(fpc)

# 1. Elbow Method 
fviz_nbclust(country_data[, !names(country_data) %in% "country"]
             , FUN = hcut, method = "wss", k.max = 10) + 
  labs(title = "Elbow Method")

# 2. Silhouette Score
fviz_nbclust(country_data[, !names(country_data) %in% "country"]
             , FUN = hcut, method = "silhouette", k.max = 10)




# - CLUSTERING ALGORITHMS

selected_features <- country_data[, c("child_mort", "exports", "health", "imports", "income"
                                      , "inflation", "life_expec", "total_fer", "gdpp")]

# 1. Applying K-Means Clustering
set.seed(123) # Set seed for reproducibility  
kmeans_result <- kmeans(selected_features, centers = 3, nstart = 25) # Perform k-means clustering

country_data$KMeans_Cluster <- kmeans_result$cluster # Add cluster assignments to the dataset

country_data$country # Display country names
country_data$KMeans_Cluster # Display cluster assignments

# 1.a) Silhouette Score
kmeans_sil <- silhouette(kmeans_result$cluster, dist(selected_features))
fviz_silhouette(kmeans_sil)

# 1.b) Calinski-Harabasz Score
kmeans_ch_score <- cluster.stats(dist(selected_features), kmeans_result$cluster)$ch
cat("K-Means ~ Calinski-Harabasz Score:\n", kmeans_ch_score)


# 2. Applying Hierarchical Clustering 
distance_matrix <- dist(selected_features, method = "euclidean") # Compute the distance matrix

hc_complete <- hclust(distance_matrix, method = "complete") # Perform hierarchical clustering with complete linkage

plot(hc_complete, cex = 0.6, hang = -1, 
     main = "Dendrogram (Complete Linkage)", 
     xlab = "Countries", ylab = "Height")

hierarchical_clusters <- cutree(hc_complete, k = 3) # Cut the dendrogram into 3 clusters

country_data$Hierarchical_Cluster <- hierarchical_clusters # Add cluster assignments to the dataset

country_data$country # Display country names
country_data$Hierarchical_Cluster # Display cluster assignments

# 2.a) Silhouette Score
hierarchical_sil <- silhouette(hierarchical_clusters, dist(selected_features))
fviz_silhouette(hierarchical_sil)

# 2.b) Calinski-Harabasz Score
hierarchical_ch_score <- cluster.stats(dist(selected_features), hierarchical_clusters)$ch
cat("Hierarchical Clustering ~ Calinski-Harabasz Score:\n", hierarchical_ch_score)


# 3. Applying GMM CLustering 
install.packages("mclust")
library(mclust)
library(factoextra)

set.seed(123) # Set seed for reproducibility
gmm_result <- Mclust(selected_features, G = 3) # Perform GMM clustering

country_data$GMM_Cluster <- gmm_result$classification # Add GMM cluster assignments to the dataset

country_data$country # Display country names
country_data$GMM_Cluster # Display GMM cluster assignments

# 3.a) Silhouette Score
gmm_sil <- silhouette(gmm_result$classification, dist(selected_features))
fviz_silhouette(gmm_sil)

# 3.b) Calinski-Harabasz Score
gmm_ch_score <- cluster.stats(dist(selected_features), gmm_result$classification)$ch
cat("GMM ~ Calinski-Harabasz Score:\n", gmm_ch_score)



# - SHOWING K-MEANS CLUSTER RESULTS ON THE MAP 

install.packages("ggplot2")
install.packages("sf")
install.packages("rnaturalearth")
install.packages("rnaturalearthdata")
install.packages("dplyr")
library(ggplot2)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(dplyr)

# Load world map data (Medium scale)
world <- ne_countries(scale = "medium", returnclass = "sf")

# Check unique country names in the world map
unique(world$name)

head(country_data)

# Find countries in country_data that are not in the world map
setdiff(country_data$country, world$name)

# Standardize country names to match the world map
country_data$country <- recode(country_data$country,
                               "Antigua and Barbuda" = "Antigua and Barb.",
                               "Bosnia and Herzegovina" = "Bosnia and Herz.",
                               "Cape Verde" = "Cabo Verde",
                               "Central African Republic" = "Central African Rep.",
                               "Congo, Dem. Rep." = "Dem. Rep. Congo",
                               "Congo, Rep." = "Republic of Congo",
                               "Cote d'Ivoire" = "Ivory Coast",
                               "Czech Republic" = "Czechia",
                               "Dominican Republic" = "Dominican Rep.",
                               "Equatorial Guinea" = "Eq. Guinea" ,
                               "Kyrgyz Republic" = "Kyrgyzstan",
                               "Lao" = "Laos",
                               "Macedonia, FYR" = "North Macedonia",
                               "Micronesia, Fed. Sts." = "Micronesia",
                               "Slovak Republic" = "Slovakia",
                               "Solomon Islands" = "Solomon Is.",
                               "St. Vincent and the Grenadines" = "St. Vin. and Gren.",
                               "United States" = "United States of America")


# Join the country data with world map data
map_data <- world %>%
  left_join(country_data, by = c("name" = "country"))

ggplot(data = map_data) +
  geom_sf(aes(fill = as.factor(KMeans_Cluster)), color = "black", size = 0.2) +
  scale_fill_manual(values = c("darkblue", "lightblue", "orange"), name = "Cluster") +
  theme_minimal() +
  labs(title = "K-Means Clustering Results",
       subtitle = "On the World Map",
       caption = "Data Source: https://www.kaggle.com/datasets/rohan0301/unsupervised-learning-on-country-data/metadata?resource=download") +
  theme(legend.position = "bottom")



# - AID DISTRIBUTION BASED ON CHILD MORTALITY, HEALTH, LIFE EXPECTANCY, AND POPULATION

# Filter countries in the third KMeans cluster
third_cluster_countries <- subset(country_data, KMeans_Cluster == 3)

# Step 0: Add population data (2024 estimates)
population_data <- c(
  42228734,   # Afghanistan
  36910630,   # Angola
  13945871,   # Benin
  2717481,    # Botswana
  23625735,   # Burkina Faso
  13512939,   # Burundi
  28846735,   # Cameroon
  5963089,    # Central African Rep.
  18473780,   # Chad
  846504,     # Comoros
  102262808,  # Dem. Rep. Congo
  6214936,    # Republic of Congo
  28873016,   # Ivory Coast
  1634462,    # Eq. Guinea
  3702740,    # Eritrea
  2476971,    # Gabon
  2796328,    # Gambia
  34317894,   # Ghana
  14479826,   # Guinea
  2236993,    # Guinea-Bissau
  11871272,   # Haiti
  45505445,   # Iraq
  56089652,   # Kenya
  135812,     # Kiribati
  7644175,    # Laos
  2267956,    # Lesotho
  5614622,    # Liberia
  31227800,   # Madagascar
  21896267,   # Malawi
  22593569,   # Mali
  4926668,    # Mauritania
  36040059,   # Mozambique
  2684742,    # Namibia
  27817816,   # Niger
  229152217,  # Nigeria
  248757419,  # Pakistan
  14467509,   # Rwanda
  18194560,   # Senegal
  9091899,    # Sierra Leone
  60624952,   # South Africa
  49359736,   # Sudan
  67315743,   # Tanzania
  1430241,    # Timor-Leste
  9254011,    # Togo
  49790168,   # Uganda
  34984957,   # Yemen
  21150263    # Zambia
)

# Add the population column to the data frame
third_cluster_countries$population <- population_data

# Step 1: Normalize selected features
third_cluster_countries$norm_child_mort <- (third_cluster_countries$child_mort - min(third_cluster_countries$child_mort)) / 
  (max(third_cluster_countries$child_mort) - min(third_cluster_countries$child_mort))

third_cluster_countries$norm_health <- (third_cluster_countries$health - min(third_cluster_countries$health)) / 
  (max(third_cluster_countries$health) - min(third_cluster_countries$health))

third_cluster_countries$norm_life_expec <- (third_cluster_countries$life_expec - min(third_cluster_countries$life_expec)) / 
  (max(third_cluster_countries$life_expec) - min(third_cluster_countries$life_expec))

third_cluster_countries$norm_population <- (third_cluster_countries$population - min(third_cluster_countries$population)) /
  (max(third_cluster_countries$population) - min(third_cluster_countries$population))

# Step 2: Calculate composite weight (equal weights for 4 factors)
third_cluster_countries$Total_Weight <- (third_cluster_countries$norm_child_mort + 
                                           third_cluster_countries$norm_health + 
                                           third_cluster_countries$norm_life_expec + 
                                           third_cluster_countries$norm_population) / 4

# Step 3: Normalize the weights
total_weight_sum <- sum(third_cluster_countries$Total_Weight)
third_cluster_countries$Weight_Adjusted <- third_cluster_countries$Total_Weight / total_weight_sum

# Step 4: Aid distribution
total_aid <- 30e6  # Total aid: $30 million
third_cluster_countries$Aid <- third_cluster_countries$Weight_Adjusted * total_aid

# Final output
aid_distribution <- third_cluster_countries[, c("country", "Aid")]
print(aid_distribution)

# Check if total aid is correctly allocated
sum(aid_distribution$Aid)  # Should be exactly 30,000,000
