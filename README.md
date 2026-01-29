# Regional Credit Demand
Credit penetration analysis

# About
The goal of this analysis is to indetify the counties with relatively small number of credits sold compared to mean wage, population, number of properties and unemployment rate. 

# Data
The data come from GUS - Polish Central Statistical Office and BIK - Credit Information Bureau

# Method
This dataset is cross-sectional, which makes clustering a suitable approach. The Elbow method initially suggested 4 clusters, but these clusters were very similar. Therefore, the final number of clusters was set to 6, splitting the most promising cluster into two.

Clusters:  
1 - Cities - moderate wages and low unemployment  
3 - Provincial - highest mean wage and few properties  
5 - Agglomerations - highest population, lowest unemployment, second highest credit-penetration  

Map of chosen clusters
![Clusters map](https://github.com/BartDi/Regional-Credit-Demand/blob/main/Clusters.jpg?raw=true)

# Final decision 
Each cluster was scaled, and the three most promising counties were identified:

| Teryt | Name                     | Cluster | Rank  |
|-------|--------------------------|--------|-------|
| 2466  | Powiat m. Gliwice        | 1      | 4.03  |
| 2469  | Powiat m. Katowice       | 1      | 3.73  |
| 3262  | Powiat m. Szczecin       | 1      | 6.71  |
| 0610  | Powiat łęczyński         | 3      | 1.83  |
| 1001  | Powiat bełchatowski      | 3      | 2.50  |
| 2467  | Powiat m. Jastrzębie-Zdrój | 3   | 3.55  |
| 1261  | Powiat m. Kraków         | 5      | 2.20  |
| 1465  | Powiat m. st. Warszawa   | 5      | 4.78  |
| 3064  | Powiat m. Poznań         | 5      | -0.491 |




