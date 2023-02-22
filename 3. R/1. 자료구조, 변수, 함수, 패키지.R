# Age : numeric (Integer) / 수치형/범주형
# Job : character / 범주형
# Marital : character / 범주형
# Balance : numeric / 수치형
# Campaign : character / 범주형
# Y : logical / 범주형

# 1. 컬럼 별 변수 생성
age <- c(30, 33, 35, 30, 68, 33)
job <- c('무직', '서비스', '관리직', '관리직', '은퇴', '관리직')
marital <- c('결혼', '결혼', '미혼', '결혼', '사별', '결혼')
balance <- c(1787, 4789, 1350, 1476, 4189, 3935)
campaign <- c('휴대폰', '휴대폰', '휴대폰', 'Unknown', '유선전화', '휴대폰')
Y <- c(F, F, F, F, T, T)

# 2. 데이터프레임 생성한 것을 result 변수에 할당
result <- data.frame(age, job, marital, balance, campaign, Y)

# 3. 결과 출력
print(result)

# 4. 평균 나이, 평균 은행 잔고 출력
age_mean <- mean(age)
age_mean   # [OUT] 38.16667

balance_mean <- mean(balance)
balance_mean  # [OUT] 2921

# 5. 대출을 신청한 사람 수 계산
yToNum <- as.numeric(Y)  # [OUT] 0 0 0 0 1 1
yCount <- sum(yToNum)
print(yCount)  # [OUT] 2

# 6. 데이터값 수정
# 1) stringr 패키지 사용
install.packages('stringr')
library(stringr)

# 2) job 컬럼의 '은퇴' → '무직'으로 대체
job_new <- str_replace(job, '은퇴', '무직')
print(job_new)

# 3) marital 컬럼의 형을 logical로 변환 ('결혼' : T, 그 외 : F)
# '결혼'값을 'T'로 변환
marital_new <- str_replace(marital, '결혼', 'T')
print(marital_new)

# 문자형을 논리형으로 강제 형변환
marital_logical <- as.logical(marital_new)
print(marital_logical)

# NA 값을 F로 변환
marital_logical[is.na(marital_logical)] = FALSE
print(marital_logical)

# 4) 수정된 결과물은 result_new 변수에 할당 후 출력
result_new <- data.frame(age, job_new, marital_logical, balance, campaign, Y)
print(result_new)
