# --- LIBRARY ---


library(survival)
library(ggsurvfit)
library(survminer)

# --- DATA ---

## Import Data
head(pbc)
View(pbc)

## Check Missing Value (NA)
colSums(is.na(pbc))

## Remove Missing Value (NA)
dt <- na.omit(pbc)
colSums(is.na(dt))

## Data Transformation
dt$status <- ifelse(dt$status == 2, 1, 0)
head(dt)
View(dt)

## Export dataset
write.csv(pbc, file = "Mayo Clinic Primary Biliary Cholangitis Data.csv")
write.csv(dt, file = "(Cleaned) Mayo Clinic Primary Biliary Cholangitis Data.csv")

# --- ANALYSIS ---

## Survival Time
y <- Surv(dt$time, dt$status)
y

## Descriptive Statistics
survfit(y ~ 1)
### Sex Variable
sex_counts <- table(dt$sex)
pie(sex_counts,
    labels = c("Male", "Female"),
    main = "Distribution of Sex in PBC Dataset",
    col = c("lightblue", "pink"))
legend("topright",
       legend = c(paste("Male :", sex_counts["m"]),
                  paste("Female :", sex_counts["f"])),
       fill = c("lightblue", "pink"),
       bty = "n") 
### Edema
edema_counts <- table(dt$edema)
pie(edema_counts,
    labels = names(edema_counts),
    main = "Distribution of Edema",
    col = c("lightgreen", "yellow", "orange"))
legend("topright",
       legend = c(paste("No Edema :", edema_counts["0"]),
                   paste("Untreated or Succesfully :", edema_counts["0.5"]),
                   paste("Edema :", edema_counts["1"])),
       fill = c("lightgreen", "yellow", "orange"),
       bty = "n")
### Ascites
ascites_counts <- table(dt$ascites)
pie(ascites_counts,
    labels = names(ascites_counts), 
    main = "Distribution of Ascites",
    col = c("lightgray", "purple"))
legend("topright",
       legend = paste(c("No Ascites", "Ascites"), ":", ascites_counts),
       fill = c("lightgray", "purple"),
       bty = "n")
### Hepatomegaly
hepato_counts <- table(dt$hepato)
pie(hepato_counts,
    labels = names(hepato_counts),
    main = "Distribution of Hepatomegaly",
    col = c("lightcoral", "lightseagreen"))
legend("topright",
       legend = paste(c("No Hepatomegaly", "Hepatomegaly"), ":", hepato_counts),
       fill = c("lightcoral", "lightseagreen"),
       bty = "n")
### Stages
stage_counts <- table(dt$stage)
pie(stage_counts,
    labels = names(stage_counts),
    main = "Distribution of Histologic Stage of Disease",
    col = c("blue", "red", "green", "purple"))
legend("topright",
       legend = paste(c("Stage-1", "Stage-2", "Stage-3", "Stage-4"), ":", stage_counts),
       fill = c("blue", "red", "green", "purple"),
       bty = "n")
### Spider
spiders_counts <- table(dt$spiders)
pie(spiders_counts,
    labels = names(spiders_counts),
    main = "Distribution of Blood Vessel Malformations (Spiders)",
    col = c("lightblue", "orange"))
legend("topright",
       legend = paste(c("No Spiders", "Spiders"), ":", spiders_counts),
       fill = c("lightblue", "orange"),
       bty = "n")
### Age
hist(dt$age,
     main = "Distribution of Age",
     xlab = "Age (years)",
     col = "skyblue",
     border = "white")
### Treatment
trt_counts <- table(dt$trt)
pie(trt_counts,
    labels = names(trt_counts),
    main = "Distribution of Treatment",
    col = c("red", "orange"))
legend("topright",
       legend = paste(c("D-penicillmain", "Placebo"), ":", trt_counts),
       fill = c("red", "orange"),
       bty = "n")
### Albumin
hist(dt$albumin,
     main = "Distribution of Serum Albumin",
     xlab = "Albumin (g/dl)",
     col = "lightgreen",
     border = "white")
### Alkalin Phosphatase
hist(dt$alk.phos,
     main = "Distribution of Alkaline Phosphatase",
     xlab = "Alkaline Phosphatase (U/liter)",
     col = "orange",
     border = "white")
### Aspartate Aminotransferase
hist(dt$ast,
     main = "Distribution of Aspartate Aminotransferase",
     xlab = "AST (U/ml)",
     col = "purple",
     border = "white")
### Serum Bilirubin
boxplot(dt$bili,
        main = "Boxplot of Serum Bilirubin",
        ylab = "Bilirubin (mg/dl)",
        col = "lightpink")
### Serum Cholesterol
hist(dt$chol,
     main = "Distribution of Serum Cholesterol",
     xlab = "Cholesterol (mg/dl)",
     col = "gold",
     border = "white")
### Urine Copper
hist(dt$copper,
     main = "Distribution of Urine Copper",
     xlab = "Copper (ug/day)",
     col = "brown",
     border = "white")
### Platelet Count
hist(dt$platelet,
     main = "Distribution of Platelet Count",
     xlab = "Platelet Count",
     col = "cyan",
     border = "white")
### Standardised Blood Clotting Time
boxplot(dt$protime,
        main = "Boxplot of Prothrombin Time",
        ylab = "Prothrombin Time",
        col = "limegreen")
### Survival Time
plot(density(dt$time),
     main = "Density Plot of Survival Time",
     xlab = "Time (days)",
     col = "blue",
     lwd = 2)


# --- KAPLAN MEIER PLOT & LOG RANK TEST ---
## Kaplan-Meier Plot for Each Treatment
fit_trt <- survfit(y ~ dt$trt)
summary(fit_trt)


plot(fit_trt, lty = c(1,2), col = c("steelblue", "tomato"), main = "Kaplan-Meier Survival Curves",
     xlab = "Days",
     ylab = "Suvival Probabilities")
grid(col = "gray", lty = "dotted")
legend("bottomleft", legend = c("D-penicillmain", "Placebo"), 
       col = c("steelblue", "tomato"), lwd = 2)

fit_trt %>%
  ggsurvfit() +
  labs(
    title = "Kaplan-Meier Survival Curve",
    x = "Days",
    y = "Overall survival probability") +
  add_confidence_interval()

## Log-Rank Test for Each Treatment
lr_trt <- survdiff(y ~ dt$trt)
lr_trt

## Kaplan-Meier Plot for Gender (sex)
fit_sex <- survfit(y ~ dt$sex)
summary(fit_sex)

plot(fit_sex, lty = c(1,2), col = c("steelblue", "tomato"), main = "Kaplan-Meier Survival Curves",
     xlab = "Days",
     ylab = "Suvival Probabilities")
grid(col = "gray", lty = "dotted")
legend("bottomleft", legend = c("Male", "Female"), 
       col = c("steelblue", "tomato"), lwd = 2)

fit_sex %>%
  ggsurvfit() +
  labs(
    title = "Kaplan-Meier Survival Curve",
    x = "Days",
    y = "Overall survival probability") +
  add_confidence_interval()

## Log-Rank Test for Gender (sex)
lr_s <- survdiff(y ~ dt$sex)
lr_s

## Kaplan-Meier Plot for Presence of Ascites
fit_asc <- survfit(y ~ dt$ascites)
summary(fit_asc)

plot(fit_asc, lty = c(1,2), col = c("steelblue", "tomato"), main = "Kaplan-Meier Survival Curves",
     xlab = "Days",
     ylab = "Suvival Probabilities")
grid(col = "gray", lty = "dotted")
legend("bottomleft", legend = c("No Ascites", "Ascites"), 
       col = c("steelblue", "tomato"), lwd = 2)

fit_asc %>%
  ggsurvfit() +
  labs(
    title = "Kaplan-Meier Survival Curve",
    x = "Days",
    y = "Overall survival probability") +
  add_confidence_interval()

## Log-Rank Test for Presence of Ascites
lr_asc <- survdiff(y ~ dt$ascites)
lr_asc

## Kaplan-Meier Plot for Presence of Hepatomegaly
fit_hep <- survfit(y ~ dt$hepato)
summary(fit_hep)

plot(fit_hep, lty = c(1,2), col = c("steelblue", "tomato"), main = "Kaplan-Meier Survival Curves",
     xlab = "Days",
     ylab = "Suvival Probabilities")
grid(col = "gray", lty = "dotted")
legend("bottomleft", legend = c("No Hepatomegaly", "Hepatomegaly"), 
       col = c("steelblue", "tomato"), lwd = 2)

fit_hep %>%
  ggsurvfit() +
  labs(
    title = "Kaplan-Meier Survival Curve",
    x = "Days",
    y = "Overall survival probability") +
  add_confidence_interval()

## Log-Rank Test for Presence of Hepatomegaly
lr_hep <- survdiff(y ~ dt$hepato)
lr_hep

## Kaplan-Meier Plot for Blood Vessel Malformations in the Skin
fit_spi <- survfit(y ~ dt$spiders)
summary(fit_spi)

plot(fit_spi, lty = c(1,2), col = c("steelblue", "tomato"), main = "Kaplan-Meier Survival Curves",
     xlab = "Days",
     ylab = "Suvival Probabilities")
grid(col = "gray", lty = "dotted")
legend("bottomleft", legend = c("No Spider Nevi", "Spiders Nevi"), 
       col = c("steelblue", "tomato"), lwd = 2)

fit_spi %>%
  ggsurvfit() +
  labs(
    title = "Kaplan-Meier Survival Curve",
    x = "Days",
    y = "Overall survival probability") +
  add_confidence_interval()

## Log-Rank Test for Blood Vessel Malformations in the Skin
lr_spi <- survdiff(y ~ dt$spiders)
lr_spi

## Kaplan-Meier Plot for Edema Status
fit_ede <- survfit(y ~ dt$edema)
summary(fit_ede)

plot(fit_ede, lty = c(1,2,3), col = c("steelblue", "green","pink"), main = "Kaplan-Meier Survival Curves",
     xlab = "Days",
     ylab = "Suvival Probabilities")
grid(col = "gray", lty = "dotted")
legend("bottomleft", legend = c("No Edema","Untreated or successfully treated Edema","Edema despite diuretic therapy"), 
       col = c("steelblue", "green","pink"), lwd = 3)

fit_ede %>%
  ggsurvfit() +
  labs(
    title = "Kaplan-Meier Survival Curve",
    x = "Days",
    y = "Overall survival probability") +
  add_confidence_interval()

## Log-rank test for Edema Status
lr_ede <- survdiff(y ~ dt$edema)
lr_ede

## Kaplan-Meier Plot for Histologic Stage of Disease
fit_sta <- survfit(y ~ dt$stage)
summary(fit_sta)

plot(fit_sta, lty = c(1,2,3,4), col = c("steelblue", "green","pink","purple"), main = "Kaplan-Meier Survival Curves",
     xlab = "Days",
     ylab = "Suvival Probabilities")
grid(col = "gray", lty = "dotted")
legend("bottomleft", legend = c("Stage-1","Stage-2","Stage-3","Stage-4"), 
       col = c("steelblue", "green","pink","purple"), lwd = 4)

fit_sta %>%
  ggsurvfit() +
  labs(
    title = "Kaplan-Meier Survival Curve",
    x = "Days",
    y = "Overall survival probability") +
  add_confidence_interval()

## Log-rank test for Histologic Stage of Disease
lr_sta <- survdiff(y ~ dt$stage)
lr_sta

# --- REGRESI COX ---

## Cox-Model
cox_model <- coxph(y ~ trt + age + sex + ascites + hepato + spiders + edema + bili + chol + albumin + copper + alk.phos + ast + trig + platelet + protime + stage, dt)
summary(cox_model)

## Backward Selection
backward <- step((cox_model), direction = 'backward')
summary(backward)

# --- PROPORTIONAL HAZARD ---

## Grambsch-Therneau Test or Goodness of Fit Test
gt_test <- cox.zph(backward)
gt_test

## log(-log Survival Probability)
### Log-log for Edema Status
ggsurvplot(fit_ede, dt, 
           conf.int = FALSE,
           xlab = "Time (Days)",
           ylab = "log(-log Survival Probability)",
           label.curves = list(keys = "lines"),
           loglog = TRUE,
           logt = TRUE)
### Log-log for Histologic Stage of Disease
ggsurvplot(fit_sta, dt, 
           conf.int = FALSE,
           xlab = "Time (Days)",
           ylab = "log(-log Survival Probability)",
           label.curves = list(keys = "lines"),
           loglog = TRUE,
           logt = TRUE)

# --- EVALUATING COX MODEL ---

## Schoenfeld Residual
ggcoxzph(gt_test)

## Martingale Residual
dt$residual_mart <- residuals(backward, type = "martingale")
dt$residual_mart
### Age Variable
ggplot(dt, mapping = aes(x = age, y = residual_mart)) +
  geom_point() +
  geom_smooth() +
  labs(
    title = "Age",
    x = "Age (Years)",
    y = "Martingale Residuals"
  ) +
  theme_bw() + 
  theme(legend.key = element_blank())
### Serum Bilirunbin Variable
ggplot(dt, mapping = aes(x = bili, y = residual_mart)) +
  geom_point() +
  geom_smooth() +
  labs(title = "Serum Bilirunbin",
       x = "Serum Bilirunbin (mg/dl)",
       y = " Martingale Residuals"
  ) +
  theme_bw() + theme(legend.key = element_blank())
### Serum Albumin Variable
ggplot(dt, mapping = aes(x = albumin, y = residual_mart)) +
  geom_point() +
  geom_smooth() +
  labs(title = "Serum Albumin",
       x = "Serum Albumin (g/dl)",
       y = " Martingale Residuals"
  ) +
  theme_bw() + theme(legend.key = element_blank())
### Urine Copper Variable
ggplot(dt, mapping = aes(x = copper, y = residual_mart)) +
  geom_point() +
  geom_smooth() +
  labs(title = "Urine Copper",
       x = "Urine Copper (ug/day)",
       y = " Martingale Residuals"
  ) +
  theme_bw() + theme(legend.key = element_blank())
### Aspartate Aminotransferase Variable
ggplot(dt, mapping = aes(x = ast, y = residual_mart)) +
  geom_point() +
  geom_smooth() +
  labs(title = "Aspartate Aminotransferase",
       x = "Aspartate Aminotransferase (U/ml)",
       y = " Martingale Residuals"
  ) +
  theme_bw() + theme(legend.key = element_blank())
### Standardised Blood Clotting Time Variable
ggplot(dt, mapping = aes(x = protime, y = residual_mart)) +
  geom_point() +
  geom_smooth() +
  labs(title = "Standardised Blood Clotting Time",
       x = "Standardised Blood Clotting Time",
       y = " Martingale Residuals"
  ) +
  theme_bw() + theme(legend.key = element_blank())

# --- EXTENDED COX MODEL ---

## Cutting Points
cut <- 1825

## Heaviside Function
### Bilirunbin Variable
dt$bili_bef <- ifelse(dt$time <= cut, dt$bili, 0)
dt$bili_aft <- ifelse(dt$time > cut, dt$bili, 0)
### Standardised Blood Clotting Time Variable
dt$protime_bef <- ifelse(dt$time <= cut, dt$protime, 0)
dt$protime_aft <- ifelse(dt$time > cut, dt$protime, 0)

## Cox-model
timedep_cox <- coxph(y ~ age + edema + albumin + copper + ast + stage +
                       bili_bef + bili_aft + protime_bef + protime_aft, dt)
summary(timedep_cox)

ph_test <- cox.zph(timedep_cox)
ph_test

## Model Comparison
AIC(backward)
AIC(timedep_cox)
