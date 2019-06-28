open Mpst

let title =
  {obj={make_obj=(fun f -> object method title=f end);
        call_obj=(fun o -> o#title)};
   var=(fun v -> `title(v))}

let quote =
  {obj={make_obj=(fun f -> object method quote=f end);
        call_obj=(fun o -> o#quote)};
   var=(fun v -> `quote(v))}

let quote_by_two =
  {obj={make_obj=(fun f -> object method quote_by_two=f end);
        call_obj=(fun o -> o#quote_by_two)};
   var=(fun v -> `quote_by_two(v))}

let ok =
  {obj={make_obj=(fun f -> object method ok=f end);
        call_obj=(fun o -> o#ok)};
   var=(fun v -> `ok(v))}

let quit =
  {obj={make_obj=(fun f -> object method quit=f end);
        call_obj=(fun o -> o#quit)};
   var=(fun v -> `quit(v))}

let date =
  {obj={make_obj=(fun f -> object method date=f end);
        call_obj=(fun o -> o#date)};
   var=(fun v -> `date(v))}

let ok_or_quit =
  {obj_merge=(fun l r -> object method ok=l#ok method quit=r#quit end);
   obj_splitL=(fun lr -> (lr :> <ok : _>));
   obj_splitR=(fun lr -> (lr :> <quit : _>));
  }

let sum =
  {obj={make_obj=(fun f -> object method sum=f end);
        call_obj=(fun o -> o#sum)};
   var=(fun v -> `sum(v))}

let multiply =
  {obj={make_obj=(fun f -> object method multiply=f end);
        call_obj=(fun o -> o#multiply)};
   var=(fun v -> `multiply(v))}

let result =
  {obj={make_obj=(fun f -> object method result=f end);
        call_obj=(fun o -> o#result)};
   var=(fun v -> `result(v))}

let sum_or_multiply =
  {obj_merge=(fun l r -> object method sum=l#sum method multiply=r#multiply end);
   obj_splitL=(fun lr -> (lr :> <sum : _>));
   obj_splitR=(fun lr -> (lr :> <multiply : _>));
  }

let sum_multiply_or_quit =
  {obj_merge=(fun l r -> object method sum=l#sum method multiply=l#multiply method quit=r#quit end);
   obj_splitL=(fun lr -> (lr :> <sum : _; multiply: _>));
   obj_splitR=(fun lr -> (lr :> <quit : _>));
  }

let fibonacci =
  {obj={make_obj=(fun f -> object method fibonacci=f end);
        call_obj=(fun o -> o#fibonacci)};
   var=(fun v -> `fibonacci(v))}

let stop =
  {obj={make_obj=(fun f -> object method stop=f end);
        call_obj=(fun o -> o#stop)};
   var=(fun v -> `stop(v))}

let fibonacci_or_stop =
  {obj_merge=(fun l r -> object method fibonacci=l#fibonacci method stop=r#stop end);
   obj_splitL=(fun lr -> (lr :> <fibonacci : _>));
   obj_splitR=(fun lr -> (lr :> <stop : _>));
  }

let is_above =
  {obj={make_obj=(fun f -> object method is_above=f end);
        call_obj=(fun o -> o#is_above)};
   var=(fun v -> `is_above(v))}

let res =
  {obj={make_obj=(fun f -> object method res=f end);
        call_obj=(fun o -> o#res)};
   var=(fun v -> `res(v))}

let both_in =
  {obj={make_obj=(fun f -> object method both_in=f end);
        call_obj=(fun o -> o#both_in)};
   var=(fun v -> `both_in(v))}

let both_out =
  {obj={make_obj=(fun f -> object method both_out=f end);
        call_obj=(fun o -> o#both_out)};
   var=(fun v -> `both_out(v))}

let intersect =
  {obj={make_obj=(fun f -> object method intersect=f end);
        call_obj=(fun o -> o#intersect)};
   var=(fun v -> `intersect(v))}

let sec_in =
  {obj={make_obj=(fun f -> object method sec_in=f end);
        call_obj=(fun o -> o#sec_in)};
   var=(fun v -> `sec_in(v))}

let sec_out =
  {obj={make_obj=(fun f -> object method sec_out=f end);
        call_obj=(fun o -> o#sec_out)};
   var=(fun v -> `sec_out(v))}

let close_ =
  {obj={make_obj=(fun f -> object method close=f end);
        call_obj=(fun o -> o#close)};
   var=(fun v -> `close(v))}

let plane =
  {obj={make_obj=(fun f -> object method plane=f end);
        call_obj=(fun o -> o#plane)};
   var=(fun v -> `plane(v))}

let bothin_or_bothout =
  {obj_merge=(fun l r -> object method both_in=l#both_in method both_out=r#both_out end);
   obj_splitL=(fun lr -> (lr :> <both_in : _>));
   obj_splitR=(fun lr -> (lr :> <both_out : _>));
  }

let bothin_bothout_or_intersect =
  {obj_merge=(fun l r -> object method both_in=l#both_in method both_out=l#both_out method intersect=r#intersect end);
   obj_splitL=(fun lr -> (lr :> <both_in : _; both_out: _>));
   obj_splitR=(fun lr -> (lr :> <intersect : _>));
  }

let secout_or_secin =
  {obj_merge=(fun l r -> object method sec_out=l#sec_out method sec_in=r#sec_in end);
   obj_splitL=(fun lr -> (lr :> <sec_out : _>));
   obj_splitR=(fun lr -> (lr :> <sec_in : _>));
  }

let isabove_or_close =
  {obj_merge=(fun l r -> object method is_above=l#is_above method close=r#close end);
   obj_splitL=(fun lr -> (lr :> <is_above : _>));
   obj_splitR=(fun lr -> (lr :> <close : _>));
  }

let propose =
  {obj={make_obj=(fun f -> object method propose=f end);
        call_obj=(fun o -> o#propose)};
   var=(fun v -> `propose(v))}

let accpt =
  {obj={make_obj=(fun f -> object method accpt=f end);
        call_obj=(fun o -> o#accpt)};
   var=(fun v -> `acppt(v))}

let confirm =
  {obj={make_obj=(fun f -> object method confirm=f end);
        call_obj=(fun o -> o#confirm)};
   var=(fun v -> `confirm(v))}

let reject =
  {obj={make_obj=(fun f -> object method reject=f end);
        call_obj=(fun o -> o#reject)};
   var=(fun v -> `reject(v))}

let accpt_reject_or_propose =
  {obj_merge=(fun l r -> object method accpt=l#accpt method reject=l#reject method propose=r#propose end);
   obj_splitL=(fun lr -> (lr :> <accpt : _; reject: _>));
   obj_splitR=(fun lr -> (lr :> <propose : _>));
  }

let accpt_or_reject =
  {obj_merge=(fun l r -> object method accpt=l#accpt method reject=r#reject end);
   obj_splitL=(fun lr -> (lr :> <accpt : _>));
   obj_splitR=(fun lr -> (lr :> <reject : _>));
  }

let authenticate =
  {obj={make_obj=(fun f -> object method authenticate=f end);
        call_obj=(fun o -> o#authenticate)};
   var=(fun v -> `authenticate(v))}

let yes =
  {obj={make_obj=(fun f -> object method yes=f end);
        call_obj=(fun o -> o#yes)};
   var=(fun v -> `yes(v))}

let no =
  {obj={make_obj=(fun f -> object method no=f end);
        call_obj=(fun o -> o#no)};
   var=(fun v -> `no(v))}

let ok_or_reject =
  {obj_merge=(fun l r -> object method ok=l#ok method reject=r#reject end);
   obj_splitL=(fun lr -> (lr :> <ok : _>));
   obj_splitR=(fun lr -> (lr :> <reject : _>));
  }

let yes_or_no =
  {obj_merge=(fun l r -> object method yes=l#yes method no=r#no end);
   obj_splitL=(fun lr -> (lr :> <yes : _>));
   obj_splitR=(fun lr -> (lr :> <no : _>));
  }

let query =
  {obj={make_obj=(fun f -> object method query=f end);
        call_obj=(fun o -> o#query)};
   var=(fun v -> `query(v))}

let quote =
  {obj={make_obj=(fun f -> object method quote=f end);
        call_obj=(fun o -> o#quote)};
   var=(fun v -> `quote(v))}

let dummy =
  {obj={make_obj=(fun f -> object method dummy=f end);
        call_obj=(fun o -> o#dummy)};
   var=(fun v -> `dummy(v))}

let payment =
  {obj={make_obj=(fun f -> object method payment=f end);
        call_obj=(fun o -> o#payment)};
   var=(fun v -> `payment(v))}

let ack =
  {obj={make_obj=(fun f -> object method ack=f end);
        call_obj=(fun o -> o#ack)};
   var=(fun v -> `ack(v))}

let query_or_yes_no =
  {obj_merge=(fun l r -> object method query=l#query method yes=r#yes method no=r#no end);
   obj_splitL=(fun lr -> (lr :> <query : _>));
   obj_splitR=(fun lr -> (lr :> <yes : _; no : _>));
  }

let bye =
  {obj={make_obj=(fun f -> object method bye=f end);
        call_obj=(fun o -> o#bye)};
   var=(fun v -> `bye(v))}

let login =
  {obj={make_obj=(fun f -> object method login=f end);
        call_obj=(fun o -> o#login)};
   var=(fun v -> `login(v))}

let loginfailure =
  {obj={make_obj=(fun f -> object method loginfailure=f end);
        call_obj=(fun o -> o#loginfailure)};
   var=(fun v -> `loginfailure(v))}

let loginsuccess =
  {obj={make_obj=(fun f -> object method loginsuccess=f end);
        call_obj=(fun o -> o#loginsuccess)};
   var=(fun v -> `loginsuccess(v))}

let getsuppliers =
  {obj={make_obj=(fun f -> object method getsuppliers=f end);
        call_obj=(fun o -> o#getsuppliers)};
   var=(fun v -> `getsuppliers(v))}

let getcontracts =
  {obj={make_obj=(fun f -> object method getcontracts=f end);
        call_obj=(fun o -> o#getcontracts)};
   var=(fun v -> `getcontracts(v))}

let deny =
  {obj={make_obj=(fun f -> object method deny=f end);
        call_obj=(fun o -> o#deny)};
   var=(fun v -> `deny(v))}

let getsuppliers =
  {obj={make_obj=(fun f -> object method getsuppliers=f end);
        call_obj=(fun o -> o#getsuppliers)};
   var=(fun v -> `getsuppliers(v))}

let suppliers =
  {obj={make_obj=(fun f -> object method suppliers=f end);
        call_obj=(fun o -> o#suppliers)};
   var=(fun v -> `suppliers(v))}

let getcontracts =
  {obj={make_obj=(fun f -> object method getcontracts=f end);
        call_obj=(fun o -> o#getcontracts)};
   var=(fun v -> `getcontracts(v))}

let contracts =
  {obj={make_obj=(fun f -> object method contracts=f end);
        call_obj=(fun o -> o#contracts)};
   var=(fun v -> `contracts(v))}

let filtered =
  {obj={make_obj=(fun f -> object method filtered=f end);
        call_obj=(fun o -> o#filtered)};
   var=(fun v -> `filtered(v))}

let getsuppliers_or_getcontracts =
  {obj_merge=(fun l r -> object method getsuppliers=l#getsuppliers method getcontracts=r#getcontracts end);
   obj_splitL=(fun lr -> (lr :> <getsuppliers : _>));
   obj_splitR=(fun lr -> (lr :> <getcontracts : _>));
  }

let loginfailure_or_loginsuccess =
  {obj_merge=(fun l r -> object method loginfailure=l#loginfailure method loginsuccess=r#loginsuccess end);
   obj_splitL=(fun lr -> (lr :> <loginfailure : _>));
   obj_splitR=(fun lr -> (lr :> <loginsuccess : _>));
  }

let ehlo =
  {obj={make_obj=(fun f -> object method ehlo=f end);
        call_obj=(fun o -> o#ehlo)};
   var=(fun v -> `ehlo(v))}

let quit =
  {obj={make_obj=(fun f -> object method quit=f end);
        call_obj=(fun o -> o#quit)};
   var=(fun v -> `quit(v))}

let starttls =
  {obj={make_obj=(fun f -> object method starttls=f end);
        call_obj=(fun o -> o#starttls)};
   var=(fun v -> `starttls(v))}

let auth =
  {obj={make_obj=(fun f -> object method auth=f end);
        call_obj=(fun o -> o#auth)};
   var=(fun v -> `auth(v))}

let mail =
  {obj={make_obj=(fun f -> object method mail=f end);
        call_obj=(fun o -> o#mail)};
   var=(fun v -> `mail(v))}

let rcpt =
  {obj={make_obj=(fun f -> object method rcpt=f end);
        call_obj=(fun o -> o#rcpt)};
   var=(fun v -> `rcpt(v))}

let data =
  {obj={make_obj=(fun f -> object method data=f end);
        call_obj=(fun o -> o#data)};
   var=(fun v -> `data(v))}

let _220 =
  {obj={make_obj=(fun f -> object method _220=f end);
        call_obj=(fun o -> o#_220)};
   var=(fun v -> `_220(v))}

let _235 =
  {obj={make_obj=(fun f -> object method _235=f end);
        call_obj=(fun o -> o#_235)};
   var=(fun v -> `_235(v))}

let _250 =
  {obj={make_obj=(fun f -> object method _250=f end);
        call_obj=(fun o -> o#_250)};
   var=(fun v -> `_250(v))}

let _250d =
  {obj={make_obj=(fun f -> object method _250d=f end);
        call_obj=(fun o -> o#_250d)};
   var=(fun v -> `_250d(v))}

let _354 =
  {obj={make_obj=(fun f -> object method _354=f end);
        call_obj=(fun o -> o#_354)};
   var=(fun v -> `_354(v))}

let _501 =
  {obj={make_obj=(fun f -> object method _501=f end);
        call_obj=(fun o -> o#_501)};
   var=(fun v -> `_501(v))}

let _535 =
  {obj={make_obj=(fun f -> object method _535=f end);
        call_obj=(fun o -> o#_535)};
   var=(fun v -> `_535(v))}

let mailbody =
  {obj={make_obj=(fun f -> object method mailbody=f end);
        call_obj=(fun o -> o#mailbody)};
   var=(fun v -> `mailbody(v))}

let starttls_or_quit =
  {obj_merge=(fun l r -> object method starttls=l#starttls method quit=r#quit end);
   obj_splitL=(fun lr -> (lr :> <starttls : _>));
   obj_splitR=(fun lr -> (lr :> <quit : _>));
  }

let ehlo_or_quit =
  {obj_merge=(fun l r -> object method ehlo=l#ehlo method quit=r#quit end);
   obj_splitL=(fun lr -> (lr :> <ehlo : _>));
   obj_splitR=(fun lr -> (lr :> <quit : _>));
  }

let mail_or_quit =
  {obj_merge=(fun l r -> object method mail=l#mail method quit=r#quit end);
   obj_splitL=(fun lr -> (lr :> <mail : _>));
   obj_splitR=(fun lr -> (lr :> <quit : _>));
  }

let _501_or_250 =
  {obj_merge=(fun l r -> object method _501=l#_501 method _250=r#_250 end);
   obj_splitL=(fun lr -> (lr :> <_501 : _>));
   obj_splitR=(fun lr -> (lr :> <_250 : _>));
  }

let rcpt_or_data =
  {obj_merge=(fun l r -> object method rcpt=l#rcpt method data=r#data end);
   obj_splitL=(fun lr -> (lr :> <rcpt : _>));
   obj_splitR=(fun lr -> (lr :> <data : _>));
  }

let auth_or_quit =
  {obj_merge=(fun l r -> object method auth=l#auth method quit=r#quit end);
   obj_splitL=(fun lr -> (lr :> <auth : _>));
   obj_splitR=(fun lr -> (lr :> <quit : _>));
  }

let _235_or_535 =
  {obj_merge=(fun l r -> object method _235=l#_235 method _535=r#_535 end);
   obj_splitL=(fun lr -> (lr :> <_235 : _>));
   obj_splitR=(fun lr -> (lr :> <_535 : _>));
  }

let _250d_or_250 =
  {obj_merge=(fun l r -> object method _250d=l#_250d method _250=r#_250 end);
   obj_splitL=(fun lr -> (lr :> <_250d : _>));
   obj_splitR=(fun lr -> (lr :> <_250 : _>));
  }

let _250d_250_or_220 =
  {obj_merge=(fun l r -> object method _250d=l#_250d method _250=l#_250 method _220=r#_220 end);
   obj_splitL=(fun lr -> (lr :> <_250d : _; _250 : _>));
   obj_splitR=(fun lr -> (lr :> <_220 : _>));
  }

let full =
  {obj={make_obj=(fun f -> object method full=f end);
        call_obj=(fun o -> o#full)};
   var=(fun v -> `full(v))}

let seat =
  {obj={make_obj=(fun f -> object method seat=f end);
        call_obj=(fun o -> o#seat)};
   var=(fun v -> `seat(v))}

let available =
  {obj={make_obj=(fun f -> object method available=f end);
        call_obj=(fun o -> o#available)};
   var=(fun v -> `available(v))}

let ready =
  {obj={make_obj=(fun f -> object method ready=f end);
        call_obj=(fun o -> o#ready)};
   var=(fun v -> `ready(v))}

let descr =
  {obj={make_obj=(fun f -> object method descr=f end);
        call_obj=(fun o -> o#descr)};
   var=(fun v -> `descr(v))}

let haircut =
  {obj={make_obj=(fun f -> object method haircut=f end);
        call_obj=(fun o -> o#haircut)};
   var=(fun v -> `haircut(v))}

let pay =
  {obj={make_obj=(fun f -> object method pay=f end);
        call_obj=(fun o -> o#pay)};
   var=(fun v -> `pay(v))}

let full_or_seat =
  {obj_merge=(fun l r -> object method full=l#full method seat=r#seat end);
   obj_splitL=(fun lr -> (lr :> <full : _>));
   obj_splitR=(fun lr -> (lr :> <seat : _>));
  }

let deleg_customer =
  {obj={make_obj=(fun f -> object method deleg_customer=f end);
        call_obj=(fun o -> o#deleg_customer)};
   var=(fun v -> `deleg_customer(v))}

let start_smoking =
  {obj={make_obj=(fun f -> object method start_smoking=f end);
        call_obj=(fun o -> o#start_smoking)};
   var=(fun v -> `start_smoking(v))}

let exit =
  {obj={make_obj=(fun f -> object method exit=f end);
        call_obj=(fun o -> o#exit)};
   var=(fun v -> `exit(v))}

let started_smoking =
  {obj={make_obj=(fun f -> object method started_smoking=f end);
        call_obj=(fun o -> o#started_smoking)};
   var=(fun v -> `started_smoking(v))}

let start_smoking_or_exit =
  {obj_merge=(fun l r -> object method start_smoking=l#start_smoking method exit=r#exit end);
   obj_splitL=(fun lr -> (lr :> <start_smoking : _>));
   obj_splitR=(fun lr -> (lr :> <exit : _>));
  }

let playAsA =
  {obj={make_obj=(fun f -> object method playAsA=f end);
        call_obj=(fun o -> o#playAsA)};
   var=(fun v -> `playAsA(v))}

let playAsB =
  {obj={make_obj=(fun f -> object method playAsB=f end);
        call_obj=(fun o -> o#playAsB)};
   var=(fun v -> `playAsB(v))}

let playAsC =
  {obj={make_obj=(fun f -> object method playAsC=f end);
        call_obj=(fun o -> o#playAsC)};
   var=(fun v -> `playAsC(v))}

let playAsA_playAsB_or_playAsC =
  {obj_merge=(fun l r -> object method playAsA=l#playAsA method playAsB=l#playAsB method playAsC=r#playAsC end);
   obj_splitL=(fun lr -> (lr :> <playAsA : _; playAsB : _>));
   obj_splitR=(fun lr -> (lr :> <playAsC : _>));
  }

let playAsA_or_playAsB =
  {obj_merge=(fun l r -> object method playAsA=l#playAsA method playAsB=r#playAsB end);
   obj_splitL=(fun lr -> (lr :> <playAsA : _;>));
   obj_splitR=(fun lr -> (lr :> <playAsB : _>));
  }

let map =
  {obj={make_obj=(fun f -> object method map=f end);
        call_obj=(fun o -> o#map)};
   var=(fun v -> `map(v))}

let work =
  {obj={make_obj=(fun f -> object method work=f end);
        call_obj=(fun o -> o#work)};
   var=(fun v -> `work(v))}

let result =
  {obj={make_obj=(fun f -> object method result=f end);
        call_obj=(fun o -> o#result)};
   var=(fun v -> `result(v))}

let done_ =
  {obj={make_obj=(fun f -> object method done_=f end);
        call_obj=(fun o -> o#done_)};
   var=(fun v -> `done_(v))}

let work_or_stop =
  {obj_merge=(fun l r -> object method work=l#work method stop=r#stop end);
   obj_splitL=(fun lr -> (lr :> <work : _;>));
   obj_splitR=(fun lr -> (lr :> <stop : _>));
  }

let result_or_done =
  {obj_merge=(fun l r -> object method result=l#result method done_=r#done_ end);
   obj_splitL=(fun lr -> (lr :> <result : _;>));
   obj_splitR=(fun lr -> (lr :> <done_ : _>));
  }

let knock =
  {obj={make_obj=(fun f -> object method knock=f end);
        call_obj=(fun o -> o#knock)};
   var=(fun v -> `knock(v))}

let deliver =
  {obj={make_obj=(fun f -> object method deliver=f end);
        call_obj=(fun o -> o#deliver)};
   var=(fun v -> `deliver(v))}

let maketoy =
  {obj={make_obj=(fun f -> object method maketoy=f end);
        call_obj=(fun o -> o#maketoy)};
   var=(fun v -> `maketoy(v))}

let start =
  {obj={make_obj=(fun f -> object method start=f end);
        call_obj=(fun o -> o#start)};
   var=(fun v -> `start(v))}