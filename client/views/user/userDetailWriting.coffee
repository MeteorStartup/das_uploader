idCheckFlag = new ReactiveVar()

Router.route 'userDetailWriting'

Template.userDetailWriting.onCreated ->
  idCheckFlag.set false

Template.userDetailWriting.events
  'click [name=btnCancle]': (e, tmpl) ->
    history.back()
  'click [name=btnIdCheck]': (e, tmpl) ->
    e.preventDefault()
    id = $('[name=mgr_id]').val()
    if id.length > 0
      Meteor.call 'idDuplCheck', id, (err, rslt) ->
        if err then alert err; idCheckFlag.set(false); $('[name=mgr_id]').val('');
        else
          alert rslt
          idCheckFlag.set true
    else
      alert '아이디 입력후 중복체크가 가능합니다'
      return
  'click [name=btnSave]': (e, tmpl) ->
    e.preventDefault()
    unless idCheckFlag.get() then alert '아이디 중복체크를 하세요.'; return;

    이름 = $('[name=mgr_nm]').val()
    아이디 = $('[name=mgr_id]').val()
    비밀번호 = $('#tmp_pswd').val()
    이메일 = $('#email1').val()
    휴대폰 = $('#cell_phone3').val()
    사용권한 = $(':radio[name="use_perm"]:checked').val()
    상태 = $(':radio[name="use_yn"]:checked').val()

    if 이름.length <= 0 then alert '이름을 입력하세요'; $('[name=mgr_nm]').focus(); return;
    if 비밀번호.length <= 0 then alert '비밀번호을 입력하세요'; $('#tmp_pswd').focus(); return;
    if 아이디.length <= 0 then alert '아이디를 입력하세요'; $('[name=mgr_id]').focus(); return;

    obj =
      이름: 이름
      아이디: 아이디
      비밀번호: 비밀번호
      이메일: 이메일
      휴대폰: 휴대폰
      사용권한: 사용권한
      상태: 상태

    Meteor.call 'addUser', obj, (err, rslt) ->
      if err then alert err
      else
        alert rslt
        Router.go 'userList'

