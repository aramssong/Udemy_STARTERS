## 1. 실습에 팰요한 패키지 로딩
library(KoNLP)
library(dplyr)
library(stringr)

useNIADic()  # NIA 사전 사용

## 2. 데이터 로딩 및 영화평 벡터 생성
# 1) 데이터 로딩 (readLines 함수  - 한 줄로 읽어옴)
txt <- readLines('ratings.txt', encoding = 'UTF-8')

# 2) 영화평으로만 구성된 벡터 생성 (반복문 사용)
result <- strsplit(txt, split = '\t')
data <- vector('character', length(result))
i <- 1

for (item in result){
  data[i] <- item[2]
  i <- i+1
}

## 3. 영화평 내 특수문자 제거 및 명사 추출
# 1) 영화평 내 특수문자 제거
data <- str_replace_all(data, '[[:punct:]]', "")
print(data[496]) # 특정 행으로 확인하기

# +) 명사 추출에 오래걸려 데이터 일부만 사용
data <- data[1:10000]

# 2) 명사 추출
nouns <- extractNoun(data)

## 4. 추출한 명사 별 등장 횟수를 데이터프레임으로 저장
# 1) 명사별 등장 횟수
wordcount <- table(unlist(nouns))

# 2) 데이터프레임 형식 (1열 : 명사, 2열 : 등장횟수)
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
str(df_word)  # 15985개 데이터, Var1, Freq 라는 2개의 열
df_word <- rename(df_word, word = Var1, freq = Freq) # 컬럼명 변경
class(df_word$word)

# 3) 단어수 3글자 이상인 행만 남김
df_word <- filter(df_word, nchar(word) > 2)

# 4) 테스트
top_40 <- df_word %>% arrange(desc(freq)) %>% head(40)
print(top_40)


## 5. wordcloud 패키지 활용
# 1) 패키지 설치
install.packages('wordcloud')

# 2) 패키지 로드
library(wordcloud)
library(RColorBrewer)

# 3) Dark2 색상 목록에서 8개 색상 추출
pal <- brewer.pal(8, 'Dark2')
pal
set.seed(1)

# 4) wordcloud 출력
wordcloud(words = df_word$word, 
          freq = round(sqrt(df_word$freq)),   # 빈도 (sqrt 함수 사용하여 차이 줄임)
          min.freq = 5,      # 최소 단어 빈도
          max.words = 200,   # 표현 단어수
          random.order = F,  # 고빈도 단어 중앙 배치 
          rot.per = .1,      # 회전 단어 비율
          scale = c(4, 0.5), # 단어 크기 범위
          colors = pal)      # 색상 목록
