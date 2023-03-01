# 모집단 평균 63
# 유의수준 0.05
# 귀무가설 : 여자 키 평균은 63인치(160cm)다
# 대립가설 : 여자 키 평균은 63인치(160cm)가 아니다

# R 내장 데이터 사용 (women)
data(women)
head(women)

# 직접 계산
length(women$height)  # 15 (자유도 : 14)

t <- (mean(women$height) - 63) / (sd(women$height)/sqrt(length(women$height)))
print(t)   # 1.732051

# t분포표 값 (qt()함수 사용)
tval <- qt(1 - 0.05/2, 14)
print(tval)   # 2.144787

if (abs(t) > tval){
  print('귀무가설 기각. 여자 평균 키는 63인치가 아니다.')
}else{
  print('귀무가설 채택. 여자 평균 키는 63인치다.')
}

# [OUT] "귀무가설 채택. 여자 평균 키는 63인치다."

################################
# t.test 함수 사용
t.test(x = women$height,
       alternative = 'two.sided',   # 양측검정
       mu = 63,             # 모집단 평균
       conf.level = 0.95)   # 신뢰수준
