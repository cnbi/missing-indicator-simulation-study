#===============================================================================
#                         Evaluation
#===============================================================================
## ResultsSimAll: Data set with all coefficients. Result of collectResults script.
## Population model: -0.293 -0.243t + 2.211y1 + 0.296 s

# Boxplots -----------------------------------------------------------------------------
ResultsSimAll[, 5:8] <- apply(ResultsSimAll[, 5:8], 2, as.numeric)
var.names <- c("Intercept", "Time point", "Previous response", "Mother smokes") #TODO Change the name of variable
true.model <- c(-0.293, -0.243, 2.211, 0.296) #TODO Change the name of variable
proportion_lab <- c("25%", "40%")

estimates_population <- ResultsSimAll
for (i in 1:nrow(ResultsSimAll)) {
     estimates_population[i, 5:8] <- ResultsSimAll[i, 5:8] - true.model
}

for (i in 5:8) {
    print(estimates_population %>% 
              group_by(samp, prop) %>% 
              ggplot(aes(x = estimates_population$Type, y = estimates_population[, i])) + 
              geom_boxplot() + labs(x = "Type of data", y = var.names[i - 4]) + facet_grid(samp ~ prop, labeller = labeller(prop = proportion_lab)) +
              geom_hline(yintercept = 0 , linetype = "dashed", color = "red"))
}

# Multivariate ----------------------------------------------------------------------------
# Test assumptions
## Multivariate normality and outliers
a <- mvn(estimates_population[, 5:8], mvnTest = "mardia", multivariatePlot = "qq", multivariateOutlierMethod = "quan", showOutliers = TRUE)
a$multivariateNormality
kbl(a$multivariateNormality, format = "latex")

## Homogeneity of variance
boxM(cbind(Intercept, timepoint, Prev_resp_1, mother_smoke) ~ as.character(samp) * as.character(prop) * Type, data = estimates_population)

# MANOVA test
manova.test <- manova(cbind(Intercept, timepoint, Prev_resp_1, mother_smoke) ~ samp * prop * Type, data = estimates_population) #TODO Change the name of variable
b <- summary(manova.test)
output <- capture.output(b, file = NULL, append = FALSE)
output_df <- as.data.frame(output)
kable(output_df, format = "latex")


effectsize::eta_squared(manova.test)

# Univariate ------------------------------------------------------------------------
summary.aov(manova.test) #Univariate ANOVA

#Individual ANOVA
intercept.aov <- estimates_population %>% anova_test(Intercept ~ samp * prop * Type) #TODO change the objects's name.
intercept.aov
time.aov <- estimates_population %>% anova_test(timepoint ~ samp * prop * Type) #TODO change the objects's name.
time.aov
prev.aov <- estimates_population %>% anova_test(Prev_resp_1 ~ samp * prop * Type) #TODO change the objects's name.
prev.aov
mothers.aov <- estimates_population %>% anova_test(mother_smoke ~ samp * prop * Type) #TODO change the objects's name.
mothers.aov
# ges is the generalized eta squared.

## Boxplot for previous response means interaction sample:proportion
ggplot(estimates_population, aes(x = factor(estimates_population$samp), y = estimates_population[, 7], fill = factor(estimates_population$samp))) +
    geom_boxplot(position = position_dodge()) +
    facet_wrap(~prop, labeller = labeller(prop = proportion_lab)) + geom_hline(yintercept = 0 , linetype = "dashed", color = "red") +
    labs(x = "Sample size", y = "Bias of previous response") + theme(legend.position = "none") 
## Boxplot only proportion
ggplot(estimates_population, aes(x = factor(estimates_population$prop), y = estimates_population[ ,7])) +
    geom_boxplot(position = position_dodge()) + geom_hline(yintercept = 0 , linetype = "dashed", color = "red") +
    labs(x = "Proportion of missing", y = "Bias of previous response") + scale_x_discrete(labels = c("25%", "40%"))
