library(readxl)
library(dplyr)

# data pulling
population <- read_xlsx("Data/LUDN_2137_XPIV_20260112162304.xlsx", sheet="DANE")
properties <- read_xlsx("Data/RYNE_3783_XPIV_20260112155353.xlsx", sheet="DANE")
wages <- read_xlsx("Data/WYNA_2497_XPIV_20260112161217.xlsx", sheet="DANE")

# Get only column that are needed
population <- population %>% select(Kod, Nazwa, Wiek, Wartosc)
properties <- properties %>% select(Kod, Nazwa, Wartosc, `Jednostka miary`)
wages <- wages %>% select(Kod, Nazwa, Wartosc, `Jednostka miary`)

# summarizing age groups
population <- population %>% group_by(Kod, Nazwa) %>% summarise(Population = sum(Wartosc))

# changing columns names
population <- population %>% rename(Teryt = Kod, Name = Nazwa)
properties <- properties %>% rename(Teryt = Kod, Name = Nazwa, Properties = Wartosc, `Prop Unit` = `Jednostka miary`)
wages <- wages %>% rename(Teryt = Kod, Name = Nazwa, Wage = Wartosc, `Wage Unit` = `Jednostka miary`)


data <- population %>% 
  left_join(properties, by=c("Teryt"="Teryt", "Name"="Name")) %>% 
  left_join(wages, by=c("Teryt"="Teryt","Name"="Name"))
