library(caret)
library(vip)

data_model <- data %>% ungroup %>% select(-Teryt, -Name)
cross_val <- trainControl(method="cv", number=10)
model <- train(`Credit Penetration` ~ ., 
               method = "ranger",
               data = data_model,
               trControl = cross_val,
               importance="permutation")
print(model)  

vip(model, num_features = 20)
