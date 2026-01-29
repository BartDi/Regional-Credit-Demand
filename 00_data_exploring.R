library(readxl)
library(dplyr)
library(stringr)

# data pulling
population <- read_xlsx("Data/LUDN_2137_XPIV_20260112162304.xlsx", sheet="DANE")
properties <- read_xlsx("Data/RYNE_3783_XPIV_20260112155353.xlsx", sheet="DANE")
wages <- read_xlsx("Data/WYNA_2497_XPIV_20260112161217.xlsx", sheet="DANE")
credits <- read_xlsx("Data/credits.xlsx")
unemployment <- read_xlsx("Data/RYNE_2392_XPIV_20260113123719.xlsx", sheet="DANE")

# Get only column that are needed
population <- population %>% select(Kod, Nazwa, Wiek, Wartosc)
properties <- properties %>% select(Kod, Nazwa, Wartosc, `Jednostka miary`)
wages <- wages %>% select(Kod, Nazwa, Wartosc, `Jednostka miary`)
unemployment <- unemployment %>% select(Kod, Wartosc)

# summarizing age groups
population <- population %>% group_by(Kod, Nazwa) %>% summarise(Population = sum(Wartosc))

# changing columns names
population <- population %>% rename(Teryt = Kod, Name = Nazwa)
properties <- properties %>% rename(Teryt = Kod, Name = Nazwa, Properties = Wartosc, `Prop Unit` = `Jednostka miary`)
wages <- wages %>% rename(Teryt = Kod, Name = Nazwa, Wage = Wartosc, `Wage Unit` = `Jednostka miary`)
unemployment <- unemployment %>% rename(Teryt = Kod, Unemployment=Wartosc)

data <- population %>% 
  left_join(properties, by=c("Teryt"="Teryt", "Name"="Name")) %>% 
  left_join(wages, by=c("Teryt"="Teryt","Name"="Name")) %>% 
  left_join(unemployment, by=c("Teryt"="Teryt"))

# extracting teryt code for voivodeships  
data <- data %>% mutate(
  Voivod = str_sub(Teryt, start=1, end=2)
  )

# adding voivodeship credit penetration 
data <- data %>% left_join(credits, by=c("Voivod"="Teryt"))

# random % of credits recipients
data <- data %>% mutate(
  `Properties per 10k residents` = round(Properties/Population*10000, 2),
  `Credit Penetration` =  rnorm(1, `perc of credit recipient`, 1)
)

data <- data %>% select(-Voivod,-`perc of credit recipient`, -`Prop Unit`, -`Wage Unit`)

for (var in data){
  if(sum(is.na(var))>0) {
    print("NA")
  }
}

# Simple visualisation
boxplot(`Credit Penetration` ~ Voivodeship, 
        data = data, 
        main = "Credit penetration ",
        col = "lightblue",
        xlab = "",
        las = 2,      
        cex.axis = 0.8, 
        ylab = "Credit Penetration (%)")
