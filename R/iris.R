install.packages("ggvis")
library(ggvis)

#show head
head(iris)

#plot sepal L vs. w
iris %>% ggvis(~Sepal.Length, ~Sepal.Width, fill = ~Species) %>% layer_points()


#plot petal length vs petal width
iris %>% ggvis(~Petal.Length, ~Petal.Width, fill = ~Species) %>% layer_points()