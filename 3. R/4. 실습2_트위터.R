## 1. 실습에 팰요한 패키지 로딩
library(KoNLP)
library(dplyr)
library(stringr)
library(ggplot2)

useNIADic()

## 2. 데이터 로딩
twitter <- read.csv('twitter.csv',
                    header = T,
                    stringsAsFactors = F,
                    fileEncoding = 'UTF-8')

str(twitter$내용)


## 3. 데이터 전처리
# 1) 특수문자 제거
twitter$내용 <- str_replace_all(twitter$내용, '[[:punct:]]', ' ')
head(twitter$내용)

# 2) 명사 추출
nouns <- extractNoun(twitter$내용)
wordcount <- table(unlist(nouns))

# 3) 데이터프레임으로 변환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word <- rename(df_word, word = Var1, freq = Freq)

# 4) 1글자 단어 제거
df_word <- filter(df_word, nchar(word) >= 2)

# 5) top20 확인
top20 <- df_word %>% arrange(desc(freq)) %>% head(20)


## 4. 데이터 시각화
# 1) 빈도 별로 정렬
order <- arrange(top20, desc(freq))$word

# 2) 막대그래프
# geom_col() : 범주형(x)별 값(y)을 막대그래프로 그려줌
# scale_x_discrete() : x축 좌표 값을 범주형 값으로 변경
# geom_text() : 그래프 내 텍스트 그려주는 함수
ggplot(top20, aes(x = word, y = freq))+
  geom_col()+
  scale_x_discrete(limit = order)+
  ggtitle('국정원 트윗 고빈도 노출단어 Top 20')+
  geom_text(aes(label = freq), vjust = -0.8)
