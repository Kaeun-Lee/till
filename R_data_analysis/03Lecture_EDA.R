# 1. ��Ű�� ��ġ�ϱ�� �ε��ϱ� ----
install.packages("readxl")
install.packages("writexl")
install.packages("tidyverse")   # �߱�
install.packages("e1071")       # ������ ����� �� ��; �ֵ�, ÷��
library(readxl)
library(writexl)
library(tidyverse)
library(e1071)

# 2. �۾����� �����ϱ� ----
setwd("d:/KCISA")
getwd


# 3. ������ �о���� ----
culture <- readxl::read_excel(path      = "culture.xlsx",
                              sheet     = "DM",
                              col_names = TRUE)


# 4. EDA(Exploratory Data Analysis) = Ž���� ������ �м� ----
# ǥ, �׷����� ���� �����Ͱ� �� �ǹ��ϴ��� ������� �ܰ� -> ��ü, ����, Ÿ��, ���κ��� ���� ö���� ���� �Ѵ�!! �׷��� insight�� ���� �� ����!�ڡڡ�


# 4.1 �Ϻ��� ���� �ڷ��� �м� ----
# �Ϻ��� : Uni-Variate(�ϳ��� ���ϴ� � ��)
# ���   : ������ �ʴ� ��
# �ϳ��� �� = �ϳ��� ���� = �ϳ��� Feature = �ϳ��� Label
# ���� �ڷ� = ������ �ڷ� : ���� �Ǵ� ����(������ �ǹ� X)

# (1) ǥ = ��ǥ(Frequency Table) ----
# ����п����� '��������ǥ'��� ��
# i.  ��(Frequency) : �� ���� �� ���� �ִ��� �ϳ��ϳ� �� �� 
# ii. �����(Percent) : (��/�հ�)*100. �ϳ��ϳ��� ������ �ִ� �� �ƴ϶�, ��ü�� 100���� ���� �� � �ϳ��� ��ü�� �󸶸�ŭ�� �����ϴ� �� �˰� ���� �� 

# SRCHWRD_NM
culture %>% 
  dplyr::count(SRCHWRD_NM, sort = TRUE) %>%     # ���� �˻��� ���� �� ������ ��������
  dplyr::mutate(percent = round((n/sum(n)) * 100, digits = 1)) %>% 
  writexl::write_xlsx(path = "SRCHWRD_NM.xlsx")


# (2) �׷��� ----
# i.  ����׷���
# ii. ���׷���


# LWPRT_CTGRY_NM
culture %>% 
  ggplot2::ggplot(mapping = aes(x = LWPRT_CTGRY_NM)) +         # aes(x)�� ���� �׷���, aes(y)�� ���� �׷���
  ggplot2::geom_bar(fill = "red") +                            # fill = "purple"
  ggplot2::theme_classic() +                                   # �ڿ� ���� ���̸� ������
  ggplot2::labs(title = "���� ī�װ������� ��Ȳ",              # title : ��Ʈ�� ����
                x     = "���� ī�װ�����",
                y     = "Frequency") +
  ggplot2::theme(plot.title = element_text(size  = 20,
                                           color = "red",
                                           face  = "bold",
                                           hjust = 0.5),       # ����� �������ش�. 0.5�� �����
                 axis.title.x = element_text(size = 15,        # axis.title.x : x���� ����
                                             face = "italic"),
                 axis.title.y = element_text(size = 15,
                                             face = "bold.italic",
                                             angle = 0,        # y�� �۾��� ���ΰ� �ƴ� ���η� ���ش�
                                             vjust = 0.5)) +   # ���� ��� ����
  ggplot2::ggsave(filename = "LWPRT_CTGRY_NM.jpeg",
                  width    = 5,       # ���� 5 inch
                  height   = 5,       # ���� 5 inch
                  units    = "in")    # units�� ����Ʈ ũ�Ⱑ inch��

# ����
# units : "in", "cm", "mm"
# "in" : inch 

  
# 4.2 �Ϻ��� ���� �ڷ��� �м� ----
# ���� �ڷ� : ��ġ�� �ڷ�(Numerical data)
# (1) ǥ = ��ǥ ----
# i.  ������ ��
# ii. ������ �����

# ���Ŵ� �������� 02Lecture���� �ߴ� �� �ٽ� �ҷ���
# culture <- readxl::read_excel(path      = "culture.xlsx",
#                               sheet     = "DM",
#                               col_names = TRUE)
# 
# culture %>%
#   dplyr::mutate(TOTAL_VALUE = MOBILE_SCCNT_VALUE + PC_SCCNT_VALUE + SCCNT_SM_VALUE) -> culture
# 
# 
# culture %>%
#   dplyr::mutate(total_log10   = log10(TOTAL_VALUE),
#                 total_root    = sqrt(TOTAL_VALUE),
#                 total_inverse = 1/TOTAL_VALUE) -> culture



# �ּҰ�, �ִ밪
min(culture$TOTAL_VALUE)
max(culture$TOTAL_VALUE)

# ���� : �ִ밪 - �ּҰ�
RANGE <- max(culture$TOTAL_VALUE) - min(culture$TOTAL_VALUE)

# ������ ���� : Sturge's Formula
INTERVAl_N <- 1 + 3.3 * log10(length(culture$TOTAL_VALUE))

# ������ �ʺ� : ���� / ������ ����
INTERVAL_WIDTH <- RANGE / 13


culture %>% 
  dplyr::mutate(total_group = cut(TOTAL_VALUE,
                                  breaks = seq(from = 50, to = 3690, by = 260),     # ������ ������ �ش�
                                  right  = FALSE)) -> culture
View(culture)


culture %>% 
  dplyr::count(total_group, sort = TRUE) %>% # ���� �˻��� ���� �� ������ ��������
  dplyr::mutate(percent = round((n/sum(n)) * 100, digits = 1)) %>%  
  writexl::write_xlsx(path = "total_group.xlsx")


# (2) �׷��� ----
# i.  ������׷�(Histogram) ----
culture %>% 
  ggplot2::ggplot(mapping = aes(x = TOTAL_VALUE)) +
  ggplot2::geom_histogram(fill = "red")

# ������ �ʺ� : binwidth =
culture %>% 
  ggplot2::ggplot(mapping = aes(x = TOTAL_VALUE)) +
  ggplot2::geom_histogram(binwidth = 100)  # 0~100 , 101~ 200

# ������ ���� : bins =
culture %>% 
  ggplot2::ggplot(mapping = aes(x = TOTAL_VALUE)) +
  ggplot2::geom_histogram(bins = 10)

# �پ��ϰ� �׷����鼭 �м��غ��� �� �߿��ϴ�!

# ii. ���ڱ׸�(Boxplot) ----
# �̻�ġ(outlier)�� �ִ����� �ľ��ϱ� ���� �ۼ���
culture %>% 
  ggplot2::ggplot(mapping = aes(y = TOTAL_VALUE)) +   # ���ڴ� ���� ���η� ���� ��/ �������� ���ڴ� �ǹ̾���
  ggplot2::geom_boxplot()


# (3) �����跮 = �����跮 ----
# ���� �� �ִٸ� ���� �ڷ�� ���ϴ� �� ���� ��

# i. �߽� = ��ǥ�� ----      
# : ���(�̻�ġ�� ������ ���� ����), �������(�������; �� ���� �Ϻθ� ����), ������(�߾Ӱ�; median), �ֺ��(�ֺ�) 
# ��ǥ���� ��ǥ���� ��ǥ�� ���ϴ� ���� ����ϴٴ� ��
# ���� �ڷ��� �߽��� ����ִ°�, ���� �ڷ��� ��ǥ���� �����ΰ��� ������ ������ ��
# ����� ���ߴٴ� �� �� ���� �ڷḦ ��ǥ�ϴ� ���� ���ϰ� �ʹٴ� ��������, �̻�ġ�� ������ ���ϰ� ����
culture %>% 
  dplyr::summarise(n           = n(),
                   Mean        = mean(TOTAL_VALUE),
                   TrimmedMean = mean(TOTAL_VALUE, trim = 0.05),   # ������
                   Median      = median(TOTAL_VALUE))   


# ii. ���� = ���� = �ٸ� : ����, ���������, ǥ������, ���������������ڡ� ----
# "�󸶳� �ٸ���"�� ���� ������ ������ �Ѵ�!!
# �� �ٸ��� ���� �����ص� �ɸ��� ����, �����ϸ� �ȵǴ� ���� ������ �Ѵ�!
# -> ��������
# ���̰� ������ �� ���� ������ '�ʿ���'�� ���̶��
# �� '����'�� ã�� ���� �ſ�ſ� �߿��ϴ�!

# ����� ���ٴ� �� '�ٸ��� �������� �ʰڴ�'�� ���� �ǹ̸� �����ϰ� ����
# ������, ������ �м����� "�ٸ��� �����ؾ� �Ѵ�!"
# '���'�� ���������� �����ÿ� ���ϰ��� �ϴ� ��� �ش���� ���� �� �ִ�.

culture %>% 
  dplyr::summarise(Range = max(TOTAL_VALUE, na.rm = TRUE) - min(TOTAL_VALUE),    # ����ġ ����
                   IQR   = IQR(TOTAL_VALUE),     # InterQuartile Range(3������ - 1������)
                   SD    = sd(TOTAL_VALUE),      # ǥ������, ���⿡���� ��հ� �� 500�������� ���̰� ��
                   MAD   = mad(TOTAL_VALUE))     # ��������������, �������� �� 359 ���� �ٸ������� �� �� ����


# iii. ������ ��� : �ֵ�, ÷�� ----
# �⺻��ɿ����� �ֵ��� ÷���� �� ���Ѵ�.
# ��Ű�� : e1071
culture %>% 
  dplyr::summarise(SKEW = e1071::skewness(TOTAL_VALUE),    # summarise: ��� ��跮
                   KURT = e1071::kurtosis(TOTAL_VALUE)) 


# 4.3 �̺��� �ڷ��� �м�(���� �ڷ� vs ���� �ڷ�) ----
# �̺���    : Bi-Variate
# �ٺ���    : Multi(ple)-Variate : 3�� �̻�
# ���� �ڷ� : ����
# ���� �� ������ �ڷ��� �м�

# (1) ���ܺ� �׷��� ----
# i. ���ܺ� ������׷� ----
culture %>% 
  ggplot2::ggplot(mapping = aes(x = TOTAL_VALUE)) +    # �ַ� x ���� ���� �ڷḦ �־��ش�
  ggplot2::geom_histogram() +
  ggplot2::facet_wrap(~LWPRT_CTGRY_NM)                 # ���� = facet

# ii. ���ܺ� ���ڱ׸� ----
culture %>% 
  ggplot2::ggplot(mapping = aes(y = TOTAL_VALUE)) +    
  ggplot2::geom_boxplot(outlier.colour = "red") +      # outlier �� �ֱ� ��
  ggplot2::facet_wrap(~LWPRT_CTGRY_NM)                 # ���� = facet, ~ + �����ڷ�(����)

# iii. ���ܺ� ���̿ø� �׸� ----
# �������� ������ ���� ���� �ð�ȭ
culture %>% 
  ggplot2::ggplot(mapping = aes(x = LWPRT_CTGRY_NM,
                                y = TOTAL_VALUE,
                                fill = LWPRT_CTGRY_NM)) +    
  ggplot2::geom_violin()


# (2) ���ܺ� �����跮 ----

culture %>% 
  dplyr::group_by(LWPRT_CTGRY_NM) %>% 
  dplyr::summarise(n           = n(),
                   Mean        = mean(TOTAL_VALUE),
                   Median      = median(TOTAL_VALUE)) %>% 
  dplyr::arrange(desc(Mean))  %>%                      # ������������ ����
  writexl::write_xlsx(path = "statistics_by.xlsx")


culture %>% 
  dplyr::group_by(LWPRT_CTGRY_NM, SRCHWRD_NM) %>%      # �� ���� �׷��� ���ϱⰡ �Ǵ� ����
  dplyr::summarise(n           = n(),
                   Mean        = mean(TOTAL_VALUE),
                   Median      = median(TOTAL_VALUE)) %>% 
  dplyr::arrange(desc(Mean))                           # descending �Լ� �ȿ� �־���

