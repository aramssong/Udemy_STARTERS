## 1. 데이터 불러오기
# 데이터 로딩 과정을 함수화 
myload_data <- function(path){
  data <-read.table(path, header = T, sep = ';')
  
  for (col in names(data)){
    data[, col] <- as.numeric(data[, col])  # 모든 값들이 문자열로 덮여 있으므로 숫자형으로 변경
  }
  return(data)
}

red_wine <- myload_data('winequality-red.csv')
white_wine <- myload_data('winequality-white.csv')

## 2. 데이터의 속성 별 상관관계 분석 & 시각화
library(corrplot)

# 피어슨 상관계수를 활용한 시각화 함수
mydraw_correlation <- function(data, cor_method = "pearson"){
  M <- cor(data, method = cor_method)
  names(M) <- names(data)
  col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
  corrplot(M,
           method = 'color',
           col = col(150),
           type = 'upper',
           order = 'hclust',
           number.cex = .7,
           addCoef.col = 'black',
           tl.col = 'black',
           tl.srt = 90,
           sig.level = 0.01,
           insig = 'blank',
           diag = FALSE)
}

# 함수를 활용한 시각화 (피어슨, 스피어만)
mydraw_correlation(white_wine)
mydraw_correlation(red_wine)
mydraw_correlation(white_wine, 'spearman')
mydraw_correlation(red_wine, 'spearman')


## 3. 변수 별 산점도 그래프 (잘 보이지 않음)
pairs(red_wine)
pairs(white_wine)


## 4. 상자그림 그래프
library(ggplot2)
ggplot(red_wine, aes(y = alcohol))+
  geom_boxplot(aes(col = factor(quality)))

ggplot(white_wine, aes(y = alcohol))+
  geom_boxplot(aes(col = factor(quality)))


## 5. 가설 검정
# 귀무가설 : 알코올 도수 평균 값이 11.25%다.\
# shapiro.test() 함수 : p-value가 유의수준보다 크면 정규분포를 따름 / 귀무가설 채택
shapiro.test(red_wine$alcohol)  # 귀무가설 기각, 정규분포 따르지 않음

shapiro.test(white_wine$alcohol)  # 귀무가설 기각, 정규분포 따르지 않음


## 6. 알코올 도수 분포 확인 (히스토그램)
# 저품질 와인(3~6)들의 분포가 낮은 알코올 도수에 지나치게 치우쳐 있음
ggplot(red_wine)+
  geom_histogram(aes(x = alcohol, fill = factor(quality)))

## 7. 품질이 7 이상인 데이터만 사용하여 정규성 검증하기
# 고품질 레드와인에 대한 가설검정은 의미가 있다.
library(dplyr)

high_quality_white <- white_wine %>% filter(quality > 6)
shapiro.test(high_quality_white$alcohol)  # 귀무가설 기각

high_quality_red <- red_wine %>% filter(quality > 6)
shapiro.test(high_quality_red$alcohol)  # 귀무가설 채택


## 8. 고품질 레드 와인, 전체 레드 와인의 알코올 도수 분포를 시각화
red_wine %>% filter(quality > 6) %>% ggplot()+
  geom_density(aes(x = alcohol), col = 'red')+     # 고품질 레드와인의 알코올 분포
  geom_density(data = red_wine, aes(x = alcohol))  # 전체 레드와인의 알코올 분포


## 9. 고품질 레드 와인의 평균 알코올 도수는 11.5%이다. 가설 검정
# 모집단의 표준편차 값을 알 수 없으므로 t검정 사용
# 결과 : 귀무가설 채택 (고품질 레드 와인의 평균 알코올 도수는 11.5%이다.)
t.test(x = high_quality_red$alcohol, alternative = 'two.sided', mu = 11.5, conf.level = 0.95)