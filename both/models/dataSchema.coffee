@dataSchema = (_objName, _addData) ->
  rslt = {}

  # add 될 데이터가 있다면 return 시에 extend 해서 반환한다.

  addData = _addData or {}

  switch _objName
    when 'DASInfo'
      rslt =
        createdAt: new Date()
        Agent명: ''    #agent의 별칭
        Agent_URL: ''   #agent의 URL
        서비스_ID: ''    #파일에서 꺼내진 서비스 ID
        서비스명: ''      #Agent에서 보내는게 아니고 dms methods에서 삽입
        게시판_ID: ''    #파일에서 꺼내진 게시판 ID (현재 불필요)
        REQ_DATE: new Date() #'201608201231000'
        CUR_IP: ''        #10.0.0.24
        DEL_FILE_LIST: []   #'/data/images/1.jpg'
        DEL_DB_URL: ''    #DB삭제 URL
        DEL_DB_QRT: ''    #DB삭제 QUERY
        UP_FSIZE: 0   #num type
        DEL_DATE: new Date() #'2016-08-01' 지우는 날짜는 00:00분으로
        KEEP_PERIOD: 1   #date Number type 일수
        STATUS: 'success'   # success or err_msg / delete error, sql error
    when '용량통계'     #@CollectionSizeInfos 에 업로드 시점 & 처리 시점에 추가
      rslt =
        createdAt: new Date()
        서비스_ID: ''
        업로드용량: 0      #byte Number 이므로 용량이 커지면 Mbyte Gbyte 등으로 변환
        처리용량: 0
#        잔여용량: 0    #업로드용량 - 처리용량
    when '서비스정보'
      rslt =
        createdAt: new Date()
        서비스_ID: ''      #기존 서버에 의해 생성되는 유니크한 ID
        서비스명: ''        #관리자가 입력하는 서비스 구분 별칭
        서비스소개: ''       #서비스 소개
        파일처리옵션: ''    #삭제/사이즈0/백업
        백업파일경로: ''    #파일처리옵션 백업 선택시 경로 e.g. /home/...
        DMS요청정보전송주기: 0 #Legacy에서 생성하는 소멸정보 파일 생성 주기? 생성시 즉시 생성으로 통일. 10/30/60/360... 분단위
        소멸정보요청주기: 0   #확인 후 적당히 처리
        Agent상태전송주기: 1   #1/3/5/10/30 분단위
        상태: true        #사용/사용안함 true / false
        DB정보:       #DB정보 자체가 현재 필요 없음. 일단 UI에 맞춰 만듦
          DB이름: ''      #DB 이름
          DB접속URL: ''   #jdbc:mysql://14.63.225.39:3306/das_demo?characterEncoding=UTF8
          DBMS종류: ''    #MsSQL/MySQL/Oracle
          DB_ID: ''       #ID
          DB_PW: ''       #PW
        Agent정보: []     #등록 갯수만큼 _id만

    when 'Agent정보'
        rslt =
          createdAt: new Date()
          Agent명: ''        #관리자가 입력하는 별칭
          Agent_URL: ''     #http://localhost:3000 에이전트 URL
          파일삭제기능: false    #해당 서비스가 파일소멸시점에 도달하면 본 기능이 true인 agent에 대해서 삭제 명령을 날림
#          파일소멸절대경로: ''   #해당 정보는 기존 서버의 떨군 파일에 존재. 어떤 에이전트(서버)가 파일 서버 인지는 파일삭제기능이 true 인놈들에게 날림.
          소멸정보전송기능: true  #본 옵션이 true인 agent는 해당 소멸정보절대경로를 참조해서 파일을 polling, dms로 전송
          소멸정보절대경로: ''    #ex> /home/das/das_agent_files (맨끝 '/' 삭제)

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