## 1. 패키지 설치
install.packages('ggiraphExtra')
install.packages('maps')
install.packages('gridExtra')

## 2. 패키지 로딩
library(ggiraphExtra)
library(tibble)
library(ggplot2)
library(gridExtra)


## 3. 데이터셋 로딩 및 주 이름값을 소문자로 변환
head(USArrests)
# rownames_to_column(df, var = '새로운 컬럼명') : 행 이름을 변수로 변환
crime <- rownames_to_column(USArrests, var = 'state')
# tolower : 영문자를 모두 소문자로 변환
crime$state <- tolower(crime$state)
print(crime$state)

## 4. 미국 주 별 위도, 경도 값 가져오기
# map_data
states_map <- map_data('state')
str(states_map)
View(states_map %>% filter(region == 'alabama'))


## 5. 시각화
# 1) 주별 살인율 단계 구분도
ggChoropleth(data = crime,
             aes(fill = Murder, map_id = state),
             map = states_map)

# interactive = T : 사용자의 마우스를 따라서 추가적인 데이터 정보 제공
ggChoropleth(data = crime,
             aes(fill = Murder, map_id = state),
             map = states_map,
             interactive = T)

# 2) 주별 폭행율 단계 구분도
ggChoropleth(data = crime,
             aes(fill = Assault, map_id = state),
             map = states_map,
             interactive = T)


## 6. 인구수 대비 강력범죄 발생율 (화면 분할)
# 나타내고 싶은 plot을 각 변수에 저장
# 1) 살인율
p1 <- ggplot(data = crime, aes(x = UrbanPop, y = Murder))+
  geom_point()+
  stat_smooth(level = 0.9)

# 2) 폭행율
p2 <- ggplot(data = crime, aes(x = UrbanPop, y = Assault))+
  geom_point()+
  stat_smooth(level = 0.9)

# 3) 강간
p3 <- ggplot(data = crime, aes(x = UrbanPop, y = Rape))+
  geom_point()+
  stat_smooth(level = 0.9)

grid.arrange(p1, p2, p3)
