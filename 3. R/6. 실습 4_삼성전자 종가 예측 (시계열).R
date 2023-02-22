## 1. 패키지 설치
install.packages('forecast')
install.packages('quantmod')


## 2. 패키지 로딩
library(forecast)
library(quantmod)
library(dplyr)
library(ggplot2)
library(tibble)


## 3. 데이터 로딩
# 예측할 데이터
data_pred = getSymbols('005930.KS',
                       from = '2021-01-01',
                       to = '2021-09-01',
                       auto.assign = FALSE)
# 실제 데이터
data_real = getSymbols('005930.KS',
                       from = '2021-01-01',
                       to = '2021-10-30',
                       auto.assign = FALSE)


## 4. 전처리
# 1) 데이터셋 컬럼명 변경
names(data_pred) <- c("open", "high", "low", "close", "volume", "adjusted")
names(data_real) <- c("open", "high", "low", "close", "volume", "adjusted")

head(data_pred)

# 2) 행 이름을 변수로 변환 (날짜)
# rownames_to_column : tibble 패키지에 있는 함수
data_pred <- rownames_to_column(as.data.frame(data_pred), var = 'date')
data_real <- rownames_to_column(as.data.frame(data_real), var = 'date')

# 3) Date 타입으로 형 변환
data_pred$date <- as.Date(data_pred$date)
data_real$date <- as.Date(data_real$date)

tail(data_pred)
tail(data_real)

## 5. 값 예측
# 1) 예측 길이 구하기 (예측할 갯수 : 9월 ~ 10월 2달치)
pred_length <- length(data_real$close) - length(data_pred$close)
print(pred_length)   # [OUT] 37

# 2) 데이터 예측
# forecast(데이터, h = 예측할 데이터 갯수) : 시계열 데이터 예측
test <- forecast(data_pred$close, h = pred_length)
test <- as.data.frame(test)
str(test)  # 37개 데이터

## 6. 시각화
# 1) data_pred 컬럼을 새롭게 만들기 (8월까지 있는 데이터 + 예측한 데이터 합침) 
data_real[,"pred_close"] <- c(data_pred$close, test$`Point Forecast`)
str(data_real)

# 2) 1월 ~ 10월까지 1개월 단위로 데이터 생성 (x축의 범위로 사용하기 위함)
datebreaks <- seq(as.Date('2021-01-01'), as.Date('2021-10-01'), by = '1 month')

# 3) 그래프 그리기
ggplot(data = data_real, aes(x = date))+
  geom_line(aes(y = pred_close, col = 'red'))+
  geom_line(aes(y = close))+
  scale_x_date(breaks = datebreaks)+
  theme(axis.text.x = element_text(angle = 30, hjust = 1))
