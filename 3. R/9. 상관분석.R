# 내장데이터셋 활용
data <- iris

## 1. 피어슨 상관계수
# 꽃받침 길이와 꽃잎 넓이 간 피어슨 상관계수 측정 
cor(data$Sepal.Length, data$Petal.Width)  # [OUT] 0.8179411

# 귀무가설 : '두 변수는 서로 상관 관계가 없다.'
cor.test(data$Sepal.Length, data$Petal.Width)

# 여러 개 변수 상관분석
cor(data[, 1:4])

# 변수 별 산점도 그래프 출력 (시각화)
pairs(data[, 1:4])


## 2. 켄달, 스피어만 상관계수
# 1) 켄달 상관계수
cor(data[, 1:4], method = 'kendall')
pairs(data[, 1:4], method = 'kendall')

# psych 패키지 (통계 관련 유용한 함수 제공)
install.packages('psych')
library(psych)

# 컬럼 별 상관계수, 컬럼 별 상관관계 가설 검정 수치 모두 출력
# cor 함수와 corr.test 함수 동일
corr.test(data[, 1:4],
          use = 'complete',
          method = 'kendall',
          adjust = 'none')

# 2) 스피어만 상관계수
cor(data[, 1:4], method = 'spearman')

pairs(data[, 1:4], method = 'spearman')

corr.test(data[, 1:4],
          use = 'complete',
          method = 'spearman',
          adjust = 'none')

## 3. corrplot 패키지 (상관계수 시각화)
install.packages('corrplot')
library('corrplot')

col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
M = cor(iris[, 1:4])   

corrplot(M,                       # 데이터
         method = 'color',        # 색상 
         col = col(150),          # 컬러 스펙트럼 (갯수)
         type = 'upper',          # 레이아웃 (“full”(디폴트)“,”upper“,”lower“)
         order = 'hclust',        # 행렬의 재정렬 (hclust : 계층 분석)
         number.cex = .7,
         addCoef.col = 'black',   # 계수 표현
         tl.col = 'black',        # 라벨 색
         tl.srt = 90,             # 위쪽 라벨 회전 각도
         sig.level = 0.01,        # 유의수준 
         insig = 'blank',         # 유의하지 않는 경우 비워두기
         diag = FALSE)            # 대각선 표시 x              
