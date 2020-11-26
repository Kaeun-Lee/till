# 1. ��Ű�� ��ġ�ϱ�� �ε��ϱ� ----
install.packages("readxl")
install.packages("writexl")
install.packages("tidyverse")   # �߱�
install.packages("e1071")       # ������ ����� �� ��; �ֵ�, ÷��
install.packages("GGally")
install.packages("psych")       # ����ũ(�ɸ�)
library(readxl)
library(writexl)
library(tidyverse)
library(e1071)
library(GGally)
library(psych)

# 2. �۾����� �����ϱ� ----
setwd("d:/KCISA")
getwd


# 3. ������ �о���� ----
culture <- readxl::read_excel(path      = "culture.xlsx",
                              sheet     = "DM",
                              col_names = TRUE)


culture %>%
  dplyr::mutate(TOTAL_VALUE = MOBILE_SCCNT_VALUE + PC_SCCNT_VALUE + SCCNT_SM_VALUE) -> culture


# 4. ����м� ----
# ���      : ������ ���� = ������ ����
# �ڷ�      : 2���� �ڷ�(�� = ���� = Feature = Label)
# ���� �ڷ� : ����м� �Ϸ��� �ڷᰡ ��� ���� �ڷῩ�� ��
# paired(��) �Ǿ� �־�� ��


# 4.1 ������(Scatter plot) ----
# x�� y���� ���踦 �ð�ȭ
# ������ ���踦 �ð�ȭ
culture %>% 
  ggplot2::ggplot(mapping = aes(x = MOBILE_SCCNT_VALUE,
                                y = PC_SCCNT_VALUE)) +   # y�࿡ �� �߿��� �ڷḦ �־��!
  ggplot2::geom_point()
  

# 4.2 ������ĵ�(SPM : Scatter plot Matrix) ----
# �ݺ��۾��� ��, purrr�� ���
culture %>% 
  purrr::keep(is.numeric)  %>% 
  dplyr::select(-c(SN, SCCNT_DE)) %>% 
  GGally::ggpairs() 
  
  
# 4.3 ������ ----
# Coefficient of Correlation
# ������ ���踦 ��ġȭ�� �� : �� ���� ������ ���谡 ������ �˰� �;
cor(culture$RANK,
    culture$MOBILE_SCCNT_VALUE,
    method = "pearson")       # pearson�� ����Ʈ��

culture %>% 
  purrr::keep(is.numeric)  %>% 
  dplyr::select(-c(SN, SCCNT_DE)) %>% 
  cor(method   = "pearson") %>% 
  round(digits = 3)

# ������ �ؼ��� �Ϲ����� ���̵�(�׻� ������ �ƴ�!)
# 0.0 <= |r| < 0.2  : ������谡 ����.
# 0.2 <= |r| < 0.4  : ���� ������谡 �ִ�.
# 0.4 <= |r| < 0.6  : ������ ������谡 �ִ�.
# 0.6 <= |r| < 0.8  : ����(����) ������谡 �ִ�.
# 0.8 <= |r| <= 1.0 : �ſ� ����(����) ������谡 �ִ�.


# 4.4 ����м� ----
# �������� ���� �ϳ�
# �͹����� : �� ���� �ڷ� ���� ������谡 ����.
# �븳���� : �� ���� �ڷ� ���� ������谡 �ִ�.
cor.test(culture$RANK, 
         culture$MOBILE_SCCNT_VALUE, 
         method = "pearson")     
  
  
# p-value = 0.000 < ���Ǽ���(alpha) = 0.05 : ����� �븳����
# """
# ����Ȯ���� 0.000�̹Ƿ� ���Ǽ��� 0.05����
# 'RANK'��' 'MOBILE_SCCNT_VALUE' ������ ��������� ������
# ���� ������谡 �ִ� ������ ��Ÿ����. 
# (so, �ϴ� RANK�� �߿��ϰ� �����ؾ߰ڴٴ� ���̵� ���� �� ����)
# """


culture %>% 
  purrr::keep(is.numeric) %>% 
  dplyr::select(-c(SN,SCCNT_DE)) %>% 
  psych::corr.test(method = "pearson")


# 5. ȸ�ͺм�(Regression Analysis) ----
# �ΰ����踦 �м���
# "����"�� �ַ� ��. ���� "�з�"���� ����.
# (�� ���ڰ� �̷��� � ���� �� ���� ��Ȯ�� �����ϰ� �;)
# ������ ���� ȸ�ͺм��� ���� ��
# (������? �ؼ��� ���� ����. ������ �������� �Ǿ�����. �������� �����ϸ� ��Ȯ���� ���������� ������ ����)

# ������ ���߼��� ȸ�ͺм��� ��
# �ܼ����� ȸ�ͺм� : X�� 1��     , Y�� 1��  (�� ����)
# ���߼��� ȸ�ͺм� : X�� 2�� �̻�, y�� 1��  

# �⺻�� X : ���� �ڷ�, Y : ���� �ڷ�
# X�� ���� �ڷᵵ �� �� ������ �׳� �� ��.
# X�� ���� �ڷ��� ��쿡�� ���� ����(dummy variable)�� �����ؾ� ��.


# ȸ�ͺм����             <- lm(formula = Y ~ X1 + X2 + ..., data = �м��� ������)
# ���� : lm : linear model
# summary(ȸ�ͺм����)    <- ȸ�ͺм��� ����� consol�� �� �ѷ���
culture_model <- lm(formula = SCCNT_SM_VALUE ~ RANK + MOBILE_SCCNT_VALUE + PC_SCCNT_VALUE,
                    data    = culture)
summary(culture_model)     # ��ġ�� ��ġ�� ��������� ���ͼ� ����


# ȸ�ͺм� ����� �ؼ�
# 1�ܰ� : ȸ�͸����� Ÿ�缺
# �͹����� : ȸ�͸����� Ÿ������ �ʴ�.
# �븳���� : ȸ�͸����� Ÿ���ϴ�.        
# ȸ�� ����:(Y���� �� �ΰ� X���� �� �δ�)

# F-statistic: 5.015e+31 on 3 and 4177 DF,  p-value: < 2.2e-16  (���� �������� �ִ� �̰� �����)
# p-value = 0.000 < ���Ǽ��� = 0.05 : ��� �븳����



# 2�ܰ� : X�� ���Ǽ� ����
# �͹����� : X�� Y���� ������ ���� �ʴ´�.
# �븳���� : X�� Y���� ������ �ش�.

# Coefficients:
#                     Estimate Std. Error        t value     Pr(>|t|)  <- �̰� p-value
# (Intercept)        -1.004e-12     8.164e-14   -1.230e+01   <2e-16
# RANK                2.644e-13     9.104e-15    2.905e+01   <2e-16
# MOBILE_SCCNT_VALUE  1.000e+00     1.123e-16    8.902e+15   <2e-16
# PC_SCCNT_VALUE      1.000e+00     3.654e-16    2.737e+15   <2e-16


# RANK               : p-value = 0.000 < ���Ǽ��� = 0.05 : ��� �븳���� 
# MOBILE_SCCNT_VALUE : p-value = 0.000 < ���Ǽ��� = 0.05 : ��� �븳���� 
# PC_SCCNT_VALUE     : p-value = 0.000 < ���Ǽ��� = 0.05 : ��� �븳���� 

# ��: �� ���� �� Y���� ������ �ش�.



# 3�ܰ� : X�� Y���� ��� ������ �ִ°�?
# RANK�� �ٸ� X���� �����Ǿ� ���� ��(�������� ��) RANK�� �⺻������(������ �� ������) 1 �����ϸ� Y�� �� 0.000 ����(Estimate) ������Ű��,
# (���� ������ $�� '1$�� �����ϸ�'�̶�� ǥ���ؾ� ��, ������ �ٸ� 2�� ���ǵ��� ������ �ְ� RANK�� �����̴� �� '�ٸ� X���� �����Ǿ� ���� ��'��� ǥ���� ����)  
# MOBILE_SCCNT_VALUE��, �ٸ� X���� �����Ǿ� ���� ���� MOBILE_SCCNT_VALUE�� �⺻������ 1 �����ϸ� Y�� �� 1 ���� ������Ű��,
# PC_SCCNT_VALUE��, �ٸ� X���� �����Ǿ� ���� ���� PC_SCCNT_VALUE�� �⺻������ 1 �����ϸ� Y�� �� 1 ���� ������Ű�� ������ ��Ÿ����. 



# 4�ܰ� : ȸ�� ������ ������ = X���� ������
# Y�ȿ� �ٸ�(����)�� �ִµ�, �� �ٸ��� X���� �󸶳� �����ϰ� �ִ°�?  
# (�̰� �������̰� ���� ������ ���� ���� ����, �������� ���ٸ� X���� �߿��ϴٴ� ����)
# Multiple R-squared:      1,	Adjusted R-squared:      1 
# X���� ��� ������ ������ �ָ� R-Square�� ����,
# X�� �߿� �Ϻδ� ������ ������ ���� ������ Adjusted R-squared�� ����.
# Adjusted R-squared: 1��� ���� X���� Y�� ����(�ٸ�)�� 100% �����ϰ� �ִ�.  <- ��� 100% ������ ��� ���� ����


# �ֳĸ�, R-Square�� �̹������� ������ �����ϴ� ������ ����. �׷� ������ X�� ���� ������ �̰� Ŀ��
# Adjusted R-squared������, �������� ���� X������ ���� �� Penalty�� �ο��ϴ� ��ġ�� �ִ�.
# �츮ó�� �� X���� �����ϸ� �׳� R-Square �ᵵ ��



# 5�ܰ� : ����
predict(culture_model,
        data.frame(RANK = 5,
                   MOBILE_SCCNT_VALUE = 100,
                   PC_SCCNT_VALUE     = 200))
# Y�� �������� �н��� �ŷ� ���� 300�� ���� �� ����! ��� ������ ����
