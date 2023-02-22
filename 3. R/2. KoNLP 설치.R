## 1. 영화평 데이터 실습에 필요한 패키지 설치
# 1) 자바 관련 패키지
install.packages('rJava')
install.packages('memoise')

# 2) KoNLP 관련 패키지 설치
# java, rjava 설치
install.packages('multilinguer')
library(multilinguer)
install_jdk()

# 의존성 패키지 설치
install.packages(c("hash", "tau", "Sejong", "RSQLite", "devtools", "bit", "rex", "lazyeval", "htmlwidgets", "crosstalk", "promises", "later", "sessioninfo", "xopen", "bit64", "blob", "DBI", "memoise", "plogr", "covr", "DT", "rcmdcheck", "rversions"), type = "binary")

# 깃허브 버전 설치
install.packages("remotes")

# KoNLP 설치
remotes::install_github('haven-jeon/KoNLP', upgrade = "never", INSTALL_opts=c("--no-multiarch"))

## 2. 패키지 로딩
library(KoNLP)

# 테스트
extractNoun('데이터분석 교육 중입니다.')