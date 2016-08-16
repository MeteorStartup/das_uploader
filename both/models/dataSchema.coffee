@dataSchema = (_objName, _addData) ->
  rslt = {}

  # add 될 데이터가 있다면 return 시에 extend 해서 반환한다.

  addData = _addData or {}

  switch _objName
    when 'profile'
      rslt =
        createdAt: new Date()
        이름: ''
        연락처: ''
        성별: ''
        생년월일: ''
        직업: ''
        찾아온경로: ''
        회원등급: '' #일반 / 관리자
        isDeletedAccounts: false
    when 'enrollment'
      rslt =
        createdAt: new Date()
        게시물아이디: ''
        접수상태: '' #대기 / 완료 / 취소
        결제방법: '' #신용카드 / 무통장입금 / 실시간계좌이체
        신청인정보: {
        #신청인 user 정보
        }
        paymentId: ''
    when 'payment'
      rslt =
        createdAt: new Date()
        buyerInfo: {
        #결제자 user 정보
        }
        payInfo: {
        #결제 response
        }
    else
      throw new Error '### Data Schema Not found'

  return _.extend rslt, addData


#payment = {
#  _id:
#  status: '완료 취소 대기'
#  ourInfo: {
#   1.users
##    우리측 정보. 유저_id,
## 결제 정보 중에 결제사에서 알려주지 않는데 우리가 알고 있어야 하는 정보들
#
#  }
#  payInfo: {
##    금액 결제 id .....
#  }
#}