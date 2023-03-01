## 1. 벡터/매트릭스 연산
# --> 동일한 인덱스 간 연산

v1 <- c(1,2,3)
v2 <- c(4,5,6)
v1+v2

l1 <- c(T,T,F)
l2 <- c(T,T,T)
l1+l2
l1&l2 # [OUT] TRUE  TRUE FALSE
l1|l2 # [OUT] TRUE TRUE TRUE

m1 <- matrix(c(1,2,3,4,5,6), nrow=2, ncol=3)
m2 <- matrix(c(2,3,4,5,6,7), nrow=2, ncol=3)
m1+m2

## 2. 브로드캐스팅 연산
v1 + 100  # [OUT] 101 102 103

l1 & T    # [OUT] TRUE  TRUE FALSE


## 3. 데이터프레임에서 데이터 추출하기
library('dplyr')
library('ggplot2')

data <- airquality
str(data)
head(data)

# Month별 데이터 수
table(data$Month)
data %>% select(Month) %>% table()

# 7월 모든 데이터
data[which(data$Month == 7), ]
data %>% filter(Month == 7)

# 7월 31일 데이터
data[which((data$Month == 7) &(data$Day == 31)), ]
data %>% filter(Month == 7 & Day == 31)

# 7월 31일 Ozone, Solar.R
data[which((data$Month == 7) &(data$Day == 31)), c('Ozone', 'Solar.R')]
data[which((data$Month == 7) &(data$Day == 31)), c(1, 2)]
data %>% filter(Month == 7 & Day == 31) %>% select('Ozone', 'Solar.R')

# 7월 데이터를 data7 데이터프레임으로 만들고
# 7월 Ozone 평균 구하기
data7 <- data %>% filter(Month == 7)
data7

mean(data7$Ozone)  # [OUT] NA (데이터에 결측치가 있기 때문)

mean(data7$Ozone, na.rm = T)  # [OUT] 59.11538 (na.rm = T : 결측치를 제외하고 평균값을 출력)

# 7월 Ozone 결측치 갯수 확인(함수중첩)
sum(is.na(data7$Ozone))   # [OUT] 5

# 7월 Ozone 결측치 갯수 확인(dplyr 파이프연산자 사용)
data7$Ozone %>% is.na() %>% sum()

# 결측치 제외하고 7월 Ozone평균 계산, 반올림하여 소수점 1자리까지 표현(dplyr 파이프연산자 사용)
data7$Ozone %>% mean(na.rm = T) %>% round(1)

# dplyr select 함수 사용하여 data7에서 Month, Day, Ozone, Temp 컬럼 추출
data7 %>% select(Month, Day, Ozone, Temp)

# dplyr filter 함수 사용하여 data7에서 Temp가 90 이상인 행 추출
data7 %>% filter(Temp >= 90)

# dplyr 패키지 사용하여 data7에서 Temp가 90 이상인 Month, Day, Temp 추출
data7 %>% filter(Temp >= 90) %>% select(Month, Day, Temp)

# data의 Month로 그룹화
data %>% group_by(Month)

# 그룹별 평균 Temp, Wind
data %>% group_by(Month) %>% summarise(temp_avg = mean(Temp), wind_avg = mean(Wind))

##########################
# ggplot
##########################
# data7의 Temp의 변화를 line그래프로 표현
ggplot(data7, aes(x = Day, y = Temp))+
  geom_line()

# 월별 Temp의 변화를 서브그래프로 각각 표현(3행 2열)
ggplot(data, aes(x = Day, y = Temp))+
  geom_line()+
  facet_wrap(~Month,
             labeller = label_both,
             nrow = 3, ncol = 2)

# 회귀선 추가(신뢰구간:0.95)
ggplot(data, aes(x = Day, y = Temp))+
  geom_line()+
  facet_wrap(~Month,
             labeller = label_both,
             nrow = 3, ncol = 2)+
  stat_smooth(level = 0.95)

# 제목 작성 ('월별 기온')
ggplot(data, aes(x = Day, y = Temp))+
  geom_line()+
  facet_wrap(~Month,
             labeller = label_both,
             nrow = 3, ncol = 2)+
  stat_smooth(level = 0.95)+
  ggtitle('월별 기온')
