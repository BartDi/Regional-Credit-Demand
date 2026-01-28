library(caret)
library(vip)

#Selecting only continous variables and voivodeship
data_model <- data %>% ungroup %>% select(-Teryt, -Name)

#Cross validation
cross_val <- trainControl(method="cv", number=10)
model <- train(`Credit Penetration` ~ ., 
               method = "ranger",
               data = data_model,
               trControl = cross_val,
               importance="permutation")
print(model)  

vip(model, num_features = 20)

#Random Forest is not helpful here
rm(list=c("data_model","cross_val", "model"))


#CLUSTERING
plot(data$`Credit Penetration`)
library(cluster)

variables <- c("Population", "Properties", "Wage", "Unemployment", "Properties per 10k residents", "Credit Penetration")

X_clustering <- scale(data[,variables])
km <- kmeans(X_clustering, centers = 4, nstart = 70)

data_clustering <- data
data_clustering$cluster <- km$cluster

aggregate(data_clustering[, variables], by = list(cluster = data_clustering$cluster), mean)
# There are 4 clusters:
#   1 - Small population, high unemployment, low wages and high credit penetration
#   2 - Low unemployment, Decent wage, many properties per 10k residents
#   3 - Is simmilar to the first one, but credit penetration is very low 
#   4 - high wages, population and credit penetration

# More clusters needed

km6 <- kmeans(X_clustering, centers = 6, nstart = 80)
data_clustering$cluster <- km$cluster

aggregate(data_clustering[, variables], by = list(cluster = data_clustering$cluster), mean)
# Now with 6 clusters I would recommend clusters: 1 - cities -  low unemployment, decent wage and not that high credit penetration
#                                               5 - agglomerations - is not the most penetrated (13,4 compare to 13,8) so there is also a chance to sell more credits
#                                               3 - Provincial - the highest mean wage, not that much properties

# cluster Population     Properties  Wage     Unemployment     Properties per 10k residents    Credit Penetration
# 1       1   42147.71   1671.8571  8217.448     3.955357                    394.94018          12.337970
# 2       2   13764.87    165.5294  7229.287    13.342647                    123.12029          11.999753
# 3       3   21317.17    391.0833 10259.884     5.300000                    170.39667          12.437076
# 4       4   21737.99    332.1240  7422.567     5.765289                    153.14157          13.770605
# 5       5  279893.17  13687.1667  9803.307     2.183333                    523.48333          13.447126
# 6       6   23096.37    200.1538  7319.347     6.970085                     86.54923           9.278385



library(sf)
powiaty <- st_read("Powiat/A02_Granice_powiatow.shp")
names(powiaty)
data_clustering$Teryt = substr(data_clustering$Teryt,1,4)
map <- merge(powiaty, data_clustering, by.x="JPT_KOD_JE", by.y="Teryt")

plot(map["credit_penetration"])
library(ggplot2)

#map$potentials <- ifelse(map$cluster %in% c(1,3,5), paste0("Potential",map$cluster), "Rest")
map <- map %>% mutate(
  potentials = case_when(
    cluster == "1" ~ "Cities",
    cluster == "3" ~ "Provincial",
    cluster == "5" ~ "Agglomerations",
    .default = "Rest"
  )
)

ggplot(map) + 
  geom_sf(aes(fill = factor(potentials)), color="white", size = 0.15) +
  theme_minimal()+
  labs(fill = "Klaster")+
  scale_fill_manual(
    values = c(
      "Cities" = "#fde725",
      "Provincial" = "#21918c",
      "Agglomerations" = "#440154",
      "Rest" = "grey"
    )
  )
