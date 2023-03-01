# 모집단 평균 63, 분산 3
# 유의수준 0.05
# 귀무가설 : 여자 키 평균은 63인치(160cm)다
# 대립가설 : 여자 키 평균은 63인치(160cm)가 아니다

# R 내장 데이터 사용 (women)
data(women)
head(women)

################################
# 직접 계산
alpha <- 1.96

z <- (mean(women$height) - 63) / (3/sqrt(length(women$height)))
print(z)  # 2.581989

if (abs(z) > 1.96){
  print('귀무가설 기각. 여자 평균 키는 63인치가 아니다')
} else{
  print('귀무가설 채택. 여자 평균 키는 63인치다')
}
# [OUT] "귀무가설 기각. 여자 평균 키는 63인치가 아니다"


################################
# z.test 함수 사용

install.packages('BSDA')
library('BSDA')
z.test(x = women$height,
       alternative = 'two.sided',  # 양측검정
       mu = 63,    # 모집단 평균
       sigma.x = 3,  # 모집단 표준편차
       conf.level = 0.95)  # 신뢰수준


# 단측 검정 (클 조건)
# 귀무가설 : 여자 평균 키는 63인치보다 크다. (귀무가설 기각)
z.test(x = women$height,
       alternative = 'greater',  # 단측 검정 (클 조건)
       mu = 63,    # 모집단 평균
       sigma.x = 3,  # 모집단 표준편차
       conf.level = 0.95)  # 신뢰수준

# 단측 검정 (작을 조건)
# 귀무가설 : 여자 평균 키는 63인치보다 작다. (귀무가설 채택)
z.test(x = women$height,
       alternative = 'less',  # 단측 검정 (작을 조건)
       mu = 63,    # 모집단 평균
       sigma.x = 3,  # 모집단 표준편차
       conf.level = 0.95)  # 신뢰수준
