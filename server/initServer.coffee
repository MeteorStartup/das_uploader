cl = console.log
#  admin 등 기본 셋팅이 들어가야 한다

#  reset 시 테스트 환경을 위한 데이터
unless CollectionServices.findOne()
  svcInfo = dataSchema '서비스정보'
  svcInfo.서비스명 = 'das서비스'
  svcInfo.파일처리옵션 = '삭제'
  서비스정보_id = CollectionServices.insert svcInfo

  agent = dataSchema 'Agent정보'
  agent.서비스정보_id = 서비스정보_id
  agent.Agent명 = 'dasAgent'
  agent.Agent_URL = 'http://localhost:3000'
  agent.소멸정보절대경로 = '/Users/jwjin/data'
  CollectionAgents.insert agent

