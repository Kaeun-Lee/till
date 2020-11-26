# ������ �м��� �������� �帧
# a. ������ �о����
# b. ������ �м��� �µ��� �����͸� ó���ϰ� ��ȯ�ϱ�
# c. ������ �ð�ȭ
# d. ���� �����
# e. ������ �м� ������ �ۼ�
# f. �ǻ����(Communication)


# Ctrl + Shift + n : ���ο� R script �����
# 1. ��Ű�� ��ġ�ϱ�� �ε��ϱ� ----
install.packages("readxl")
install.packages("writexl")
install.packages("tidyverse")  # �߱�
library(readxl)
library(writexl)
library(tidyverse)


# 2. �۾����� �����ϱ� ----
setwd("d:/KCISA")
getwd


# 3. ������ �о���� ----
culture <- readxl::read_excel(path      = "culture.xlsx",
                              sheet     = "DM",
                              col_names = TRUE)


# 4. ������ ��ü ���� ----
# View(data)
View(culture)


# 5. �������� �Ϻ� ���� ----
# �ֿܼ� ����� ��
# 5.1 head(data, n =6) ----
head(culture)
head(culture, n = 10)


# 5.2 tail(data, n =6) ----
tail(culture)
tail(culture, n = 10)


# 6. �������� ����(Structure) ----
# dplyr::glimpse(data)   # �����͸� ���� �Ⱦ�� ��
# <dbl> : double, <chr> : character
# <dbl> :  double�� �Ҽ����� ���� ���ڷ� �Ǿ��ֱ���!
dplyr::glimpse(culture)



# 7. �Է¿��� üũ�ϱ� ----
# summary(data) �����Ϳ� �Է��� �� �Ǿ����� �ƴ����� üũ
summary(culture)    # Rank�� min�� max�� ���� ��. 

# summary���� ���ڿ��� ���� ������ ������ ����
# vector�� factor�� �ٲ㼭 ���ڿ��� ���뵵 summary�� �������� �����
# ��, ���ڿ��� üũ�� ������ factor�� ���� �� �ٽ� summary�� Ȯ���� ����
culture$SRCHWRD_NM <- as.factor(culture$SRCHWRD_NM)  
culture$UPPER_CTGRY_NM <- as.factor(culture$UPPER_CTGRY_NM)
culture$LWPRT_CTGRY_NM <- as.factor(culture$LWPRT_CTGRY_NM)


# 8. �������� �Ӽ� ----
# ������ : 2���� ������ ������
# ��� ���� �����Ǿ� ����
# data.frame, tibble, data.table(������ ���� �ʹ� Ŭ �� table�� ��ȯ; �ӵ� ����)
# ��, data.frame�� tibble�� data.table�� ���·� �ٲٸ� �м� �ӵ��� ������ ������ ����
# ���� : ��Ű�� �� data.table�� ����
# ���� : SQL(DB�� �ٷ� Ŀ�´����̼� �ϴ� ��; �ӵ� ����) # ��, SQL�� DB�� �ٷ� Ŀ�´����̼� �ؼ� DB���� �ٷ� ������ �� ����. �ӵ��鿡�� ���� 


# 8.1 ���� ���� ----
# nrow(data)
nrow(culture)


# 8.2 ��(Column) = ����(Variable) = Feature = Label ----
# ncol(data)
ncol(culture)


# 8.3 ���� �̸� ----
# colnames(data)
colnames(culture)


# 9. ������ �����̽�(Data Slicing) ----
# 9.1 �� ----
# dplyr::select(data, variable)

# Ctrl + Shift + m : %>%(Pipe; data�� function�ȿ� �־��ִ� ����)
# data %>% dplyr::select(variable)    # �߱�


# data %>% funtion()
# (1) x %>% f()  => f(x)
# (2) x %>% f(y) => f(x,y)
# (3) x %>% f()
#       %>% g()  => g(f(X))
culture %>%
  dplyr::select(RANK)

culture %>% 
  dplyr::select(RANK, SCCNT_SM_VALUE)

culture %>%
  dplyr::select(RANK:SCCNT_SM_VALUE)  # �������� �� ����

culture %>% 
  dplyr::select(-RANK)  # RANK�� �� �������� �� ������

culture %>% 
  dplyr::select(-c(RANK, SCCNT_SM_VALUE))

# �������� Ư���� ������ �ִ� ���
# i. �������� 'p'��� ���ڰ� �ִ� ���
culture %>% 
  dplyr::select(contains("P"))

# ii. �������� 'S'��� ���ڷ� �����ϴ� ���
culture %>% 
  dplyr::select(starts_with("S"))

# iii. �������� 'E'��� ���ڷ� ������ ���
culture %>% 
  dplyr::select(ends_with("E"))


# 9.2 �� ----
# dplyr::filter(data, ����)
# data %>% dplyr::filter(����)  # �߱�

# (1) RANK�� 5������ data
culture %>% 
  dplyr::filter(RANK <= 5)  # �� ������ ���ǿ� �´� ���� �߶󳻴� ��


# (2) LWPRT_CTGRY_NM�� "����"�� data
culture %>% 
  dplyr::filter(LWPRT_CTGRY_NM == "����")


# (3) RANK�� 5�����̰�,  LWPRT_CTGRY_NM�� "����"�� data
culture %>% 
  dplyr::filter(RANK <= 5, LWPRT_CTGRY_NM == "����")

  
# (4) RANK�� 5�̰ų� �Ǵ�  LWPRT_CTGRY_NM�� "����"�� data
# tibble�� data�� �ǹ��Ѵ�.
culture %>% 
  dplyr::filter(RANK <= 5 | LWPRT_CTGRY_NM == "����") 


# ������� ������ �����͸� ���� �ʹٸ� �̷��� ����!
culture %>% 
  dplyr::filter(RANK <= 5 | LWPRT_CTGRY_NM == "����") %>% 
  View()


# 9.3 ��� �� ----
# RANK�� 5�����̰�,  LWPRT_CTGRY_NM�� "����"�� ��������
# 'E'��� ���ڷ� ������ ��
# ��� ���� �����̽��� ���� select(��)���� filter(��)�� �׻� ���� �߶��ش�!
culture %>% 
  dplyr::filter(RANK <= 5, LWPRT_CTGRY_NM == "����") %>%
  dplyr::select(ends_with("E")) -> culture2    # �ٸ� ������ �̰� ��������

# (1) �ܰ躰�� � �۾��� �ϴ��� ��Ÿ�� �� �ְ�,
# (2) �߰��� �����͸� ������ �ʿ䰡 ���� ������
# Pipe�� ���� �� ����!

# %>% �� ����ϸ� ������� ���� �۾��� �ߴ��� �Ѵ��� �ܰ躰�� �� �� ����
# �߰��� ���ʿ��� �����͸� �������� �ʰ� �츮�� ���ϴ� �������� �����͸� ���� �� ����
# �߰��� �����Ͱ� ����� �� �� ���� ������? �޸𸮸� �����ϱ� ������.
# �������� �����Ͱ� �ʹ� ũ�� �޸� �뷮�� �ʹ� ���� �����ϰ� �ȴ�.


# 10. ���ο� ���� ����� ----
# dplyr::mutate(new_variable = )
# 10.1 ���� ----
culture %>% 
  dplyr::mutate(TOTAL_VALUE = MOBILE_SCCNT_VALUE + PC_SCCNT_VALUE + SCCNT_SM_VALUE) -> culture 
# "-> culture"�� �ؾ� ������ ����Ⱑ �ȴ�. �׷��� TOTAL_VALUE��� �÷��� ����.�̰� �� ���ָ� �׳� �� �۾��� �� ����.
# %>% �� �ܼ�â���� �����ִ� �ͱ���

# 10.2 ��ȯ ----
# (1) �α� ��ȯ 
# (2) ��Ʈ ��ȯ
# (3) ���� ��ȯ
# ��Ī�� Ȯ���ϱ� ���ؼ�
culture %>% 
  dplyr::mutate(total_log10   = log10(TOTAL_VALUE),
                total_root    = sqrt(TOTAL_VALUE),
                total_inverse = 1/TOTAL_VALUE) -> culture
View(culture)



# 10.3 ����(����) ���̱� ----
# 10.4 ���������� ���� ���� ----


